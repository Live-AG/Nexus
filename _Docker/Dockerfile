FROM ubuntu:xenial

ENV GOSU_VERSION 1.7
RUN apt-get -qq update \
  && apt-get -qq install --yes --no-install-recommends ca-certificates wget locales \
  && `#----- Install the dependencies -----` \
  && apt-get -qq install --yes --no-install-recommends fontconfig imagemagick \
  && `#----- Deal with ttf-mscorefonts-installer -----` \
  && apt-get -qq install --yes --no-install-recommends xfonts-utils cabextract \
  && wget --quiet --output-document /tmp/ttf-mscorefonts-installer_3.6_all.deb http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb \
  && dpkg --install /tmp/ttf-mscorefonts-installer_3.6_all.deb 2> /dev/null \
  && rm /tmp/ttf-mscorefonts-installer_3.6_all.deb \
  && `#----- Install gosu -----` \
  && wget --quiet --output-document /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

RUN localedef --inputfile ru_RU --force --charmap UTF-8 --alias-file /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.utf8

ADD server64_8_*.tar.gz /tmp/

ENV PLATFORM_VERSION 83
ENV SERVER_VERSION 8.3.21.1644

RUN /tmp/setup-full-$SERVER_VERSION-x86_64.run --mode unattended --enable-components config_storage_server,integrity_monitoring,liberica_jre,server,server_admin,ws,ru \
#dpkg --install /tmp/1c-enterprise$PLATFORM_VERSION-common_${SERVER_VERSION}_amd64.deb 2> /dev/null \
#  && dpkg --install /tmp/1c-enterprise$PLATFORM_VERSION-server_${SERVER_VERSION}_amd64.deb 2> /dev/null \
&& rm /tmp/*.run \
&& mkdir --parents /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
&& chown --recursive usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8 \
&& apt-get install mc -y

COPY container/docker-entrypoint.sh /
#COPY container/docker-entrypoint.sh /docker-entrypoint.d/docker-entrypoint.sh
COPY container/logcfg.xml /home/usr1cv8/.1cv8/1C/1cv8/conf

#ENTRYPOINT ["/docker-entrypoint.d/docker-entrypoint.sh"]

# RUN chmod +x /tmp/docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /home/usr1cv8
VOLUME /var/log/1C

# RUN chmod +x /tmp/docker-entrypoint.sh

EXPOSE 1540 1541 1545 1560-1591

CMD ["ragent"]
