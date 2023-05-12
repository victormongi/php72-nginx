FROM ubuntu:18.04
LABEL maintainer="Victor Mongi"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& apt-get install -y gnupg tzdata vim\
	&& dpkg-reconfigure -f noninteractive tzdata
RUN apt-get update \
	&& apt-get install -y curl zip unzip git supervisor sqlite3 vim \
	nginx php7.2-fpm php7.2-cli \
	php7.2-pgsql php7.2-sqlite3 php7.2-gd \
	php7.2-curl php7.2-memcached \
	php7.2-imap php7.2-mysql php7.2-mbstring \
	php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
	php7.2-intl php7.2-readline php7.2-xdebug \
	php-msgpack php-igbinary \
	&& mkdir /run/php \
	&& cp /usr/share/zoneinfo/Asia/Makassar /etc/localtime \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& echo "daemon off;" >> /etc/nginx/nginx.conf
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y php7.2-mongodb
RUN apt-get install -y php-pear php7.2-dev libyaml-dev
RUN pecl install mongodb

RUN echo "extension=mongodb.so" >> php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["supervisord"]

COPY ./default /etc/nginx/sites-available/default

RUN apt update -y

RUN mkdir /home/session
RUN chmod 777 /home/session
