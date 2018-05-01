FROM debian:stretch

MAINTAINER Egor Puzanov

RUN set -x; apt-get update &&\
    apt-get install -y --no-install-recommends blahtexml cython g++ gcc gettext \
        git dvipng imagemagick libcxxtools-dev libcxxtools9v5 liblzma-dev liblzma5 libstdc++6 libstdc++-6-dev \
        libzim-dev libzim0v5 make ocaml-nox pdftk ploticus python-apipkg \
        python-bottle python-cssutils python-dev python-gevent python-greenlet \
        python-imaging python-lxml python-pip python-py python-pypdf2 \
        python-reportlab python-roman python-setuptools python-simplejson re2c \
        supervisor texlive-latex-recommended &&\
    cd /tmp &&\
    git clone --depth 1 -b 0.15.19 https://github.com/pediapress/mwlib.git mwlib &&\
    sed -i "s/pyparsing[^\"]*/pyparsing/g" /tmp/mwlib/setup.py &&\
    sed -i "s/odfpy[^\"]*/odfpy/g" /tmp/mwlib/setup.py &&\
    sed -i "s/if netloc[^:]*/if False/g" /tmp/mwlib/mwlib/nserve.py &&\
    git clone --depth 1 -b 0.14.6 https://github.com/pediapress/mwlib.rl.git mwlib.rl &&\
    sed -i "s/mwlib.ext[^\"]*/reportlab/g" /tmp/mwlib.rl/setup.py &&\
    sed -i "s/fonts/fonts\", \"mwlib.ext/g" /tmp/mwlib.rl/setup.py &&\
    mkdir /tmp/mwlib.rl/mwlib/ext &&\
    touch /tmp/mwlib.rl/mwlib/ext/__init__.py &&\
    echo "include mwlib/ext/__init__.py" >> /tmp/mwlib.rl/MANIFEST.in &&\
    git clone --depth 1 -b 0.14.3 https://github.com/pediapress/mwlib.epub.git mwlib.epub &&\
    sed -i "s/, 'ordereddict'//g" /tmp/mwlib.epub/setup.py &&\
    sed -i "s/from ordereddict/from collections/g" /tmp/mwlib.epub/mwlib/epub/collection.py &&\
#    git clone --depth 1 -b 0.3.0 https://github.com/pediapress/pyzim.git pyzim &&\
#    git clone --depth 1 -b 0.2.1 https://github.com/pediapress/mwlib.zim.git mwlib.zim &&\
    for m in mwlib mwlib.rl mwlib.epub ; do cd $m &&\
    python setup.py install && cd .. ; done && \
    apt-get remove -y cython g++ gcc gettext git libcxxtools-dev liblzma-dev \
        libstdc++-6-dev libzim-dev make ocaml-nox python-dev python-pip re2c &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* &&\
    ln -sfT /dev/stdout /var/log/supervisord.log &&\
    mkdir -p /var/cache/mwlib

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY customconfig.py /usr/local/lib/python2.7/dist-packages/customconfig.py
RUN python -m compileall /usr/local/lib/python2.7/dist-packages/customconfig.py

VOLUME /var/cache/mwlib
EXPOSE 8899

#CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
CMD ["/bin/bash", "-c", "nserve & mw-qserve & nslave --cachedir /var/cache/mwlib & postman --cachedir /var/cache/mwlib"]
