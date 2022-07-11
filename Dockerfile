FROM ruby:3.0.1

RUN apt-key adv --fetch-keys "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xea6e302dc78cc4b087cfc3570ebea9b02842f111" && \
    echo 'deb http://ppa.launchpad.net/chromium-team/beta/ubuntu bionic main ' >> /etc/apt/sources.list.d/chromium-team-beta.list

RUN apt-get update -qq && apt-get install -y build-essential

RUN mkdir -p tmp/sockets/ \
  && mkdir -p tmp/pids/

RUN mkdir /app
WORKDIR /app

RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs=8

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . .

ENV RAILS_ENV "production"
ENV RAILS_LOG_TO_STDOUT 1

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]