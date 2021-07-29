@echo off
cls
title Raspberry Pi Samba Server - Passwort aendern
set /p username="Ihr Benutzer-Name: "
set /p oldpassword="Ihr aktuelles Benutzer-Passwort: "
set /p newpassword="Ihr neues Benutzer-Passwort: "

echo.
echo Geben Sie ihr Passwort nochmals ein sobald sie dazu aufgefordert werden!
echo !!! ACHTUNG - Sie werden bei der Eingabe keine Zeichen sehen !!!
echo.

ssh raspberrypi.local -p 22 -l %username% "cd ~ && echo %oldpassword% > oldpassword && echo "%newpassword%" > newpassword && /media/Data/Samba_Share_Device/Samba_Share/ServerResources/scripts/changepassword && rm oldpassword && mv newpassword password"
pause
