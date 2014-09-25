FROM debian:wheezy
MAINTAINER Patrick Kettner <patrickkettner@gmail.co>

# Install base packages
ENV DEBIAN_FRONTEND noninteractive

RUN useradd --no-create-home www && \
    apt-get update && \
    apt-get -yq install \
        lighttpd && \
    mkdir -p  /var/run/lighttpd && \
    chown -R www:www /var/log/lighttpd/ && \
    rm -rf /var/lib/apt/lists/*

ADD server-config/lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
RUN mkdir -p /app && \
  rm -fr /var/www/sites/go/here && \
  mkdir -p /var/www/sites/go && \
  ln -s /app /var/www/sites/go/here
ADD sample-app/dist/ /app

# Add application code onbuild
ONBUILD RUN rm -fr /app
ONBUILD ADD . /app
ONBUILD RUN chown www:www /app -R

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
