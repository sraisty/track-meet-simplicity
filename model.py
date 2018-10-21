"""
The Data model for Track Meet Simplicity
by Susan Raisty

NOTE: "mde" and "mdes" (plural of mde) refer to "MeetDivisionEvent"
"""
from decimal import *
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

EVENT_DEFS = ({"code": "100M", "name": "100 Meter", "type": "sprint"},
              {"code": "200M", "name": "200 Meter", "type": "sprint"},
              {"code": "400M", "name": "400 Meter", "type": "sprint"},
              {"code": "800M", "name": "800 Meter", "type": "sprint"},
              {"code": "1600M", "name": "1600 Meter", "type": "distance"},
              {"code": "3200M", "name": "3200 Meter", "type": "distance"},
              {"code": "4x100M", "name": "4x100 Meter Relay", "type": "relay"},
              {"code": "4x400M", "name": "4x400 Meter Relay", "type": "relay"},
              {"code": "65H", "name": "65 Meter Hurdles", "type": "sprint"},
              {"code": "100H", "name": "100 Meter Hurdles (Girls Only)", "type": "sprint"},
              {"code": "110H", "name": "110 Meter Hurdles (Boys Only)", "type": "sprint"},
              {"code": "300H", "name": "300 Meter Hurdles", "type": "sprint"},  
              {"code": "LJ", "name": "Long Jump", "type": "horzjump"},
              {"code": "TJ", "name": "Triple Jump", "type": "horzjump"},
              {"code": "DT", "name": "Discus Throw", "type": "throw"},
              {"code": "SP", "name": "Shot Put Throw", "type": "throw"},
              {"code": "HJ", "name": "High Jump", "type": "vertjump"},
              {"code": "PV", "name": "Pole Vault", "type": "vertjump"})


EVENT_TYPES = ("sprint", "distance", "relay",
                "vertjump", "horzjump", "throw")

MEET_STATUS = ("Not Published", "Accepting Entries", "Awaiting Assignment",
               "Assignments Done", "Meet In Progress", "Completed")

MARK_TYPES = ("seconds", "inches", "meters")

USER_ROLES = ("meet_director", "coach", "athlete", "other")

db = SQLAlchemy()

# #############
# class Tms_App:
#     """ 
#     TODO - This is just a regular class, not mapped to the database?  
#     Do I really need this?
#     """
#     def __init__(self):
#         self.meets = []
#         self.athletes = []
#         self.schools = []
#         School.init_unattached_school()
#         Division.generate_divisions(gender_list=GENDERS, grade_list=GRADES)
#         Event_Definition.generate_event_defs(EVENT_DEFS)

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
                       default="Accepting Entries",
                       nullable=False)

    # order_of_events at meet
    # order_of_divs_in_event
    max_entries_per_athlete = db.Column(db.Integer, nullable=True)
    max_team_entries_per_event = db.Column(db.Integer, nullable=True)

    host_school = db.relationship("School", uselist=False)
    mdes = db.relationship("MeetDivisionEvent", back_populates="meet")
    events = db.relationship("Event_Definition",
                             secondary="meet_division_events", 
                             # back_populates="meet"
                             )
    divisions = db.relationship("Division",
                                secondary="meet_division_events", 
                                # back_populates="meet"
                                )
    entries = db.relationship("Entry", secondary="meet_division_events",
                              back_populates="meet")

    editor_users = db.relationship("User", secondary="schools")
    # heats
    # athletes


    def __repr__(self):
        return "\n<MEET id# {}: {}>".format(self.id, self.name)



