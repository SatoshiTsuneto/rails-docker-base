FROM ruby:2.6.3

RUN apt update && apt install -y build-essential libpq-dev nodejs
RUN mkdir /root/rails-app
WORKDIR /root/rails-app
COPY ./rails-app/Gemfile /root/rails-app/Gemfile
COPY ./rails-app/Gemfile.lock /root/rails-app/Gemfile.lock
RUN bundle install
COPY ./rails-app /root/rails-app
