"""
Populates our database with starter data
Load up the "Constants" for our MVP's database.
"""

from model import (db, connect_to_db, reset_database, Division, Gender, Grade,
                   Meet, Athlete, Entry, School,  Event_Definition,
                   Event_Def_Type, MeetDivisionEvent)


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

EVENT_DEF_TYPES = ("sprint", "distance", "relay",
                   "vertjump", "horzjump", "throw")

GRADES = ("6", "7", "8")

ALLOWED_GENDERS = ({"code": "M", "name": "Boys"},
                   {"code": "F", "name": "Girls"})

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
    # Delete all rows in table, so if we need to run this a second time,
    # we won't be trying to add duplicate schools
    School.query.delete()

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
        # Need to GET the event_type id
        ev_type = Event_Def_Type(code=ev['type'])
        db.session.add(Event_Definition(abbrev=ev['abbrev'],
                                        name=ev['name'],
                                        event_type_code=ev_type.code))
    db.session.commit()


def create_a_meet():
    meet = Meet(name="My Test Meet")
    db.session.add(meet)
    db.session.commit()
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


def init_constant_data():
    import pdb; pdb.set_trace()
    init_genders(ALLOWED_GENDERS)
    init_grades(GRADES)
    init_divisions()
    init_schools()
    init_event_def_types(EVENT_DEF_TYPES)
    init_event_defs(EVENT_DEFS)





def populate_example_data():
    test_meet = create_a_meet()
    populate_meet_division_events(test_meet)
    sue = Athlete.newAthlete(fname="Sue", lname="Raisty",
                             gender_string="F", grade_num=7)
    test_entry = sue.enter_event(test_meet, "100M")
    return {"meet": test_meet, "athlete": sue, "entry": test_entry}


if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    reset_database()
    db.create_all()
    init_constant_data()
    print("Connected to DB")

    # This is all testing jumk
    test_objs = populate_example_data()
    meet1 = test_objs["meet"]
    sue = test_objs["athlete"]
    sue_entry1 = test_objs["entry"]
