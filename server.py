""" Track Meet Simplicity
Some module docstring
"""
import os
from flask import (Flask, render_template, redirect, request, flash,
                   session, url_for)
from werkzeug.utils import secure_filename
from jinja2 import StrictUndefined
from jinja2 import select_autoescape
# from flask_login import LoginManager
from flask_debugtoolbar import DebugToolbarExtension
# import requests

from model import (connect_to_db, db, User, Meet, Athlete, Entry, Division,
                   School, MeetDivisionEvent, EventOrdering, DivOrdering,
                   DEFAULT_EVENT_ORDER, DEFAULT_DIVISION_ORDER, MEET_STATUS)

# from util import error, warning, info
from parse_hytek import parse_hytek_file

UPLOAD_FOLDER = "./entry_file_uploads"
ALLOWED_EXTENSIONS = set(['txt', 'hyv'])


app = Flask(__name__)
# login = LoginManager(app)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = os.environ['FLASK_APP_SECRET_KEY']

# Normally, if you use an undefined variable in Jinja2, it fails
# silently. This is horrible. Fix so that it raises an error.
app.jinja_env.undefined = StrictUndefined

# The following control the whitespace that is inserted into the HTML that the
# templates produce, making it easier for humans to understand/debug the HTML.
app.jinja_env.trim_blocks = True
app.jinja_env.lstrip_blocks = True
app.jinja_env.strip_trailing_newlines = False

# app.jinja_env.autoescape = True
# TODO Is the following needed (or correct), since my Jinja templates
# end in "J2" to get syntax highlighting?
app.jinja_env.autoescape = select_autoescape(
        enabled_extensions=('html', 'xml', 'html', 'j2'),
        default_for_string=True)
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
    entry = Entry.query.get(7000)
    return render_template('/test/test.html.j2', entry=entry)


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


# ############# USER LOGIN, REGISTRATION AND PROFILE EDITING  ##############
@app.route('/login', methods=['GET'])
def show_login_form():
    return render_template('users/login.html.j2')


@app.route('/do-login', methods=['POST'])
def do_login():
    """ Receive the login credentials from form user filled in """
    email = request.form['email']
    password = request.form['password']
    user = User.query.filter_by(email=email, password=password).one_or_none()
    if user is None:
        # bad login
        flash("User doesn't exist. Try again, or sign up as a new user.",
              "danger")
        return redirect(url_for('show_login_form'))

    # Successful login
    session['user_id'] = user.id
    session['user_email'] = user.email
    session['user_school_id'] = user.school.id
    session['user_school_name'] = user.school.name
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


@app.route('/register')
def show_register_form():
    """ Show form for user signup. """
    # Get the list of schools to populate the drop-down
    schools = School.query.order_by("name").all()
    return render_template("users/register.html.j2", school_list=schools)


