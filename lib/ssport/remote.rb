require 'json'
require 'colorize'
require 'net/ssh'

class Remote
    
    def initialize(options)
        @options = options
    end
    
    def check?(keys) 
        keys.each do |key| 
          if !@options[key]
            puts "#! Please set :server".colorize(:red)
            return false
          end
        end
        return true
    end

    def genCommand(keys) 
        command = "ssport -c #{@options[:config]}"
        keys.each do |key|
            if @options[key] 
                command += " --#{key} #{@options[key]}"
            end
        end
        return command
    end

    def genScript
        command = genCommand [:password , :method, :port]
        script = %Q{
          if ! [ -x "$(command -v ssport)" ]; then
            gem install ssport
          fi
          #{command}
          ssserver -c #{@options[:config]} -d start
          }
        script
    end
    
    def ssh
        if !check?(@options, [:server, :username, :pass, :config] 
          return 
        end
    
        puts '----------------Begin Connect---------------'.colorize(:yellow)
    
        output = ""
        script = genScript
    
        Net::SSH.start(@options[:server], @options[:username], :password => @options[:pass]) do |ssh|
          # capture all stderr and stdout output from a remote process
          output = ssh.exec!(script)
        end
    
        puts '----------------Remote---------------'.colorize(:yellow)
        puts output
        puts '------------------End------------------'.colorize(:yellow)
    
    end

end