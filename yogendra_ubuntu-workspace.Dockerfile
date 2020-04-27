FROM yogendra/ubuntu:bionic
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y git vim tmux 

CMD ["bash", "-l"]
