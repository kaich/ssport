require "colorize"
require "json"

class Config
     
    @@SERVER_PORT = "server_port"
    @@PASSWORD = "password"
    @@METHOD = "method"

    def initialize(options)
        @options = options
        @config_file = options[:config]
    end

    def create 
       defualt_config = {
        "server": @options[:server] || "my_server_ip",
        "server_port": 8388,
        "local_address":"127.0.0.1",
        "local_port": 1080,
        "password": "123456",
        "timeout": 300,
        "method": "rc4-md5"
        }
        File.write '/etc/shadowsocks.json' , defualt_config 

        parseConfig
        applyChange
    end

    def update
        if !@config_file 
            raise "config file not set"
        end 
        parseConfig
        applyChange
    end

    def parseConfig
        puts "---------Bengin Deal #{@config_file} ------------".colorize(:yellow)
        if File.exist? @config_file 
            file_content = File.read @config_file
            @config_json = JSON.parse file_content
            puts "-------------Old Config---------------".colorize(:yellow)
            puts JSON.pretty_generate(@config_json)
        else 
            puts "Config 文件不存在".colorize(:red)
        end
    end

    def changeField(config_key, option_key)
        option_value = @options[option_key]
        if option_value 
            @config_json[config_key] = option_value
        end
    end
    
    def applyChange
        changeField @@SERVER_PORT , :port
        changeField @@PASSWORD , :password
        changeField @@METHOD , :method
        final_config = JSON.pretty_generate(@config_json)
        puts "-------------New Config---------------".colorize(:yellow)
        puts final_config
        File.write @config_file , final_config 
    end

    
end