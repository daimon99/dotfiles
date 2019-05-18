# deepin 安装后的设置

## 命令行

```bash
for pkg in konsole dolphin git
do
	sudo apt-get -y install $pkg
done
for pkg in build-essential zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev libgdbm-devliblzma-dev tk8.5-dev lzma lzma-dev libgdbm-dev
do
    sudo apt-get -y install $pkg
done
sudo apt install konsole
sudo apt install dolphin
sudo apt install git
ssh-keygen
cat ~/.ssh/id_rsa.pub
```

登录github配置ssh key信任

```bash
mkdir ~/git
cd ~/git
git clone git@github.com:daimon99/dotfiles
cd dotfiles
cp .ssh/config ~/.ssh/config
mkdir ~/.pip
cp .pip/pip.conf ~/.pip/pip.conf
cp .vimrc ~/
```

## 源码编译安装

> https://www.iamhuman.app

* python3.6

```bash
./configure --with-ssl
make && make install
```

* ariac

## 应用商店安装

* shadowsocks-qt
* 微信
* 企业微信
* sublime text


