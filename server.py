""" Track Meet Simplicity
Some module docstring
"""
import os
from flask import (Flask, render_template, redirect, request, flash,
                   session, url_for)
from jinja2 import StrictUndefined, Environment, select_autoescape
from flask_debugtoolbar import DebugToolbarExtension
import requests

from model import (connect_to_db, db, User, Meet, Athlete, Entry,
                   School, MeetDivisionEvent)

from util import error, warning, info
# from model import more stuff


app = Flask(__name__)

# Required to use Flask sessions and the debug toolbar
app.secret_key = os.environ['FLASK_APP_SECRET_KEY']

# Normally, if you use an undefined variable in Jinja2, it fails
# silently. This is horrible. Fix this so that, instead, it raises an
# error.
app.jinja_env.undefined = StrictUndefined

# The following control the whitespace that is inserted into the HTML that the
# templates produce, and make it easier for humans to understand/debug the HTML.
app.jinja_env.trim_blocks = True
app.jinja_env.lstrip_blocks = True
app.jinja_env.strip_trailing_newlines = False

app.jinja_env.autoescape = True
# TODO Is the following needed (or correct), since my Jinja templates
# end in "J2" to get syntax highlighting?

# app.jinja_env.autoescape = select_autoescape(
#         enabled_extensions=('html', 'xml', 'html', 'j2'),
#         default_for_string=True)

# jinja_env = jinja2.Environment(loader = jinja2.FileSystemLoader(template_dir),
#                                autoescape = True,
#                                extensions = ['jinja2.ext.autoescape'])
#  See http://jinja.pocoo.org/docs/2.10/api/#the-context
# env = Environment(autoescape=select_autoescape(
#     enabled_extensions=('html', 'xml'),
#     default_for_string=True,
# ))

@app.route('/test')
def test_render():
    return render_template('/test/test.html.j2')


@app.route('/')
@app.route('/index')
def index():
    """
    Check if the user is already logged in by looking at the flask session
    if not, redirect to the login page.
    """
    if session.get('user_id'):
        if session.get('user_school_id'):
            return redirect(url_for(
                    'show_school_detail', school_id=session['user_school_id']))
        return render_template('index.html.j2')
    return redirect(url_for('show_login_form'))


@app.route('/login', methods=['GET'])
def show_login_form():
    return render_template('users/login.html.j2')


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
        flash("Try again, or <a href='/register'>sign up</a> as a new user.",
              "danger")
        return redirect(url_for('show_login_form'))

    # Successful login
    session['user_id'] = user.id
    session['user_email'] = user.email
    session['user_school_id'] = user.school.id
    session['user_school_name'] = user.school.name
    # session['user_role'] = user.role

    flash("Successfully logged in. Welcome to TrackMeetSimplicity!", "success")
    return redirect(url_for('index'))


@app.route('/do-logout', methods=['GET'])
def do_logout():
    session.pop('user_id', None)
    session.pop('user_email', None)
    session.pop('user_school_id', None)
    session.pop('user_school_name', None)
    flash("You've successfully logged out.", "success")
    return redirect(url_for('show_register_form'))


@app.route('/register', methods=['GET'])
def show_register_form():
    """Show form for user signup."""
    # Get the list of schools to populate the drop-down
    schools = School.query.order_by("name").all()
    return render_template("users/register.html.j2", school_list=schools)


@app.route('/profile')
def show_user_profile():
    school_list = School.query.order_by(School.name).all()

    return render_template('users/profile.html.j2', school_list=school_list)


@app.route('/do-register', methods=['POST'])
def do_register():
    (email, password, school) = _get_user_details_and_school(request)

    # If user with the email already exists, don't allow registration
    user = User.query.filter_by(email=email).one_or_none()
    if user:
        flash(
            f"ERROR: A user with email {email} already exists!\nTry again, " +
            f"or <a href='/login'>log in</a> if you already have an account.",
            "danger")
        return redirect(url_for('show_register_form'))

    new_user = User(email=email, password=password, school_id=school.id)
    db.session.add(new_user)
    db.session.commit()

    # Save the coach user's info and school info on the Flask session
    session['user_id'] = new_user.id
    session['user_email'] = new_user.email
    session['user_school_id'] = new_user.school.id
    session['user_school_name'] = new_user.school.name

    flash("Welcome to TrackMeetSimplicity!", "success")
    return redirect(url_for("index"))


@app.route('/do-change-profile', methods=['POST'])
def do_change_profile():

    (new_email, new_password, school) = _get_user_details_and_school(request)

    # get our user record from the database and update it.
    user_id = session.get('user_id')
    user = User.query.get(user_id)

    user.school_id = school.id
    if new_email:
        user.email = new_email
    if new_password:
        user.password = new_password
    db.session.commit()

    session['user_school_id'] = user.school.id
    session['user_school_name'] = user.school.name
    session['user_email'] = user.email

    flash("Your user profile has been updated.", "success")
    return redirect((url_for("index")))


