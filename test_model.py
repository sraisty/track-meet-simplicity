"""
TESTS on data model in model.py
by Sue Raisty
"""

import unittest

from sqlalchemy.exc import IntegrityError, DataError

from model import (
        db, TmsApp, Division, School, EventDefinition, Meet, MeetDivisionEvent,
        Athlete, Entry, EventOrdering, DivOrdering, Heat, User,
        GENDERS, MIDDLE_SCHOOL_GRADES, GRADES, EVENT_DEFS, INFINITY_SECONDS,
        TmsError)

from server import app

from test_utils import (
    teardown_test_db_app, setup_test_app_db, EXAMPLE_MEETS)


class TestDatabaseEmpty(unittest.TestCase):
    """ These test that the database is properly resetting before
        all the tests
    """
    def setUp(self):
        setup_test_app_db()
        db.create_all()
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

    def test_heats_empty_at_init(self):
        self.assertEqual(0, Heat.query.count())

    def test_users_empty_at_init(self):
        self.assertEqual(0, User.query.count())

    def test_div_orderings_empty_at_init(self):
        self.assertEqual(0, DivOrdering.query.count())

    def test_event_ordering_empty_at_init(self):
        self.assertEqual(0, EventOrdering.query.count())


class TestMeetConstructor(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()
        TmsApp()

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
        self.assertEqual(m.status, "Unpublished")

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
                         code="RJFM",
                         city="Los Gatos",
                         state="CA")
        meet1.host_school = school1
        db.session.add(meet1)
        db.session.commit()

        m = Meet.query.first()
        self.assertEqual(m.status, "Unpublished")
        # test relationship from meet to host_school
        self.assertEqual(m.host_school.code, "RJFM")

        sch = School.query.filter_by(code="RJFM").one()
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


class TestInitMeet(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()
        TmsApp()

    def tearDown(self):
        teardown_test_db_app()

    def test_init_meet_just_gender_divs_1(self):

        meet = Meet.init_meet(
                {
                    "name": "Meet with Just a Male and Female Div & 1 event",
                    "date": "March 8, 2019",
                    "division_order": ["M", "F"],
                    "event_order": ["1600M"]
                })
        self.assertEqual(DivOrdering.query.count(), 2)
        self.assertEqual(len(meet.divisions), 2)
        self.assertEqual(meet.divisions[0].code, "M")
        self.assertEqual(meet.divisions[0].name, "Boys")
        self.assertEqual(meet.divisions[1].code, "F")
        self.assertEqual(meet.divisions[1].name, "Girls")

        self.assertEqual(EventOrdering.query.count(), 1)
        self.assertEqual(meet.events[0].name, "1600 Meter")
        self.assertEqual(meet.events[0].code, "1600M")


    def test_init_meet_just_gender_divs_2(self):
        meet = Meet.init_meet(
                {
                    "name": "Meet with Just a Male and Female Div & 1 event",
                    "date": "March 8, 2019",
                    "division_order": ["M", "F"],
                    "event_order": ["1600M"]
                },)
        self.assertEqual(MeetDivisionEvent.query.count(), 2)

        mdes = MeetDivisionEvent.query.order_by(
                    MeetDivisionEvent.seq_num)

        self.assertEqual(mdes[0].division.code, "M")
        self.assertEqual(mdes[0].division.name, "Boys")
        self.assertEqual(mdes[0].event.name, "1600 Meter")
        self.assertEqual(mdes[0].event.code, "1600M")
        self.assertEqual(mdes[0].seq_num, 1)

        self.assertEqual(mdes[1].division.code, "F")
        self.assertEqual(mdes[1].division.name, "Girls")
        self.assertEqual(mdes[1].event.name, "1600 Meter")
        self.assertEqual(mdes[1].event.code, "1600M")
        self.assertEqual(mdes[1].seq_num, 2)

    def init_small_meet_with_div_event_orders(self):
        meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['7F', '7M'],
                'event_order': ['PV', '200M', '4x400M']})

    def test_init_meet_thrice(self):
        meet0 = Meet.init_meet(EXAMPLE_MEETS[0])
        meet1 = Meet.init_meet(EXAMPLE_MEETS[1])
        meet2 = Meet.init_meet(EXAMPLE_MEETS[2])
        self.assertEqual(Meet.query.count(), 3)

    def test_init_all_meets(self):
        for meet_info in EXAMPLE_MEETS:
            meet = Meet.init_meet(meet_info)

        self.assertEqual(len(EXAMPLE_MEETS)-1,
                         Meet.query.filter(Meet.name.like("%PCAL%")).count())
        q = Meet.query.filter_by(status="Unpublished")
        self.assertEqual(q.count(), 1)
        self.assertEqual(q.first().name, "Unpublished Meet")

    def test_meet_status(self):
        pass


