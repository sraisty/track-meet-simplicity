"""
Tests the parse-hytek.py file.
"""

from parse_hytek import parse_hytek_file

import unittest

from model import (
    db, reset_database, Meet, Athlete, Entry,
    Division, School, EventDefinition, MeetDivisionEvent,
    GENDERS, GRADES, EVENT_DEFS)


from server import app


EXAMPLE_MEETS = (
    {
        "name": "PCAL: San Benito (Hollister) vs. Everett Alvarez",
        "date": "March 8, 2019",
        "description": """ San Benito at Everett Alvarez. Meet starts at 3pm.
        Entries must be submitted by noon the day before.
                       """,
        "status": "Accepting Entries",
        "host_school_id": 2,
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
        "host_school_id": 25, # pajaro valley
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
        "host_school_id": 5,    #carmel    
        "filename": "MS_HtMeetEntries_53.txt"
    })

NUM_SEED_MEETS = len(EXAMPLE_MEETS)


class TestVerifyEmptyDatabase(unittest.TestCase):
    def setUp(self):
        print("testVerifyEmptyDatabase - setup")
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.meet1 = init_meet(EXAMPLE_MEETS[0], divs, events)
        # Deliberately not setting up a host_school for this meet, so we can
        # be sure the database is really empty.

    def tearDown(self):
        teardown_test_db_app()

    def test_everything_should_be_reset(self):
        self.assertEqual(Athlete.query.count(), 0)
        self.assertEqual(School.query.one().name, "Unattached")
        self.assertEqual(6, Division.query.count())
        self.assertEqual(18, EventDefinition.query.count())
        self.assertEqual(1, Meet.query.count())
        self.assertEqual(18 * 6, MeetDivisionEvent.query.count())
        self.assertEqual(0, Athlete.query.count())
        self.assertEqual(0, Entry.query.count())


class TestCreateMeet(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.meet1 = init_meet(EXAMPLE_MEETS[0], divs, events)

    def tearDown(self):
        teardown_test_db_app()

    def test_parse_just_I_lines(self):
        self.assertEqual(Athlete.query.count(), 0)
        self.assertEqual(School.query.one().name, "Unattached")
        parse_hytek_file("seed_data/HT_test1-1S-3A.txt", self.meet1)
        """
        I;Aldrich;Eric;;M;;PCS;Pacific Collegiate;;6;;;;;;;;;;;;
        I;Antonino;Kevin;;M;;PCS;Pacific Collegiate;;8;;;;;;;;;;;;
        I;Armstrong;Elizabeth;;F;10/18/2001;PCS;Pacific Collegiate;;6
        """
        self.assertEqual(Athlete.query.count(), 3)
        self.assertEqual(School.query.count(), 2)
        self.assertIsNotNone(School.query.filter_by(abbrev="PCS").one())

        q = Athlete.query
        eric = q.filter_by(fname="Eric", lname="Aldrich").one()
        kevin = q.filter_by(fname="Kevin", lname="Antonino").one()
        elizabeth = q.filter_by(fname="Elizabeth", lname="Armstrong").one()

        self.assertEqual(eric.division.abbrev(), "6M")
        self.assertEqual(kevin.division.abbrev(), "8M")
        self.assertEqual(elizabeth.division.abbrev(), "6F")
        self.assertEqual(eric.school.abbrev, "PCS")


    def test_parse_just_one_D_line(self):
        parse_hytek_file("seed_data/HT-test2-oneentry.txt", self.meet1)
        """
        D;Rodriguez;Veronica;;F;;GONZ;Gonzales;;6;DT;53' 8;E;1;;;;
        """
        self.assertEqual(Athlete.query.count(), 1)
        self.assertEqual(School.query.count(), 2)
        self.assertEqual(Entry.query.count(), 1)
        self.assertIsNotNone(School.query.filter_by(abbrev="GONZ").one())
        q = Athlete.query
        veronica = q.filter_by(fname="Veronica", lname="Rodriguez").one()
        self.assertEqual(veronica.division.abbrev(), "6F")

        v_entry = Entry.query.filter_by(athlete_id=veronica.id).one()
        self.assertEqual(v_entry.mark, 644)
        self.assertEqual(v_entry.mark_type, "inches")

        mde = MeetDivisionEvent.query.filter_by(meet_id=self.meet1.id,
                                                div_id=veronica.division.id,
                                                event_code="DT")
        self.assertEqual(v_entry.athlete, veronica)
        self.assertIn(v_entry, self.meet1.entries)
        self.assertIn(v_entry, veronica.division.entries)
        self.assertIn(v_entry, v_entry.event.entries)
        self.assertEqual(v_entry.meet.name, EXAMPLE_MEETS[0]['name'])


    def test_parse_two_D_line(self):
        # Two entries for the same athlete. Make sure we don't create
        # the athlete twice, nor create her school twice.
        # Make sure the athlete is linked to her entries.
        parse_hytek_file("seed_data/HT-test3-1M1A2E.txt", self.meet1)
        self.assertEqual(Athlete.query.count(), 1)
        self.assertEqual(School.query.count(), 2)
        self.assertEqual(Entry.query.count(), 2)

        q = Athlete.query
        veronica = q.filter_by(fname="Veronica", lname="Rodriguez").one()
        self.assertEqual(len(veronica.entries), 2)


class TestBadFile(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.divs = divs
        self.events = events

    def tearDown(self):
        teardown_test_db_app()

    def test_athlete_missing_grade(self):
        self.meet1 = init_meet(EXAMPLE_MEETS[0], self.divs, self.events)
        parse_hytek_file("seed_data/HT_test-no-grade.txt", self.meet1)

        # the athlete shoudl not have gotten added to the database 
        self.assertEqual(Athlete.query.count(), 0)

    def test_parse_one_full_file(self):
        self.meet1 = init_meet(EXAMPLE_MEETS[0], self.divs, self.events)
        parse_hytek_file(f"seed_data/{EXAMPLE_MEETS[0]['filename']}", self.meet1)
        # TODO  meet1.host_school_id = EXAMPLE_MEETS[0]['host_school_id']


class TestFillSeedDatabase(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.divs = divs
        self.events = events

    def tearDown(self):
        import pdb; pdb.set_trace()
        teardown_test_db_app()

    def test_parse_lots_big_files(self):
        # CHANGE num_meets LATER
        num_meets = NUM_SEED_MEETS
        self.assertTrue(num_meets <= len(EXAMPLE_MEETS))
        # import pdb; pdb.set_trace()
        for i in range(num_meets):
            meet_info = EXAMPLE_MEETS[i]
            # import pdb; pdb.set_trace()
            meet = init_meet(meet_info, self.divs, self.events)
            self.assertIsNotNone(meet)
            parse_hytek_file(f"seed_data/{meet_info['filename']}", meet)
            meet.host_school_id = meet_info['host_school_id']
        self.assertEqual(Meet.query.count(), num_meets)

# ############## HELPER FUNCTIONS ###############

def init_meet(meet_info_dict, divs, events):
    # Note that this function does not set the meet's host_school_id. That 
    # has to be done later.
    print("init_meet")
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
    print("init_tms")
    School.init_unattached_school()
    divs = Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)
    events = EventDefinition.generate_event_defs(EVENT_DEFS)
    return (divs, events)


def setup_test_app_db():
    """
    """
    print("setup_test_app_db")
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_ECHO"] = False
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///tms-test"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["DEBUG"] = False
    db.app = app
    db.init_app(app)
    db.create_all()


def teardown_test_db_app():
    print("teardown_test_db_app")
    reset_database()


if __name__ == "__main__":
    unittest.main()