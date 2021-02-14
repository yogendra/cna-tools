FROM yogendra/ubuntu:bionic
RUN adduser --shell /bin/bash --uid 1000 --disabled-login  --gecos "" ubuntu
USER 1000
WORKDIR /home/ubuntu
CMD ["bash", "-l"]
