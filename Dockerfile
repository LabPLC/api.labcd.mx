FROM phusion/passenger-ruby22:latest
MAINTAINER "Miguel Angel Gordian  miguel.angel@civica.digital"

ENV HOME /root

CMD ["/sbin/my_init"]
RUN ruby-switch --set ruby2.2

USER app
WORKDIR /home/app/api_cdmx

ADD . /home/app/api_cdmx
ADD docker/api_cdmx.conf /etc/nginx/sites-enabled/
ADD docker/00_app_env.conf /etc/nginx/conf.d/
ADD docker/api_cdmx-env.conf /etc/nginx/main.d/
ADD docker/database.yml /home/app/api_cdmx/config/database.yml

USER root
RUN bundle install
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN chown -R app:app /home/app/api_cdmx

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
