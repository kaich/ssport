require "ssport/version"
require "ssport/config"
require "colorize"
require 'fileutils'
require 'optparse'
require 'json'
require 'net/ssh'

module Ssport

  def self.run 

    options = {}
    options[:config] = "shadowsocks.json"
    OptionParser.new do |opts|
      opts.banner = "Usage: change shadowsocket port"

      opts.on("-S", "--server host", "ssh server host") do |v|
        options[:server] = v
      end

      opts.on("-U", "--username username", "ssh server username") do |v|
        options[:username] = v
      end

      opts.on("-P", "--pass password", "ssh server password") do |v|
        options[:pass] = v
      end

      opts.on("-b", "--bind port", "shadowsocket server bind port") do |v|
        options[:port] = v 
      end

      opts.on("-p", "--password password",Array,"shadowsocket password") do |v|
        options[:password] = v 
      end

      opts.on("-m", "--method method",Array,"shadowsocket encry method") do |v|
        options[:method] = v 
      end

      opts.on("-c", "--config filepath",Array,"shadowsocket config file path") do |v|
        options[:config] = v 
      end

    end.parse!

    if options[:server] 
      ssh options
    end

    config = Config(options)
    config.run

  end

  def self.ssh(options) 

    Net::SSH.start(options[:server], options[:username], :password => options[:pass]) do |ssh|
      # capture all stderr and stdout output from a remote process
      parameter = %Q{
      if ! [ -x "$(command -v ssport)" ]; then
        gem install ssport
      if
      ssport -b #{options[:port]}
      }
      output = ssh.exec!("~/bin/command '#{parameter}'")

    end

    puts output
  end

end
