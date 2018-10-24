# ############## HELPER FUNCTIONS ###############
""" Helper functions for running tests """


from model import (
    db, reset_database,
    Meet, MeetDivisionEvent, School, EventDefinition, Division,
    GENDERS, GRADES, EVENT_DEFS)

from util import info

from server import app


def init_meet(meet_info_dict, divs, events):
    # Note that this function does not set the meet's host_school_id. That
    # has to be done later.
    info("init_meet")
    meet = Meet(
            name=meet_info_dict['name'],
            date=meet_info_dict['date'],
            description=meet_info_dict.get('description', ''),
            status=meet_info_dict.get('status', 'Accepting Entries')
    )
    db.session.add(meet)
    db.session.commit()
    MeetDivisionEvent.generate_mdes(meet, divs, events)
    return meet


def init_tms():
    info("init_tms")
    School.init_unattached_school()
    divs = Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)
    events = EventDefinition.generate_event_defs(EVENT_DEFS)
    return (divs, events)


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
    db.create_all()


def teardown_test_db_app():
    info("teardown_test_db_app")
    reset_database()
