# ############## HELPER FUNCTIONS ###############
""" Helper functions for running tests """


from model import db, reset_database
from server import app
from util import info

SMALL_TEST_MEETS = {
    "only_gender_divs": {
        "name": "Meet with Just a Male and Female Div & 3 events",
        "date": "March 8, 2019",
        "description": """ Meet with Just a Male and Female Div and 3 events
                   """,
        "status": "Unpublished",
        "host_school_id": 1,  # UNA
        "division_order": ["M", "F"],
        "event_order": ["1600M", "100M", "LJ"],
        "filename": "",
    },
    "only_2_grades": {
        "name": "Just 2 grades and 2 events",
        "date": "March 8, 2019",
        "description": """ Just 2 grades and 2 events
                   """,
        "status": "Unpublished",
        "host_school_id": 1,  # UNA
        "division_order": ["7F", "8F", "7M", "8M"],
        "event_order": ["100M"],
        "filename": "",
    }
}

EXAMPLE_MEETS = (
    {
        "name": "PCAL: San Benito (Hollister) vs. Everett Alvarez",
        "date": "March 8, 2019",
        "description": """ San Benito at Everett Alvarez. Meet starts at 3pm.
        Entries must be submitted by noon the day before.
                       """,
        "status": "Accepting Entries",
        "host_school_id": 2,        # Everett Alvarez
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_43.txt",
    }, {
        "name": "PCAL: League Practice Meet #1",
        "date": "March 10, 2019",
        "description": """ Meet starts at 3pm, at Los Gatos High School.
            """,
        "status": "Accepting Entries",
        "host_school_id": 5,    # carmel
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_44.txt"
    }, {
        "name": "PCAL League Practice Meet #2",
        "date": "March 22, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 8,   # king city
        "division_order": ["6M", "7M", "8M", "6F", "7F", "8F"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_45.txt"
    }, {
        "name": "PCAL League Practice Meet #3",
        "date": "March 22, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 9,    # marina
        "division_order": ["8F", "7F", "6F", "8M", "7M", "6M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_46.txt"
    }, {
        "name": "PCAL League Practice Meet #4",
        "date": "March 29, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 14,    # soledad
        "division_order": ["8M", "7M", "6M", "8F", "7F", "6F"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_47.txt"
    }, {
        "name": "PCAL League Practice Meet #5",
        "date": "April 5, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 25,       # pajaro valley
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_48.txt"
    }, {
        "name": "PCAL League Practice Meet #6",
        "date": "April 12, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 8,    # king city
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_49.txt"
    }, {
        "name": "PCAL League Practice Meet #7",
        "date": "April 17, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 5,    # carmel
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_50.txt"
    }, {
        "name": "PCAL League Practice Meet #8",
        "date": "April 24, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 9,   # marina
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_51.txt"
    }, {
        "name": "PCAL League Practice Meet #9",
        "date": "May 1, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 14,   # soledad
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_52.txt"
    }, {
        "name": "PCAL League Championships",
        "date": "May 8, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 5,    # carmel
        "division_order": ["6F", "7F", "8F", "6M", "7M", "8M"],
        "event_order": ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"],
        "filename": "MS_HtMeetEntries_53.txt"
    }, {
        "name": "Unpublished Meet",
        "date": "May 8, 2019",
        "description": "",
        "status": "Unpublished",
        "host_school_id": 1,    # carmel
        "division_order": ["F", "M"],
        "event_order": ["1600M", "100H"],
        "filename": ""
    })


def setup_test_app_db():
    """
    """
    info("setup_test_app_db")
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_ECHO"] = False
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///tms-test"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["DEBUG"] = False
    db.app = app
    db.init_app(app)


def teardown_test_db_app():
    info("teardown_test_db_app")
    reset_database()
