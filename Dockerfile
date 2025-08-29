FROM jairf/samba_pass:latest

RUN apt update && apt upgrade -y

# dev container settings
RUN apt install -y git bash-completion fish curl wget shellcheck

RUN apt install -y vim openssh-server build-essential samba sudo net-tools iproute2
COPY ./smb.conf /etc/samba/smb.conf
RUN mkdir /samba_server

USER root
RUN cp -R /etc/skel/.* /root/ ; echo " "
RUN usermod -s /bin/fish root

COPY . /samba_server

RUN chmod +x /samba_server/scripts/*.sh
RUN /samba_server/scripts/createFolderTree.sh "/samba_server/default_config"

ENV SAMBA_PASS_USER_CREDS_FILE=/samba_server/data/user_creds.bak
ENTRYPOINT [ "/samba_server/scripts/startServer.sh" ]
