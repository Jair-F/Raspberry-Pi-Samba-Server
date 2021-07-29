@echo off
cls
title Raspberry Pi Samba Server - Benutzer zu sudo hinzufuegen
set /p username="Ihr Benutzer-Name: "
set /p username_to_make_to_sudo="Benutzername, den Sie zur Gruppe sudo hinzufuegen wolen: "

echo.
echo Geben Sie ihr Passwort nochmals ein sobald sie dazu aufgefordert werden!
echo !!! ACHTUNG - Sie werden bei der Eingabe keine Zeichen sehen !!!
echo.

ssh raspberrypi.local -p 22 -l %username% "sudo groupmod -g sudo -a %username_to_make_to_sudo%"
pause
