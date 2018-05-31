require 'json'
require 'colorize'

class Installer

    def self.run
        puts "---------Bengin Install SS ------------".colorize(:yellow)

        script = %Q{
            if [ -x "$(command -v yum)" ]; then
                yum install python-setuptools && easy_install pip
            elif [ -x "$(command -v apt-get)" ]; then
                apt-get install python-pip 
            fi
            pip install shadowsocks
        }
        system script
    end

end