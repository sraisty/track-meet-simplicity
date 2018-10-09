"""
Populates our database with starter data
Load up the "Constants" for our MVP's database.
"""

from model import (Meet, Athlete, Entry, School, Division, Event_Definition,
                   Event_Def_Type, MeetDivisionEvent, Gender, Grade, Sport,
                   db, connect_to_db)


EVENT_DEFS = ({"abbrev": "100M", "name": "100 Meter", "type": "sprint"},
              {"abbrev": "800M", "name": "800 Meter", "type": "sprint"},
              {"abbrev": "1600M", "name": "1600 Meter", "type": "distance"},
              {"abbrev": "4x100M", "name": "4x100 Meter Relay", "type": "relay"},
              {"abbrev": "65H", "name": "65 Meter Hurdles", "type": "sprint"},
              {"abbrev": "4x400M", "name": "4x400 Meter Relay", "type": "relay"},
              {"abbrev": "LJ", "name": "Long Jump", "type": "horzjump"},
              {"abbrev": "TJ", "name": "Triple Jump", "type": "horzjump"},
              {"abbrev": "DT", "name": "Discus Throw", "type": "throw"},
              {"abbrev": "SP", "name": "Shot Put Throw", "type": "throw"},
              {"abbrev": "HJ", "name": "High Jump", "type": "vertjump"})

EVENT_DEF_TYPES = ("sprint", "distance", "relay", "vertjump", "horzjump", "throw")

SPORTS = ("Outdoor", "Indoor", "Cross Country")

GRADES = ("6", "7", "8")

def populate_sports(sport_name_list):
    for name in sport_name_list:
        sport = Sport(name=name)
        db.session.add(sport)
    db.session.commit()


def populate_divisions():
    """ Create a division for each combination of grade & gender """

    genders = Gender.query.all()
    for gender in genders:
        grades = Grade.query.all()
        for grade in grades:
            division = Division(gender_code=gender.gender_code,
                                grade_code=grade.grade_code)
            db.session.add(division)
    db.session.commit()


def populate_schools():
    """ """
    # Delete all rows in table, so if we need to run this a second time,
    # we won't be trying to add duplicate schools
    School.query.delete()

    # In general, we're going to add schools as they start using the TMS,
    # but we need to make sure that there is always an "Unattached" school
    # in the database, no matter what.
    unattached_school = School()
    db.session.add(unattached_school)
    db.session.commit()


def populate_event_def_types(event_def_type_list):
    """ """
    for type in event_def_type_list:
        event_def_type = Event_Def_Type(name=type)
        db.session.add(event_def_type)
    db.session.commit()


def populate_event_defs(event_list):

    for ev in event_list:
        # Need to GET the event_type id
        type = Event_Def_Type.get_from_name(ev['type'])
        event_def = Event_Definition(abbrev=ev['abbrev'],
                                     name=ev['name'],
                                     event_type_id=type.id)
        db.session.add(event_def)
    db.session.commit()


def populate_genders():
    """ Setup Gender Tables with constant data for middle school"""

    male = Gender(gender_code="M", gender_name="Boys")
    female = Gender(gender_code="F", gender_name="Girls")
    db.session.add_all([male, female])
    db.session.commit()


def populate_grades(grades_list):
    """
    Setup grades tables with constant data for numbered grades between
    lowest_grade and highest_graade, inclusive
    """

    for grade_string in grades_list:
        grade = Grade(grade_code=grade_string,
                      grade_name="Grade {}".format(grade_string))
        db.session.add(grade)
    db.session.commit()


def create_a_meet():
    meet = Meet(name="My Test Meet", sport_id=1)
    db.session.add(meet)
    db.session.commit()
    populate_meet_division_events(meet)
    return meet


def populate_meet_division_events(meet):
    events = Event_Definition.query.all()
    divisions = Division.query.all()

    for event in events:
        for division in divisions:
            mde = MeetDivisionEvent(div_id=division.id,
                                    meet_id=meet.id,
                                    event_def_id=event.id)
            db.session.add(mde)
    db.session.commit()


def reset_start_data():
    # Delete all rows in tables, so if we need to run this seeding program
    # a second time, we won't be trying to add duplicate data
    db.drop_all()


def populate_start_data():
    populate_sports(SPORTS)
    populate_genders()
    populate_grades(GRADES)
    populate_divisions()
    populate_schools()
    populate_event_def_types(EVENT_DEF_TYPES)
    populate_event_defs(EVENT_DEFS)
    meet = create_a_meet()




if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    reset_start_data()
    db.create_all()

    populate_start_data()

    print("Connected to DB")
