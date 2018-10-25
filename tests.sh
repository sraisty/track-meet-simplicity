#!/bin/sh

# Run tests
dropdb tms-test
createdb tms-test
rm .coverage*

coverage run -p --source=. --omit="env/*" test_parse_hytek.py

coverage run -p --source=. --omit="env/*" test_model.py
coverage combine
coverage report --omit="test_*"