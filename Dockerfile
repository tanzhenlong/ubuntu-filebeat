FROM ubuntu:23.04
MAINTAINER  tanzhenlong@qq.com

ENV FILEBEAT_VERSION 6.5.4
ENV FILEBEAT_BASE_URL https://artifacts.elastic.co/downloads/beats/filebeat/
ENV TIME_ZONE Asia/Shanghai

WORKDIR /usr/share/filebeat

COPY filebeat-6.5.4-linux-x86_64.tar.gz /usr/share
ADD  docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN  apt-get update  \
    && apt-get upgrade -y  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata   \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone  \
    && dpkg-reconfigure -f noninteractive tzdata \
    && cd /usr/share \
    && tar -zxf filebeat-6.5.4-linux-x86_64.tar.gz   -C /usr/share/filebeat --strip-components=1 \
    && rm -rf ilebeat-6.5.4-linux-x86_64.tar.gz \
    && chmod +x /usr/bin/docker-entrypoint.sh \
    && chmod +x /usr/share/filebeat \
    && apt-get clean  \
    && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/share/filebeat/filebeat","-e","-c","/usr/share/filebeat/filebeat.yml"]
