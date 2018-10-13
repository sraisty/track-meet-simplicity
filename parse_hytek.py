""" This file parses a "Hytek" meet entry file, which is in a semicolon
separated format.  Details on this file format follow:


################
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
14   Event Division   2   A Division number; Optional; For JV, Varsity, Bantam, etc.
15   Competitor #   5   Optional
16   Finish Place   2   Place from prior round if an advancer (optional)
17   Declaration Status   1   D = Declared, S = Scratched, A = Alive, blank = Undeclared (optional)
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

Example: E;Doe;John;P;M;09/07/1947;HURR;Hurricane High School;;;SP;21.23;M;[CRLF]



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

import sys
from model import Athlete, School, Entry
from util import warn, error, info


def open_hytek_file(filename):
    """
    Opens a hytek entry file, parses it and writes the records to the database
    """

    with open(filename) as file:
        for line in file:
            tokens = line.strip().split(';')
            linetype = tokens[0]
            if linetype == "I":
                parse_athlete_info(tokens)
            elif linetype == "D" or linetype == "E":
                parse_event_entry(tokens)
            elif linetype == "Q" or linetype == "R":
                parse_relay_entry(tokens)


def parse_athlete_info(tokens):
    """
    This line is "optional", but if it is present, it must include at least the
    first 

    I LINE FORMAT:
    <filed> <data> <numchars>  <notes>
    1   I   1               Information Record
    2   Last Name   20      (Required)
    3   First Name   20     (Required)
    4   Initial   1
    5   Gender   1          M = Male, F = Female (Required)
    6   Birth Date   10     MM/DD/YYYY (Optional)
    7   Team Code   4       4 character max; use UNA if unknown (Required)
    8   Team Name   30      Use Unattached if unknown (Required)
    9   Age   3             Optional if birth date provided
    10   School Year   2   (Optional)
    18   Home Phone   20   (Optional)

    RULES:

    1. If no information for a given field, leave it blank, but include the
    semi-colon.

    2. Each record must be followed by a carriage return & line feed.

    3. At any point in a record, if all remaining fields are blank,
    it can be ended with a carriage return without all the extra semi-colons.

    4. For each athlete there can be one information record. You create one E
    record or D record for each individual entry. The 2nd thru 10th fields of
    both the I, D and E record types are identical. One relay per relay entry
    record with up to 8 relay runner names.

    5. The order of each record makes no difference.

    6. For each I, D or E record for the same athlete, fields 2 through 8 must
    be the same.

    7. The I record is optional and thus not required.

    """
    tokens = tokens[:]  # make a copy so we don't mutate the original list
    info(f"Parsing I-Line: {tokens}")
    if len(tokens) < 10:
        # TODO - one day, only require 7 fields. But for first release we
        # need files that have the School Year at tokens[9]
        error(f"I-Line requires at least 9 fields. <{tokens}>")

    (last_name,
     first_name,
     middle,
     gender,
     __birth_date,            # not using this in first release
     team_code,
     team_name,
     __age,                   # not using this in first release
     school_year) = tokens[1:10]

    # If present, use the athlete's phone number to send text alerts to him/her
    if tokens[17]:
        phone = tokens[17]
    else:
        phone = None

    # First check if this athlete's school is already in the meet, and make
    # sure it is a legal school
    school = School.query.filter_by(name=team_name,
                                    abbrev=team_code).one_or_none()

    # Check to make sure that this athlete belongs to an existing divisiion?
    division = Division.query.filter_by(gender_code=gender,
                                        grade=school_year).one_or_none()

    athlete = Athlete(fname=first_name, lname=last_name, middle=middle)
    if school:
        athlete.school = school

    return athlete


# ###############
if __name__ == "__main__":

    if len(sys.argv) > 1:
        athletes = open_hytek_file(sys.argv[1])
    else:
        print "Please provide the filename that contains athelete and event entry information."
