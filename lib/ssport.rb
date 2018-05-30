require "ssport/version"
require "ssport/config"
require "ssport/profile"
require "ssport/remote"
require "colorize"
require 'fileutils'
require 'optparse'
require 'json'

module Ssport

  def self.run 

    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: change shadowsocket port"

      opts.on("-S", "--server host", "ssh server host") do |v|
        options[:server] = v
      end

      opts.on("-A", "--server aliasName", "ssh server alia name, eg: ssport -a ramnode -b 724") do |v|
        options[:alias] = v
      end

      opts.on("-L", "--list", "list available server alia name") do |v|
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

      opts.on("-v", "--version","ssport version") do |v|
        options[:version] = true 
      end

    end.parse!

    if options[:version] 
      puts Ssport::VERSION
      return 
    end

    if options[:list] 
      profile = Profile.new(options) 
      profile.list 
      return 
    end

    alias_name = options[:alias]
    if alias_name 
      profile = Profile.new(options) 
      rc = profile.dealrc
      if rc
        changeOption options, rc, :server
        changeOption options, rc, :username
        changeOption options, rc, :pass
        changeOption options, rc, :config
      end
    end

    if options[:server] 
      remote = Remote.new(options)
      remote.ssh
    elsif options[:config]
      config = Config.new(options)
      config.run
    end

  end

  def self.changeOption(options, rc, key) 
    opt_value = options[key]
    rc_value = rc[key]
    if !opt_value && rc_value 
      options[key] = rc_value 
    end
  end

end
