"""
TESTS on data model in model.py
by Sue Raisty

"""
import unittest

from model import db, reset_database, Grade, Gender, Division, School
from init_data import (init_genders, init_grades, init_divisions, init_schools,
                       GRADES, ALLOWED_GENDERS)
from server import app
from util import info


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
        pass

    def test_school_to_athlete_relationship(self):
        pass

    def test_school_to_entries_relationship(self):
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
        num_divs = Division.query.filter_by(gender_code="M", grade_code="8").count()
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

    def test_division_to_mdes_relationship():
        pass

    def test_division_to_meets_relationship():
        pass

    def test_division_to_athletes_relationship():
        pass

    def test_division_to_schools_relationship():
        pass

    def test_division_to_entries_relationship():
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
        num_grades = Grade.query.count
        self.assertEqual(num_grades, 3)

    def test_init_grades_num_recs(self):
        init_grades(GRADES)
        gr6 = Grade.query.filter_by(grade_code="6").one()
        self.assertEqual(gr6.grade_name, "Grade 6")
        gr7 = Grade.query.filter_by(grade_code="7").one()
        self.assertEqual(gr7.grade_name, "Grade 7")
        gr8 = Grade.query.filter_by(grade_code="8").one()
        self.assertEqual(gr8.grade_name, "Grade 8")

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
