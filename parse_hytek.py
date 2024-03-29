""" This file parses a "Hytek" meet entry file, which is in a semicolon
separated format.  Details on this file format follow:
"""

from sqlalchemy.orm.exc import NoResultFound

from model import (Athlete, Entry, MeetDivisionEvent, TmsError, db)

from util import warning, error, info

# Translate HyTek's codes for events into our codes
ht_event_translator = {'100': '100M', '200': '200M', '400': '400M',
                       '800': '800M', '1600': '1600M', '3200': '3200M'}


def parse_hytek_file(filename, meet):
    """
    Opens a hytek entry file, parses it and writes the records to the database
    """
    with open(filename) as file:
        for line in file:
            tokens = line.strip().split(';')
            linetype = tokens[0]

            if linetype == "I":
                parse_athlete(tokens)
            elif linetype == "D":
                parse_entry(tokens, meet)
            elif linetype == "Q":
                parse_relay(tokens)
            else:
                warning(f"Ignoring unknown line type: {line}")


def parse_athlete(tokens):
    """
    Parses an "I" line record from a Hytek meet entry file that contains
    athlete information, and adds the athlete to our database.

    SIDE EFFECTS: Adds athlete to the Database. Also adds the athlete's school
    to the database if it isn't already in it.

    I LINE FORMAT:
    <token #> <data> <numchars>  <notes>
    0   I           1   Information Record
    1   Last Name   20  (Required)
    2   First Name  20  (Required)
    3   Initial     1
    4   Gender      1   M = Male, F = Female (Required)
    5   Birth Date  10  MM/DD/YYYY (Optional)
    6   Team Code   4   4 character max; use UNA if unknown (Required)
    7   Team Name   30  Use Unattached if unknown (Required)
    8   Age         3   Optional if birth date provided
    9  School Year 2   (Optional according to HyTek, but TMS requires it)
    17  Home Phone  20  (Optional)

    NOTE: We REQUIRE School Year, even though valid HyTek files might not.
    """

    tokens = tokens[:]  # make a copy so we don't mutate the original list
    if len(tokens) < 10:
        error(f"I-Line requires at least 10 fields. <{tokens}>")

    (_junk1, last_name, first_name, middle, gender, _junk2, team_code,
        team_name, _junk3, grade) = tokens[0:10]

    athlete = Athlete.add_athlete_to_db(
        first_name, middle, last_name, gender, grade, team_code, team_name)
    if athlete is None:
        # athlete might be null because there were issues with the file's
        # record (such as no matching division. if that's the case, just move
        # on to the next record
        # TODO - message user about problem with adding user
        return

    # If present in this I-record, add the athlete's phone (for SMS) to db
    # This will override any previous phone numbers for this athlete
    if len(tokens) > 17:
        if tokens[17] != "":
            athlete.phone = tokens[17]
        db.session.commit()


def parse_entry(tokens, meet):
    """
    Parses a "D-Line" in a Hytek entry file that corresponds to an athlete's
    entry into a particular event within a meet.

    D-Line format
    <Token#> <Data> <MaxChar>  <Description>
    0   D           1   Individual Entry Record
    1   Last Name   20  (Required)
    2   First Name  20  (Required)
    3   Initial     1   (Optional)
    4   Gender      1   M = Male, F = Female (Required)
    5   Birth Date  10  MM/DD/YYYY (Optional)
    6   Team Code   4   4 characters max; use UNA if unknown (Required)
    7   Team Name   30  Use Unattached if unknown (Required)
    8   Age         3   Age is optional if birth date provided
    9  School Year  2   (Optional for HyTek, but not for TMS)
    10  Event Code  10  Examples: 100, 5000S, 10000W, SP, HJ, DEC
    11  Entry Mark  11  Time: hh:mm:ss.tt (1:23.44.55, 1:19.14, 58.83, 13.4h)
                        Field Metric: 12.33, 1233;
                        Field English: 12-10.25", 12', 121025, 12' 10
                        Combined-event: 3020 (points)
    12  Mark measure 1  M for Metric, E for English (Required if Entry Mark
                        provided)
    """

    if len(tokens) < 11:
        error(f"HyTek D-Line requires at least 11 fields. <{tokens}>")

    (_junk1, last_name, first_name, middle, gender, _junk2, team_code,
        team_name, _junk3, grade, ht_event_code) = tokens[0:11]

    athlete = Athlete.add_athlete_to_db(
        first_name, middle, last_name, gender, grade, team_code, team_name)

    # If the athlete's record in file was bad, add_athlete_to_db returns None.
    if athlete is None:
        warning(f"Skipping athlete {first_name} {last_name}")
        return

    # translate the HyTek event names into TMS event codes
    event_code = ht_event_translator.get(ht_event_code, ht_event_code)

    q = MeetDivisionEvent.query
    try:
        mde = q.filter_by(meet_id=meet.id,
                          event_code=event_code,
                          div_id=athlete.division.id).one()
    except NoResultFound:
        raise TmsError("MDE doesn't exist: meet #{}, event {}, div {}".format(
            meet.id, event_code, athlete.division.code))

    entry = Entry(athlete=athlete, mde=mde)
    # we need to commit here, or else we can't see the event in the below call
    # of entry.set_mark method.
    db.session.add(entry)
    db.session.commit()
    info(f"Added entry: {entry}")

    # If the athlete's entry includes a seed mark for this event, set it
    if len(tokens[11:13]) == 2:
        entry.set_mark(mark_string=tokens[11], mark_measure_type=tokens[12])

    # I don't understand why, but at this point the entry thinks its "event"
    # attribute is "None", even after I setup the relationship with the mde,
    # which should also get me the event. I believe this shoudl be possible
    # without adding the entry to the session and commiting.
    db.session.commit()
    info("Set entry's mark. Entry: {}. Mark:{}".format(
        entry.event.code, entry.mark_to_string()))