class TestMeetInitMdes(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_count_mdes(self):
        TmsApp()

        self.meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['7F', '7M'],
                'event_order': ['PV', '200M', '4x400M']})
        num_mdes_overall = MeetDivisionEvent.query.count()
        num_mdes_this_meet = MeetDivisionEvent.query.filter_by(
                meet=self.meet).count()
        self.assertEqual(num_mdes_overall, num_mdes_this_meet)
        self.assertEqual(num_mdes_this_meet, 6)

    def test_count_DivOrdering(self):
        TmsApp()

        self.meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['7F', '7M'],
                'event_order': ['PV', '200M', '4x400M']})
        self.assertEqual(DivOrdering.query.filter_by(
                meet=self.meet).count(), 2)

    def test_count_EventOrdering(self):
        TmsApp()
        self.meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['7F', '7M'],
                'event_order': ['PV', '200M', '4x400M']})
        self.assertEqual(EventOrdering.query.filter_by(
                meet=self.meet).count(), 3)
        self.assertEqual(EventDefinition.query.count(), len(EVENT_DEFS))

    def test_mde_sequence(self):
        TmsApp()

        self.meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['7F', '7M'],
                'event_order': ['PV', '200M', '4x400M']})
        q_mdes = MeetDivisionEvent.query.filter_by(meet=self.meet)
        mdes = q_mdes.order_by(MeetDivisionEvent.seq_num)

        self.assertEqual(mdes[0].event.code, "PV")
        self.assertEqual(mdes[0].division.code, "7F")
        self.assertEqual(mdes[1].event.code, "PV")
        self.assertEqual(mdes[1].division.code, "7M")

        self.assertEqual(mdes[2].event.code, "200M")
        self.assertEqual(mdes[2].division.code, "7F")
        self.assertEqual(mdes[3].event.code, "200M")
        self.assertEqual(mdes[3].division.code, "7M")

        self.assertEqual(mdes[4].event.code, "4x400M")
        self.assertEqual(mdes[4].division.code, "7F")
        self.assertEqual(mdes[5].event.code, "4x400M")
        self.assertEqual(mdes[5].division.code, "7M")

    def test_init_meet_no_event_div_orders(self):
        # if we don't provide dictionary with 'event_order' or 'division_order'
        # keys, then we assume the meet includes all possible EventDefinitions
        # and Divisions already defined.
        TmsApp()
        meet = Meet.init_meet({'name': 'TestMeet', 'date': "August 5, 2018"})

        num_mdes = MeetDivisionEvent.query.count()
        self.assertEqual(
                num_mdes,
                len(EVENT_DEFS) * len(GENDERS) *
                # There are also all-M and all-F divisions.  We didn't provide
                # a division_list to init_meet, so we're using ALL 8 divisions
                (len(MIDDLE_SCHOOL_GRADES) + 1))
        self.assertEqual(
                DivOrdering.query.filter_by(meet=meet).count(),
                len(GENDERS) * (len(MIDDLE_SCHOOL_GRADES)+1))
        self.assertEqual(
                EventOrdering.query.filter_by(meet=meet).count(),
                len(EVENT_DEFS))

    def test_mde_meet_division_event_relationships(self):
        TmsApp()
        self.meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['6F', '7F', '8F', '6M', '7M', '8M'],
                'event_order': ['PV', '200M', '4x400M', 'HJ']})

        g7 = Division.query.filter_by(grade="7", gender="F").one()
        hj = EventDefinition.query.filter_by(code="HJ").one()

        q = MeetDivisionEvent.query.filter_by(meet=self.meet)
        q = q.filter_by(division=g7, event=hj)
        meet_g7_hj = q.one()

        self.assertEqual(meet_g7_hj.division.code, "7F")
        self.assertEqual(meet_g7_hj.event.name, "High Jump")
        self.assertEqual(meet_g7_hj.meet.name, "TestMeet")

    def test_event_to_mde_relationship(self):
        TmsApp()
        self.meet = Meet.init_meet({
                'name': 'TestMeet',
                'date': "August 5, 2018",
                'division_order': ['6F', '7F', '8F', '6M', '7M', '8M'],
                'event_order': ['PV', '200M', '4x400M', 'HJ']})
        e = EventDefinition.query.filter_by(code="1600M").all()

