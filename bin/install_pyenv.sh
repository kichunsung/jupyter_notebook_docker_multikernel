#!/bin/bash
#set pyenv
#apt-get install -y make build-essential \
#    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
#    wget curl llvm libncurses5-dev libncursesw5-dev \
#    git python-pip
# xz-utils tk-dev
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
source ~/.profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
pyenv install 3.7.4
pyenv install 2.7.16