def parse_relay(tokens):
    pass


"""
# ################
INFORMATION FROM HYTEK:

A semi-colon delimited format is available for importing entries, relays,
rosters, and addresses. Semi-Colon Delimited Import was created as a courtesy
to our users for importing entry/roster data into MM in a plain text file.

If you wish to use this feature, please note that HY-TEK does not support
semi-colon delimited import other than the guidance provided below.

To import, click File / Import / Semi-Colon Delimited Rosters/Entries File.
When importing using the semi-colon delimited format, if a mark is out of r
ange and you answer "No" to use the mark, the athlete, team, and mark will be
listed on the Exception Report. If an athlete's first name is missing, this
too will be listed on the exception report. And thirdly, when importing, the
last directory used for the import file will become the default directory for
the next import.

There are five file types:
I = Information Record (25 fields separated by semi-colons)
D = Individual Entry Record (20 fields separated by semi-colons)
E = Individual Entry Record (15 fields separated by semi-colons)
Q = Relay Entry Record (15 or more fields separated by semi-colons)
R = Relay Entry Record (10 or more fields separated by semi-colons)

It is preferred that the D file type be used instead of the E file type and
that the Q file type be used instead of the R file type. These newer D and Q
file types contain more information.



FILE FORMAT RULES

1. If no information for a given field, leave it blank, but include the
semi-colon.

2. Each record must be followed by a carriage return & line feed.

3. If at any point in a record, all remaining fields in the record are blank,
it can be ended with a carriage return without all the extra semi-colons.

4. For each athlete there can be one information record. You create one E
record or D record for each individual entry. The 2nd thru 10th fields of
both the I, D and E record types are identical. One relay per relay entry
record with up to 8 relay runner names.

5. The order of each record makes no difference.

6. For each I, D or E record for the same athlete, fields 2 through 8 must
be the same.

7. The I record is optional and thus not required.



****  DETAIL ON THE I RECORD  (ATHLETE INFORMATION) ******
Data   Max   Notes for the I Record
1   I   1   Information Record
2   Last Name   20   (Required)
3   First Name   20   (Required)
4   Initial   1
5   Gender   1   M = Male, F = Female (Required)
6   Birth Date   10   MM/DD/YYYY (Optional)
7   Team Code   4   4 character max; use UNA if unknown (Required)
8   Team Name   30   Use Unattached if unknown (Required)
9   Age   3   Optional if birth date provided
10   School Year   2   (Optional)
11   Address line 1   30
12   Addr 2 / Province   30
13   City   30
14   State   3   state code for USA, Canada, Australia, etc.
15   Zip   10
16   Country   3   use country code, such as USA, GER, AUS
17   Citizen Country   3   use country code, such as FRA, CAN, BRA
18   Home Phone   20
19   Office Phone   20
20   Fax #   20
21   Shirt size   4   S, M, L, XL, etc.
22   Registration #   15
23   Competitor #   5
24   E-mail   30
25   Disabled classification 20

Example: I; Doe; John; P; M; 09/07/1947; USA; United States; ; ;3395 West Street; Suite 101; Sullivan; ME; 04664; USA; USA; 207-422-6243; ; ; XL; 49-345-6789;296;mm@hy-tekltd.com [Carriage Return]


****  DETAIL ON THE D RECORD  (ATHLETE EVENT ENTRY) ******
  Data   Max   Notes for the D Record
1   D   1   Individual Entry Record
2   Last Name   20   (Required)
3   First Name   20   (Required)
4   Initial   1   (Optional)
5   Athlete Gender   1   M = Male, F = Female (Required)
6   Birth Date   10   MM/DD/YYYY (Optional)
7   Team Code   4   4 characters max; use UNA if unknown (Required)
8   Team Name   30   Use Unattached if unknown (Required)
9   Age   3   Age is optional if birth date provided
10   School Year   2   (Optional)
11   Event Code   10   Examples: 100, 5000S, 10000W, SP, HJ, DEC
12   Entry Mark   11   Time: hh:mm:ss.tt (1:23.44.55, 1:19.14, 58.83, 13.4h)
        Field Metric: 12.33, 1233;
        English: 12-10.25", 12', 121025
        Combined-event: 3020 (points)
13   Event measure   1   M for Metric, E for English (Required)
14   Event Division   2   A Division number; Optional; For JV, Varsity, 6G, etc
15   Competitor #   5   Optional
16   Finish Place   2   Place from prior round if an advancer (optional)
17   Declaration Status   1   D = Declared, S = Scratched, A = Alive,
                              blank = Undeclared (optional)
18   Entry Note   60   Optional
20   Alternate 1 Optional Y=Is Alternate

Example: D;Doe;John;P;M;09/07/1947;HURR;Hurricane High School;;;SP;21.23;M;;304;;D;Qualified 12-05[CRLF]


****  DETAIL ON THE E RECORD  (ABBREVIATED ATHLETE EVENT ENTRY) ******
  Data   Max   Notes for the E Record
1   E   1   Individual Entry Record
2   Last Name   20   (Required)
3   First Name   20   (Required)
4   Initial   1   (Optional)
5   Athlete Gender   1   M = Male, F = Female (Required)
6   Birth Date   10   MM/DD/YYYY (Optional)
7   Team Code   4   4 characters max; use UNA if unknown (Required)
8   Team Name   30   Use Unattached if unknown (Required)
9   Age or Comp #   5   Age is optional if birth date provided; or enter comp#
10   School Year   2   (Optional)
11   Event Code   10   Examples: 100, 5000S, 10000W, SP, HJ, DEC
12   Entry Mark   11   Time: hh:mm:ss.tt (1:23.44.55, 1:19.14, 58.83, 13.4h)
        Field: Metric: 12.33, 1233;
        English: 12-10.25", 12', 121025
        Combined-event: 3020 (points)
13   Event measure   1   M for Metric, E for English (Required)
14   Event Div or   2   A Division number; Optional; For JV, Varsity, Gr6, etc.
        Finish Place or can be the finish place from prior round of advancers
15  Alternate 1 Optional Y=Is Alternate

Ex: E;Doe;John;P;M;09/07/1947;HURR;Hurricane High School;;;SP;21.23;M;[CRLF]



NOTES ON ENTRIES FOR INDIVIDUAL EVENTS
1. One D or E record per individual entry; 4 entries for same athlete
requires 4 D or E records.

2. For Open meets, birth date and age are not required.

3.For division meets with birth date ranges, birth date is required, but if
division number is used, birth date is not required.

4.For division meets without birth date ranges, division number is required.

5.For age group meets, the age is required. However, if the birth date is
entered, the age is not required.

6. For meets that are not division meets and where the entries are advancers
going to the next higher level meet, the division slot in the E record can be
used for the place finish in the prior round.

7.The competitor number can be entered in the I record or it can be included
in the E record in place of the Age (this assumes you are not entering an age).
The D record has a separate field for the comp#.



EVENT CODES:

Running Events:   Distance without commas, such as 100, 800, 3200, 10000,
1MILE, 2MILE, HMAR half marathon, MAR
Note: For the 800 and longer, MM must have these events setup as Runs.
If they are setup as Dashes, they will not be imported.

Hurdle Events:   Distance plus H, such as 80H, 400H.

Steeplechase Events:   Distance plus S, such as 2000S, 3000S.

Race Walk Events:   Distance plus W, such as 5000W, 20000W.

Field Events:   HJ High Jump, PV Pole Vault, LJ Long Jump, TJ Triple Jump,
SP Shot Put, DT Discus, HT Hammer, JT Javelin, WT Weight Throw,
SWT Super Weight Throw

Combined-Events:   DEC Decathlon, HEP Heptathlon, IPENT Indoor Pentathlon,
OPENT Outdoor Pentathlon, TRI Triathlon, WPENT Weight Pentathlon, BI Biathlon,
TET Tetrathlon, OCT Octathlon


*** NOTES ON Q-RECORD - ENTRY OF ATHLETES INTO A RELAY****
Q RECORD (RELAYS)
  Data   Max   Note for the Q Record
1   Q   1   Relay Entry Record
2   Team Code   4   4 characters max; use UNA if unknown (Required)
3   Team Name   30   Use Unattached if unknown (Required)
4   Relay Letter   1   A, B, C, etc.
5   Relay Gender   1   M = Male, F = Female, X = Mixed (Required)
6   Relay Age   3   Required for age group meets
7   Event Code   10   Examples: 400, 1600S, 3200D
8   Entry Time   10   Time: hh:mm:ss.tt (44.55, 4:19.14)
9   Event meas.   1   M for Metric, E for English (Required)
10   Event Division   2   A Division number; Optional; For JV, Varsity, etc.
11   Finish Place   2   Place from prior round if an advancer (optional)
12   Declaration Status   1   D = Declared, S = Scratched, A = Alive,
                              blank = Undeclared (optional)
13   Entry Note   60   Optional
14   Spare   For future use
15   Spare   For future use
     == Runner number 1 ==
16   R1 Last Name   20
17   R1 First Name   20
18   R1 Initial   1
19   Athlete Gender   1   M = Male, F = Female (Required)
20   Birth Date   10   MM/DD/YYYY (Optional)
21   Age   5   Age is optional if birth date provided
22   School Year   2   Optional
23   Competitor #   5   Optional
     == Runner number 2 ==
24   R2 Last Name   20
25   R2 First Name   20
26   R2 Initial   1
27   Athlete Gender   1   M = Male, F = Female (Required)
28   Birth Date   10   MM/DD/YYYY (Optional)
29   Age   5   Age is optional if birth date provided
30   School Year   2   Optional
31   Competitor #   5   Optional
    ==Runner end==
Alternate 1 Optional Y=Is Alternate

== Continue same pattern for runners 3 through 8 ==

Example:
Q;HURR;Hurricanes;A;M;;1600;4:01.44;M;;;D;Altitude;;;
Doe;John;P;M;09/07/1977;;SR;189;Jackson;Jim;;M;;;JR;186;
Avery;Mark;A;M;10/20/1979;;SO;190;Lathrop;Terry;T;M;01/08/1980;;SR;199[CRLF]




*** NOTES ON R-RECORD - ENTRY (abbreviated) OF ATHLETES INTO A RELAY****

  Data   Max   Note for the R Record
1   R   1   Relay Entry Record
2   Team Code   4   4 characters max; use UNA if unknown (Required)
3   Team Name   30   Use Unattached if unknown (Required)
4   Relay Letter   1   A, B, C, etc.
5   Relay Gender   1   M = Male, F = Female, X = Mixed (Required)
6   Relay Age   3   Required for age group meets
7   Event Code   10   Examples: 400, 1600S, 3200D
8   Entry Time   10   Time: hh:mm:ss.tt (44.55, 4:19.14)
9   Event meas.   1   M for Metric, E for English (Required)
10   Event Div or   2   A Division number; Optional; For JV, Varsity, etc.
        Finish Place or can be the finish place from prior round of advancers
     == Runner number 1 ==
11   R1 Last Name   20
12   R1 First Name   20
13   R1 Initial   1
14   Athlete Gender   1   M = Male, F = Female (Required)
15   Birth Date   10   MM/DD/YYYY (Optional)
16   Age or Comp#   5   Age is optional if birth date provided; or enter
                        competitor#
17   School Year   2   (Optional)
     == Runner number 2 ==
18   R2 Last Name   20
19   R2 First Name   20
20   R2 Initial   1
21   Athlete Gender   1   M = Male, F = Female (Required)
22   Birth Date   10   MM/DD/YYYY (Optional)
23   Age or Comp#   5   Age is optional if birth date provided; or enter
                        competitor#
24   School Year   2   (Optional)
    ==Runner end==
Alternate 1 Optional Y=Is Alternate

== Continue same pattern for runners 3 through 8 ==

Example:
R;HURR;Hurricanes;A;M;;1600;4:01.44;M;;Doe;John;P;M;09/07/1977;;SR;
Jackson;Jim;;M;;;JR;Avery;Mark;A;M;10/20/1979;;SO;Lathrop;Terry;T;M;01/08/1980;;SR[CRLF]

NOTES FOR RELAYS
1.   For Open meets, relay age is not required.
2.   For division meets, event division is required.
3.    For age group meets, the age is required.
4. The competitor number can be entered in the I record or it can be
included in the R record in place of the Age for each runner (this assumes
you are not entering an age). The Q record has separate fields for the comp#'s.


RELAY EVENT CODES

Regular relays:   Just the distance without commas, such as 400 for 4x100,
1600 for 4x400, 4 for 4Mile relay.

Sprint Medley relay:   Distance plus S, such as 1600S.

Distance Medley relays:   Distance plus D, such as 3200D.

Shuttle Hurdle relay:   Distance plus H, such as 240H.

"""
