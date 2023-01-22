# Trading Simulator API

Simple Ruby on Rails Trading Simulator API

## Swagger
Swagger specification is located at /api-docs/

## Admin credentials
admin@example.com:12345

## Running

### Using docker-compose

```bash
cp secrets.env.template secrets.env
```
Update secrets.env file with api key for [https://fixer.io](https://fixer.io)
```bash
docker-compose up
```

## Develop

### Dev running
```bash
cp .env.template .env
```
Update .env file
```bash
bundle install
bundle exec rake db:setup
bundle exec rails s
```

### Run tests
```bash
bundle install
bundle exec rspec
```
