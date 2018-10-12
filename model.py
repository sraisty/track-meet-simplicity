"""
The Data model for Track Meet Simplicity
by Susan Raisty

NOTE: "mde" and "mdes" (plural of mde) refer to "MeetDivisionEvent"
"""


from flask_sqlalchemy import SQLAlchemy
from util import warning, error, info

db = SQLAlchemy()


# class Meet(db.Model):
#     __tablename__ = "meets"

#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     name = db.Column(db.String(50), nullable=False)
#     date = db.Column(db.DateTime, nullable=True)
#     host_school_id = db.Column(db.ForeignKey("schools.id"), nullable=True)
#     # order_of_events at meet
#     # order_of_divs_in_event
#     max_entries_per_athlete = db.Column(db.Integer, nullable=True)
#     max_team_entries_per_event = db.Column(db.Integer, nullable=True)

#     # lifecycle_code = db.Column(db.ForeignKey("lifecycles.id"),
#     #                            default="setup", nullable=False)

#     host_school = db.relationship("School")
#     mdes = db.relationship("MeetDivisionEvent")
#     events = db.relationship("Event_Definition",
#                              secondary="meet_division_events")
#     divisions = db.relationship("Division",
#                                 secondary="meet_division_events")

#     # heats

#     def __repr__(self):
#         return "\n<MEET id# {}: {}>".format(self.id, self.name)

#     def get_schools(self, no_entries=False):
#         """
#         Returns the a list of School objects who are "entered" into the Meet,
#         by virtue of having at least one athlete entered into one of its
#         DivisionEvents
#         """
#         schools_set = set()
#         athletes = self.get_athletes()
#         for athlete in athletes:
#             schools_set.add(athlete.school)
#         return list(schools_set)

#     def get_athletes(self):
#         """
#         Returns the list of Athlete objects who are entered into this meet,
#         so that none are duplicated
#         """
#         entries = self.get_entries()
#         athletes = []
#         for entry in entries:
#             athletes.append(entry.athlete)
#         return list(set(athletes))

#     def get_heat_list():
#         """
#         Returns ordered list of all of a meet's heats, from beginning of
#         meet to end of meet
#         """
#         pass

#     def get_entries(self):
#         """ get all the entries the meet (all divisions & events) """
#         entries = []
#         for mde in self.mdes:
#             entries.extend(mde.entries)
#         return list(set(entries))


# class Athlete(db.Model):
#     """ """
#     __tablename__ = "athletes"

#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     fname = db.Column(db.String(30), nullable=False)
#     lname = db.Column(db.String(30), nullable=False)
#     minitial = db.Column(db.String(1), nullable=True)
#     # TODO - Making school_id and div_id nullable so I can initially create
#     # an athlete without having these, but then quickly add them to athlete
#     # via db.relationship instead of by id.
#     school_id = db.Column(db.ForeignKey('schools.id'), nullable=True)
#     div_id = db.Column(db.ForeignKey('divisions.id'), nullable=True)
#     phone = db.Column(db.String(12), nullable=True)

#     school = db.relationship("School")
#     division = db.relationship("Division")
#     entries = db.relationship("Entry")
#     mdes = db.relationship("MeetDivisionEvent", secondary="entries")

#     def __repr__(self):
#         return "\n<ATHL# {}: {}, {}, {}>".format(
#                 self.id,
#                 self.get_full_name(self.fname, self.minitial, self.lname),
#                 self.school.__repr__(),
#                 self.division.__repr__())

#     @classmethod
#     def newAthlete(cls, fname, lname, gender_string, grade_num, minitial="",
#                    school_name="Unattached"):
#         """ Creates a new Athlete, but does more than the
#         regular SQLAlchemy class constructor. It creates the mandatory
#         relationship for school and division
#         """
#         info("Creating new athlete")
#         athlete = cls(fname=fname, minitial=minitial, lname=lname)

#         school = School.query.filter_by(name=school_name).first()
#         if school:
#             athlete.school = school
#         else:
#             warning(f"Athlete in unknown school: {school_name}")

#         div = Division.get_by_gender_grade(gender_string=gender_string,
#                                            grade_num=grade_num)
#         if div:
#             athlete.division = div
#         else:
#             warning("Athlete in unknown division. Gender={}, Grade={}".format(
#                   gender_string, grade_num))
#             # TODO: add the division?

#         # maybe we should change the "nullable" value for the school & div
#         # columns back to False?
#         db.session.add(athlete)
#         db.session.commit()
#         return athlete

#     def get_meets(self):
#         """
#         Returns the list of Meet objects where this athlete was entered
#         """
#         meets = {mde.meet for mde in self.mdes}
#         return meets

#     def get_meet_entries(self, meet):
#         """
#         Returns a non-duplicated list of the athlete's Entry objects for the
#         specied meet
#         """
#         entries_set = {mde.entries[0] for mde in self.mdes
#                        if mde.meet_id == meet.id}
#         # TODO - combine with above, but make it easier
#         return entries_set

