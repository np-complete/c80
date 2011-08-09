#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'
include Magick
Dir.glob("#{ENV['HOME']}/Dropbox/picture/{ritsu,azusa,mugi}_*.png").each do |file|
  image = ImageList.new(file).resize(160, 160).quantize(16, GRAYColorspace).write(File.join("images", File.basename(file)))
end
