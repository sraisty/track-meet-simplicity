"""
Populates our database with starter data
Load up the "Constants" for our MVP's database.
"""

from model import (Gender, Grade, Division, School, Event_Type, Event, Entry,
                   Athlete, db, connect_to_db)


EVENT_DEFS = ({"abbrev": "100M", "name": "100 Meter", "type": "sprint"},
              {"abbrev": "800M", "name": "800 Meter", "type": "sprint"},
              {"abbrev": "1600M", "name": "1600 Meter", "type": "distance"},
              {"abbrev": "4x100M", "name": "4x100 Meter Relay", "type": "relay"},
              {"abbrev": "65H", "name": "65 Meter Hurdles", "type": "sprint"},
              {"abbrev": "4x400M", "name": "4x400 Meter Relay", "type": "relay"},
              {"abbrev": "LJ", "name": "Long Jump", "type": "horzjump"},
              {"abbrev": "TJ", "name": "Triple Jump", "type": "horzjump"},
              {"abbrev": "DS", "name": "Long Jump", "type": "horzjump"},
              {"abbrev": "TJ", "name": "Triple Jump", "type": "horzjump"},
              {"abbrev": "DT", "name": "Discus Throw", "type": "throw"},
              {"abbrev": "SP", "name": "Shot Put Throw", "type": "throw"},
              {"abbrev": "HJ", "name": "High Jump", "type": "vertjump"})


def populate_genders():
    """ Setup Gender Tables with constant data for middle school"""

    male = Gender(gender_code="M", gender_name="Boys")
    female = Gender(gender_code="F", gender_name="Girls")
    db.session.add_all([male, female])
    db.session.commit()


def populate_grades(lowest_grade, highest_grade):
    """
    Setup grades tables with constant data for numbered grades between
    lowest_grade and highest_graade, inclusive
    """

    for i in range(lowest_grade, highest_grade+1):
        gr = Grade(grade_code=str(i), grade_name="Grade {}".format(i))
        db.session.add(gr)

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


def populate_event_types():
    """ """

    for type in ("sprint", "distance", "relay", "vertjump", "horzjump", "throw"):
        event_type = Event_Type(event_type_name=type)
        db.session.add(event_type)
    db.session.commit()


def populate_event_defs(event_list):
    populate_event_types()

    for ev in event_list:
        # Need to GET the event_type id 
        event_type = Event_Type.get_from_name(ev['type'])
        event = Event(event_abbrev=ev['abbrev'],
                      event_name=ev['name'],
                      event_type_id=event_type.event_type_id)
        db.session.add(event)
    db.session.commit()


def reset_start_data():
    # Delete all rows in tables, so if we need to run this seeding program
    # a second time, we won't be trying to add duplicate data
    Entry.query.delete()
    Athlete.query.delete()
    School.query.delete()
    Event_Type.query.delete()
    Division.query.delete()
    Grade.query.delete()
    Gender.query.delete()


def populate_start_data():
    populate_genders()
    populate_grades(6, 8)
    populate_divisions()
    populate_schools()
    populate_event_defs(EVENT_DEFS)


if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    db.create_all()
    reset_start_data()
    populate_start_data()

    print("Connected to DB")
