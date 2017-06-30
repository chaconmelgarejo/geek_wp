FROM php:7.0-apache

CMD ["/sbin/my_init"]

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

#RUN apt-get update -y

#RUN apt-get install -y software-properties-common wget git tree sudo curl

RUN rm -f /etc/service/sshd/down
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*

RUN useradd -u 996 -m jenkins

RUN cd /tmp \
&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp \
&& chmod +x /usr/local/bin/wp

RUN wget -O - https://wordpress.org/wordpress-4.8.tar.gz | tar zx -C /var/www/html --strip-components=1
COPY wp-config.php /
RUN chown -R www-data:www-data /var/www/html

RUN  echo 'jenkins     ALL=NOPASSWD: ALL' >> /etc/sudoers

RUN { \
                echo 'upload_max_filesize=4M'; \
        } >> /etc/php/7.0/apache2/conf.d/10-settings.ini

EXPOSE 80
