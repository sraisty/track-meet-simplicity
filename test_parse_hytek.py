"""
Tests the parse-hytek.py file.
"""

from parse_hytek import parse_hytek_file

import unittest

from model import (
    Meet, Athlete, Entry, Division, School, EventDefinition, MeetDivisionEvent,
    INFINITY_SECONDS)

from server import app

from test_utils import (
    init_meet, init_tms, setup_test_app_db, teardown_test_db_app)


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

# NUM_SEED_MEETS = len(EXAMPLE_MEETS)
NUM_SEED_MEETS = 1


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


class TestParsingSmallFiles(unittest.TestCase):
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
        ath_q = Athlete.query
        veronica = ath_q.filter_by(fname="Veronica", lname="Rodriguez").one()
        self.assertEqual(veronica.division.abbrev(), "6F")

        v_entry = Entry.query.filter_by(athlete_id=veronica.id).one()
        self.assertEqual(v_entry.mark, 644)
        self.assertEqual(v_entry.mark_type, "inches")

        mde = MeetDivisionEvent.query.filter_by(meet_id=self.meet1.id,
                                                div_id=veronica.division.id,
                                                event_code="DT").one()
        self.assertIsNotNone(mde)
        self.assertIn(v_entry, mde.entries)
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
        # this file has one athlete record with an empty grade field
        parse_hytek_file("seed_data/HT_test-no-grade.txt", self.meet1)
        # the athlete should not have gotten added to the database
        self.assertEqual(Athlete.query.count(), 0)


class TestMarks(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.meet1 = init_meet(EXAMPLE_MEETS[0], divs, events)

    def tearDown(self):
        teardown_test_db_app()

    def test_no_time_mark(self):
        self.assertEqual(School.query.one().name, "Unattached")
        parse_hytek_file("seed_data/HT_test_no_time_mark.txt", self.meet1)
        holly_entry = Entry.query.one()
        self.assertEqual(holly_entry.mark, INFINITY_SECONDS)
        self.assertEqual(holly_entry.mark_type, "seconds")


class TestEntryFilesOneByOne(unittest.TestCase):
    """ Test parsing of files we've none to be problematic """
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.divs = divs
        self.events = events

    def tearDown(self):
        teardown_test_db_app()

    def test_parse_file0(self):
        meet1 = init_meet(EXAMPLE_MEETS[0], self.divs, self.events)
        parse_hytek_file(
                f"seed_data/{EXAMPLE_MEETS[0]['filename']}",
                meet1)

    def test_parse_file1(self):
        helper_file_to_meet(1, self.divs, self.events)

    def test_parse_file2(self):
        helper_file_to_meet(2, self.divs, self.events)

    def test_parse_file3(self):
        helper_file_to_meet(3, self.divs, self.events)

    def test_parse_file4(self):
        helper_file_to_meet(4, self.divs, self.events)

    def test_parse_file5(self):
        helper_file_to_meet(5, self.divs, self.events)

    def test_parse_file6(self):
        helper_file_to_meet(6, self.divs, self.events)

    def test_parse_file7(self):
        helper_file_to_meet(7, self.divs, self.events)

    def test_parse_file8(self):
        helper_file_to_meet(8, self.divs, self.events)

    def test_parse_file9(self):
        helper_file_to_meet(9, self.divs, self.events)

    def test_parse_file10(self):
        helper_file_to_meet(10, self.divs, self.events)


class TestFillSeedDatabase(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        self.client = app.test_client()
        (divs, events) = init_tms()
        self.divs = divs
        self.events = events

    def tearDown(self):
        import ipdb; ipdb.set_trace()
        teardown_test_db_app()

    def test_parse_lots_big_files(self):
        # CHANGE num_meets LATER
        num_meets = NUM_SEED_MEETS
        self.assertTrue(num_meets <= len(EXAMPLE_MEETS))
        for i in range(num_meets):
            meet_info = EXAMPLE_MEETS[i]
            meet = init_meet(meet_info, self.divs, self.events)
            self.assertIsNotNone(meet)
            parse_hytek_file(f"seed_data/{meet_info['filename']}", meet)
            meet.host_school_id = meet_info['host_school_id']
        self.assertEqual(Meet.query.count(), num_meets)


def helper_file_to_meet(example_meet_idx, divs, events):
    meet_init_info = EXAMPLE_MEETS[example_meet_idx]

    meet = init_meet(meet_init_info, divs, events)
    parse_hytek_file(f"seed_data/{meet_init_info['filename']}", meet)
    meet.host_school_id = meet_init_info['host_school_id']


if __name__ == "__main__":
    unittest.main()