#     def enter_event(self, meet, event_abbrev):
#         """ """
#         # Get the corresponding meet_event_div
#         query = MeetDivisionEvent.query.filter_by(meet_id=meet.id)
#         query = query.filter_by(div_id=self.division.id)
#         event_def = Event_Definition.query.filter_by(abbrev=event_abbrev).one()
#         query = query.filter_by(event_def_id=event_def.id)

#         mde = query.first()
#         if mde:
#             # TODO: Did the athlete already enter this event? If they did,
#             # warn and don't create a new Entry
#             entry = Entry(athlete_id=self.id,
#                           mde_id=mde.id)
#             self.entries.append(entry)
#             db.session.commit()
#         else:
#             error("Athlete entering non-existent event that does not exist.",
#                   "Athlete: {} {}. Event: {}, Meet: {}".format(
#                    self.fname, self.lname, event_abbrev, meet.name))

#     @staticmethod
#     def get_full_name(fname, minitial, lname):
#         """
#         Creates a fullname from the first name, last name, and middle initial,
#         with spaces in between. Note that middle initial might not be present,
#         or it might have been passed as more than one character, in which case
#         we just take the first character.

#         >>> Athlete.get_full_name("Susan", "Kathleen", "Raisty")
#         'Susan K. Raisty'

#         >>> Athlete.get_full_name("Jane", "", "Doe")
#         'Jane Doe'
#         """
#         if minitial:
#             return f"{fname} {minitial[0]}. {lname}"
#         return f"{fname} {lname}"


# class Entry(db.Model):
#     """
#     A middle object between Athlete and MeetDivisionEvent.  Each Entry object
#     has an entry of one athletes into one MeetDivisionEvent-combo object. Each
#     athlete can enter multiple events at a meet, within his/her division.
#     Each division within an event has multiple athletes.

#     Note that entering into an event doesn't mean the athlete will actually
#     get assigned to the event
#     """
#     __tablename__ = "entries"
#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)

#     athlete_id = db.Column(db.ForeignKey("athletes.id"),
#                            nullable=False)
#     mde_id = db.Column(db.ForeignKey("meet_division_events.id"),
#                        nullable=False)
#     mark_id = db.Column(db.ForeignKey("marks.id"))
#     assigned_heat_id = db.Column(db.ForeignKey("heats.id"), nullable=True)

#     athlete = db.relationship("Athlete")
#     division = db.relationship("Division",
#                                secondary="athletes",
#                                uselist=False)
#     mde = db.relationship("MeetDivisionEvent")
#     event = db.relationship("Event_Definition",
#                             secondary="meet_division_events",
#                             uselist=False)
#     meet = db.relationship("Meet",
#                            secondary="meet_division_events",
#                            uselist=False)
#     assigned_heat = db.relationship("Heat")
#     mark = db.relationship("Mark")

#     def __repr__(self):
#         return ("\n<ENTRY #{}, Ath: {} {}, Event: {}, Div: {}, Meet: {}>"
#                 .format(
#                     self.id, self.athlete.fname, self.athlete.lname,
#                     self.event.abbrev, self.division, self.meet.name))


# class Mark(db.Model):
#     __tablename__ = "marks"
#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     # All our marks should be under 99,999.00 or less (centimeters or seconds),
#     # so total digits of 7 and precision of 2 works
#     mark = db.Column(db.Numeric(7, 2), nullable=True)
#     date = db.Column(db.DateTime, nullable=True)

#     entry = db.relationship("Entry", uselist=False)
#     athlete = db.relationship("Athlete", secondary="entries")
#     mde = db.relationship("MeetDivisionEvent", secondary="entries")
#     heat = db.relationship("Heat", secondary="entries")

#     def get_event(self):
#         return self.mde.event

#     def get_division(self):
#         return self.mde.division


class MeetDivisionEvent(db.Model):
    """
    Associative table to handle the many to many relationship between Events
    and Divisions.
    """
    __tablename__ = "meet_division_events"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    div_id = db.Column(db.ForeignKey("divisions.id"), nullable=False)
    # meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    event_def_code = db.Column(db.ForeignKey("event_defs.code"),
                             nullable=False)

    division = db.relationship("Division")
    # entries = db.relationship("Entry")
    # meet = db.relationship("Meet")
    event = db.relationship("Event_Definition")
    # athletes = db.relationship("Athlete", secondary=entries)

    def __repr__(self):
        return "\nMeetDivEvent#{}: Meet: '{}', Event: {}, Division: {}".format(
                self.id,
                # self.meet.name,
                self.event.abbrev,
                self.division.get_div_name())

    def get_schools(self):
        schools = set()
        for athlete in self.athletes:
            schools.add(athlete.school)
        return list(schools)

    def form_heats(self):
        pass

    def assign_athletes(self):
        pass


# class Heat(db.Model):
#     """ TODO - Does this really belong hanging off of entry?  It seems a more
#     natural fit with being connected to MeetDivisionEvent
#     """
#     __tablename__ = "heats"
#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     # seq_num
#     entries = db.relationship("Entry")
#     athletes = db.relationship("Athlete", secondary="entries")
#     mde = db.relationship("MeetDivisionEvent", secondary="entries")

