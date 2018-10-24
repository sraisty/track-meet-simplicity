"""
TESTS on data model in model.py
by Sue Raisty

"""
# from decimal import *
import unittest

from sqlalchemy.exc import IntegrityError, DataError

from model import (
        db, Division, School, EventDefinition, Meet, MeetDivisionEvent,
        Athlete, Entry, GENDERS, GRADES, EVENT_DEFS)
from server import app

from test_utils import (
    teardown_test_db_app, setup_test_app_db, init_tms, init_meet)


# We are not importing the following 'constants' from init_data because
# we don't want these unit tests to break when we one day add more events,
# more grades, etc.


EXAMPLE_MEETS = ({"name": "A Meet from the Past",
                  "date": "August 5, 2018",
                  "status": "Completed"},
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


class testDatabaseEmpty(unittest.TestCase):
    """ These test that the database is properly resetting before
        all the tests
    """
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_divisions_empty_at_init(self):
        self.assertEqual(0, Division.query.count())

    def test_events_empty_at_init(self):
        self.assertEqual(0, EventDefinition.query.count())

    def test_meets_empty_at_init(self):
        self.assertEqual(0, Meet.query.count())

    def test_mdes_empty_at_init(self):
        self.assertEqual(0, MeetDivisionEvent.query.count())

    def test_athletes_empty_at_init(self):
        self.assertEqual(0, Athlete.query.count())

    def test_entries_empty_at_init(self):
        self.assertEqual(0, Entry.query.count())

    def test_schools_empty_at_init(self):
        self.assertEqual(0, School.query.count())


class testMeet(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
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
        self.assertEqual(m.status, "Accepting Entries")

    def test_bad_create_just_name(self):
        meet1 = Meet(name="My Meet Name")
        db.session.add(meet1)
        db.session.commit()
        m = Meet.query.filter_by(name="My Meet Name").one()
        self.assertIsNone(m.date)

    def test_bad_create_just_date(self):
        meet2 = Meet(date="September 1, 2019")
        db.session.add(meet2)
        with self.assertRaises(IntegrityError):
            db.session.commit()

    def test_meet_date(self):
        # TODO
        pass

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
        self.assertEqual(m.status, "Accepting Entries")
        # test relationship from meet to host_school
        self.assertEqual(m.host_school.abbrev, "RJFM")

        sch = School.query.filter_by(abbrev="RJFM").one()
        self.assertTrue(sch)
        self.assertEqual(sch.city, "Los Gatos")
        self.assertEqual(sch.state, "CA")

    def test_create_multiple_meets(self):
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
        q = Meet.query.filter_by(status="Completed")
        self.assertEqual(q.count(), 1)
        self.assertEqual(q.first().name, "A Meet from the Past")

    def test_meet_status(self):
        pass

    def test_meet_lifecycle(self):
        pass

    def test_order_of_events(self):
        pass

    def test_order_of_divs_in_event(self):
        pass


class testMeetDivisionEvent(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

        meet1 = Meet(name="Meet #1")
        db.session.add(meet1)
        db.session.commit()
        self.meet1 = Meet.query.filter_by(name="Meet #1").one()

    def tearDown(self):
        teardown_test_db_app()

    def test_mde_generate_mdes_one_meet_and_count(self):
        Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)
        divs = Division.query.all()
        EventDefinition.generate_event_defs(EVENT_DEFS)
        events = EventDefinition.query.all()
        MeetDivisionEvent.generate_mdes(self.meet1, divs, events)
        num_mdes = MeetDivisionEvent.query.count()
        self.assertEqual(
                num_mdes, len(EVENT_DEFS) * len(GENDERS) * len(GRADES))

    def test_mde_generate_mdes_with_returned_divs_and_events(self):
        divs = Division.generate_divisions(gender_list=GENDERS,
                                           grade_list=GRADES)
        events = EventDefinition.generate_event_defs(EVENT_DEFS)
        MeetDivisionEvent.generate_mdes(self.meet1, divs, events)
        num_mdes = MeetDivisionEvent.query.count()
        self.assertEqual(
                num_mdes, len(EVENT_DEFS) * len(GENDERS) * len(GRADES))

    def test_mde_meet_division_event_relationships(self):
        divs = Division.generate_divisions(gender_list=GENDERS,
                                           grade_list=GRADES)
        events = EventDefinition.generate_event_defs(EVENT_DEFS)
        MeetDivisionEvent.generate_mdes(self.meet1, divs, events)

        g7 = Division.query.filter_by(grade="7", gender="F").one()
        hj = EventDefinition.query.filter_by(code="HJ").one()

        q = MeetDivisionEvent.query.filter_by(meet_id=self.meet1.id)
        q = q.filter_by(div_id=g7.id, event_code=hj.code)
        meet1_g7_hj = q.one()

        self.assertEqual(meet1_g7_hj.division.abbrev(), "7F")
        self.assertEqual(meet1_g7_hj.event.name, "High Jump")
        self.assertEqual(meet1_g7_hj.meet.name, "Meet #1")

        # Within Grade7 Girls, how many events are there within the whole meet
        # TODOS
        # import pdb; pdb.set_trace()
        # self.assertEqual(len(meet1_g7_hj.division.mdes), len(EVENT_DEFS))

        # self.assertIs(meet1_g7_hj.division.mdes[0], meet1_g7_hj)


class TestRelationships(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

        meet1 = Meet(name="Meet #1")
        db.session.add(meet1)
        db.session.commit()
        self.meet1 = Meet.query.filter_by(name="Meet #1").one()

        Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)
        divs = Division.query
        EventDefinition.generate_event_defs(EVENT_DEFS)
        events = EventDefinition.query
        MeetDivisionEvent.generate_mdes(self.meet1, divs, events)

    def tearDown(self):
        teardown_test_db_app()

    # def test_event_to_mde(self):
    #     pass

    # def test_mde_to_entries(self):
    #     pass

    # def test_mde_to_athletes(self):
    #     pass

    # def test_meet_to_mdes(self):
    #     pass

    # def test_meet_to_entries(self):
    #     pass

    # def test_meet_to_divisions(self):
    #     pass

    # def test_meet_to_event_defs(self):
    #     pass

    # def test_meet_to_heats(self):
    #     pass

    # def test_meet_to_athletes(self):
    #     pass

    # def test_meet_to_schools(self):
    #     pass

    # def test_meet_to_host_school(self):
    #     pass

    def test_event_to_mde_relationship(self):
        e = EventDefinition.query.filter_by(code="1600M").one()
        self.assertEqual(6, len(e.mdes))

    # def test_event_to_entries_relationship(self):
    #     pass

    # def test_event_to_meets_relationship(self):
    #     pass

    # def test_event_to_divisions_relationship(self):
    #     pass

    # def test_division_to_mdes_relationship(self):
    #     pass

    # def test_division_to_meets_relationship(self):
    #     pass

    # def test_division_to_entries_relationship(self):
    #     pass

    # def test_division_to_events_relationship(self):
    #     pass

    # def test_division_to_athletes_relationship(self):
    #     pass

    # def test_division_to_schools_relationship(self):
    #     pass


class testAthlete(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        School.init_unattached_school()
        Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)

    def tearDown(self):
        teardown_test_db_app()

    def test_Athlete_constructor(self):

        sue = Athlete("Susan", "K", "Raisty", "F", "7")
        # sue.school = unattached
        db.session.add(sue)
        db.session.commit()

        ath = Athlete.query.filter_by(
                    fname="Susan", lname="Raisty").one()
        self.assertEqual(ath.school.name, "Unattached")
        self.assertEqual(ath.school.abbrev, "UNA")
        self.assertIsNone(ath.phone)
        self.assertEqual(ath.division.abbrev(), "7F")
        self.assertEqual(ath.division.longname(), "Grade 7 Girls")

    def test_athlete_get_full_name(self):
        fullname = Athlete.get_full_name("Susan", "Kathleen", "Raisty")
        self.assertEqual("Susan K. Raisty", fullname)

        fullname = Athlete.get_full_name("Jane", "", "Doe")
        self.assertEqual(fullname, "Jane Doe")

        fullname = Athlete.get_full_name("William", "H.", "Macy")
        self.assertEqual(fullname, "William H. Macy")

        fullname = Athlete.get_full_name("William", "H", "Macy")
        self.assertEqual(fullname, "William H. Macy")

        with self.assertRaises(Exception) as cm:
            Athlete.get_full_name("", "", "Raisty")
        err = cm.exception
        self.assertEqual(str(err), "Must provide first and last name.")

        with self.assertRaises(Exception) as cm:
            Athlete.get_full_name("Susan", "", "")
        err = cm.exception
        self.assertEqual(str(err), "Must provide first and last name.")


class testEntry(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_one_entry_one_meet(self):
        pass

    def test_time_mark_conversion(self):
        self.assertAlmostEqual(11.45, Entry.time_string_to_seconds('11.45'))
        self.assertAlmostEqual(61.34, Entry.time_string_to_seconds('1:01.34'))
        self.assertAlmostEqual(7201.24,
                               Entry.time_string_to_seconds('2:00:01.24'))
        self.assertAlmostEqual(3601.24,
                               Entry.time_string_to_seconds('01:00:01.24'))

    def test_time_mark_to_string(self):
        self.assertEqual("23:23:23.23", Entry.seconds_to_time_string(84203.23))
        self.assertEqual("1:01:01.01", Entry.seconds_to_time_string(3661.01))
        self.assertEqual("59:59.59", Entry.seconds_to_time_string(3599.592))
        self.assertEqual("4:04.04", Entry.seconds_to_time_string(244.04))
        self.assertEqual("58.90", Entry.seconds_to_time_string(58.9))
        self.assertEqual("9.93", Entry.seconds_to_time_string(9.93))


class TestEntryToEventRelationships(unittest.TestCase):
    # TODO = Move this to the test-model file
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.meet1 = init_meet(EXAMPLE_MEETS[0], divs, events)

    def tearDown(self):
        teardown_test_db_app()

    def test_entry_to_event_relationship(self):
        veronica = Athlete("Veronica", "", "Rodriguez", "F", "6")
        self.assertIsNotNone(veronica)
        self.assertEqual(veronica.division.abbrev(), "6F")
        db.session.add(veronica)
        db.session.commit()

        e_code = "DT"
        mde = MeetDivisionEvent.query.filter_by(
                meet=self.meet1,
                event_code=e_code,
                div_id=veronica.division.id).one()
        entry = Entry(athlete=veronica, mde=mde)
        db.session.add(entry)
        db.session.commit()

        self.assertIsNotNone(entry.mde)
        self.assertIsNotNone(entry.athlete)
        self.assertIsNotNone(mde.entries)
        self.assertIsNotNone(veronica.entries)

        # This is the line that used to error
        self.assertEqual(entry.event, entry.mde.event)

        self.assertEqual(mde.entries[0].athlete.fname, "Veronica")


###################################

class testEventDefinition(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_new_event_definition(self):
        e = EventDefinition(code="3000S",
                            name="3000M Steeplechase",
                            etype="distance")
        db.session.add(e)
        db.session.commit()
        self.assertEqual(1, EventDefinition.query.count())
        steeple = EventDefinition.query.get("3000S")
        self.assertIsNotNone(steeple)

    def test_new_event_def_bad_type(self):
        e = EventDefinition(code="3000S",
                            name="3000M Steeplechase",
                            etype="bananas")
        db.session.add(e)

    def test_generate_event_defs(self):
        EventDefinition.generate_event_defs(EVENT_DEFS)

        q = EventDefinition.query

        e = q.get("100M")
        self.assertEqual(e.name, "100 Meter")

        jumps = q.filter(EventDefinition.name.like("%Jump%")).all()
        self.assertEqual(len(jumps), 3)

        dist_q = q.filter(EventDefinition.etype == "relay")
        self.assertEqual(dist_q.count(), 2)
        dist_events = dist_q.all()
        for e in dist_events:
            self.assertIn("Relay", e.name)


class TestEventDefinitionTypes(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

        EventDefinition.generate_event_defs(EVENT_DEFS)
        self.pv = EventDefinition.query.filter_by(code="PV").one()
        self.hj = EventDefinition.query.filter_by(code="HJ").one()
        self.i100 = EventDefinition.query.filter_by(code="100M").one()
        self.i800 = EventDefinition.query.filter_by(code="800M").one()
        self.i1600 = EventDefinition.query.filter_by(code="1600M").one()
        self.sp = EventDefinition.query.filter_by(code="SP").one()
        self.dt = EventDefinition.query.filter_by(code="DT").one()
        self.lj = EventDefinition.query.filter_by(code="LJ").one()
        self.tj = EventDefinition.query.filter_by(code="TJ").one()
        self.r4x400 = EventDefinition.query.filter_by(code="4x400M").one()
        self.r4x100 = EventDefinition.query.filter_by(code="4x400M").one()

    def tearDown(self):
        teardown_test_db_app()

    def test_is_track(self):
        self.assertTrue(self.i100.is_track())
        self.assertTrue(self.i800.is_track())
        self.assertTrue(self.i1600.is_track())
        self.assertTrue(self.r4x400.is_track())
        self.assertTrue(self.r4x100.is_track())

        self.assertFalse(self.hj.is_track())
        self.assertFalse(self.pv.is_track())
        self.assertFalse(self.dt.is_track())
        self.assertFalse(self.sp.is_track())
        self.assertFalse(self.lj.is_track())
        self.assertFalse(self.tj.is_track())

    def test_is_field(self):
        self.assertFalse(self.i100.is_field())
        self.assertFalse(self.i800.is_field())
        self.assertFalse(self.i1600.is_field())
        self.assertFalse(self.r4x400.is_field())
        self.assertFalse(self.r4x100.is_field())

        self.assertTrue(self.hj.is_field())
        self.assertTrue(self.pv.is_field())
        self.assertTrue(self.dt.is_field())
        self.assertTrue(self.sp.is_field())
        self.assertTrue(self.lj.is_field())
        self.assertTrue(self.tj.is_field())

    def test_is_indiv(self):
        self.assertFalse(self.r4x400.is_indiv())
        self.assertFalse(self.r4x100.is_indiv())

        self.assertTrue(self.i100.is_indiv())
        self.assertTrue(self.i800.is_indiv())
        self.assertTrue(self.i1600.is_indiv())
        self.assertTrue(self.hj.is_indiv())
        self.assertTrue(self.pv.is_indiv())
        self.assertTrue(self.dt.is_indiv())
        self.assertTrue(self.sp.is_indiv())
        self.assertTrue(self.lj.is_indiv())
        self.assertTrue(self.tj.is_indiv())

    def test_event_type_to_event_def_relationship(self):
        horzjumps = EventDefinition.query.filter_by(etype='horzjump').all()
        self.assertEqual(len(horzjumps), 2)
        for e in horzjumps:
            self.assertIn(e.code, ["LJ", "TJ"])


class testSchools(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

    def tearDown(self):
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
        School.init_unattached_school()
        unattachedSchool = School.query.get(1)
        self.assertEqual(unattachedSchool.name, "Unattached")
        self.assertEqual(unattachedSchool.abbrev, "UNA")

    # def test_school_to_division_relationship(self):
    #     pass

    # def test_school_to_athlete_relationship(self):
    #     pass

    # def test_school_to_entries_relationship(self):
    #     pass

    # def test_hostschool_to_meet_relationship(self):
    #     pass


class testDivision(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()

        self.boys8 = Division(gender="M", grade="8")
        self.girls6 = Division(gender="F", grade="6")
        db.session.add_all([self.boys8, self.girls6])
        db.session.commit()

    def tearDown(self):
        teardown_test_db_app()

    def test_division_duplicate(self):
        pass

    def test_division_create_and_query_get(self):
        # shoul match the boys.8 already in the databse
        q = Division.query.filter_by(gender="M", grade="8")
        self.assertEqual(q.count(), 1)
        self.assertIs(q.one(), self.boys8)

    def test_create_division_illegal_gender(self):
        mixed_gr8 = Division(gender="X", grade="8")
        db.session.add(mixed_gr8)
        with self.assertRaises(DataError):
            db.session.commit()

    def test_create_division_illegal_grade_num(self):
        boys_gr3 = Division(gender="M", grade="3")
        db.session.add(boys_gr3)
        with self.assertRaises(DataError):
            db.session.commit()

    def test_create_division_illegal_grade_letters(self):
        boys_senior = Division(gender="M", grade="Senior")
        db.session.add(boys_senior)
        with self.assertRaises(DataError):
            db.session.commit()

    def test_get_by_gender_grade(self):
        div1 = Division.query.filter_by(gender="M", grade="8").one()
        self.assertEqual(div1, self.boys8)

        div2 = Division.query.filter_by(gender="F", grade="6").one()
        self.assertEqual(div2, self.girls6)

    def test_get_by_bad_grade(self):
        with self.assertRaises(DataError):
            Division.query.filter_by(gender="F", grade="3").one()

    def test_get_by_bad_gender(self):
        with self.assertRaises(DataError):
            Division.query.filter_by(gender="X", grade="6").one()

    def test_get_div_name(self):
        self.assertEqual(self.boys8.longname(), "Grade 8 Boys")

    def test_generate_divisions(self):
        num_grades = len(GRADES)
        num_genders = len(GENDERS)
        Division.generate_divisions(grade_list=GRADES, gender_list=GENDERS)
        num_divisions = Division.query.count()
        self.assertEqual(num_divisions, num_grades * num_genders)

        num_divs_for_males = Division.query.filter_by(gender="M").count()
        self.assertEqual(num_divs_for_males, len(GRADES))

        num_divs_for_grade = Division.query.filter_by(grade="7").count()
        self.assertEqual(num_divs_for_grade, len(GENDERS))


# ############## HELPER FUNCTIONS ###############
def populate_example_meets(meet_list):
    for meet_dict in meet_list:
        meet = Meet(name=meet_dict['name'], date=meet_dict['date'],
                    status=meet_dict.get('status', 'Accepting Entries'))

        db.session.add(meet)
    db.session.commit()


if __name__ == "__main__":
    unittest.main()
