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
ENV PROJECT_NAME=workspace
ENV PYTHONPATH=$WORKSPACE/$PROJECT_NAME

ADD . $WORKSPACE/
WORKDIR $WORKSPACE

#set jupyter
RUN /bin/bash -c "pip install jupyter"
RUN /bin/bash -c "jupyter notebook --generate-config"
RUN python -m pip install ipykernel
RUN python -m ipykernel install --user
RUN cp -r jupyter_notebook_config.py /root/.jupyter/
RUN cp -r jupyter_notebook_config.json /root/.jupyter/

#set pyenv
#RUN pip install pipenv
RUN apt-get install -y make build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    wget curl llvm libncurses5-dev libncursesw5-dev \
    git python-pip
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN /bin/bash -c "sh /root/app/bin/install_pyenv.sh"

#set python2  kernel
RUN /root/.pyenv/shims/pip2 install ipykernel
RUN /bin/bash -c "python /root/app/bin/gen_kernel.py -p 2.7 -vn python2 -vp /root/.pyenv/shims/python2"
#RUN apt-get install -y git
#set brand
#WORKDIR $WORKSPACE/$PROJECT_NAME
#ADD ./search-brand_extractor/. $WORKSPACE/$PROJECT_NAME/
#RUN git clone git@bitbucket.org:ayaan_buzzni/brand_extractor_api.git
WORKDIR $WORKSPACE/bin
RUN /bin/bash -c "sh env.sh /root/app/env_list/brand_extractor"


WORKDIR $WORKSPACE
CMD ["jupyter","notebook","--allow-root"]
EXPOSE 8888