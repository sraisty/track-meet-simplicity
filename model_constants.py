SUPERUSER_EMAIL = "sraisty@spcinc.com"
SUPERUSER_PASSWORD = "12345"
USER_ROLES = ("superuser", "coach", "athlete", "other")

GENDERS = ('M', 'F')
MIDDLE_SCHOOL_GRADES = ('6', '7', '8')

HIGH_SCHOOL_GRADES = ('9', '10', '11', '12')
GRADES = MIDDLE_SCHOOL_GRADES + HIGH_SCHOOL_GRADES

ADULT_CHILD = ('adult', 'child')
DIV_NAME_DICT = {"child": {"M": "Boys", "F": "Girls"},
                 "adult": {"M": "Men", "F": "Women"}}

MIN_ATHLETES_PER_HEAT = 2

EVENT_TYPES = ("sprint", "distance", "relay",
               "vertjump", "horzjump", "throw", "hurdle")

MEET_STATUS = ("Unpublished", "Accepting Entries", "Awaiting Assignment",
               "Assignments Done", "Meet In Progress", "Completed")

MARK_TYPES = ("seconds", "inches", "meters")

MDE_STATUS = ("Unassigned", "Assigned")

SPORTS = ("outdoor", "indoor", "cross country")

# START_TYPE = ("allies", "lanes", "waterfall")

HEAT_FLIGHT_ASSIGN_METHOD = ("best-to-worst", "worst-to-best", "random")

TRACK_LANE_ASSIGN_METHOD = (
        "serpentine", "random", "team lanes")
FIELD_ORDER_ASSIGN_METHOD = (
        "best-to-worst", "worst-to-best", "teams alternate")

DEFAULT_EVENT_ORDER = ["4x100M", "1600M", "100H", "110H", "65H", "400M",
                        "100M", "800M", "300H", "200M", "3200M", "4x400M",
                        "HJ", "PV", "LJ", "TJ", "DT", "SP"]

DEFAULT_DIVISION_ORDER = ["6F", "7F", "8F", "6M", "7M", "8M"]

EVENT_DEFS = (
        {
            "code": "60M",
            "name": "60 Meter",
            "type": "sprint",
            "max_per_heat": 8,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "100M",
            "name": "100 Meter",
            "type": "sprint",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "200M",
            "name": "200 Meter",
            "type": "sprint",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "400M",
            "name": "400 Meter",
            "type": "sprint",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "600M",
            "name": "600 Meter",
            "type": "sprint",
            "max_per_heat": 8,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "800M",
            "name": "800 Meter",
            "type": "sprint",
            "max_per_heat": 12,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "1000M",
            "name": "1000 Meter",
            "type": "sprint",
            "max_per_heat": 12,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "1500M",
            "name": "1500 Meter",
            "type": "distance",
            "max_per_heat": 15,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "1600M",
            "name": "1600 Meter",
            "type": "distance",
            "max_per_heat": 15,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "MILE",
            "name": "Mile",
            "type": "distance",
            "max_per_heat": 15,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "3000M",
            "name": "3000 Meter",
            "type": "distance",
            "max_per_heat": 18,
            "indoor": True,
            "outdoor": False,
        },
        {
            "code": "3200M",
            "name": "3200 Meter",
            "type": "distance",
            "max_per_heat": 18,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "5000M",
            "name": "5000 Meter",
            "type": "distance",
            "max_per_heat": 24,
            "indoor": True,
            "outdoor": True,
        },
        {
            "code": "10000M",
            "name": "10000 Meter",
            "type": "distance",
            "max_per_heat": 30,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "3000S",
            "name": "3000 Meter Steeplechase",
            "type": "distance",
            "max_per_heat": 18,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "4x100M",
            "name": "4x100 Meter Relay",
            "type": "relay",
            "max_per_heat": 15,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "4x400M",
            "name": "4x400 Meter Relay",
            "type": "relay",
            "max_per_heat": 15,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "DMR",
            "name": "Distance Medley Relay",
            "type": "relay",
            "max_per_heat": 8,
            "outdoor": False,
        },
        {
            "code": "4x800M",
            "name": "4x800 Meter Relay",
            "type": "relay",
            "max_per_heat": 8,
            "outdoor": False,
            "indoor": False,
        },
        {
            "code": "55H",
            "name": "55 Meter Hurdles",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "60H",
            "name": "60 Meter Hurdles",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "65H",
            "name": "65 Meter Hurdles",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "100H",
            "name": "100 Meter Hurdles (Girls Only)",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "110H",
            "name": "110 Meter Hurdles (Boys Only)",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "300H",
            "name": "300 Meter Hurdles",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "400H",
            "name": "400 Meter Hurdles",
            "type": "hurdle",
            "max_per_heat": 8,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "LJ",
            "name": "Long Jump",
            "type": "horzjump",
            "max_per_heat": 13,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "TJ",
            "name": "Triple Jump",
            "type": "horzjump",
            "max_per_heat": 13,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "DT",
            "name": "Discus Throw",
            "type": "throw",
            "max_per_heat": 13,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "SP",
            "name": "Shot Put",
            "type": "throw",
            "max_per_heat": 13,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "JT",
            "name": "Javelin Throw",
            "type": "throw",
            "max_per_heat": 13,
            "outdoor": True,
            "indoor": False,
        },
        {
            "code": "HT",
            "name": "Hammer Throw",
            "type": "throw",
            "max_per_heat": 13,
            "outdoor": True,
            "indoor": False,
        },        {
            "code": "WT",
            "name": "Weight Throw",
            "type": "throw",
            "max_per_heat": 13,
            "outdoor": False,
            "indoor": True,
        },
        {
            "code": "HJ",
            "name": "High Jump",
            "type": "vertjump",
            "max_per_heat": 20,
            "outdoor": True,
            "indoor": True,
        },
        {
            "code": "PV",
            "name": "Pole Vault",
            "type": "vertjump",
            "max_per_heat": 20,
            "outdoor": True,
            "indoor": True,
        })
