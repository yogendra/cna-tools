FROM yogendra/ubuntu:lts
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y git vim tmux 

CMD ["bash", "-l"]
