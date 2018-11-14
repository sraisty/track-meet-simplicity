"""
The Data model for Track Meet Simplicity
by Susan Raisty

NOTE: "mde" and "mdes" (plural of mde) refer to "MeetDivisionEvent"
"""

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Enum
from sqlalchemy.orm.exc import NoResultFound, MultipleResultsFound
from sqlalchemy_utils import generic_repr
from datetime import datetime, timedelta
from random import shuffle


from util import warning, error, info

from model_constants import (
    SUPERUSER_EMAIL, SUPERUSER_PASSWORD, USER_ROLES, GENDERS, GRADES,
    MIDDLE_SCHOOL_GRADES, HIGH_SCHOOL_GRADES, MDE_STATUS,
    ADULT_CHILD, DIV_NAME_DICT, MIN_ATHLETES_PER_HEAT, EVENT_TYPES,
    MEET_STATUS, MARK_TYPES, HEAT_FLIGHT_ASSIGN_METHOD,
    TRACK_LANE_ASSIGN_METHOD, FIELD_ORDER_ASSIGN_METHOD, EVENT_DEFS,
    DEFAULT_DIVISION_ORDER, DEFAULT_EVENT_ORDER)

# This is a hack. It's a number of seconds that is greater than any track meet
# event would possibly take, so I can get the database to do sorting of athlete 
# entry marks from best to worst without special handling.
INFINITY_SECONDS = 99999999

db = SQLAlchemy()


class TmsError(Exception):
    """ Base class for exceptions in the TMS module """
    def __init__(self, message):
        self.message = message


class TmsApp:
    """ TODO - This is just a regular class, not mapped to the database. Is
        this good practice?  Should it just be a function?
        Initializes the database and ets up application-level data (not
        meet-leve;) that are used across multiple meets.
    """
    def __init__(self):
        """
        Initialize the application from scratch: create database tables,
        write constant data that are used across multiple meets to database.

        Sets up: the superuser, the unattached school, the list
        of the competition divisions (i.e "7th grade boys") used across most
        middle school and high school meets, and the definitions of official
        track & field events.

        This should only be used once, with a completely empty database.
        """

        # TODO - test tp make sure the database is empty first.

        User.create_superuser()
        School.init_unattached_school()

        # Create all the standard divisions for middle school
        Division.generate_grade_gender_divisions(
                gender_list=GENDERS, grade_list=MIDDLE_SCHOOL_GRADES)

        Division.generate_gender_only_divisions(gender_list=GENDERS)
        # TODO Create the typical highschool divisions: varisty/JV/FS(boys)

        # Create all the possible event definitions as defined by Track & Field
        # governance bodies.
        EventDefinition.generate_event_defs(EVENT_DEFS)


# #######################  MEET CLASS #####################
meet_status_enum = Enum(*MEET_STATUS, name="meet_status")


