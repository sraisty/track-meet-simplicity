"""
Populates our database with starter data
Load up the "Constants" for our MVP's database.
"""

from model import (db, connect_to_db, reset_database, Division, Gender, Grade,
                   School, Event_Def_Type, Event_Definition, Meet,
                   MeetDivisionEvent)


EVENT_DEFS = ({"abbrev": "100M", "name": "100 Meter", "type": "sprint"},
              {"abbrev": "800M", "name": "800 Meter", "type": "distance"},
              {"abbrev": "1600M", "name": "1600 Meter", "type": "distance"},
              {"abbrev": "4x100M", "name": "4x100 Meter Relay", "type": "relay"},
              {"abbrev": "65H", "name": "65 Meter Hurdles", "type": "sprint"},
              {"abbrev": "4x400M", "name": "4x400 Meter Relay", "type": "relay"},
              {"abbrev": "LJ", "name": "Long Jump", "type": "horzjump"},
              {"abbrev": "TJ", "name": "Triple Jump", "type": "horzjump"},
              {"abbrev": "DT", "name": "Discus Throw", "type": "throw"},
              {"abbrev": "SP", "name": "Shot Put Throw", "type": "throw"},
              {"abbrev": "HJ", "name": "High Jump", "type": "vertjump"})

EVENT_DEF_TYPES = ("sprint", "distance", "relay",
                   "vertjump", "horzjump", "throw")

GRADES = ("6", "7", "8")

ALLOWED_GENDERS = ({"code": "M", "name": "Boys"},
                   {"code": "F", "name": "Girls"})

EXAMPLE_MEETS = ({"name": "A Meet from the Past",
                  "date": "August 5, 2018",
                  "active": False},
                 {"name": "WVAL League Practice Meet #1",
                  "date": "April 15, 2019"},
                 {"name": "WVAL League Practice Meet #2",
                  "date": "April 25, 2019"},
                 {"name": "WVAL League Practice Meet #3",
                  "date": "May 8, 2019"},
                 {"name": "Santa Clara County Middle School Championships",
                  "date": "May 15, 2019"},
                 {"name": "Central Coast Section Middle School Championships",
                  "date": "May 31, 2019"})
########################################


def init_genders(gender_list):
    """ Setup Gender Tables with constant data for middle school"""
    for gender_dict in gender_list:
        code = gender_dict['code']
        name = gender_dict['name']
        new_gender_obj = Gender(gender_code=code, gender_name=name)
        db.session.add(new_gender_obj)
    db.session.commit()


def init_grades(grades_list):
    """
    Setup grades tables with constant data for numbered grades between
    lowest_grade and highest_graade, inclusive

    grade_string is usually something like "7" for 7th grade
    """
    for grade_string in grades_list:
        grade_obj = Grade(grade_code=grade_string,
                          grade_name="Grade {}".format(grade_string))
        db.session.add(grade_obj)
    db.session.commit()


def init_divisions():
    """ Create a division for each combination of grade & gender """

    genders = Gender.query.all()
    for gender in genders:
        grades = Grade.query.all()
        for grade in grades:
            division = Division(gender_code=gender.gender_code,
                                grade_code=grade.grade_code)
            db.session.add(division)
    db.session.commit()


def init_schools():
    """ """
    # In general, we're going to add schools as they start using the TMS,
    # but we need to make sure that there is always an "Unattached" school
    # in the database, no matter what.
    unattached_school = School()
    db.session.add(unattached_school)
    db.session.commit()


def init_event_def_types(event_def_type_list):
    """ """
    for type in event_def_type_list:
        db.session.add(Event_Def_Type(code=type))
    db.session.commit()


def init_event_defs(event_list):
    """ """
    for ev in event_list:
        db.session.add(Event_Definition(code=ev['abbrev'],
                                        name=ev['name'],
                                        etype=ev['type']))
    db.session.commit()


def populate_example_meets(meet_list):
    for meet_dict in meet_list:
        meet = Meet(name=meet_dict['name'],
                    date=meet_dict['date'])
        if not meet_dict.get('active', True):
            meet.active_status = False
        db.session.add(meet)
    db.session.commit()


def populate_mdes(meet):
    events = Event_Definition.query.all()
    divisions = Division.query.all()

    for event in events:
        for division in divisions:
            mde = MeetDivisionEvent(meet_id=meet.id,
                                    div_id=division.id,
                                    event_code=event.code)
            db.session.add(mde)
    db.session.commit()


def init_constant_data():
    init_genders(ALLOWED_GENDERS)
    init_grades(GRADES)
    init_divisions()
    init_schools()
    init_event_def_types(EVENT_DEF_TYPES)
    init_event_defs(EVENT_DEFS)


def populate_example_data():
    populate_example_meets(EXAMPLE_MEETS)
    meet1 = Meet.query.filter_by(name="WVAL League Practice Meet #1").first()
    populate_mdes(meet1)


if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    reset_database()
    db.create_all()
    init_constant_data()
