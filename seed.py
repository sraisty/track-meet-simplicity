"""
Seeds the development database
"""
from flask import Flask

from model import db, reset_database, connect_to_db, TmsApp, Meet


from parse_hytek import parse_hytek_file

from test_utils import EXAMPLE_MEETS
from util import info

NUM_MEETS = len(EXAMPLE_MEETS)
# NUM_MEETS = 3

if __name__ == "__main__":
    # reset database
    app = Flask(__name__)
    connect_to_db(app, "tms-dev", debug=False)
    info("Connected to database")
    reset_database()
    db.create_all()
    # create divs & events that are standard across all our meegs
    TmsApp()

    for i in range(NUM_MEETS):
        meet = Meet.init_meet(EXAMPLE_MEETS[i])

        parse_hytek_file("seed_data/{}".format(
                            EXAMPLE_MEETS[i]['filename']),
                         meet)

    # Fix Unattached meets. Assign to Carmel HS.
    carmel = School.get.filter_by(code="CARM")
    unattached_meets = Meets.query.filter_by(host_school_id=1)
    for m in unattached_meets:
        m.host_school = carmel
    db.session.commit()


