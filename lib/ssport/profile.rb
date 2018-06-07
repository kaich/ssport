require 'json'
require 'colorize'

class Profile

    def initialize(options)
        @options = options
        @alias_name = @options[:alias]
    end

    def genrc(alias_name) 
        if !File.directory?(File.expand_path("~/.ssport"))
            `mkdir ~/.ssport`
        end
        File.expand_path "~/.ssport/#{alias_name}.rc"
    end

    def list
         alias_names = Dir[File.expand_path "~/.ssport/*"].select{ |f| File.file? f }.map{ |f| File.basename f, ".rc"}
         puts '----------Alias Name----------'.colorize(:yellow)
         alias_names.each do |name|
            rc = loadrc
            puts "#{alias_names}  :  #{rc[:server]}".colorize(:green)
         end
    end
   
    def dealrc
        if @alias_name 
            server = @options[:server]
            username = @options[:username]
            pass = @options[:pass]
            if server || username || pass
                return saverc
            else 
                return loadrc
            end
        end 
        return nil
    end

    def saverc
        if @alias_name 
            rc = JSON.pretty_generate(@options)
            File.write genrc(@alias_name), rc  
            return @options
        end
        return nil
    end

    def loadrc
        if @alias_name 
            rc_content = File.read genrc(@alias_name)
            rc = JSON.parse(rc_content)
            final_rc = rc.collect{|k,v| [k.to_sym, v]}.to_h
            return final_rc
        else
            puts "Don't find server alias name profile.".colorize(:red)
        end
        return nil
    end

end