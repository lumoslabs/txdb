FROM ruby:2.5

EXPOSE 9292

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./Gemfile /usr/src/app/
COPY ./Gemfile.lock /usr/src/app/
COPY ./txdb.gemspec /usr/src/app/
COPY ./lib/txdb/version.rb /usr/src/app/lib/txdb/
RUN bundle install --jobs=3 --retry=3 --without development test

COPY . /usr/src/app

CMD ["bundle", "exec", "puma", "-p", "9292"]
