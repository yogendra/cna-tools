FROM yogendra/ubuntu:bionic
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y git vim tmux git-crypt gpg && \
    curl -L https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/dotfiles-init.Linux.sh  | bash 

CMD ["bash", "-l"]