class Meet(db.Model):
    __tablename__ = "meets"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(50), nullable=False)
    date = db.Column(db.DateTime, nullable=True)
    host_school_id = db.Column(db.ForeignKey("schools.id"), nullable=True)
    description = db.Column(db.String(300), nullable=True)
    status = db.Column(
            meet_status_enum, default="Unpublished", nullable=False)

    max_entries_per_athlete = db.Column(db.Integer, default=4, nullable=True)
    max_relays_per_athlete = db.Column(db.Integer, default=2, nullable=True)
    max_teammates_per_event = db.Column(db.Integer, default=12, nullable=True)
    max_heats_per_mde = db.Column(db.Integer, default=1, nullable=True)

    # TODO  Invited/Entered Schools is a many-to-many relationship with Meets, and
    # requires an associative table or associative object. It is different than
    # entered schools.
    # invited_schools = db.relationship(
    #         "School", primaryjoin="School.id == Meet.host_school_id",
    #         uselist=True, back_populates="meets_invited")
    host_school = db.relationship(
            "School", uselist=False,
            primaryjoin="School.id == Meet.host_school_id",
            back_populates="meets_hosted")

    mdes = db.relationship(
            "MeetDivisionEvent", uselist=True,
            order_by="MeetDivisionEvent.seq_num",
            back_populates="meet")

    events = db.relationship(
            "EventDefinition", secondary="meet_division_events", uselist=True,
            backref="meets")

    event_orderings = db.relationship(
            "EventOrdering", uselist=True, order_by="EventOrdering.seq_num",
            back_populates="meet")

    divisions = db.relationship(
            "Division", secondary="meet_division_events", uselist=True,
            )

    div_orderings = db.relationship(
            "DivOrdering", uselist=True, order_by="DivOrdering.seq_num",
            back_populates="meet")

    entries = db.relationship(
            "Entry", secondary="meet_division_events", uselist=True,
            back_populates="meet")

    # Make sure that editor users is determine by HOST school,
    # NOT invited schools
    manager_users = db.relationship(
            "User", secondary="schools", uselist=True,
            primaryjoin="School.id == Meet.host_school_id",
            secondaryjoin="User.school_id == School.id",
            back_populates="meets_managed")

    def __repr__(self):
        str = "\n<MEET id={self.id}, name=<{self.name}>, " \
               "date={self.date}, status={self.status}, " \
               "host_school={self.host_school.name}, " \
               "events={self.events}, " \
               "event_ordering={self.event_orderings}, " \
               "divisions={self.divisions}, " \
               "div_ordering={self.div_orderings}, " \
               "managing_users = {self.manager_users} ".format(self=self)
        str = str + "num_mdes = {}, num_entries={}".format(
                        len(self.mdes), len(self.entries))
        return str

    @classmethod
    def init_meet(cls, meet_info_dict):
        # Note that this function might not set the meet's host_school_id 
        # correctly if the school doesn't already exist in the database
        info("init_meet")
        meet = Meet(
            name=meet_info_dict['name'],
            date=meet_info_dict['date'],
            description=meet_info_dict.get('description', ''),
            status=meet_info_dict.get('status', 'Unpublished'))

        host_school_id = meet_info_dict.get('host_school_id')
        host_school = School.query.filter_by(id=host_school_id).one_or_none()
        if host_school:
            meet.host_school = host_school
        else:
            # host school isn't in the database yet. This should not happen
            # in normal usage, but for seeding the database and testing
            # it's common, so I'm going to just reassign the meet's
            # host school to the "Unattached" school.
            meet.host_school_id = 1     # Unattached school has id of 1

        meet.max_entries_per_athlete = meet_info_dict.get(
                "max_entries_per_athlete")
        meet.max_relays_per_athlete = meet_info_dict.get(
                "max_relays_per_athlete")
        meet.max_teammates_per_event = meet_info_dict.get(
                "max_team_entries_per_event")
        meet.max_heats_per_mde = meet_info_dict.get(
                "max_heats_per_mde")

        # associate this meet with the selected events (i.e. "4x400 relay"),
        # and specify how the events should be ordered within this meet
        # If ev_code_order is None, then createEventOrders assumes the
        # meet includes all possible events in alpha order by event code.
        events = EventOrdering.create_events_in_order(
                        meet,
                        meet_info_dict.get('event_order', DEFAULT_EVENT_ORDER))

        # associate this meet with the selected divisions for athletes
        # (i.e. "6th Grade Girls"), and specify the order in which divisions
        # will compete (each division has its own heats) within a given event.
        # If ev_code_order is none, then createDivOrders assumes the
        # meet includes all possible events in alpha order by code.
        divs = DivOrdering.create_divs_in_order(
                meet,
                meet_info_dict.get('division_order', DEFAULT_DIVISION_ORDER))

        # With the events and divisions selected for this meet, now generate
        # the "MeetDivisionEvents" for the whole meet and each "MDE's" sequence
        # order within the overall meet
        MeetDivisionEvent.generate_mdes(meet, events, divs)
        db.session.add(meet)
        db.session.commit()
        return meet

    def get_event_mdes(self, ev):
        q = MeetDivisionEvent.query.filter(
                MeetDivisionEvent.meet == self,
                MeetDivisionEvent.event == ev)
        q = q.order_by(MeetDivisionEvent.seq_num)
        mdes = q.all()
        return mdes

    def get_event_athlete_count_across_divs(self, ev):
        """ For this meet, get the number of athletes, in all divisions, entered
            into an event. Note that this is the number of ENTRIES, not ASSIGNMENTS.
            TODO - rename this function to better reflect its
        """
        mde_q = MeetDivisionEvent.query.filter(
                MeetDivisionEvent.meet == self,
                MeetDivisionEvent.event == ev)
        count = 0
        for mde in mde_q:
            count += len(mde.entries)
        return count

    def get_event_heat_count_across_divs(self, ev):
        """ For a meet, count the number of required heats across all divisions
            that are needed for a particular event, given the current number of 
            entries.  Won't exceed the max_heat_count for each mde, or if some 
            MDEs don't have a max_heat_count set, it won't exceed the overall 
            setting for MaxHeatCount for the entire meet.
        """
        mde_q = MeetDivisionEvent.query.filter(
                MeetDivisionEvent.meet == self,
                MeetDivisionEvent.event == ev)
        count = 0
        for mde in mde_q:
            count += mde.get_num_assigned_heats()
        return count

    def get_num_heats(self):
        # TODO - seems redundant with get_event_heat_count_across_divs.
        # Do I really need both? 
        if self.status == "Accepting Entries" or self.status == "Unpublished":
            return None
        total_heats = 0
        for mde in self.mdes:
            mde_heats = mde.get_num_assigned_heats()
            if mde_heats:
                total_heats += mde_heats
        return total_heats

    def event_is_oversubscribed(self, ev):
        mde_q = MeetDivisionEvent.query.filter(
                MeetDivisionEvent.meet == self,
                MeetDivisionEvent.event == ev)
        for mde in mde_q:
            if len(mde.entries) > mde.get_max_athletes():
                return True
        return False

    def schools_entered(self):
        """ returns a list of school objects, ordered alphabetically by the
        school's codes, that have atheltes entered into this meet.
        """
        q = db.session.query(School).join(School.entries).join(Entry.meet)
        q = q.filter(Meet.id == self.id).distinct()
        q = q.order_by(School.code)
        schools = q.all()
        num_schools = q.count()
        info(f"Meet {self.name} has **{num_schools}** entered:")
        for s in schools:
            info(f"\t\t\t{s.name}, {s.code}")
        return schools

    def school_is_entered(self, school_id):
        school = School.query.get(school_id)
        return school in self.schools_entered()

    def get_athletes(self, school_id=None):
        """ Returns a list of athletes entered into this meet.
        If school_id is
        provided, it returns a list of the meet's athletes from that school
        Note that each athlete only appears in the list once, regardless of
        how many events the athlete is entered into.
        """
        q = db.session.query(Athlete).join(Athlete.entries).join(Entry.meet)
        q = q.filter(Meet.id == self.id).distinct()
        if school_id:
            q = q.filter(Athlete.school_id == school_id)
        q = q.order_by(Athlete.fname).order_by(Athlete.lname)
        athletes = q.all()
        return athletes

    def get_school_entries(self, school_id):
        school_entries = set()
        for entry in self.entries:
            if entry.athlete.school_id == school_id:
                school_entries.add(entry)
        return school_entries

    @classmethod
    def reorder_mdes(cls):
        # TODO if user changes order of meets and divisions
        pass

    def assign_all_mdes(self):
        """ For each MDE in the Meet, takes the current set of entries and 
        assigns athletes to the MDE and assign seed numbers. If an MDE was 
        already "assigned", this method overrides that previous assignment. 
        """
        for mde in self.mdes:
            mde.assign_seed_numbers()
        self.status = "Assignments Pending"
        db.session.commit()


