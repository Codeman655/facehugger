#!/usr/bin/env ruby
require 'yaml'
require 'rubygems/package'
require 'thor'
require 'pathname'
require 'fileutils'

#default config
Configdir = Pathname.new(File.join(ENV["HOME"],".config", "facehugger"))
Config = Pathname.new(File.join(Configdir, "facehugger.yml"))

def read_config
    #puts join("templates", "example.html")
    fp = open(Config,'r')
    files = YAML.load(fp.read)
    puts files

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

    #Credit: http://weblog.jamisbuck.org/2015/7/23/tar-gz-in-ruby.html
    desc "collect", "tar all config files into a collection"
    option :dest
    def collect(opt)
        #Read config
        files = self.read_config

        #Check if files exist
        files.each { |f|
            if File.exists? f then
                puts "#{f} does not exist."
                exit
            end
        }

        #Check if tar( or tar libraries) are available
        #tar files 
        puts "tar -czf #{Configdir}/config_egg.tar.gz #{files}"
    end

    desc "alien", "prints an alien"
    def alien()
        puts File.read('alien.txt')
    end

    desc "init", "create a blank config file for facehugger"
    def init()
        unless File.exists? Configdir 
            FileUtils::mkdir_p Configdir
        end

        if File.exists? Config then
            puts "config file already exists at #{Config}"
        else
            puts "Creating config file in #{Config}"
            fp = File.open(Config,'w')
            bash_sample = File.join(ENV["HOME"], ".bashrc")
            output={"bash"=>{"configfile"=>"#{bash_sample}"}}
            fp.puts(YAML.dump(output))
            fp.close
        end
    end
end

Facehugger.start(ARGV)
