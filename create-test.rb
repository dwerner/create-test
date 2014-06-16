#!/usr/bin/env ruby

require 'optparse'
require 'net/http'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: "+ File.basename(__FILE__) +" [options]"
  opts.on('-n', '--name NAME', 
          'Test name') { |name| options[:name] = name }
  opts.on('-l', '--language LANGUAGE', 
          'Target language for generated test') { |lang| options[:lang] = lang }
  opts.on('-m', '--makefile MAKEFILE', 
          'Optional makefile') { |mk| options[:makefile] = mk }
  opts.on('-t', '--template TEMPLATE', 
          'Optional explicit template') { |tmpl| options[:template] = tmpl }
end.parse!

raise("Specify a test name.") unless options.has_key?(:name) 
raise("Specify a target language template.") unless options.has_key?(:lang) 

class TestCreator 
  def initialize(name, language, makefile, template)
    @name = name
    @language = language
    @makefile = makefile
    @template = template
  end
  def create_source!
    puts "- Creating test " + @name 
    puts "- with language " + @language 
    puts "- and makefile " + @makefile unless @makefile == nil
    puts "- and template " + @template unless @template == nil
    self.fetch_template! unless @template == nil
  end
  def fetch_template!
    Net::HTTP.start("https://www.github.com") do |http|
      resp = http.get("/dwerner/scratchpad.git")
      puts resp.body
    end
  end
end

TestCreator.new(
  options[:name], 
  options[:lang], 
  options[:makefile],
  options[:template]
).create_source!

