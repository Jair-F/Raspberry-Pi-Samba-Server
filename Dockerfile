FROM jairf/samba_pass:latest
USER root

RUN apt update && apt upgrade -y
RUN apt install -y bash-completion curl wget vim samba sudo net-tools iproute2

COPY ./smb.conf /etc/samba/smb.conf
RUN mkdir /samba_server

RUN cp -R /etc/skel/.* /root/ ; echo " "

COPY . /samba_server

RUN chmod +x /samba_server/scripts/*.sh
RUN /samba_server/scripts/createFolderTree.sh "/samba_server/default_config"

ENV SAMBA_PASS_USER_CREDS_FILE=/samba_server/data/user_creds.bak
ENTRYPOINT [ "/samba_server/scripts/startServer.sh" ]
