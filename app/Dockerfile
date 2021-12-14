FROM ruby:2.7.4

ENV LANG="C.UTF-8" \
	RAILS_VERSION="6.0.3"

RUN apt-get update && apt-get install -y vim git build-essential nano&& rm -rf /var/lib/apt/lists/*

RUN echo 'export PS1="\[\e[1;33m\]rails:\w \u\[\e[m\]# "' >> ~/.bashrc

RUN echo "alias ll='ls -la'" >> ~/.bashrc

RUN echo "alias ss='rails s -b 0.0.0.0'" >> ~/.bashrc

RUN gem install rails --version "$RAILS_VERSION" -N

RUN gem install mysql2

WORKDIR /app/todo

EXPOSE 3000