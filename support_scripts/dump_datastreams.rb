#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../config/environment"

pid = ARGV[0]
result =  ActiveFedora::Base.find(pid)
result.datastreams.each do |key, datastream|
  puts "--- #{key} ---------------------------------"
  puts "mimeType: #{datastream.mimeType}"
  if datastream.respond_to?(:to_rels_ext)
    puts datastream.to_rels_ext
  elsif datastream.respond_to?(:to_xml)
    puts datastream.to_xml
  elsif datastream.respond_to?(:url)
    puts datastream.url
  end
  puts "\n\n"
end
