FROM ruby:2.5.1

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      libpq-dev \
      mcrypt libmcrypt-dev \
      git \
      pkg-config \
      libcurl3 libcurl3-gnutls libcurl4-openssl-dev && \
    apt-get clean -qq
