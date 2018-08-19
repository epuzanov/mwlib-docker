FROM debian:stretch

MAINTAINER Egor Puzanov

ENV DEBIAN_FRONTEND noninteractive

RUN set -x; apt-get update &&\
    apt-get install -y --no-install-recommends blahtexml ca-certificates cython \
        g++ gcc gettext git dvipng imagemagick locales-all make ocaml-nox pdftk \
        ploticus python-apipkg python-bottle python-cssutils python-dev \
        python-gevent python-greenlet python-imaging python-lxml python-odf \
        python-pip python-py python-pygments python-pyparsing python-pypdf2 \
        python-roman python-setuptools python-simplejson python-wheel \
        python-wsgi-intercept re2c supervisor texlive-latex-recommended &&\
    cd /tmp &&\
    git clone --depth 1 -b 0.16.1 https://github.com/pediapress/mwlib.git mwlib &&\
    sed -i "s/pyparsing[^\"]*/pyparsing/g" /tmp/mwlib/setup.py &&\
    sed -i "s/odfpy[^\"]*/odfpy/g" /tmp/mwlib/setup.py &&\
    sed -i "s/pyPdf[^\"]*/PyPDF2/g" /tmp/mwlib/setup.py &&\
    sed -i "s/pyPdf/PyPDF2/g" /tmp/mwlib/mwlib/utils.py &&\
    sed -i "s/if netloc[^:]*/if False/g" /tmp/mwlib/mwlib/nserve.py &&\
    echo "qserve==0.2.8\nsqlite3dbm==0.1.4\ntimelib==0.2.4" > /tmp/mwlib/requirements.txt &&\
    git clone --depth 1 -b 0.14.6 https://github.com/pediapress/mwlib.rl.git mwlib.rl &&\
    git clone --depth 1 -b 0.14.3 https://github.com/pediapress/mwlib.epub.git mwlib.epub &&\
    sed -i "s/, 'ordereddict'//g" /tmp/mwlib.epub/setup.py &&\
    sed -i "s/from ordereddict/from collections/g" /tmp/mwlib.epub/mwlib/epub/collection.py &&\
    for m in mwlib mwlib.rl mwlib.epub ; do cd $m &&\
    python setup.py install && cd .. ; done && \
    apt-get remove -y cython g++ gcc gettext git make ocaml-nox python-dev \
        python-pip python-wheel re2c &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /root/* &&\
    ln -sfT /dev/stdout /var/log/supervisord.log &&\
    mkdir -p /var/cache/mwlib

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY customconfig.py /usr/local/lib/python2.7/dist-packages/customconfig.py
RUN python -m compileall /usr/local/lib/python2.7/dist-packages/customconfig.py

VOLUME /var/cache/mwlib
EXPOSE 8899

#CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
CMD ["/bin/bash", "-c", "nserve & mw-qserve & nslave --cachedir /var/cache/mwlib & postman --cachedir /var/cache/mwlib"]
