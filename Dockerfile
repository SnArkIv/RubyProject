FROM ruby:3.3.11-bookworm

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips-dev \
    libyaml-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .
