FROM quay.io/jaimemarianoz/ubi:8.0

MAINTAINER Jaime Zamudio <jzamudio@redhat.com>

ENV HTTPD_VERSION=2.4 \
    PORT=8080 \
    USER=1001

LABEL description="A custom Apache container based on UBI 8" \
      io.k8s.display-name="Apache httpd $HTTPD_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,httpd,httpd24"

RUN yum install -y --nodocs --disableplugin=subscription-manager httpd && \
    yum clean all --disableplugin=subscription-manager && \
    sed -ri -e "/^Listen 80/c\Listen ${PORT}" /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /run/httpd /var/log/httpd && \
    chmod -R g=u /run/httpd /var/log/httpd

USER ${USER}
EXPOSE ${PORT}

CMD ["httpd", "-D", "FOREGROUND"]

