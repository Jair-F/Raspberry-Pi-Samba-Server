#!/bin/bash

/server_scripts/addUsers.sh

service ssh start
service smbd start
service nmbd start

/bin/bash
