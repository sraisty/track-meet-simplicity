""" Track Meet Simplicity
Some module docstring
"""
import os


from flask import (Flask, render_template, redirect, request, flash,
                   session, url_for)
from jinja2 import StrictUndefined
from flask_debugtoolbar import DebugToolbarExtension
import requests

from model import (connect_to_db, db, User, Meet, Athlete, Entry,
                   Division, School, Event_Definition, MeetDivisionEvent)


# from model import more stuff


app = Flask(__name__)

# Required to use Flask sessions and the debug toolbar
app.secret_key = os.environ['FLASK_APP_SECRET_KEY']

# Normally, if you use an undefined variable in Jinja2, it fails
# silently. This is horrible. Fix this so that, instead, it raises an
# error.
app.jinja_env.undefined = StrictUndefined


@app.route('/')
@app.route('/index')
def index():
    """
    Check if the user is already logged in by looking at the flask session
    if not, redirect to the login page.
    """
    if session.get('user_id'):
        return render_template('index.html.j2')
    return redirect(url_for('show_login_form'))


@app.route('/login', methods=['GET'])
def show_login_form():
    return render_template('login.html.j2')


@app.route('/do-login', methods=['POST'])
def do_login():
    """ Receive the login credentials from form user filled in """

    # get the user_id and login from the form
    email = request.form['email']
    password = request.form['password']
    # Test whether this user_id and password match the database.

    user = User.query.filter_by(email=email, password=password).one_or_none()

    if user is None:
        # bad login
        flash(
                "ERROR: Incorrect email address or password. Try again, or <a href='/register'>sign up</a> as a new user.",
                "danger"
            )
        return redirect(url_for('do_login'))

    # Successful login
    session['user_id'] = user.id
    session['user_email'] = user.email

    ## TODO - TEST HACK
    session['user_school_id'] = 2
    session['admin_user'] = True
    # session['user_school'] = user.school

    flash("Successfully logged in. Welcome to TrackMeetSimplicity!", "success")
    return redirect(url_for('index'))


@app.route('/do-logout', methods=['GET'])
def do_logout():
    session.pop('user_id', None)
    flash("You've successfully logged out.", "success")
    return redirect(url_for('show_register_form'))


@app.route('/register', methods=['GET'])
def show_register_form():
    """Show form for user signup."""
    # Get the list of schools to populate the drop-down
    schools = School.query.all()
    return render_template("register.html.j2", school_list=schools)


@app.route('/do-register', methods=['POST'])
def register_process():
    """Process user sign-up."""

    # Get form variables
    email = request.form["email"]
    password = request.form["password"]
    # school = request.form.get('school')

    # If user with the email already exists, don't allow registration
    user = User.query.filter_by(email=email).one_or_none()
    if user:
        flash(
            f"ERROR: A user with email {email} already exists!\nTry again, or <a href='/login'>log in</a> if you already have an account.", 
            "danger")
        return redirect(url_for('show_register_form'))

    # TODO GATHER THE SCHOOL IN THE FUTURE
    # new_user = User(email=email, password=password, school=None)
    new_user = User(email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

    session['user_id'] = new_user.id
    session['user_email'] = new_user.email
    flash("Welcome to TrackMeetSimplicity!", "success")
    return redirect(url_for("index"))


@app.route('/profile')
def show_user_profile():
    user_id = session.get('user_id')
    user = User.query.get(user_id)
    return render_template('profile.html.j2', user=user)


@app.route('/meets')
def show_all_meets():
    meets = Meet.query.all()
    return render_template('all_meets.html.j2', list=meets)


@app.route('/meets/<int:meet_id>')
def show_meet_detail(meet_id):
    meet = Meet.query.filter_by(id=meet_id).order_by(Meet.date).first_or_404()
    return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/new_meet')
def new_meet():
    return ('<p>Create New Meet</p>')


@app.route('/meets/<int:meet_id>/edit_meet')
def edit_meet(meet_id):
    meet = Meet.query.filter_by(id=meet_id).first_or_404()
    return '<p>Edit Meet {}</p>'.format(meet.id)
    # return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/enter_meet')
def enter_meet(meet_id):
    meet = Meet.query.filter_by(id=meet_id).first_or_404()
    return '<p>Enter my school into Meet {}</p>'.format(meet.id)
    # return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/view_entries')
def edit_meet_entries(meet_id):
    meet = Meet.query.filter_by(id=meet_id).order_by(Meet.date).first_or_404()
    return "<p>View (and edit?) my school's entries for Meet {}</p>".format(
            meet.id)
    # return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/mdes/<int:mde_id>')
def show_meet_division_events(meet_id, mde_id):
    mde = MeetDivisionEvent.query.filter_by(id=mde_id).first_or_404()
    return render_template('mde_detail.html.j2', mde=mde)


@app.route('/athletes')
def show_all_athletes():
    # athletes = Athlete.query.order_by(fname).order_by(lname).all()
    athletes = Athlete.query.all()
    return render_template('all_athletes.html.j2', list=athletes)


@app.route('/athletes/<int:athlete_id>')
def show_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    return render_template('athlete_detail.html.j2', athlete=athlete)


@app.route('/athletes/<int:athlete_id>/edit')
def edit_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    # return render_template('athlete_detail.html.j2', athlete=athlete)
    return '<p>Edit athlete {}</p>'.format(athlete.id)


@app.route('/schools')
def show_all_schools():
    schools = School.query.order_by(School.name).all()
    return render_template('all_schools.html.j2', list=schools)


@app.route('/schools/<int:school_id>')
def show_school_detail(school_id):
    school = School.query.get(school_id)
    return render_template('school_detail.html.j2', school=school)

@app.route('/schools/<int:school_id>/edit')
def edit_school_detail(school_id):
    school = School.query.get(school_id)
    return '<p>Edit athlete {}</p>'.format(school.id)


# @app.route('/display-info-from-server.json')
# def example_json():
#     """ Gathers information about something and sends it to the browser as a
#     dictionary that is converted to a JSON
#     """
#     foo = {'bar': 30, 'baz': 'wow'}
#     return requests.jsonify(foo)


@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html.j2'), 404


if __name__ == '__main__':
    # We have to set app.debug=True here, since it has to be True at the
    # point that we invoke the DebugToolbarExtension
    app.debug = True
    # make sure templates, etc. are not cached in debug mode
    app.jinja_env.auto_reload = app.debug

    connect_to_db(app)

    # Do I need this?
    app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False

    # Use the DebugToolbar
    DebugToolbarExtension(app)

    from doctest import testmod
    if testmod().failed == 0:
        # Can't start Flask server until our doctests all pass
        # app.run(port=5000, host='0.0.0.0')
        # app.run(port=5000, host='0.0.0.0' debug=True)
        # Is the following better?
        app.run(port=5000, host='0.0.0.0', debug=app.debug)
