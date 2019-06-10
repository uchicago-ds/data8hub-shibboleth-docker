FROM buildpack-deps:bionic-scm

ENV APP_DIR /srv/app

# Set up common env variables
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN adduser --disabled-password --gecos "Default Jupyter user" jovyan
RUN install -d -o jovyan -g jovyan ${APP_DIR}

COPY nodesource.list /etc/apt/sources.list.d/nodesource.list
COPY nodesource-key.asc /tmp/nodesource-key.asc
RUN apt-key add /tmp/nodesource-key.asc

# TODO: remove me when apt can find our packages
#RUN echo 91.189.91.26  security.ubuntu.com >> /etc/hosts
#RUN echo 91.189.88.149  archive.ubuntu.com >> /etc/hosts

RUN apt-get -qq update --yes && \
    apt-get -qq install --yes \
            python3.6 \
            python3.6-venv \
            python3.6-dev \
            python3-venv \
            python3-pip \
            tar \
            vim \
            nodejs \
            locales > /dev/null

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# for nbconvert
RUN apt-get -qq install --yes \
            pandoc \
            texlive-xetex \
            texlive-fonts-recommended \
            texlive-generic-recommended > /dev/null

ENV PATH ${APP_DIR}/venv/bin:$PATH
# Set this to be on container storage, rather than under $HOME
ENV IPYTHONDIR ${APP_DIR}/venv/etc/ipython

WORKDIR /home/jovyan

USER jovyan
RUN python3.6 -m venv ${APP_DIR}/venv

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install JupyterLab extensions
RUN jupyter labextension install \
            @jupyterlab/hub-extension \
            @jupyter-widgets/jupyterlab-manager \
            jupyter-matplotlib \
            @jupyterlab/plotly-extension \
            @jupyterlab/geojson-extension

ADD ipython_config.py ${IPYTHONDIR}/ipython_config.py
ADD jupyter_notebook_config.py ${APP_DIR}/venv/etc/jupyter/jupyter_notebook_config.py

# Install nbzip
RUN jupyter serverextension enable  --sys-prefix --py nbzip && \
    jupyter nbextension     install --sys-prefix --py nbzip && \
    jupyter nbextension     enable  --sys-prefix --py nbzip

EXPOSE 8888
