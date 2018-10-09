# Reset our project  completely
# cd ~/src/tms
# deactivate
# source env/bin/activate
# pip3 install -r requirements.txt

dropdb tms-dev
createdb tms-dev
python3 tms-dev < tms_seed.sql

# what about production databse?



## RUN THE DOCTESTS

#verbose:
python3 -m doctest -v *.py
#not verbose:
pythoh3 -m doctest *.py