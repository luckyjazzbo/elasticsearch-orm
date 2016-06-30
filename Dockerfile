FROM ruby:2.3.1

RUN apt-get update -qq && \
    apt-get install -y build-essential cmake libpq-dev mcrypt libmcrypt-dev && \
    apt-get clean

ENV BUNDLE_PATH=/app/.bundle
ENV PATH=$PATH:./bin
ENV AWS_PROFILE=dev

RUN mkdir -p /app
WORKDIR /app

ENTRYPOINT docker_start $0 $@
