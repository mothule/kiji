require 'rubygems'
require 'bundler/setup'
require 'imgkit'
require 'erb'
require 'optparse'

opt = OptionParser.new
params = {}
opt.on('-w [val]', '--width [val]') {|v| params[:width] = v }
opt.on('-h [val]', '--height [val]') {|v| params[:height] = v }
opt.on('-l val', '--label val') {|v| params[:title] = v }
opt.on('-o [val]', '--out [val]') {|v| params[:out] = v }
opt.on('-t [val]', '--template [val]') {|v| params[:template] = v }
opt.parse(ARGV)

width = params[:width] || 1200
height = params[:height] || 628
title = params[:title]
out_name = params[:out] || 'hoge.png'
template_path = params[:template] || './template.html.erb'

begin
  raise ArgumentError.new('width type must be integer') unless width.to_s =~ /\A[1-9][0-9]*\z/
  raise ArgumentError.new('height type must be integer') unless height.to_s =~ /\A[1-9][0-9]*\z/
  raise ArgumentError.new('label option must be specified') if title.nil?
  raise ArgumentError.new('template file not found') unless File.exist?(template_path)

  erb = File.read(template_path)
  html = ERB.new(erb).result(binding)
  kit = IMGKit.new(html, {width: width, height: height})
  kit.to_file(out_name)

  raise StandardError.new('Failed image generation') unless File.exist?(out_name)

rescue => e
  puts e
  exit 1
end

puts 'Image generation succeeded.'
puts "Image file path: #{ File.absolute_path(out_name) }"
exit 0