@app.route('/do-register', methods=['POST'])
def do_register():
    (email, password, school) = _get_user_details_and_school(request)

    # If user with the email already exists, don't allow registration
    user = User.query.filter_by(email=email).one_or_none()
    if user:
        flash(
            f"ERROR: A user with email {email} already exists!\nTry again, " +
            f"or log in if you already have an account.",
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
    return redirect(url_for("index"))


@app.route('/profile')
def show_user_profile():
    # get our existing user record from the database
    user_id = session.get('user_id')
    user = User.query.get(user_id)
    return render_template('users/profile_show.html.j2', user=user)


@app.route('/profile/edit')
def show_edit_profile_form():
    school_list = School.query.order_by(School.name).all()
    return render_template(
            'users/profile_edit.html.j2', school_list=school_list)


@app.route('/do-change-profile', methods=['POST'])
def do_change_profile():
    # get our existing user record from the database and update it.
    user_id = session.get('user_id')
    user = User.query.get(user_id)

    (new_email, _junk, school) = _get_user_details_and_school(request)

    if new_email:
        user.email = new_email
        session['user_email'] = user.email

    user.school_id = school.id
    session['user_school_id'] = user.school.id
    session['user_school_name'] = user.school.name

    db.session.commit()

    flash("Your user profile has been updated.", "success")
    return redirect((url_for("show_user_profile")))


@app.route('/do-change-password', methods=['POST'])
def do_change_password():
    # get our existing user record from the database and update it.
    user_id = session.get('user_id')
    user = User.query.get(user_id)
    new_password = request.form.get("password")
    user.password = new_password

    db.session.commit()

    flash("Your password has been updated.", "success")
    return redirect((url_for("show_user_profile")))


# ########   SCHOOL LIST, EDIT, CREATE #########################

@app.route('/schools')
def show_all_schools():
    schools = School.query.order_by(School.name)
    return render_template(
            '/schools/all_schools.html.j2',
            schools=schools.all(),
            num_schools=schools.count())


@app.route('/schools/<int:school_id>')
def show_school_detail(school_id):
    school = School.query.get(school_id)
    return render_template(
            '/schools/school_show_home.html.j2', school=school)


@app.route('/schools/<int:school_id>/edit')
def show_edit_school_detail(school_id):
    school = School.query.get(school_id)
    return render_template(
            '/schools/_school_detail_edit_form.html.j2', school=school)


@app.route('/schools/<int:school_id>/do_edit', methods=['POST'])
def do_edit_school_detail(school_id):
    school = School.query.get(school_id)
    school.name = request.form.get('name', school.name)
    school.code = request.form.get('code', school.code)
    school.league = request.form.get('league', school.league)
    school.section = request.form.get('section', school.section)
    school.city = request.form.get('city', school.city)
    school.state = request.form.get('state', school.state)

    db.session.commit()
    flash(f"Updated details for school {school.name}.", "success")
    return redirect(url_for('show_school_detail', school_id=school.id))


# ########   MEET LIST, EDIT, CREATE, SEED #########################

@app.route('/meets')
def show_all_meets():
    meets = Meet.query.all()
    return render_template('/meets/all_meets.html.j2', meets=meets)


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
    return (render_template('/meets/new_meet.html.j2',
            event_order=EventOrdering.get_default_event_order_codes(),
            div_order=DivOrdering.get_default_division_order_codes()))


@app.route('/meets/do-new-meet', methods=['POST'])
def do_new_meet_form():
    # # Get form variables
    mi = {}
    mi['name'] = request.form["name"]
    mi['date'] = request.form["date"]
    mi['description'] = request.form.get("description")
    mi['host_school_id'] = session['user_school_id']
    mi['max_entries_per_athlete'] = int(
            request.form.get("max_entries_per_athlete", 4))
    mi['max_relays_per_athlete'] = int(
            request.form.get("max_relays_per_athlete", 2))
    mi['max_teammates_per_event'] = int(
            request.form.get("max_team_entries_per_event", 12))
    mi['max_heats_per_mde'] = int(request.form.get("max_heats_per_mde", 3))
    mi['ev_code_list'] = request.form.get("ev_code_list", DEFAULT_EVENT_ORDER)
    mi['div_code_list'] = request.form.get(
            "div_code_list", DEFAULT_DIVISION_ORDER)
    # seeding tiebreakers
    # heat assignment method
    # lane/position assignment method
    meet = Meet.init_meet(mi)
    meet.status = "Unpublished"
    flash("New meet created!", "success")
    return (redirect(url_for('show_meet_detail', meet_id=meet.id)))


@app.route('/meets/<int:meet_id>/edit-meet')
def show_edit_meet_form(meet_id):
    meet = Meet.query.get(meet_id)
    if not meet:
        flash("Meet with id# {meet_id} does not exist.".format(meet.id),
              "danger")
        return redirect(url_for('show_all_meets'))
    if session['user_school_id'] != meet.host_school_id:
        flash(
            "You are not authorized. Only users from the host school may edit this meet.",
            "danger")
        return redirect(url_for('show_meet_detail', meet_id=meet_id))

    school_list = School.query.order_by(School.name).all()
    return render_template(
            '/meets/show_edit_meet_form.html.j2',
            meet=meet, school_list=school_list, meet_status_list=MEET_STATUS)


@app.route('/meets/<int:meet_id>/do-edit-meet', methods=['POST'])
def do_edit_meet_form(meet_id):
    meet = Meet.query.get(meet_id)

    meet.name = request.form.get('name', meet.name)
    meet.date = request.form.get('date', meet.date)
    meet.status = request.form.get('status', meet.status)

    meet.host_school_id = session['user_school_id']

    # meet.host_school_id = int(request.form.get(
    #         'host_school_id', meet.host_school_id))
    meet.description = request.form.get("description", meet.description)

    meet.max_entries_per_athlete = int(request.form.get(
            "max_entries_per_athlete", meet.max_entries_per_athlete))
    meet.max_relays_per_athlete = int(request.form.get(
            "max_relays_per_athlete", meet.max_relays_per_athlete))
    meet.max_teammates_per_event = int(request.form.get(
            "max_team_entries_per_event", meet.max_teammates_per_event))
    meet.max_heats_per_mde = int(request.form.get(
            "max_heats_per_mde", meet.max_heats_per_mde))

    # For now, we're not changing the ordering of events or divisions
    # Do this later.
    # Get the new event ordering
    # Reassign the sequence numbers in the database event orderings for meet
    # Get the new division ordering
    # Reassign sequence numbers in the databases divisions orderings for meet
    # redo the sequence numbers for all MDEs in the meet
    # meet.event_orderings_list = request.form.get(
    #       "ev_code_list", meet.ev_code_list)
    # meet.div_code_list = request.form.get(
    #         "div_code_list", meet.div_code_list)
    
    # TODO - warn if they reduce number of heats or athletes per heat
    # after assignments have been made, that athletes will be kicked out.
    # Maybe a confirmation message
    db.session.commit()

    return (redirect(url_for('show_meet_detail', meet_id=meet.id)))


# ##### CREATE MDEs/ENTRIES, ASSIGNMENTS & EDIT ENTRIES / MDES

@app.route('/meets/<int:meet_id>/enter-meet')
def show_enter_meet_upload_form(meet_id):
    meet = Meet.query.get(meet_id)
    school = School.query.get(session['user_school_id'])
    return render_template(
            "/entries/_school_entry_into_meet.html.j2",
            meet=meet, school=school)


@app.route('/meets/<int:meet_id>/do-enter-meet', methods=["POST"])
def do_upload_school_entries(meet_id):
    meet = Meet.query.get(meet_id)

    # check if the post request has the file part
    if 'entry_file' not in request.files:
        flash("You must upload a file containing track meet entries in Hytek file format")
        return redirect(url_for(
                'show_enter_meet_upload_form', meet_id=meet_id))

    file = request.files['entry_file']
    # if user does not select file, browser submits an empty part
    # without filename
    if file.filename == '':
        flash('No selected file')
        return redirect(url_for('show_enter_meet_upload_form', meet_id))
    if file and allowed_file(file.filename):

        filename = "meet_{}_school_{}_{}".format(
                meet_id, session['user_school_name'], file.filename)
        filename = secure_filename(filename)

        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        parse_hytek_file(
                os.path.join(app.config['UPLOAD_FOLDER'], filename),
                meet)
    flash("Successfully added athletes from file to meet.", "success")
    return redirect(url_for('show_meet_detail', meet_id=meet_id))


@app.route('/meets/<int:meet_id>/mdes/<int:mde_id>')
def show_mde_detail(meet_id, mde_id):
    # TO DO - Don't think I really need BOTH the meet_id and the mde_id
    # for this function, but it's in the URL for usability
    mde = MeetDivisionEvent.query.get(mde_id)
    return render_template('/entries/mde_detail.html.j2', mde=mde)


@app.route('/meets/<int:meet_id>/mdes/<int:mde_id>/edit')
def show_mde_edit_form(meet_id, mde_id):
    # Technically, I can get the meet_id from the mde_id, but this url format
    # is more friendly to users.
    mde = MeetDivisionEvent.query.get(mde_id)
    school = School.query.get(mde.meet.host_school_id)
    return render_template(
            '/entries/mde_detail_edit_form.html.j2',
            mde=mde, meet_id=meet_id, school=school)


@app.route('/meets/<int:meet_id>/mdes/<int:mde_id>/do-edit', methods=["POST"])
def do_edit_mde_detail(meet_id, mde_id):
    mde = MeetDivisionEvent.query.get(mde_id)
    mde.status = request.form.get('mde_status', mde.status)
    mde.seq_num = int(request.form.get('mde_seq_num', mde.seq_num))

    max_heats = request.form.get('mde_max_heats', mde.max_heats)
    if max_heats:
        mde.max_heats = int(max_heats)
    mde.mde_notes = request.form.get('mde_notes', mde.mde_notes)
    db.session.commit()
    flash("Saved new settings for mde.event.name for mde.division.name",
          "success")
    return redirect(url_for('show_mde_detail', meet_id=meet_id, mde_id=mde.id))


# #### ASSIGNING ATHLETES, DETECTING PROBLEMS & ALLOWING EDITS OF ENTRIES
@app.route('/meets/<int:meet_id>/mdes/<int:mde_id>/do-assign')
def do_mde_assign_athletes(meet_id, mde_id):
    mde = MeetDivisionEvent.query.get(mde_id)
    mde.assign_seed_numbers()
    return redirect(
        url_for('show_mde_detail', meet_id=mde.meet.id, mde_id=mde.id))


@app.route('/meets/<int:meet_id>/do-assign')
def do_meet_assignment_all_mdes(meet_id):
    meet = Meet.query.get(meet_id)
    meet.assign_all_mdes()
    flash("Assigned athletes to all contests.")
    return redirect(url_for('show_meet_detail', meet_id=meet.id))


@app.route('/entries')
@app.route('/school/<int:school_id>/entries')
@app.route('/meets/<int:meet_id>/school/<int:school_id>/entries')
@app.route('/meets/<int:meet_id>/entries')
def show_entries(school_id=None, meet_id=None):

    problems = request.args.get('problems')
    # import ipdb; ipdb.set_trace()

    q = Entry.query
    # q = db.session.query(Entry.id, )
    if school_id:
        school = School.query.get(school_id)
        q = q.filter_by(school=school)
    else:
        school = None

    if meet_id:
        meet = Meet.query.get(meet_id)
        q = q.filter_by(meet=meet)
    # if problems:
    #     q = q.filter_by(problem is not None)

    # q = q.order_by(event.code)
    # q = q.options(joinedload())
    entries = q.all()

    return render_template(
        "/entries/show_meet_entries.html.j2", entries=entries, meet=meet, school=school)


@app.route('/meets/<int:meet_id>/school/<int:school_id>/entries')
@app.route('/meets/<int:meet_id>/entries')
def show_meet_entries(meet_id, entries=None, school_id=None, problems=False):
    """ if problems is True, the entries shown will ony be the ones with noted
        problems
    """
    # TODO problems as parameter
    if school_id is None:
        school_id = session['school.id']
    school = School.query.get(school_id)
    meet = Meet.query.get(meet_id)
    return render_template(
            "/entries/show_meet_entries.html.j2", meet=meet, school=school)


@app.route('/entries/problems')
@app.route('/school/<int:school_id>/entries/problems')
def show_school_entry_problems(school_id):
    flash("To be implemented")
    # TODO
    if school_id is None:
        school_id = session['school.id']
    school = School.query.get(school_id)
    q = Entry.query.filter_by(school=school).filter(Entry.problem is not None)
    problem_entries = q.all()
    # TODO
    return render_template(
            "/entries/show_meet_entries.html.j2", meet=None, school=school)


@app.route('/entries/<int:entry_id>/edit')
@app.route('/meets/<int:meet_id>/entries/<int:entry_id>/edit')
def show_edit_entry_form(entry_id, meet_id=None):
    entry = Entry.query.get(entry_id)
    return render_template("/entries/entry_detail_edit_form.html.j2", entry=entry)


@app.route('/entries/<int:entry_id>/do-edit', methods=['POST'])
@app.route('/meets/<int:meet_id>/entries/<int:entry_id>/do-edit', methods=['POST'])
def do_edit_entry(meet_id, entry_id):
    entry = Entry.query.get(entry_id)
    mark_string = request.form.get('mark')
    mark_type = request.form.get('mark_type')
    # TODO
    flash("To be Implemented: Update entry.")
    return redirect(url_for(
            'show_meet_entries', meet_id=meet_id,
            school_id=session.get('user_school_id')))


@app.route('/entries/<int:entry_id>/delete', methods=['POST'])
def delete_entry(entry_id):
    flash("To be implemented.")
    return redirect(url_for(
            'show_meet_entries', meet_id=entry.meet.id, 
            school_id=session.get('user_school_id')))


@app.route('/entries/new', methods=['POST'])
@app.route('/meets/<int:meet_id>/entries/new', methods=['POST'])
def new_entry(meet_id=None):
    flash("To be implemented.")
    return redirect(url_for(
            'show_meet_entries', meet_id=entry.meet.id, 
            school_id=session.get('user_school_id')))

# ##########  DISPLAY AND EDIT ATHLETES  ###########
@app.route('/athletes')
def show_all_athletes():
    q = Athlete.query.order_by(Athlete.lname).order_by(Athlete.fname)
    athletes = q.all()
    return render_template('/athletes/all_athletes.html.j2', athletes=athletes)


@app.route('/athletes/<int:athlete_id>')
def show_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    return render_template('/athletes/athlete_detail.html.j2', athlete=athlete)


@app.route('/athletes/<int:athlete_id>/edit')
def show_edit_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)
    school_list = School.query.all()
    division_list = Division.query.all()
    return render_template(
        '/athletes/_athlete_detail_edit_form.html.j2',
        athlete=athlete, school_list=school_list, division_list=division_list)


