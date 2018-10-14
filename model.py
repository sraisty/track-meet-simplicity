"""
The Data model for Track Meet Simplicity
by Susan Raisty

NOTE: "mde" and "mdes" (plural of mde) refer to "MeetDivisionEvent"
"""

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Enum
from sqlalchemy.exc import DataError
from sqlalchemy.orm.exc import NoResultFound
from util import warning, error, info

GENDERS = ('M', 'F')
GRADES = ('6', '7', '8')
ADULT_CHILD = ('adult', 'child')
DIV_NAME_DICT = {"child": {"M": "Boys", "F": "Girls"},
                 "adult": {"M": "Men", "F": "Women"}}

EVENT_TYPES = ("sprint", "distance", "relay",
                "vertjump", "horzjump", "throw")

MEET_STATUS = ("accepting_entries", "entries_closed", "athletes_assigned",
               "done")

db = SQLAlchemy()

# #############
class Tms_App:
    """ 
    TODO - This is just a regular class, not mapped to the database?  
    Do I really need this?
    """
    def __init__(self):
        self.meets = []
        self.athletes = []
        self.schools = []
        School.init_unattached_school()
        Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)
        Event_Definition.generate_event_defs(EVENT_DEFS)

    # def get_all_meets(self):
    """ returns a list of all meets, inactive, active, and whatever status """

meet_status_enum = Enum(*MEET_STATUS, name="meet_status")

class Meet(db.Model):
    __tablename__ = "meets"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(50), nullable=False)
    date = db.Column(db.DateTime, nullable=True)
    host_school_id = db.Column(db.ForeignKey("schools.id"), nullable=True)
    description = db.Column(db.String(300), nullable=True)
    status = db.Column(meet_status_enum,
                       default="accepting_entries",
                       nullable=False)

    # order_of_events at meet
    # order_of_divs_in_event
    max_entries_per_athlete = db.Column(db.Integer, nullable=True)
    max_team_entries_per_event = db.Column(db.Integer, nullable=True)


    host_school = db.relationship("School")
    mdes = db.relationship("MeetDivisionEvent")
    events = db.relationship("Event_Definition",
                             secondary="meet_division_events")
    divisions = db.relationship("Division",
                                secondary="meet_division_events")
    entries = db.relationship("Entry", secondary="meet_division_events")
    # heats
    # athletes
    # schools

    def __repr__(self):
        return "\n<MEET id# {}: {}>".format(self.id, self.name)


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


class Athlete(db.Model):
    """ """
    __tablename__ = "athletes"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    minitial = db.Column(db.String(1), nullable=True)
    phone = db.Column(db.String(12), nullable=True)

    school_id = db.Column(db.ForeignKey('schools.id'), nullable=False)
    div_id = db.Column(db.ForeignKey('divisions.id'), nullable=False)

    school = db.relationship("School")
    division = db.relationship("Division")
    entries = db.relationship("Entry")
    mdes = db.relationship("MeetDivisionEvent", secondary="entries")
    # meets

    def __init__(self, fname, minitial, lname, gender, grade,
                 school_abbrev="UNA", phone=None):

        """ You actually CAN have a __init__ method for a class mapped to 
        SQLAlchemy!!!  You just have to map the  colums 
        via self.<dbColumn Name> =  foo
        Note that the athlete hasn't been added to the db session or committed
        """
        self.fname = fname
        self.minitial = minitial
        self.lname = lname
        self.phone = phone

        div_q = Division.query.filter_by(gender=gender)
        if grade:
            div_q = div_q.filter_by(grade=grade)
        try:
            div = div_q.one()
        except NoResultFound:
           error(f"Athlete {fname} {lname}: age and/or gender don't match any Division")
        self.division = div

        school = School.query.filter_by(abbrev=school_abbrev).one_or_none()
        if not school:
            warning(f"Athete {fname} {lname}:School ({school_abrev}) doesn't exist in TMS.")
            warning(f"\nAssigning {fname} {lname} to 'Unattached' school.")
            school = School.query.filter_by(abbrev="UNA").one
        self.school = school

    def __repr__(self):
        return "\n<ATHL# {}: {}, {}, {}>".format(
                    self.id,
                    self.get_full_name(self.fname, self.minitial, self.lname),
                    self.school.__repr__(),
                    self.division.__repr__())

    @staticmethod
    def get_full_name(fname, minitial, lname):
        """ Creates a fullname from the first, last name, and middle initial
        >>> Athlete.get_full_name("Jane", "", "Doe")
        'Jane Doe'
        """
        if not (fname and lname):
            raise Exception("Must provide first and last name.")
        if minitial:
            return f"{fname} {minitial[0]}. {lname}"
        return f"{fname} {lname}"


    # def enter_event(self, meet, event_abbrev):
    #     """ """
    #     # Get the corresponding meet_event_div
    #     query = MeetDivisionEvent.query.filter_by(meet_id=meet.id)
    #     query = query.filter_by(div_id=self.division.id)
    #     event_def = Event_Definition.query.filter_by(abbrev=event_abbrev).one()
    #     query = query.filter_by(event_def_id=event_def.id)

    #     mde = query.first()
    #     if mde:
    #         # TODO: Did the athlete already enter this event? If they did,
    #         # warn and don't create a new Entry
    #         entry = Entry(athlete_id=self.id,
    #                       mde_id=mde.id)
    #         self.entries.append(entry)
    #         db.session.commit()
    #     else:
    #         error("Athlete entering non-existent event that does not exist.",
    #               "Athlete: {} {}. Event: {}, Meet: {}".format(
    #                self.fname, self.lname, event.code, meet.name))