@app.route('/meets')
def show_all_meets():
    meets = Meet.query.all()
    return render_template('/meets/all_meets.html.j2', list=meets)


@app.route('/meets/<int:meet_id>')
def show_meet_detail(meet_id):
    meet = Meet.query.filter_by(id=meet_id).order_by(Meet.date).first_or_404()
    # TODO if meet.status="Accepting Entries" and myschool not entered yet:
    #   dispaly enter meet button
    # else if accepting entries and my school has entered
    #   buttton to display edit my meet roster / entries
    # else if meet.status assigned or later, and my school entered:
    #   button to see athlete assignments
    # else if meet.status == "Finished":
    # display the entries and the results to anyone
    return render_template('/meets/meet_detail.html.j2', meet=meet)


@app.route('/meets/new-meet')
def show_new_meet_form():
    return (render_template('/meets/new_meet.html.j2'))


@app.route('/meets/do-new-meet', methods=['POST'])
def do_new_meet_form():
    # # Get form variables
    # name = request.form["name"]
    # date = request.form["date"]
    # description = request.form["description"]
    # host_school = request.form["host_school"]
    # max_entries_per_athlete = request.form["max_entries_per_athlete"]
    # max_relays_per_athlete = request.form["max_relays_per_athlete"]
    # max_teammates_per_event = request.form["max_team_entries_per_event"]
    # max_heats_per_mde = 3request.form["max_heats_per_mde"]
    # # max_heats_per_mde = request.form["max_heats_per_mde"]

    # ev_code_list = request.form["ev_code_list"]
    # div_code_list = request.form["div_code_list"]

    # seeding tiebreakers
    # heat assignment method
    # lane/position assignment method
    # meet status = unpublished?

    meet = Meet.init_meet(request.form)
    meet.status = "Unpublished"

    flash("New meet created!", "success")
    return (redirect(url_for('show_all_meets')))


@app.route('/meets/<int:meet_id>/edit_meet')
def show_edit_meet_form(meet_id):
    meet = Meet.query.filter_by(id=meet_id).first_or_404()
    return '<p>Edit Meet {}</p>'.format(meet.id)
    # reuse the same form from do_new_meet_form
    # add meet status field - they can now change it to the next stage?
    # return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/enter_meet')
def show_enter_meet_form(meet_id):
    meet = Meet.query.filter_by(id=meet_id).first_or_404()
    return'<p>Enter my school {} into Meet {}</p>'.format(
        session['user_school_name'], meet.id)
    # return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/school/<int:school_id>/edit_entries')
@app.route('/meets/<int:meet_id>/edit_entries')
def edit_meet_entries(meet_id, school_id=None):
    if school_id is None:
        school_id = session['school.id']

    meet = Meet.query.filter_by(id=meet_id).order_by(Meet.date).first_or_404()
    return "<p>View (and edit?) my school's entries for Meet {}</p>".format(
            meet.id)
    # return render_template('meet_detail.html.j2', meet=meet)


@app.route('/meets/<int:meet_id>/mdes/<int:mde_id>')
def show_mde_detail(meet_id, mde_id):
    # TO DO - Don't think I really need BOTH the meet_id and the mde_id
    # for this function, but maybe it should be in the URL anyway ?
    mde = MeetDivisionEvent.query.filter_by(id=mde_id).first_or_404()
    return render_template('/meets/mde_detail.html.j2', mde=mde)


@app.route('/athletes')
def show_all_athletes():
    q = Athlete.query.order_by(Athlete.lname).order_by(Athlete.fname)
    athletes = q.all()
    # athletes = Athlete.query.all()
    return render_template('/athletes/all_athletes.html.j2', list=athletes)


@app.route('/athletes/<int:athlete_id>')
def show_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    return render_template('/athletes/athlete_detail.html.j2', athlete=athlete)


@app.route('/athletes/<int:athlete_id>/edit')
def edit_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    # return render_template('athlete_detail.html.j2', athlete=athlete)
    return '<p>Edit athlete {}</p>'.format(athlete.id)


@app.route('/schools')
def show_all_schools():
    schools = School.query.order_by(School.name).all()
    return render_template('/schools/all_schools.html.j2', list=schools)


@app.route('/schools/<int:school_id>')
def show_school_detail(school_id):
    school = School.query.get(school_id)
    return render_template('/schools/school_detail.html.j2', school=school)


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
def page_not_found(err):
    return render_template('/__page_not_found.html.j2'), 404

# ### HELPER FUNCTIONS ##########
def _get_user_details_and_school(request):
    new_email = request.form.get("email")
    new_password = request.form.get("password")
    school_id = request.form.get("school_id")

    if school_id:
        school = School.query.get(school_id)

    else:
        # user is entering a new school in the form.
        # So, create the new school
        new_school_name = request.form.get('new_school_name')
        new_school_code = request.form.get('new_school_code')

        school = School(name=new_school_name, code=new_school_code)
        db.session.add(school)
        db.session.flush()

    return (new_email, new_password, school)


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
