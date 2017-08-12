###############################################
# Dockerfile to build php-fpm
# based on CentOS 7 image
###############################################

# Set the base image to CentOS 7
FROM centos:centos7

# Image author/maintainer
MAINTAINER Randy Lowe <randy@weblogix.ca>

# normal updates
RUN yum -y update

# install tools
RUN yum -y install epel-release initscripts nano bind-utils net-tools sendmail

# Install PHP 7
RUN \
  rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \

  yum -y install \
  php71w-fpm \
  php71w-opcache \
  php71w-bcmath \
  php71w-cli \
  php71w-common \
  php71w-gd \
  php71w-imap	\
  php71w-mbstring	\
  php71w-mcrypt	\
  php71w-mysqlnd \
  php71w-pdo \
  php71w-pear	\
  php71w-pecl-imagick	\
  php71w-process \
  php71w-pspell	\
  php71w-recode	\
  php71w-tidy	\
  php71w-xml

# Copy php-fpm configuration
COPY conf/php-fpm/www.conf /etc/php-fpm.d/www.conf
COPY conf/php-fpm/php.ini /etc/php.ini

# Copy supervisor configuration file
RUN yum -y install supervisor
COPY conf/supervisor/supervisord.conf /etc/supervisord.conf

# Forward logs to docker log collector
RUN ln -sf /dev/stdout /var/log/php-fpm/access.log \
	&& ln -sf /dev/stderr /var/log/fpm-php.www.log \
  && ln -sf /dev/stderr /var/log/php-fpm/fpm-error.log

# Clean up
RUN yum clean all

# Expose ports
EXPOSE 9000

CMD ["/usr/bin/supervisord"]
