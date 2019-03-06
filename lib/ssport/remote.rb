require 'json'
require 'colorize'
require 'net/ssh'
require 'ssport/version'

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
                if @options[key] == true
                    command += " --#{key} "
                else
                    if key == :port
                        command += " -b #{@options[key]}"
                    else 
                        command += " --#{key} #{@options[key]}"
                    end
                end
            end
        end
        return command
    end

    def genScript
        command = genCommand [:password , :method, :port, :config, :install]
        script = %Q{
          if ! [ -x "$(command -v ssport)" ]; then
            if ! [ -x "$(command -v ruby)" ]; then
                gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
                curl -sSL https://get.rvm.io | bash -s stable --ruby
            fi
            gem install ssport
          else 
            if [ `ssport -v` != "#{Ssport::VERSION}" ]; then 
                gem update ssport
            fi
          fi
          #{command}
          ssserver -c #{@options[:config]} -d restart
          }
        script
    end
    
    def ssh
        if !check?([:server, :username, :pass, :config])
          return 
        end
    
        puts "Begin Connect #{@options[:server]}...".colorize(:yellow)
    
        output = ""
        script = genScript

        server = @options[:server]
        port = nil
        if server.include?(":") 
          server, port = server.split(":")
        end 
        params = {:password => @options[:pass]}
        if port 
          params[:port] = port
        end
    
        Net::SSH.start(server, @options[:username], params) do |ssh|
          # capture all stderr and stdout output from a remote process
          output = ssh.exec!(script)
        end
    
        puts '----------------Remote---------------'.colorize(:yellow)
        puts output
        puts '------------------End------------------'.colorize(:yellow)
    
    end

end