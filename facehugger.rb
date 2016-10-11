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
    YAML.load(fp.read)

	#files.each_pair { |key,val|
		#puts key
		#puts val
		#if File.exists?(val["configfile"]) then
			#puts "#{val} exists"
		#end
#
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
    option :dest, :required=>false
	def collect()
		#Read config
		files = read_config

		#Check if files exist
		list = []
		files.each_pair { |f,c|
			c.each_pair { |key, val|
				case key
				when 'configfile'
					unless File.exists? val then
						puts "#{val} does not exist."
					else
						list.push val
					end
				when 'configdir'
					unless File.exists? val then
						puts "#{val} does not exist."
					else
						list.push val
					end
				when 'command'
					puts "command: " + val
				else
					'invalid key'
				end
			}
		}

		#Determine output location
		if options[:dest] then 
			location = Files.join(Configdir, "config_egg.tar.gz")
		else
			location = "config_egg.tar.gz"
		end

		#Write tar file
		puts "tar -czf #{location} #{list.join(' ')}"
		`tar -czf #{location} #{list.join(' ')}`

		#Until I can figue out how to tar a directory
		#File.open(location,"wb") { |file|
			#Zlib::GzipWriter.wrap(file) { |gz|
				#Gem::Package::TarWriter.new(gz) { |tar|
					#list.each { |f|
						#File.open(f,'r') { |fp|
							#tar.add_file(Pathname.new(f),0444) { |io|
								#io.write(fp.read)
							#}
						#}
					#}
				#}
			#}
		#}
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