# #######################  ATHLETE CLASS #####################


class Athlete(db.Model):
    """ """
    __tablename__ = "athletes"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    minitial = db.Column(db.String(1), nullable=True)
    # gender = db.Column(gender_enum, nullable=False)
    # grade = db.Column(grade_enum, nullable=True)
    phone = db.Column(db.String(12), nullable=True)

    school_id = db.Column(db.ForeignKey('schools.id'), nullable=True)
    div_id = db.Column(db.ForeignKey('divisions.id'), nullable=False)
    problem = db.Column(db.String(64), nullable=True)
    coach_notes = db.Column(db.String(64), nullable=True)

    school = db.relationship(
            "School", uselist=False, back_populates="athletes")
    division = db.relationship(
            "Division", uselist=False, back_populates="athletes")
    entries = db.relationship("Entry", uselist=True, back_populates="athlete")
    mdes = db.relationship(
            "MeetDivisionEvent", uselist=True, secondary="entries",
            back_populates="athletes")
    # Coaches for the athlete's school can edit the athlete's record
    editor_users = db.relationship("User", secondary="schools")

    def __init__(self, fname, minitial, lname, gender, grade,
                 school_code="UNA", phone=None):
        self.fname = fname
        self.minitial = minitial
        self.lname = lname
        self.phone = phone
        # TODO - test to see if athlete already exists?

        # set athlete's division
        div_q = Division.query.filter_by(gender=gender)
        if grade:
            div_q = div_q.filter_by(grade=grade)
        try:
            div = div_q.one()
        except NoResultFound:
            # TODO set the problem field in the existing DB records
            print("SKIPPING {} {}. No Div for grade: {}, Gender:{}".format(
                    fname, lname, grade, gender))
            raise TmsError("BadAthleteRecord: {}, {}, gr:{} gender:{}".format(
                    fname, lname, grade, gender))
        except MultipleResultsFound:
            # This should never happen? TODO eliminate this?
            # TODO set the problem field in the existing DB records
            raise TmsError(
                    "Athlete matches >1 div: {} {}, gr:{} gen:{}".format(
                        fname, lname, grade, gender))
        self.division = div

        # set athlete's school
        school = School.query.filter_by(code=school_code).one_or_none()
        if not school:
            warning("Athete {} {}: School ({}) not in database.".format(
                    fname, lname, school_code))
            warning(f"\nAssigning {fname} {lname} to 'Unattached' school.")
            self.problem = "School {} not in DB. Ressigned to UNA".format(school_code)
            school = School.query.filter_by(code="UNA").one()
        self.school = school


    @classmethod
    def add_athlete_to_db(cls, first_name, middle, last_name, gender,
                          grade, team_code, team_name):
        """ If the specified Athlete is not already in the database, add it.
        Also adds the athlete's school if it is not already in the database.
        Returns None if the athlete didn't get added to db because of a problem
        with the record (grade/gender) or if the athlete was already added.

        Note that an athlete is considered to already be in the database if
        its first_name, middle, last_name, gender, and team_code are identical.
        Note that GRADE is NOT used to identify the athlete uniquely, because
        kids' grades change over time.
        """

        # See if there is an athlete with the same name, gender and team code
        # in the database (not GRADE)
        athlete = Athlete.get_athlete(first_name, middle, last_name, gender,
                                      team_code)
        # Athlete is already in DB, so return it.
        if athlete is not None:
            return athlete

        # OK, the athlete is NOT already in the database, so let's add him/her.

        # Check if this athlete's school is already in the database. If not,
        # add the school to database. Note: the school must be committed to the
        # database before adding the athlete, or an Exception will result.
        school = School.query.filter_by(name=team_name,
                                        code=team_code).one_or_none()
        if not school:
            warning(f"Unknown School Found: {team_name}, code:{team_code}")
            school = School(name=team_name, code=team_code)
            db.session.add(school)
            db.session.commit()
            warning(f"Added new school: {team_name}, code:{team_code}")

        # Next, reate the new athlete, and add it to the database.
        try:
            athlete = Athlete(
                    first_name, middle, last_name, gender, grade, team_code)
        except TmsError as err:
            error("Error parsing athlete record: " + err.message)
            return

        # Athlete constructor might return none if there was something wrong
        # with the athlete's gender or grade. Just skip if this is the case.
        if athlete is None:
            return

        db.session.add(athlete)
        try:
            db.session.commit()
        except MultipleResultsFound:
            # TODO . In theory this should never happen if the first query, to
            # see if athlete was already in the db. Consolidate that query with
            # the following & figure out why the below sometimes still happens.
            error("Tried adding duplicate athlete: {},  {}, {}, {}, {}".format(
                    first_name, last_name, gender, grade, team_code))
            db.session.rollback()
            return
        info(f"Added athlete: {athlete}")
        return athlete


    def __repr__(self):
        return "\n<ATHL# {}: {}, {}, {}>".format(
                self.id,
                self.full_name(),
                self.school.__repr__(),
                self.division.__repr__())

    def full_name(self):
        # TODO - should this just be a hybrid column in database
        return self._get_full_name(self.fname, self.minitial, self.lname)

    @staticmethod
    def _get_full_name(fname, minitial, lname):
        """ Creates a fullname from the first, last name, and middle initial
            Separated into a static method for easy testing
        """
        if not (fname and lname):
            raise TmsError("Must provide first and last name.")
        if minitial:
            return f"{fname} {minitial[0]}. {lname}"
        return f"{fname} {lname}"

    @classmethod
    def get_athlete(cls, fname, middle, lname, gender, school_code):
        """ If a athlete is already in the database, returns that athlete's
        object. If not, returns None. An athlete is considered to be already
        in the database if the athlete's fname, middle initial, lname, gender,
        and school_code all match.
        Note that GRADE is not considered.
        """
        athletes_same_name = Athlete.query.filter_by(
            fname=fname, lname=lname, minitial=middle).all()
        for ath in athletes_same_name:
            if (ath.school.code == school_code and
                    ath.division.gender == gender):
                return ath
        return

    # def get_meets(self, meet_status, include_past_meets):
    def get_meets(self):
        """ Returns a list of all the meet objects that this athlete is
        entered into. If athlete is not entered into any meets, returns None.
        """
        q = db.session.query(Meet)
        q = q.join(Meet.mdes).join(MeetDivisionEvent.athletes)
        q = q.filter(Athlete.id == self.id).distinct()
        q = q.order_by(Meet.date)
        meets = q.all()
        return meets

    # def get_meets(self, meet_status, include_past_meets):
    def get_meet_count(self):
        """ Returns the number of meets that this athlete is
        entered into. If athlete is not entered into any meets, returns 0.
        """
        q = db.session.query(Meet)
        q = q.join(Meet.mdes).join(MeetDivisionEvent.athletes)
        q = q.filter(Athlete.id == self.id).distinct()
        q = q.order_by(Meet.date)
        return q.count()

    def get_events(self):
        q = db.session.query(EventDefinition)
        q = q.join(Athlete.entries).join(Entry.event)
        q = q.filter(Athlete.id == self.id).distinct()
        events = q.all()
        return events

    # UNUSED?
    # @staticmethod
    # def get_tuples_all_athletes():
    #     q = db.session.query(
    #             Athlete.fname, Athlete.lname, Athlete.id, School.name,
    #             School.id, EventDefinition.id, EventDefinition.name,
    #             EventDefinition.code, Division.id, Division.name, Division.code,
    #             Meet.id, Meet.name)
    #     q = q.filter(Entry.meet_id == Meet.id)
    #     q = q.filter(Entry.athlete_id == Athlete.id)


