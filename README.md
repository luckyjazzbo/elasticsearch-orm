# ElasticsearchOrm (System:MES,Squad:publisher,Type:Component)
[![Build Status](https://travis-ci.org/glomex/elasticsearch-orm.svg?branch=master)](https://travis-ci.org/glomex/elasticsearch-orm)

Component for accessing/modifying elastic from ruby apps.

## Technology
* ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticsearch-orm', git: 'git@github.com:glomex/elasticsearch-orm.git'
```

## Running tests
```bash
docker-compose run app bundle install
docker-compose run app bundle exec rspec
```
