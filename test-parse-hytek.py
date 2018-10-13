from parse_hytek import open_hytek_file

import unittest

from model import (db, reset_database, Grade, Gender, Division, School,
                   Event_Def_Type, Event_Definition, Meet, MeetDivisionEvent,
                   Athlete, Entry)
from init_data import (init_genders, init_grades, init_divisions, init_schools,
                       init_event_def_types, init_event_defs, init_constant_data,
                       populate_mdes)
from server import app






# ############## HELPER FUNCTIONS ###############


def setup_test_app_db():
    """
    """
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_ECHO"] = False
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///tms-test"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["DEBUG"] = False
    db.app = app
    db.init_app(app)
    db.create_all()


def teardown_test_db_app():
    reset_database()


if __name__ == "__main__":
    unittest.main()