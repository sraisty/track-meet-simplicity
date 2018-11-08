#!/bin/sh
echo "STARTING TMS PROJECT (via vagrant$ source ~/tms.sh)"
source ~/src/tms/secrets.sh
source ~/src/tms/env/bin/activate
cd ~/src/tms
echo "GIT STATUS:"
git status


