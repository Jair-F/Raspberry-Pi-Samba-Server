#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
echo "$SCRIPT_PATH"

# delete password for user
# passwd -d user
# updating the password: `openssl passwd -6`
# https://stackoverflow.com/questions/66190675/docker-set-user-password-non-interactively
# password is `pass`
# usermod -p '$6$rvUVdxrCv5S/Zknq$RQLd9FA.H/iq4gMVUIQANgPp93jOO9itv7gAecODzL/C9c5xodhhYMsITpfTCZvAlFraK94TAwmAyAXYwKjmh/' user

if [ $UID != 0 ] ; 
then
	echo "Please run as root"
	exit 1
fi

if [ ! -f "$SCRIPT_PATH/sambaUsers.back" ]
then
	echo "samba users Backup File doesnt exists - not creating users"
	exit 0
fi

echo "adding login user jair"
useradd -m -p "\$6\$rvUVdxrCv5S/Zknq\$RQLd9FA.H/iq4gMVUIQANgPp93jOO9itv7gAecODzL/C9c5xodhhYMsITpfTCZvAlFraK94TAwmAyAXYwKjmh/" \
 	-s /bin/bash -U -G sudo jair

for username in $(awk -F: '{print $1}' < "$SCRIPT_PATH/sambaUsers.back")
#while read -r username < "$(awk -F: '{print $1}' < "$SCRIPT_PATH/sambaUsers.back")"
do
	if [ "$username" == "jair" ] ; # we add him extra later
	then
		echo "skipping user jair - adding as login user later"
		continue
	fi
	echo "adding nonlogin user $username"
	#adduser -q --no-create-home --system --shell /sbin/nologin --disabled-password --disabled-login $username
	useradd --no-create-home --shell /sbin/nologin "$username"
done

# restoring samba users
pdbedit -i "smbpasswd:$SCRIPT_PATH/sambaUsers.back"

echo ""
echo "list of samba users:"
pdbedit -L -v -L


# /etc/init.d/smbd restart
# /etc/init.d/nmbd restart
