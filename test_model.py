"""
TESTS on data model in model.py
by Sue Raisty

"""
import unittest
from model import School
from populate_data import populate_start_data
from model import connect_to_db
from server import app


class testSchools(unittest.TestCase):

    def setUp(self):
        """ Stuff to do before every test """
        self.client = app.test_client()
        app.config['TESTING'] = True
        connect_to_db(app, "tms-dev")
        populate_start_data()

    def tearDown(self):
        """ Stuff to do after every test """
        pass

    def test_unattached_school(self):
        unattachedSchool = School.query.get(1)
        self.assertEqual(unattachedSchool.school_name, "Unattached")


if __name__ == "__main__":
    unittest.main()
