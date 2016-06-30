# MES-Elastic

[![Build Status](https://travis-ci.com/glomex/mes-elastic.svg?token=wTxfWxNSPNpHpdJc4pif&branch=master)](https://travis-ci.com/glomex/mes-elastic)

This gem aggregates ElasticSearch logics, which can be reused in MES applications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mes-elastic', git: 'git@github.com:glomex/mes-elastic.git'
```

And then execute:

```bash
bundle
```

## Testing

You can run tests for it using docker-compose:

```bash
docker-compose run app bundle exec rspec
```
