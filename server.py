""" Track Meet Simplicity
Some module docstring
"""
import os


from flask import (Flask, render_template, redirect, request, flash, session)
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
def index():
    # Check if the user is already logged in by looking at the flask session
    # if not, redirect to the login page.

    if session.get('user_id'):
        return render_template('index.html.j2')
    return redirect('/login')


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
        flash("Incorrect email address and / or password.")
        flash("Please try again, or <a href='/register'>sign up</a> as a new user.")
        return redirect('/login')

    # Successful login
    session['user_id'] = user.id
    session['user_email'] = user.email
    # session['user_school'] = user.school

    flash('Successfully logged in. Welcome to TrackMeetSimplicity!')
    return redirect('/')


@app.route('/do-logout', methods=['GET'])
def do_logout():
    del(session['user_id'])
    flash("You've successfully logged out.")
    return redirect('/register')


@app.route('/register', methods=['GET'])
def register_form():
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
        flash(f"A user with email {email} already exists!")
        flash(f"Please try signing up again, or <a href='/login'>log in</a>.")
        return redirect("/register")

    # TODO GATHER THE SCHOOL IN THE FUTURE
    # new_user = User(email=email, password=password, school=None)
    new_user = User(email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

    session['user_id'] = new_user.id
    session['user_email'] = new_user.email
    flash("Thanks for signing up!")
    flash("Welcome to TrackMeetSimplicity!")
    return redirect("/index")


@app.route('/users/<int:user_id>')
def show_user_profile(user_id):
    user = User.query.filter_by(id=user_id).first_or_404()
    return render_template('user_profile.html.j2', user=user)

@app.route('/profile')
def show_user():
    user_id=session.get('user_id')
    user = User.query.get(user_id)
    return render_template('profile.html.j2', user=user)


@app.route('/meets')
def show_all_meets():
    meets = Meet.query.all()
    return render_template(
        'item_list.html.j2', section="meets", list=meets)


@app.route('/meets/<int:meet_id>')
def show_meet_detail(meet_id):
    meet = Meet.query.filter_by(id=meet_id).order_by(Meet.date).first_or_404()
    return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/athletes/<int:school_id>')
def show_meet_school_entries(meet_id, school_id):
    pass

@app.route('/athletes')
def show_all_athletes():
    # athletes = Athlete.query.order_by(fname).order_by(lname).all()
    athletes = Athlete.query.all()
    return render_template(
        'athlete_list.html.j2', section="athletes", list=athletes)


@app.route('/athletes/<int:athlete_id>')
def show_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    return render_template('detail.html.j2', section="athletes", item=athlete)


@app.route('/schools')
def show_all_schools():
    schools = School.query.order_by(School.name).all()
    return render_template(
        'item_list.html.j2', section="schools", list=schools)


@app.route('/schools/<int:school_id>')
def show_school_detail(school_id):
    school = School.query.get(school_id)
    return render_template('detail.html.j2', section="schools", item=school)


@app.route('/display-info-from-server.json')
def example_json():
    """ Gathers information about something and sends it to the browser as a
    dictionary that is converted to a JSON
    """
    foo = {'bar': 30, 'baz': 'wow'}
    return requests.jsonify(foo)


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
