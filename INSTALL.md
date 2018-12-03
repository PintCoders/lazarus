### Install docker and criu on Ubuntu
```
$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https ca-certificates curl software-properties-common pkg-config python-ipaddress libbsd0 iproute2 libcap-dev libnl-3-dev libnet-dev libaio-dev python3-future autoconf automake libtool curl make g++ unzip

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo apt-key fingerprint 0EBFCD88

$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

$ sudo add-apt-repository ppa:criu/ppa

$ sudo apt-get update

$ sudo apt-get install docker-ce

$ sudo apt-get install criu

$ git clone https://github.com/moby/moby.git

$ cd moby && sudo make install && cd ..

```
