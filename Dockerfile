FROM debian:buster

ENV TZ Asia/Seoul

COPY srcs/ /

RUN \
    apt-get update && \
    apt-get install -y \
		ffmpeg \
		cron \
		rtmpdump \
		tzdata && \
	chmod 0777 /record.sh


CMD bash /init.sh

VOLUME /recorded /data