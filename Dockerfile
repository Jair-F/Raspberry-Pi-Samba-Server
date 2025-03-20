FROM ubuntu:22.04

RUN apt update && apt upgrade -y
RUN apt install vim openssh-server build-essential samba sudo net-tools -y
ADD  ./smb.conf /etc/samba/smb.conf

# creates user with default password
RUN useradd -m -G sudo user
# delete password for user
# RUN passwd -d user

# updating the password: `openssl passwd -6`
# https://stackoverflow.com/questions/66190675/docker-set-user-password-non-interactively
# password is `pass`
RUN usermod -p '$6$rvUVdxrCv5S/Zknq$RQLd9FA.H/iq4gMVUIQANgPp93jOO9itv7gAecODzL/C9c5xodhhYMsITpfTCZvAlFraK94TAwmAyAXYwKjmh/' user

RUN mkdir -p /media/Data/Samba_Share_Device

#USER user
#WORKDIR /home/user
WORKDIR /root

ADD startServer.sh ./
RUN sudo chmod +x ./startServer.sh

ENTRYPOINT [ "/bin/bash", "startServer.sh" ]
