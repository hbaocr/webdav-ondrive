FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ UTC
RUN apt-get update &&  apt-get install -y davfs2 python3  python3-pip gosu wget\
    && chmod 777 /etc/davfs2/davfs2.conf \
    && mkdir -p /webdavfs/mnt
COPY docker-entrypoint.sh docker-entrypoint.sh
COPY check-mount-each-min.sh check-mount-each-min.sh
COPY get-sharepoint-auth-cookie.py get-sharepoint-auth-cookie.py 
RUN chmod +x docker-entrypoint.sh check-mount-each-min.sh
ENTRYPOINT [ "./docker-entrypoint.sh" ]

