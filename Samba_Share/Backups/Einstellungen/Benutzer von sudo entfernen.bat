@echo off
cls
title Raspberry Pi Samba Server - Benutzer von sudo entfernen
set /p username="Ihr Benutzer-Name: "
set /p username_to_make_to_sudo="Benutzername, den Sie von der Gruppe sudo entfernen wolen: "

echo.
echo Geben Sie ihr Passwort nochmals ein sobald sie dazu aufgefordert werden!
echo !!! ACHTUNG - Sie werden bei der Eingabe keine Zeichen sehen !!!
echo.

ssh raspberrypi.local -p 22 -l %username% "sudo groupmod -g sudo -d %username_to_make_to_sudo%"
pause