class Athlete(db.Model):
    """ """
    __tablename__ = "athletes"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    minitial = db.Column(db.String(1), nullable=True)
    phone = db.Column(db.String(12), nullable=True)

    school_id = db.Column(db.ForeignKey('schools.id'), nullable=True)
    div_id = db.Column(db.ForeignKey('divisions.id'), nullable=False)

    school = db.relationship("School", back_populates="athletes")
    division = db.relationship("Division", back_populates="athletes")
    entries = db.relationship("Entry", back_populates="athlete")
    mdes = db.relationship("MeetDivisionEvent", secondary="entries",
                           back_populates="athletes")
    # Coaches for the athlete's team can edit the athlete's record
    editor_users = db.relationship("User", secondary="schools")
    # meets

    def __init__(self, fname, minitial, lname, gender, grade,
                 school_abbrev="UNA", phone=None):
        """ You actually CAN have a __init__ method for a class mapped to
        SQLAlchemy!!!  You just have to map the  columns
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
            error(f"Athlete {fname} {lname}: No division for age/gender")
        self.division = div

        school = School.query.filter_by(abbrev=school_abbrev).one_or_none()
        if not school:
            warning(f"Athete {fname} {lname}:School ({school_abbrev}) doesn't exist in TMS.")
            warning(f"\nAssigning {fname} {lname} to 'Unattached' school.")
            school = School.query.filter_by(abbrev="UNA").one()
        self.school = school

        ## TODO THIS IS A HACK CLEAN IT UP.
        # self.name = get_full_name(self.fname, self.minitial, self.lname)

    def __repr__(self):
        return "\n<ATHL# {}: {}, {}, {}>".format(
                self.id,
                self.full_name(),
                self.school.__repr__(),
                self.division.__repr__())

    def full_name(self):
        return self.get_full_name(self.fname, self.minitial, self.lname)

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

    @classmethod
    def get_athlete(cls, fname, middle, lname, gender, school_code):
        """ The HyTek file format requires that the first 7 fields of an
        athlete's entry record be the same as the first 8 fields of any
        athlete info record.  This method makes the test. If the athlete is
        alaredy in the database, returns that athlete's object.

        Returns none if this athlete is not already in the database
        """
        athletes_same_name = Athlete.query.filter_by(fname=fname, lname=lname,
                                                     minitial=middle).all()
        for ath in athletes_same_name:
            if (ath.school.abbrev == school_code and
                    ath.division.gender == gender):
                return ath

        # database doesn't contain an athlete matching the parameteres specified
        return None

    def meets(self):
        meets = set()
        for mde in self.mdes:
            meets.add(mde.meet)
        return list(meets)



mark_type_enum = Enum(*MARK_TYPES, name="mark_type")


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

    # In track, an athlete's "mark" for a parituclar event is either his/her 
    # time or distance thrown/jumped or height jumped (in inches) for field 
    # events. We store in seconds or inches, with precision to the hundredth of 
    # a second and up to 1/4 inch.
    mark = db.Column(db.Numeric(7, 2), nullable=True)
    mark_type = db.Column(mark_type_enum, nullable=True)

    # # assigned_heat_id = db.Column(db.ForeignKey("heats.id"), nullable=True)

    meet = db.relationship("Meet",
                           secondary="meet_division_events",
                           uselist=False,
                           back_populates="entries")
    athlete = db.relationship("Athlete",
                              uselist=False,
                              back_populates="entries")
    mde = db.relationship("MeetDivisionEvent",
                          uselist=False,
                          back_populates="entries")
    division = db.relationship("Division",
                               secondary="athletes",
                               uselist=False,
                               back_populates="entries")
    event = db.relationship("Event_Definition",
                            secondary="meet_division_events",
                            uselist=False,
                            back_populates="entries")
    school = db.relationship("School",
                             secondary="athletes",
                             uselist=False,
                             back_populates="entries")
    # editor_users = db.relationship("User", secondary="schools")


    # assigned_heat = db.relationship("Heat")
    def __repr__(self):
        return ("\n<ENTRY #{}, Ath: TODO {}, Event: {}, Div: {}, Meet: {}>"
                .format(
                    self.id, self.athlete.full_name(),
                    self.event.code, self.division.abbrev(), self.meet.name))

    @staticmethod
    def time_string_to_seconds(time_string):
        """ Takes a string like '1:23.44.55, 1:19.14, 58.83, 13.4' and
        returns it in seconds, with resolution to the tenth or hundreth of a
        second

        TODO - deal with hand-timed marks, which have a 'h' at the end and
        are only recorded in tenths of seconds instead of hundredths
        """
        # turn the time string into a [seconds, minutes, hours] list
        t_list = time_string.split(':')[::-1]

        secs = 0
        for i in range(0, len(t_list)):
            secs += float(t_list[i]) * 60**i
        return secs

    def mark_to_string(self):
        if self.mark is None:
            return None

        if self.mark_type == "seconds":
            return self.time_mark_to_string()
        elif self.mark_type == "inches":
            return self.english_dist_mark_to_string()
        else:
            raise Exception("UNIMPLEMENTED: metric field distance marks")


    def time_mark_to_string(self):
        total_seconds= self.mark
        return self.seconds_to_time_string(total_seconds)

    @staticmethod
    def seconds_to_time_string(total_seconds):
        seconds = 0.0
        minutes = 0
        hours = 0
        if total_seconds > 60*60:
            hours = int(total_seconds // (60 * 60))
            total_seconds -= hours * 60 * 60
        if total_seconds > 60:
            minutes = int(total_seconds // 60)
            total_seconds -= minutes * 60
        seconds = total_seconds

        if hours:
            return '{:d}:{:02d}:{:05.2f}'.format(hours, minutes, seconds)
        elif minutes:
            # less than an hour, more than a minute
            return '{:d}:{:05.2f}'.format(minutes, seconds)
        else:
            # less than a minute
            return '{:.2f}'.format(seconds)

    @staticmethod
    def field_english_mark_to_inches(distance_str):
        # TODO this function is poorly named and easily confused with the 
        # english_dist_mark_to_string
        """
        Convert a string that represents an English distance, in inches,
        for a field distance mark.
        Examples 12' || 12' 10 || 12' 10.5 || 32' 4 || 5' 0
        TODO later: numbers like: 121025 12-10.25".

        Returns distance_str converted to inches. If it can't be converted,
        returns None.
        """
        [feet, inches] = distance_str.split()

        # verify feet has the ' character at the end, and remove it.
        if feet[-1] != "'":
            return None
        feet = int(feet[0:-1])
        return float(inches) + (12 * feet)


    def english_dist_mark_to_string(self):
        inches = self.mark
        if inches >= 12:
            feet = int(inches // 12)
            inches = inches - feet * 12

        return "{:d}".format(feet) + "' " + "{:.2f}".format(inches)
        # TODO - Need to fix this so it will only retur 10' 6" instead of
        # 10' 6.00" for events like the high jump that aren't measured so the
        # fraction of an inch


# class Mark(db.Model):
# TODO - Eventually pull the Mark out of the Entry class into its own class.


class MeetDivisionEvent(db.Model):
    """
    Associative table to handle the many to many relationship between Events,
    Divisions, and Meets
    """
    __tablename__ = "meet_division_events"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    div_id = db.Column(db.ForeignKey("divisions.id"), nullable=False)
    meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    event_code = db.Column(db.ForeignKey("event_defs.code"), nullable=False)

    meet = db.relationship("Meet", back_populates="mdes",
                           uselist=False)
    host_school = db.relationship(
            "School", secondary="meets",
            # back_populates="meet_division_events", 
            uselist=False)
    division = db.relationship(
            "Division", 
            back_populates="mdes", 
            uselist=False)
    event = db.relationship(
            "Event_Definition", 
            back_populates="mdes",
            uselist=False)

    entries = db.relationship(
            "Entry", back_populates="mde", lazy="joined")
    athletes = db.relationship(
            "Athlete", secondary="entries", lazy="joined", 
            back_populates="mdes")
    # school = 
    # editor_users = db.relationship("User", secondary="schools")

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

    def schools(self):
        schools = set()
        for athlete in self.athletes:
            schools.add(athlete)
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
                   autoincrement=True)
    abbrev = db.Column(db.String(8),
                       nullable=False,
                       unique=True,
                       default="UNA")
    name = db.Column(db.String(50),
                     nullable=False,
                     unique=True,
                     default="Unattached")
    league = db.Column(db.String(6), nullable=True)
    section = db.Column(db.String(12), nullable=True)
    city = db.Column(db.String(30), nullable=True)
    state = db.Column(db.String(2), nullable=True)

    athletes = db.relationship("Athlete", back_populates="school")
    divisions = db.relationship("Division", secondary="athletes")
    entries = db.relationship(
            "Entry", 
            back_populates="school",
            secondary="athletes")
    coaches = db.relationship("User")
    # editor_users = coaches

    def __init__(
            self, name="Unattached", abbrev="UNA", city=None, state=None, 
            league=None, section=None):
        self.name = name
        self.abbrev = abbrev
        if city:
            self.city = city.title()
        if state:
            self.state = state.upper()
        if league:
            self.league = league.upper()
        if section:
            self.section = section.upper()


    def __repr__(self):
        return "<SCHOOL id#{}: {}>".format(self.id, self.name)


    @classmethod
    def init_unattached_school(cls):
        """
        Side Effects: Writes to the database

        This shoudl only be called before any records have been added to the
        schools table.

        In general, we're going to add schools as they start using the TMS,
        but we need to make sure that there is always an "Unattached"
        school in the database, no matter what.
        Note that School() will create the unattached school if it is not
        created yet. But if it has been,  SQL Alchemy will throw an exception.
        """

        # Don't initialize the unattached school if it already exists.
        unattached_school = School.query.filter_by(abbrev="UNA").one_or_none()
        if unattached_school is None:
            new_unattached_school = cls()
            db.session.add(new_unattached_school)
            db.session.commit()


    def meets(self):
        meets = set()
        for entry in self.entries:
            meets.add(entry.meet)
        print(meets)
        return list(meets)


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
        """
        Side Effects: Writes to the database

        event_list is a tuple of event_dictionaries:
        eg: ({"code": "100M", "name": "100 Meter", "type": "sprint"})
        """
        event_defs = []
        for e_dict in event_list:
            event_defs.append(cls(code=e_dict["code"],
                              name=e_dict['name'],
                              etype=e_dict['type']))
        db.session.add_all(event_defs)
        db.session.commit()
        return event_defs

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
        # TO DO - change this to just "name" - It's too confusing.
        return (f"Grade {self.grade} " +
                f"{DIV_NAME_DICT[self.adult_child][self.gender]}")

    @classmethod
    def generate_divisions(cls, gender_list, grade_list):
        """
        Side Effects: Writes to the database

        Generate a combination of divisions for every combination of genders
        and grades. If a particular division already exists in the database,
        do nothing.
        >>> generate_divisions(gender_list=("M", "F"), grade_list=(6, 7, 8))
        """
        divs = []
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
                    divs.append(div)
        db.session.add_all(divs)
        db.session.commit()
        return divs
        # TODO Now, change our list back into an orderd list


user_role_enum = Enum(*USER_ROLES, name="user_roles")


class User(db.Model):
    """User of TrackMeetSimplicity website."""

    __tablename__ = "users"

    id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    email = db.Column(db.String(64), nullable=True)
    password = db.Column(db.String(64), nullable=True)
    school_id = db.Column(db.ForeignKey("schools.id"), nullable=True)
    # TO DO - fix this to somethine less privileged by default
    role = db.Column(user_role_enum, nullable=False, default="coach")
    # TODO FUTURE - add school is


    school = db.relationship("School")
    meets_owned = db.relationship("Meet", secondary="schools")
    athletes_editable = db.relationship("Athlete", secondary="schools")

    def __repr__(self):
        # CHANGE TO ONE DAY STORE SCHOOL
        # return "<USER #{}, {}, school={}, role={}".format(
        #     self.user_id, self.email, self.school, self.role)
        return "<USER #{}, {}, role={}".format(
            self.user_id, self.email, self.role)


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
    connect_to_db(app, "tms-dev")
    db.session.remove()
    db.drop_all()

    db.create_all()
