FROM jairf/samba_pass:latest

RUN apt update && apt upgrade -y

# dev container settings
RUN apt install -y git bash-completion fish curl wget shellcheck

RUN apt install -y vim openssh-server build-essential samba sudo net-tools iproute2
COPY ./smb.conf /etc/samba/smb.conf
RUN mkdir -p /media/Data/Samba_Share_Device
RUN mkdir /server_scripts


USER root
RUN cp -R /etc/skel/.* /root/ ; echo " "
RUN usermod -s /bin/fish root

WORKDIR /server_scripts

COPY scripts/startServer.sh /server_scripts
COPY scripts/addUsers.sh /server_scripts
RUN chmod +x /server_scripts/startServer.sh /server_scripts/addUsers.sh

ENTRYPOINT [ "/server_scripts/startServer.sh" ]
