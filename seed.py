"""
Seeds the development database
"""
from flask import Flask

from model import (
    db, reset_database, connect_to_db,
    )


from parse_hytek import parse_hytek_file

from test_utils import EXAMPLE_MEETS, init_meet, init_tms
from util import info

if __name__ == "__main__":
    # reset database
    app = Flask(__name__)
    connect_to_db(app, "tms-dev")
    info("Connected to database")
    reset_database()
    db.create_all()

    # create divs & events that are standard across all our meegs
    (divs, events) = init_tms()

    num_meets = len(EXAMPLE_MEETS)

    for i in range(num_meets):
        meet_init_info = EXAMPLE_MEETS[i]
        meet = init_meet(meet_init_info, divs, events)

        parse_hytek_file("seed_data/{}".format(meet_init_info['filename']),
                         meet)
        meet.host_school_id = meet_init_info['host_school_id']
