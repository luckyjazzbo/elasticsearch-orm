# MES-Elastic

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
docker-compose up -d
docker-compose run app
```

## Usage

The gem defines 2 models:

```ruby
Mes::EvaIndex
Mes::MesIndex
```

For each model you can perform following index actions:

```ruby
YOUR_MODEL_CLASS.index_exists?   # returns true if index already exists
YOUR_MODEL_CLASS.create_index    # creates index unless it exists
```
