FROM graag/lgogdownloader:latest
MAINTAINER Konrad Klimaszewski <graag666@gmail.com>

RUN apt-get -y update \
 && apt-get -y install git python3 python3-pip supervisor \
 && pip3 --no-cache-dir install json-logging-py gunicorn gevent \
 && cd /opt \
 && git clone https://github.com/graag/lgogwebui.git \
 && cd /opt/lgogwebui \
 && pip3 --no-cache-dir install -r requirements.txt \
 && apt-get -y remove git python3-pip \
 && apt-get -y autoremove \
 && apt-get -y --no-install-recommends install python3-pip python3-setuptools \
 && rm -rf /var/lib/apt/lists/*

# && pip install --upgrade pip setuptools \

#VOLUME ["/home/user/.cache/lgogdownloader", "/home/user/.config/lgogdownloader", "/home/user/GOG"]
WORKDIR "/home/user"

# https://sebest.github.io/post/protips-using-gunicorn-inside-a-docker-image/
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY logging.conf /etc/gunicorn/logging.conf
COPY gunicorn.conf /etc/gunicorn/gunicorn.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8585

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
