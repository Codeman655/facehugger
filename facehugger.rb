#!/usr/bin/env ruby
require 'yaml'
#require 'thor'
require 'pathname'

class Facehugger < Thor
    #default config
    config = Pathname.new(File.join(ENV["HOME"],".config", "facehugger", "facehugger.yml"))
    def read_config
        #puts join("templates", "example.html")
        fp = open(config,'r')
        files = YAML.load(fp.read)
        #puts files

        #files.each_pair { |key,val|
        #    puts key
        #    puts val
        #    if File.exists?(val["configfile"]) then
        #        puts "#{val} exists"
        #    end
        #puts f["configfile"]
        #puts f[1]['configfile']
        #if File.exists? f[:configfile] then
        #puts f[:configfile]
        #end
        #}
    end

    desc "inject", "performs a secure copy (scp) to the target"
    def inject(host)
        puts "injecting the following files to the targeted host"
    end

    desc "collect", "tar all config files into a collection"
    option :dest
    def collect(opt)
        #Read config
        files = self.read_config
        #tar files 
    end
end
