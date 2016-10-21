FROM ubuntu:trusty

MAINTAINER dtomcej <danielt@getyardstick.com>

#Config files and some ideas taken from
# https://github.com/Epheo/docker-naxsi-proxy-waf/

#Change this and build the image to suit your needs by default, without needing to add parameters later
ENV LEARNING_MODE yes
ENV PROXY_REDIRECT_IP 12.34.56.78
ENV NAXSI_UI_PASSWORD test

#Install needed packages from repos and get naxsi-ui from source
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx-naxsi \
    python-twisted-web \
    python-geoip \
    wget && \
    cd /usr/local/ && \
    wget https://github.com/nbs-system/naxsi/archive/0.50.tar.gz && \
    tar zxvf 0.50.tar.gz && \
    rm 0.50.tar.gz && \
    sed -i 's/error import NoResource/resource import NoResource/g'  /usr/local/naxsi-0.50/contrib/naxsi-ui/nx_extract.py && \
    mkdir /etc/nginx/local-config && \
    mkdir /var/log/naxsi


#Configuration files
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/default /etc/nginx/sites-enabled/default
ADD naxsi-ui/naxsi-ui.conf /usr/local/naxsi-0.50/contrib/naxsi-ui/naxsi-ui.conf
ADD entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

#Ports
EXPOSE 80
EXPOSE 8081

CMD ["/entrypoint.sh"]
