"""
Populates our database with starter data
Load up the "Constants" for our MVP's database.
"""

from model import (db, connect_to_db, reset_database,
                   School, Meet)


EXAMPLE_MEETS = ({"name": "A Meet from the Past",
                  "date": "August 5, 2018",
                  "active": False},
                 {"name": "WVAL League Practice Meet #1",
                  "date": "April 15, 2019"},
                 {"name": "WVAL League Practice Meet #2",
                  "date": "April 25, 2019"},
                 {"name": "WVAL League Practice Meet #3",
                  "date": "May 8, 2019"},
                 {"name": "Santa Clara County Middle School Championships",
                  "date": "May 15, 2019"},
                 {"name": "Central Coast Section Middle School Championships",
                  "date": "May 31, 2019"})
########################################


def populate_example_meets(meet_list):
    for meet_dict in meet_list:
        meet = Meet(name=meet_dict['name'], date=meet_dict['date'],
                    status=meet_dict.get('status', 'accepting_entries'))

        db.session.add(meet)
        db.session.commit()


def populate_example_data():
    populate_example_meets(EXAMPLE_MEETS)
    meet1 = Meet.query.filter_by(name="WVAL League Practice Meet #1").first()
    populate_mdes(meet1)


if __name__ == "__main__":
    from server import app
    connect_to_db(app, "tms-dev")
    reset_database()
    db.create_all()

