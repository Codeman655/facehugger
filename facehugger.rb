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

def r_tar(dir_path, tarfile)
    #relative_file = cf.sub /^#{Regexp::escape path}\/?/, ''

    # If configure file is a dir, tar everything underneath
    puts "Tarring dir #{dir_path}"
    Dir[File.join(dir_path, "**/*")].each do |subfile|
        if File.directory?(subfile)
            r_tar(subfile, tarfile)
        else
            mode = File.stat(subfile).mode
            size = File.stat(subfile).size
            tarfile.add_file_simple(subfile, mode, size) do |tf|
                File.open(subfile, "rb") { |f| tf.write f.read }
            end
        end
    end
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
            unless c.is_a? Hash
                next 
            end
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
            output_location = Files.join(Configdir, "config_egg.tar.gz")
        else
            output_location = "config_egg.tar.gz"
        end

        #Write tar file
        #puts "tar -czf #{output_location} #{list.join(' ')}"
        #`tar -czf #{output_location} #{list.join(' ')}`

        #Until I can figue out how to tar a directory
        File.open(output_location,"wb") { |output_file|
            Zlib::GzipWriter.wrap(output_file) { |gz|
                Gem::Package::TarWriter.new(gz) { |tar|
                    #For each member in the config
                    list.each { |cf|
                        mode = File.stat(cf).mode
                        size = File.stat(cf).size
                        #relative_file = cf.sub /^#{Regexp::escape path}\/?/, ''

                        # If configure file is a dir, tar everything underneath
                        if File.directory? cf 
                            r_tar(cf,tar)
                        else 
                            puts "Tarring file #{cf}"
                            tar.add_file_simple(cf, mode,size) do |tf|
								File.open(cf, "rb") { |f| tf.write f.read }
                            end
                        end
                    }
                }
            }
        }
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
