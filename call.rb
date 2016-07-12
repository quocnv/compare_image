# include gem to Gemfile
# gem "mini_magick"
# gem 'chunky_png', '~> 1.3', '>= 1.3.6'


require 'chunky_png'
include ImageCompare
include ChunkyPNG::Color

puts "====DATA COMPARE===="
img1 = "http://www.codeproject.com/KB/GDI-plus/ImageProcessing2/img.jpg"
img2 = "http://www.codeproject.com/KB/GDI-plus/ImageProcessing2/greenfilter.jpg"
result = compare_img(img1, img2)
puts result
