FROM alpine:latest AS build

RUN apk add nodejs yarn
COPY frontend/package.json /app/frontend/package.json
COPY frontend/yarn.lock /app/frontend/yarn.lock
WORKDIR /app/frontend
RUN yarn
COPY frontend /app/frontend
RUN yarn build

FROM alpine:latest

RUN apk add ruby libpq-dev ruby-dev build-base gcc sqlite-dev ruby-bigdecimal
RUN gem i bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle config set with 'production' && bundle install
COPY . /app
COPY --from=build /app/frontend/build /app/public

WORKDIR /app
ENTRYPOINT ["/usr/bin/bundle", "exec"]
CMD ["thin", "start"]
