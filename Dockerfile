FROM alpine as git_httpd

ENTRYPOINT ["/entrypoint.sh"]
RUN apk --no-cache add git apache2-proxy py3-waitress

#Remove in final build
RUN apk add bash nano

RUN apk --no-cache add py3-setuptools && \
    cd /opt/ && \
    git clone https://github.com/bloomberg/python-github-webhook.git && \
    cd /opt/python-github-webhook && \
    python3 setup.py install && \
    apk --no-cache del py3-setuptools

COPY *.conf /etc/apache2/conf.d/


WORKDIR /opt/python-github-webhook/
COPY run.py /opt/python-github-webhook/
COPY hooks/* /opt/python-github-webhook/hooks/
COPY entrypoint.sh /entrypoint.sh
