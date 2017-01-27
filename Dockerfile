FROM ubuntu:16.04
MAINTAINER toolbox@cloudpassage.com

RUN apk add -U \
    ruby ruby-dev ruby-bundler

COPY ./ /source/

WORKDIR /source/

#RUN gem install bundler

#RUN bundle install