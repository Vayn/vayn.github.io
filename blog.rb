#!/usr/bin/env ruby
# coding: utf-8
#Author: Roy L Zuo (roylzuo at gmail dot com)
#Description: 
require 'rubygems'
require 'sinatra'

set :public, File.dirname(__FILE__)
 
# This before filter ensures that your pages are only ever served
# once (per deploy) by Sinatra, and then by Varnish after that
# before do
  # response.headers['Cache-Control'] = 'public, max-age=3600' # 1 year
# end
before do
  response.headers['Cache-Control'] = 'no-cache'
end
 
get '/' do
    File.read('index.html')
end

get '/*' do
    File.read(params['splat'].first)
end
