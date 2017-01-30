FROM ubuntu:16.04
MAINTAINER toolbox@cloudpassage.com

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y build-essential && \
  apt-get install zlib1g-dev && \
  apt-get install -y ruby ruby-dev ruby-bundler && \
  rm -rf /var/lib/apt/lists/*

COPY ./ /source/

WORKDIR /source/

RUN mkdir /root/.aws
RUN gem install rake -v 10.5.0

RUN bundle install

CMD cat <<EOT >> ~/.aws/config \
[default] \
region = ${KITCHEN_AWS_REGION} \
EOT

CMD cat <<EOT>> ~/.aws/config \
[default] \
aws_access_key_id = ${AWS_ACCESS_KEY_ID} \
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY} \
EOT

CMD rake integration:ec2