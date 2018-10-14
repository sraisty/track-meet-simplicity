from parse_hytek import open_hytek_file

import unittest

from model import (db, reset_database, Grade, Gender, Division, School,
                   Event_Def_Type, Event_Definition, Meet, MeetDivisionEvent,
                   Athlete, Entry)
from init_data import (init_genders, init_grades, init_divisions, init_schools,
                       init_event_def_types, init_event_defs, init_constant_data,
                       populate_mdes)
from server import app

EVENT_DEFS = ({"abbrev": "100M", "name": "100 Meter", "type": "sprint"},
              {"abbrev": "200M", "name": "200 Meter", "type": "sprint"},
              {"abbrev": "400M", "name": "400 Meter", "type": "sprint"},
              {"abbrev": "800M", "name": "800 Meter", "type": "sprint"},
              {"abbrev": "1600M", "name": "1600 Meter", "type": "distance"},
              {"abbrev": "4x100M", "name": "4x100 Meter Relay", "type": "relay"},
              {"abbrev": "65H", "name": "65 Meter Hurdles", "type": "sprint"},
              {"abbrev": "4x400M", "name": "4x400 Meter Relay", "type": "relay"},
              {"abbrev": "LJ", "name": "Long Jump", "type": "horzjump"},
              {"abbrev": "TJ", "name": "Triple Jump", "type": "horzjump"},
              {"abbrev": "DT", "name": "Discus Throw", "type": "throw"},
              {"abbrev": "SP", "name": "Shot Put Throw", "type": "throw"},
              {"abbrev": "HJ", "name": "High Jump", "type": "vertjump"},
              {"abbrev": "PV", "name": "Pole Vault", "type": "vertjump"})

EVENT_DEF_TYPES = ("sprint", "distance", "relay",
                   "vertjump", "horzjump", "throw")

GRADES = ("6", "7", "8")

ALLOWED_GENDERS = ({"code": "M", "name": "Boys"},
                   {"code": "F", "name": "Girls"})


class testCreateMeet(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        # init_constant_data()
        # populate_example_meets(EXAMPLE_MEETS)

    def tearDown(self):
        """ Stuff to do after every test """
        teardown_test_db_app()



# ############## HELPER FUNCTIONS ###############

def create_active_meet(name, date_str, description, event_list,
                       gender_list, grade_list):
    meet = Meet(name=name, date=date, description=description)
    



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