@echo off
cls
title Raspberry Pi Samba Server - Neustarten
echo ACHTUNG nur die Benutzer, die der Gruppe sudo angehoeren, koennen den Server neu starten
echo Nur der Administrator kann den Server herunterfahren
set /p username="Ihr Benutzer-Name: "

echo.
echo Geben Sie ihr Passwort nochmals ein sobald sie dazu aufgefordert werden!
echo !!! ACHTUNG - Sie werden bei der Eingabe keine Zeichen sehen !!!
echo.

set /p seconds="In wieviel Sekunden wollen sie den Server neu starten: "

ssh raspberrypi.local -p 22 -l %username% "/media/Data/Samba_Share_Device/Samba_Share/ServerResources/scripts/shutdown.sh"
pause
