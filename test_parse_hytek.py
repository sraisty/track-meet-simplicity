"""
Tests the parse-hytek.py file.
"""

import unittest

from parse_hytek import parse_hytek_file

from model import (
    Meet, Athlete, Entry, Division, School, EventDefinition, MeetDivisionEvent,
    Heat, EventOrdering, DivOrdering, User, TmsApp, db,
    INFINITY_SECONDS, EVENT_DEFS)

from server import app

from test_utils import setup_test_app_db, teardown_test_db_app

from util import error, warning, info
from seed import EXAMPLE_MEETS

NUM_SEED_MEETS = 1


class TestVerifyEmptyDatabase(unittest.TestCase):
    def setUp(self):
        info("testVerifyEmptyDatabase - setup")
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()
        self.assertEqual(0, Meet.query.count())
        self.assertEqual(0, Athlete.query.count())
        self.assertEqual(0, Entry.query.count())
        self.assertEqual(0, MeetDivisionEvent.query.count())
        self.assertEqual(0, Heat.query.count())
        self.assertEqual(0, School.query.count())
        self.assertEqual(0, EventDefinition.query.count())
        self.assertEqual(0, EventOrdering.query.count())
        self.assertEqual(0, Division.query.count())
        self.assertEqual(0, DivOrdering.query.count())
        self.assertEqual(0, User.query.count())

        TmsApp()
        self.meet1 = Meet.init_meet(EXAMPLE_MEETS[0])
        # Deliberately not setting up a host_school for this meet, so we can
        # be sure the database is really empty.

    def tearDown(self):
        teardown_test_db_app()

    def test_everything_should_be_reset(self):
        self.assertEqual(Athlete.query.count(), 0)
        self.assertEqual(School.query.one().name, "Unattached")
        self.assertEqual(8, Division.query.count())
        self.assertEqual(len(EVENT_DEFS), EventDefinition.query.count())
        self.assertEqual(1, Meet.query.count())
        self.assertEqual(18 * 6, MeetDivisionEvent.query.count())
        self.assertEqual(0, Athlete.query.count())
        self.assertEqual(0, Entry.query.count())
        self.assertEqual(18, EventOrdering.query.count())
        self.assertEqual(6, DivOrdering.query.count())
        self.assertEqual(1, User.query.count())


class TestParsingSmallFiles(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()
        TmsApp()
        self.meet1 = Meet.init_meet(EXAMPLE_MEETS[0])

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
        self.assertIsNotNone(School.query.filter_by(code="PCS").one())

        q = Athlete.query
        eric = q.filter_by(fname="Eric", lname="Aldrich").one()
        kevin = q.filter_by(fname="Kevin", lname="Antonino").one()
        elizabeth = q.filter_by(fname="Elizabeth", lname="Armstrong").one()

        self.assertEqual(eric.division.code, "6M")
        self.assertEqual(kevin.division.code, "8M")
        self.assertEqual(elizabeth.division.code, "6F")
        self.assertEqual(eric.school.code, "PCS")

    def test_parse_just_one_D_line(self):
        parse_hytek_file("seed_data/HT-test2-oneentry.txt", self.meet1)
        """
        D;Rodriguez;Veronica;;F;;GONZ;Gonzales;;6;DT;53' 8;E;1;;;;
        """
        self.assertEqual(Athlete.query.count(), 1)
        self.assertEqual(School.query.count(), 2)
        self.assertEqual(Entry.query.count(), 1)
        self.assertIsNotNone(School.query.filter_by(code="GONZ").one())
        ath_q = Athlete.query
        veronica = ath_q.filter_by(fname="Veronica", lname="Rodriguez").one()
        self.assertEqual(veronica.division.code, "6F")

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
        self.assertIn(v_entry, veronica.entries)
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
        db.create_all()
        self.client = app.test_client()
        TmsApp()

    def tearDown(self):
        teardown_test_db_app()

    def test_athlete_missing_grade(self):
        self.meet1 = Meet.init_meet(EXAMPLE_MEETS[0])
        # this file has one athlete record with an empty grade field
        parse_hytek_file("seed_data/HT_test-no-grade.txt", self.meet1)
        # the athlete should not get added to the database
        self.assertEqual(Athlete.query.count(), 0)


class TestMarks(unittest.TestCase):
    def setUp(self):
        setup_test_app_db()
        db.create_all()
        self.client = app.test_client()
        TmsApp()
        self.meet1 = Meet.init_meet(EXAMPLE_MEETS[0])

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
        db.create_all()
        self.client = app.test_client()
        TmsApp()

    def tearDown(self):
        teardown_test_db_app()

    def test_parse_file0(self):
        helper_file_to_meet(0)

    def test_parse_file1(self):
        helper_file_to_meet(1)

    # def test_parse_file2(self):
    #     helper_file_to_meet(2)

    # def test_parse_file3(self):
    #     helper_file_to_meet(3)

    # def test_parse_file4(self):
    #     helper_file_to_meet(4)

    def test_parse_file5(self):
        helper_file_to_meet(5)

    # def test_parse_file6(self):
    #     helper_file_to_meet(6)

    # def test_parse_file7(self):
    #     helper_file_to_meet(7)

    # def test_parse_file8(self):
    #     helper_file_to_meet(8)

    # def test_parse_file9(self):
    #     helper_file_to_meet(9)

    def test_parse_file10(self):
        helper_file_to_meet(10)


def helper_file_to_meet(example_meet_idx):
    meet_info_dict = EXAMPLE_MEETS[example_meet_idx]
    meet = Meet.init_meet(EXAMPLE_MEETS[example_meet_idx])
    parse_hytek_file(f"seed_data/{meet_info_dict['filename']}", meet)
    meet.host_school_id = meet_info_dict['host_school_id']


if __name__ == "__main__":
    unittest.main()
