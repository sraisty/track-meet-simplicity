""" testing out some SQLAlchemy Stuff """

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Enum
from util import info

db = SQLAlchemy()


genders = ('M', 'F')
grades = ('5', '6', '7', '8')
adult_child = ('adult', 'child')

divname_dict = {"child": {"M": "Boys", "F": "Girls"},
                "adult": {"M": "Men", "F": "Women"}}


gender_enum = Enum(*genders, name="gender")
grade_enum = Enum(*grades, name='grade')
adult_enum = Enum(*adult_child, name='adultchild')


class Division(db.Model):
    __tablename__ = "divisions"
    id = db.Column(db.Integer(), primary_key=True)
    gender = db.Column(gender_enum, nullable=False)
    grade = db.Column(grade_enum, nullable=True)
    adultchild = db.Column(adult_enum, default='child', nullable=False)

    def abbrev(self):
        return f"{self.grade}{self.gender}"

    def longname(self):
        return f"Grade {self.grade} {divname_dict[self.adultchild][self.gender]}"


if __name__ == "__main__":
    from server import app
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///tms-test"
    app.config["SQLALCHEMY_ECHO"] = True
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    db.app = app
    db.init_app(app)
    info("Connected to DB")
    db.create_all()