# #######################  ENTRY CLASS #####################
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
    athlete_id = db.Column(db.ForeignKey("athletes.id"), nullable=False)
    mde_id = db.Column(db.ForeignKey("meet_division_events.id"),
                       nullable=False)

    seed_num = db.Column(db.Integer, nullable=True)

    # An athlete's "mark" for a parituclar event is either his/her
    # time or distance thrown/jumped or height jumped. We store in seconds or
    # inches, with precision to the hundredth of a second and up to 1/4 inch.
    mark = db.Column(db.Numeric(12, 2), nullable=True)
    mark_type = db.Column(mark_type_enum, nullable=True)

    # TODO - this problem column probably violates normal form for the database
    # when use to denote an entry not gettign assigned to an MDE. 
    # Refactor.

    # describes a problem with the athlete's entry that a user needs to resolve
    problem = db.Column(db.String(64), nullable=True)

    # @aggregated('meet', db.Column(db.String(50)))
    # def meet_name(self):
    #     # return meet.name
    #     return db.func.max(Meet.name)

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
                               )

    event = db.relationship("EventDefinition",
                            secondary="meet_division_events",
                            uselist=False,
                            )

    school = db.relationship("School",
                             secondary="athletes",
                             uselist=False,
                             back_populates="entries")

    # editor_users = db.relationship("User", secondary="schools")

    def __init__(self, athlete, mde):
        self.athlete = athlete
        self.mde = mde
        if mde.event.is_track():
            self.mark = INFINITY_SECONDS
            self.mark_type = "seconds"
        else:                           # field event
            self.mark = 0
            self.mark_type = "inches"   # TODO one day handle meters

    def __repr__(self):
        return ("\n<ENTRY #{}, Ath: {}, school: {}, Event: {}, Div: {}, Meet: {}>"
                .format(
                    self.id, self.athlete.full_name(), self.athlete.school.code,
                    self.event.code, self.division.code, self.meet.name))

    # SETTING MARKS
    def set_mark(self, mark_string=None, mark_measure_type=None):
        """ If mark_string is empty or null, treat it as if no mark was
        submitted for that athlete. That means that we'll treat this entry's
        mark as "0" if it's a field event, and as positive infinity if it's a
        track event.

        ??? Assumes that this entry has already been committed to the
        sqlalchemy session.
        """
        # We can't use "is_track" until this entry has been committed, becaue
        # otherwise we can't get to the event relationship.
        if self.event.is_track():
            self.mark_type = "seconds"
            if mark_string is None or mark_string == "":
                self.mark = INFINITY_SECONDS
                return
            self.mark = Entry._time_string_to_seconds(mark_string)

        # field events
        elif mark_measure_type == "E" or mark_measure_type is None:
            self.mark_type = "inches"
            if mark_string is None or mark_string == "":
                # assume 0 inches when mark is not provided
                self.mark = 0
                return
            self.mark = Entry._field_english_string_to_inches(mark_string)

        else:
            # field event & mark_measure_type == "M"
            self.mark_type = "meters"
            if mark_string is None or mark_string == "":
                # assume 0 meters when mark is not provided
                self.mark = 0
            raise TmsError("Haven't implemented metric field measurements yet")

    @staticmethod
    def _time_string_to_seconds(time_string):
        """ Takes a string like '1:23.44.55, 1:19.14, 58.83, 13.4' and
        returns it in seconds, with resolution to the tenth or hundreth of a
        second

        TODO - deal with hand-timed marks, which have a 'h' at are measured to
        tenths of seconds (not hundredths):  eg.  12:34.3h
        """
        # turn the time string into a [seconds, minutes, hours] list
        t_list = time_string.split(':')[::-1]
        if t_list[-1][-1] == "h":
            raise TmsError("UNIMPLEMENTED: hand-timed marks")
        secs = 0
        for i in range(0, len(t_list)):
            secs += float(t_list[i]) * 60**i
        return secs

    @staticmethod
    def _field_english_string_to_inches(distance_string):
        """
        Converts an "English/Imperial" distance string in feet and inches into
        the number of inches (a float). If the string can't be converted,
        returns None.

        Examples 12' || 12' 10 || 12' 10.5 || 32' 4 || 5' 0
        TODO later: numbers like: 121025 12-10.25".

        NOTE: don't have to handle distances under 12 inches
        """
        dist_parts = distance_string.split()
        if dist_parts is None or len(dist_parts) == 0 or len(dist_parts) > 2:
            return None

        feet = dist_parts[0]
        if len(dist_parts) == 2:
            inches = dist_parts[1]
        else:
            inches = 0

        # verify feet has the ' character at the end, and then remove it.
        if feet[-1] != "'":
            return None
        feet = int(feet[0:-1])
        return float(inches) + (12 * feet)

    # ##### RETRIEVING AND PRINTING MARKS

    def mark_to_string(self):
        if self.mark is None:
            return ""
        if self.mark_type == "seconds":
            return self._seconds_mark_to_string()
        elif self.mark_type == "inches":
            return self._inches_mark_to_string()
        else:
            raise TmsError("UNIMPLEMENTED: metric field distance marks")

    def _seconds_mark_to_string(self):
        if self.mark == INFINITY_SECONDS:
            return ""
        return self._seconds_to_string(self.mark)

    @staticmethod
    def _seconds_to_string(total_seconds):
        """ Assumes total_seconds is always a positive float of precision
        to the hundredths of seconds. Returns well-formatted string like:
            hh:mm:ss.tt,  h:mm:ss.tt, mm:ss.tt,  m:ss.tt, ss.tt, s.tt
        """
        (hours, minutes, seconds) = (0, 0, 0.0)
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

    # ------

    def _inches_mark_to_string(self):
        if self.mark == 0:       # this is the same as no mark provided
            return ""
        inches = self.mark
        return self._inches_to_string(inches)

    @staticmethod
    def _inches_to_string(inches):
        feet = 0
        if inches >= 12:
            feet = int(inches // 12)
            inches = inches - feet * 12
        # TODO - Need to fix this so it will only return 10' 6" instead of
        # 10' 6.00" for events like the high jump that aren't measured so the
        # fraction of an inch

        if feet > 0:
            feet_str = "{:d}".format(feet) + "' "
        else:
            feet_str = ""
        return feet_str + "{:.2f}".format(inches) + '"'

    def get_heat_number(self):
        max_athletes_per_heat = self.mde.get_max_athletes_per_heat()
        if self.seed_num:
            return 1 + (self.seed_num - 1) // max_athletes_per_heat


# #######################  MEETDIVISION EVENT CLASS #####################

mde_status_enum = Enum(*MDE_STATUS, name="mde_status")


class MeetDivisionEvent(db.Model):
    """
    Associative table to handle the many to many relationship between Events,
    Divisions, and Meets. Aka "contests
    """
    __tablename__ = "meet_division_events"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    div_id = db.Column(db.ForeignKey("divisions.id"), nullable=False)
    meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    event_code = db.Column(db.ForeignKey("event_defs.code"), nullable=False)
    seq_num = db.Column(db.Integer, nullable=False)
    qualifying_mark = db.Column(db.Integer, nullable=True)
    status = db.Column(mde_status_enum, default="Unassigned", nullable=False)
    # notes about opening height, etc.
    mde_notes = db.Column(db.String(256), nullable=True)
    # The MDE can override  the Meet's overall max_heats
    max_heats = db.Column(db.Integer, nullable=True)
    # @aggregated('athletes', db.Column(db.Integer))
    # def athletes_count(self):
    #     return db.func.count('1')

    meet = db.relationship(
            "Meet", uselist=False, back_populates="mdes")
    division = db.relationship(
            "Division", uselist=False,
            )
    event = db.relationship(
            "EventDefinition", uselist=False,
            )
    entries = db.relationship(
            # in ascending order by mark, so in proper best-to-worst order for
            # track event seeding (where lowest time is best). 
            # But for field events we need to reverse it. (longest distance is 
            # the best performance)
            "Entry", uselist=True, order_by="Entry.mark",
            back_populates="mde")

    athletes = db.relationship(
            "Athlete", secondary="entries", uselist=True,
            back_populates="mdes")


    def __repr__(self):
        return "\nMeetDivEvent#{}: Seq#:{}, Meet: '{}', Event: {}, Division: {}".format(
                self.id,
                self.seq_num,
                self.meet.name,
                self.event.code,
                self.division.name)

    @classmethod
    def generate_mdes(cls, meet, events_list, divisions_list):
        """ For this meet, from the provided list of Division objects
        EventDefinition objects, generates all the MDE objects and assigns
        each MDE sequence number of the order each MDE will take place within
        the meet.

        divisions_list is an ordered list of Division instances. The order is
        the sequence in which divisions participate within a given event at
        this meet.

        events_list is an order list of EventDefinition instances. The list's
        order is the order in which this meet's events take place.
        """
        seq_num = 1
        for event in events_list:
            for division in divisions_list:
                mde = MeetDivisionEvent()
                mde.meet = meet
                mde.division = division
                mde.event = event
                mde.seq_num = seq_num
                db.session.add(mde)
                seq_num += 1

        db.session.commit()


    def get_max_heats(self):
        if self.max_heats:
            # The MDE is using its own setting for max heats that is 
            # overriding the meet-wide setting
            return self.max_heats
        else:
            # this isn't set at the MDE level, so use the
            # meet-wide setting
            return self.meet.max_heats_per_mde

    def get_max_athletes(self):
        return self.get_max_heats() * self.event.max_per_heat

    def get_max_athletes_per_heat(self):
        return self.event.max_per_heat

    def get_num_assigned_heats(self):
        # import ipdb; ipdb.set_trace()
        if len(self.entries) == 0:
            return 0
        if len(self.entries) < self.get_max_athletes():
            return 1 + (len(self.entries)-1) // self.get_max_athletes_per_heat()
        return self.get_max_heats()

    def assign_seed_numbers(self):

        #if seed_tiebreaker == "random": 
        # TODO - handle other types of tie breakers.
        # make a copy because sqlalchemy doesn't let me reorder it
        entries = self.entries[:]

        # put the entire entry list in random order so that for ties or no-mark 
        # situations, that we don't pull in all kids from one school
        shuffle(entries)

        # now sort according to mark order. If marks are tied (as will be the case
        # if no mark was submitted with the entry, it will still be in the random 
        # order from previous step.
        if self.event.is_track():
            # track events. Best mark is the lowest num seconds.
            entries.sort(key=lambda ent: ent.mark, reverse=False)
        else:
            # field events. Best mark is the most inches/meters.
            entries.sort(key=lambda ent: ent.mark, reverse=True)

        # self.entries should now be in sorted order for this event
        # type, with ties randomly ordered. So now, assign seed numbers
        seed_num = 1
        max_athletes = self.get_max_athletes()

        for entry in entries:
            if seed_num <= max_athletes:
                entry.seed_num = seed_num
                seed_num += 1
            else:
                self.seed_num = None
                entry.problem = (
                    "Athlete not assigned to mde#{}: {} - {}".format(
                        self.id, self.event.code,
                        self.division.code))
        self.status = "Assigned"
        db.session.commit()


    def get_num_assignments(self):
        if self.status == "Unassigned":
            return 0
        if self.get_max_athletes() < len(self.entries):
            return self.get_max_athletes()
        return len(self.entries)


# #######################  SCHOOL CLASS #####################
@generic_repr
class School(db.Model):
    """
    """
    __tablename__ = "schools"

    # Set up so that the "Unattached" School always uses primary key #1
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # TODO - change this to code
    code = db.Column(db.String(8), unique=True, nullable=False)
    name = db.Column(db.String(50), unique=True, nullable=False)
    league = db.Column(db.String(6), nullable=True)
    section = db.Column(db.String(12), nullable=True)
    city = db.Column(db.String(30), nullable=True)
    state = db.Column(db.String(2), nullable=True)

    # @aggregated("athletes", db.Column(db.Integer))
    # def athletes_count(self):
    #     return db.func.count('1')

    # @aggregated("entries", db.Column(db.Integer))
    # def entries_count(self):
    #     return db.func.count('1')

    athletes = db.relationship(
            "Athlete", uselist=True,
            order_by="Athlete.lname", back_populates="school")

    entries = db.relationship(
            "Entry", secondary="athletes", uselist=True,
            back_populates="school")

    divisions = db.relationship(
        "Division", secondary="athletes", uselist=True)

    coaches = db.relationship("User", uselist=True, backref="editor_users")

    meets_hosted = db.relationship(
            "Meet", uselist=True,
            primaryjoin="Meet.host_school_id==School.id",
            order_by="Meet.date",
            back_populates="host_school")
    # meets_invited = db.relationship(
    #         "Meet", uselist=True, back_populates="invited_schools")


    def __init__(
            self, name="Unattached", code="UNA", city=None, state=None,
            league=None, section=None):
        self.name = name
        self.code = code
        if city:
            self.city = city.title()
        if state:
            self.state = state.upper()
        if league:
            self.league = league.upper()
        if section:
            self.section = section.upper()

    def __repr__(self):
        return "<SCHOOL id#{}: {}, {}>".format(self.id, self.name, self.code)

    @classmethod
    def init_unattached_school(cls):
        """ Creates the "unattached" school in the database if it isn't already
        in the database. Should only call this once, right after
        the database tables are created, before any athletes are created.

        TO DO - get rid of this nethod and have this record created
        automatically when the table is created via an event listener. Because
        this must be called immediatley after table initialization and not at
        any other time.
        """
        unattached_school = School.query.filter_by(code="UNA").one_or_none()
        if unattached_school is None:
            new_unattached_school = cls(name="Unattached", code="UNA")
            db.session.add(new_unattached_school)
            db.session.commit()

    def meets_entered(self, meet_status=None, include_past_meets=False):
        """ Returns a list of meets where this school has any athletes entered
        """
        q = db.session.query(Meet).join(Meet.entries).join(Entry.school)
        q = q.filter(School.id == self.id).distinct()
        if meet_status:
            q = q.filter(Meet.status == meet_status)
        if not include_past_meets:
            q = q.filter(Meet.date > datetime.now() - timedelta(days=1))
        q = q.order_by(Meet.date)
        meets = q.all()
        num_meets = q.count()
        info(f"School {self.name} is in **{num_meets}** meets:")
        for m in meets:
            info(f"\t\t\t{m.name}, {m.date}")
        return meets


# #######################  EVENTDEFINITION CLASS #####################


event_type_enum = Enum(*EVENT_TYPES, name="event_types")


class EventDefinition(db.Model):
    """
    """
    __tablename__ = "event_defs"

    code = db.Column(db.String(6), primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    etype = db.Column(event_type_enum, nullable=False)
    max_per_heat = db.Column(db.Integer, nullable=True)

    mdes = db.relationship("MeetDivisionEvent")
    # divisions = db.relationship("Division", secondary="meet_division_events")
    entries = db.relationship("Entry", secondary="meet_division_events")


    def __repr__(self):
        return "\n<EVENT_DEF {}, Name: {}, Type: {}>".format(
                self.code,
                self.name,
                self.etype,
                self.max_per_heat)

    @classmethod
    def generate_event_defs(cls, event_list):
        """
        Side Effects: Writes to the database

        event_list is a tuple of event_dictionaries:
        eg: ({"code": "100M", "name": "100 Meter", "type": "sprint"})
        """
        edef_list = []
        for e_dict in event_list:
            edef_list.append(cls(code=e_dict["code"],
                                 name=e_dict['name'],
                                 etype=e_dict['type'],
                                 max_per_heat=e_dict['max_per_heat']))
        db.session.add_all(edef_list)
        db.session.commit()
        return edef_list

    def is_field(self):
        if self.etype in ['horzjump', 'vertjump', 'throw']:
            return True
        return False

    def is_track(self):
        return not self.is_field()

    def is_indiv(self):
        if self.etype is not 'relay':
            return True
        return False


# #######################  EVENTORDERING CLASS #####################
class EventOrdering(db.Model):
    """ the order in which divisions participate in each event can differ from
        meet to meet
    """
    __tablename__ = "event_ordering"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    event_code = db.Column(db.ForeignKey("event_defs.code"), nullable=False)
    seq_num = db.Column(db.Integer, nullable=False)

    event = db.relationship(
            "EventDefinition", uselist=False, backref="event_orderings")
    meet = db.relationship(
            "Meet", uselist=False, back_populates="event_orderings")

    @classmethod
    def create_events_in_order(cls, meet, ev_code_order):
        events = []
        seq_num = 1
        if not ev_code_order:           # None or empty list
            events = EventDefinition.query.order_by('code').all()
            for event in events:
                e_o = EventOrdering(
                        meet=meet, event_code=event.code, seq_num=seq_num)
                db.session.add(e_o)
                seq_num += 1
        else:
            for ev_code in ev_code_order:
                event = EventDefinition.query.filter_by(code=ev_code).one()
                events.append(event)
                e_o = EventOrdering(
                        meet=meet, event_code=ev_code, seq_num=seq_num)
                db.session.add(e_o)
                seq_num += 1
        db.session.commit()
        return events

    @staticmethod
    def get_default_event_order_codes():
        return DEFAULT_EVENT_ORDER

# #######################  DIVISION CLASS #####################
gender_enum = Enum(*GENDERS, name="gender")
grade_enum = Enum(*GRADES, name='grade')
adult_enum = Enum(*ADULT_CHILD, name='adultchild')


class Division(db.Model):
    __tablename__ = "divisions"
    id = db.Column(db.Integer(), primary_key=True, autoincrement=True)
    gender = db.Column(gender_enum, nullable=False)
    # In some meets, divisions are not determined by grade, so null is ok.
    grade = db.Column(grade_enum, nullable=True)
    code = db.Column(db.String(5), unique=True, nullable=False)
    name = db.Column(db.String(20), unique=True, nullable=False)

    athletes = db.relationship(
            "Athlete", uselist=True, back_populates="division")

    def __init__(self, gender, grade=None, adult_child='child',
                 name=None, code=None):

        if gender not in GENDERS:
            raise TmsError(f"Illegal Gender: {gender}")
        if grade:
            if grade not in GRADES:
                # A none grade is allowed
                raise TmsError(f"Illegal Grade: {grade}")

        self.gender = gender
        self.grade = grade

        if name:
            self.name = name.title()
        else:
            self.name = self._derive_name(gender, grade, adult_child)

        if code:
            self.code = code.upper()
        else:
            self.code = self._derive_code(gender, grade)

    def __repr__(self):
        return "<DIVISION id#{}: {} - {}>".format(
            self.id, self.code, self.name)

    @staticmethod
    def _derive_code(gender, grade=None):
        if grade:
            code = f"{grade}{gender}"
        else:
            code = f"{gender}"
        return code.upper()

    @staticmethod
    def _derive_name(gender, grade=None, adult_child="child"):
        gender_string = f"{DIV_NAME_DICT[adult_child][gender]}"
        if grade:
            name = f"Grade {grade} {gender_string}"
        else:
            name = gender_string
        return name.title()

    @classmethod
    def generate_grade_gender_divisions(cls, gender_list, grade_list):
        """
        Generate a combination of divisions for every combination of genders
        and grades and returns them in a list. If a particular division already
        exists in the database, don't add it again, but do include in the
        returned list.

        SIDE EFFECT: adds and commits records to the database.
        """
        divs = []
        for gender_str in gender_list:
            for grade_str in grade_list:
                if (not grade_str.isnumeric()
                        or int(grade_str) < 1
                        or int(grade_str) > 12):
                    err_msg = (
                        "Division Generation by grade/gender failed."
                        + f" Grade:{grade_str}, gender:{gender_str}."
                        + " Grade must be numeric and 12 or lower")
                    raise TmsError(err_msg)

                # don't create a duplicate division
                div = Division.query.filter_by(
                        gender=gender_str,
                        grade=grade_str).one_or_none()
                if div is None:
                    div = Division(gender=gender_str,
                                   grade=grade_str,
                                   adult_child="child")
                    db.session.add(div)
                divs.append(div)
        db.session.commit()
        return divs

    @classmethod
    def generate_gender_only_divisions(cls, gender_list):
        divs = []
        for gender in gender_list:
            div = Division(gender=gender, adult_child="child")
            db.session.add(div)
            divs.append(div)
        db.session.commit()
        return divs


# #######################  DIVORDERING CLASS #####################
class DivOrdering(db.Model):
    """ the order in which divisions participate in each event  can differ from
        meet to meet """
    __tablename__ = "div_orderings"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    meet_id = db.Column(db.ForeignKey("meets.id"), nullable=False)
    div_id = db.Column(db.ForeignKey("divisions.id"), nullable=False)
    seq_num = db.Column(db.Integer, nullable=False)

    division = db.relationship(
            "Division", uselist=False)
    meet = db.relationship(
            "Meet", uselist=False, back_populates="div_orderings")

    def __repr__(self):
        return f"<DIVORDERING: id={self.id}, meet_id={self.meet_id}, " \
               "div={self.division.code} seq_num={self.seq_num}".format(
                self=self)

    @classmethod
    def create_divs_in_order(cls, meet, divcode_order):
        """ Creates the division ordering for this meet and returns
            the div objects corresponding to it in order in a list.
        """
        divs = []
        seq_num = 1

        if not divcode_order:  # none or empty list
            divs = Division.query.order_by('code').all()
            for div in divs:
                d_o = DivOrdering(meet=meet, division=div, seq_num=seq_num)
                db.session.add(d_o)
                seq_num += 1
        else:
            for divcode in divcode_order:
                div = Division.query.filter_by(code=divcode).one()
                d_o = DivOrdering(meet=meet, division=div, seq_num=seq_num)
                divs.append(div)
                db.session.add(d_o)
                seq_num += 1
        db.session.commit()
        return divs

    @staticmethod
    def get_default_division_order_codes():
        return DEFAULT_DIVISION_ORDER

# #######################  USER  CLASS #####################

user_role_enum = Enum(*USER_ROLES, name="user_roles")


class User(db.Model):
    """ User of TrackMeetSimplicity website."""

    __tablename__ = "users"

    id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    email = db.Column(db.String(64), nullable=True)
    password = db.Column(db.String(64), nullable=True)
    school_id = db.Column(db.ForeignKey("schools.id"), nullable=True)
    role = db.Column(user_role_enum, nullable=False, default="coach")

    # TO DO - fix the following so the back_population doesn't happen for users
    # associated with a school who are not in the "coaches" role
    school = db.relationship(
            "School", uselist=False, back_populates="coaches")
    meets_managed = db.relationship(
            "Meet", secondary="schools", uselist=True,
            back_populates="manager_users")

    def __repr__(self):
        return "<USER #{}, {}, school={}, role={}".format(
            self.id, self.email, self.school, self.role)

    @classmethod
    def create_superuser(cls):
        # TODO - get rid of this method and have a superuser be auto-created
        # when table is first created
        # TODO - SUPERUSER_PPASSWORD Should be from the Secrets File, not 
        # hardcoded into the constant_models file
        superuser = User(
            email=SUPERUSER_EMAIL, password=SUPERUSER_PASSWORD,
            role="superuser")
        db.session.add(superuser)
        db.session.commit()


# ##############  HELPER FUNCTIONS ###########################
# Helper functions
def connect_to_db(app, db_uri="tms-dev", debug=True):
    """ Configure to use dev version of PostgreSQL DB & connect it to Flask app.
    NOTE: doesn't create the tables
    """
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:///" + db_uri
    app.config["SQLALCHEMY_ECHO"] = debug
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["DEBUG"] = debug
    db.app = app
    db.init_app(app)
    info("Connected to DB")


def reset_database():
    """ Deletes all tables from db and our entire SQLAlchemy session
    After running this, the db still exists but is empty, and the SQLAlchmey
    session is stable.
    """
    db.session.remove()
    db.drop_all()
    db.engine.dispose()


if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    db.session.remove()
    db.drop_all()
    db.create_all()
    TmsApp()
