FROM ubuntu:16.04
MAINTAINER toolbox@cloudpassage.com

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y build-essential &&\
  apt-get install -y ruby ruby-dev ruby-bundler && \
  rm -rf /var/lib/apt/lists/*

COPY ./ /source/

WORKDIR /source/

RUN gem install rake

RUN bundle install