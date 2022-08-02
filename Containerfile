FROM ubi8/ubi:8.4

MAINTAINER Jaime Zamudio <jzamudio@redhat.com>

ENV HTTPD_VERSION=2.4
ENV PORT=8080

LABEL description="A custom Apache container based on UBI 8" \
      io.k8s.display-name="Apache httpd $HTTPD_VERSION" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="builder,httpd,httpd24"

RUN yum install -y httpd yum-utils && \
    yum clean all


RUN sed -ri -e "/^Listen 80/c\Listen ${PORT}" /etc/httpd/conf/httpd.conf && \
    chown -R apache:apache /etc/httpd/logs/ && \
    chown -R apache:apache /run/httpd/

#RUN echo "Hello from Dockerfile UBI 8" > /var/www/html/index.html
COPY index.html /var/www/html/

USER apache
EXPOSE ${PORT}

CMD ["httpd", "-D", "FOREGROUND"]

