FROM alpine:latest as build

RUN apk add nodejs yarn
COPY frontend/package.json /app/frontend/package.json
COPY frontend/yarn.lock /app/frontend/yarn.lock
WORKDIR /app/frontend
RUN yarn
COPY frontend /app/frontend
RUN yarn build

FROM alpine:latest

RUN apk add ruby ruby-etc postgresql-dev ruby-dev build-base gcc sqlite-dev ruby-json ruby-bigdecimal
RUN gem i bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle --with production
COPY . /app
COPY --from=build /app/frontend/build /app/public

WORKDIR /app
ENTRYPOINT ["/usr/bin/bundle", "exec"]
CMD ["thin", "start"]