class Entry(db.Model):
    """
    A middle object between Athlete and MeetDivisionEvent.  Each Entry object
    has an entry of one athletes into one MeetDivisionEvent-combo object. Each
    athlete can enter multiple events at a meet, within his/her division.
    Each division within an event has multiple athletes.

    Note that entering into an event doesn't mean the athlete will actually
    get assigned to the event
    """
    __tablename__ = "entries"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    athlete_id = db.Column(db.ForeignKey("athletes.id"),
                           nullable=False)
    mde_id = db.Column(db.ForeignKey("meet_division_events.id"),
                       nullable=False)
    # # mark_id = db.Column(db.ForeignKey("marks.id"))
    # # assigned_heat_id = db.Column(db.ForeignKey("heats.id"), nullable=True)

    meet = db.relationship("Meet",
                           secondary="meet_division_events",
                           uselist=False)
    athlete = db.relationship("Athlete", uselist=False)
    mde = db.relationship("MeetDivisionEvent", uselist=False)
    division = db.relationship("Division",
                               secondary="athletes",
                               uselist=False)
    event = db.relationship("Event_Definition",
                            secondary="meet_division_events",
                            uselist=False)

    # assigned_heat = db.relationship("Heat")
    # mark = db.relationship("Mark")

    def __repr__(self):
        return ("\n<ENTRY #{}, Ath: TODO {}, Event: {}, Div: {}, Meet: {}>"
                .format(
                    self.id, self.athlete.fname, self.athlete.lname,
                    self.event.abbrev, self.division, self.meet.name))


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
    Associative table to handle the many to many relationship between Events,
    Divisions, and Meets
    """
    __tablename__ = "meet_division_events"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    div_id = db.Column(db.ForeignKey("divisions.id"), nullable=False)
    meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    event_code = db.Column(db.ForeignKey("event_defs.code"),
                           nullable=False)

    meet = db.relationship("Meet", uselist=False)
    division = db.relationship("Division", uselist=False)
    event = db.relationship("Event_Definition", uselist=False)

    entries = db.relationship("Entry", lazy="joined")
    athletes = db.relationship("Athlete", secondary="entries", lazy="joined")

    def __repr__(self):
        return "\nMeetDivEvent#{}: Meet: '{}', Event: {}, Division: {}".format(
                self.id,
                self.meet.name,
                self.event.code,
                self.division.longname())

    @classmethod
    def generate_mdes(cls, meet, divisions, event_defs):
        for event in event_defs:
            for division in divisions:
                mde = MeetDivisionEvent()
                mde.meet = meet
                mde.division = division
                mde.event = event
                db.session.add(mde)
        db.session.commit()


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

    athletes = db.relationship("Athlete")
    divisions = db.relationship("Division", secondary="athletes")
    entries = db.relationship("Entry", secondary="athletes")

    def __repr__(self):
        return "<SCHOOL id#{}: {}>".format(self.id, self.name)

    @classmethod
    def init_unattached_school(cls):
        """
        This shoudl only be called before any records have been added to the
        schools table.

        In general, we're going to add schools as they start using the TMS,
        but we need to make sure that there is always an "Unattached"
        school in the database, no matter what.
        Note that School() will create the unattached school if it is not
        created yet. But if it has been,  SQL Alchemy will throw an exception.
        """
        unattached_school = cls()
        db.session.add(unattached_school)
        db.session.commit()


# # ###### THESE TABLES ARE INITIALIZED BUT NOT MODIFIED GOING FORWARD
# # ###### CONTAIN "Constant" Data or are used for referential integrity

event_type_enum = Enum(*EVENT_TYPES, name="event_types")

class Event_Definition(db.Model):
    """
    """
    __tablename__ = "event_defs"

    code = db.Column(db.String(8), primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    etype = db.Column(event_type_enum, nullable=False)

    mdes = db.relationship("MeetDivisionEvent")
    divisions = db.relationship("Division", secondary="meet_division_events")
    meets = db.relationship("Meet", secondary="meet_division_events")
    entries = db.relationship("Entry", secondary="meet_division_events")
    # heats

    def __repr__(self):
        """
        Returns human-readable repr of the Event_Definition object
        """
        return "\n<EVENT_DEF {}, Name: {}, Type: {}>".format(
                self.code,
                self.name,
                self.etype)

    @classmethod
    def generate_event_defs(cls, event_list):
        """  event_list is a tuple of event_dictionaries:
        eg: ({"code": "100M", "name": "100 Meter", "type": "sprint"})
        """
        for e_dict in event_list:
            event_def = cls(code=e_dict["code"],
                            name=e_dict['name'],
                            etype=e_dict['type'])
            db.session.add(event_def)
        db.session.commit()

    def is_field(self):
        if self.etype in ['horzjump', 'vertjump', 'throw']:
            return True
        return False

    def is_track(self):
        return not self.is_field()

    def is_indiv(self):
        if self.etype != 'relay':
            return True
        return False


gender_enum = Enum(*GENDERS, name="gender")
grade_enum = Enum(*GRADES, name='grade')
adult_enum = Enum(*ADULT_CHILD, name='adultchild')

class Division(db.Model):
    __tablename__ = "divisions"
    id = db.Column(db.Integer(), primary_key=True, autoincrement=True)
    gender = db.Column(gender_enum, nullable=False)
    # In some meets, they don't separate kids out by grade, so null is ok
    grade = db.Column(grade_enum, nullable=True)
    adult_child = db.Column(adult_enum, default='child', nullable=False)

    mdes = db.relationship("MeetDivisionEvent")
    meets = db.relationship("Meet", secondary="meet_division_events")
    events = db.relationship("Event_Definition",
                             secondary="meet_division_events")
    athletes = db.relationship("Athlete")
    schools = db.relationship("School", secondary="athletes")
    entries = db.relationship("Entry", secondary="athletes")

    def __repr__(self):
        """ returns human-readable representation of Division object """
        return "<DIVISION id#{}: {}>".format(self.id, self.longname())

    def abbrev(self):
        return f"{self.grade}{self.gender}"

    def longname(self):
        return (f"Grade {self.grade} " +
                f"{DIV_NAME_DICT[self.adult_child][self.gender]}")


    @classmethod
    def generate_divisions(cls, gender_list, grade_list):
        """ Generate a combination of divisions for every combination of genders
        and grades. If a particular division already exists in the database,
        do nothing.
        >>> generate_divisions(gender_list=("M", "F"), grade_list=(6, 7, 8))
        """
        div_set = set()
        for gender_str in gender_list:
            for grade_str in grade_list:
                if (grade_str.isnumeric() and
                        (0 < int(grade_str) <= 12)):
                    adult_child_str = "child"
                else:
                    adult_child_str = "adult"

                if Division.query.filter_by(gender=gender_str, grade=grade_str,
                                            adult_child=adult_child_str
                                            ).one_or_none():
                    # this division was already in the database, so no need
                    # to create a new object and  new db Rows
                    continue
                else:
                    div = Division(gender=gender_str,
                                   grade=grade_str,
                                   adult_child=adult_child_str)
                    div_set.add(div)
        db.session.add_all(list(div_set))
        db.session.commit()
        # TODO Now, change our list back into an orderd list


###############
# Helper functions

def connect_to_db(app, db_uri="tms-dev"):
    """ Connect the database to our Flask app
    """
    # Configure to use the dev version of our PostgreSQL database
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///" + db_uri
    app.config["SQLALCHEMY_ECHO"] = True
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["DEBUG"] = True
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
