#! /bin/sh
#
# install.sh
# Copyright (C) 2014 Fechin <lihuoqingfly@163.com>
#
# Distributed under terms of the MIT license.

# 系统检测
OS=$(uname)

if [[ ${OS} != "Darwin" && ${OS} != "Linux" ]]; then
    echo "暂时不支持${OS}系统!"
    exit 1
fi

echo "安装需要花费一些时间，请等待..."

# 插件目录,跟vimrc保持一致
PLUG_DIR=$HOME/.vim/plugged

# 清空插件目录
if [ -d $PLUG_DIR ]; then
    echo "清理插件目录：" $PLUG_DIR
    rm -rf $PLUG_DIR
fi

# Linux 系统安装
if which apt-get >/dev/null; then
    sudo apt-get install -y build-essential cmake python-dev pyflakes npm
elif which yum >/dev/null; then
    sudo yum install -y build-essential cmake python-dev pyflakes npm
fi

# Mac 系统安装
if which brew >/dev/null; then
    sudo easy_install pyflakes
    brew install cmake npm
    npm install jshint -g
fi

VIM_COMMAND="PlugInstall"
mvim -c "$VIM_COMMAND"  -c "q" -c "q"

# 定时检测vim是否退出
while true; do
  ps -ef | grep -v grep | grep -v "install.sh" | grep Vim | grep "$VIM_COMMAND" > /dev/null || break
  echo "=\c"
  sleep 3
done

# do something
ERROR_PREFIX="\033[31m Error:\033[0m "

if [ -d "$PLUG_DIR/YouCompleteMe/" ]; then
    YCMD_DIR=$PLUG_DIR/YouCompleteMe/third_party/ycmd
    if [ ! -e "$YCMD_DIR/build.sh" ]; then
        cd $YCMD_DIR
        git submodule update --init --recursive
    fi

    cd $PLUG_DIR/YouCompleteMe
    ./install.sh --clang-completer
else
    echo "$ERROR_PREFIX YouCompleteMe安装失败，请查阅：https://github.com/Valloric/YouCompleteMe"
    exit 1
fi

echo "久等，现在你能做的不止是煮咖啡！！"
