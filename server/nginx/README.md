create self signed certificate

`sudo openssl req -x509 -nodes -newkey rsa:2048 -keyout ./nginx-selfsigned.key -out ./nginx-selfsigned.crt`

add in common name the domain

`sudo openssl dhparam -out ./dhparam.pem 4096`