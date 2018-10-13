"""
TESTS on data model in model.py
by Sue Raisty

"""
import unittest
# from sqlalchemy.exc import IntegrityError

from model import (db, reset_database, Grade, Gender, Division, School,
                   Event_Def_Type, Event_Definition, Meet, MeetDivisionEvent,
                   Athlete, Entry)
from init_data import (init_genders, init_grades, init_divisions, init_schools,
                       init_event_def_types, init_event_defs, init_constant_data,
                       populate_example_meets, populate_mdes, populate_example_data)
from server import app


# We are not importing the following 'constants' from init_data because
# we don't want these unit tests to break when we one day add more events,
# more grades, etc.
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


class testMeet(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        init_event_def_types(EVENT_DEF_TYPES)

    def tearDown(self):
        """ Stuff to do after every test """
        teardown_test_db_app()

    def test_create_meet(self):
        meet1 = Meet(name="WVAL League Practice Meet #1",
                     date="April 15, 2019")
        db.session.add(meet1)
        db.session.commit()
        id = meet1.id

        m = Meet.query.get(id)
        self.assertTrue(m)
        self.assertEqual(m.name, "WVAL League Practice Meet #1")
        self.assertTrue(m.active_status)

    def test_bad_create_just_name(self):
        meet1 = Meet(name="Boo")
        db.session.add(meet1)
#       self.assertRaises(IntegrityError, db.session.commit())
        try:
            db.session.commit()
        except:
            pass
        else:
            self.assertTrue(False)

        meet2 = Meet(date="September 1, 2019")
        db.session.add(meet2)
        try:
            db.session.commit()
        except:
            pass
        else:
            self.assertTrue(False)


    def test_meet_date(self):
        pass
        self.assertFalse("TODO")

    def test_create_meet_with_host_school(self):
        meet1 = Meet(name="WVAL League Practice Meet #1",
                     date="April 15, 2019")
        school1 = School(name="RJ Fisher Middle School",
                         abbrev="RJFM",
                         city="Los Gatos",
                         state="CA")
        meet1.host_school = school1
        db.session.add(meet1)
        db.session.commit()

        m = Meet.query.first()

        self.assertEqual(m.host_school.abbrev, "RJFM")
        self.assertTrue(m.active_status)

        sch = School.query.filter_by(abbrev="RJFM").one()
        self.assertTrue(sch)
        self.assertEqual(sch.city, "Los Gatos")
        self.assertEqual(sch.state, "CA")

    def test_get_meet_list(self):
        meet1 = Meet(name="WVAL League Practice Meet #1",
                     date="April 15, 2019")
        meet2 = Meet(name="WVAL League Practice Meet #2",
                     date="April 25, 2019")
        meet3 = Meet(name="WVAL League Practice Meet #3",
                     date="May 8, 2019")
        meet4 = Meet(name="Santa Clara County Middle School Championships",
                     date="May 15, 2019")
        meet5 = Meet(name="Central Coast Section Middle School Championships",
                     date="May 31, 2019")
        db.session.add_all([meet1, meet2, meet3, meet4, meet5])
        db.session.commit()
        self.assertEqual(Meet.query.count(), 5)

    def test_populate_example_meets(self):
        populate_example_meets(EXAMPLE_MEETS)
        self.assertEqual(Meet.query.count(), 6)

    def test_get_meet_selects(self):
        populate_example_meets(EXAMPLE_MEETS)
        self.assertEqual(3,
                         Meet.query.filter(Meet.name.like("%WVAL%")).count())
        q = Meet.query.filter_by(active_status=False)
        self.assertEqual(q.count(), 1)
        self.assertEqual(q.first().name, "A Meet from the Past")

    def test_meet_active_status(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_mdes(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_entries(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_divisions(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_event_defs(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_heats(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_athletes(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_schools(self):
        self.assertFalse("TODO")
        pass

    def test_meet_to_host_school(self):
        self.assertFalse("TODO")
        pass

    def test_meet_lifecycle(self):
        self.assertFalse("TODO")
        pass

    def test_order_of_events(self):
        self.assertFalse("TODO")
        pass

    def test_order_of_divs_in_event(self):
        self.assertFalse("TODO")
        pass

class testAthlete(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        # init_constant_data()
        # populate_example_meets(EXAMPLE_MEETS)

    def tearDown(self):
        """ Stuff to do after every test """
        teardown_test_db_app()

    def test_athlete_get_full_name(self):
        fullname = Athlete.get_full_name("Susan", "Kathleen", "Raisty")
        self.assertEqual("Susan K. Raisty", fullname)

        fullname = Athlete.get_full_name("Jane", "", "Doe")
        self.assertEqual(fullname, "Jane Doe")

        fullname = Athlete.get_full_name("William", "H.", "Macy")
        self.assertEqual(fullname, "William H. Macy")

        fullname = Athlete.get_full_name("William", "H", "Macy")
        self.assertEqual(fullname, "William H. Macy")

        self.assertRaises(ValueError, Athlete.get_full_name, "", "", "Raisty")
        self.assertRaises(ValueError, Athlete.get_full_name, "Susan", "", "")


class testMeetDivisionEvent(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

        init_constant_data()
        populate_example_meets(EXAMPLE_MEETS)


    def tearDown(self):
        """ Stuff to do after every test """
        teardown_test_db_app()

    def test_mde_autocreate_one_meet(self):
        meet1 = Meet.query.filter_by(name="WVAL League Practice Meet #1").one()
        populate_mdes(meet1)
        q = MeetDivisionEvent.query.filter_by(meet_id=meet1.id)
        self.assertEqual(q.count(),
                         Division.query.count() * Event_Definition.query.count())

    def test_meet_to_mde_relationship(self):
        meet1 = Meet.query.filter_by(name="WVAL League Practice Meet #1").one()
        populate_mdes(meet1)
        self.assertEqual(len(meet1.mdes), 66)

        self.assertEqual(meet1.mdes[10].gender.gender_name, 'Girls')
        self.assertEqual(meet1.mdes[10].grade.grade_name, 'Grade 7')
        self.assertEqual(meet1.mdes[10].event.name, "800 Meter")
        self.assertEqual(meet1.mdes[10].meet.name, "WVAL League Practice Meet #1")


    def test_mde_to_meet_elationship(self):
        meet1 = Meet.query.filter_by(name="WVAL League Practice Meet #1").one()
        populate_mdes(meet1)

        q = MeetDivisionEvent.query.filter_by(meet_id=meet1.id)
        q = q.filter_by(div_id=2)
        q = q.filter_by(event_code="100M")
        mde = q.first()

        self.assertEqual(mde.division.get_div_name(), "Grade 7 Boys")
        self.assertEqual(mde.gender.gender_code, "M")
        self.assertEqual(mde.grade.grade_code, "7")

    def test_event_to_mde_relationship(self):
        pass

    def test_mde_entries_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_mde_athletes_relationship(self):
        self.assertFalse("TODO")
        pass




###################################

class testEventDefinition(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        init_event_def_types(EVENT_DEF_TYPES)

    def tearDown(self):
        teardown_test_db_app()

    def test_new_event_definition(self):
        e = Event_Definition(code="3000S",
                             name="3000M Steeplechase",
                             etype="distance")
        db.session.add(e)
        db.session.commit()
        self.assertEqual(1, Event_Definition.query.count())
        steeple = Event_Definition.query.get("3000S")
        self.assertIsNotNone(steeple)

    def test_new_event_def_bad_type(self):
        e = Event_Definition(code="3000S",
                             name="3000M Steeplechase",
                             etype="bananas")
        db.session.add(e)

        # self.assertRaises(db.IntegrityError, db.session.commit())
        try:
            db.session.commit()
        except:  # TODO - compare to sqlalchemy.exc.IntegrityError
            self.assertTrue(True)
        else:
            self.assertTrue(False)

    def test_init_event_defs(self):
        init_event_defs(EVENT_DEFS)

        q = Event_Definition.query

        e = q.get("100M")
        self.assertEqual(e.name, "100 Meter")

        jumps = q.filter(Event_Definition.name.like("%Jump%")).all()
        self.assertEqual(len(jumps), 3)

        dist_q = q.filter(Event_Definition.etype == "relay")
        self.assertEqual(dist_q.count(), 2)
        dist_events = dist_q.all()
        for e in dist_events:
            self.assertIn("Relay", e.name)

    def test_event_to_mde_relationship(self):
        init_genders(ALLOWED_GENDERS)
        init_grades(GRADES)
        init_divisions()
        init_schools()
        init_event_defs(EVENT_DEFS)
        populate_example_data()

        e = Event_Definition.query.get("1600M")
        self.assertEqual(6, len(e.mdes))

    def test_event_to_entries_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_event_to_meets_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_event_to_divisions_relationship(self):
        self.assertFalse("TODO")
        pass


class testEventDefType(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        """ Stuff to do after every test """
        teardown_test_db_app()

    def test_new_event_def_type(self):
        edt = Event_Def_Type(code="distance")
        db.session.add(edt)
        db.session.commit()
        self.assertEqual(Event_Def_Type.query.count(), 1)
        e = Event_Def_Type.query.get("distance")
        self.assertIsNotNone(e)

    def test_init_event_def_types(self):
        init_event_def_types(EVENT_DEF_TYPES)
        num_types = len(EVENT_DEF_TYPES)
        self.assertEqual(num_types, Event_Def_Type.query.count())

    def test_is_track(self):
        dist = Event_Def_Type(code="distance")
        sprint = Event_Def_Type(code="sprint")
        relay = Event_Def_Type(code="relay")
        vjump = Event_Def_Type(code="vertjump")
        hjump = Event_Def_Type(code="horzjump")
        throw = Event_Def_Type(code="throw")
        db.session.add_all([dist, sprint, relay, vjump, hjump, throw])
        db.session.commit()

        self.assertTrue(dist.is_track())
        self.assertTrue(sprint.is_track())
        self.assertTrue(relay.is_track())
        self.assertFalse(vjump.is_track())
        self.assertFalse(hjump.is_track())
        self.assertFalse(throw.is_track())

    def test_is_field(self):
        dist = Event_Def_Type(code="distance")
        sprint = Event_Def_Type(code="sprint")
        relay = Event_Def_Type(code="relay")
        vjump = Event_Def_Type(code="vertjump")
        hjump = Event_Def_Type(code="horzjump")
        throw = Event_Def_Type(code="throw")
        db.session.add_all([dist, sprint, relay, vjump, hjump, throw])
        db.session.commit()

        self.assertFalse(dist.is_field())
        self.assertFalse(sprint.is_field())
        self.assertFalse(relay.is_field())
        self.assertTrue(vjump.is_field())
        self.assertTrue(hjump.is_field())
        self.assertTrue(throw.is_field())

    def test_is_indiv(self):
        dist = Event_Def_Type(code="distance")
        sprint = Event_Def_Type(code="sprint")
        relay = Event_Def_Type(code="relay")
        vjump = Event_Def_Type(code="vertjump")
        hjump = Event_Def_Type(code="horzjump")
        throw = Event_Def_Type(code="throw")
        db.session.add_all([dist, sprint, relay, vjump, hjump, throw])
        db.session.commit()

        self.assertTrue(dist.is_indiv())
        self.assertTrue(sprint.is_indiv())
        self.assertFalse(relay.is_indiv())
        self.assertTrue(vjump.is_indiv())
        self.assertTrue(hjump.is_indiv())
        self.assertTrue(throw.is_indiv())

    def test_event_type_to_event_def_relationship(self):
        init_event_def_types(EVENT_DEF_TYPES)
        init_event_defs(EVENT_DEFS)
        horzjump = Event_Def_Type.query.get('horzjump')
        self.assertEqual(len(horzjump.events), 2)
        for e in horzjump.events:
            self.assertIn(e.code, ["LJ", "TJ"])


class testSchools(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        """ Stuff to do after every test """
        teardown_test_db_app()

    def test_empty_before_init(self):
        num_schools = School.query.count()
        self.assertEqual(num_schools, 0)

    def test_new_school_minimal(self):
        lghs = School(name="Los Gatos High School", abbrev="LOGA")
        db.session.add(lghs)
        db.session.commit()
        self.assertEqual(School.query.count(), 1)
        s = School.query.first()
        self.assertEqual(s.name, "Los Gatos High School")
        self.assertEqual(s.abbrev, "LOGA")

    def test_new_school_all_info(self):
        lghs = School(name="Los Gatos High School", abbrev="LOGA",
                      city="Los Gatos", state="CA")
        db.session.add(lghs)
        db.session.commit()
        self.assertEqual(School.query.count(), 1)
        s = School.query.first()
        self.assertEqual(s.name, "Los Gatos High School")
        self.assertEqual(s.abbrev, "LOGA")
        self.assertEqual(s.city, "Los Gatos")
        self.assertEqual(s.state, "CA")

    def test_unattached_school(self):
        init_schools()
        unattachedSchool = School.query.get(1)
        self.assertEqual(unattachedSchool.name, "Unattached")
        self.assertEqual(unattachedSchool.abbrev, "UNA")

    def test_school_to_division_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_school_to_athlete_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_school_to_entries_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_hostschool_to_meet_relationship(self):
        self.assertFalse("TODO")
        pass


class testDivision(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        init_genders(ALLOWED_GENDERS)
        init_grades(GRADES)

    def tearDown(self):
        teardown_test_db_app()

    def test_divisions_none_at_init(self):
        num_divisions = Division.query.count()
        self.assertEqual(num_divisions, 0)

    def test_division_query_create_and_get(self):
        boysGr8 = Division(gender_code="M", grade_code="8")
        db.session.add(boysGr8)
        db.session.commit()
        num_divs = Division.query.filter_by(
                   gender_code="M", grade_code="8").count()
        self.assertEqual(num_divs, 1)

    def test_create_division_illegal_gender(self):
        mixed_gr8 = Division(gender_code="X", grade_code="8")
        db.session.add(mixed_gr8)
        try:
            db.session.commit()
        except:  # TODO test for sqlalchemy.exc.IntegrityError
            self.assertTrue(True)
        else:
            self.assertTrue(False)

    def test_create_division_illegal_grade(self):
        boys_gr3 = Division(gender_code="M", grade_code="3")
        db.session.add(boys_gr3)
        try:
            db.session.commit()
        except:  # TODO test for sqlalchemy.exc.IntegrityError
            self.assertTrue(True)
        else:
            self.assertTrue(False)

    def test_get_by_gender_grade(self):
        boys8 = Division(gender_code="M", grade_code="8")
        girls6 = Division(gender_code="F", grade_code="6")
        db.session.add_all([boys8, girls6])
        db.session.commit()

        div1 = Division.get_by_gender_grade("M", "8")
        self.assertEqual(div1, boys8)

        div2 = Division.get_by_gender_grade("F", "6")
        self.assertEqual(div2, girls6)

    def test_bad_get_by_gender_grade(self):
        boys8 = Division(gender_code="M", grade_code="8")
        girls6 = Division(gender_code="F", grade_code="6")
        db.session.add_all([boys8, girls6])

        div = Division.get_by_gender_grade("M", "3")
        self.assertIsNone(div)

    def test_get_div_name(self):
        boys8 = Division(gender_code="M", grade_code="8")
        db.session.add(boys8)
        db.session.commit()
        boys8_name = boys8.get_div_name()
        self.assertEqual(boys8_name, "Grade 8 Boys")

    def test_init_divisions(self):
        num_grades = Grade.query.count()
        num_genders = Gender.query.count()
        init_divisions()
        num_divisions = Division.query.count()
        # import pdb; pdb.set_trace()
        self.assertEqual(num_divisions, num_grades * num_genders)

    def test_gender_relationship(self):
        boys8 = Division(gender_code="M", grade_code="8")
        db.session.add(boys8)
        db.session.commit()
        self.assertEqual(boys8.gender.gender_name, "Boys")

    def test_grade_relationship(self):
        boys8 = Division(gender_code="M", grade_code="8")
        db.session.add(boys8)
        db.session.commit()
        self.assertEqual(boys8.grade.grade_name, "Grade 8")

    def test_division_to_mdes_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_division_to_meets_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_division_to_entries_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_division_to_events_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_division_to_athletes_relationship(self):
        self.assertFalse("TODO")
        pass

    def test_division_to_schools_relationship(self):
        self.assertFalse("TODO")
        pass


class testGrade(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_grades_none_at_init(self):
        num_grades = Grade.query.count()
        self.assertEqual(num_grades, 0)

    def test_grade_query_get(self):
        grade7 = Grade(grade_code="7", grade_name="Grade 7")
        db.session.add(grade7)
        db.session.commit()
        gr = Grade.query.get("7")
        self.assertEqual(gr.grade_code, "7")
        self.assertEqual(gr.grade_name, "Grade 7")

    def test_grade_query_one(self):
        grade7 = Grade(grade_code="7", grade_name="Grade 7")
        db.session.add(grade7)
        db.session.commit()
        gr = Grade.query.filter_by(grade_code="7").one()
        self.assertTrue(gr)

    def test_grade_query_duplicate_insert(self):
        # TODO - Do a better job of testing that the exception raised is the
        # right one
        grade7 = Grade(grade_code="7", grade_name="Grade 7")
        db.session.add(grade7)
        db.session.commit()
        another_grade7 = Grade(grade_code="7", grade_name="Another Grade 7")
        db.session.add(another_grade7)
        try:
            db.session.commit()
        except:  # TODO - more specific Except
            # Should sqlalchemy.orm.exc.FlushError from trying to
            # insert item with already-used primary key
            self.assertTrue(True)
        else:
            self.assertTrue(False)

    def test_init_grades_num_recs(self):
        init_grades(GRADES)
        num_grades = Grade.query.count()
        self.assertEqual(num_grades, 3)

    def test_init_grades_num_recs_by_grade(self):
        init_grades(GRADES)
        gr6 = Grade.query.filter_by(grade_code="6").one()
        self.assertEqual(gr6.grade_name, "Grade 6")
        gr7 = Grade.query.filter_by(grade_code="7").one()
        self.assertEqual(gr7.grade_name, "Grade 7")
        gr8 = Grade.query.filter_by(grade_code="8").one()
        self.assertEqual(gr8.grade_name, "Grade 8")

    def test_grade_to_div_relationship(self):
        init_genders(ALLOWED_GENDERS)
        init_grades(GRADES)
        init_divisions()

        gr7 = Grade.query.get("7")
        gr7_divs = gr7.divisions

        self.assertEqual(len(ALLOWED_GENDERS), len(gr7_divs))
        self.assertEqual(len(gr7_divs), 2)
        for div in gr7_divs:
            self.assertIn('Grade 7', div.get_div_name())

    def test_grade_to_mde_relationship(self):
        init_constant_data()
        populate_example_meets(EXAMPLE_MEETS)
        meet1 = Meet.query.first()
        populate_mdes(meet1)

        gr7 = Grade.query.get("7")
        self.assertEqual(len(gr7.mdes), 22)


class testGender(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_gender_none_at_init(self):
        num_genders = Gender.query.count()
        self.assertEqual(num_genders, 0)

    def test_gender_repr(self):
        boys = Gender(gender_code="M", gender_name="Boys")
        self.assertEqual(boys.__repr__(), "GENDER: M, Boys")

    def test_gender_query_get(self):
        boys = Gender(gender_code="M", gender_name="Boys")
        db.session.add(boys)
        db.session.commit()
        b = Gender.query.get("M")
        self.assertEqual(b.gender_code, "M")
        self.assertEqual(b.gender_name, "Boys")

    def test_gender_query_one(self):
        boys = Gender(gender_code="M", gender_name="Boys")
        girls = Gender(gender_code="F", gender_name="Girls")
        mixed = Gender(gender_code="X", gender_name="Mixed")
        db.session.add_all([boys, girls, mixed])
        db.session.commit()
        b = Gender.query.filter_by(gender_code="M").one()
        self.assertTrue(b)
        g = Gender.query.filter_by(gender_code="F").one()
        self.assertTrue(g)
        m = Gender.query.filter_by(gender_code="X").one()
        self.assertTrue(m)

    def test_gender_no_extra_rows(self):
        boys = Gender(gender_code="M", gender_name="Boys")
        girls = Gender(gender_code="F", gender_name="Girls")
        mixed = Gender(gender_code="X", gender_name="Mixed")
        db.session.add_all([boys, girls, mixed])
        db.session.commit()
        num_genders = Gender.query.count()
        self.assertEqual(num_genders, 3)

    def test_gender_query_duplicate_insert(self):
        # TODO - Do a better job of testing that the exception raised is the
        # right one
        girls = Gender(gender_code="F", gender_name="Girls")
        db.session.add(girls)
        db.session.commit()
        women = Gender(gender_code="F", gender_name="Women")
        db.session.add(women)
        try:
            db.session.commit()
        except:
            # sqlalchemy.orm.exc.FlushError should result from trying to
            # insert item with already-used primary key, (Females)
            self.assertTrue(True)
        else:
            self.assertTrue(False)

    def test_init_genders_num_recs(self):
        init_genders(ALLOWED_GENDERS)
        num_genders = Gender.query.count()
        self.assertEqual(num_genders, 2)

    def test_init_genders_rec_vals(self):
        init_genders(ALLOWED_GENDERS)

        boys = Gender.query.filter_by(gender_code="M").one()
        self.assertEqual(boys.gender_code, "M")
        self.assertEqual(boys.gender_name, "Boys")

        girls = Gender.query.filter_by(gender_code="F").one()
        self.assertEqual(girls.gender_code, "F")
        self.assertEqual(girls.gender_name, "Girls")

    def test_gender_to_div_relationship(self):
        init_genders(ALLOWED_GENDERS)
        init_grades(GRADES)
        init_divisions()

        male = Gender.query.get("M")
        male_divs = male.divisions

        self.assertEqual(len(GRADES), len(male_divs))
        self.assertEqual(len(male_divs), 3)

        for div in male_divs:
            self.assertIn('Boys', div.get_div_name())

    def test_gender_to_mde_relationship(self):
        init_constant_data()
        populate_example_meets(EXAMPLE_MEETS)
        meet1 = Meet.query.first()
        populate_mdes(meet1)

        male=Gender.query.get("M")
        self.assertEqual(len(male.mdes), 33)




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
