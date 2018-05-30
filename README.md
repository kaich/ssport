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
    -b, --bind port                  shadowsocket server bind port
    -p, --password password          shadowsocket password
    -m, --method method              shadowsocket encry method
    -c, --config filepath            shadowsocket config file path


* S 服务器地址 
* A 服务器别名，记录之后下次直接用别名不用每次都输入`服务器地址`,`服务器用户名`和`服务器密码`。例如： `ssport -S 119.44.97.96:9090 -U root -P 123456 -A bandwagon`。 下次直接用`ssport -A bandwagon -b 8970` 就可以修改端口号了。
* L 显示所有的服务器别名
* U 服务器SSH登录的用户名，因为需要读写权限，请确保用户有权限。或者直接用root更方便。
* P SSH登录的密码
* b 设置SS需要绑定的端口号
* p 设置SS需要修改的新密码
* m 设置SS需要修改的加密方法
* c 指定SS服务的配置文件位置, 默认是`/etc/shadowsocks.json`

如果您遇到需要修改SS配置的情况，可以尝试使用该命令行来解决您的问题。


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ssport.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
