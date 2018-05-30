require "ssport/version"
require "ssport/config"
require "ssport/profile"
require "colorize"
require 'fileutils'
require 'optparse'
require 'net/ssh'
require 'json'

module Ssport

  def self.run 

    options = {}
    options[:config] = "shadowsocks.json"
    OptionParser.new do |opts|
      opts.banner = "Usage: change shadowsocket port"

      opts.on("-S", "--server host", "ssh server host") do |v|
        options[:server] = v
      end

      opts.on("-A", "--server aliasName", "ssh server alia name, eg: ssport -a ramnode -b 724") do |v|
        options[:alias] = v
      end

      opts.on("-l", "--list", "list available server alia name") do |v|
        options[:list] = true
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

      opts.on("-p", "--password password","shadowsocket password") do |v|
        options[:password] = v 
      end

      opts.on("-m", "--method method","shadowsocket encry method") do |v|
        options[:method] = v 
      end

      opts.on("-c", "--config filepath","shadowsocket config file path") do |v|
        options[:config] = v 
      end

    end.parse!

    alias_name = options[:alias]
    if alias_name 
      profile = Profile.new(options) 
      rc = profile.dealrc
      if rc
        server = options[:server]
        rc_server = rc[:server]
        if !server && rc_server 
          options[:server] = rc_server 
        end
        username = options[:username]
        rc_username = rc[:username]
        if !username && rc_username 
          options[:username] = rc_username 
        end
        pass = options[:pass]
        rc_pass = rc[:pass]
        if !pass && rc_pass 
          options[:pass] = rc_pass 
        end
      end
    end

    if options[:server] 
      ssh options
    elsif options[:config]
      config = Config.new(options)
      config.run
    end

  end


  def self.ssh(options) 
    puts '----------------Begin Connect---------------'.colorize(:yellow)

    output = ""

    Net::SSH.start(options[:server], options[:username], :password => options[:pass]) do |ssh|
      # capture all stderr and stdout output from a remote process
      script = %Q{
      if ! [ -x "$(command -v ssport)" ]; then
        gem install ssport
      fi
      ssport -b #{options[:port]} -c #{options[:config]}
      ssserver -c #{options[:config]} -d start
      }
      output = ssh.exec!(script)
    end

    puts '----------------Remote---------------'.colorize(:yellow)
    puts output
    puts '------------------End------------------'.colorize(:yellow)

  end

end
