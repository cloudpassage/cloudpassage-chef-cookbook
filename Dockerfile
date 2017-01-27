FROM alpine:3.4
MAINTAINER toolbox@cloudpassage.com

RUN apk add -U \
    ruby ruby-dev ruby-bundler

COPY ./ /source/

WORKDIR /source/

#RUN gem install bundler

#RUN bundle install