FROM python:3.10-alpine AS bratbase

WORKDIR /brat
ADD https://github.com/nlplab/brat/archive/refs/heads/master.zip /tmp/brat-latest.zip
RUN unzip /tmp/brat-latest.zip -d /tmp/
RUN cp /tmp/brat-master/* . -r
RUN echo "application/xhtml+xml xhtml" > /etc/mime.types

FROM bratbase AS annotationtask
ADD doc doc/
ADD config/* ./
RUN mkdir work
CMD ["/brat/standalone.py"]
