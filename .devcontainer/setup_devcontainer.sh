#!/bin/bash

git config --global user.name Jair-F
git config --global user.email jair.fehlauer@gmail.com
git config --global core.eol lf # Forces LF line endings in the working directory for text files.

/bin/bash scripts/createFolderTree.sh "default_config"
