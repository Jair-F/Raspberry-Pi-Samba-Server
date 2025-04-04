FROM ubuntu:22.04

RUN apt update && apt upgrade -y

# dev container settings
RUN apt install -y git bash-completion fish curl wget

RUN apt install -y vim openssh-server build-essential samba sudo net-tools iproute2
COPY ./smb.conf /etc/samba/smb.conf
RUN mkdir -p /media/Data/Samba_Share_Device

COPY ./data/ /tmp/data/
RUN /bin/bash /tmp/data/addUsers.sh
RUN rm -rd /tmp/data


USER root
RUN cp -R /etc/skel/.* /root/ ; echo " "
RUN usermod -s /bin/fish root
WORKDIR /root

COPY startServer.sh ./
RUN sudo chmod +x ./startServer.sh

ENTRYPOINT [ "/bin/bash", "startServer.sh" ]
