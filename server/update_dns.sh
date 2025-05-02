#!/bin/bash

DOMAIN_PORTMAPIO=''
DOMAIN_DUCKDNS=''
TOKEN_DUCKDNS=''
IP_PORTMAPIO=$(dig +short $DOMAIN_PORTMAPIO)

echo url="https://www.duckdns.org/update?domains=$DOMAIN_DUCKDNS&token=$TOKEN_DUCKDNS&ip=$IP_PORTMAPIO" | curl -k -o ~/duckdns/duck.log -K -