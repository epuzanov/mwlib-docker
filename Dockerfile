FROM debian:stretch

MAINTAINER Egor Puzanov

ENV DEBIAN_FRONTEND noninteractive

RUN set -x; apt-get update &&\
    apt-get install -y --no-install-recommends blahtexml ca-certificates cython \
        g++ gcc gettext dvipng imagemagick libfreetype6-dev libjpeg-dev \
        libxml2-dev libxslt-dev libz-dev locales-all make ocaml-nox pdftk \
        ploticus python python-dev python-imaging python-lxml python-pip \
        python-setuptools python-virtualenv python-wheel re2c supervisor \
        texlive-latex-recommended &&\
    echo "[global]\nindex-url = http://pypi.pediapress.com/simple\ntrusted-host = pypi.pediapress.com\n" > /etc/pip.conf &&\
    pip install http://pypi.pediapress.com/packages/mirror/mwlib-0.15.19.zip &&\
    pip install http://pypi.pediapress.com/packages/mirror/mwlib.ext-0.12.4.zip &&\
    pip install http://pypi.pediapress.com/packages/mirror/mwlib.rl-0.14.6.zip &&\
    pip install http://pypi.pediapress.com/packages/mirror/mwlib.epub-0.14.3.zip &&\
    apt-get remove -y cython g++ gcc gettext git libc6-dev make ocaml-nox \
        python-dev python-pip python-virtualenv python-wheel re2c &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /root/* /etc/pip.conf &&\
    ln -sfT /dev/stdout /var/log/supervisord.log &&\
    mkdir -p /var/cache/mwlib

COPY supervisord.conf /etc/supervisord.conf
COPY customconfig.py /usr/local/lib/python2.7/dist-packages/customconfig.py
RUN python -m compileall /usr/local/lib/python2.7/dist-packages/customconfig.py

VOLUME /var/cache/mwlib
EXPOSE 8899

#CMD ["supervisord", "-c", "/etc/supervisord.conf"]
CMD ["/bin/bash", "-c", "nserve & mw-qserve & nslave --cachedir /var/cache/mwlib & postman --cachedir /var/cache/mwlib"]