#     def __repr__(self):
#         return "<HEAT #{self.id}, {mde.event}, {mde.division}>"

#     def get_event(self):
#         return self.mde.event

#     def get_division(self):
#         return self.mde.division

#     def assign_lanes_pos(self):
#         pass


class School(db.Model):
    """
    """
    __tablename__ = "schools"

    # Set up so that the "Unattached" School always uses primary key #1
    id = db.Column(db.Integer, primary_key=True,
                   autoincrement=True,
                   default=1)
    abbrev = db.Column(db.String(8),
                       nullable=False,
                       unique=True,
                       default="UNA")
    name = db.Column(db.String(50),
                     nullable=False,
                     unique=True,
                     default="Unattached")
    city = db.Column(db.String(30), nullable=True)
    state = db.Column(db.String(2), nullable=True)

    # athletes = db.relationship("Athlete")
    # divisions = db.relationship("Division", secondary="athletes")
    # entries = db. relationship("Entry", secondary="athletes")

    def __repr__(self):
        return "<SCHOOL id#{}: {}>".format(self.id, self.name)


# # ###### THESE TABLES ARE INITIALIZED BUT NOT MODIFIED GOING FORWARD
# # ###### CONTAIN "Constant" Data or are used for referential integrity

class Event_Definition(db.Model):
    """
    """
    __tablename__ = "event_defs"

    # id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    code = db.Column(db.String(8), primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    etype = db.Column(db.ForeignKey("event_def_types.code"),
                      nullable=False)

    def __repr__(self):
        """
        Returns human-readable representation of the Event_Definition object
        """
        return "\n<EVENT_DEF. CODE: {}, Name: {}, Type: {}>".format(
                self.code,
                self.name,
                self.etype)


class Event_Def_Type(db.Model):
    """
    """
    __tablename__ = "event_def_types"

    code = db.Column(db.String(8), primary_key=True)
    events = db.relationship("Event_Definition")

    def __repr__(self):
        return f"<EVENTTYPE: {self.code}>"

    def is_field(self):
        if self.code in ['horzjump', 'vertjump', 'throw']:
            return True
        return False

    def is_track(self):
        return not self.is_field()

    def is_indiv(self):
        if self.code == 'relay':
            return False
        else:
            return True


class Division(db.Model):
    """
    """
    __tablename__ = "divisions"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    gender_code = db.Column(db.ForeignKey("genders.gender_code"),
                            nullable=False)
    grade_code = db.Column(db.ForeignKey("grades.grade_code"), nullable=False)
    # mdes = db.relationship("MeetDivisionEvent")
    # meets = db.relationship("Meet", secondary="meet_division_events")
    grade = db.relationship("Grade")
    gender = db.relationship("Gender")
    # athletes
    # schools
    # entries

    def __repr__(self):
        """ returns human-readable representation of Division object """
        return "<DIVISION id#{}: {}>".format(self.id, self.get_div_name())

    @classmethod
    def get_by_gender_grade(cls, gender_string, grade_num):
        """ Gets the division given the gender string (as "M" or "F"),
        and the grade as a number. Returns None if no division exists that
        matches the gender/grade combo.
        """
        division = cls.query.filter_by(gender_code=gender_string,
                                       grade_code=str(grade_num)).first()
        return division

    def get_div_name(self):
        # To do  - move this into a __init__
        return f"{self.grade.grade_name} {self.gender.gender_name}"


class Gender(db.Model):
    """
    gender_code is typically "M" or "F"
    gender_name is something like "Boys", "Men", "Girls", "Women"

    >>> boys = Gender(gender_code="M", gender_name="Boys")
    >>> boys
    'GENDER: M, Boys'
    """
    __tablename__ = "genders"

    gender_code = db.Column(db.String(2),
                            primary_key=True,
                            autoincrement=False)
    gender_name = db.Column(db.String(10), unique=True, nullable=False)
    divisions = db.relationship("Division")

    def __repr__(self):
        return "GENDER: {}, {}".format(self.gender_code, self.gender_name)


class Grade(db.Model):
    """
    In MVP, athletes must be in a grade. For now, it will be 5, 6, 7, or 8.
    But in future, for high school, it could be 9,10,11,or 12. And college:
    FR, SO, JR, SR.  So making this a 2-character 'code' and not an Integer
    """
    __tablename__ = "grades"

    grade_code = db.Column(db.String(2), primary_key=True, autoincrement=False)
    grade_name = db.Column(db.String(12), unique=True, nullable=False)
    divisions = db.relationship("Division")

    def __repr__(self):
        return "<GRADE: code: {}, name: {}>".format(
                self.grade_code, self.grade_name)


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
    info("Connected to DB")


def reset_database():
    # Delete all rows in tables, so if we need to run this seeding program
    # a second time, we won't be trying to add duplicate data
    db.session.remove()
    db.drop_all()
    db.engine.dispose()


if __name__ == "__main__":
    from server import app
    reset_database()
    connect_to_db(app, "tms-dev")
    db.create_all()
