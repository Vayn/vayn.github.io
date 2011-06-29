require 'rack/jekyll'

run Rack::Jekyll.new(:destination => 'jisedai')
