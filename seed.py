"""
Seeds the development database
"""
from flask import Flask

from model import (
    db, reset_database, connect_to_db, 
    Meet, Division, MeetDivisionEvent, EventDefinition, School,
    GENDERS, GRADES, EVENT_DEFS)

from util import info

from parse_hytek import parse_hytek_file



EXAMPLE_MEETS = (
    {
        "name": "PCAL: San Benito (Hollister) vs. Everett Alvarez",
        "date": "March 8, 2019",
        "description": """ San Benito at Everett Alvarez. Meet starts at 3pm.
        Entries must be submitted by noon the day before.
                       """,
        "status": "Accepting Entries",
        "host_school_id": 2,        # Everett Alvarez
        "filename": "MS_HtMeetEntries_43.txt"
    }, {
        "name": "PCAL: League Practice Meet #1",
        "date": "March 10, 2019",
        "description": """ Meet starts at 3pm, at Los Gatos High School.
            """,
        "status": "Accepting Entries",
        "host_school_id": 5,    # carmel
        "filename": "MS_HtMeetEntries_44.txt"
    }, {
        "name": "PCAL League Practice Meet #2",
        "date": "March 22, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 8,   # king city
        "filename": "MS_HtMeetEntries_45.txt"
    }, {
        "name": "PCAL League Practice Meet #3",
        "date": "March 22, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 9,    # marina
        "filename": "MS_HtMeetEntries_46.txt"
    }, {
        "name": "PCAL League Practice Meet #4",
        "date": "March 29, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 14,    # soledad
        "filename": "MS_HtMeetEntries_47.txt"
    }, {
        "name": "PCAL League Practice Meet #5",
        "date": "April 5, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 25,       # pajaro valley
        "filename": "MS_HtMeetEntries_48.txt"
    }, {
        "name": "PCAL League Practice Meet #6",
        "date": "April 12, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 8,    # king city
        "filename": "MS_HtMeetEntries_49.txt"
    }, {
        "name": "PCAL League Practice Meet #7",
        "date": "April 17, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 5,    # carmel
        "filename": "MS_HtMeetEntries_50.txt"
    }, {
        "name": "PCAL League Practice Meet #8",
        "date": "April 24, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 9,   # marina
        "filename": "MS_HtMeetEntries_51.txt"
    }, {
        "name": "PCAL League Practice Meet #9",
        "date": "May 1, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 14,   # soledad
        "filename": "MS_HtMeetEntries_52.txt"
    }, {
        "name": "PCAL League Championships",
        "date": "May 8, 2019",
        "description": """ Meet starts at 3pm.
            """,
        "status": "Accepting Entries",
        "host_school_id": 5,    # carmel
        "filename": "MS_HtMeetEntries_53.txt"
    })

NUM_SEED_MEETS = len(EXAMPLE_MEETS)

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


if __name__ == "__main__":
    # reset database
    app = Flask(__name__)
    connect_to_db(app, "tms-dev")
    reset_database()

    # create divs & events that are standard across all our meegs
    (divs, events) = init_tms()

    num_meets = NUM_SEED_MEETS

    for i in range(num_meets):
        meet_init_info = EXAMPLE_MEETS[i]
        meet = init_meet(meet_init_info, divs, events)

        parse_hytek_file("seed_data/{}".format(meet_init_info['filename'], 
                         meet))
        meet.host_school_id = meet_init_info['host_school_id']
