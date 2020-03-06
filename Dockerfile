FROM ubuntu:latest
MAINTAINER Ayaan "ayaan@buzzni.com"

# set python
RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN apt-get install -y python3.7
RUN apt-get install -y python3-pip python3-dev build-essential\
      && cd /usr/local/bin \
      && ln -s /usr/bin/python3 python \
      && pip3 install --upgrade pip

# set locale
RUN apt-get install -y locales
RUN export LANGUAGE=C.UTF-8
RUN export LANG=C.UTF-8
ENV PYTHONIOENCODING UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE C.UTF-8

# set timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV HOME=/root
ENV WORKSPACE=$HOME/app
ENV PYTHONPATH=$WORKSPACE
ADD . $WORKSPACE/

#set pyenv
RUN apt-get install -y make build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    wget curl llvm libncurses5-dev libncursesw5-dev \
    git python-pip
# xz-utils tk-dev
RUN curl -L \
https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer \
| bash

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
RUN echo 'eval "$(pyenv init -)"' >> ~/.profile
RUN /bin/bash -c "source ~/.profile"
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

RUN pyenv install 3.7.4
RUN pyenv install 2.7.16
RUN jupyter notebook --generate-config
RUN python -m pip install ipykernel
RUN python -m ipykernel install --user
RUN cp -r jupyter_notebook_config.py /root/.jupyter/
RUN cp -r jupyter_notebook_config.json /root/.jupyter/
CMD ["jupyter","notebook","--allow-root"]
EXPOSE 8888