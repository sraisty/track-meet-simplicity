from bs4 import BeautifulSoup


# filename = 'raw_input_data/SCCountyMeet.html'
# filename = 'raw_input_data/WVALPrelim.html'
# filename = 'raw_input_data/VALfinals.html'
filename = 'raw_input_data/SanDiegoMiddle.html'


def create_soup_from_file(filename):
    # r = requests.get('https://FILLMEIN')
    f = open(filename)
    page_html = f.read()
    # print(page_html)
    return BeautifulSoup(page_html, 'lxml')


def get_team_name_list(soup):
    teams = []
    team_lines = soup.tbody.find_all('td', class_='Team filter')
    for team in team_lines:
        teams.append(team.string.strip())
    return teams


def get_events(soup, gender):
    e_info_list = []
    e_result_dict = {}

    if gender == 'male':
        gender_id = 'M-Results'
    else:
        assert(gender == 'female')
        gender_id = 'F-Results'

    gender_soup = soup.find("div", id=gender_id)
    events_soup = gender_soup.find_all('tbody', class_='EventBody')
    for event_soup in events_soup:
        print("\n\n*************************************************************")
        print(f'*** {gender.upper()}:')
        print(f'Event# {events_soup.index(event_soup)}')
        event_info = get_event_info(event_soup)
        print(f'**** {event_info}')
        e_info_list.append(event_info)
        key = tuple([gender] + list(event_info))

        event_results = get_event_results(event_soup)
        e_result_dict[key] = event_results
    return e_result_dict


def get_event_info(event_soup):
    event_name = event_soup.find('span', class_='eN').string
    division = event_soup.h4.find('span', class_='text-primary').string.strip()
    div_id, evt_round, _ = event_soup['class']
    event_info = (event_name, division, div_id, evt_round)
    return event_info


def get_event_results(event_soup):
    event_results = []
    event_results_soup = event_soup.find_all('tr', class_='A')
    for result_soup in event_results_soup:
        result_info = get_result_details(result_soup)
        event_results.append(result_info)
    return event_results


def get_athlete_grade_from_result(result_soup):
    """ This is called when the athlete's result doesn't have a grade, but the
    athlete ran in a grade-specific event, so it's obvious what grade they are
    """
    event_info = get_event_info(result_soup.parent)
    grade_string = event_info[1]
    # Assume the first word of the grade_string is something like
    # "6th" or "12th", so cut off the last two letters
    grade = int(grade_string.split()[0][:-2])
    return grade


def get_result_details(result_soup):
    dets = []
    details = result_soup.contents[:]  # make a copy so don't change the soup
    assert(len(details) == 6)

    details.pop(3)      # get rid of the blan <td class="sb"></td>

    for detail in details:
        if detail.string:
            dets.append(detail.string)
        elif detail.contents:
            # import pdb; pdb.set_trace()
            dets.append(detail.contents[0])
        else:
            # import pdb; pdb.set_trace()
            dets.append(None)

    # details = [detail.contents[0] for detail in res_soup if len(detail) > 0]
    finish_place, grade, athlete_name, mark, team = dets

    # remove "." at and of finish_place and make an int
    # Note this field might be full of "-" or space chars or just be empty
    if finish_place and finish_place[:-1].isnumeric():
        finish_place = int(finish_place[:-1])
    else:
        finish_place = None

    # Replace any '-' values (unknown) for grade with None
    if grade == '-' or grade == '' or grade is None:
        # import pdb; pdb.set_trace()
        grade = get_athlete_grade_from_result(result_soup)
    else:
        grade = int(grade)

    athlete_name = athlete_name.string.strip()

    if mark.string is None:
        mark = mark.contents[0]
    else:
        mark = mark.string

    athl_result = {"athlete_name": athlete_name,
                   "grade": grade,
                   "place": finish_place,
                   "mark": mark,
                   "team": team}
    print(f'$$$$ {athl_result}')
    return athl_result


#
# def debug_get_random_event_soup(soup, i):
#     gender_soup = soup.find("div", id='M-Results')
#     events_soup = gender_soup.find_all('tbody', class_='EventBody')
#     assert(i >= 0  and i < len(events_soup))
#     return events_soup[i]
#
# def debug_get_athlete_result_from_soup(soup, evtnum, resnum):
#     event_soup = debug_get_random_event_soup(soup, evtnum)
#     event_results_soup = event_soup.find_all('tr', class_='A')
#     assert(resnum >= 0 and resnum < len(event_results_soup))
#     return event_results_soup[resnum]
#

soup = create_soup_from_file(filename)
teams = get_team_name_list(soup)
male_events_info = get_events(soup, 'male')
female_events_info = get_events(soup, 'female')
