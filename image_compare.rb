module ImageCompare
  extend ActiveSupport::Concern
  require 'chunky_png'
  include ChunkyPNG::Color
  def convert_img_to_png(url)
    img = MiniMagick::Image.open(url)
    img.format "PNG"
    file_name = "#{Rails.root}/tmp/#{SecureRandom.hex(10)}.png"
    img.write(file_name)
    return file_name
  end

  def compare_img(img_url1, img_url2)
    img_url1 = convert_img_to_png(img_url1)
    img_url2 = convert_img_to_png(img_url2)
    images = [
      ChunkyPNG::Image.from_file(img_url1),
      ChunkyPNG::Image.from_file(img_url2)
    ]
    # output = ChunkyPNG::Image.new(images.first.width, images.last.width, WHITE)
    diff = []
    images.first.height.times do |y|
      images.first.row(y).each_with_index do |pixel, x|
        unless pixel == images.last[x,y]
          score = Math.sqrt((r(images.last[x,y]) - r(pixel)) ** 2 + (g(images.last[x,y]) - g(pixel)) ** 2 + (b(images.last[x,y]) - b(pixel)) ** 2) / Math.sqrt(MAX ** 2 * 3)
          # output[x,y] = grayscale(MAX - (score * MAX).round)
          diff << score
        end
      end
    end
    File.delete(img_url1) if File.exist?(img_url1)
    File.delete(img_url2) if File.exist?(img_url2)

    total_diff = 0
    total_diff = ((diff.inject{|sum, value| sum + value})/images.first.pixels.length) * 100 if diff.size > 0
    result = {
      pixel_change: diff.length,
      image_change_percent: total_diff
    }
  end
end
