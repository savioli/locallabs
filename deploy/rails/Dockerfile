FROM ruby:2.7.1-alpine

RUN apk add --update \
              build-base \
              mariadb-dev \
              sqlite-dev \
              nodejs \
              tzdata \
              yarn

RUN rm -rf /var/cache/apk/*

ENV RAILS_ROOT /var/www/ror_app

WORKDIR $RAILS_ROOT

RUN mkdir tmp/pids

COPY Gemfile Gemfile

# COPY Gemfile.lock Gemfile.lock

RUN gem install bundler

RUN bundle install

COPY . .

# COPY yarn.lock yarn.lock

RUN yarn install --check-files

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
