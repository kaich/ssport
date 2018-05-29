class Config
     
    @@SERVER_PORT = "server_port"
    @@PASSWORD = "password"
    @@METHOD = "method"

    def initialize(options)
        @options = options
        @config_file = options[:config]
    end

    def run
        if !@config_file 
            raise "config file not set"
        end 
        parseConfig
        applyChange
    end

    def parseConfig
        if File.exist? @config_file 
            file_content = File.read @config_file
            @config_json = JSON.parse file_content
        else 
            p "Config 文件不存在".colorize(:red)
        end
    end

    def changeField(config_key, option_key)
        option_value = @options[option_key]
        if option_value 
            @config_json[config_key] = option_value
        end
    end
    
    def applyChange(config_json)
        changeField @@SERVER_PORT , :port
        changeField @@PASSWORD , :password
        changeField @@METHOD , :method
        File.write @config_file , @config_json.to_json 
    end

    
end