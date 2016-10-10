#!/usr/bin/env ruby
require 'yaml'
require 'thor'
require 'pathname'

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

class Facehugger < Thor
    desc "inject", "performs a secure copy (scp) to the target"
    def inject(host)
        puts "injecting the following files to the targeted host"
    end

    desc "collect", "tar all config files into a collection"
    option :dest
    def collect(opt)
        #Read config
        files = self.read_config

        #Check if tar( or tar libraries) are available
        #tar files 
        puts "tar -czf config_egg.tar.gz #{files}"
    end

    desc "alien", "prints a little image"
    def alien()
        puts File.read('/Users/chricrai/Documents/Code/facehugger/alien.txt')
    end

    desc "init", "create a blank config file for facehugger"
    def init()
        if File.exists? config then
            puts "config file already exists at #{config}"
        else
            puts "Creating config file in #{config}"
            fp = File.open(config,'w')
            bash_sample = File.join(ENV[HOME], ".bashrc")
            fp.write('---'\
                     'bash:'\
                     '  configfile: "#{bash_sample}"')
            fp.close
        end
    end
end

Facehugger.start(ARGV)