@app.route('/athletes/<int:athlete_id>/do_edit', methods=['POST'])
def do_edit_athlete_detail(athlete_id):
    athlete = Athlete.query.get(athlete_id)

    athlete.fname = request.form.get('fname', athlete.fname)
    athlete.minitial = request.form.get('minitial', athlete.minitial)
    athlete.lname = request.form.get('lname', athlete.lname)
    athlete.div_id = request.form.get('division_id', athlete.div_id)
    athlete.phone = request.form.get('phone', athlete.phone)
    athlete.coach_notes = request.form.get('coach_notes', athlete.coach_notes)

    db.session.commit()
    flash(f"Updated details for school {athlete.full_name()}.", "success")
    return redirect(url_for('show_athlete_detail', athlete_id=athlete.id))


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


def allowed_file(filename):
    # For the upload files
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


if __name__ == '__main__':
    from sys import argv
    if argv[-1] == "--debug":
        app.debug = True
        # We have to set app.debug=True here, since it has to be True at the
        # point that we invoke the DebugToolbarExtension
        # make sure templates, etc. are not cached in debug mode
        app.jinja_env.auto_reload = True
        connect_to_db(app, db_uri="tms-dev", debug=True)
        # Use the DebugToolbar
        app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False
        DebugToolbarExtension(app)
    else:
        app.debug = False
        app.jinja_env.auto_reload = True
        connect_to_db(app, db_uri="tms-dev", debug=False)
        # connect_to_db(app, db_uri="tms-prod", debug=False)

    from doctest import testmod
    if testmod().failed == 0:
        # Can't start Flask server until our doctests all pass
        app.run(port=5000, host='0.0.0.0', debug=app.debug)
