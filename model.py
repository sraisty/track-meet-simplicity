"""
The Data model for Track Meet Simplicity
by Susan Raisty
"""


from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Athlete(db.Model):

    __tablename__ = "athletes"

    athlete_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    minitial = db.Column(db.String(1), nullable=True)
    school_id = db.Column(db.ForeignKey('schools.school_id'), nullable=False)
    div_id = db.Column(db.ForeignKey('divisions.division_id'), nullable=False)

    school = db.relationship("School")
    division = db.relationship("Division")

    entries = db.relationship("Entry")

    def __repr__(self):
        return "\nATHL# {}: {} School: {}, Div: {}".format(
                self.athlete_id,
                self.make_full_name(self.fname, self.minitial, self.lname),
                self.school_id,
                self.division.get_div_name())

    @staticmethod
    def make_full_name(fname, minitial, lname):
        """
        Creates a fullname from the first name, last name, and middle initial,
        with spaces in between. Note that middle initial might not be present,
        or it might have been passed as more than one character, in which case
        we just take the first character.

        >>> Athlete.make_full_name("Susan", "Kathleen", "Raisty")
        'Susan K. Raisty'

        >>> Athlete.make_full_name("Jane", "", "Doe")
        'Jane Doe'

        >>> Athlete.make_full_name("William", "H.", "Macy")
        'William H. Macy'

        >>> Athlete.make_full_name("William", "H", "Macy")
        'William H. Macy'
        """
        if minitial:
            return f"{fname} {minitial[0]}. {lname}"
        return f"{fname} {lname}"


class School(db.Model):
    """
    """
    __tablename__ = "schools"

    # Set up so that the "Unattached" School always uses primary key #1
    school_id = db.Column(db.Integer, primary_key=True, autoincrement=True,
                          default=1)
    school_name = db.Column(db.String(50), nullable=False, unique=True,
                            default="Unattached")
    school_city = db.Column(db.String(30), nullable=True)
    school_state = db.Column(db.String(2), nullable=True)

    athletes = db.relationship("Athlete")

    def __repr__(self):
        return "SCHOOL ID#{}: {}".format(self.school_id, self.school_name)


class Division(db.Model):
    """
    """
    __tablename__ = "divisions"

    division_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    gender_code = db.Column(db.ForeignKey("genders.gender_code"),
                            nullable=False)
    grade_code = db.Column(db.ForeignKey("grades.grade_code"), nullable=False)
    gender = db.relationship("Gender")
    grade = db.relationship("Grade")

    def __repr__(self):
        return "DIVISION ID#{}: {}".format(self.division_id,
                                           self.get_div_name())

    def get_div_name(self):
        return f"{self.grade.grade_name} {self.gender.gender_name}"


class Gender(db.Model):
    """
    In MVP, we only support 2 genders: 'M' and 'F', but there are sometimes
    "Mixed" or "Non-Binary" gender divisions.
    """
    __tablename__ = "genders"

    gender_code = db.Column(db.String(1), primary_key=True)  # "M" or "F"
    # Gender name would be "Boys" or "Girls" in MVP.
    gender_name = db.Column(db.String(10), unique=True, nullable=False)
    divisions = db.relationship("Division")

    def __repr__(self):
        return "GENDER CODE#{}: {}".format(self.gender_code, self.gender_name)


class Grade(db.Model):
    """
    In MVP, athletes must be in a grade. For now, it will be 5, 6, 7, or 8.
    But in future, for high school, it could be 9,10,11,or 12. And college:
    FR, SO, JR, SR.  So making this a 2-character 'code' and not an Integer
    """
    __tablename__ = "grades"

    grade_code = db.Column(db.String(2), primary_key=True)
    grade_name = db.Column(db.String(12), unique=True,  nullable=False)
    divisions = db.relationship("Division")

    def __repr__(self):
        return "GRADE CODE#{}: {}".format(self.grade_code, self.grade_name)


class Event(db.Model):
    """
    """
    __tablename__ = "events"

    event_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    event_abbrev = db.Column(db.String(8), unique=True, nullable=False)
    event_name = db.Column(db.String(20), unique=True, nullable=False)
    event_type_id = db.Column(db.ForeignKey("event_types.event_type_id"),
                              nullable=False)
    # TODO: Not sure about the following column. Maybe this should be
    # stored with Meet Info?
    # event_order = db.Column(db.Integer, unique=True, nullable=True)

    def __repr__(self):
        return "EVENT ID#{}: {}".format(self.grade_code, self.grade_name)


class Event_Type(db.Model):
    """
    """
    __tablename__ = "event_types"

    event_type_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    event_type_name = db.Column(db.String(8), unique=True, nullable=False)

    def __repr__(self):
        return "EVENT ID#{}: {}".format(self.grade_code, self.grade_name)

    @classmethod
    def get_from_name(cls, event_type_string):
        ev_type = cls.query.filter(cls.event_type_name == event_type_string).one()
        return ev_type


class DivisionEvent(db.Model):
    """
    Associative table to handle the many to many relationship between Events
    and Divisions.
    """
    __tablename__ = "division_events"
    div_event_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    division_id = db.Column(db.ForeignKey("divisions.division_id"),
                            nullable=False)
    event_id = db.Column(db.ForeignKey("events.event_id"),
                         nullable=False)

    # event = db.relationship("Event")
    division = db.relationship("Division")
    entries = db.relationship("Entry")


class Entry(db.Model):
    """
    A middle table. The "entries" of athletes into divisionEvents. Each athlete
    can enter multiple events within his/her division. Each division within an
    event has multiple athletes.
    Note that entering into an event doesn't mean the athlete will actually
    get assigned to run in the event.""
    """
    __tablename__ = "entries"
    entry_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    div_event_id = db.Column(db.ForeignKey("division_events.div_event_id"),
                             nullable=False)
    athlete_id = db.Column(db.ForeignKey("athletes.athlete_id"),
                           nullable=False)
    # mark = db.Column(db.Float, nullable=True)
    # mark_date = db.Column(db.Datetime, nullable=True)

    athlete = db.relationship("Athlete")
    div_event = db.relationship("DivisionEvent")
    # division = db.relationship("DivisionEvent.division")
    # event = db.relationship("DivisionEvent.event")


###############
# Helper functions


def connect_to_db(app, db_uri="tms-dev"):
    """ Connect the database to our Flask app
    """
    # Configure to use the dev version of our PostgreSQL database
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///" + db_uri
    app.config["SQLALCHEMY_ECHO"] = True
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    db.app = app
    db.init_app(app)


if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    # db.create_all()
    print("Connected to DB")
