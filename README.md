# TrackMeetSimplicity

## Summary

## About the Developer
Spent was created by Sue Raisty, a software engineer in San Francisco, CA. Learn more about the developer on LinkedIn.

## Deployment on Amazon Lightsail
point your browser at 54.149.44.160


## Setup/Installation 
Requirements:
* PostgreSQL
* Python 3.6

To have this app running on your local computer, please follow the below steps:

Clone repository:

	$ git clone https://github.com/sraisty/track-meet-simplicity.git

Create a virtual environment:

	$ virtualenv env

Activate the virtual environment:

	$ source env/bin/activate
	
Install dependencies🔗:

	$ pip3 install -r requirements.txt

Create database 'tms-dev'.

	$ createdb tms-dev

Create your database tables and seed example data.

	$ python3 seed.py

Run the app from the command line.

	$ python3 server.py

If you want to use SQLAlchemy to query the database, run in interactive mode

	$ python3 -i model.py



## Technologies
**Tech Stack:**

* Python
* Flask
* SQLAlchemy
* Jinja2
* HTML
* CSS
* Javascript
* JQuery
* AJAX
* JSON
* Bootstrap
* Python unittest module
* BeautifulSoup
* jQuery Data Tables
* jQuery Sortable
* jQuery multi-step wizard
* FontAwesome icons



TrackMeetSimplicity is a web-based application built on a Flask server with a PostgreSQL database, with SQLAlchemy as the ORM. The front end templating uses Jinja2, the HTML was built using Bootstrap, and the Javascript uses JQuery and AJAX to interact with the backend. Server routes and the data model are tested using the Python unittest module.

Seed data was gathered using donated files in HyTek MeetManager format and by using BeautifulSoup to scrape results from Athletic.net.

## Features


## Data Model


## Shout-outs
* jQuery Data Tables
* jQuery Sortable
* jQuery multi-step wizard
* FontAwesome icons
* Coolors.com for helping me pick the color palette for this application.
* Sqlalchemy-utils

* Jamey Harris, for getting me several entry files

## For Version 2.0