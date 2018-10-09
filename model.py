"""
The Data model for Track Meet Simplicity
by Susan Raisty
"""


from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Meet(db.Model):
    __tablename__ = "meets"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    date = db.Column(db.DateTime, nullable=True)
    name = db.Column(db.String(50), nullable=False)
    host_school_id = db.Column(db.ForeignKey("schools.id"), nullable=True)
    sport_id = db.Column(db.ForeignKey("sports.id"),
                         nullable=False)

    sport = db.relationship("Sport")
    host_school = db.relationship("School")
    meet_division_events = db.relationship("MeetDivisionEvent")

    ### HOW DO I GET THE LIST OF DIVISION IN THE MEET???
    
    ###divisions = db.relationship("MeetDivisionEvent.division")


    def __repr__(self):
        return "\nMEET# {}: {}".format(self.id, self.name)

class Athlete(db.Model):
    """ """
    __tablename__ = "athletes"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    minitial = db.Column(db.String(1), nullable=True)
    school_id = db.Column(db.ForeignKey('schools.id'), nullable=False)
    div_id = db.Column(db.ForeignKey('divisions.id'), nullable=False)

    school = db.relationship("School")
    division = db.relationship("Division")

    entries = db.relationship("Entry")

    def __repr__(self):
        return "\nATHL# {}: {} School: {}, Div: {}".format(
                self.id,
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
        """
        if minitial:
            return f"{fname} {minitial[0]}. {lname}"
        return f"{fname} {lname}"


class Entry(db.Model):
    """
    A middle table. The "entries" of athletes into MeetDivisionEvents. Each
    athlete can enter multiple events at a meet, within his/her division.
    Each division within an event has multiple athletes.

    Note that entering into an event doesn't mean the athlete will actually
    get assigned to the event
    """
    __tablename__ = "entries"
    entry_id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    athlete_id = db.Column(db.ForeignKey("athletes.id"),
                           nullable=False)
    meet_div_event_id = db.Column(db.ForeignKey("meet_division_events.id"),
                                  nullable=False)
    # mark = db.Column(db.Float, nullable=True)
    # mark_date = db.Column(db.Datetime, nullable=True)

    athlete = db.relationship("Athlete")
    meet_div_event = db.relationship("MeetDivisionEvent")
    # division = db.relationship("MeetDivisionEvent.division")
    # event = db.relationship("MeetDivisionEvent.event")
    # meet = db.relationship("MeetDivisionEvent.meet")


class School(db.Model):
    """
    """
    __tablename__ = "schools"

    # Set up so that the "Unattached" School always uses primary key #1
    id = db.Column(db.Integer, primary_key=True,
                   autoincrement=True,
                   default=1)
    name = db.Column(db.String(50), nullable=False,
                     unique=True,
                     default="Unattached")
    city = db.Column(db.String(30), nullable=True)
    state = db.Column(db.String(2), nullable=True)
    athletes = db.relationship("Athlete")

    def __repr__(self):
        return "SCHOOL ID#{}: {}".format(self.id, self.name)



#######  THESE TABLES ARE INITIALIZED BUT NOT MODIFIED GOING FORWARD 
####### CONTAIN "Constant" Data or are used for referential integrity


class Division(db.Model):
    """
    """
    __tablename__ = "divisions"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    gender_code = db.Column(db.ForeignKey("genders.gender_code"),
                            nullable=False)
    grade_code = db.Column(db.ForeignKey("grades.grade_code"), nullable=False)
    # set up division's relationships to gender and grade tables
    gender = db.relationship("Gender")
    grade = db.relationship("Grade")


    def __repr__(self):
        """ returns human-readable representation of Division object """
        return "DIVISION ID#{}: {}".format(self.id,
                                           self.get_div_name())

    @classmethod
    def get_division(cls, gender_string, grade_num):
        """ Gets the division given the gender string (as "M" or "F"),
        and the grade as a number. Returns null if no division exists that
        matches the gender/grade combo.
        """
        division = cls.query.filter_by(gender_code=gender_string,
                                       grade_code=str(grade_num)).first()
        return division


    def get_div_name(self):
        return f"{self.grade.grade_name} {self.gender.gender_name}"


class Event_Definition(db.Model):
    """
    """
    __tablename__ = "event_defs"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    abbrev = db.Column(db.String(8), unique=True, nullable=False)
    name = db.Column(db.String(50), unique=True, nullable=False)
    event_type_id = db.Column(db.ForeignKey("event_def_types.id"),
                              nullable=False)
    type = db.relationship("Event_Def_Type")


    def __repr__(self):
        """
        Returns human-readable representation of the Event_Definition object
        """
        return "EVENT_DEF ID#{}: {} - {}. Type: {}".format(
                self.id,
                self.abbrev,
                self.name,
                self.id)


class Event_Def_Type(db.Model):
    """
    """
    __tablename__ = "event_def_types"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(8), unique=True, nullable=False)

    def __repr__(self):
        return "EVENT Def TypeID#{}: {}".format(self.id, self.name)

    @classmethod
    def get_from_name(cls, event_type_string):
        return cls.query.filter(cls.name == event_type_string).one()


class MeetDivisionEvent(db.Model):
    """
    Associative table to handle the many to many relationship between Events
    and Divisions.
    """
    __tablename__ = "meet_division_events"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    div_id = db.Column(db.ForeignKey("divisions.id"), nullable=False)
    meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    event_def_id = db.Column(db.ForeignKey("event_defs.id"),
                             nullable=False)

    # event = db.relationship("Event")
    division = db.relationship("Division")
    entries = db.relationship("Entry")
    meet = db.relationship("Meet")
    event = db.relationship("Event_Definition")
    # how do I get a relationship athletes

    def __repr__(self):
        return "\nMeetDivEvent#{}: Meet: '{}', Event: {}, Division: {}".format(
                self.id,
                self.meet.name,
                self.event.abbrev,
                self.division.get_div_name())


class Gender(db.Model):
    """
    In MVP, we only support 2 genders: 'M' and 'F'
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


class Sport(db.Model):
    """ The sports are Outdoor, Indoor, & 'Cross Country' """
    __tablename__ = "sports"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(15), nullable=False, unique=True)

    meets = db.relationship("Meet")

    def __repr__(self):
        return "SPORT#{}: {}".format(self.id, self.name)

    @classmethod
    def get_by_name(cls, name):
        return cls.query.filter_by(name=name).one()


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
