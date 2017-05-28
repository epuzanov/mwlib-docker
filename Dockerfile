FROM debian:jessie

MAINTAINER Egor Puzanov <epuzanov@gmx.de>

RUN apt-get update \
    && apt-get install -y --no-install-recommends texlive-latex-recommended \
    gcc g++ make python-pip python-lxml python-imaging python-bottle \
    python-dev python-pypdf python-apipkg python-py python-simplejson \
    python-roman python-gevent python-greenlet pdftk ploticus blahtexml \
    imagemagick dvipng supervisor \
    && mkdir /etc/pip \
    && echo "[global]\ntrusted-host=pypi.pediapress.com\n" > /etc/pip/pip.conf \
    && pip install -i http://pypi.pediapress.com/simple/ mwlib \
    && pip install -i http://pypi.pediapress.com/simple/ mwlib.rl \
    && rm /etc/pip/pip.conf \
    && rmdir /etc/pip \
    && apt-get remove -y python-dev python-pip python3 gcc g++ make \
    && apt-get autoremove -y \
    && apt-get install -y python-setuptools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && mkdir -p /var/cache/mwlib /var/log/supervisor

COPY customconfig.py /usr/local/lib/python2.7/dist-packages/customconfig.py
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

VOLUME /var/cache/mwlib
EXPOSE 8899

CMD ["/bin/bash", "-c", "nserve & mw-qserve & nslave --cachedir /var/cache/mwlib & postman --cachedir /var/cache/mwlib"]