class TestTmsAppInit(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_TmsApp(self):
        # everything should be empty before
        self.assertEqual(Meet.query.count(), 0)
        self.assertEqual(Athlete.query.count(), 0)
        self.assertEqual(Entry.query.count(), 0)
        self.assertEqual(Heat.query.count(), 0)
        self.assertEqual(MeetDivisionEvent.query.count(), 0)
        self.assertEqual(School.query.count(), 0)
        self.assertEqual(EventDefinition.query.count(), 0)
        self.assertEqual(EventOrdering.query.count(), 0)
        self.assertEqual(Division.query.count(), 0)
        self.assertEqual(DivOrdering.query.count(), 0)
        self.assertEqual(User.query.count(), 0)

        TmsApp()

        # After TmsApp, User, School, EventDef and Division
        # tables should have data, but no other tables.
        self.assertEqual(User.query.count(), 1)
        self.assertEqual(School.query.count(), 1)
        self.assertEqual(
                EventDefinition.query.count(), len(EVENT_DEFS))
        self.assertEqual(
            Division.query.count(),
            (len(GENDERS) * len(MIDDLE_SCHOOL_GRADES)) + len(GENDERS))

        self.assertEqual(Meet.query.count(), 0)
        self.assertEqual(Athlete.query.count(), 0)
        self.assertEqual(Entry.query.count(), 0)
        self.assertEqual(Heat.query.count(), 0)
        self.assertEqual(MeetDivisionEvent.query.count(), 0)
        self.assertEqual(EventOrdering.query.count(), 0)
        self.assertEqual(DivOrdering.query.count(), 0)


class TestAthlete(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()
        TmsApp()

    def tearDown(self):
        teardown_test_db_app()

    def test_athlete_constructor(self):

        sue = Athlete("Susan", "K", "Raisty", "F", "7")
        # school was not provided, so should be unattached
        db.session.add(sue)
        db.session.commit()

        ath = Athlete.query.filter_by(
                    fname="Susan", lname="Raisty").one()
        self.assertEqual(ath.school.name, "Unattached")
        self.assertEqual(ath.school.code, "UNA")
        self.assertIsNone(ath.phone)
        self.assertEqual(ath.division.code, "7F")
        self.assertEqual(ath.division.name, "Grade 7 Girls")

    def test_athlete_get_full_name(self):
        fullname = Athlete._get_full_name("Susan", "Kathleen", "Raisty")
        self.assertEqual("Susan K. Raisty", fullname)

        fullname = Athlete._get_full_name("Jane", "", "Doe")
        self.assertEqual(fullname, "Jane Doe")

        fullname = Athlete._get_full_name("William", "H.", "Macy")
        self.assertEqual(fullname, "William H. Macy")

        fullname = Athlete._get_full_name("William", "H", "Macy")
        self.assertEqual(fullname, "William H. Macy")

        with self.assertRaises(Exception) as cm:
            Athlete._get_full_name("", "", "Raisty")
        err = cm.exception
        self.assertEqual(str(err), "Must provide first and last name.")

        with self.assertRaises(Exception) as cm:
            Athlete._get_full_name("Susan", "", "")
        err = cm.exception
        self.assertEqual(str(err), "Must provide first and last name.")


class TestEntryMarks(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()

        TmsApp()

        self.meet = Meet.init_meet({
                'name': 'TestEntryMarks Meet',
                'date': "August 5, 2018",
                'division_order': ['7F'],
                'event_order': ['1600M', 'LJ']})

        athlete = Athlete("Sue", "K", "Raisty", "F", "7")
        db.session.add(athlete)
        db.session.commit()
        self.athlete = athlete

        self.mde_1600m = MeetDivisionEvent.query.filter_by(
                meet=self.meet,
                event_code="1600M").one()
        self.mde_longjump = MeetDivisionEvent.query.filter_by(
                meet=self.meet,
                event_code="LJ").one()


    def tearDown(self):
        teardown_test_db_app()

    def test_time_string_to_seconds_static(self):
        self.assertAlmostEqual(11.45, Entry._time_string_to_seconds('11.45'))
        self.assertAlmostEqual(61.34, Entry._time_string_to_seconds('1:01.34'))
        self.assertAlmostEqual(7201.24,
                               Entry._time_string_to_seconds('2:00:01.24'))
        self.assertAlmostEqual(3601.24,
                               Entry._time_string_to_seconds('01:00:01.24'))
        with self.assertRaises(TmsError):
            Entry._time_string_to_seconds('17.4h')

    def test_seconds_to_time_string_static(self):
        self.assertEqual("23:23:23.23", Entry._seconds_to_string(84203.23))
        self.assertEqual("1:01:01.01", Entry._seconds_to_string(3661.01))
        self.assertEqual("59:59.59", Entry._seconds_to_string(3599.592))
        self.assertEqual("4:04.04", Entry._seconds_to_string(244.04))
        self.assertEqual("58.90", Entry._seconds_to_string(58.9))
        self.assertEqual("9.93", Entry._seconds_to_string(9.93))

    def test_set_mark_with_no_mark_string_track_event(self):
        entry_1600m = Entry(mde=self.mde_1600m, athlete=self.athlete)
        db.session.add(entry_1600m)
        db.session.commit()
        entry_1600m.set_mark()

        # Test no mark provided for the event
        self.assertEqual(entry_1600m.mark, INFINITY_SECONDS)
        self.assertEqual(entry_1600m.mark_type, "seconds")
        self.assertEqual(entry_1600m.mark_to_string(), "")

    def test_set_mark_with_no_mark_string_field_event(self):
        entry_lj = Entry(mde=self.mde_longjump, athlete=self.athlete)
        db.session.add(entry_lj)
        db.session.commit()
        entry_lj.set_mark()
        self.assertEqual(entry_lj.mark, 0)
        self.assertEqual(entry_lj.mark_type, "inches")
        self.assertEqual(entry_lj.mark_to_string(), "")

    def test_field_english_string_to_inches(self):
        self.assertEqual(120, Entry._field_english_string_to_inches("10'"))
        # No ' character provided as feet symbol
        self.assertIsNone(Entry._field_english_string_to_inches("8"))
        self.assertEqual(
            1200.25, Entry._field_english_string_to_inches("100' 0.25"))
        self.assertEqual(
            90.5, Entry._field_english_string_to_inches("7' 6.5"))

    def test_none_mark_to_string(self):
        entry_lj = Entry(mde=self.mde_longjump, athlete=self.athlete)
        db.session.add(entry_lj)
        db.session.commit()
        # No mark has been set
        self.assertEqual(entry_lj.mark_to_string(), "")

        entry_1600m = Entry(mde=self.mde_1600m, athlete=self.athlete)
        db.session.add(entry_1600m)
        db.session.commit()
        self.assertEqual(entry_1600m.mark_to_string(), "")

    def test_inches_to_string_static(self):
        self.assertEqual("10' 6.00\"", Entry._inches_to_string(126.00))
        self.assertEqual("10' 0.00\"", Entry._inches_to_string(120.00))
        self.assertEqual("9.25\"", Entry._inches_to_string(9.25))
        self.assertEqual("8.00\"", Entry._inches_to_string(8))


class TestEntryToEventRelationships(unittest.TestCase):
    # TODO = Move this to the test-model file
    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()

        TmsApp()
        self.meet1 = Meet.init_meet(EXAMPLE_MEETS[0])

    def tearDown(self):
        teardown_test_db_app()

    def test_entry_to_event_relationship(self):
        veronica = Athlete("Veronica", "", "Rodriguez", "F", "6")
        self.assertIsNotNone(veronica)
        self.assertEqual(veronica.division.code, "6F")
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

class TestEventDefinition(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
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
        with self.assertRaises(DataError):
            db.session.commit()

    def test_generate_event_defs(self):
        # this usually happens as part of TmsApp()
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
        db.create_all()
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


class TestSchools(unittest.TestCase):

    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()

    def tearDown(self):
        teardown_test_db_app()

    def test_empty_before_init(self):
        num_schools = School.query.count()
        self.assertEqual(num_schools, 0)

    def test_new_school_minimal(self):
        lghs = School(name="Los Gatos High School", code="LOGA")
        db.session.add(lghs)
        db.session.commit()
        self.assertEqual(School.query.count(), 1)
        s = School.query.first()
        self.assertEqual(s.name, "Los Gatos High School")
        self.assertEqual(s.code, "LOGA")

    def test_new_school_all_info(self):
        lghs = School(name="Los Gatos High School", code="LOGA",
                      city="Los Gatos", state="CA",
                      league="BVAL", section="SCC")
        db.session.add(lghs)
        db.session.commit()
        self.assertEqual(School.query.count(), 1)
        s = School.query.first()
        self.assertEqual(s.name, "Los Gatos High School")
        self.assertEqual(s.code, "LOGA")
        self.assertEqual(s.city, "Los Gatos")
        self.assertEqual(s.state, "CA")
        self.assertEqual(s.league, "BVAL")
        self.assertEqual(s.section, "SCC")

    def test_unattached_school(self):
        School.init_unattached_school()
        unattachedSchool = School.query.get(1)
        self.assertEqual(unattachedSchool.name, "Unattached")
        self.assertEqual(unattachedSchool.code, "UNA")

    def test_host_school(self):
        TmsApp()
        lghs = School(name="Los Gatos High School", code="LOGA")
        db.session.add(lghs)
        db.session.commit()

        meet1 = Meet.init_meet({"name": "Meet #1",
                                "date": "October 28, 2018"})
        meet1.host_school = lghs
        meet2 = Meet.init_meet({"name": "Meet #2",
                                "date": "November 5, 2018"})
        meet2.host_school = lghs

        self.assertIn(meet1, lghs.meets_hosted)
        self.assertIn(meet2, lghs.meets_hosted)
        self.assertEqual(len(lghs.meets_hosted), 2)

        self.assertEqual(lghs.meets_hosted[0].name, "Meet #1")
        self.assertEqual(lghs.meets_hosted[1].name, "Meet #2")

    # def test_school_to_division_relationship(self):
    #     pass

    # def test_school_to_athlete_relationship(self):
    #     pass

    # def test_school_to_entries_relationship(self):
    #     pass


class TestDivision(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        db.create_all()
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
        # should match the "boys8" already in the databse
        q = Division.query.filter_by(gender="M", grade="8")
        self.assertEqual(q.count(), 1)
        self.assertIs(q.one(), self.boys8)

    def test_create_division_illegal_gender(self):
        with self.assertRaises(TmsError):
            mixed_gr8 = Division(gender="X", grade="8")

    def test_create_division_illegal_grade_num(self):
        with self.assertRaises(TmsError):
            boys_gr3 = Division(gender="M", grade="3")

    def test_create_division_illegal_grade_letters(self):
        with self.assertRaises(TmsError):
            boys_senior = Division(gender="M", grade="Senior")

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
        self.assertEqual(self.boys8.name, "Grade 8 Boys")

    def test_div_without_grade(self):
        div = Division(gender="F", adult_child="child")
        self.assertEqual(div.name, "Girls")
        self.assertEqual(div.code, "F")
        db.session.add(div)
        db.session.commit()

    def test_generate_grade_gender_divisions(self):

        Division.generate_grade_gender_divisions(
                grade_list=GRADES, gender_list=GENDERS)

        num_divisions = Division.query.count()
        self.assertEqual(num_divisions, len(GRADES) * len(GENDERS))

        num_divs_for_males = Division.query.filter_by(gender="M").count()
        self.assertEqual(num_divs_for_males, len(GRADES))

        num_divs_for_grade = Division.query.filter_by(grade="7").count()
        self.assertEqual(num_divs_for_grade, len(GENDERS))


# ############## HELPER FUNCTIONS ###############


if __name__ == "__main__":
    unittest.main()
