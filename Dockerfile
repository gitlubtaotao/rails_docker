FROM ruby:2.6.0

#安装ruby 依赖
RUN apt-get update -qq && apt-get install -y \
    mysql-client \
    curl

RUN curl -sL https://deb.nodesource.com/setup_8.x |   bash -
RUN apt-get install -y nodejs

RUN apt-get install gcc g++ make
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn



RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]