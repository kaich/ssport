# Ssport

由于Shadowsocket时不时端口就被墙了。每次都要经过一下步骤`登录服务器` -> `修改配置文件` -> `重启SS服务` 来换端口号或者加密方式。虽然步骤不多，每次及密码修改重启这些命令和密码记忆起来也麻烦，毕竟都是不常用的命令。为节省大家时间，于是写了一个命令行工具，可以一个命令行解决所有，省去繁杂操作。

## Installation

    $ gem install ssport

## Usage

由于该工具使用ruby写的，请确保服务器上安装了`ruby`环境和`gems`。

##### 帮助： `ssport -h` 查看。

    Usage: change shadowsocket port
    -S host                          ssh server host
    -A, --server aliasName           ssh server alia name, eg: ssport -a ramnode -b 724
    -L, --list                       list available server alia name
    -U, --username username          ssh server username
    -P, --pass password              ssh server password
    -I, --install shadowsocket       install shadowsocket on server, default port: 8388, password: 123456, method: rc4-md5
    -b, --bind port                  shadowsocket server bind port
    -p, --password password          shadowsocket password
    -m, --method method              shadowsocket encry method
    -c, --config filepath            shadowsocket config file path


* S 服务器地址 
* A 服务器别名，记录之后下次直接用别名不用每次都输入`服务器地址`,`服务器用户名`和`服务器密码`。例如： `ssport -S 119.44.97.96:9090 -U root -P 123456 -A bandwagon`。 下次直接用`ssport -A bandwagon -b 8970` 就可以修改端口号了。
* L 显示所有的服务器别名
* U 服务器SSH登录的用户名，因为需要读写权限，请确保用户有权限。或者直接用root更方便。
* P SSH登录的密码
* I 在服务器上安装SS服务, 默认 密码:123456、端口：8388、方式：rc4-md5。当然你可以在里面参数里面自己添加[-b -p -m]来修改默认配置。
* b 设置SS需要绑定的端口号
* p 设置SS需要修改的新密码
* m 设置SS需要修改的加密方法
* c 指定SS服务的配置文件位置

如果您遇到需要修改SS配置的情况，可以尝试使用该命令行来解决您的问题。

##### 查看配置

如何只查看SS的配置呢。 很简单，只要不加修改的选项就可以了。例如：`ssport -A bandwagon`, 显示内容如下：

    ---------Bengin Deal /etc/shadowsocks.json ------------
    -------------Old Config---------------
    {
    "server": "47.192.99.110",
    "server_port": "8081",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "ssport",
    "timeout": 300,
    "method": "rc4-md5",
    "fast_open": false,
    "workers": 1
    }
    -------------New Config---------------
    {
    "server": "47.192.99.110",
    "server_port": "8081",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "ssport",
    "timeout": 300,
    "method": "rc4-md5",
    "fast_open": false,
    "workers": 1
    }

原本的配置和新的配置一模一样，也就是任何内容都未曾改变。用于方便的查看SS配置。

###### 安装SS

* 添加主机别名为ramnode： `ssport -S 47.192.99.110 -P 123456 -U root -c /etc/shadowsocks.json -A ramnode`
* 在服务器上安装SS: `ssport -A ramnode -i`
* 在服务器上安装SS，并修改默认配置: `ssport -A ramnode -i -b 900 -m rc4-md5 -p 123456`


###### 修改配置

* 修改端口号并添加主机别名为ramnode： `ssport -S 47.192.99.110 -P 123456 -U root -c /etc/shadowsocks.json -b 805 -A ramnode`
* 修改端口号: `ssport -A ramnode -b 903`
* 修改加密方法: `ssport -A ramnode -m rc4-md5`
* 修改端口号、加密方法、密码：`ssport -A ramnode -b 900 -m rc4-md5 -p 123456`

以上内容都是虚构的地址和用户名密码，请替换成你自己的进行操作。

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ssport.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
