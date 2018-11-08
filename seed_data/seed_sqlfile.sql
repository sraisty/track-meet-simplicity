--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.users DROP CONSTRAINT users_school_id_fkey;
ALTER TABLE ONLY public.meets DROP CONSTRAINT meets_host_school_id_fkey;
ALTER TABLE ONLY public.meet_division_events DROP CONSTRAINT meet_division_events_meet_id_fkey;
ALTER TABLE ONLY public.meet_division_events DROP CONSTRAINT meet_division_events_event_code_fkey;
ALTER TABLE ONLY public.meet_division_events DROP CONSTRAINT meet_division_events_div_id_fkey;
ALTER TABLE ONLY public.event_ordering DROP CONSTRAINT event_ordering_meet_id_fkey;
ALTER TABLE ONLY public.event_ordering DROP CONSTRAINT event_ordering_event_code_fkey;
ALTER TABLE ONLY public.entries DROP CONSTRAINT entries_mde_id_fkey;
ALTER TABLE ONLY public.entries DROP CONSTRAINT entries_heat_id_fkey;
ALTER TABLE ONLY public.entries DROP CONSTRAINT entries_athlete_id_fkey;
ALTER TABLE ONLY public.div_orderings DROP CONSTRAINT div_orderings_meet_id_fkey;
ALTER TABLE ONLY public.div_orderings DROP CONSTRAINT div_orderings_div_id_fkey;
ALTER TABLE ONLY public.athletes DROP CONSTRAINT athletes_school_id_fkey;
ALTER TABLE ONLY public.athletes DROP CONSTRAINT athletes_div_id_fkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.schools DROP CONSTRAINT schools_pkey;
ALTER TABLE ONLY public.schools DROP CONSTRAINT schools_name_key;
ALTER TABLE ONLY public.schools DROP CONSTRAINT schools_code_key;
ALTER TABLE ONLY public.meets DROP CONSTRAINT meets_pkey;
ALTER TABLE ONLY public.meet_division_events DROP CONSTRAINT meet_division_events_pkey;
ALTER TABLE ONLY public.heats DROP CONSTRAINT heats_pkey;
ALTER TABLE ONLY public.event_ordering DROP CONSTRAINT event_ordering_pkey;
ALTER TABLE ONLY public.event_defs DROP CONSTRAINT event_defs_pkey;
ALTER TABLE ONLY public.event_defs DROP CONSTRAINT event_defs_name_key;
ALTER TABLE ONLY public.entries DROP CONSTRAINT entries_pkey;
ALTER TABLE ONLY public.divisions DROP CONSTRAINT divisions_pkey;
ALTER TABLE ONLY public.divisions DROP CONSTRAINT divisions_name_key;
ALTER TABLE ONLY public.divisions DROP CONSTRAINT divisions_code_key;
ALTER TABLE ONLY public.div_orderings DROP CONSTRAINT div_orderings_pkey;
ALTER TABLE ONLY public.athletes DROP CONSTRAINT athletes_pkey;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.schools ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.meets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.meet_division_events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.heats ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.event_ordering ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entries ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.divisions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.div_orderings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.athletes ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.schools_id_seq;
DROP TABLE public.schools;
DROP SEQUENCE public.meets_id_seq;
DROP TABLE public.meets;
DROP SEQUENCE public.meet_division_events_id_seq;
DROP TABLE public.meet_division_events;
DROP SEQUENCE public.heats_id_seq;
DROP TABLE public.heats;
DROP SEQUENCE public.event_ordering_id_seq;
DROP TABLE public.event_ordering;
DROP TABLE public.event_defs;
DROP SEQUENCE public.entries_id_seq;
DROP TABLE public.entries;
DROP SEQUENCE public.divisions_id_seq;
DROP TABLE public.divisions;
DROP SEQUENCE public.div_orderings_id_seq;
DROP TABLE public.div_orderings;
DROP SEQUENCE public.athletes_id_seq;
DROP TABLE public.athletes;
DROP TYPE public.user_roles;
DROP TYPE public.meet_status;
DROP TYPE public.mde_status;
DROP TYPE public.mark_type;
DROP TYPE public.grade;
DROP TYPE public.gender;
DROP TYPE public.event_types;
DROP TYPE public.adultchild;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adultchild; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.adultchild AS ENUM (
    'adult',
    'child'
);


--
-- Name: event_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.event_types AS ENUM (
    'sprint',
    'distance',
    'relay',
    'vertjump',
    'horzjump',
    'throw',
    'hurdle'
);


--
-- Name: gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gender AS ENUM (
    'M',
    'F'
);


--
-- Name: grade; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.grade AS ENUM (
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
);


--
-- Name: mark_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mark_type AS ENUM (
    'seconds',
    'inches',
    'meters'
);


--
-- Name: mde_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mde_status AS ENUM (
    'Unassigned',
    'Assigned'
);


--
-- Name: meet_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.meet_status AS ENUM (
    'Unpublished',
    'Accepting Entries',
    'Assignments Pending',
    'Assignments Done',
    'Meet In Progress',
    'Completed'
);


--
-- Name: user_roles; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_roles AS ENUM (
    'superuser',
    'coach',
    'athlete',
    'other'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: athletes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.athletes (
    id integer NOT NULL,
    fname character varying(30) NOT NULL,
    lname character varying(30) NOT NULL,
    minitial character varying(1),
    phone character varying(12),
    school_id integer,
    div_id integer NOT NULL,
    problem character varying(64),
    coach_notes character varying(64)
);


--
-- Name: athletes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.athletes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: athletes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.athletes_id_seq OWNED BY public.athletes.id;


--
-- Name: div_orderings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.div_orderings (
    id integer NOT NULL,
    meet_id integer NOT NULL,
    div_id integer NOT NULL,
    seq_num integer NOT NULL
);


--
-- Name: div_orderings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.div_orderings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: div_orderings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.div_orderings_id_seq OWNED BY public.div_orderings.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.divisions (
    id integer NOT NULL,
    gender public.gender NOT NULL,
    grade public.grade,
    code character varying(5) NOT NULL,
    name character varying(20) NOT NULL
);


--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.divisions_id_seq OWNED BY public.divisions.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entries (
    id integer NOT NULL,
    athlete_id integer NOT NULL,
    mde_id integer NOT NULL,
    heat_id integer,
    seed_num integer,
    mark numeric(12,2),
    mark_type public.mark_type,
    problem character varying(64)
);


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.entries_id_seq OWNED BY public.entries.id;


--
-- Name: event_defs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_defs (
    code character varying(6) NOT NULL,
    name character varying(50) NOT NULL,
    etype public.event_types NOT NULL,
    max_per_heat integer
);


--
-- Name: event_ordering; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_ordering (
    id integer NOT NULL,
    meet_id integer NOT NULL,
    event_code character varying(6) NOT NULL,
    seq_num integer NOT NULL
);


--
-- Name: event_ordering_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_ordering_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_ordering_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_ordering_id_seq OWNED BY public.event_ordering.id;


--
-- Name: heats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heats (
    id integer NOT NULL,
    seq_num integer NOT NULL
);


--
-- Name: heats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heats_id_seq OWNED BY public.heats.id;


--
-- Name: meet_division_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meet_division_events (
    id integer NOT NULL,
    div_id integer NOT NULL,
    meet_id integer NOT NULL,
    event_code character varying(6) NOT NULL,
    seq_num integer NOT NULL,
    qualifying_mark integer,
    status public.mde_status NOT NULL,
    mde_notes character varying(256),
    max_heats integer
);


--
-- Name: meet_division_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meet_division_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meet_division_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meet_division_events_id_seq OWNED BY public.meet_division_events.id;


--
-- Name: meets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meets (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    date timestamp without time zone,
    host_school_id integer,
    description character varying(300),
    status public.meet_status NOT NULL,
    max_entries_per_athlete integer,
    max_relays_per_athlete integer,
    max_teammates_per_event integer,
    max_heats_per_mde integer
);


--
-- Name: meets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meets_id_seq OWNED BY public.meets.id;


--
-- Name: schools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schools (
    id integer NOT NULL,
    code character varying(8) NOT NULL,
    name character varying(50) NOT NULL,
    league character varying(6),
    section character varying(12),
    city character varying(30),
    state character varying(2)
);


--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schools_id_seq OWNED BY public.schools.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(64),
    password character varying(64),
    school_id integer,
    role public.user_roles NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athletes ALTER COLUMN id SET DEFAULT nextval('public.athletes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.div_orderings ALTER COLUMN id SET DEFAULT nextval('public.div_orderings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions ALTER COLUMN id SET DEFAULT nextval('public.divisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_ordering ALTER COLUMN id SET DEFAULT nextval('public.event_ordering_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heats ALTER COLUMN id SET DEFAULT nextval('public.heats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meet_division_events ALTER COLUMN id SET DEFAULT nextval('public.meet_division_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meets ALTER COLUMN id SET DEFAULT nextval('public.meets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools ALTER COLUMN id SET DEFAULT nextval('public.schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: athletes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.athletes (id, fname, lname, minitial, phone, school_id, div_id, problem, coach_notes) FROM stdin;
1	Elijah	Alvarez		\N	2	2	\N	\N
2	Ricky	Alvarez		\N	2	1	\N	\N
3	Valerie	Barocio		\N	2	5	\N	\N
4	Hazel	Batara		\N	2	4	\N	\N
5	Daniel	Brathwaite		\N	2	2	\N	\N
6	Jaydan	Brathwaite		\N	2	1	\N	\N
7	Nerina	Campos		\N	2	6	\N	\N
8	Gregorio	Castro		\N	2	2	\N	\N
9	Mia	Corona		\N	2	5	\N	\N
10	Tristan	Cortez		\N	2	1	\N	\N
11	Jed	Dionisio		\N	2	2	\N	\N
12	Ramiro	Garcia		\N	2	3	\N	\N
13	Steven	Garcia		\N	2	3	\N	\N
14	Makiala	Gonzales		\N	2	5	\N	\N
15	Lorena	Gonzalez		\N	2	6	\N	\N
16	Manuel	Gonzalez		\N	2	2	\N	\N
17	Michelle	Gonzalez		\N	2	4	\N	\N
18	Sergio	Gonzalez		\N	2	2	\N	\N
19	Jennifer	Guarneros		\N	2	4	\N	\N
20	Paige	Gularte		\N	2	6	\N	\N
21	Sabria	Henry-Hunter		\N	2	5	\N	\N
22	Irving	Hermosillo		\N	2	3	\N	\N
23	Angel	Hernandez		\N	2	3	\N	\N
24	Claudia	Hernandez		\N	2	5	\N	\N
25	Jenning De'Amonte	Huntley		\N	2	3	\N	\N
26	Deandre	Jaime		\N	2	3	\N	\N
27	Brian	Jimenez		\N	2	3	\N	\N
28	Brian	Jimenez H		\N	2	2	\N	\N
29	Tayjak	Johnson		\N	2	6	\N	\N
30	Tyshell	Johnson		\N	2	6	\N	\N
31	Gladys	Jovel		\N	2	6	\N	\N
32	Ricardo	Juan		\N	2	2	\N	\N
33	Hector	Juarez		\N	2	3	\N	\N
34	Jeyri	Leon		\N	2	5	\N	\N
35	Sebastian	Lepe		\N	2	3	\N	\N
36	Jordi	Lizaola		\N	2	2	\N	\N
37	Alan	Llamas		\N	2	3	\N	\N
38	Jose	Lomeli		\N	2	2	\N	\N
39	Francisco	Maciel		\N	2	2	\N	\N
40	Carlos	Madrigal		\N	2	3	\N	\N
41	Fatima	Mandujano		\N	2	6	\N	\N
42	Andres	Martinez		\N	2	3	\N	\N
43	Antonio	Martinez		\N	2	2	\N	\N
44	Illiana	Martinez		\N	2	4	\N	\N
45	Kaymberlin	Mendoza		\N	2	6	\N	\N
46	Luis	Mendoza		\N	2	2	\N	\N
47	Andrei	Mina		\N	2	3	\N	\N
48	Joshua	Monctezuma		\N	2	2	\N	\N
49	Jared	Montalvo		\N	2	3	\N	\N
50	Jose	Morado		\N	2	3	\N	\N
51	Alexis	Morales		\N	2	1	\N	\N
52	Juan	Morales		\N	2	2	\N	\N
53	Sarah	Muradas		\N	2	5	\N	\N
54	Juan	Murillo		\N	2	3	\N	\N
55	Nathan	Nagata		\N	2	3	\N	\N
56	Darshana	Nahnd		\N	2	5	\N	\N
57	Esmeralda	Navarro		\N	2	5	\N	\N
58	Sophia	Nunez		\N	2	6	\N	\N
59	Xavier	Ortiz		\N	2	3	\N	\N
60	Nancy	Oviedo		\N	2	5	\N	\N
61	Koby	Pearson		\N	2	1	\N	\N
62	Efrain	Perez		\N	2	2	\N	\N
63	Gabriel	Perez		\N	2	1	\N	\N
64	Gerardo	Perez		\N	2	3	\N	\N
65	Frank	Pinedo		\N	2	3	\N	\N
66	Valerie	Quinonez		\N	2	6	\N	\N
67	Eleazar	Rico		\N	2	3	\N	\N
68	Aliyah	Robles		\N	2	5	\N	\N
69	Jonathan	Rodriguez		\N	2	2	\N	\N
70	Jonny	Rodriguez		\N	2	2	\N	\N
71	Michael	Sanchez		\N	2	2	\N	\N
72	Rigoberto	Sanchez		\N	2	3	\N	\N
73	Keighon	Serrano		\N	2	3	\N	\N
74	Jennie	Tang		\N	2	4	\N	\N
75	Cristian	Tonalixco		\N	2	2	\N	\N
76	Xavier	Torres		\N	2	2	\N	\N
77	Emmanuel	Valdez		\N	2	2	\N	\N
78	Nayeli	Valencia		\N	2	4	\N	\N
79	Vicentejordan	Vanderlipe		\N	2	1	\N	\N
80	Brian	Vasquez		\N	2	2	\N	\N
81	Kimberly	Yanez		\N	2	5	\N	\N
82	Colby	Aalgaard		\N	3	2	\N	\N
83	Cooper	Aiello		\N	3	3	\N	\N
84	Yanira	Alvarez Munoz		\N	3	5	\N	\N
85	Ashlyn	Archibeque		\N	3	6	\N	\N
86	Julian	Arreola		\N	3	2	\N	\N
87	Samuel	Arreola		\N	3	1	\N	\N
88	Richardo	Arreola Padilla		\N	3	3	\N	\N
89	John	Ash		\N	3	3	\N	\N
90	Adrian	Avila		\N	3	3	\N	\N
91	Adrian	Avila Hurtado		\N	3	3	\N	\N
92	Raul	Azcona		\N	3	3	\N	\N
93	Kenna	Barrett		\N	3	6	\N	\N
94	Cesar	Bedolla		\N	3	2	\N	\N
95	Ivan	Benitez		\N	3	2	\N	\N
96	Johnathan	Betz		\N	3	3	\N	\N
97	Chloe	Blackwood		\N	3	5	\N	\N
98	Annie	Breger		\N	3	6	\N	\N
99	Jack	Breger		\N	3	3	\N	\N
100	Kami	Brewer Pozzi		\N	3	5	\N	\N
101	Jenette	Cabrera		\N	3	6	\N	\N
102	Tristan	Camacho		\N	3	1	\N	\N
103	Chelsey	Cameron		\N	3	5	\N	\N
104	Michael	Campos		\N	3	1	\N	\N
105	Nancy	Campos		\N	3	6	\N	\N
106	Christina	Carvalho		\N	3	6	\N	\N
107	Christian	Casarez		\N	3	2	\N	\N
108	William	Castellanos		\N	3	2	\N	\N
109	Gustavo	Castillo		\N	3	1	\N	\N
110	Stephanie	Castillo		\N	3	5	\N	\N
111	Marianna	Castro		\N	3	5	\N	\N
112	Angel	Cesareo		\N	3	3	\N	\N
113	Mariah	Changco		\N	3	5	\N	\N
114	Robert	Chapa		\N	3	3	\N	\N
115	Arturo	Chavez		\N	3	3	\N	\N
116	Christian	Chavez		\N	3	1	\N	\N
117	Nezly	Chavez		\N	3	5	\N	\N
118	Mario Alfonso	Chavez Escobar		\N	3	2	\N	\N
119	Karina	Collins		\N	3	6	\N	\N
120	Shelbey	Conley		\N	3	6	\N	\N
121	Jose	Contreras Rodriguez		\N	3	2	\N	\N
122	Clarissa	Corona		\N	3	5	\N	\N
123	Angel	Cortes		\N	3	3	\N	\N
124	Samantha	Cortez		\N	3	6	\N	\N
125	Gabrielle	Cross		\N	3	6	\N	\N
126	Hailey	Cross		\N	3	5	\N	\N
127	Natalia	Del Moral		\N	3	4	\N	\N
128	Anthony	Delgado		\N	3	2	\N	\N
129	Brandon	Dell		\N	3	3	\N	\N
130	Evan	Duran		\N	3	1	\N	\N
131	Christian	Elizarraras		\N	3	3	\N	\N
132	Dillon	Engler		\N	3	2	\N	\N
133	Ariana	Espinoza		\N	3	4	\N	\N
134	Ryan	Evans		\N	3	1	\N	\N
135	Elian	Fileto		\N	3	3	\N	\N
136	Jordan	Finister		\N	3	3	\N	\N
137	Camille	Finley		\N	3	6	\N	\N
138	Lauren	Flaherty		\N	3	6	\N	\N
139	Ruben	Flores		\N	3	1	\N	\N
140	Ulices	Flores		\N	3	3	\N	\N
141	Hunter	Fu		\N	3	2	\N	\N
142	Marco	Gaitan		\N	3	3	\N	\N
143	Guadalupe	Galvan		\N	3	5	\N	\N
144	Oliver	Garcia		\N	3	3	\N	\N
145	Vanessa	Garcia		\N	3	5	\N	\N
146	Francesca	Giannotta		\N	3	4	\N	\N
147	Caitlyn	Gonzalez		\N	3	6	\N	\N
148	Jonathan	Gonzalez		\N	3	3	\N	\N
149	Yasmin	Gonzalez		\N	3	5	\N	\N
150	Eric	Green		\N	3	1	\N	\N
151	Abigail	Greene		\N	3	6	\N	\N
152	Ray	Guerrero		\N	3	3	\N	\N
153	Antonio	Guerrero Magdaleno		\N	3	1	\N	\N
154	Isaac	Gutierrez		\N	3	1	\N	\N
155	Jasmine	Gutierrez		\N	3	6	\N	\N
156	Niko	Gutierrez		\N	3	1	\N	\N
157	Romaldo	Gutierrez		\N	3	1	\N	\N
158	Benjamin	Hagan		\N	3	2	\N	\N
159	Nevaeh	Henry		\N	3	4	\N	\N
160	Fernando	Hernandez		\N	3	2	\N	\N
161	Jacob	Hernandez		\N	3	1	\N	\N
162	Kelvyn	Hernandez		\N	3	2	\N	\N
163	Vivian	Hernandez		\N	3	6	\N	\N
164	Sonya	Hervey		\N	3	5	\N	\N
165	McKenzie	Hoff		\N	3	5	\N	\N
166	Andre	Holder		\N	3	2	\N	\N
167	Trent	Hurtado		\N	3	2	\N	\N
168	Elizabeth	Jacuinde		\N	3	5	\N	\N
169	Adam	Jimenez		\N	3	1	\N	\N
170	Chris	Johst		\N	3	3	\N	\N
171	Cristal	Juarez Farfan		\N	3	5	\N	\N
172	Richard	Justo		\N	3	3	\N	\N
173	Ethan	Kimber		\N	3	3	\N	\N
174	Megan	Kistner		\N	3	6	\N	\N
175	Elli	Kliewer		\N	3	6	\N	\N
176	Mateo	Koch		\N	3	2	\N	\N
177	Pedro	Laguna		\N	3	2	\N	\N
178	Adrianna	Ledesma		\N	3	6	\N	\N
179	Sarah	Lima		\N	3	4	\N	\N
180	Holly	Lompa		\N	3	6	\N	\N
181	Dennys	Lopez		\N	3	5	\N	\N
182	Leslie	Lopez		\N	3	6	\N	\N
183	Marc	Lopez		\N	3	3	\N	\N
184	Joseph	Loredo		\N	3	2	\N	\N
185	Alexis	Lozano		\N	3	4	\N	\N
186	Samantha	Lucatero		\N	3	4	\N	\N
187	Che	Luevano		\N	3	1	\N	\N
188	Christopher	Maes		\N	3	3	\N	\N
189	Kyle	Manley		\N	3	3	\N	\N
190	Matthew	Manley		\N	3	3	\N	\N
191	Johana	Manzo		\N	3	5	\N	\N
192	Yazmin	Manzo		\N	3	4	\N	\N
193	Abraham	Manzo Hernandez		\N	3	1	\N	\N
194	Gerald	Maresh		\N	3	2	\N	\N
195	Brianna	Martin		\N	3	6	\N	\N
196	Edgar	Martinez		\N	3	1	\N	\N
197	Mia	Martinez		\N	3	6	\N	\N
198	Oscar	Martinez		\N	3	3	\N	\N
199	Badiana	Martinez Garcia		\N	3	5	\N	\N
200	Melissa	McGinnis		\N	3	6	\N	\N
201	Andres	Medina		\N	3	3	\N	\N
202	Christian	Medina		\N	3	3	\N	\N
203	Galilea	Medina Ruiz		\N	3	5	\N	\N
204	Nayeli	Medina Ruiz		\N	3	5	\N	\N
205	Joseph	Medrano		\N	3	2	\N	\N
206	Michelle	Medrano Sanchez		\N	3	6	\N	\N
207	Luis	Melo		\N	3	3	\N	\N
208	Adam	Mendoza		\N	3	3	\N	\N
209	Ivan	Mendoza		\N	3	1	\N	\N
210	Luis	Mendoza		\N	3	3	\N	\N
211	Robert	Mendoza		\N	3	2	\N	\N
212	Taryn	Mills		\N	3	4	\N	\N
213	Rafael	Miramontes		\N	3	2	\N	\N
214	Maritza	Molina		\N	3	6	\N	\N
215	Brittany	Moore		\N	3	4	\N	\N
216	Raighan	Mooshabad		\N	3	4	\N	\N
217	Manuel	Mora		\N	3	1	\N	\N
218	Axel	Mora Bravo		\N	3	1	\N	\N
219	Kimberly	Morales		\N	3	6	\N	\N
220	Samantha	Moran		\N	3	4	\N	\N
221	Brandon	Morgan		\N	3	2	\N	\N
222	Nathan	Morioka		\N	3	3	\N	\N
223	Anai	Murillo Gonzalez		\N	3	5	\N	\N
224	Brittany	Navarro		\N	3	6	\N	\N
225	Jessica	Neff		\N	3	5	\N	\N
226	Lisa	Nguyen		\N	3	6	\N	\N
227	Colby	Noble		\N	3	3	\N	\N
228	Ricardo	Nunez		\N	3	1	\N	\N
229	Hunter	Nye		\N	3	3	\N	\N
230	Trey	Oldakowski		\N	3	1	\N	\N
231	Sebastian	Orozco		\N	3	3	\N	\N
232	Chris	Outman		\N	3	3	\N	\N
233	Leah	Overman		\N	3	6	\N	\N
234	Carlos	Paniagua		\N	3	3	\N	\N
235	Chris	Parga		\N	3	3	\N	\N
236	Makenna	Parks		\N	3	6	\N	\N
237	Ella Shara	Pascua		\N	3	4	\N	\N
238	Daniel	Pasillas		\N	3	3	\N	\N
239	Julia	Pearson		\N	3	5	\N	\N
240	Steven	Pedersen		\N	3	2	\N	\N
241	Cheyenne	Peebles		\N	3	5	\N	\N
242	Dakota	Peebles		\N	3	6	\N	\N
243	Jimmy	Pelaiz		\N	3	2	\N	\N
244	Jesus	Perez		\N	3	1	\N	\N
245	Marcos	Perez		\N	3	2	\N	\N
246	Jacqueline	Perez Archibeque		\N	3	5	\N	\N
247	Aaliyah	Perillo		\N	3	4	\N	\N
248	Maya	Peterson		\N	3	4	\N	\N
249	Izia	Polanco		\N	3	2	\N	\N
250	Sara	Power		\N	3	6	\N	\N
251	Aiden	Pung		\N	3	2	\N	\N
252	Emily	Quinby		\N	3	5	\N	\N
253	Kathryn	Quinones		\N	3	6	\N	\N
254	Emiliano	Quintero		\N	3	1	\N	\N
255	Diego	Ramirez		\N	3	2	\N	\N
256	Lisbeth	Ramirez		\N	3	5	\N	\N
257	Lucero	Ramirez		\N	3	6	\N	\N
258	Emily	Ramirez Lagunas		\N	3	6	\N	\N
259	Jonathan	Ramos		\N	3	2	\N	\N
260	Kristian	Reardon		\N	3	2	\N	\N
261	Nolan	Redman		\N	3	2	\N	\N
262	Isaac	Regalado		\N	3	3	\N	\N
263	Peter	Reikowski		\N	3	3	\N	\N
264	Amber	Rericha		\N	3	4	\N	\N
265	Theodore	Rialson		\N	3	1	\N	\N
266	Nathaniel	Robles		\N	3	1	\N	\N
267	Brandon	Rodriguez		\N	3	3	\N	\N
268	James	Rodriguez		\N	3	2	\N	\N
269	Michelle	Rodriguez		\N	3	6	\N	\N
270	Rudy	Rodriguez		\N	3	1	\N	\N
271	Yazmin	Rodriguez		\N	3	6	\N	\N
272	Iris Yuliana	Roman Guzman		\N	3	6	\N	\N
273	Joseph	Romero		\N	3	1	\N	\N
274	Jasmine	Rosales Castillo		\N	3	5	\N	\N
275	Elliot	Ruiz		\N	3	2	\N	\N
276	Annie	Ruvalcaba		\N	3	5	\N	\N
277	Emma	Saguindel		\N	3	4	\N	\N
278	Michael	Sainz		\N	3	3	\N	\N
279	Alexander	San Miguel		\N	3	2	\N	\N
280	Bobby	Sanchez		\N	3	1	\N	\N
281	Joseph	Sanchez		\N	3	3	\N	\N
282	Katalina	Santiago		\N	3	5	\N	\N
283	Hailey	Schleeter-Powell		\N	3	6	\N	\N
284	Cameron	Schmuckle		\N	3	1	\N	\N
285	Carson	Schmuckle		\N	3	3	\N	\N
286	Erik	Servin		\N	3	1	\N	\N
287	Tyler	Shelton		\N	3	2	\N	\N
288	Ian	Sills		\N	3	2	\N	\N
289	Ryan	Sims		\N	3	6	\N	\N
290	Ashley	Smith		\N	3	6	\N	\N
291	Shaelynne	Smith		\N	3	6	\N	\N
292	Cloey	Stiers		\N	3	4	\N	\N
293	Mackenzie	Stoner		\N	3	5	\N	\N
294	Nicole	Taluban		\N	3	6	\N	\N
295	Cesar	Tapia		\N	3	2	\N	\N
296	Jada	Taylor		\N	3	5	\N	\N
297	Kaitlyn	Tedesco		\N	3	5	\N	\N
298	Ray	Tiscareno		\N	3	3	\N	\N
299	Grace	Tomasini		\N	3	4	\N	\N
300	Jerry	Torres		\N	3	3	\N	\N
301	Hannah	Trimble		\N	3	5	\N	\N
302	Jose	Velarde-Ruiz		\N	3	2	\N	\N
303	Summer	Vowinkle		\N	3	4	\N	\N
304	Hailee	Westrick		\N	3	4	\N	\N
305	Anna	Williams		\N	3	6	\N	\N
306	Alex	Avila		\N	4	1	\N	\N
307	Cesar	Avila		\N	4	2	\N	\N
308	Jacob	Avila		\N	4	3	\N	\N
309	Addam	Banuelos		\N	4	3	\N	\N
310	Arely	Campos		\N	4	5	\N	\N
311	Ella	De Amaral		\N	4	6	\N	\N
312	Angel	Garcia		\N	4	3	\N	\N
313	Martin	Guzman		\N	4	3	\N	\N
314	Gianna	Herbert		\N	4	4	\N	\N
315	Peyton	Masuen		\N	4	5	\N	\N
316	Daniel	Melendez		\N	4	2	\N	\N
317	Luis	Morales		\N	4	3	\N	\N
318	Jasmine	Rios		\N	4	5	\N	\N
319	Ethan	Woehrmann		\N	4	3	\N	\N
320	Travis	Wronksi		\N	4	3	\N	\N
321	Diego	Almaraz		\N	5	3	\N	\N
322	Ellie	Alto		\N	5	6	\N	\N
323	Sienna	Anderson		\N	5	4	\N	\N
324	Skye	Arle		\N	5	3	\N	\N
325	Sam	Boone		\N	5	3	\N	\N
326	Gabrielle	Borges		\N	5	4	\N	\N
327	Robert	Brown		\N	5	2	\N	\N
328	Savannah	Chappell		\N	5	4	\N	\N
329	Maxim	Clark		\N	5	3	\N	\N
330	Noah	Conklin		\N	5	1	\N	\N
331	Luke	Danzer		\N	5	2	\N	\N
332	Zach	DeZee		\N	5	2	\N	\N
333	Jessica	Dilullo		\N	5	6	\N	\N
334	Kiana	Dorantes		\N	5	4	\N	\N
335	Maggie	Ellison		\N	5	5	\N	\N
336	Peter	Ellison		\N	5	2	\N	\N
337	Svenn	Eyjolfsson		\N	5	1	\N	\N
338	Jamison	Farrington		\N	5	1	\N	\N
339	Alex	Faxon		\N	5	1	\N	\N
340	Tommaso	Feo		\N	5	3	\N	\N
341	Michelle	Foley		\N	5	4	\N	\N
342	Amaya	Gomez		\N	5	4	\N	\N
343	Jonathan	Hamilton		\N	5	2	\N	\N
344	Connor	Hatch		\N	5	3	\N	\N
345	Hunter	Heger		\N	5	1	\N	\N
346	Sebastian	Hendricks		\N	5	1	\N	\N
347	Gillian	Horak		\N	5	4	\N	\N
348	Connor	Houlihan		\N	5	2	\N	\N
349	Jessica	Hwang		\N	5	6	\N	\N
350	Tara	Jones		\N	5	6	\N	\N
351	Zachary	Keaton		\N	5	1	\N	\N
352	Noah	Kirsch		\N	5	3	\N	\N
353	Annalise	Krueger		\N	5	5	\N	\N
354	Nick	Krueger		\N	5	3	\N	\N
355	Ashley	Langley		\N	5	5	\N	\N
356	Soana	Laulotu		\N	5	5	\N	\N
357	Emily	Lazarus		\N	5	5	\N	\N
358	LiMei	Louis		\N	5	4	\N	\N
359	Andy	Ma		\N	5	3	\N	\N
360	Angel	Madrigal		\N	5	2	\N	\N
361	Orlandis	Mathes		\N	5	1	\N	\N
362	Natalie	Mazaud		\N	5	4	\N	\N
363	Scott	McMahon		\N	5	3	\N	\N
364	Michael	Meheen		\N	5	1	\N	\N
365	Muni	Mohamed		\N	5	1	\N	\N
366	Pascale	Montgomery		\N	5	4	\N	\N
367	Sarah	Morgan		\N	5	5	\N	\N
368	Robert	Mowry		\N	5	2	\N	\N
369	Gabrielle	Obligacion		\N	5	6	\N	\N
370	Nathan	Oros		\N	5	2	\N	\N
371	Cody	O'Rourke		\N	5	3	\N	\N
372	Miles	Prekoski		\N	5	1	\N	\N
373	Dalton	Quilty		\N	5	3	\N	\N
374	Adam	Ramlawi		\N	5	1	\N	\N
375	Vincent	Ravalin		\N	5	3	\N	\N
376	Julian	Resendiz		\N	5	3	\N	\N
377	Carlos	Robles		\N	5	3	\N	\N
378	Zach	Rossi		\N	5	3	\N	\N
379	Nathan	Schneiderman		\N	5	1	\N	\N
380	Katie	Short		\N	5	4	\N	\N
381	Nathan	Suess		\N	5	3	\N	\N
382	Elijah	Thompson		\N	5	3	\N	\N
383	Tio	Turrini-Smith		\N	5	3	\N	\N
384	Melanie	Verga		\N	5	5	\N	\N
385	Madison	Vernon		\N	5	4	\N	\N
386	Rashaan	Ward		\N	5	2	\N	\N
387	Rohan	Warner		\N	5	3	\N	\N
388	West	Whittaker		\N	5	3	\N	\N
389	Alexis	Aceves		\N	6	3	\N	\N
390	Melissa	Aceves		\N	6	6	\N	\N
391	Damian	Acosta		\N	6	3	\N	\N
392	Anissa	Aguilar		\N	6	4	\N	\N
393	Jesus	Alcantar		\N	6	3	\N	\N
394	Mireya	Alvarez		\N	6	4	\N	\N
395	Jacob	Amador		\N	6	2	\N	\N
396	Angel	Anguiano		\N	6	3	\N	\N
397	Miguel	Arreola		\N	6	2	\N	\N
398	Edgar	Arriola		\N	6	3	\N	\N
399	Jack	Banuelos		\N	6	2	\N	\N
400	Angel	Bautista		\N	6	1	\N	\N
401	Damian	Castaneda		\N	6	2	\N	\N
402	Ivan	Correa		\N	6	2	\N	\N
403	Matthew	Cortez		\N	6	2	\N	\N
404	Stephanie	Delgado		\N	6	6	\N	\N
405	Ismael	Duarte		\N	6	3	\N	\N
406	Cecilia	Espinoza		\N	6	5	\N	\N
407	Ulysses	Fierros		\N	6	3	\N	\N
408	Alex	Flores		\N	6	5	\N	\N
409	Nick	Flores		\N	6	3	\N	\N
410	Andrew	Funk		\N	6	1	\N	\N
411	Scott	Funk		\N	6	2	\N	\N
412	Miguel	Garcia		\N	6	3	\N	\N
413	Rodrigo	Garcia		\N	6	3	\N	\N
414	Greg	Gudino		\N	6	2	\N	\N
415	Juan	Hernandez		\N	6	2	\N	\N
416	Leslie	Hernandez		\N	6	4	\N	\N
417	Octavio	Hernandez		\N	6	2	\N	\N
418	Angel	Huerta		\N	6	3	\N	\N
419	Kathleen	Humphries		\N	6	6	\N	\N
420	Danielle	Javier		\N	6	4	\N	\N
421	Xavier	Jimenez		\N	6	1	\N	\N
422	Helga	Klemezdottir		\N	6	6	\N	\N
423	Athena	Landeros		\N	6	5	\N	\N
424	Maria	Lopez		\N	6	4	\N	\N
425	Ray	Lopez		\N	6	3	\N	\N
426	Iris	Manriquez		\N	6	6	\N	\N
427	Jorge	Manriquez		\N	6	3	\N	\N
428	Sarah	Marmolejo		\N	6	5	\N	\N
429	Alyssa	Martinez		\N	6	6	\N	\N
430	Mario	Martinez		\N	6	3	\N	\N
431	Jairo	Medina		\N	6	3	\N	\N
432	Faustino	Mendez		\N	6	3	\N	\N
433	Martin	Mendez		\N	6	2	\N	\N
434	Pablo	Mendoza		\N	6	2	\N	\N
435	Hernan	Mojica		\N	6	3	\N	\N
436	Christian	Patino		\N	6	2	\N	\N
437	Andy	Perez		\N	6	3	\N	\N
438	Jaime	Perez		\N	6	3	\N	\N
439	Nathan	Perez		\N	6	1	\N	\N
440	Jackie	Ramirez		\N	6	5	\N	\N
441	Jorge	Ramirez		\N	6	2	\N	\N
442	Genaro	Renteria		\N	6	3	\N	\N
443	Patricia	Resendiz		\N	6	6	\N	\N
444	Elias	Rico		\N	6	3	\N	\N
445	Gil	Rodriguez		\N	6	3	\N	\N
446	Julian	Rodriguez		\N	6	1	\N	\N
447	Marilyn	Rodriguez		\N	6	6	\N	\N
448	Veronica	Rodriguez		\N	6	4	\N	\N
449	Felix	Romero		\N	6	3	\N	\N
450	Jerome	Russell		\N	6	1	\N	\N
451	Luis	Sainz		\N	6	2	\N	\N
452	Bianca	Sanchez		\N	6	6	\N	\N
453	Jose	Sanchez		\N	6	3	\N	\N
454	Madison	Schweitzer		\N	6	4	\N	\N
455	Jazmin	Useda		\N	6	4	\N	\N
456	Jade	Valdez		\N	6	4	\N	\N
457	Jose	Valdez		\N	6	3	\N	\N
458	Jossue	Valdez		\N	6	3	\N	\N
459	Nael	Vazquez		\N	6	2	\N	\N
460	Pablo	Villasenor		\N	6	2	\N	\N
461	Jasmin	Yadao		\N	6	6	\N	\N
462	Celeste	Castro		\N	7	6	\N	\N
463	Daniel	Cerna		\N	7	2	\N	\N
464	Marina Jane	Cerna		\N	7	4	\N	\N
465	Andrew	Dang		\N	7	1	\N	\N
466	Alejandro	De Jesus		\N	7	3	\N	\N
467	Abraham	Dominquez Perez		\N	7	2	\N	\N
468	Daniel	Dominquez Perez		\N	7	1	\N	\N
469	Gladis	Garcia		\N	7	4	\N	\N
470	Rodrigo	Garcia		\N	7	2	\N	\N
471	Daniel	Gonzales		\N	7	1	\N	\N
472	Martin	Hernandez Ramos		\N	7	1	\N	\N
473	Isaac	Lopez		\N	7	1	\N	\N
474	Maria	Malagon		\N	7	6	\N	\N
475	Kristian	Maldonado		\N	7	3	\N	\N
476	Adrian	Martinez		\N	7	1	\N	\N
477	Ericka	Martinez		\N	7	5	\N	\N
478	Kenny	Martinez		\N	7	2	\N	\N
479	Sebastian	Meza		\N	7	1	\N	\N
480	Jesus	Ortega		\N	7	2	\N	\N
481	Luis	Perez		\N	7	3	\N	\N
482	Hector	Ramirez		\N	7	3	\N	\N
483	Alexis	Sanchez		\N	7	2	\N	\N
484	Francisco	Sanchez		\N	7	1	\N	\N
485	Jonathon	Villegas		\N	7	3	\N	\N
486	Noemi	Amezcua		\N	8	6	\N	\N
487	Nancy	Andrade		\N	8	5	\N	\N
488	Rodrigo	Andrade		\N	8	2	\N	\N
489	Gisela	Aparicio		\N	8	6	\N	\N
490	Jesus	Avalos		\N	8	3	\N	\N
491	Jhames	Bautista		\N	8	2	\N	\N
492	Daniela	Bedolla		\N	8	5	\N	\N
493	Joe	Black		\N	8	3	\N	\N
494	Emmitt	Blacks		\N	8	3	\N	\N
495	Luis	Briseño		\N	8	2	\N	\N
496	Elizabeth	Bryant		\N	8	6	\N	\N
497	Isidro	Cabrera		\N	8	3	\N	\N
498	Delaney	Carroll		\N	8	5	\N	\N
499	Elizabeth	Cazares		\N	8	6	\N	\N
500	Daisy	Chavez		\N	8	5	\N	\N
501	Emily	Chavez		\N	8	6	\N	\N
502	Xabier	Espinoza		\N	8	2	\N	\N
503	Cassidy	Flores		\N	8	6	\N	\N
504	Federico	Flores		\N	8	2	\N	\N
505	Freddy	Garcia		\N	8	3	\N	\N
506	Esteban	Gonzales		\N	8	3	\N	\N
507	Isaias	Gonzales		\N	8	2	\N	\N
508	Israel	Gutierrez		\N	8	3	\N	\N
509	Michael	Hart		\N	8	3	\N	\N
510	Isaac	Huerta		\N	8	2	\N	\N
511	Luis	Luna		\N	8	3	\N	\N
512	Justin	Mantel		\N	8	3	\N	\N
513	Miguel	Martinez		\N	8	3	\N	\N
514	Fausto	Medina		\N	8	1	\N	\N
515	Jalen	Mendez		\N	8	4	\N	\N
516	Roman	Munoz		\N	8	3	\N	\N
517	Cali	Murillo		\N	8	6	\N	\N
518	Kyle	Near		\N	8	3	\N	\N
519	Dylan	Oliveros		\N	8	2	\N	\N
520	Christian	Olmos		\N	8	3	\N	\N
521	Milagros	Ortega		\N	8	6	\N	\N
522	Kevin	Pena		\N	8	3	\N	\N
523	Stephanie	Politron		\N	8	6	\N	\N
524	Bella	Rava		\N	8	5	\N	\N
525	Jackie	Rios		\N	8	6	\N	\N
526	Lauren	Rist		\N	8	6	\N	\N
527	Ismael	Rocha		\N	8	3	\N	\N
528	Kajar	Rodgers		\N	8	4	\N	\N
529	Edith	Rojas		\N	8	6	\N	\N
530	Christian	Rose		\N	8	3	\N	\N
531	Ricardo	Ruelas		\N	8	3	\N	\N
532	Cody	Scrivner		\N	8	3	\N	\N
533	Grace	Shepherd		\N	8	5	\N	\N
534	Drury	Tankersley		\N	8	3	\N	\N
535	Jose V.	Torres		\N	8	3	\N	\N
536	Jackelyn	Zavala		\N	8	6	\N	\N
537	Rosa Elena	Acevedo		\N	9	6	\N	\N
538	Ali	Alkhawldy		\N	9	2	\N	\N
539	Bryan	Arredondo		\N	9	2	\N	\N
540	Leanne	Bagood		\N	9	5	\N	\N
541	Smilepreet	Bal		\N	9	6	\N	\N
542	Sukhneet	Bal		\N	9	3	\N	\N
543	David	Brooks		\N	9	3	\N	\N
544	Michael	Dronet		\N	9	3	\N	\N
545	Andrea	Escobedo		\N	9	4	\N	\N
546	Fermin	Gabot		\N	9	3	\N	\N
547	Michael	Garcia-Reyes		\N	9	2	\N	\N
548	Isaias	Guizar		\N	9	2	\N	\N
549	Karla	Herrera		\N	9	4	\N	\N
550	Leo	Isidro		\N	9	1	\N	\N
551	Jefferson	Lagudas		\N	9	3	\N	\N
552	Will	Leander		\N	9	3	\N	\N
553	Olivia	Lehman		\N	9	5	\N	\N
554	Daniel	Lucas		\N	9	3	\N	\N
555	Christopher	Plascencia		\N	9	2	\N	\N
556	Sierra	Ravinski		\N	9	5	\N	\N
557	Jackie	Reyes		\N	9	5	\N	\N
558	Bruno	Salcido		\N	9	3	\N	\N
559	Amadeus	Soria		\N	9	2	\N	\N
560	Robert	Valencia		\N	9	3	\N	\N
561	Alberto (A.J.)	Gastelum		\N	10	1	\N	\N
562	Jeb	Goldman		\N	10	2	\N	\N
563	Nicholas	Kawwas		\N	10	2	\N	\N
564	Adam	Kim		\N	10	2	\N	\N
565	Jack (Yize)	Ma		\N	10	1	\N	\N
566	Maryam	Moghaddami		\N	10	5	\N	\N
567	Jashan	Pabla		\N	10	1	\N	\N
568	Gabe	Piper		\N	10	3	\N	\N
569	Hannah	Selby		\N	10	5	\N	\N
570	Nathan	Walker		\N	10	3	\N	\N
571	Eric	Aldrich		\N	11	1	\N	\N
572	Kevin	Antonino		\N	11	3	\N	\N
573	Elizabeth	Armstrong		\N	11	4	\N	\N
574	Chloe	Chipman		\N	11	4	\N	\N
575	Conor	Driscoll-Natale		\N	11	1	\N	\N
576	Liam	Failor-Wass		\N	11	2	\N	\N
577	Corey	Friedenbach		\N	11	6	\N	\N
578	Kathryn	Haney		\N	11	5	\N	\N
579	Jack	Isacson		\N	11	1	\N	\N
580	Cameron	Kies		\N	11	2	\N	\N
581	Roxana	Ortiz		\N	11	5	\N	\N
582	Tristan	Peterson		\N	11	3	\N	\N
583	Erika	Pistor		\N	11	6	\N	\N
584	Catharina	Rogaczewski		\N	11	5	\N	\N
585	Milo	Rudman		\N	11	2	\N	\N
586	Anna	Spangrud		\N	11	5	\N	\N
587	Alex	Stout		\N	11	6	\N	\N
588	Sachiko	Tate		\N	11	6	\N	\N
589	Miles	Voenell		\N	11	1	\N	\N
590	Max	Afifi		\N	12	2	\N	\N
591	Tiago	Agostini		\N	12	1	\N	\N
592	Jake	Alt		\N	12	2	\N	\N
593	Hannah	Bennett		\N	12	4	\N	\N
594	Noor	Benny		\N	12	4	\N	\N
595	Taylor	Biondi		\N	12	5	\N	\N
596	Ray	Birkett		\N	12	1	\N	\N
597	Nick	Coppla		\N	12	3	\N	\N
598	Andrew	Crannell		\N	12	1	\N	\N
599	Batuhan	Demir		\N	12	2	\N	\N
600	Zach	Goodwin		\N	12	3	\N	\N
601	Mary	Grebing		\N	12	6	\N	\N
602	Courtney	Gurries		\N	12	4	\N	\N
603	Paul	Gurries		\N	12	3	\N	\N
604	Julius	Gutierrez		\N	12	1	\N	\N
605	Delson	Hays		\N	12	1	\N	\N
606	Rachel	House		\N	12	6	\N	\N
607	Gavin	James		\N	12	3	\N	\N
608	Thomas	Jameson		\N	12	1	\N	\N
609	Leo	Lauritzen		\N	12	1	\N	\N
610	Luca	Lauritzen		\N	12	3	\N	\N
611	Christine	Lee		\N	12	5	\N	\N
612	Henry	Loh		\N	12	3	\N	\N
613	India	Maaske		\N	12	6	\N	\N
614	Callie	McGraw		\N	12	5	\N	\N
615	Bryce	Montgomery		\N	12	1	\N	\N
616	Mike	Paff		\N	12	3	\N	\N
617	Taylor	Rainey		\N	12	5	\N	\N
618	Cameron	Reeves		\N	12	3	\N	\N
619	Robertson	Rice		\N	12	1	\N	\N
620	Bella	Rohrer		\N	12	4	\N	\N
621	Rachel	Sands		\N	12	5	\N	\N
622	Tyler	Smithro		\N	12	1	\N	\N
623	Parker	Staples		\N	12	6	\N	\N
624	Anna	Stefanou		\N	12	6	\N	\N
625	Will	Stefanou		\N	12	1	\N	\N
626	Nami	Suzuki		\N	12	6	\N	\N
627	Kulaea	Tulua		\N	12	6	\N	\N
628	Jada	Ware		\N	12	6	\N	\N
629	Jacob	Wren		\N	12	3	\N	\N
630	Jacob	Zeidberg		\N	12	2	\N	\N
631	Rosa	Aguilar		\N	13	6	\N	\N
632	Barbara	Avalos		\N	13	6	\N	\N
633	Carolina	Bishop		\N	13	6	\N	\N
634	Avery	Blanco		\N	13	6	\N	\N
635	Yvett	Cardenas		\N	13	5	\N	\N
636	Lauren	Dean		\N	13	4	\N	\N
637	Caitlyn	Giannini		\N	13	5	\N	\N
638	Kacey	Konya		\N	13	5	\N	\N
639	Ana	Leon		\N	13	6	\N	\N
640	Annie	Luo		\N	13	5	\N	\N
641	Ana Sofia	Magana		\N	13	6	\N	\N
642	Daniela	Mastretta		\N	13	6	\N	\N
643	Orlinka	Mitoko-Kereere		\N	13	6	\N	\N
644	Maya	Pruthi		\N	13	5	\N	\N
645	Mikayla	Revera		\N	13	6	\N	\N
646	Emma	Roffler		\N	13	6	\N	\N
647	Laurel	Wong		\N	13	5	\N	\N
648	Luis	Alba		\N	14	1	\N	\N
649	Lyla	Alderete		\N	14	6	\N	\N
650	Preciosa	Almaraz		\N	14	5	\N	\N
651	Marlene	Alonza		\N	14	6	\N	\N
652	Axel	Amaro		\N	14	1	\N	\N
653	Edward	Bachtel		\N	14	2	\N	\N
654	Alyssa	Borbon		\N	14	4	\N	\N
655	Jacob	Burgoz		\N	14	1	\N	\N
656	Ulises	Camarena		\N	14	3	\N	\N
657	Destiny	Carrillo		\N	14	5	\N	\N
658	Tamara	Castillo		\N	14	4	\N	\N
659	Christian	Chan		\N	14	3	\N	\N
660	Theresa	Chavez		\N	14	4	\N	\N
661	Daniel	Contawe		\N	14	3	\N	\N
662	Anselmo	De Jesus		\N	14	3	\N	\N
663	Gyrallene	Degarcia		\N	14	4	\N	\N
664	Belen	Flores		\N	14	5	\N	\N
665	Josiah	Freeman		\N	14	1	\N	\N
666	Gabriella	Gasca		\N	14	6	\N	\N
667	Aliyah	Gonzalez		\N	14	6	\N	\N
668	Christopher	Gonzalez		\N	14	2	\N	\N
669	Miguel	Gonzalez		\N	14	3	\N	\N
670	Ramona	Granillo		\N	14	4	\N	\N
671	Julian	Hernandez		\N	14	3	\N	\N
672	Jessica	Herrera		\N	14	5	\N	\N
673	Christopher	Huerta		\N	14	2	\N	\N
674	Leslie	Jimenez		\N	14	4	\N	\N
675	Neidi	Jorge		\N	14	5	\N	\N
676	Danyelle	Landeros		\N	14	4	\N	\N
677	Andrea	Martinez		\N	14	5	\N	\N
678	Estefani	Martinez		\N	14	5	\N	\N
679	Talia	Medina		\N	14	5	\N	\N
680	Elise	Melchor		\N	14	5	\N	\N
681	Adrian	Mellin		\N	14	1	\N	\N
682	Salvador	Meza		\N	14	2	\N	\N
683	Estefania	Montel		\N	14	4	\N	\N
684	Jonathan	Morales		\N	14	1	\N	\N
685	Marcus	Morales		\N	14	1	\N	\N
686	Crystal	Moreno		\N	14	4	\N	\N
687	Angel	Olivas		\N	14	2	\N	\N
688	Lauryn	Orozco		\N	14	6	\N	\N
689	Emanual	Ortega		\N	14	3	\N	\N
690	Andrew	Palmerin		\N	14	2	\N	\N
691	Miguel	Paredes		\N	14	1	\N	\N
692	Odalys	Paredes		\N	14	6	\N	\N
693	Victor	Phillips		\N	14	1	\N	\N
694	Arilene	Rios		\N	14	6	\N	\N
695	Vivianna	Robledo		\N	14	4	\N	\N
696	Jesus	Rodriguez		\N	14	2	\N	\N
697	Iris	Ruis		\N	14	5	\N	\N
698	Francisco	Sanchez		\N	14	1	\N	\N
699	Juan	Sanchez		\N	14	2	\N	\N
700	Iziah	Stone		\N	14	2	\N	\N
701	Isabel	Suarez		\N	14	5	\N	\N
702	Emily	Tinajero		\N	14	5	\N	\N
703	Raul	Trujillo		\N	14	3	\N	\N
704	Jose	Velasco		\N	14	1	\N	\N
705	Jose	Villalobos		\N	14	3	\N	\N
706	Krystal	Villegas		\N	14	4	\N	\N
707	Daisy	Virgen		\N	14	5	\N	\N
708	Denise	Virgen		\N	14	5	\N	\N
709	Treyon	Walker		\N	14	3	\N	\N
710	Emily	Adomako		\N	15	4	\N	\N
711	Lillian	Agar		\N	15	5	\N	\N
712	Cyrus	Barringer		\N	15	3	\N	\N
713	Gabrielle	Butler		\N	15	5	\N	\N
714	Ray	Cai		\N	15	3	\N	\N
715	Harry	Cheung		\N	15	3	\N	\N
716	Clarence	Chou		\N	15	1	\N	\N
717	Kieren	Daste		\N	15	1	\N	\N
718	Guido	Davi		\N	15	1	\N	\N
719	Eliza	Foster		\N	15	6	\N	\N
720	Grace	Ingram		\N	15	4	\N	\N
721	Alexander	Jensen		\N	15	3	\N	\N
722	Hale	Jones		\N	15	3	\N	\N
723	Philo	Katzman		\N	15	2	\N	\N
724	Carlin	Kempt		\N	15	6	\N	\N
725	Fauve	Koontz		\N	15	6	\N	\N
726	Cade	Laranang		\N	15	3	\N	\N
727	Nathan	Ma		\N	15	3	\N	\N
728	Colin	McEachen		\N	15	2	\N	\N
729	Alexander	Meredith		\N	15	3	\N	\N
730	Nicole	Naquin		\N	15	6	\N	\N
731	Helen	Nickerson		\N	15	6	\N	\N
732	Emilio	Orozco		\N	15	3	\N	\N
733	Tom	Phan		\N	15	3	\N	\N
734	Faith	Pinnow		\N	15	4	\N	\N
735	Annika	Roberts		\N	15	6	\N	\N
736	Erika	Roberts		\N	15	4	\N	\N
737	Charles	Shim		\N	15	3	\N	\N
738	Csilla	Smith		\N	15	6	\N	\N
739	Peter	Song		\N	15	3	\N	\N
740	Quynh	Stanoff		\N	15	6	\N	\N
741	Madison	Strickling		\N	15	6	\N	\N
742	Flora	Tamm		\N	15	5	\N	\N
743	Lucas	Tilly		\N	15	3	\N	\N
744	Jacob	Wang		\N	15	3	\N	\N
745	Lola	Wilcox		\N	15	4	\N	\N
746	Tony	Zhou		\N	15	3	\N	\N
747	Kaden	Agha		\N	16	3	\N	\N
748	Max	Burke		\N	16	2	\N	\N
749	Tristen	Laney		\N	16	2	\N	\N
750	Evan	Li		\N	16	3	\N	\N
751	Joseph	Rhee		\N	16	3	\N	\N
752	Adam	Shapiro		\N	16	2	\N	\N
753	Washakie	Tibbetts		\N	16	3	\N	\N
754	Jonathan	Zhao		\N	16	1	\N	\N
755	Gracie	Antrim-Kerr		\N	17	6	\N	\N
756	Uirassu	de Almeida		\N	17	3	\N	\N
757	Connor	Hetzler		\N	17	3	\N	\N
758	Keinan	Mactins		\N	17	2	\N	\N
759	Chloe	Ortiz		\N	17	6	\N	\N
760	Jasmin	schulz		\N	17	4	\N	\N
761	Elijah	Stone		\N	17	2	\N	\N
762	Anthony	Gonzalez		\N	6	1	\N	\N
763	Isabel	Mendoza		\N	6	4	\N	\N
764	Madisyn	Schweitzer		\N	6	4	\N	\N
765	Jesus	Trujillo		\N	6	2	\N	\N
766	Christian	Derbonne-Sipal		\N	9	3	\N	\N
767	Rina	Rossi		\N	11	4	\N	\N
768	Deaven	Keller		\N	12	3	\N	\N
769	Destiny	Hansen		\N	4	6	\N	\N
770	Nayeli	De Jesus		\N	7	5	\N	\N
771	Abraham	Dominguez Perez		\N	7	2	\N	\N
772	Jaime	Martinez		\N	7	3	\N	\N
773	Evelin	Meza		\N	7	6	\N	\N
774	Nancy	Ortiz		\N	7	5	\N	\N
775	Daniel	Perez		\N	7	1	\N	\N
776	Monica	Reyes		\N	7	5	\N	\N
777	Maria	Santiago		\N	7	5	\N	\N
778	Edward	Villagomez		\N	7	2	\N	\N
779	Gage	Barmes		\N	8	1	\N	\N
780	David	Black		\N	8	1	\N	\N
781	Cesar	Chavez		\N	8	1	\N	\N
782	George	Chavez		\N	8	3	\N	\N
783	Yoali	Cid		\N	8	5	\N	\N
784	Dominic	Conricode		\N	8	1	\N	\N
785	Felipe	Cruz		\N	8	1	\N	\N
786	Jesal	Desai		\N	8	2	\N	\N
787	Ricardo	Diaz		\N	8	1	\N	\N
788	Syrina	Espinoza		\N	8	4	\N	\N
789	Andy	Garcia		\N	8	1	\N	\N
790	Draven	Halstead		\N	8	1	\N	\N
791	Ashton	Headley		\N	8	1	\N	\N
792	Kyras	Headley		\N	8	1	\N	\N
793	Maria	Lobato		\N	8	4	\N	\N
794	Bryce	McEwen		\N	8	1	\N	\N
795	Luis	Morales		\N	8	1	\N	\N
796	Cassandra	Murillo		\N	8	5	\N	\N
797	Abel	Quintero		\N	8	1	\N	\N
798	Robert	Reyes		\N	8	3	\N	\N
799	Allen	Rocha		\N	8	1	\N	\N
800	Monica	Rodriguez		\N	8	5	\N	\N
801	Carson	Roylance		\N	8	2	\N	\N
802	Xavier	Salone		\N	8	1	\N	\N
803	Gloria	Sanchez		\N	8	4	\N	\N
804	Francisco	Sandoval		\N	8	1	\N	\N
805	Jose	Santos		\N	8	1	\N	\N
806	Pablo	Silva		\N	8	3	\N	\N
807	Daniel	Smith		\N	8	1	\N	\N
808	Carter	Tugel		\N	8	2	\N	\N
809	Francisco	Vega		\N	8	1	\N	\N
810	Miguel	Zendejas		\N	8	2	\N	\N
811	Hannia	Zuniga		\N	8	5	\N	\N
812	Edson	Ortiz		\N	9	2	\N	\N
813	Andrew	Perez		\N	9	3	\N	\N
814	Laura	Bauman		\N	16	6	\N	\N
815	Jaryd	Mercer		\N	16	2	\N	\N
816	Genevieve	Roeder-Hensley		\N	16	6	\N	\N
817	Jack	Whilden		\N	16	3	\N	\N
818	Quincy	Hendricks		\N	5	3	\N	\N
819	Colleen	Lang		\N	5	5	\N	\N
820	Olandis	Mathes		\N	5	1	\N	\N
821	Jennifer	Delgado		\N	6	5	\N	\N
822	Jonathan	Hernandez		\N	6	3	\N	\N
823	Angel	Vasquez		\N	6	3	\N	\N
824	Eric	Arias		\N	12	1	\N	\N
825	Thuy	Burshtein		\N	12	6	\N	\N
826	Miles	Moore		\N	12	1	\N	\N
827	Rebecca	Raschulewski		\N	12	4	\N	\N
828	Foster	Smith		\N	12	3	\N	\N
829	Estrella	Garcia		\N	14	5	\N	\N
830	Nathanial	Munk		\N	14	1	\N	\N
831	Iris	Ruiz		\N	14	5	\N	\N
832	Anthony	Aguilar		\N	18	1	\N	\N
833	Javier	Alcala		\N	18	3	\N	\N
834	Corina	Alcantar		\N	18	6	\N	\N
835	Cristina	Alcantar		\N	18	6	\N	\N
836	Jesus	Alfaro		\N	18	3	\N	\N
837	Andrew	Alonzo		\N	18	2	\N	\N
838	Adrian	Altamirano		\N	18	2	\N	\N
839	Herklin	Amaro		\N	18	3	\N	\N
840	Ricardo	Avalos		\N	18	3	\N	\N
841	Diego	Barajas		\N	18	3	\N	\N
842	Mitchell	Cabanas		\N	18	3	\N	\N
843	Luis	Canseco		\N	18	2	\N	\N
844	Ulises	Carbajal		\N	18	2	\N	\N
845	Nestor	Cardenas		\N	18	2	\N	\N
846	Miguel	Cardenaz		\N	18	3	\N	\N
847	Christopher	Castro		\N	18	1	\N	\N
848	Yamilet	Castro		\N	18	4	\N	\N
849	Monse	Cortez		\N	18	4	\N	\N
850	Yaqueline	Cruz		\N	18	6	\N	\N
851	Joanna	Cuevas		\N	18	6	\N	\N
852	Dulce	Del Aguilar		\N	18	4	\N	\N
853	Josue	Del Real		\N	18	3	\N	\N
854	Jesus	Delgadillo		\N	18	1	\N	\N
855	Maria	Diaz		\N	18	6	\N	\N
856	Isaac	Duenas		\N	18	2	\N	\N
857	Maria	Espinoza		\N	18	5	\N	\N
858	Yesenia	Espinoza		\N	18	5	\N	\N
859	Manuel	Figueroa		\N	18	3	\N	\N
860	Alexis	Garcia		\N	18	6	\N	\N
861	Desteney	Garcia		\N	18	6	\N	\N
862	Diana C	Garcia		\N	18	6	\N	\N
863	Mario	Garcia		\N	18	1	\N	\N
864	Viviana	Gonzalez		\N	18	5	\N	\N
865	Florencia	Gregorio		\N	18	6	\N	\N
866	Noralys	Hernandez		\N	18	5	\N	\N
867	Laura	Huitron		\N	18	4	\N	\N
868	Jesus	Iturbe		\N	18	3	\N	\N
869	Flavio	Jaramillo		\N	18	3	\N	\N
870	Maximos	Lopez		\N	18	1	\N	\N
871	Javion	Macias		\N	18	3	\N	\N
872	Francisco	Maciel		\N	18	3	\N	\N
873	Ilai	Maciel		\N	18	5	\N	\N
874	Peter	Maciel		\N	18	2	\N	\N
875	Kelly	Magana		\N	18	6	\N	\N
876	Jonathan	Martinez		\N	18	3	\N	\N
877	Luis	Martinez		\N	18	1	\N	\N
878	Carlos	Mendoza		\N	18	3	\N	\N
879	Joseph Jay	Montesclaros		\N	18	3	\N	\N
880	Emmanuel	Nieto		\N	18	3	\N	\N
881	Ariana	Ochoa		\N	18	5	\N	\N
882	Chris	Oseguera		\N	18	3	\N	\N
883	Joel	Ramirez		\N	18	2	\N	\N
884	Diego	Raya		\N	18	2	\N	\N
885	Antonio	Reyes		\N	18	3	\N	\N
886	Oscar	Rodriguez		\N	18	1	\N	\N
887	Ruben	Santana		\N	18	1	\N	\N
888	Moziah	Stewart		\N	18	3	\N	\N
889	Yaritza	Tinoco		\N	18	5	\N	\N
890	Rex	Tomimbang		\N	18	3	\N	\N
891	Kimberly	Torres		\N	18	6	\N	\N
892	Pablo	Trujillo		\N	18	1	\N	\N
893	Ruben	Vega		\N	18	2	\N	\N
894	Nathaniel	Velasquez		\N	18	1	\N	\N
895	Xochilth	Aguila		\N	19	4	\N	\N
896	Alan	Calderon		\N	19	3	\N	\N
897	Emiliano	Calvario		\N	19	2	\N	\N
898	Ivan	Carillo		\N	19	2	\N	\N
899	Alexis	Carlos-Soto		\N	19	2	\N	\N
900	Cristian	Cisneros		\N	19	2	\N	\N
901	Jacqueline	Gallardo		\N	19	5	\N	\N
902	Giselle	Garcia		\N	19	5	\N	\N
903	Nolvin	Guerra		\N	19	3	\N	\N
904	Anahí	Gurrola		\N	19	6	\N	\N
905	Clarissa	Guzman		\N	19	6	\N	\N
906	Diego	Hernandez		\N	19	3	\N	\N
907	Erick	Hernandez		\N	19	3	\N	\N
908	Mikayla	Kalem		\N	19	6	\N	\N
909	Karina	Maldonado		\N	19	5	\N	\N
910	Cristopher	Mansilla		\N	19	2	\N	\N
911	Joshua	Mendez		\N	19	3	\N	\N
912	Jose	Munoz		\N	19	3	\N	\N
913	Alexis	Nunez		\N	19	3	\N	\N
914	Carlos Anye	Nunez		\N	19	2	\N	\N
915	Margaret	Pazos		\N	19	6	\N	\N
916	Brene	Pita		\N	19	6	\N	\N
917	Juan	Plata		\N	19	2	\N	\N
918	Desiree	Rawls		\N	19	6	\N	\N
919	Keily	Romero		\N	19	5	\N	\N
920	Veronika	Romero		\N	19	6	\N	\N
921	Luis	Rosas		\N	19	2	\N	\N
922	Shanya	Singh		\N	19	5	\N	\N
923	Mina	Tameilau		\N	19	5	\N	\N
924	Max	Velazquez		\N	19	3	\N	\N
925	Tayjah	Johnson		\N	2	6	\N	\N
926	Ana	Rosas		\N	2	5	\N	\N
927	Randell	Yasay		\N	2	2	\N	\N
928	Rodrigo	Frias		\N	7	3	\N	\N
929	Luis	Meza		\N	7	3	\N	\N
930	Irvin	Vergara		\N	8	1	\N	\N
931	Francisco	Alejo		\N	20	2	\N	\N
932	Diego	Angeles		\N	20	2	\N	\N
933	Karina	Campos		\N	20	6	\N	\N
934	Juan	Centeno		\N	20	2	\N	\N
935	Grecia	Rodriguez		\N	20	6	\N	\N
936	Eduardo	Tletlepantzi		\N	20	3	\N	\N
937	Azjani	McGill		\N	21	1	\N	\N
938	Trinity	Mobley		\N	21	4	\N	\N
939	Itsel	Oseguera Reyes		\N	21	5	\N	\N
940	Fiaaulagi	Tautolo		\N	21	6	\N	\N
941	Carlos	Alfaro		\N	22	1	\N	\N
942	Ricardo	Alfaro		\N	22	3	\N	\N
943	Nayla	Anastacio		\N	22	5	\N	\N
944	Nicole	Anastacio		\N	22	6	\N	\N
945	Jesus	Avalos		\N	22	3	\N	\N
946	Brianna	Baughman		\N	22	6	\N	\N
947	Brenda	Bermudez		\N	22	6	\N	\N
948	Joseph	Bertao		\N	22	2	\N	\N
949	Fernando	Bugarin		\N	22	3	\N	\N
950	Brian	Cabanillas		\N	22	1	\N	\N
951	Eric	Castillo		\N	22	1	\N	\N
952	Alondra	Cazarez		\N	22	6	\N	\N
953	Jocelyn	Cazarez		\N	22	6	\N	\N
954	Joe	Chavez		\N	22	2	\N	\N
955	Andy	Chhoun		\N	22	3	\N	\N
956	Luis	Contridas		\N	22	3	\N	\N
957	Ruben	Cornejo		\N	22	1	\N	\N
958	Ashley	Corona		\N	22	5	\N	\N
959	Sarah	Delgado		\N	22	6	\N	\N
960	Brandon	Ducusin		\N	22	1	\N	\N
961	Shakira	Figueroa		\N	22	5	\N	\N
962	Alex	Flores		\N	22	2	\N	\N
963	Alexandra	Garcia		\N	22	6	\N	\N
964	Gabriel	Garcia		\N	22	1	\N	\N
965	Jiovanni	Garcia		\N	22	2	\N	\N
966	Guy	Gida		\N	22	3	\N	\N
967	Grayson	Griffin		\N	22	6	\N	\N
968	Abril	Guzman		\N	22	6	\N	\N
969	Odalys	Guzman		\N	22	6	\N	\N
970	Cuauhtemoc	Hernandez		\N	22	3	\N	\N
971	Elisa	Ibarra		\N	22	6	\N	\N
972	Hugo	Jimenez		\N	22	3	\N	\N
973	Justin	Landacre		\N	22	2	\N	\N
974	Esteban	Lemus		\N	22	2	\N	\N
975	Javier	Lemus		\N	22	3	\N	\N
976	Samuel	Madrigal		\N	22	1	\N	\N
977	Jacqueline	Magallon		\N	22	5	\N	\N
978	Edgar	Medina		\N	22	3	\N	\N
979	Salvador	Melo		\N	22	3	\N	\N
980	Faith	Mora		\N	22	5	\N	\N
981	Christian	Moreno		\N	22	2	\N	\N
982	Daniela	Munoz		\N	22	5	\N	\N
983	Fabrisio	Naranjo		\N	22	1	\N	\N
984	Shally	Navarro		\N	22	5	\N	\N
985	Ryan	Orlando		\N	22	3	\N	\N
986	Nayeli	Ortiz		\N	22	5	\N	\N
987	Reyna	Ortiz		\N	22	6	\N	\N
988	Gerardo	Perez		\N	22	3	\N	\N
989	Cameron	Reyes		\N	22	3	\N	\N
990	Eduardo	Rios		\N	22	2	\N	\N
991	Ricardo	Rios		\N	22	2	\N	\N
992	Yesenia	Rivera		\N	22	6	\N	\N
993	Linda	Rocha		\N	22	6	\N	\N
994	Abel	Ruiz		\N	22	2	\N	\N
995	Cindy	Rule		\N	22	5	\N	\N
996	Mayra	Salas		\N	22	5	\N	\N
997	Agustin	Saldivar		\N	22	2	\N	\N
998	Lupe	Sanchez		\N	22	2	\N	\N
999	Rafael	Tapia		\N	22	2	\N	\N
1000	Anthony	Valdivia		\N	22	2	\N	\N
1001	Stephanie	Valdivia		\N	22	5	\N	\N
1002	Konan	Van Lear		\N	22	2	\N	\N
1003	Ricardo	Vasquez		\N	22	1	\N	\N
1004	Itzel	Venegas		\N	22	5	\N	\N
1005	Constantino	Villegas		\N	22	2	\N	\N
1006	Bryan	Zamudio		\N	22	3	\N	\N
1007	Rodrick	Alberto		\N	23	3	\N	\N
1008	Nina	Arias		\N	23	6	\N	\N
1009	Benhur	Aromin		\N	23	3	\N	\N
1010	Cristo	Ayo		\N	23	3	\N	\N
1011	Alyssa	Ceja Pena		\N	23	6	\N	\N
1012	Victor	Ceja-Pena		\N	23	1	\N	\N
1013	Jesus	Diaz		\N	23	3	\N	\N
1014	Harry	Do		\N	23	3	\N	\N
1015	Cristopher	Escalante		\N	23	2	\N	\N
1016	Brittany	Fickas		\N	23	6	\N	\N
1017	Alex	Galvan		\N	23	2	\N	\N
1018	Isaiah	Guerra		\N	23	3	\N	\N
1019	Brandon	Gutierrez		\N	23	3	\N	\N
1020	Timothy	Hunter		\N	23	3	\N	\N
1021	Jimenez	Jesus		\N	23	2	\N	\N
1022	Christian	Lonero		\N	23	1	\N	\N
1023	Leslie	Medina		\N	23	6	\N	\N
1024	Makaelah	Napolitano		\N	23	5	\N	\N
1025	Johnny	Olivares		\N	23	2	\N	\N
1026	Elizabeth	Padilla		\N	23	5	\N	\N
1027	Justin	Robante		\N	23	3	\N	\N
1028	Julia	Ruiz		\N	23	6	\N	\N
1029	Christoper	Sibal		\N	23	3	\N	\N
1030	Daniel	Simo		\N	23	3	\N	\N
1031	Jake	Sotelo		\N	23	1	\N	\N
1032	Hiroki	Terada		\N	23	2	\N	\N
1033	Dennise	Torres-Alfaro		\N	23	6	\N	\N
1034	Lucas	Urquidez		\N	23	2	\N	\N
1035	Anesa	Vanderlipe		\N	23	6	\N	\N
1036	Samantha	Vargas		\N	23	6	\N	\N
1037	Andrea	Villalbos		\N	23	5	\N	\N
1038	Elijah	Washington		\N	23	2	\N	\N
1039	Daniel	Wason		\N	23	3	\N	\N
1040	Kelly	Kinon		\N	24	4	\N	\N
1041	Sophia	Lazzerini		\N	24	6	\N	\N
1042	Lauryn	Nimis		\N	24	6	\N	\N
1043	Grace	O'Connor		\N	24	4	\N	\N
1044	Jessie	Pavek		\N	24	5	\N	\N
1045	Chloe	Plumley		\N	24	6	\N	\N
1046	Mariah	Schlaper		\N	24	4	\N	\N
1047	Keona	Stopper		\N	24	6	\N	\N
1048	Christine	Wooler		\N	24	6	\N	\N
1049	Katie	Zernicke		\N	24	6	\N	\N
1050	Christian	Aguilar		\N	25	3	\N	\N
1051	Marco	Fragoso		\N	25	2	\N	\N
1052	Sam	Hernadez		\N	25	3	\N	\N
1053	Jordan	Jimanez		\N	25	3	\N	\N
1054	Cristo	Lopez		\N	25	1	\N	\N
1055	David	Madrigal		\N	25	2	\N	\N
1056	Bernie	Mora		\N	25	1	\N	\N
1057	Sofia	Nolasco		\N	25	5	\N	\N
1058	Amely	Zamora		\N	25	6	\N	\N
1059	Isaac	Zamora		\N	25	2	\N	\N
1060	Monica	Zepeda		\N	25	5	\N	\N
1061	Ben	Eastman		\N	26	1	\N	\N
1062	Brent	Eastman		\N	26	1	\N	\N
1063	Zach	Flores		\N	26	3	\N	\N
1064	Christian	Galardo		\N	26	3	\N	\N
1065	Pedro	Gomez		\N	26	3	\N	\N
1066	Kyle	Haas		\N	26	3	\N	\N
1067	Erin	Limbo		\N	26	2	\N	\N
1068	Miguel	Lizaola		\N	26	2	\N	\N
1069	Daudi	London		\N	26	3	\N	\N
1070	Emilio	Martinez		\N	26	3	\N	\N
1071	Christian	Neisonger		\N	26	3	\N	\N
1072	Micah	Olivas		\N	26	1	\N	\N
1073	Thomas	Padilla		\N	26	2	\N	\N
1074	Arturo	Ponce		\N	26	3	\N	\N
1075	Andrew	Rivera		\N	26	2	\N	\N
1076	Sam	Robinson		\N	26	3	\N	\N
1077	Octavio	Rubio		\N	26	3	\N	\N
1078	Oscar	Rubio		\N	26	2	\N	\N
1079	Caspar	Silvania		\N	26	2	\N	\N
1080	Phil	Sites		\N	26	1	\N	\N
1081	Zack	Taylor		\N	26	3	\N	\N
1082	Anthony	Villegas		\N	26	1	\N	\N
1083	Beau	Winslow		\N	26	3	\N	\N
1084	Veronica	Aguilar		\N	27	6	\N	\N
1085	Sergio	Arreola		\N	27	3	\N	\N
1086	Lilly	Baez		\N	27	6	\N	\N
1087	Thomas	Balian		\N	27	3	\N	\N
1088	Ricardo	Beltran		\N	27	2	\N	\N
1089	Isaiah	Brown		\N	27	3	\N	\N
1090	Cole	Burk		\N	27	2	\N	\N
1091	Tully	Cannon		\N	27	1	\N	\N
1092	Christina	Chagnon		\N	27	5	\N	\N
1093	Jonathan	Chagnon		\N	27	3	\N	\N
1094	Kimi	Chin		\N	27	6	\N	\N
1095	Kayla	Clayton		\N	27	6	\N	\N
1096	Wyatt	Conner		\N	27	3	\N	\N
1097	Elle	Froistad		\N	27	6	\N	\N
1098	Isaaic	Gallegos		\N	27	3	\N	\N
1099	Nicole	Gorczyca		\N	27	5	\N	\N
1100	Haley	Hibbs		\N	27	5	\N	\N
1101	Taylor	Hibino		\N	27	4	\N	\N
1102	Brisia	Martinez		\N	27	5	\N	\N
1103	Alfredo	Mejia		\N	27	3	\N	\N
1104	Fermin	Moreno		\N	27	1	\N	\N
1105	Dante	Morr		\N	27	6	\N	\N
1106	Brandon	Partido		\N	27	3	\N	\N
1107	Jonathan	Partido		\N	27	3	\N	\N
1108	Brett	Reade		\N	27	3	\N	\N
1109	Carlos	Reyes		\N	27	3	\N	\N
1110	Carl	Richardson		\N	27	1	\N	\N
1111	Andres	Rodriguez		\N	27	3	\N	\N
1112	Nicole	Stearns		\N	27	6	\N	\N
1113	Andy	Tavares		\N	27	1	\N	\N
1114	Peter	Tavares		\N	27	3	\N	\N
1115	Matthew	Vasher		\N	27	3	\N	\N
1116	Charlie	Jung		\N	28	3	\N	\N
1117	Jeremy	Miller		\N	28	3	\N	\N
1118	Anna	Mokkapati		\N	28	4	\N	\N
1119	Ryan	Negrette		\N	28	3	\N	\N
1120	Ursula	Ott		\N	28	6	\N	\N
1121	Pedro	Alcantara		\N	29	3	\N	\N
1122	Braydon	Arnold		\N	29	3	\N	\N
1123	Daniela	Castro		\N	29	6	\N	\N
1124	Jesse	Mandujano		\N	29	2	\N	\N
1125	Xavier	Marinez		\N	29	2	\N	\N
1126	Raul	Martinez		\N	29	3	\N	\N
1127	Carlos	Santiago		\N	29	2	\N	\N
1128	Pablo	Valle		\N	29	1	\N	\N
1129	Zach	Ahern		\N	5	2	\N	\N
1130	Angelyna	Ragsdale		\N	8	5	\N	\N
1131	Carson	Coppinger		\N	5	3	\N	\N
1132	Jasmin	Schulz		\N	17	4	\N	\N
1133	Ashley	Bruning		\N	10	4	\N	\N
1134	Jordan	Matthew		\N	10	2	\N	\N
1135	Taegan	Dunton		\N	11	1	\N	\N
1136	Lauren	Hubbell		\N	11	5	\N	\N
1137	Sahil	Patel		\N	11	1	\N	\N
1138	Tai	White		\N	11	3	\N	\N
1139	Matthew	Lo		\N	12	2	\N	\N
1140	Joseph	Cohen		\N	15	3	\N	\N
1141	Belle	Kreitler		\N	15	5	\N	\N
1142	Francesco	Carriglio		\N	16	1	\N	\N
1143	Stuart	Carruthers		\N	16	1	\N	\N
1144	Natalie	Sanford		\N	16	5	\N	\N
1145	Henry	Xiang		\N	16	2	\N	\N
1146	Kathryn	Yeager		\N	16	5	\N	\N
1147	Taylor	Colello		\N	30	5	\N	\N
1148	Zach	Davidson		\N	30	3	\N	\N
1149	Carla	McEwen		\N	4	5	\N	\N
1150	Jahziel	Alfaro		\N	31	1	\N	\N
1151	Hugo	Ayala		\N	31	3	\N	\N
1152	Guadalupe	Contreras		\N	31	5	\N	\N
1153	Noely	Contreras		\N	31	5	\N	\N
1154	Marlen	De La Cruz		\N	31	4	\N	\N
1155	Jessica	De Reza		\N	31	4	\N	\N
1156	Charley	Garcia		\N	31	2	\N	\N
1157	Daniela	Garcia		\N	31	6	\N	\N
1158	Vanessa	Garcia		\N	31	5	\N	\N
1159	Miguel	Gutierrez		\N	31	3	\N	\N
1160	Tais	Hernandez		\N	31	5	\N	\N
1161	Axel	Martinez		\N	31	2	\N	\N
1162	Liliana	Mireles		\N	31	4	\N	\N
1163	Christian	Napoles		\N	31	3	\N	\N
1164	Daniel	Rivera		\N	31	3	\N	\N
1165	Lucy	Robles		\N	31	6	\N	\N
1166	Tyler	Smithtro		\N	12	1	\N	\N
1167	Symone	Crawley		\N	32	6	\N	\N
1168	Edward	De Guzman		\N	32	3	\N	\N
1169	Kamoana	De Guzman		\N	32	1	\N	\N
1170	Ethan	Fry		\N	32	1	\N	\N
1171	Makenzie	Giovannoni		\N	32	6	\N	\N
1172	Eliesse	Kwok		\N	32	6	\N	\N
1173	Joshua	Montenegro		\N	32	1	\N	\N
1174	Catherine	Slevin		\N	32	6	\N	\N
1175	Rebecca	Slevin		\N	32	6	\N	\N
1176	Kaleb	Windsor		\N	32	3	\N	\N
1177	Valeria	Cortina		\N	13	4	\N	\N
1178	Alicia	Rector		\N	13	5	\N	\N
1179	Eric	Wright		\N	30	3	\N	\N
1180	Leo	Ruiz		\N	6	3	\N	\N
\.


--
-- Name: athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.athletes_id_seq', 1180, true);


--
-- Data for Name: div_orderings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.div_orderings (id, meet_id, div_id, seq_num) FROM stdin;
1	1	4	1
2	1	5	2
3	1	6	3
4	1	1	4
5	1	2	5
6	1	3	6
7	2	4	1
8	2	5	2
9	2	6	3
10	2	1	4
11	2	2	5
12	2	3	6
13	3	1	1
14	3	2	2
15	3	3	3
16	3	4	4
17	3	5	5
18	3	6	6
19	4	6	1
20	4	5	2
21	4	4	3
22	4	3	4
23	4	2	5
24	4	1	6
25	5	3	1
26	5	2	2
27	5	1	3
28	5	6	4
29	5	5	5
30	5	4	6
31	6	4	1
32	6	5	2
33	6	6	3
34	6	1	4
35	6	2	5
36	6	3	6
37	7	4	1
38	7	5	2
39	7	6	3
40	7	1	4
41	7	2	5
42	7	3	6
43	8	4	1
44	8	5	2
45	8	6	3
46	8	1	4
47	8	2	5
48	8	3	6
49	9	4	1
50	9	5	2
51	9	6	3
52	9	1	4
53	9	2	5
54	9	3	6
55	10	4	1
56	10	5	2
57	10	6	3
58	10	1	4
59	10	2	5
60	10	3	6
61	11	4	1
62	11	5	2
63	11	6	3
64	11	1	4
65	11	2	5
66	11	3	6
67	12	8	1
68	12	7	2
\.


--
-- Name: div_orderings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.div_orderings_id_seq', 68, true);


--
-- Data for Name: divisions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.divisions (id, gender, grade, code, name) FROM stdin;
1	M	6	6M	Grade 6 Boys
2	M	7	7M	Grade 7 Boys
3	M	8	8M	Grade 8 Boys
4	F	6	6F	Grade 6 Girls
5	F	7	7F	Grade 7 Girls
6	F	8	8F	Grade 8 Girls
7	M	\N	M	Boys
8	F	\N	F	Girls
\.


--
-- Name: divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.divisions_id_seq', 8, true);


--
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.entries (id, athlete_id, mde_id, heat_id, seed_num, mark, mark_type, problem) FROM stdin;
55	271	57	\N	\N	30.00	seconds	\N
1	68	38	\N	\N	13.47	seconds	\N
2	101	39	\N	\N	13.74	seconds	\N
89	159	55	\N	\N	99999999.00	seconds	\N
3	98	39	\N	\N	13.90	seconds	\N
56	233	57	\N	\N	30.66	seconds	\N
4	271	39	\N	\N	14.00	seconds	\N
5	294	39	\N	\N	14.00	seconds	\N
6	110	38	\N	\N	14.00	seconds	\N
57	294	57	\N	\N	31.00	seconds	\N
7	178	39	\N	\N	14.20	seconds	\N
8	151	39	\N	\N	14.50	seconds	\N
90	256	56	\N	\N	99999999.00	seconds	\N
9	125	39	\N	\N	14.50	seconds	\N
58	180	57	\N	\N	31.12	seconds	\N
10	233	39	\N	\N	14.50	seconds	\N
11	15	39	\N	\N	14.58	seconds	\N
12	253	39	\N	\N	15.10	seconds	\N
59	253	57	\N	\N	31.40	seconds	\N
13	138	39	\N	\N	15.50	seconds	\N
14	14	38	\N	\N	15.65	seconds	\N
117	9	8	\N	\N	385.03	seconds	\N
15	31	39	\N	\N	16.07	seconds	\N
60	138	57	\N	\N	32.00	seconds	\N
16	305	39	\N	\N	16.20	seconds	\N
17	81	38	\N	\N	16.38	seconds	\N
91	252	32	\N	\N	63.86	seconds	\N
18	226	39	\N	\N	16.60	seconds	\N
19	180	39	\N	\N	99999999.00	seconds	\N
20	29	39	\N	\N	99999999.00	seconds	\N
21	272	39	\N	\N	99999999.00	seconds	\N
61	119	57	\N	\N	32.00	seconds	\N
22	122	38	\N	\N	14.20	seconds	\N
23	215	37	\N	\N	14.20	seconds	\N
24	103	38	\N	\N	14.50	seconds	\N
62	31	57	\N	\N	34.35	seconds	\N
25	164	38	\N	\N	14.50	seconds	\N
26	297	38	\N	\N	15.00	seconds	\N
107	143	44	\N	\N	197.81	seconds	\N
27	168	38	\N	\N	15.10	seconds	\N
63	305	57	\N	\N	35.53	seconds	\N
28	247	37	\N	\N	15.10	seconds	\N
29	301	38	\N	\N	15.20	seconds	\N
64	57	56	\N	\N	99999999.00	seconds	\N
30	84	38	\N	\N	15.24	seconds	\N
31	117	38	\N	\N	15.30	seconds	\N
65	29	57	\N	\N	99999999.00	seconds	\N
32	282	38	\N	\N	15.40	seconds	\N
33	199	38	\N	\N	15.50	seconds	\N
66	178	57	\N	\N	99999999.00	seconds	\N
34	111	38	\N	\N	15.60	seconds	\N
35	149	38	\N	\N	16.30	seconds	\N
67	272	57	\N	\N	99999999.00	seconds	\N
36	74	37	\N	\N	16.44	seconds	\N
37	171	38	\N	\N	16.60	seconds	\N
92	126	32	\N	\N	64.00	seconds	\N
38	191	38	\N	\N	16.70	seconds	\N
39	97	38	\N	\N	99999999.00	seconds	\N
40	145	38	\N	\N	99999999.00	seconds	\N
41	146	37	\N	\N	99999999.00	seconds	\N
42	204	38	\N	\N	99999999.00	seconds	\N
43	237	37	\N	\N	99999999.00	seconds	\N
44	248	37	\N	\N	99999999.00	seconds	\N
45	296	38	\N	\N	99999999.00	seconds	\N
46	304	37	\N	\N	99999999.00	seconds	\N
47	239	38	\N	\N	99999999.00	seconds	\N
48	159	37	\N	\N	99999999.00	seconds	\N
49	256	38	\N	\N	99999999.00	seconds	\N
68	122	56	\N	\N	30.00	seconds	\N
50	66	57	\N	\N	27.74	seconds	\N
51	101	57	\N	\N	28.74	seconds	\N
52	110	56	\N	\N	29.00	seconds	\N
69	103	56	\N	\N	31.00	seconds	\N
53	125	57	\N	\N	29.19	seconds	\N
54	214	57	\N	\N	29.40	seconds	\N
93	214	33	\N	\N	65.00	seconds	\N
70	164	56	\N	\N	31.00	seconds	\N
71	215	55	\N	\N	31.00	seconds	\N
108	127	43	\N	\N	99999999.00	seconds	\N
72	297	56	\N	\N	31.40	seconds	\N
94	57	32	\N	\N	65.08	seconds	\N
73	168	56	\N	\N	31.60	seconds	\N
74	247	55	\N	\N	31.66	seconds	\N
75	84	56	\N	\N	32.70	seconds	\N
95	119	33	\N	\N	70.00	seconds	\N
76	301	56	\N	\N	33.20	seconds	\N
77	117	56	\N	\N	33.40	seconds	\N
109	192	43	\N	\N	99999999.00	seconds	\N
78	199	56	\N	\N	33.50	seconds	\N
96	252	44	\N	\N	156.70	seconds	\N
79	171	56	\N	\N	35.64	seconds	\N
80	191	56	\N	\N	99999999.00	seconds	\N
81	74	55	\N	\N	99999999.00	seconds	\N
82	97	56	\N	\N	99999999.00	seconds	\N
83	145	56	\N	\N	99999999.00	seconds	\N
84	146	55	\N	\N	99999999.00	seconds	\N
85	248	55	\N	\N	99999999.00	seconds	\N
86	282	56	\N	\N	99999999.00	seconds	\N
87	296	56	\N	\N	99999999.00	seconds	\N
88	304	55	\N	\N	99999999.00	seconds	\N
97	236	45	\N	\N	157.00	seconds	\N
110	303	43	\N	\N	99999999.00	seconds	\N
98	175	45	\N	\N	157.70	seconds	\N
99	7	45	\N	\N	167.18	seconds	\N
100	53	44	\N	\N	181.31	seconds	\N
101	41	45	\N	\N	99999999.00	seconds	\N
102	34	44	\N	\N	99999999.00	seconds	\N
103	126	44	\N	\N	99999999.00	seconds	\N
111	175	9	\N	\N	340.28	seconds	\N
104	133	43	\N	\N	178.44	seconds	\N
105	56	44	\N	\N	187.79	seconds	\N
106	299	43	\N	\N	194.45	seconds	\N
112	195	9	\N	\N	352.09	seconds	\N
118	17	7	\N	\N	386.27	seconds	\N
113	236	9	\N	\N	354.52	seconds	\N
114	124	9	\N	\N	359.98	seconds	\N
124	58	9	\N	\N	99999999.00	seconds	\N
115	113	8	\N	\N	370.55	seconds	\N
119	53	8	\N	\N	399.87	seconds	\N
116	7	9	\N	\N	370.80	seconds	\N
127	192	7	\N	\N	416.74	seconds	\N
120	44	7	\N	\N	408.19	seconds	\N
125	133	7	\N	\N	408.38	seconds	\N
121	24	8	\N	\N	455.42	seconds	\N
122	41	9	\N	\N	99999999.00	seconds	\N
123	34	8	\N	\N	99999999.00	seconds	\N
126	56	8	\N	\N	413.51	seconds	\N
129	264	7	\N	\N	432.88	seconds	\N
128	60	8	\N	\N	428.03	seconds	\N
130	143	8	\N	\N	435.57	seconds	\N
131	276	8	\N	\N	442.39	seconds	\N
132	3	8	\N	\N	458.93	seconds	\N
133	303	7	\N	\N	499.51	seconds	\N
134	127	7	\N	\N	503.49	seconds	\N
135	19	7	\N	\N	99999999.00	seconds	\N
136	78	7	\N	\N	99999999.00	seconds	\N
137	4	7	\N	\N	99999999.00	seconds	\N
138	299	7	\N	\N	99999999.00	seconds	\N
139	195	63	\N	\N	760.39	seconds	\N
140	124	63	\N	\N	763.21	seconds	\N
141	113	62	\N	\N	793.41	seconds	\N
142	9	62	\N	\N	797.56	seconds	\N
143	17	61	\N	\N	845.25	seconds	\N
144	44	61	\N	\N	900.90	seconds	\N
145	58	63	\N	\N	99999999.00	seconds	\N
146	60	62	\N	\N	951.90	seconds	\N
205	68	98	\N	\N	905.00	inches	\N
147	264	61	\N	\N	1089.70	seconds	\N
148	276	62	\N	\N	99999999.00	seconds	\N
149	3	62	\N	\N	99999999.00	seconds	\N
150	19	61	\N	\N	99999999.00	seconds	\N
151	78	61	\N	\N	99999999.00	seconds	\N
152	4	61	\N	\N	99999999.00	seconds	\N
153	291	15	\N	\N	18.21	seconds	\N
154	219	15	\N	\N	20.83	seconds	\N
206	14	98	\N	\N	857.00	inches	\N
155	151	15	\N	\N	20.96	seconds	\N
156	257	15	\N	\N	20.99	seconds	\N
157	20	15	\N	\N	99999999.00	seconds	\N
158	226	15	\N	\N	99999999.00	seconds	\N
159	269	15	\N	\N	99999999.00	seconds	\N
160	241	14	\N	\N	18.87	seconds	\N
161	274	14	\N	\N	99999999.00	seconds	\N
162	111	14	\N	\N	99999999.00	seconds	\N
207	290	99	\N	\N	801.00	inches	\N
163	242	51	\N	\N	53.44	seconds	\N
164	219	51	\N	\N	58.04	seconds	\N
237	220	73	\N	\N	54.00	inches	\N
165	257	51	\N	\N	58.04	seconds	\N
208	258	99	\N	\N	695.00	inches	\N
166	151	51	\N	\N	58.74	seconds	\N
167	226	51	\N	\N	66.64	seconds	\N
168	174	51	\N	\N	99999999.00	seconds	\N
169	269	51	\N	\N	99999999.00	seconds	\N
170	241	50	\N	\N	56.44	seconds	\N
171	274	50	\N	\N	99999999.00	seconds	\N
172	111	50	\N	\N	99999999.00	seconds	\N
173	204	50	\N	\N	99999999.00	seconds	\N
209	200	99	\N	\N	693.00	inches	\N
174	290	105	\N	\N	321.00	inches	\N
175	68	104	\N	\N	313.00	inches	\N
238	149	74	\N	\N	0.00	inches	\N
176	200	105	\N	\N	309.00	inches	\N
210	21	98	\N	\N	679.00	inches	\N
177	14	104	\N	\N	279.00	inches	\N
178	21	104	\N	\N	259.50	inches	\N
179	197	105	\N	\N	245.00	inches	\N
211	206	99	\N	\N	637.00	inches	\N
180	224	105	\N	\N	225.50	inches	\N
181	155	105	\N	\N	225.00	inches	\N
239	239	74	\N	\N	0.00	inches	\N
182	206	105	\N	\N	219.00	inches	\N
212	106	99	\N	\N	631.00	inches	\N
183	258	105	\N	\N	217.50	inches	\N
184	106	105	\N	\N	211.00	inches	\N
185	30	105	\N	\N	0.00	inches	\N
186	147	105	\N	\N	0.00	inches	\N
187	250	105	\N	\N	0.00	inches	\N
188	163	105	\N	\N	0.00	inches	\N
189	85	105	\N	\N	0.00	inches	\N
190	237	103	\N	\N	283.00	inches	\N
213	155	99	\N	\N	625.00	inches	\N
191	225	104	\N	\N	252.00	inches	\N
192	100	104	\N	\N	250.50	inches	\N
256	233	87	\N	\N	0.00	inches	\N
193	277	103	\N	\N	212.00	inches	\N
214	197	99	\N	\N	560.00	inches	\N
194	181	104	\N	\N	195.00	inches	\N
195	212	103	\N	\N	192.00	inches	\N
240	180	81	\N	\N	102.00	inches	\N
196	292	103	\N	\N	165.50	inches	\N
197	223	104	\N	\N	0.00	inches	\N
198	165	104	\N	\N	0.00	inches	\N
199	179	103	\N	\N	0.00	inches	\N
200	186	103	\N	\N	0.00	inches	\N
201	203	104	\N	\N	0.00	inches	\N
202	293	104	\N	\N	0.00	inches	\N
203	246	104	\N	\N	0.00	inches	\N
215	224	99	\N	\N	478.00	inches	\N
204	250	99	\N	\N	968.00	inches	\N
216	30	99	\N	\N	0.00	inches	\N
217	147	99	\N	\N	0.00	inches	\N
218	163	99	\N	\N	0.00	inches	\N
219	85	99	\N	\N	0.00	inches	\N
220	225	98	\N	\N	784.00	inches	\N
241	45	81	\N	\N	78.00	inches	\N
221	237	97	\N	\N	688.00	inches	\N
222	181	98	\N	\N	584.00	inches	\N
257	283	87	\N	\N	0.00	inches	\N
223	100	98	\N	\N	553.00	inches	\N
242	81	80	\N	\N	72.00	inches	\N
224	277	97	\N	\N	546.00	inches	\N
225	212	97	\N	\N	530.00	inches	\N
226	292	97	\N	\N	477.00	inches	\N
227	223	98	\N	\N	0.00	inches	\N
228	165	98	\N	\N	0.00	inches	\N
229	179	97	\N	\N	0.00	inches	\N
230	186	97	\N	\N	0.00	inches	\N
231	203	98	\N	\N	0.00	inches	\N
232	293	98	\N	\N	0.00	inches	\N
233	246	98	\N	\N	0.00	inches	\N
243	174	81	\N	\N	72.00	inches	\N
234	137	75	\N	\N	62.00	inches	\N
235	98	75	\N	\N	56.00	inches	\N
236	29	75	\N	\N	0.00	inches	\N
244	182	81	\N	\N	72.00	inches	\N
245	289	81	\N	\N	0.00	inches	\N
246	219	81	\N	\N	0.00	inches	\N
247	226	81	\N	\N	0.00	inches	\N
248	282	80	\N	\N	0.00	inches	\N
258	220	85	\N	\N	154.00	inches	\N
249	98	87	\N	\N	179.00	inches	\N
250	137	87	\N	\N	177.00	inches	\N
251	24	86	\N	\N	132.50	inches	\N
252	66	87	\N	\N	0.00	inches	\N
253	105	87	\N	\N	0.00	inches	\N
254	120	87	\N	\N	0.00	inches	\N
255	93	87	\N	\N	0.00	inches	\N
259	241	86	\N	\N	152.00	inches	\N
266	137	93	\N	\N	399.00	inches	\N
260	216	85	\N	\N	139.00	inches	\N
261	185	85	\N	\N	98.00	inches	\N
262	146	85	\N	\N	0.00	inches	\N
263	149	86	\N	\N	0.00	inches	\N
264	239	86	\N	\N	0.00	inches	\N
267	105	93	\N	\N	0.00	inches	\N
265	98	93	\N	\N	402.50	inches	\N
268	120	93	\N	\N	0.00	inches	\N
269	283	93	\N	\N	0.00	inches	\N
271	220	91	\N	\N	293.50	inches	\N
270	241	92	\N	\N	304.00	inches	\N
274	185	91	\N	\N	0.00	inches	\N
272	216	91	\N	\N	273.50	inches	\N
273	93	93	\N	\N	0.00	inches	\N
275	99	42	\N	\N	11.33	seconds	\N
276	108	41	\N	\N	11.80	seconds	\N
277	148	42	\N	\N	11.90	seconds	\N
278	285	42	\N	\N	12.00	seconds	\N
279	89	42	\N	\N	12.02	seconds	\N
280	208	42	\N	\N	12.04	seconds	\N
281	190	42	\N	\N	12.18	seconds	\N
282	229	42	\N	\N	12.20	seconds	\N
283	189	42	\N	\N	12.29	seconds	\N
284	6	40	\N	\N	12.31	seconds	\N
285	65	42	\N	\N	12.33	seconds	\N
286	61	40	\N	\N	12.84	seconds	\N
287	131	42	\N	\N	13.00	seconds	\N
288	112	42	\N	\N	13.20	seconds	\N
289	26	42	\N	\N	13.46	seconds	\N
290	202	42	\N	\N	13.64	seconds	\N
291	183	42	\N	\N	13.80	seconds	\N
348	6	58	\N	\N	25.52	seconds	\N
292	234	42	\N	\N	13.80	seconds	\N
293	173	42	\N	\N	14.10	seconds	\N
294	25	42	\N	\N	99999999.00	seconds	\N
295	47	42	\N	\N	99999999.00	seconds	\N
296	79	40	\N	\N	99999999.00	seconds	\N
297	50	42	\N	\N	99999999.00	seconds	\N
298	298	42	\N	\N	99999999.00	seconds	\N
299	136	42	\N	\N	99999999.00	seconds	\N
300	83	42	\N	\N	99999999.00	seconds	\N
301	254	40	\N	\N	12.00	seconds	\N
349	89	60	\N	\N	25.58	seconds	\N
302	102	40	\N	\N	12.30	seconds	\N
303	169	40	\N	\N	12.40	seconds	\N
380	70	59	\N	\N	27.12	seconds	\N
304	209	40	\N	\N	12.40	seconds	\N
350	189	60	\N	\N	25.73	seconds	\N
305	11	41	\N	\N	12.96	seconds	\N
306	244	40	\N	\N	13.10	seconds	\N
307	150	40	\N	\N	13.20	seconds	\N
351	27	60	\N	\N	26.12	seconds	\N
308	1	41	\N	\N	13.21	seconds	\N
309	70	41	\N	\N	13.27	seconds	\N
398	75	59	\N	\N	99999999.00	seconds	\N
310	52	41	\N	\N	13.31	seconds	\N
352	5	59	\N	\N	26.22	seconds	\N
311	261	41	\N	\N	13.40	seconds	\N
312	130	40	\N	\N	13.40	seconds	\N
381	2	58	\N	\N	27.31	seconds	\N
313	134	40	\N	\N	13.40	seconds	\N
353	131	60	\N	\N	26.29	seconds	\N
314	2	40	\N	\N	13.48	seconds	\N
315	167	41	\N	\N	13.60	seconds	\N
316	213	41	\N	\N	13.60	seconds	\N
354	47	60	\N	\N	26.49	seconds	\N
317	80	41	\N	\N	13.68	seconds	\N
318	75	41	\N	\N	13.75	seconds	\N
319	38	41	\N	\N	13.91	seconds	\N
355	112	60	\N	\N	27.00	seconds	\N
320	166	41	\N	\N	14.00	seconds	\N
321	218	40	\N	\N	14.10	seconds	\N
382	11	59	\N	\N	27.52	seconds	\N
322	104	40	\N	\N	14.50	seconds	\N
356	202	60	\N	\N	27.50	seconds	\N
323	63	40	\N	\N	14.90	seconds	\N
324	71	41	\N	\N	15.46	seconds	\N
325	43	41	\N	\N	99999999.00	seconds	\N
326	69	41	\N	\N	99999999.00	seconds	\N
327	51	40	\N	\N	99999999.00	seconds	\N
328	10	40	\N	\N	99999999.00	seconds	\N
329	87	40	\N	\N	99999999.00	seconds	\N
330	109	40	\N	\N	99999999.00	seconds	\N
331	139	40	\N	\N	99999999.00	seconds	\N
332	157	40	\N	\N	99999999.00	seconds	\N
333	217	40	\N	\N	99999999.00	seconds	\N
334	230	40	\N	\N	99999999.00	seconds	\N
335	259	41	\N	\N	99999999.00	seconds	\N
336	273	40	\N	\N	99999999.00	seconds	\N
337	280	40	\N	\N	99999999.00	seconds	\N
338	187	40	\N	\N	99999999.00	seconds	\N
339	94	41	\N	\N	99999999.00	seconds	\N
340	99	60	\N	\N	23.00	seconds	\N
357	35	60	\N	\N	27.64	seconds	\N
341	108	59	\N	\N	23.50	seconds	\N
342	208	60	\N	\N	24.50	seconds	\N
399	167	59	\N	\N	99999999.00	seconds	\N
343	144	60	\N	\N	25.00	seconds	\N
358	234	60	\N	\N	28.60	seconds	\N
344	229	60	\N	\N	25.00	seconds	\N
345	285	60	\N	\N	25.00	seconds	\N
383	134	58	\N	\N	27.60	seconds	\N
346	37	60	\N	\N	25.02	seconds	\N
359	173	60	\N	\N	28.74	seconds	\N
347	148	60	\N	\N	25.40	seconds	\N
360	22	60	\N	\N	99999999.00	seconds	\N
361	23	60	\N	\N	99999999.00	seconds	\N
362	25	60	\N	\N	99999999.00	seconds	\N
363	65	60	\N	\N	99999999.00	seconds	\N
364	12	60	\N	\N	99999999.00	seconds	\N
365	39	59	\N	\N	99999999.00	seconds	\N
366	50	60	\N	\N	99999999.00	seconds	\N
367	26	60	\N	\N	99999999.00	seconds	\N
368	42	60	\N	\N	99999999.00	seconds	\N
369	183	60	\N	\N	99999999.00	seconds	\N
370	298	60	\N	\N	99999999.00	seconds	\N
371	83	60	\N	\N	99999999.00	seconds	\N
372	102	58	\N	\N	25.00	seconds	\N
373	209	58	\N	\N	25.00	seconds	\N
384	150	58	\N	\N	27.80	seconds	\N
374	211	59	\N	\N	25.00	seconds	\N
375	141	59	\N	\N	25.50	seconds	\N
400	213	59	\N	\N	99999999.00	seconds	\N
376	284	58	\N	\N	25.70	seconds	\N
385	244	58	\N	\N	27.80	seconds	\N
377	265	58	\N	\N	26.00	seconds	\N
378	52	59	\N	\N	26.78	seconds	\N
379	279	59	\N	\N	27.00	seconds	\N
386	261	59	\N	\N	28.00	seconds	\N
401	286	58	\N	\N	99999999.00	seconds	\N
387	166	59	\N	\N	28.20	seconds	\N
388	38	59	\N	\N	28.23	seconds	\N
402	109	58	\N	\N	99999999.00	seconds	\N
389	80	59	\N	\N	28.53	seconds	\N
390	130	58	\N	\N	28.70	seconds	\N
403	139	58	\N	\N	99999999.00	seconds	\N
391	230	58	\N	\N	29.74	seconds	\N
392	63	58	\N	\N	99999999.00	seconds	\N
393	43	59	\N	\N	99999999.00	seconds	\N
394	1	59	\N	\N	99999999.00	seconds	\N
395	69	59	\N	\N	99999999.00	seconds	\N
396	51	58	\N	\N	99999999.00	seconds	\N
397	10	58	\N	\N	99999999.00	seconds	\N
404	161	58	\N	\N	99999999.00	seconds	\N
405	218	58	\N	\N	99999999.00	seconds	\N
406	217	58	\N	\N	99999999.00	seconds	\N
407	259	59	\N	\N	99999999.00	seconds	\N
408	273	58	\N	\N	99999999.00	seconds	\N
409	280	58	\N	\N	99999999.00	seconds	\N
410	187	58	\N	\N	99999999.00	seconds	\N
411	144	36	\N	\N	55.00	seconds	\N
415	35	36	\N	\N	65.79	seconds	\N
412	23	36	\N	\N	55.56	seconds	\N
413	37	36	\N	\N	56.04	seconds	\N
416	22	36	\N	\N	99999999.00	seconds	\N
414	42	36	\N	\N	57.44	seconds	\N
417	12	36	\N	\N	99999999.00	seconds	\N
418	141	35	\N	\N	57.00	seconds	\N
419	211	35	\N	\N	57.00	seconds	\N
420	284	34	\N	\N	60.00	seconds	\N
421	279	35	\N	\N	99999999.00	seconds	\N
422	32	35	\N	\N	99999999.00	seconds	\N
423	265	34	\N	\N	99999999.00	seconds	\N
424	286	34	\N	\N	99999999.00	seconds	\N
425	161	34	\N	\N	99999999.00	seconds	\N
426	222	48	\N	\N	131.73	seconds	\N
427	275	47	\N	\N	131.73	seconds	\N
428	39	47	\N	\N	133.94	seconds	\N
429	201	48	\N	\N	143.34	seconds	\N
430	115	48	\N	\N	143.73	seconds	\N
431	129	48	\N	\N	144.55	seconds	\N
432	232	48	\N	\N	146.32	seconds	\N
433	13	48	\N	\N	146.90	seconds	\N
434	90	48	\N	\N	159.44	seconds	\N
435	72	48	\N	\N	99999999.00	seconds	\N
436	46	47	\N	\N	99999999.00	seconds	\N
437	48	47	\N	\N	99999999.00	seconds	\N
438	207	48	\N	\N	99999999.00	seconds	\N
439	88	48	\N	\N	99999999.00	seconds	\N
440	270	46	\N	\N	143.90	seconds	\N
441	92	48	\N	\N	99999999.00	seconds	\N
442	162	47	\N	\N	99999999.00	seconds	\N
443	245	47	\N	\N	99999999.00	seconds	\N
444	121	47	\N	\N	99999999.00	seconds	\N
445	177	47	\N	\N	99999999.00	seconds	\N
446	205	47	\N	\N	99999999.00	seconds	\N
447	156	46	\N	\N	99999999.00	seconds	\N
448	266	46	\N	\N	99999999.00	seconds	\N
449	193	46	\N	\N	99999999.00	seconds	\N
526	260	53	\N	\N	47.50	seconds	\N
450	275	11	\N	\N	293.29	seconds	\N
497	116	64	\N	\N	690.80	seconds	\N
451	210	12	\N	\N	293.87	seconds	\N
452	184	11	\N	\N	299.81	seconds	\N
453	123	12	\N	\N	303.54	seconds	\N
498	154	64	\N	\N	699.80	seconds	\N
454	194	11	\N	\N	305.57	seconds	\N
455	36	11	\N	\N	306.20	seconds	\N
542	55	108	\N	\N	303.00	inches	\N
456	13	12	\N	\N	306.52	seconds	\N
499	86	65	\N	\N	733.10	seconds	\N
457	16	11	\N	\N	320.59	seconds	\N
458	207	12	\N	\N	323.36	seconds	\N
500	28	65	\N	\N	99999999.00	seconds	\N
459	48	11	\N	\N	323.45	seconds	\N
460	201	12	\N	\N	328.55	seconds	\N
501	121	65	\N	\N	99999999.00	seconds	\N
461	77	11	\N	\N	337.52	seconds	\N
462	232	12	\N	\N	344.31	seconds	\N
502	176	65	\N	\N	99999999.00	seconds	\N
463	90	12	\N	\N	345.30	seconds	\N
464	18	11	\N	\N	99999999.00	seconds	\N
465	72	12	\N	\N	99999999.00	seconds	\N
466	46	11	\N	\N	99999999.00	seconds	\N
467	222	12	\N	\N	99999999.00	seconds	\N
468	107	11	\N	\N	99999999.00	seconds	\N
469	88	12	\N	\N	99999999.00	seconds	\N
470	116	10	\N	\N	312.92	seconds	\N
503	228	64	\N	\N	99999999.00	seconds	\N
471	115	12	\N	\N	314.45	seconds	\N
472	154	10	\N	\N	319.78	seconds	\N
504	302	65	\N	\N	99999999.00	seconds	\N
473	270	10	\N	\N	319.83	seconds	\N
474	129	12	\N	\N	326.13	seconds	\N
527	249	53	\N	\N	52.12	seconds	\N
475	121	11	\N	\N	332.45	seconds	\N
505	260	29	\N	\N	11.58	seconds	\N
476	245	11	\N	\N	335.46	seconds	\N
477	302	11	\N	\N	336.78	seconds	\N
478	86	11	\N	\N	337.08	seconds	\N
506	132	29	\N	\N	12.14	seconds	\N
479	162	11	\N	\N	338.69	seconds	\N
480	92	12	\N	\N	381.26	seconds	\N
481	28	11	\N	\N	99999999.00	seconds	\N
482	176	11	\N	\N	99999999.00	seconds	\N
483	177	11	\N	\N	99999999.00	seconds	\N
484	205	11	\N	\N	99999999.00	seconds	\N
485	156	10	\N	\N	99999999.00	seconds	\N
486	228	10	\N	\N	99999999.00	seconds	\N
487	266	10	\N	\N	99999999.00	seconds	\N
488	193	10	\N	\N	99999999.00	seconds	\N
489	123	66	\N	\N	643.80	seconds	\N
507	288	29	\N	\N	12.67	seconds	\N
490	210	66	\N	\N	647.20	seconds	\N
491	16	65	\N	\N	99999999.00	seconds	\N
492	77	65	\N	\N	99999999.00	seconds	\N
493	36	65	\N	\N	99999999.00	seconds	\N
494	18	65	\N	\N	99999999.00	seconds	\N
495	194	65	\N	\N	99999999.00	seconds	\N
496	107	65	\N	\N	99999999.00	seconds	\N
528	288	53	\N	\N	54.04	seconds	\N
508	295	29	\N	\N	12.90	seconds	\N
509	87	28	\N	\N	99999999.00	seconds	\N
510	104	28	\N	\N	99999999.00	seconds	\N
511	262	24	\N	\N	15.40	seconds	\N
529	87	52	\N	\N	99999999.00	seconds	\N
512	128	23	\N	\N	15.80	seconds	\N
513	96	24	\N	\N	18.17	seconds	\N
530	104	52	\N	\N	99999999.00	seconds	\N
514	54	24	\N	\N	18.22	seconds	\N
515	267	24	\N	\N	18.50	seconds	\N
531	295	53	\N	\N	99999999.00	seconds	\N
516	170	24	\N	\N	20.22	seconds	\N
517	263	24	\N	\N	22.01	seconds	\N
518	8	23	\N	\N	99999999.00	seconds	\N
543	59	108	\N	\N	0.00	inches	\N
519	128	53	\N	\N	43.92	seconds	\N
532	238	108	\N	\N	492.00	inches	\N
520	267	54	\N	\N	45.01	seconds	\N
521	54	54	\N	\N	46.53	seconds	\N
522	96	54	\N	\N	47.38	seconds	\N
533	227	108	\N	\N	473.00	inches	\N
523	170	54	\N	\N	51.23	seconds	\N
524	8	53	\N	\N	53.23	seconds	\N
525	173	54	\N	\N	99999999.00	seconds	\N
544	172	108	\N	\N	0.00	inches	\N
534	76	107	\N	\N	447.00	inches	\N
545	114	108	\N	\N	0.00	inches	\N
535	235	108	\N	\N	395.50	inches	\N
536	50	108	\N	\N	367.00	inches	\N
552	196	106	\N	\N	335.00	inches	\N
537	33	108	\N	\N	364.00	inches	\N
546	95	107	\N	\N	429.50	inches	\N
538	67	108	\N	\N	347.50	inches	\N
539	64	108	\N	\N	347.00	inches	\N
540	140	108	\N	\N	344.00	inches	\N
547	221	107	\N	\N	393.00	inches	\N
541	188	108	\N	\N	328.00	inches	\N
553	255	107	\N	\N	333.00	inches	\N
548	118	107	\N	\N	383.00	inches	\N
549	251	107	\N	\N	373.50	inches	\N
554	80	107	\N	\N	0.00	inches	\N
550	240	107	\N	\N	362.00	inches	\N
551	243	107	\N	\N	343.50	inches	\N
559	227	102	\N	\N	1126.00	inches	\N
555	82	107	\N	\N	0.00	inches	\N
556	150	106	\N	\N	0.00	inches	\N
557	94	107	\N	\N	0.00	inches	\N
558	238	102	\N	\N	1128.50	inches	\N
563	76	101	\N	\N	1048.00	inches	\N
560	33	102	\N	\N	1103.00	inches	\N
562	50	102	\N	\N	1054.00	inches	\N
561	67	102	\N	\N	1061.00	inches	\N
564	235	102	\N	\N	1027.00	inches	\N
565	64	102	\N	\N	959.00	inches	\N
566	140	102	\N	\N	876.00	inches	\N
567	188	102	\N	\N	837.00	inches	\N
568	55	102	\N	\N	816.00	inches	\N
569	59	102	\N	\N	0.00	inches	\N
570	172	102	\N	\N	0.00	inches	\N
571	114	102	\N	\N	0.00	inches	\N
572	251	101	\N	\N	1208.00	inches	\N
573	221	101	\N	\N	1128.00	inches	\N
574	118	101	\N	\N	1096.00	inches	\N
575	95	101	\N	\N	1050.00	inches	\N
576	196	100	\N	\N	870.00	inches	\N
577	255	101	\N	\N	789.00	inches	\N
578	243	101	\N	\N	759.00	inches	\N
579	240	101	\N	\N	721.00	inches	\N
580	80	101	\N	\N	0.00	inches	\N
581	82	101	\N	\N	0.00	inches	\N
582	94	101	\N	\N	0.00	inches	\N
583	27	78	\N	\N	68.00	inches	\N
641	259	89	\N	\N	0.00	inches	\N
584	262	78	\N	\N	68.00	inches	\N
585	49	78	\N	\N	64.00	inches	\N
586	142	78	\N	\N	62.00	inches	\N
587	73	78	\N	\N	0.00	inches	\N
588	62	77	\N	\N	0.00	inches	\N
589	5	77	\N	\N	0.00	inches	\N
590	278	78	\N	\N	0.00	inches	\N
591	107	77	\N	\N	0.00	inches	\N
592	2	76	\N	\N	0.00	inches	\N
593	141	77	\N	\N	0.00	inches	\N
594	249	77	\N	\N	0.00	inches	\N
595	158	77	\N	\N	0.00	inches	\N
596	265	76	\N	\N	0.00	inches	\N
597	259	77	\N	\N	0.00	inches	\N
642	99	96	\N	\N	470.50	inches	\N
598	263	84	\N	\N	144.00	inches	\N
599	267	84	\N	\N	126.00	inches	\N
670	328	145	\N	\N	99999999.00	seconds	\N
600	152	84	\N	\N	126.00	inches	\N
643	262	96	\N	\N	468.50	inches	\N
601	183	84	\N	\N	120.00	inches	\N
602	135	84	\N	\N	120.00	inches	\N
603	91	84	\N	\N	108.00	inches	\N
644	300	96	\N	\N	466.00	inches	\N
604	198	84	\N	\N	108.00	inches	\N
605	61	82	\N	\N	102.00	inches	\N
671	349	147	\N	\N	99999999.00	seconds	\N
606	79	82	\N	\N	96.00	inches	\N
607	40	84	\N	\N	0.00	inches	\N
608	49	84	\N	\N	0.00	inches	\N
609	27	84	\N	\N	0.00	inches	\N
610	73	84	\N	\N	0.00	inches	\N
645	142	96	\N	\N	456.00	inches	\N
611	71	83	\N	\N	84.00	inches	\N
612	213	83	\N	\N	0.00	inches	\N
613	287	83	\N	\N	0.00	inches	\N
614	102	82	\N	\N	0.00	inches	\N
615	153	82	\N	\N	0.00	inches	\N
616	262	90	\N	\N	218.00	inches	\N
617	300	90	\N	\N	210.00	inches	\N
646	231	96	\N	\N	408.50	inches	\N
618	49	90	\N	\N	195.25	inches	\N
619	23	90	\N	\N	178.00	inches	\N
647	152	96	\N	\N	0.00	inches	\N
620	190	90	\N	\N	167.00	inches	\N
621	112	90	\N	\N	159.00	inches	\N
648	136	96	\N	\N	0.00	inches	\N
622	231	90	\N	\N	158.00	inches	\N
623	13	90	\N	\N	136.75	inches	\N
624	25	90	\N	\N	0.00	inches	\N
625	73	90	\N	\N	0.00	inches	\N
626	62	89	\N	\N	0.00	inches	\N
627	281	90	\N	\N	0.00	inches	\N
628	278	90	\N	\N	0.00	inches	\N
629	142	90	\N	\N	0.00	inches	\N
630	136	90	\N	\N	0.00	inches	\N
672	357	146	\N	\N	99999999.00	seconds	\N
631	132	89	\N	\N	223.00	inches	\N
649	254	94	\N	\N	462.50	inches	\N
632	265	88	\N	\N	209.00	inches	\N
633	169	88	\N	\N	209.00	inches	\N
634	254	88	\N	\N	204.00	inches	\N
650	169	94	\N	\N	435.00	inches	\N
635	249	89	\N	\N	183.00	inches	\N
636	166	89	\N	\N	183.00	inches	\N
673	369	147	\N	\N	99999999.00	seconds	\N
637	130	88	\N	\N	174.00	inches	\N
651	162	95	\N	\N	399.50	inches	\N
638	268	89	\N	\N	134.00	inches	\N
639	158	89	\N	\N	0.00	inches	\N
640	157	88	\N	\N	0.00	inches	\N
652	160	95	\N	\N	399.00	inches	\N
674	428	146	\N	\N	99999999.00	seconds	\N
653	249	95	\N	\N	397.50	inches	\N
654	268	95	\N	\N	388.00	inches	\N
675	408	146	\N	\N	99999999.00	seconds	\N
655	130	94	\N	\N	373.00	inches	\N
656	96	96	\N	\N	0.00	inches	\N
657	158	95	\N	\N	0.00	inches	\N
658	645	147	\N	\N	12.15	seconds	\N
676	416	145	\N	\N	99999999.00	seconds	\N
659	647	146	\N	\N	13.50	seconds	\N
660	632	147	\N	\N	14.00	seconds	\N
677	420	145	\N	\N	99999999.00	seconds	\N
661	588	147	\N	\N	14.50	seconds	\N
662	584	146	\N	\N	14.59	seconds	\N
678	423	146	\N	\N	99999999.00	seconds	\N
663	454	145	\N	\N	14.88	seconds	\N
664	578	146	\N	\N	14.97	seconds	\N
679	424	145	\N	\N	99999999.00	seconds	\N
665	429	147	\N	\N	14.98	seconds	\N
666	452	147	\N	\N	15.15	seconds	\N
680	456	145	\N	\N	99999999.00	seconds	\N
667	489	147	\N	\N	15.84	seconds	\N
668	586	146	\N	\N	16.15	seconds	\N
669	355	146	\N	\N	99999999.00	seconds	\N
681	447	147	\N	\N	99999999.00	seconds	\N
682	394	145	\N	\N	99999999.00	seconds	\N
683	464	145	\N	\N	99999999.00	seconds	\N
684	477	146	\N	\N	99999999.00	seconds	\N
685	557	146	\N	\N	99999999.00	seconds	\N
686	537	147	\N	\N	99999999.00	seconds	\N
687	594	145	\N	\N	99999999.00	seconds	\N
688	602	145	\N	\N	99999999.00	seconds	\N
689	621	146	\N	\N	99999999.00	seconds	\N
690	614	146	\N	\N	99999999.00	seconds	\N
691	620	145	\N	\N	99999999.00	seconds	\N
692	577	147	\N	\N	99999999.00	seconds	\N
693	574	145	\N	\N	99999999.00	seconds	\N
694	573	145	\N	\N	99999999.00	seconds	\N
695	631	147	\N	\N	99999999.00	seconds	\N
696	641	147	\N	\N	99999999.00	seconds	\N
697	635	146	\N	\N	99999999.00	seconds	\N
698	640	146	\N	\N	99999999.00	seconds	\N
699	644	146	\N	\N	99999999.00	seconds	\N
700	702	146	\N	\N	99999999.00	seconds	\N
701	701	146	\N	\N	99999999.00	seconds	\N
702	654	145	\N	\N	99999999.00	seconds	\N
703	706	145	\N	\N	99999999.00	seconds	\N
704	674	145	\N	\N	99999999.00	seconds	\N
705	658	145	\N	\N	99999999.00	seconds	\N
706	660	145	\N	\N	99999999.00	seconds	\N
707	686	145	\N	\N	99999999.00	seconds	\N
708	679	146	\N	\N	99999999.00	seconds	\N
709	649	147	\N	\N	99999999.00	seconds	\N
710	695	145	\N	\N	99999999.00	seconds	\N
711	735	147	\N	\N	99999999.00	seconds	\N
712	719	147	\N	\N	99999999.00	seconds	\N
713	742	146	\N	\N	99999999.00	seconds	\N
714	710	145	\N	\N	99999999.00	seconds	\N
715	713	146	\N	\N	99999999.00	seconds	\N
716	720	145	\N	\N	99999999.00	seconds	\N
717	736	145	\N	\N	99999999.00	seconds	\N
718	738	147	\N	\N	99999999.00	seconds	\N
719	741	147	\N	\N	99999999.00	seconds	\N
720	745	145	\N	\N	99999999.00	seconds	\N
721	645	165	\N	\N	24.88	seconds	\N
722	569	164	\N	\N	32.77	seconds	\N
723	586	164	\N	\N	34.60	seconds	\N
724	384	164	\N	\N	99999999.00	seconds	\N
725	328	163	\N	\N	99999999.00	seconds	\N
726	342	163	\N	\N	99999999.00	seconds	\N
727	358	163	\N	\N	99999999.00	seconds	\N
728	369	165	\N	\N	99999999.00	seconds	\N
729	385	163	\N	\N	99999999.00	seconds	\N
730	347	163	\N	\N	99999999.00	seconds	\N
731	452	165	\N	\N	99999999.00	seconds	\N
732	428	164	\N	\N	99999999.00	seconds	\N
733	408	164	\N	\N	99999999.00	seconds	\N
734	416	163	\N	\N	99999999.00	seconds	\N
735	420	163	\N	\N	99999999.00	seconds	\N
736	424	163	\N	\N	99999999.00	seconds	\N
737	454	163	\N	\N	99999999.00	seconds	\N
738	456	163	\N	\N	99999999.00	seconds	\N
739	447	165	\N	\N	99999999.00	seconds	\N
740	394	163	\N	\N	99999999.00	seconds	\N
741	464	163	\N	\N	99999999.00	seconds	\N
742	477	164	\N	\N	99999999.00	seconds	\N
743	557	164	\N	\N	99999999.00	seconds	\N
744	537	165	\N	\N	99999999.00	seconds	\N
745	627	165	\N	\N	99999999.00	seconds	\N
746	623	165	\N	\N	99999999.00	seconds	\N
747	611	164	\N	\N	99999999.00	seconds	\N
748	594	163	\N	\N	99999999.00	seconds	\N
749	628	165	\N	\N	99999999.00	seconds	\N
750	620	163	\N	\N	99999999.00	seconds	\N
751	583	165	\N	\N	99999999.00	seconds	\N
752	581	164	\N	\N	99999999.00	seconds	\N
753	578	164	\N	\N	99999999.00	seconds	\N
754	588	165	\N	\N	99999999.00	seconds	\N
755	574	163	\N	\N	99999999.00	seconds	\N
756	573	163	\N	\N	99999999.00	seconds	\N
757	637	164	\N	\N	99999999.00	seconds	\N
758	643	165	\N	\N	99999999.00	seconds	\N
759	644	164	\N	\N	99999999.00	seconds	\N
760	708	164	\N	\N	99999999.00	seconds	\N
761	702	164	\N	\N	99999999.00	seconds	\N
762	701	164	\N	\N	99999999.00	seconds	\N
763	654	163	\N	\N	99999999.00	seconds	\N
764	706	163	\N	\N	99999999.00	seconds	\N
765	660	163	\N	\N	99999999.00	seconds	\N
766	663	163	\N	\N	99999999.00	seconds	\N
767	649	165	\N	\N	99999999.00	seconds	\N
768	695	163	\N	\N	99999999.00	seconds	\N
769	731	165	\N	\N	99999999.00	seconds	\N
770	735	165	\N	\N	99999999.00	seconds	\N
771	719	165	\N	\N	99999999.00	seconds	\N
772	725	165	\N	\N	99999999.00	seconds	\N
773	710	163	\N	\N	99999999.00	seconds	\N
774	720	163	\N	\N	99999999.00	seconds	\N
775	730	165	\N	\N	99999999.00	seconds	\N
776	736	163	\N	\N	99999999.00	seconds	\N
800	708	140	\N	\N	99999999.00	seconds	\N
777	645	141	\N	\N	57.50	seconds	\N
778	569	140	\N	\N	74.11	seconds	\N
801	702	140	\N	\N	99999999.00	seconds	\N
779	529	141	\N	\N	75.35	seconds	\N
780	335	140	\N	\N	99999999.00	seconds	\N
781	367	140	\N	\N	99999999.00	seconds	\N
782	342	139	\N	\N	99999999.00	seconds	\N
783	353	140	\N	\N	99999999.00	seconds	\N
784	358	139	\N	\N	99999999.00	seconds	\N
785	385	139	\N	\N	99999999.00	seconds	\N
786	347	139	\N	\N	99999999.00	seconds	\N
787	380	139	\N	\N	99999999.00	seconds	\N
788	408	140	\N	\N	99999999.00	seconds	\N
789	420	139	\N	\N	99999999.00	seconds	\N
790	424	139	\N	\N	99999999.00	seconds	\N
791	394	139	\N	\N	99999999.00	seconds	\N
792	462	141	\N	\N	99999999.00	seconds	\N
793	469	139	\N	\N	99999999.00	seconds	\N
794	489	141	\N	\N	99999999.00	seconds	\N
795	623	141	\N	\N	99999999.00	seconds	\N
796	611	140	\N	\N	99999999.00	seconds	\N
797	581	140	\N	\N	99999999.00	seconds	\N
798	584	140	\N	\N	99999999.00	seconds	\N
799	637	140	\N	\N	99999999.00	seconds	\N
802	654	139	\N	\N	99999999.00	seconds	\N
803	676	139	\N	\N	99999999.00	seconds	\N
804	660	139	\N	\N	99999999.00	seconds	\N
805	724	141	\N	\N	99999999.00	seconds	\N
806	740	141	\N	\N	99999999.00	seconds	\N
829	469	151	\N	\N	99999999.00	seconds	\N
807	549	151	\N	\N	176.00	seconds	\N
808	553	152	\N	\N	178.00	seconds	\N
830	499	153	\N	\N	99999999.00	seconds	\N
809	521	153	\N	\N	178.18	seconds	\N
810	556	152	\N	\N	179.82	seconds	\N
831	492	152	\N	\N	99999999.00	seconds	\N
811	314	151	\N	\N	182.70	seconds	\N
812	311	153	\N	\N	183.23	seconds	\N
832	606	153	\N	\N	99999999.00	seconds	\N
813	541	153	\N	\N	200.00	seconds	\N
814	318	152	\N	\N	99999999.00	seconds	\N
815	310	152	\N	\N	99999999.00	seconds	\N
816	335	152	\N	\N	99999999.00	seconds	\N
817	367	152	\N	\N	99999999.00	seconds	\N
818	323	151	\N	\N	99999999.00	seconds	\N
819	341	151	\N	\N	99999999.00	seconds	\N
820	362	151	\N	\N	99999999.00	seconds	\N
821	366	151	\N	\N	99999999.00	seconds	\N
822	353	152	\N	\N	99999999.00	seconds	\N
823	419	153	\N	\N	99999999.00	seconds	\N
824	392	151	\N	\N	99999999.00	seconds	\N
825	422	153	\N	\N	99999999.00	seconds	\N
826	455	151	\N	\N	99999999.00	seconds	\N
827	462	153	\N	\N	99999999.00	seconds	\N
828	474	153	\N	\N	99999999.00	seconds	\N
833	595	152	\N	\N	99999999.00	seconds	\N
834	624	153	\N	\N	99999999.00	seconds	\N
835	583	153	\N	\N	99999999.00	seconds	\N
836	581	152	\N	\N	99999999.00	seconds	\N
837	587	153	\N	\N	99999999.00	seconds	\N
838	639	153	\N	\N	99999999.00	seconds	\N
839	642	153	\N	\N	99999999.00	seconds	\N
840	688	153	\N	\N	99999999.00	seconds	\N
841	694	153	\N	\N	99999999.00	seconds	\N
842	651	153	\N	\N	99999999.00	seconds	\N
843	672	152	\N	\N	99999999.00	seconds	\N
844	697	152	\N	\N	99999999.00	seconds	\N
845	707	152	\N	\N	99999999.00	seconds	\N
846	678	152	\N	\N	99999999.00	seconds	\N
847	683	151	\N	\N	99999999.00	seconds	\N
848	676	151	\N	\N	99999999.00	seconds	\N
849	734	151	\N	\N	99999999.00	seconds	\N
850	711	152	\N	\N	99999999.00	seconds	\N
851	587	117	\N	\N	298.53	seconds	\N
853	492	116	\N	\N	380.60	seconds	\N
852	549	115	\N	\N	371.68	seconds	\N
854	521	117	\N	\N	384.25	seconds	\N
855	553	116	\N	\N	387.50	seconds	\N
856	556	116	\N	\N	390.00	seconds	\N
857	486	117	\N	\N	390.43	seconds	\N
858	499	117	\N	\N	390.76	seconds	\N
859	540	116	\N	\N	408.42	seconds	\N
860	311	117	\N	\N	411.96	seconds	\N
861	545	115	\N	\N	421.00	seconds	\N
862	541	117	\N	\N	440.33	seconds	\N
863	318	116	\N	\N	99999999.00	seconds	\N
864	314	115	\N	\N	99999999.00	seconds	\N
865	310	116	\N	\N	99999999.00	seconds	\N
866	323	115	\N	\N	99999999.00	seconds	\N
867	341	115	\N	\N	99999999.00	seconds	\N
868	362	115	\N	\N	99999999.00	seconds	\N
869	366	115	\N	\N	99999999.00	seconds	\N
870	419	117	\N	\N	99999999.00	seconds	\N
871	392	115	\N	\N	99999999.00	seconds	\N
872	422	117	\N	\N	99999999.00	seconds	\N
873	455	115	\N	\N	99999999.00	seconds	\N
874	474	117	\N	\N	99999999.00	seconds	\N
875	469	115	\N	\N	99999999.00	seconds	\N
876	606	117	\N	\N	99999999.00	seconds	\N
877	595	116	\N	\N	99999999.00	seconds	\N
878	624	117	\N	\N	99999999.00	seconds	\N
879	639	117	\N	\N	99999999.00	seconds	\N
880	642	117	\N	\N	99999999.00	seconds	\N
881	688	117	\N	\N	99999999.00	seconds	\N
882	694	117	\N	\N	99999999.00	seconds	\N
883	651	117	\N	\N	99999999.00	seconds	\N
884	672	116	\N	\N	99999999.00	seconds	\N
885	697	116	\N	\N	99999999.00	seconds	\N
886	707	116	\N	\N	99999999.00	seconds	\N
887	678	116	\N	\N	99999999.00	seconds	\N
888	683	115	\N	\N	99999999.00	seconds	\N
889	734	115	\N	\N	99999999.00	seconds	\N
890	688	171	\N	\N	99999999.00	seconds	\N
891	694	171	\N	\N	99999999.00	seconds	\N
892	672	170	\N	\N	99999999.00	seconds	\N
893	697	170	\N	\N	99999999.00	seconds	\N
894	707	170	\N	\N	99999999.00	seconds	\N
895	678	170	\N	\N	99999999.00	seconds	\N
896	683	169	\N	\N	99999999.00	seconds	\N
897	633	123	\N	\N	17.25	seconds	\N
937	426	213	\N	\N	0.00	inches	\N
898	566	122	\N	\N	17.97	seconds	\N
899	636	121	\N	\N	19.49	seconds	\N
938	443	213	\N	\N	0.00	inches	\N
900	517	123	\N	\N	20.17	seconds	\N
901	496	123	\N	\N	21.01	seconds	\N
939	406	212	\N	\N	0.00	inches	\N
902	501	123	\N	\N	24.12	seconds	\N
903	355	122	\N	\N	99999999.00	seconds	\N
904	628	123	\N	\N	99999999.00	seconds	\N
905	674	121	\N	\N	99999999.00	seconds	\N
906	658	121	\N	\N	99999999.00	seconds	\N
907	664	122	\N	\N	99999999.00	seconds	\N
908	657	122	\N	\N	99999999.00	seconds	\N
909	679	122	\N	\N	99999999.00	seconds	\N
910	633	159	\N	\N	53.11	seconds	\N
940	601	213	\N	\N	0.00	inches	\N
911	566	158	\N	\N	53.64	seconds	\N
912	636	157	\N	\N	55.73	seconds	\N
941	646	213	\N	\N	0.00	inches	\N
913	517	159	\N	\N	55.80	seconds	\N
914	496	159	\N	\N	57.45	seconds	\N
942	677	212	\N	\N	0.00	inches	\N
915	501	159	\N	\N	62.30	seconds	\N
916	355	158	\N	\N	99999999.00	seconds	\N
917	380	157	\N	\N	99999999.00	seconds	\N
918	617	158	\N	\N	99999999.00	seconds	\N
919	638	158	\N	\N	99999999.00	seconds	\N
920	664	158	\N	\N	99999999.00	seconds	\N
921	657	158	\N	\N	99999999.00	seconds	\N
922	679	158	\N	\N	99999999.00	seconds	\N
923	440	212	\N	\N	338.50	inches	\N
943	666	213	\N	\N	0.00	inches	\N
924	448	211	\N	\N	330.50	inches	\N
925	503	213	\N	\N	323.00	inches	\N
944	670	211	\N	\N	0.00	inches	\N
926	461	213	\N	\N	302.00	inches	\N
927	523	213	\N	\N	282.00	inches	\N
945	686	211	\N	\N	0.00	inches	\N
928	526	213	\N	\N	266.00	inches	\N
929	500	212	\N	\N	245.00	inches	\N
930	315	212	\N	\N	0.00	inches	\N
931	356	212	\N	\N	0.00	inches	\N
932	326	211	\N	\N	0.00	inches	\N
933	334	211	\N	\N	0.00	inches	\N
934	357	212	\N	\N	0.00	inches	\N
935	404	213	\N	\N	0.00	inches	\N
936	390	213	\N	\N	0.00	inches	\N
946	680	212	\N	\N	0.00	inches	\N
947	675	212	\N	\N	0.00	inches	\N
948	650	212	\N	\N	0.00	inches	\N
949	667	213	\N	\N	0.00	inches	\N
950	692	213	\N	\N	0.00	inches	\N
951	731	213	\N	\N	0.00	inches	\N
952	710	211	\N	\N	0.00	inches	\N
953	738	213	\N	\N	0.00	inches	\N
970	406	206	\N	\N	0.00	inches	\N
954	503	207	\N	\N	1032.00	inches	\N
955	523	207	\N	\N	871.00	inches	\N
971	533	206	\N	\N	0.00	inches	\N
956	525	207	\N	\N	865.00	inches	\N
957	526	207	\N	\N	858.00	inches	\N
972	601	207	\N	\N	0.00	inches	\N
958	440	206	\N	\N	816.00	inches	\N
959	461	207	\N	\N	779.00	inches	\N
973	646	207	\N	\N	0.00	inches	\N
960	448	205	\N	\N	644.00	inches	\N
961	500	206	\N	\N	582.00	inches	\N
962	356	206	\N	\N	0.00	inches	\N
963	326	205	\N	\N	0.00	inches	\N
964	334	205	\N	\N	0.00	inches	\N
965	357	206	\N	\N	0.00	inches	\N
966	404	207	\N	\N	0.00	inches	\N
967	390	207	\N	\N	0.00	inches	\N
968	426	207	\N	\N	0.00	inches	\N
969	443	207	\N	\N	0.00	inches	\N
974	677	206	\N	\N	0.00	inches	\N
975	666	207	\N	\N	0.00	inches	\N
976	670	205	\N	\N	0.00	inches	\N
977	686	205	\N	\N	0.00	inches	\N
978	680	206	\N	\N	0.00	inches	\N
979	675	206	\N	\N	0.00	inches	\N
980	650	206	\N	\N	0.00	inches	\N
981	667	207	\N	\N	0.00	inches	\N
982	692	207	\N	\N	0.00	inches	\N
983	725	207	\N	\N	0.00	inches	\N
987	333	183	\N	\N	0.00	inches	\N
984	633	183	\N	\N	54.00	inches	\N
985	487	182	\N	\N	52.00	inches	\N
986	498	182	\N	\N	0.00	inches	\N
988	350	183	\N	\N	0.00	inches	\N
989	380	181	\N	\N	0.00	inches	\N
990	613	183	\N	\N	0.00	inches	\N
991	626	183	\N	\N	0.00	inches	\N
992	623	183	\N	\N	0.00	inches	\N
993	593	181	\N	\N	0.00	inches	\N
994	634	183	\N	\N	0.00	inches	\N
995	644	182	\N	\N	0.00	inches	\N
996	664	182	\N	\N	0.00	inches	\N
997	667	183	\N	\N	0.00	inches	\N
999	577	189	\N	\N	138.00	inches	\N
998	647	188	\N	\N	154.25	inches	\N
1000	634	189	\N	\N	114.00	inches	\N
1001	501	189	\N	\N	78.00	inches	\N
1002	489	189	\N	\N	66.00	inches	\N
1003	384	188	\N	\N	0.00	inches	\N
1004	342	187	\N	\N	0.00	inches	\N
1005	613	189	\N	\N	0.00	inches	\N
1006	601	189	\N	\N	0.00	inches	\N
1007	664	188	\N	\N	0.00	inches	\N
1008	647	194	\N	\N	198.50	inches	\N
1009	566	194	\N	\N	174.00	inches	\N
1010	487	194	\N	\N	163.00	inches	\N
1011	536	195	\N	\N	123.50	inches	\N
1012	524	194	\N	\N	118.00	inches	\N
1013	498	194	\N	\N	0.00	inches	\N
1014	533	194	\N	\N	0.00	inches	\N
1015	333	195	\N	\N	0.00	inches	\N
1016	322	195	\N	\N	0.00	inches	\N
1017	328	193	\N	\N	0.00	inches	\N
1018	349	195	\N	\N	0.00	inches	\N
1019	347	193	\N	\N	0.00	inches	\N
1020	429	195	\N	\N	0.00	inches	\N
1021	452	195	\N	\N	0.00	inches	\N
1022	416	193	\N	\N	0.00	inches	\N
1023	424	193	\N	\N	0.00	inches	\N
1024	569	194	\N	\N	0.00	inches	\N
1025	613	195	\N	\N	0.00	inches	\N
1026	593	193	\N	\N	0.00	inches	\N
1027	620	193	\N	\N	0.00	inches	\N
1028	577	195	\N	\N	0.00	inches	\N
1029	574	193	\N	\N	0.00	inches	\N
1030	632	195	\N	\N	0.00	inches	\N
1031	638	194	\N	\N	0.00	inches	\N
1032	651	195	\N	\N	0.00	inches	\N
1033	701	194	\N	\N	0.00	inches	\N
1034	663	193	\N	\N	0.00	inches	\N
1035	649	195	\N	\N	0.00	inches	\N
1036	742	194	\N	\N	0.00	inches	\N
1037	711	194	\N	\N	0.00	inches	\N
1038	713	194	\N	\N	0.00	inches	\N
1039	720	193	\N	\N	0.00	inches	\N
1040	730	195	\N	\N	0.00	inches	\N
1083	364	148	\N	\N	99999999.00	seconds	\N
1041	634	201	\N	\N	430.50	inches	\N
1042	633	201	\N	\N	385.00	inches	\N
1084	370	149	\N	\N	99999999.00	seconds	\N
1043	533	200	\N	\N	359.50	inches	\N
1044	636	199	\N	\N	329.00	inches	\N
1085	402	149	\N	\N	99999999.00	seconds	\N
1045	536	201	\N	\N	299.00	inches	\N
1046	524	200	\N	\N	249.50	inches	\N
1047	498	200	\N	\N	0.00	inches	\N
1048	322	201	\N	\N	0.00	inches	\N
1049	429	201	\N	\N	0.00	inches	\N
1050	408	200	\N	\N	0.00	inches	\N
1051	626	201	\N	\N	0.00	inches	\N
1052	632	201	\N	\N	0.00	inches	\N
1053	638	200	\N	\N	0.00	inches	\N
1086	398	150	\N	\N	99999999.00	seconds	\N
1054	597	150	\N	\N	11.60	seconds	\N
1055	520	150	\N	\N	11.88	seconds	\N
1087	407	150	\N	\N	99999999.00	seconds	\N
1056	391	150	\N	\N	12.54	seconds	\N
1057	435	150	\N	\N	12.60	seconds	\N
1088	421	148	\N	\N	99999999.00	seconds	\N
1058	438	150	\N	\N	12.72	seconds	\N
1059	530	150	\N	\N	12.72	seconds	\N
1089	437	150	\N	\N	99999999.00	seconds	\N
1060	564	149	\N	\N	13.36	seconds	\N
1061	575	148	\N	\N	13.64	seconds	\N
1090	439	148	\N	\N	99999999.00	seconds	\N
1062	395	149	\N	\N	13.97	seconds	\N
1063	502	149	\N	\N	14.07	seconds	\N
1064	320	150	\N	\N	99999999.00	seconds	\N
1065	309	150	\N	\N	99999999.00	seconds	\N
1066	381	150	\N	\N	99999999.00	seconds	\N
1067	354	150	\N	\N	99999999.00	seconds	\N
1068	383	150	\N	\N	99999999.00	seconds	\N
1069	327	149	\N	\N	99999999.00	seconds	\N
1070	348	149	\N	\N	99999999.00	seconds	\N
1071	386	149	\N	\N	99999999.00	seconds	\N
1072	331	149	\N	\N	99999999.00	seconds	\N
1073	340	150	\N	\N	99999999.00	seconds	\N
1074	343	149	\N	\N	99999999.00	seconds	\N
1075	345	148	\N	\N	99999999.00	seconds	\N
1076	359	150	\N	\N	99999999.00	seconds	\N
1077	368	149	\N	\N	99999999.00	seconds	\N
1078	382	150	\N	\N	99999999.00	seconds	\N
1079	324	150	\N	\N	99999999.00	seconds	\N
1080	330	148	\N	\N	99999999.00	seconds	\N
1081	332	149	\N	\N	99999999.00	seconds	\N
1082	338	148	\N	\N	99999999.00	seconds	\N
1091	446	148	\N	\N	99999999.00	seconds	\N
1092	457	150	\N	\N	99999999.00	seconds	\N
1093	427	150	\N	\N	99999999.00	seconds	\N
1094	482	150	\N	\N	99999999.00	seconds	\N
1095	475	150	\N	\N	99999999.00	seconds	\N
1096	485	150	\N	\N	99999999.00	seconds	\N
1097	478	149	\N	\N	99999999.00	seconds	\N
1098	463	149	\N	\N	99999999.00	seconds	\N
1099	480	149	\N	\N	99999999.00	seconds	\N
1100	467	149	\N	\N	99999999.00	seconds	\N
1101	465	148	\N	\N	99999999.00	seconds	\N
1102	476	148	\N	\N	99999999.00	seconds	\N
1103	471	148	\N	\N	99999999.00	seconds	\N
1104	473	148	\N	\N	99999999.00	seconds	\N
1105	479	148	\N	\N	99999999.00	seconds	\N
1106	484	148	\N	\N	99999999.00	seconds	\N
1107	551	150	\N	\N	99999999.00	seconds	\N
1108	558	150	\N	\N	99999999.00	seconds	\N
1109	548	149	\N	\N	99999999.00	seconds	\N
1110	552	150	\N	\N	99999999.00	seconds	\N
1111	546	150	\N	\N	99999999.00	seconds	\N
1112	563	149	\N	\N	99999999.00	seconds	\N
1113	565	148	\N	\N	99999999.00	seconds	\N
1114	599	149	\N	\N	99999999.00	seconds	\N
1115	596	148	\N	\N	99999999.00	seconds	\N
1116	605	148	\N	\N	99999999.00	seconds	\N
1117	591	148	\N	\N	99999999.00	seconds	\N
1118	604	148	\N	\N	99999999.00	seconds	\N
1119	582	150	\N	\N	99999999.00	seconds	\N
1120	580	149	\N	\N	99999999.00	seconds	\N
1121	669	150	\N	\N	99999999.00	seconds	\N
1122	699	149	\N	\N	99999999.00	seconds	\N
1123	682	149	\N	\N	99999999.00	seconds	\N
1124	652	148	\N	\N	99999999.00	seconds	\N
1125	655	148	\N	\N	99999999.00	seconds	\N
1126	693	148	\N	\N	99999999.00	seconds	\N
1127	681	148	\N	\N	99999999.00	seconds	\N
1128	685	148	\N	\N	99999999.00	seconds	\N
1129	659	150	\N	\N	99999999.00	seconds	\N
1130	709	150	\N	\N	99999999.00	seconds	\N
1131	665	148	\N	\N	99999999.00	seconds	\N
1132	689	150	\N	\N	99999999.00	seconds	\N
1133	704	148	\N	\N	99999999.00	seconds	\N
1134	728	149	\N	\N	99999999.00	seconds	\N
1135	715	150	\N	\N	99999999.00	seconds	\N
1136	723	149	\N	\N	99999999.00	seconds	\N
1137	729	150	\N	\N	99999999.00	seconds	\N
1138	726	150	\N	\N	99999999.00	seconds	\N
1139	716	148	\N	\N	99999999.00	seconds	\N
1140	718	148	\N	\N	99999999.00	seconds	\N
1141	721	150	\N	\N	99999999.00	seconds	\N
1143	520	168	\N	\N	24.39	seconds	\N
1142	597	168	\N	\N	23.00	seconds	\N
1144	580	167	\N	\N	26.72	seconds	\N
1145	575	166	\N	\N	27.24	seconds	\N
1146	511	168	\N	\N	99999999.00	seconds	\N
1147	309	168	\N	\N	99999999.00	seconds	\N
1148	354	168	\N	\N	99999999.00	seconds	\N
1149	383	168	\N	\N	99999999.00	seconds	\N
1150	348	167	\N	\N	99999999.00	seconds	\N
1151	386	167	\N	\N	99999999.00	seconds	\N
1152	331	167	\N	\N	99999999.00	seconds	\N
1153	340	168	\N	\N	99999999.00	seconds	\N
1154	346	166	\N	\N	99999999.00	seconds	\N
1155	359	168	\N	\N	99999999.00	seconds	\N
1156	368	167	\N	\N	99999999.00	seconds	\N
1157	371	168	\N	\N	99999999.00	seconds	\N
1158	382	168	\N	\N	99999999.00	seconds	\N
1159	330	166	\N	\N	99999999.00	seconds	\N
1160	332	167	\N	\N	99999999.00	seconds	\N
1161	338	166	\N	\N	99999999.00	seconds	\N
1162	370	167	\N	\N	99999999.00	seconds	\N
1163	388	168	\N	\N	99999999.00	seconds	\N
1164	412	168	\N	\N	99999999.00	seconds	\N
1165	435	168	\N	\N	99999999.00	seconds	\N
1166	430	168	\N	\N	99999999.00	seconds	\N
1167	402	167	\N	\N	99999999.00	seconds	\N
1168	425	168	\N	\N	99999999.00	seconds	\N
1169	395	167	\N	\N	99999999.00	seconds	\N
1170	398	168	\N	\N	99999999.00	seconds	\N
1171	407	168	\N	\N	99999999.00	seconds	\N
1172	421	166	\N	\N	99999999.00	seconds	\N
1173	438	168	\N	\N	99999999.00	seconds	\N
1174	446	166	\N	\N	99999999.00	seconds	\N
1175	451	167	\N	\N	99999999.00	seconds	\N
1176	457	168	\N	\N	99999999.00	seconds	\N
1177	459	167	\N	\N	99999999.00	seconds	\N
1178	444	168	\N	\N	99999999.00	seconds	\N
1179	482	168	\N	\N	99999999.00	seconds	\N
1180	485	168	\N	\N	99999999.00	seconds	\N
1181	463	167	\N	\N	99999999.00	seconds	\N
1182	480	167	\N	\N	99999999.00	seconds	\N
1183	465	166	\N	\N	99999999.00	seconds	\N
1184	476	166	\N	\N	99999999.00	seconds	\N
1185	471	166	\N	\N	99999999.00	seconds	\N
1186	473	166	\N	\N	99999999.00	seconds	\N
1187	484	166	\N	\N	99999999.00	seconds	\N
1188	502	167	\N	\N	99999999.00	seconds	\N
1189	551	168	\N	\N	99999999.00	seconds	\N
1190	558	168	\N	\N	99999999.00	seconds	\N
1191	544	168	\N	\N	99999999.00	seconds	\N
1192	548	167	\N	\N	99999999.00	seconds	\N
1193	552	168	\N	\N	99999999.00	seconds	\N
1194	546	168	\N	\N	99999999.00	seconds	\N
1195	565	166	\N	\N	99999999.00	seconds	\N
1196	599	167	\N	\N	99999999.00	seconds	\N
1197	596	166	\N	\N	99999999.00	seconds	\N
1198	603	168	\N	\N	99999999.00	seconds	\N
1199	605	166	\N	\N	99999999.00	seconds	\N
1200	572	168	\N	\N	99999999.00	seconds	\N
1201	571	166	\N	\N	99999999.00	seconds	\N
1202	582	168	\N	\N	99999999.00	seconds	\N
1203	579	166	\N	\N	99999999.00	seconds	\N
1204	669	168	\N	\N	99999999.00	seconds	\N
1205	699	167	\N	\N	99999999.00	seconds	\N
1206	682	167	\N	\N	99999999.00	seconds	\N
1207	652	166	\N	\N	99999999.00	seconds	\N
1208	655	166	\N	\N	99999999.00	seconds	\N
1209	693	166	\N	\N	99999999.00	seconds	\N
1210	685	166	\N	\N	99999999.00	seconds	\N
1211	687	167	\N	\N	99999999.00	seconds	\N
1212	668	167	\N	\N	99999999.00	seconds	\N
1213	659	168	\N	\N	99999999.00	seconds	\N
1214	671	168	\N	\N	99999999.00	seconds	\N
1215	709	168	\N	\N	99999999.00	seconds	\N
1216	689	168	\N	\N	99999999.00	seconds	\N
1217	704	166	\N	\N	99999999.00	seconds	\N
1218	715	168	\N	\N	99999999.00	seconds	\N
1219	723	167	\N	\N	99999999.00	seconds	\N
1220	726	168	\N	\N	99999999.00	seconds	\N
1221	716	166	\N	\N	99999999.00	seconds	\N
1222	718	166	\N	\N	99999999.00	seconds	\N
1223	749	167	\N	\N	99999999.00	seconds	\N
1224	748	167	\N	\N	99999999.00	seconds	\N
1225	312	144	\N	\N	55.66	seconds	\N
1226	749	143	\N	\N	56.66	seconds	\N
1233	542	144	\N	\N	63.00	seconds	\N
1227	495	143	\N	\N	57.54	seconds	\N
1228	531	144	\N	\N	57.59	seconds	\N
1266	704	142	\N	\N	99999999.00	seconds	\N
1229	748	143	\N	\N	58.51	seconds	\N
1234	319	144	\N	\N	66.42	seconds	\N
1230	544	144	\N	\N	61.00	seconds	\N
1231	571	142	\N	\N	61.76	seconds	\N
1235	316	143	\N	\N	99999999.00	seconds	\N
1232	579	142	\N	\N	62.00	seconds	\N
1236	325	144	\N	\N	99999999.00	seconds	\N
1237	352	144	\N	\N	99999999.00	seconds	\N
1238	363	144	\N	\N	99999999.00	seconds	\N
1239	375	144	\N	\N	99999999.00	seconds	\N
1240	346	142	\N	\N	99999999.00	seconds	\N
1241	360	143	\N	\N	99999999.00	seconds	\N
1242	371	144	\N	\N	99999999.00	seconds	\N
1243	364	142	\N	\N	99999999.00	seconds	\N
1244	412	144	\N	\N	99999999.00	seconds	\N
1245	430	144	\N	\N	99999999.00	seconds	\N
1246	425	144	\N	\N	99999999.00	seconds	\N
1247	398	144	\N	\N	99999999.00	seconds	\N
1248	407	144	\N	\N	99999999.00	seconds	\N
1249	459	143	\N	\N	99999999.00	seconds	\N
1250	472	142	\N	\N	99999999.00	seconds	\N
1251	570	144	\N	\N	99999999.00	seconds	\N
1252	563	143	\N	\N	99999999.00	seconds	\N
1253	567	142	\N	\N	99999999.00	seconds	\N
1254	561	142	\N	\N	99999999.00	seconds	\N
1255	622	142	\N	\N	99999999.00	seconds	\N
1256	603	144	\N	\N	99999999.00	seconds	\N
1257	591	142	\N	\N	99999999.00	seconds	\N
1258	576	143	\N	\N	99999999.00	seconds	\N
1259	652	142	\N	\N	99999999.00	seconds	\N
1260	681	142	\N	\N	99999999.00	seconds	\N
1261	685	142	\N	\N	99999999.00	seconds	\N
1262	687	143	\N	\N	99999999.00	seconds	\N
1263	668	143	\N	\N	99999999.00	seconds	\N
1264	671	144	\N	\N	99999999.00	seconds	\N
1265	689	144	\N	\N	99999999.00	seconds	\N
1267	712	144	\N	\N	99999999.00	seconds	\N
1268	727	144	\N	\N	99999999.00	seconds	\N
1269	722	144	\N	\N	99999999.00	seconds	\N
1270	516	156	\N	\N	119.70	seconds	\N
1282	559	155	\N	\N	152.00	seconds	\N
1271	312	156	\N	\N	131.96	seconds	\N
1277	543	156	\N	\N	144.00	seconds	\N
1272	493	156	\N	\N	134.70	seconds	\N
1273	555	155	\N	\N	135.00	seconds	\N
1274	514	154	\N	\N	136.62	seconds	\N
1278	531	156	\N	\N	144.02	seconds	\N
1275	560	156	\N	\N	143.00	seconds	\N
1276	547	155	\N	\N	143.00	seconds	\N
1279	572	156	\N	\N	145.30	seconds	\N
1283	317	156	\N	\N	158.82	seconds	\N
1280	582	156	\N	\N	145.75	seconds	\N
1281	550	154	\N	\N	148.00	seconds	\N
1286	319	156	\N	\N	173.13	seconds	\N
1284	504	155	\N	\N	158.96	seconds	\N
1285	538	155	\N	\N	168.00	seconds	\N
1289	308	156	\N	\N	99999999.00	seconds	\N
1287	567	154	\N	\N	191.45	seconds	\N
1288	539	155	\N	\N	240.00	seconds	\N
1290	307	155	\N	\N	99999999.00	seconds	\N
1291	306	154	\N	\N	99999999.00	seconds	\N
1292	316	155	\N	\N	99999999.00	seconds	\N
1293	352	156	\N	\N	99999999.00	seconds	\N
1294	363	156	\N	\N	99999999.00	seconds	\N
1295	375	156	\N	\N	99999999.00	seconds	\N
1296	381	156	\N	\N	99999999.00	seconds	\N
1297	336	155	\N	\N	99999999.00	seconds	\N
1298	387	156	\N	\N	99999999.00	seconds	\N
1299	372	154	\N	\N	99999999.00	seconds	\N
1300	337	154	\N	\N	99999999.00	seconds	\N
1301	339	154	\N	\N	99999999.00	seconds	\N
1302	351	154	\N	\N	99999999.00	seconds	\N
1303	365	154	\N	\N	99999999.00	seconds	\N
1304	409	156	\N	\N	99999999.00	seconds	\N
1305	411	155	\N	\N	99999999.00	seconds	\N
1306	436	155	\N	\N	99999999.00	seconds	\N
1307	449	156	\N	\N	99999999.00	seconds	\N
1308	458	156	\N	\N	99999999.00	seconds	\N
1309	432	156	\N	\N	99999999.00	seconds	\N
1310	413	156	\N	\N	99999999.00	seconds	\N
1311	389	156	\N	\N	99999999.00	seconds	\N
1312	399	155	\N	\N	99999999.00	seconds	\N
1313	410	154	\N	\N	99999999.00	seconds	\N
1314	400	154	\N	\N	99999999.00	seconds	\N
1315	405	156	\N	\N	99999999.00	seconds	\N
1316	418	156	\N	\N	99999999.00	seconds	\N
1317	450	154	\N	\N	99999999.00	seconds	\N
1318	393	156	\N	\N	99999999.00	seconds	\N
1319	442	156	\N	\N	99999999.00	seconds	\N
1320	417	155	\N	\N	99999999.00	seconds	\N
1321	481	156	\N	\N	99999999.00	seconds	\N
1322	470	155	\N	\N	99999999.00	seconds	\N
1323	466	156	\N	\N	99999999.00	seconds	\N
1324	472	154	\N	\N	99999999.00	seconds	\N
1325	490	156	\N	\N	99999999.00	seconds	\N
1326	510	155	\N	\N	99999999.00	seconds	\N
1327	562	155	\N	\N	99999999.00	seconds	\N
1328	568	156	\N	\N	99999999.00	seconds	\N
1329	600	156	\N	\N	99999999.00	seconds	\N
1330	612	156	\N	\N	99999999.00	seconds	\N
1331	610	156	\N	\N	99999999.00	seconds	\N
1332	592	155	\N	\N	99999999.00	seconds	\N
1333	619	154	\N	\N	99999999.00	seconds	\N
1334	625	154	\N	\N	99999999.00	seconds	\N
1335	609	154	\N	\N	99999999.00	seconds	\N
1336	615	154	\N	\N	99999999.00	seconds	\N
1337	608	154	\N	\N	99999999.00	seconds	\N
1338	576	155	\N	\N	99999999.00	seconds	\N
1339	705	156	\N	\N	99999999.00	seconds	\N
1340	696	155	\N	\N	99999999.00	seconds	\N
1341	673	155	\N	\N	99999999.00	seconds	\N
1342	698	154	\N	\N	99999999.00	seconds	\N
1343	648	154	\N	\N	99999999.00	seconds	\N
1344	691	154	\N	\N	99999999.00	seconds	\N
1345	662	156	\N	\N	99999999.00	seconds	\N
1346	744	156	\N	\N	99999999.00	seconds	\N
1347	746	156	\N	\N	99999999.00	seconds	\N
1348	739	156	\N	\N	99999999.00	seconds	\N
1349	743	156	\N	\N	99999999.00	seconds	\N
1350	717	154	\N	\N	99999999.00	seconds	\N
1351	753	156	\N	\N	99999999.00	seconds	\N
1352	752	155	\N	\N	99999999.00	seconds	\N
1366	560	120	\N	\N	307.48	seconds	\N
1353	514	118	\N	\N	253.86	seconds	\N
1354	516	120	\N	\N	265.88	seconds	\N
1355	592	119	\N	\N	272.96	seconds	\N
1367	543	120	\N	\N	307.76	seconds	\N
1356	753	120	\N	\N	276.92	seconds	\N
1357	747	120	\N	\N	283.75	seconds	\N
1403	442	120	\N	\N	99999999.00	seconds	\N
1358	752	119	\N	\N	283.75	seconds	\N
1368	550	118	\N	\N	319.22	seconds	\N
1359	555	119	\N	\N	287.21	seconds	\N
1360	612	120	\N	\N	290.00	seconds	\N
1361	625	118	\N	\N	290.58	seconds	\N
1369	559	119	\N	\N	329.61	seconds	\N
1362	493	120	\N	\N	294.65	seconds	\N
1363	490	120	\N	\N	295.99	seconds	\N
1404	417	119	\N	\N	99999999.00	seconds	\N
1364	308	120	\N	\N	305.37	seconds	\N
1370	317	120	\N	\N	345.08	seconds	\N
1365	547	119	\N	\N	306.96	seconds	\N
1371	538	119	\N	\N	358.51	seconds	\N
1405	481	120	\N	\N	99999999.00	seconds	\N
1372	504	119	\N	\N	362.44	seconds	\N
1373	535	120	\N	\N	370.08	seconds	\N
1406	470	119	\N	\N	99999999.00	seconds	\N
1374	554	120	\N	\N	390.00	seconds	\N
1375	568	120	\N	\N	396.33	seconds	\N
1376	312	120	\N	\N	99999999.00	seconds	\N
1377	307	119	\N	\N	99999999.00	seconds	\N
1378	306	118	\N	\N	99999999.00	seconds	\N
1379	316	119	\N	\N	99999999.00	seconds	\N
1380	336	119	\N	\N	99999999.00	seconds	\N
1381	387	120	\N	\N	99999999.00	seconds	\N
1382	372	118	\N	\N	99999999.00	seconds	\N
1383	337	118	\N	\N	99999999.00	seconds	\N
1384	339	118	\N	\N	99999999.00	seconds	\N
1385	351	118	\N	\N	99999999.00	seconds	\N
1386	365	118	\N	\N	99999999.00	seconds	\N
1387	409	120	\N	\N	99999999.00	seconds	\N
1388	411	119	\N	\N	99999999.00	seconds	\N
1389	436	119	\N	\N	99999999.00	seconds	\N
1390	449	120	\N	\N	99999999.00	seconds	\N
1391	458	120	\N	\N	99999999.00	seconds	\N
1392	432	120	\N	\N	99999999.00	seconds	\N
1393	413	120	\N	\N	99999999.00	seconds	\N
1394	389	120	\N	\N	99999999.00	seconds	\N
1395	399	119	\N	\N	99999999.00	seconds	\N
1396	410	118	\N	\N	99999999.00	seconds	\N
1397	400	118	\N	\N	99999999.00	seconds	\N
1398	434	119	\N	\N	99999999.00	seconds	\N
1399	405	120	\N	\N	99999999.00	seconds	\N
1400	418	120	\N	\N	99999999.00	seconds	\N
1401	450	118	\N	\N	99999999.00	seconds	\N
1402	393	120	\N	\N	99999999.00	seconds	\N
1407	467	119	\N	\N	99999999.00	seconds	\N
1408	466	120	\N	\N	99999999.00	seconds	\N
1409	472	118	\N	\N	99999999.00	seconds	\N
1410	483	119	\N	\N	99999999.00	seconds	\N
1411	567	118	\N	\N	99999999.00	seconds	\N
1412	561	118	\N	\N	99999999.00	seconds	\N
1413	600	120	\N	\N	99999999.00	seconds	\N
1414	610	120	\N	\N	99999999.00	seconds	\N
1415	619	118	\N	\N	99999999.00	seconds	\N
1416	609	118	\N	\N	99999999.00	seconds	\N
1417	615	118	\N	\N	99999999.00	seconds	\N
1418	608	118	\N	\N	99999999.00	seconds	\N
1419	589	118	\N	\N	99999999.00	seconds	\N
1420	696	119	\N	\N	99999999.00	seconds	\N
1421	673	119	\N	\N	99999999.00	seconds	\N
1422	698	118	\N	\N	99999999.00	seconds	\N
1423	648	118	\N	\N	99999999.00	seconds	\N
1424	691	118	\N	\N	99999999.00	seconds	\N
1425	662	120	\N	\N	99999999.00	seconds	\N
1426	744	120	\N	\N	99999999.00	seconds	\N
1427	746	120	\N	\N	99999999.00	seconds	\N
1428	739	120	\N	\N	99999999.00	seconds	\N
1429	717	118	\N	\N	99999999.00	seconds	\N
1430	751	120	\N	\N	99999999.00	seconds	\N
1431	750	120	\N	\N	99999999.00	seconds	\N
1432	754	118	\N	\N	99999999.00	seconds	\N
1433	673	173	\N	\N	99999999.00	seconds	\N
1434	648	172	\N	\N	99999999.00	seconds	\N
1435	662	174	\N	\N	99999999.00	seconds	\N
1436	527	132	\N	\N	18.94	seconds	\N
1437	494	132	\N	\N	21.21	seconds	\N
1438	513	132	\N	\N	23.20	seconds	\N
1439	378	132	\N	\N	99999999.00	seconds	\N
1440	376	132	\N	\N	99999999.00	seconds	\N
1441	340	132	\N	\N	99999999.00	seconds	\N
1442	343	131	\N	\N	99999999.00	seconds	\N
1443	338	130	\N	\N	99999999.00	seconds	\N
1444	391	132	\N	\N	99999999.00	seconds	\N
1445	396	132	\N	\N	99999999.00	seconds	\N
1446	478	131	\N	\N	99999999.00	seconds	\N
1447	491	131	\N	\N	99999999.00	seconds	\N
1448	607	132	\N	\N	99999999.00	seconds	\N
1449	604	130	\N	\N	99999999.00	seconds	\N
1450	690	131	\N	\N	99999999.00	seconds	\N
1451	656	132	\N	\N	99999999.00	seconds	\N
1452	727	132	\N	\N	99999999.00	seconds	\N
1453	527	162	\N	\N	48.60	seconds	\N
1517	329	210	\N	\N	0.00	inches	\N
1454	491	161	\N	\N	48.99	seconds	\N
1455	570	162	\N	\N	49.98	seconds	\N
1518	373	210	\N	\N	0.00	inches	\N
1456	494	162	\N	\N	51.49	seconds	\N
1457	378	162	\N	\N	99999999.00	seconds	\N
1458	374	160	\N	\N	99999999.00	seconds	\N
1459	324	162	\N	\N	99999999.00	seconds	\N
1460	391	162	\N	\N	99999999.00	seconds	\N
1461	396	162	\N	\N	99999999.00	seconds	\N
1462	434	161	\N	\N	99999999.00	seconds	\N
1463	481	162	\N	\N	99999999.00	seconds	\N
1464	478	161	\N	\N	99999999.00	seconds	\N
1465	495	161	\N	\N	99999999.00	seconds	\N
1466	607	162	\N	\N	99999999.00	seconds	\N
1467	727	162	\N	\N	99999999.00	seconds	\N
1468	722	162	\N	\N	99999999.00	seconds	\N
1469	497	216	\N	\N	475.50	inches	\N
1519	321	210	\N	\N	0.00	inches	\N
1470	518	216	\N	\N	467.00	inches	\N
1471	512	216	\N	\N	407.00	inches	\N
1520	327	209	\N	\N	0.00	inches	\N
1472	532	216	\N	\N	388.00	inches	\N
1473	488	215	\N	\N	335.50	inches	\N
1521	361	208	\N	\N	0.00	inches	\N
1474	506	216	\N	\N	331.50	inches	\N
1475	313	216	\N	\N	0.00	inches	\N
1476	344	216	\N	\N	0.00	inches	\N
1477	329	216	\N	\N	0.00	inches	\N
1478	375	216	\N	\N	0.00	inches	\N
1479	373	216	\N	\N	0.00	inches	\N
1480	321	216	\N	\N	0.00	inches	\N
1481	327	215	\N	\N	0.00	inches	\N
1482	361	214	\N	\N	0.00	inches	\N
1483	377	216	\N	\N	0.00	inches	\N
1484	453	216	\N	\N	0.00	inches	\N
1485	415	215	\N	\N	0.00	inches	\N
1486	460	215	\N	\N	0.00	inches	\N
1487	414	215	\N	\N	0.00	inches	\N
1488	397	215	\N	\N	0.00	inches	\N
1489	445	216	\N	\N	0.00	inches	\N
1490	431	216	\N	\N	0.00	inches	\N
1491	441	215	\N	\N	0.00	inches	\N
1492	468	214	\N	\N	0.00	inches	\N
1493	554	216	\N	\N	0.00	inches	\N
1494	563	215	\N	\N	0.00	inches	\N
1495	618	216	\N	\N	0.00	inches	\N
1496	616	216	\N	\N	0.00	inches	\N
1497	598	214	\N	\N	0.00	inches	\N
1498	585	215	\N	\N	0.00	inches	\N
1499	661	216	\N	\N	0.00	inches	\N
1500	703	216	\N	\N	0.00	inches	\N
1501	684	214	\N	\N	0.00	inches	\N
1502	653	215	\N	\N	0.00	inches	\N
1503	700	215	\N	\N	0.00	inches	\N
1504	737	216	\N	\N	0.00	inches	\N
1505	729	216	\N	\N	0.00	inches	\N
1506	497	210	\N	\N	1441.00	inches	\N
1522	377	210	\N	\N	0.00	inches	\N
1507	460	209	\N	\N	1315.00	inches	\N
1508	518	210	\N	\N	1224.00	inches	\N
1523	379	208	\N	\N	0.00	inches	\N
1509	532	210	\N	\N	1146.00	inches	\N
1510	512	210	\N	\N	1087.00	inches	\N
1524	453	210	\N	\N	0.00	inches	\N
1511	506	210	\N	\N	1018.00	inches	\N
1512	488	209	\N	\N	903.00	inches	\N
1525	415	209	\N	\N	0.00	inches	\N
1513	564	209	\N	\N	883.00	inches	\N
1514	397	209	\N	\N	810.00	inches	\N
1515	313	210	\N	\N	0.00	inches	\N
1516	344	210	\N	\N	0.00	inches	\N
1526	414	209	\N	\N	0.00	inches	\N
1527	445	210	\N	\N	0.00	inches	\N
1528	431	210	\N	\N	0.00	inches	\N
1529	441	209	\N	\N	0.00	inches	\N
1530	468	208	\N	\N	0.00	inches	\N
1531	542	210	\N	\N	0.00	inches	\N
1532	554	210	\N	\N	0.00	inches	\N
1533	618	210	\N	\N	0.00	inches	\N
1534	616	210	\N	\N	0.00	inches	\N
1535	598	208	\N	\N	0.00	inches	\N
1536	585	209	\N	\N	0.00	inches	\N
1537	661	210	\N	\N	0.00	inches	\N
1538	703	210	\N	\N	0.00	inches	\N
1539	684	208	\N	\N	0.00	inches	\N
1540	653	209	\N	\N	0.00	inches	\N
1541	700	209	\N	\N	0.00	inches	\N
1542	737	210	\N	\N	0.00	inches	\N
1543	743	210	\N	\N	0.00	inches	\N
1544	729	210	\N	\N	0.00	inches	\N
1545	509	186	\N	\N	62.00	inches	\N
1553	388	186	\N	\N	0.00	inches	\N
1546	522	186	\N	\N	62.00	inches	\N
1547	507	185	\N	\N	60.00	inches	\N
1548	564	185	\N	\N	0.00	inches	\N
1549	320	186	\N	\N	0.00	inches	\N
1550	344	186	\N	\N	0.00	inches	\N
1551	378	186	\N	\N	0.00	inches	\N
1552	345	184	\N	\N	0.00	inches	\N
1554	401	185	\N	\N	0.00	inches	\N
1555	403	185	\N	\N	0.00	inches	\N
1556	433	185	\N	\N	0.00	inches	\N
1557	570	186	\N	\N	0.00	inches	\N
1558	630	185	\N	\N	0.00	inches	\N
1559	690	185	\N	\N	0.00	inches	\N
1560	681	184	\N	\N	0.00	inches	\N
1561	665	184	\N	\N	0.00	inches	\N
1562	714	186	\N	\N	0.00	inches	\N
1563	733	186	\N	\N	0.00	inches	\N
1564	527	192	\N	\N	114.00	inches	\N
1568	376	192	\N	\N	0.00	inches	\N
1565	505	192	\N	\N	102.00	inches	\N
1566	493	192	\N	\N	102.00	inches	\N
1567	325	192	\N	\N	0.00	inches	\N
1569	330	190	\N	\N	0.00	inches	\N
1570	364	190	\N	\N	0.00	inches	\N
1571	388	192	\N	\N	0.00	inches	\N
1572	629	192	\N	\N	0.00	inches	\N
1573	590	191	\N	\N	0.00	inches	\N
1574	630	191	\N	\N	0.00	inches	\N
1575	622	190	\N	\N	0.00	inches	\N
1576	705	192	\N	\N	0.00	inches	\N
1577	690	191	\N	\N	0.00	inches	\N
1578	681	190	\N	\N	0.00	inches	\N
1579	509	198	\N	\N	210.00	inches	\N
1580	530	198	\N	\N	203.00	inches	\N
1581	491	197	\N	\N	198.50	inches	\N
1582	579	196	\N	\N	174.00	inches	\N
1583	522	198	\N	\N	171.00	inches	\N
1584	507	197	\N	\N	166.00	inches	\N
1585	575	196	\N	\N	166.00	inches	\N
1586	580	197	\N	\N	158.00	inches	\N
1587	508	198	\N	\N	148.00	inches	\N
1588	519	197	\N	\N	0.00	inches	\N
1589	329	198	\N	\N	0.00	inches	\N
1590	375	198	\N	\N	0.00	inches	\N
1591	343	197	\N	\N	0.00	inches	\N
1592	345	196	\N	\N	0.00	inches	\N
1593	360	197	\N	\N	0.00	inches	\N
1594	374	196	\N	\N	0.00	inches	\N
1595	332	197	\N	\N	0.00	inches	\N
1596	370	197	\N	\N	0.00	inches	\N
1597	412	198	\N	\N	0.00	inches	\N
1598	430	198	\N	\N	0.00	inches	\N
1599	401	197	\N	\N	0.00	inches	\N
1600	403	197	\N	\N	0.00	inches	\N
1601	402	197	\N	\N	0.00	inches	\N
1602	433	197	\N	\N	0.00	inches	\N
1603	451	197	\N	\N	0.00	inches	\N
1604	459	197	\N	\N	0.00	inches	\N
1605	475	198	\N	\N	0.00	inches	\N
1606	478	197	\N	\N	0.00	inches	\N
1607	467	197	\N	\N	0.00	inches	\N
1608	479	196	\N	\N	0.00	inches	\N
1609	534	198	\N	\N	0.00	inches	\N
1610	554	198	\N	\N	0.00	inches	\N
1611	629	198	\N	\N	0.00	inches	\N
1612	607	198	\N	\N	0.00	inches	\N
1613	705	198	\N	\N	0.00	inches	\N
1614	687	197	\N	\N	0.00	inches	\N
1615	659	198	\N	\N	0.00	inches	\N
1616	704	196	\N	\N	0.00	inches	\N
1617	714	198	\N	\N	0.00	inches	\N
1618	728	197	\N	\N	0.00	inches	\N
1619	732	198	\N	\N	0.00	inches	\N
1620	723	197	\N	\N	0.00	inches	\N
1621	733	198	\N	\N	0.00	inches	\N
1622	717	196	\N	\N	0.00	inches	\N
1623	721	198	\N	\N	0.00	inches	\N
1624	519	203	\N	\N	501.00	inches	\N
1662	428	257	\N	\N	99999999.00	seconds	\N
1625	509	204	\N	\N	467.00	inches	\N
1626	320	204	\N	\N	426.50	inches	\N
1663	408	257	\N	\N	99999999.00	seconds	\N
1627	530	204	\N	\N	420.50	inches	\N
1628	522	204	\N	\N	380.00	inches	\N
1664	416	256	\N	\N	99999999.00	seconds	\N
1629	511	204	\N	\N	379.00	inches	\N
1630	507	203	\N	\N	377.75	inches	\N
1665	420	256	\N	\N	99999999.00	seconds	\N
1631	508	204	\N	\N	347.00	inches	\N
1632	386	203	\N	\N	0.00	inches	\N
1633	359	204	\N	\N	0.00	inches	\N
1634	374	202	\N	\N	0.00	inches	\N
1635	412	204	\N	\N	0.00	inches	\N
1636	401	203	\N	\N	0.00	inches	\N
1637	403	203	\N	\N	0.00	inches	\N
1638	433	203	\N	\N	0.00	inches	\N
1639	451	203	\N	\N	0.00	inches	\N
1640	629	204	\N	\N	0.00	inches	\N
1641	607	204	\N	\N	0.00	inches	\N
1642	690	203	\N	\N	0.00	inches	\N
1643	714	204	\N	\N	0.00	inches	\N
1644	728	203	\N	\N	0.00	inches	\N
1645	732	204	\N	\N	0.00	inches	\N
1646	733	204	\N	\N	0.00	inches	\N
1647	645	258	\N	\N	12.15	seconds	\N
1666	423	257	\N	\N	99999999.00	seconds	\N
1648	647	257	\N	\N	13.50	seconds	\N
1649	632	258	\N	\N	14.00	seconds	\N
1667	424	256	\N	\N	99999999.00	seconds	\N
1650	588	258	\N	\N	14.50	seconds	\N
1651	584	257	\N	\N	14.59	seconds	\N
1668	456	256	\N	\N	99999999.00	seconds	\N
1652	764	256	\N	\N	14.88	seconds	\N
1653	578	257	\N	\N	14.97	seconds	\N
1669	447	258	\N	\N	99999999.00	seconds	\N
1654	429	258	\N	\N	14.98	seconds	\N
1655	452	258	\N	\N	15.15	seconds	\N
1670	394	256	\N	\N	99999999.00	seconds	\N
1656	489	258	\N	\N	15.84	seconds	\N
1657	586	257	\N	\N	16.15	seconds	\N
1658	328	256	\N	\N	99999999.00	seconds	\N
1659	349	258	\N	\N	99999999.00	seconds	\N
1660	357	257	\N	\N	99999999.00	seconds	\N
1661	760	256	\N	\N	99999999.00	seconds	\N
1671	763	256	\N	\N	99999999.00	seconds	\N
1672	464	256	\N	\N	99999999.00	seconds	\N
1673	477	257	\N	\N	99999999.00	seconds	\N
1674	557	257	\N	\N	99999999.00	seconds	\N
1675	537	258	\N	\N	99999999.00	seconds	\N
1676	594	256	\N	\N	99999999.00	seconds	\N
1677	621	257	\N	\N	99999999.00	seconds	\N
1678	614	257	\N	\N	99999999.00	seconds	\N
1679	620	256	\N	\N	99999999.00	seconds	\N
1680	577	258	\N	\N	99999999.00	seconds	\N
1681	767	256	\N	\N	99999999.00	seconds	\N
1682	574	256	\N	\N	99999999.00	seconds	\N
1683	573	256	\N	\N	99999999.00	seconds	\N
1684	631	258	\N	\N	99999999.00	seconds	\N
1685	641	258	\N	\N	99999999.00	seconds	\N
1686	635	257	\N	\N	99999999.00	seconds	\N
1687	640	257	\N	\N	99999999.00	seconds	\N
1688	644	257	\N	\N	99999999.00	seconds	\N
1689	702	257	\N	\N	99999999.00	seconds	\N
1690	701	257	\N	\N	99999999.00	seconds	\N
1691	654	256	\N	\N	99999999.00	seconds	\N
1692	706	256	\N	\N	99999999.00	seconds	\N
1693	674	256	\N	\N	99999999.00	seconds	\N
1694	658	256	\N	\N	99999999.00	seconds	\N
1695	660	256	\N	\N	99999999.00	seconds	\N
1696	686	256	\N	\N	99999999.00	seconds	\N
1697	679	257	\N	\N	99999999.00	seconds	\N
1698	649	258	\N	\N	99999999.00	seconds	\N
1699	695	256	\N	\N	99999999.00	seconds	\N
1700	735	258	\N	\N	99999999.00	seconds	\N
1701	719	258	\N	\N	99999999.00	seconds	\N
1702	742	257	\N	\N	99999999.00	seconds	\N
1703	710	256	\N	\N	99999999.00	seconds	\N
1704	713	257	\N	\N	99999999.00	seconds	\N
1705	720	256	\N	\N	99999999.00	seconds	\N
1706	736	256	\N	\N	99999999.00	seconds	\N
1707	738	258	\N	\N	99999999.00	seconds	\N
1708	741	258	\N	\N	99999999.00	seconds	\N
1709	745	256	\N	\N	99999999.00	seconds	\N
1710	645	276	\N	\N	24.88	seconds	\N
1714	328	274	\N	\N	99999999.00	seconds	\N
1711	569	275	\N	\N	32.77	seconds	\N
1712	586	275	\N	\N	34.60	seconds	\N
1713	384	275	\N	\N	99999999.00	seconds	\N
1715	342	274	\N	\N	99999999.00	seconds	\N
1716	358	274	\N	\N	99999999.00	seconds	\N
1717	385	274	\N	\N	99999999.00	seconds	\N
1718	347	274	\N	\N	99999999.00	seconds	\N
1719	755	276	\N	\N	99999999.00	seconds	\N
1720	760	274	\N	\N	99999999.00	seconds	\N
1721	452	276	\N	\N	99999999.00	seconds	\N
1722	428	275	\N	\N	99999999.00	seconds	\N
1723	408	275	\N	\N	99999999.00	seconds	\N
1724	416	274	\N	\N	99999999.00	seconds	\N
1725	420	274	\N	\N	99999999.00	seconds	\N
1726	424	274	\N	\N	99999999.00	seconds	\N
1727	764	274	\N	\N	99999999.00	seconds	\N
1728	456	274	\N	\N	99999999.00	seconds	\N
1729	447	276	\N	\N	99999999.00	seconds	\N
1730	394	274	\N	\N	99999999.00	seconds	\N
1731	763	274	\N	\N	99999999.00	seconds	\N
1732	464	274	\N	\N	99999999.00	seconds	\N
1733	477	275	\N	\N	99999999.00	seconds	\N
1734	557	275	\N	\N	99999999.00	seconds	\N
1735	537	276	\N	\N	99999999.00	seconds	\N
1736	627	276	\N	\N	99999999.00	seconds	\N
1737	623	276	\N	\N	99999999.00	seconds	\N
1738	611	275	\N	\N	99999999.00	seconds	\N
1739	594	274	\N	\N	99999999.00	seconds	\N
1740	628	276	\N	\N	99999999.00	seconds	\N
1741	620	274	\N	\N	99999999.00	seconds	\N
1742	583	276	\N	\N	99999999.00	seconds	\N
1743	581	275	\N	\N	99999999.00	seconds	\N
1744	578	275	\N	\N	99999999.00	seconds	\N
1745	588	276	\N	\N	99999999.00	seconds	\N
1746	767	274	\N	\N	99999999.00	seconds	\N
1747	574	274	\N	\N	99999999.00	seconds	\N
1748	573	274	\N	\N	99999999.00	seconds	\N
1749	637	275	\N	\N	99999999.00	seconds	\N
1750	643	276	\N	\N	99999999.00	seconds	\N
1751	644	275	\N	\N	99999999.00	seconds	\N
1752	708	275	\N	\N	99999999.00	seconds	\N
1753	702	275	\N	\N	99999999.00	seconds	\N
1754	701	275	\N	\N	99999999.00	seconds	\N
1755	654	274	\N	\N	99999999.00	seconds	\N
1756	706	274	\N	\N	99999999.00	seconds	\N
1757	660	274	\N	\N	99999999.00	seconds	\N
1758	663	274	\N	\N	99999999.00	seconds	\N
1759	649	276	\N	\N	99999999.00	seconds	\N
1760	695	274	\N	\N	99999999.00	seconds	\N
1761	731	276	\N	\N	99999999.00	seconds	\N
1762	735	276	\N	\N	99999999.00	seconds	\N
1763	719	276	\N	\N	99999999.00	seconds	\N
1764	725	276	\N	\N	99999999.00	seconds	\N
1765	710	274	\N	\N	99999999.00	seconds	\N
1766	730	276	\N	\N	99999999.00	seconds	\N
1767	736	274	\N	\N	99999999.00	seconds	\N
1768	745	274	\N	\N	99999999.00	seconds	\N
1811	323	262	\N	\N	99999999.00	seconds	\N
1769	645	252	\N	\N	57.50	seconds	\N
1770	569	251	\N	\N	74.11	seconds	\N
1812	341	262	\N	\N	99999999.00	seconds	\N
1771	529	252	\N	\N	75.35	seconds	\N
1772	335	251	\N	\N	99999999.00	seconds	\N
1773	367	251	\N	\N	99999999.00	seconds	\N
1774	342	250	\N	\N	99999999.00	seconds	\N
1775	353	251	\N	\N	99999999.00	seconds	\N
1776	358	250	\N	\N	99999999.00	seconds	\N
1777	385	250	\N	\N	99999999.00	seconds	\N
1778	347	250	\N	\N	99999999.00	seconds	\N
1779	380	250	\N	\N	99999999.00	seconds	\N
1780	755	252	\N	\N	99999999.00	seconds	\N
1781	408	251	\N	\N	99999999.00	seconds	\N
1782	420	250	\N	\N	99999999.00	seconds	\N
1783	424	250	\N	\N	99999999.00	seconds	\N
1784	394	250	\N	\N	99999999.00	seconds	\N
1785	462	252	\N	\N	99999999.00	seconds	\N
1786	469	250	\N	\N	99999999.00	seconds	\N
1787	489	252	\N	\N	99999999.00	seconds	\N
1788	623	252	\N	\N	99999999.00	seconds	\N
1789	611	251	\N	\N	99999999.00	seconds	\N
1790	581	251	\N	\N	99999999.00	seconds	\N
1791	584	251	\N	\N	99999999.00	seconds	\N
1792	637	251	\N	\N	99999999.00	seconds	\N
1793	708	251	\N	\N	99999999.00	seconds	\N
1794	702	251	\N	\N	99999999.00	seconds	\N
1795	654	250	\N	\N	99999999.00	seconds	\N
1796	676	250	\N	\N	99999999.00	seconds	\N
1797	660	250	\N	\N	99999999.00	seconds	\N
1798	740	252	\N	\N	99999999.00	seconds	\N
1799	587	264	\N	\N	147.00	seconds	\N
1813	362	262	\N	\N	99999999.00	seconds	\N
1800	549	262	\N	\N	176.00	seconds	\N
1801	553	263	\N	\N	178.00	seconds	\N
1814	366	262	\N	\N	99999999.00	seconds	\N
1802	521	264	\N	\N	178.18	seconds	\N
1803	556	263	\N	\N	179.82	seconds	\N
1815	353	263	\N	\N	99999999.00	seconds	\N
1804	314	262	\N	\N	182.70	seconds	\N
1805	311	264	\N	\N	183.23	seconds	\N
1816	759	264	\N	\N	99999999.00	seconds	\N
1806	541	264	\N	\N	200.00	seconds	\N
1807	318	263	\N	\N	99999999.00	seconds	\N
1808	310	263	\N	\N	99999999.00	seconds	\N
1809	335	263	\N	\N	99999999.00	seconds	\N
1810	367	263	\N	\N	99999999.00	seconds	\N
1817	419	264	\N	\N	99999999.00	seconds	\N
1818	392	262	\N	\N	99999999.00	seconds	\N
1819	422	264	\N	\N	99999999.00	seconds	\N
1820	455	262	\N	\N	99999999.00	seconds	\N
1821	462	264	\N	\N	99999999.00	seconds	\N
1822	474	264	\N	\N	99999999.00	seconds	\N
1823	469	262	\N	\N	99999999.00	seconds	\N
1824	499	264	\N	\N	99999999.00	seconds	\N
1825	492	263	\N	\N	99999999.00	seconds	\N
1826	606	264	\N	\N	99999999.00	seconds	\N
1827	595	263	\N	\N	99999999.00	seconds	\N
1828	624	264	\N	\N	99999999.00	seconds	\N
1829	583	264	\N	\N	99999999.00	seconds	\N
1830	581	263	\N	\N	99999999.00	seconds	\N
1831	639	264	\N	\N	99999999.00	seconds	\N
1832	642	264	\N	\N	99999999.00	seconds	\N
1833	688	264	\N	\N	99999999.00	seconds	\N
1834	694	264	\N	\N	99999999.00	seconds	\N
1835	651	264	\N	\N	99999999.00	seconds	\N
1836	672	263	\N	\N	99999999.00	seconds	\N
1837	697	263	\N	\N	99999999.00	seconds	\N
1838	707	263	\N	\N	99999999.00	seconds	\N
1839	678	263	\N	\N	99999999.00	seconds	\N
1840	683	262	\N	\N	99999999.00	seconds	\N
1841	676	262	\N	\N	99999999.00	seconds	\N
1842	711	263	\N	\N	99999999.00	seconds	\N
1843	587	228	\N	\N	298.53	seconds	\N
1845	492	227	\N	\N	380.60	seconds	\N
1844	549	226	\N	\N	371.68	seconds	\N
1855	318	227	\N	\N	99999999.00	seconds	\N
1846	521	228	\N	\N	384.25	seconds	\N
1847	553	227	\N	\N	387.50	seconds	\N
1856	314	226	\N	\N	99999999.00	seconds	\N
1848	556	227	\N	\N	390.00	seconds	\N
1849	486	228	\N	\N	390.43	seconds	\N
1857	310	227	\N	\N	99999999.00	seconds	\N
1850	499	228	\N	\N	390.76	seconds	\N
1851	540	227	\N	\N	408.42	seconds	\N
1858	323	226	\N	\N	99999999.00	seconds	\N
1852	311	228	\N	\N	411.96	seconds	\N
1853	545	226	\N	\N	421.00	seconds	\N
1859	341	226	\N	\N	99999999.00	seconds	\N
1854	541	228	\N	\N	440.33	seconds	\N
1860	362	226	\N	\N	99999999.00	seconds	\N
1861	366	226	\N	\N	99999999.00	seconds	\N
1862	759	228	\N	\N	99999999.00	seconds	\N
1863	419	228	\N	\N	99999999.00	seconds	\N
1864	392	226	\N	\N	99999999.00	seconds	\N
1865	422	228	\N	\N	99999999.00	seconds	\N
1866	455	226	\N	\N	99999999.00	seconds	\N
1867	474	228	\N	\N	99999999.00	seconds	\N
1868	469	226	\N	\N	99999999.00	seconds	\N
1869	606	228	\N	\N	99999999.00	seconds	\N
1870	595	227	\N	\N	99999999.00	seconds	\N
1871	624	228	\N	\N	99999999.00	seconds	\N
1872	639	228	\N	\N	99999999.00	seconds	\N
1873	642	228	\N	\N	99999999.00	seconds	\N
1874	688	228	\N	\N	99999999.00	seconds	\N
1875	694	228	\N	\N	99999999.00	seconds	\N
1876	651	228	\N	\N	99999999.00	seconds	\N
1877	672	227	\N	\N	99999999.00	seconds	\N
1878	697	227	\N	\N	99999999.00	seconds	\N
1879	707	227	\N	\N	99999999.00	seconds	\N
1880	678	227	\N	\N	99999999.00	seconds	\N
1881	683	226	\N	\N	99999999.00	seconds	\N
1882	734	226	\N	\N	99999999.00	seconds	\N
1883	688	282	\N	\N	99999999.00	seconds	\N
1884	694	282	\N	\N	99999999.00	seconds	\N
1885	672	281	\N	\N	99999999.00	seconds	\N
1886	697	281	\N	\N	99999999.00	seconds	\N
1887	707	281	\N	\N	99999999.00	seconds	\N
1888	678	281	\N	\N	99999999.00	seconds	\N
1889	683	280	\N	\N	99999999.00	seconds	\N
1950	525	318	\N	\N	865.00	inches	\N
1890	633	234	\N	\N	17.25	seconds	\N
1891	566	233	\N	\N	17.97	seconds	\N
1892	636	232	\N	\N	19.49	seconds	\N
1951	526	318	\N	\N	858.00	inches	\N
1893	517	234	\N	\N	20.17	seconds	\N
1894	496	234	\N	\N	21.01	seconds	\N
1985	626	294	\N	\N	0.00	inches	\N
1895	501	234	\N	\N	24.12	seconds	\N
1896	355	233	\N	\N	99999999.00	seconds	\N
1897	628	234	\N	\N	99999999.00	seconds	\N
1898	674	232	\N	\N	99999999.00	seconds	\N
1899	658	232	\N	\N	99999999.00	seconds	\N
1900	664	233	\N	\N	99999999.00	seconds	\N
1901	657	233	\N	\N	99999999.00	seconds	\N
1902	679	233	\N	\N	99999999.00	seconds	\N
1952	440	317	\N	\N	816.00	inches	\N
1903	633	270	\N	\N	53.11	seconds	\N
1904	566	269	\N	\N	53.64	seconds	\N
1905	636	268	\N	\N	55.73	seconds	\N
1953	461	318	\N	\N	779.00	inches	\N
1906	517	270	\N	\N	55.80	seconds	\N
1907	496	270	\N	\N	57.45	seconds	\N
1986	623	294	\N	\N	0.00	inches	\N
1908	501	270	\N	\N	62.30	seconds	\N
1909	355	269	\N	\N	99999999.00	seconds	\N
1910	380	268	\N	\N	99999999.00	seconds	\N
1911	617	269	\N	\N	99999999.00	seconds	\N
1912	638	269	\N	\N	99999999.00	seconds	\N
1913	664	269	\N	\N	99999999.00	seconds	\N
1914	657	269	\N	\N	99999999.00	seconds	\N
1915	679	269	\N	\N	99999999.00	seconds	\N
1954	448	316	\N	\N	644.00	inches	\N
1916	440	323	\N	\N	338.50	inches	\N
1917	448	322	\N	\N	330.50	inches	\N
1918	503	324	\N	\N	323.00	inches	\N
1955	500	317	\N	\N	582.00	inches	\N
1919	461	324	\N	\N	302.00	inches	\N
1920	523	324	\N	\N	282.00	inches	\N
1956	356	317	\N	\N	0.00	inches	\N
1921	526	324	\N	\N	266.00	inches	\N
1922	500	323	\N	\N	245.00	inches	\N
1923	315	323	\N	\N	0.00	inches	\N
1924	356	323	\N	\N	0.00	inches	\N
1925	326	322	\N	\N	0.00	inches	\N
1926	334	322	\N	\N	0.00	inches	\N
1927	357	323	\N	\N	0.00	inches	\N
1928	760	322	\N	\N	0.00	inches	\N
1929	404	324	\N	\N	0.00	inches	\N
1930	390	324	\N	\N	0.00	inches	\N
1931	426	324	\N	\N	0.00	inches	\N
1932	443	324	\N	\N	0.00	inches	\N
1933	406	323	\N	\N	0.00	inches	\N
1934	601	324	\N	\N	0.00	inches	\N
1935	646	324	\N	\N	0.00	inches	\N
1936	677	323	\N	\N	0.00	inches	\N
1937	666	324	\N	\N	0.00	inches	\N
1938	670	322	\N	\N	0.00	inches	\N
1939	686	322	\N	\N	0.00	inches	\N
1940	680	323	\N	\N	0.00	inches	\N
1941	675	323	\N	\N	0.00	inches	\N
1942	650	323	\N	\N	0.00	inches	\N
1943	667	324	\N	\N	0.00	inches	\N
1944	692	324	\N	\N	0.00	inches	\N
1945	731	324	\N	\N	0.00	inches	\N
1946	710	322	\N	\N	0.00	inches	\N
1947	738	324	\N	\N	0.00	inches	\N
1957	326	316	\N	\N	0.00	inches	\N
1948	503	318	\N	\N	1032.00	inches	\N
1949	523	318	\N	\N	871.00	inches	\N
1987	593	292	\N	\N	0.00	inches	\N
1958	334	316	\N	\N	0.00	inches	\N
1959	357	317	\N	\N	0.00	inches	\N
1960	404	318	\N	\N	0.00	inches	\N
1961	390	318	\N	\N	0.00	inches	\N
1962	426	318	\N	\N	0.00	inches	\N
1963	443	318	\N	\N	0.00	inches	\N
1964	406	317	\N	\N	0.00	inches	\N
1965	533	317	\N	\N	0.00	inches	\N
1966	601	318	\N	\N	0.00	inches	\N
1967	646	318	\N	\N	0.00	inches	\N
1968	677	317	\N	\N	0.00	inches	\N
1969	666	318	\N	\N	0.00	inches	\N
1970	670	316	\N	\N	0.00	inches	\N
1971	686	316	\N	\N	0.00	inches	\N
1972	680	317	\N	\N	0.00	inches	\N
1973	675	317	\N	\N	0.00	inches	\N
1974	650	317	\N	\N	0.00	inches	\N
1975	667	318	\N	\N	0.00	inches	\N
1976	692	318	\N	\N	0.00	inches	\N
1977	725	318	\N	\N	0.00	inches	\N
1978	633	294	\N	\N	54.00	inches	\N
1988	634	294	\N	\N	0.00	inches	\N
1979	487	293	\N	\N	52.00	inches	\N
1980	498	293	\N	\N	0.00	inches	\N
1981	333	294	\N	\N	0.00	inches	\N
1982	350	294	\N	\N	0.00	inches	\N
1983	380	292	\N	\N	0.00	inches	\N
1984	613	294	\N	\N	0.00	inches	\N
1989	644	293	\N	\N	0.00	inches	\N
1990	664	293	\N	\N	0.00	inches	\N
1991	667	294	\N	\N	0.00	inches	\N
1992	647	299	\N	\N	154.25	inches	\N
2001	664	299	\N	\N	0.00	inches	\N
1993	577	300	\N	\N	138.00	inches	\N
1994	634	300	\N	\N	114.00	inches	\N
2007	498	305	\N	\N	0.00	inches	\N
1995	501	300	\N	\N	78.00	inches	\N
2002	647	305	\N	\N	198.50	inches	\N
1996	489	300	\N	\N	66.00	inches	\N
1997	384	299	\N	\N	0.00	inches	\N
1998	342	298	\N	\N	0.00	inches	\N
1999	613	300	\N	\N	0.00	inches	\N
2000	601	300	\N	\N	0.00	inches	\N
2003	566	305	\N	\N	174.00	inches	\N
2008	533	305	\N	\N	0.00	inches	\N
2004	487	305	\N	\N	163.00	inches	\N
2005	536	306	\N	\N	123.50	inches	\N
2009	333	306	\N	\N	0.00	inches	\N
2006	524	305	\N	\N	118.00	inches	\N
2010	322	306	\N	\N	0.00	inches	\N
2011	328	304	\N	\N	0.00	inches	\N
2012	349	306	\N	\N	0.00	inches	\N
2013	347	304	\N	\N	0.00	inches	\N
2014	755	306	\N	\N	0.00	inches	\N
2015	760	304	\N	\N	0.00	inches	\N
2016	429	306	\N	\N	0.00	inches	\N
2017	452	306	\N	\N	0.00	inches	\N
2018	416	304	\N	\N	0.00	inches	\N
2019	424	304	\N	\N	0.00	inches	\N
2020	569	305	\N	\N	0.00	inches	\N
2021	613	306	\N	\N	0.00	inches	\N
2022	593	304	\N	\N	0.00	inches	\N
2023	620	304	\N	\N	0.00	inches	\N
2024	577	306	\N	\N	0.00	inches	\N
2025	574	304	\N	\N	0.00	inches	\N
2026	632	306	\N	\N	0.00	inches	\N
2027	638	305	\N	\N	0.00	inches	\N
2028	651	306	\N	\N	0.00	inches	\N
2029	701	305	\N	\N	0.00	inches	\N
2030	663	304	\N	\N	0.00	inches	\N
2031	649	306	\N	\N	0.00	inches	\N
2032	742	305	\N	\N	0.00	inches	\N
2033	713	305	\N	\N	0.00	inches	\N
2034	730	306	\N	\N	0.00	inches	\N
2098	465	253	\N	\N	99999999.00	seconds	\N
2035	634	312	\N	\N	430.50	inches	\N
2036	633	312	\N	\N	385.00	inches	\N
2099	476	253	\N	\N	99999999.00	seconds	\N
2037	533	311	\N	\N	359.50	inches	\N
2038	636	310	\N	\N	329.00	inches	\N
2100	471	253	\N	\N	99999999.00	seconds	\N
2039	536	312	\N	\N	299.00	inches	\N
2040	524	311	\N	\N	249.50	inches	\N
2041	498	311	\N	\N	0.00	inches	\N
2042	322	312	\N	\N	0.00	inches	\N
2043	755	312	\N	\N	0.00	inches	\N
2044	429	312	\N	\N	0.00	inches	\N
2045	408	311	\N	\N	0.00	inches	\N
2046	626	312	\N	\N	0.00	inches	\N
2047	632	312	\N	\N	0.00	inches	\N
2048	638	311	\N	\N	0.00	inches	\N
2101	473	253	\N	\N	99999999.00	seconds	\N
2049	597	255	\N	\N	11.60	seconds	\N
2050	520	255	\N	\N	11.88	seconds	\N
2102	479	253	\N	\N	99999999.00	seconds	\N
2051	391	255	\N	\N	12.54	seconds	\N
2052	435	255	\N	\N	12.60	seconds	\N
2103	484	253	\N	\N	99999999.00	seconds	\N
2053	438	255	\N	\N	12.72	seconds	\N
2054	530	255	\N	\N	12.72	seconds	\N
2104	551	255	\N	\N	99999999.00	seconds	\N
2055	564	254	\N	\N	13.36	seconds	\N
2056	575	253	\N	\N	13.64	seconds	\N
2105	558	255	\N	\N	99999999.00	seconds	\N
2057	395	254	\N	\N	13.97	seconds	\N
2058	502	254	\N	\N	14.07	seconds	\N
2059	309	255	\N	\N	99999999.00	seconds	\N
2060	381	255	\N	\N	99999999.00	seconds	\N
2061	354	255	\N	\N	99999999.00	seconds	\N
2062	383	255	\N	\N	99999999.00	seconds	\N
2063	327	254	\N	\N	99999999.00	seconds	\N
2064	348	254	\N	\N	99999999.00	seconds	\N
2065	386	254	\N	\N	99999999.00	seconds	\N
2066	331	254	\N	\N	99999999.00	seconds	\N
2067	340	255	\N	\N	99999999.00	seconds	\N
2068	343	254	\N	\N	99999999.00	seconds	\N
2069	345	253	\N	\N	99999999.00	seconds	\N
2070	368	254	\N	\N	99999999.00	seconds	\N
2071	382	255	\N	\N	99999999.00	seconds	\N
2072	324	255	\N	\N	99999999.00	seconds	\N
2073	330	253	\N	\N	99999999.00	seconds	\N
2074	332	254	\N	\N	99999999.00	seconds	\N
2075	338	253	\N	\N	99999999.00	seconds	\N
2076	364	253	\N	\N	99999999.00	seconds	\N
2077	370	254	\N	\N	99999999.00	seconds	\N
2078	757	255	\N	\N	99999999.00	seconds	\N
2079	758	254	\N	\N	99999999.00	seconds	\N
2080	402	254	\N	\N	99999999.00	seconds	\N
2081	398	255	\N	\N	99999999.00	seconds	\N
2082	407	255	\N	\N	99999999.00	seconds	\N
2083	421	253	\N	\N	99999999.00	seconds	\N
2084	437	255	\N	\N	99999999.00	seconds	\N
2085	439	253	\N	\N	99999999.00	seconds	\N
2086	446	253	\N	\N	99999999.00	seconds	\N
2087	457	255	\N	\N	99999999.00	seconds	\N
2088	427	255	\N	\N	99999999.00	seconds	\N
2089	762	253	\N	\N	99999999.00	seconds	\N
2090	444	255	\N	\N	99999999.00	seconds	\N
2091	482	255	\N	\N	99999999.00	seconds	\N
2092	475	255	\N	\N	99999999.00	seconds	\N
2093	485	255	\N	\N	99999999.00	seconds	\N
2094	478	254	\N	\N	99999999.00	seconds	\N
2095	463	254	\N	\N	99999999.00	seconds	\N
2096	480	254	\N	\N	99999999.00	seconds	\N
2097	467	254	\N	\N	99999999.00	seconds	\N
2106	548	254	\N	\N	99999999.00	seconds	\N
2107	552	255	\N	\N	99999999.00	seconds	\N
2108	546	255	\N	\N	99999999.00	seconds	\N
2109	563	254	\N	\N	99999999.00	seconds	\N
2110	565	253	\N	\N	99999999.00	seconds	\N
2111	599	254	\N	\N	99999999.00	seconds	\N
2112	596	253	\N	\N	99999999.00	seconds	\N
2113	605	253	\N	\N	99999999.00	seconds	\N
2114	591	253	\N	\N	99999999.00	seconds	\N
2115	604	253	\N	\N	99999999.00	seconds	\N
2116	582	255	\N	\N	99999999.00	seconds	\N
2117	580	254	\N	\N	99999999.00	seconds	\N
2118	669	255	\N	\N	99999999.00	seconds	\N
2119	699	254	\N	\N	99999999.00	seconds	\N
2120	682	254	\N	\N	99999999.00	seconds	\N
2121	652	253	\N	\N	99999999.00	seconds	\N
2122	655	253	\N	\N	99999999.00	seconds	\N
2123	693	253	\N	\N	99999999.00	seconds	\N
2124	681	253	\N	\N	99999999.00	seconds	\N
2125	685	253	\N	\N	99999999.00	seconds	\N
2126	659	255	\N	\N	99999999.00	seconds	\N
2127	709	255	\N	\N	99999999.00	seconds	\N
2128	665	253	\N	\N	99999999.00	seconds	\N
2129	689	255	\N	\N	99999999.00	seconds	\N
2130	704	253	\N	\N	99999999.00	seconds	\N
2131	728	254	\N	\N	99999999.00	seconds	\N
2132	715	255	\N	\N	99999999.00	seconds	\N
2133	723	254	\N	\N	99999999.00	seconds	\N
2134	729	255	\N	\N	99999999.00	seconds	\N
2135	726	255	\N	\N	99999999.00	seconds	\N
2136	716	253	\N	\N	99999999.00	seconds	\N
2137	718	253	\N	\N	99999999.00	seconds	\N
2138	721	255	\N	\N	99999999.00	seconds	\N
2148	386	272	\N	\N	99999999.00	seconds	\N
2139	597	273	\N	\N	23.00	seconds	\N
2140	520	273	\N	\N	24.39	seconds	\N
2149	331	272	\N	\N	99999999.00	seconds	\N
2141	580	272	\N	\N	26.72	seconds	\N
2142	575	271	\N	\N	27.24	seconds	\N
2143	511	273	\N	\N	99999999.00	seconds	\N
2144	309	273	\N	\N	99999999.00	seconds	\N
2145	354	273	\N	\N	99999999.00	seconds	\N
2146	383	273	\N	\N	99999999.00	seconds	\N
2147	348	272	\N	\N	99999999.00	seconds	\N
2150	340	273	\N	\N	99999999.00	seconds	\N
2151	346	271	\N	\N	99999999.00	seconds	\N
2152	368	272	\N	\N	99999999.00	seconds	\N
2153	371	273	\N	\N	99999999.00	seconds	\N
2154	382	273	\N	\N	99999999.00	seconds	\N
2155	330	271	\N	\N	99999999.00	seconds	\N
2156	332	272	\N	\N	99999999.00	seconds	\N
2157	338	271	\N	\N	99999999.00	seconds	\N
2158	370	272	\N	\N	99999999.00	seconds	\N
2159	388	273	\N	\N	99999999.00	seconds	\N
2160	757	273	\N	\N	99999999.00	seconds	\N
2161	758	272	\N	\N	99999999.00	seconds	\N
2162	412	273	\N	\N	99999999.00	seconds	\N
2163	435	273	\N	\N	99999999.00	seconds	\N
2164	430	273	\N	\N	99999999.00	seconds	\N
2165	402	272	\N	\N	99999999.00	seconds	\N
2166	425	273	\N	\N	99999999.00	seconds	\N
2167	395	272	\N	\N	99999999.00	seconds	\N
2168	398	273	\N	\N	99999999.00	seconds	\N
2169	407	273	\N	\N	99999999.00	seconds	\N
2170	421	271	\N	\N	99999999.00	seconds	\N
2171	438	273	\N	\N	99999999.00	seconds	\N
2172	446	271	\N	\N	99999999.00	seconds	\N
2173	451	272	\N	\N	99999999.00	seconds	\N
2174	457	273	\N	\N	99999999.00	seconds	\N
2175	459	272	\N	\N	99999999.00	seconds	\N
2176	762	271	\N	\N	99999999.00	seconds	\N
2177	444	273	\N	\N	99999999.00	seconds	\N
2178	482	273	\N	\N	99999999.00	seconds	\N
2179	485	273	\N	\N	99999999.00	seconds	\N
2180	463	272	\N	\N	99999999.00	seconds	\N
2181	480	272	\N	\N	99999999.00	seconds	\N
2182	465	271	\N	\N	99999999.00	seconds	\N
2183	476	271	\N	\N	99999999.00	seconds	\N
2184	471	271	\N	\N	99999999.00	seconds	\N
2185	473	271	\N	\N	99999999.00	seconds	\N
2186	484	271	\N	\N	99999999.00	seconds	\N
2187	502	272	\N	\N	99999999.00	seconds	\N
2188	551	273	\N	\N	99999999.00	seconds	\N
2189	558	273	\N	\N	99999999.00	seconds	\N
2190	544	273	\N	\N	99999999.00	seconds	\N
2191	548	272	\N	\N	99999999.00	seconds	\N
2192	552	273	\N	\N	99999999.00	seconds	\N
2193	546	273	\N	\N	99999999.00	seconds	\N
2194	565	271	\N	\N	99999999.00	seconds	\N
2195	599	272	\N	\N	99999999.00	seconds	\N
2196	768	273	\N	\N	99999999.00	seconds	\N
2197	596	271	\N	\N	99999999.00	seconds	\N
2198	603	273	\N	\N	99999999.00	seconds	\N
2199	605	271	\N	\N	99999999.00	seconds	\N
2200	572	273	\N	\N	99999999.00	seconds	\N
2201	571	271	\N	\N	99999999.00	seconds	\N
2202	582	273	\N	\N	99999999.00	seconds	\N
2203	579	271	\N	\N	99999999.00	seconds	\N
2204	669	273	\N	\N	99999999.00	seconds	\N
2205	699	272	\N	\N	99999999.00	seconds	\N
2206	682	272	\N	\N	99999999.00	seconds	\N
2207	652	271	\N	\N	99999999.00	seconds	\N
2208	655	271	\N	\N	99999999.00	seconds	\N
2209	693	271	\N	\N	99999999.00	seconds	\N
2210	685	271	\N	\N	99999999.00	seconds	\N
2211	687	272	\N	\N	99999999.00	seconds	\N
2212	668	272	\N	\N	99999999.00	seconds	\N
2213	659	273	\N	\N	99999999.00	seconds	\N
2214	671	273	\N	\N	99999999.00	seconds	\N
2215	709	273	\N	\N	99999999.00	seconds	\N
2216	689	273	\N	\N	99999999.00	seconds	\N
2217	704	271	\N	\N	99999999.00	seconds	\N
2218	715	273	\N	\N	99999999.00	seconds	\N
2219	723	272	\N	\N	99999999.00	seconds	\N
2220	726	273	\N	\N	99999999.00	seconds	\N
2221	716	271	\N	\N	99999999.00	seconds	\N
2222	718	271	\N	\N	99999999.00	seconds	\N
2223	749	272	\N	\N	99999999.00	seconds	\N
2224	748	272	\N	\N	99999999.00	seconds	\N
2246	758	248	\N	\N	99999999.00	seconds	\N
2225	312	249	\N	\N	55.66	seconds	\N
2226	749	248	\N	\N	56.66	seconds	\N
2247	412	249	\N	\N	99999999.00	seconds	\N
2227	495	248	\N	\N	57.54	seconds	\N
2228	531	249	\N	\N	57.59	seconds	\N
2248	430	249	\N	\N	99999999.00	seconds	\N
2229	748	248	\N	\N	58.51	seconds	\N
2230	766	249	\N	\N	60.00	seconds	\N
2249	425	249	\N	\N	99999999.00	seconds	\N
2231	544	249	\N	\N	61.00	seconds	\N
2232	571	247	\N	\N	61.76	seconds	\N
2250	398	249	\N	\N	99999999.00	seconds	\N
2233	579	247	\N	\N	62.00	seconds	\N
2234	542	249	\N	\N	63.00	seconds	\N
2251	407	249	\N	\N	99999999.00	seconds	\N
2235	319	249	\N	\N	66.42	seconds	\N
2236	316	248	\N	\N	99999999.00	seconds	\N
2237	325	249	\N	\N	99999999.00	seconds	\N
2238	352	249	\N	\N	99999999.00	seconds	\N
2239	363	249	\N	\N	99999999.00	seconds	\N
2240	375	249	\N	\N	99999999.00	seconds	\N
2241	346	247	\N	\N	99999999.00	seconds	\N
2242	360	248	\N	\N	99999999.00	seconds	\N
2243	371	249	\N	\N	99999999.00	seconds	\N
2244	364	247	\N	\N	99999999.00	seconds	\N
2245	756	249	\N	\N	99999999.00	seconds	\N
2252	459	248	\N	\N	99999999.00	seconds	\N
2253	472	247	\N	\N	99999999.00	seconds	\N
2254	570	249	\N	\N	99999999.00	seconds	\N
2255	563	248	\N	\N	99999999.00	seconds	\N
2256	567	247	\N	\N	99999999.00	seconds	\N
2257	561	247	\N	\N	99999999.00	seconds	\N
2258	768	249	\N	\N	99999999.00	seconds	\N
2259	622	247	\N	\N	99999999.00	seconds	\N
2260	603	249	\N	\N	99999999.00	seconds	\N
2261	591	247	\N	\N	99999999.00	seconds	\N
2262	576	248	\N	\N	99999999.00	seconds	\N
2263	652	247	\N	\N	99999999.00	seconds	\N
2264	681	247	\N	\N	99999999.00	seconds	\N
2265	685	247	\N	\N	99999999.00	seconds	\N
2266	687	248	\N	\N	99999999.00	seconds	\N
2267	668	248	\N	\N	99999999.00	seconds	\N
2268	671	249	\N	\N	99999999.00	seconds	\N
2269	689	249	\N	\N	99999999.00	seconds	\N
2270	704	247	\N	\N	99999999.00	seconds	\N
2271	712	249	\N	\N	99999999.00	seconds	\N
2272	727	249	\N	\N	99999999.00	seconds	\N
2273	722	249	\N	\N	99999999.00	seconds	\N
2278	514	259	\N	\N	136.62	seconds	\N
2274	516	261	\N	\N	119.70	seconds	\N
2275	312	261	\N	\N	131.96	seconds	\N
2276	493	261	\N	\N	134.70	seconds	\N
2279	560	261	\N	\N	143.00	seconds	\N
2277	555	260	\N	\N	135.00	seconds	\N
2289	538	260	\N	\N	168.00	seconds	\N
2280	547	260	\N	\N	143.00	seconds	\N
2281	543	261	\N	\N	144.00	seconds	\N
2297	352	261	\N	\N	99999999.00	seconds	\N
2282	531	261	\N	\N	144.02	seconds	\N
2290	319	261	\N	\N	173.13	seconds	\N
2283	572	261	\N	\N	145.30	seconds	\N
2284	582	261	\N	\N	145.75	seconds	\N
2285	550	259	\N	\N	148.00	seconds	\N
2291	567	259	\N	\N	191.45	seconds	\N
2286	559	260	\N	\N	152.00	seconds	\N
2287	317	261	\N	\N	158.82	seconds	\N
2298	363	261	\N	\N	99999999.00	seconds	\N
2288	504	260	\N	\N	158.96	seconds	\N
2292	539	260	\N	\N	240.00	seconds	\N
2293	308	261	\N	\N	99999999.00	seconds	\N
2294	307	260	\N	\N	99999999.00	seconds	\N
2295	306	259	\N	\N	99999999.00	seconds	\N
2296	316	260	\N	\N	99999999.00	seconds	\N
2299	375	261	\N	\N	99999999.00	seconds	\N
2300	381	261	\N	\N	99999999.00	seconds	\N
2301	336	260	\N	\N	99999999.00	seconds	\N
2302	387	261	\N	\N	99999999.00	seconds	\N
2303	372	259	\N	\N	99999999.00	seconds	\N
2304	337	259	\N	\N	99999999.00	seconds	\N
2305	339	259	\N	\N	99999999.00	seconds	\N
2306	351	259	\N	\N	99999999.00	seconds	\N
2307	365	259	\N	\N	99999999.00	seconds	\N
2308	756	261	\N	\N	99999999.00	seconds	\N
2309	761	260	\N	\N	99999999.00	seconds	\N
2310	409	261	\N	\N	99999999.00	seconds	\N
2311	411	260	\N	\N	99999999.00	seconds	\N
2312	436	260	\N	\N	99999999.00	seconds	\N
2313	449	261	\N	\N	99999999.00	seconds	\N
2314	458	261	\N	\N	99999999.00	seconds	\N
2315	432	261	\N	\N	99999999.00	seconds	\N
2316	413	261	\N	\N	99999999.00	seconds	\N
2317	389	261	\N	\N	99999999.00	seconds	\N
2318	399	260	\N	\N	99999999.00	seconds	\N
2319	410	259	\N	\N	99999999.00	seconds	\N
2320	400	259	\N	\N	99999999.00	seconds	\N
2321	405	261	\N	\N	99999999.00	seconds	\N
2322	450	259	\N	\N	99999999.00	seconds	\N
2323	393	261	\N	\N	99999999.00	seconds	\N
2324	442	261	\N	\N	99999999.00	seconds	\N
2325	417	260	\N	\N	99999999.00	seconds	\N
2326	765	260	\N	\N	99999999.00	seconds	\N
2327	481	261	\N	\N	99999999.00	seconds	\N
2328	470	260	\N	\N	99999999.00	seconds	\N
2329	466	261	\N	\N	99999999.00	seconds	\N
2330	472	259	\N	\N	99999999.00	seconds	\N
2331	490	261	\N	\N	99999999.00	seconds	\N
2332	510	260	\N	\N	99999999.00	seconds	\N
2333	562	260	\N	\N	99999999.00	seconds	\N
2334	568	261	\N	\N	99999999.00	seconds	\N
2335	600	261	\N	\N	99999999.00	seconds	\N
2336	612	261	\N	\N	99999999.00	seconds	\N
2337	610	261	\N	\N	99999999.00	seconds	\N
2338	592	260	\N	\N	99999999.00	seconds	\N
2339	619	259	\N	\N	99999999.00	seconds	\N
2340	625	259	\N	\N	99999999.00	seconds	\N
2341	609	259	\N	\N	99999999.00	seconds	\N
2342	615	259	\N	\N	99999999.00	seconds	\N
2343	608	259	\N	\N	99999999.00	seconds	\N
2344	576	260	\N	\N	99999999.00	seconds	\N
2345	705	261	\N	\N	99999999.00	seconds	\N
2346	696	260	\N	\N	99999999.00	seconds	\N
2347	673	260	\N	\N	99999999.00	seconds	\N
2348	698	259	\N	\N	99999999.00	seconds	\N
2349	648	259	\N	\N	99999999.00	seconds	\N
2350	691	259	\N	\N	99999999.00	seconds	\N
2351	662	261	\N	\N	99999999.00	seconds	\N
2352	744	261	\N	\N	99999999.00	seconds	\N
2353	746	261	\N	\N	99999999.00	seconds	\N
2354	739	261	\N	\N	99999999.00	seconds	\N
2355	743	261	\N	\N	99999999.00	seconds	\N
2356	717	259	\N	\N	99999999.00	seconds	\N
2357	753	261	\N	\N	99999999.00	seconds	\N
2358	752	260	\N	\N	99999999.00	seconds	\N
2359	514	223	\N	\N	253.86	seconds	\N
2385	336	224	\N	\N	99999999.00	seconds	\N
2360	516	225	\N	\N	265.88	seconds	\N
2361	592	224	\N	\N	272.96	seconds	\N
2386	387	225	\N	\N	99999999.00	seconds	\N
2362	753	225	\N	\N	276.92	seconds	\N
2363	747	225	\N	\N	283.75	seconds	\N
2387	372	223	\N	\N	99999999.00	seconds	\N
2364	752	224	\N	\N	283.75	seconds	\N
2365	555	224	\N	\N	287.21	seconds	\N
2388	337	223	\N	\N	99999999.00	seconds	\N
2366	612	225	\N	\N	290.00	seconds	\N
2367	625	223	\N	\N	290.58	seconds	\N
2389	339	223	\N	\N	99999999.00	seconds	\N
2368	493	225	\N	\N	294.65	seconds	\N
2369	490	225	\N	\N	295.99	seconds	\N
2390	351	223	\N	\N	99999999.00	seconds	\N
2370	308	225	\N	\N	305.37	seconds	\N
2371	547	224	\N	\N	306.96	seconds	\N
2391	365	223	\N	\N	99999999.00	seconds	\N
2372	560	225	\N	\N	307.48	seconds	\N
2373	543	225	\N	\N	307.76	seconds	\N
2392	756	225	\N	\N	99999999.00	seconds	\N
2374	550	223	\N	\N	319.22	seconds	\N
2375	559	224	\N	\N	329.61	seconds	\N
2393	761	224	\N	\N	99999999.00	seconds	\N
2376	317	225	\N	\N	345.08	seconds	\N
2377	538	224	\N	\N	358.51	seconds	\N
2394	409	225	\N	\N	99999999.00	seconds	\N
2378	504	224	\N	\N	362.44	seconds	\N
2379	535	225	\N	\N	370.08	seconds	\N
2395	411	224	\N	\N	99999999.00	seconds	\N
2380	554	225	\N	\N	390.00	seconds	\N
2381	568	225	\N	\N	396.33	seconds	\N
2382	307	224	\N	\N	99999999.00	seconds	\N
2383	306	223	\N	\N	99999999.00	seconds	\N
2384	316	224	\N	\N	99999999.00	seconds	\N
2396	436	224	\N	\N	99999999.00	seconds	\N
2397	449	225	\N	\N	99999999.00	seconds	\N
2398	458	225	\N	\N	99999999.00	seconds	\N
2399	432	225	\N	\N	99999999.00	seconds	\N
2400	413	225	\N	\N	99999999.00	seconds	\N
2401	389	225	\N	\N	99999999.00	seconds	\N
2402	399	224	\N	\N	99999999.00	seconds	\N
2403	410	223	\N	\N	99999999.00	seconds	\N
2404	400	223	\N	\N	99999999.00	seconds	\N
2405	434	224	\N	\N	99999999.00	seconds	\N
2406	405	225	\N	\N	99999999.00	seconds	\N
2407	450	223	\N	\N	99999999.00	seconds	\N
2408	393	225	\N	\N	99999999.00	seconds	\N
2409	442	225	\N	\N	99999999.00	seconds	\N
2410	417	224	\N	\N	99999999.00	seconds	\N
2411	765	224	\N	\N	99999999.00	seconds	\N
2412	481	225	\N	\N	99999999.00	seconds	\N
2413	470	224	\N	\N	99999999.00	seconds	\N
2414	467	224	\N	\N	99999999.00	seconds	\N
2415	466	225	\N	\N	99999999.00	seconds	\N
2416	472	223	\N	\N	99999999.00	seconds	\N
2417	483	224	\N	\N	99999999.00	seconds	\N
2418	567	223	\N	\N	99999999.00	seconds	\N
2419	561	223	\N	\N	99999999.00	seconds	\N
2420	600	225	\N	\N	99999999.00	seconds	\N
2421	610	225	\N	\N	99999999.00	seconds	\N
2422	619	223	\N	\N	99999999.00	seconds	\N
2423	609	223	\N	\N	99999999.00	seconds	\N
2424	615	223	\N	\N	99999999.00	seconds	\N
2425	608	223	\N	\N	99999999.00	seconds	\N
2426	589	223	\N	\N	99999999.00	seconds	\N
2427	696	224	\N	\N	99999999.00	seconds	\N
2428	673	224	\N	\N	99999999.00	seconds	\N
2429	698	223	\N	\N	99999999.00	seconds	\N
2430	648	223	\N	\N	99999999.00	seconds	\N
2431	691	223	\N	\N	99999999.00	seconds	\N
2432	662	225	\N	\N	99999999.00	seconds	\N
2433	744	225	\N	\N	99999999.00	seconds	\N
2434	746	225	\N	\N	99999999.00	seconds	\N
2435	739	225	\N	\N	99999999.00	seconds	\N
2436	717	223	\N	\N	99999999.00	seconds	\N
2437	751	225	\N	\N	99999999.00	seconds	\N
2438	750	225	\N	\N	99999999.00	seconds	\N
2439	754	223	\N	\N	99999999.00	seconds	\N
2440	673	278	\N	\N	99999999.00	seconds	\N
2441	648	277	\N	\N	99999999.00	seconds	\N
2442	662	279	\N	\N	99999999.00	seconds	\N
2445	513	237	\N	\N	23.20	seconds	\N
2443	527	237	\N	\N	18.94	seconds	\N
2444	494	237	\N	\N	21.21	seconds	\N
2446	378	237	\N	\N	99999999.00	seconds	\N
2447	376	237	\N	\N	99999999.00	seconds	\N
2448	340	237	\N	\N	99999999.00	seconds	\N
2449	343	236	\N	\N	99999999.00	seconds	\N
2450	338	235	\N	\N	99999999.00	seconds	\N
2451	391	237	\N	\N	99999999.00	seconds	\N
2452	396	237	\N	\N	99999999.00	seconds	\N
2453	478	236	\N	\N	99999999.00	seconds	\N
2454	491	236	\N	\N	99999999.00	seconds	\N
2455	607	237	\N	\N	99999999.00	seconds	\N
2456	604	235	\N	\N	99999999.00	seconds	\N
2457	690	236	\N	\N	99999999.00	seconds	\N
2458	656	237	\N	\N	99999999.00	seconds	\N
2459	727	237	\N	\N	99999999.00	seconds	\N
2460	527	267	\N	\N	48.60	seconds	\N
2461	491	266	\N	\N	48.99	seconds	\N
2462	570	267	\N	\N	49.98	seconds	\N
2463	494	267	\N	\N	51.49	seconds	\N
2464	378	267	\N	\N	99999999.00	seconds	\N
2465	374	265	\N	\N	99999999.00	seconds	\N
2466	324	267	\N	\N	99999999.00	seconds	\N
2467	391	267	\N	\N	99999999.00	seconds	\N
2468	396	267	\N	\N	99999999.00	seconds	\N
2469	434	266	\N	\N	99999999.00	seconds	\N
2470	481	267	\N	\N	99999999.00	seconds	\N
2471	478	266	\N	\N	99999999.00	seconds	\N
2472	495	266	\N	\N	99999999.00	seconds	\N
2473	607	267	\N	\N	99999999.00	seconds	\N
2474	727	267	\N	\N	99999999.00	seconds	\N
2475	722	267	\N	\N	99999999.00	seconds	\N
2476	497	321	\N	\N	475.50	inches	\N
2534	414	314	\N	\N	0.00	inches	\N
2477	518	321	\N	\N	467.00	inches	\N
2478	512	321	\N	\N	407.00	inches	\N
2535	445	315	\N	\N	0.00	inches	\N
2479	532	321	\N	\N	388.00	inches	\N
2480	488	320	\N	\N	335.50	inches	\N
2536	431	315	\N	\N	0.00	inches	\N
2481	506	321	\N	\N	331.50	inches	\N
2482	313	321	\N	\N	0.00	inches	\N
2483	344	321	\N	\N	0.00	inches	\N
2484	329	321	\N	\N	0.00	inches	\N
2485	375	321	\N	\N	0.00	inches	\N
2486	373	321	\N	\N	0.00	inches	\N
2487	321	321	\N	\N	0.00	inches	\N
2488	327	320	\N	\N	0.00	inches	\N
2489	361	319	\N	\N	0.00	inches	\N
2490	377	321	\N	\N	0.00	inches	\N
2491	757	321	\N	\N	0.00	inches	\N
2492	453	321	\N	\N	0.00	inches	\N
2493	415	320	\N	\N	0.00	inches	\N
2494	460	320	\N	\N	0.00	inches	\N
2495	414	320	\N	\N	0.00	inches	\N
2496	397	320	\N	\N	0.00	inches	\N
2497	445	321	\N	\N	0.00	inches	\N
2498	431	321	\N	\N	0.00	inches	\N
2499	441	320	\N	\N	0.00	inches	\N
2500	468	319	\N	\N	0.00	inches	\N
2501	554	321	\N	\N	0.00	inches	\N
2502	563	320	\N	\N	0.00	inches	\N
2503	618	321	\N	\N	0.00	inches	\N
2504	598	319	\N	\N	0.00	inches	\N
2505	585	320	\N	\N	0.00	inches	\N
2506	661	321	\N	\N	0.00	inches	\N
2507	703	321	\N	\N	0.00	inches	\N
2508	684	319	\N	\N	0.00	inches	\N
2509	653	320	\N	\N	0.00	inches	\N
2510	700	320	\N	\N	0.00	inches	\N
2511	737	321	\N	\N	0.00	inches	\N
2512	729	321	\N	\N	0.00	inches	\N
2513	497	315	\N	\N	1441.00	inches	\N
2537	441	314	\N	\N	0.00	inches	\N
2514	460	314	\N	\N	1315.00	inches	\N
2515	518	315	\N	\N	1224.00	inches	\N
2538	468	313	\N	\N	0.00	inches	\N
2516	532	315	\N	\N	1146.00	inches	\N
2517	512	315	\N	\N	1087.00	inches	\N
2539	542	315	\N	\N	0.00	inches	\N
2518	506	315	\N	\N	1018.00	inches	\N
2519	488	314	\N	\N	903.00	inches	\N
2540	554	315	\N	\N	0.00	inches	\N
2520	564	314	\N	\N	883.00	inches	\N
2521	397	314	\N	\N	810.00	inches	\N
2522	313	315	\N	\N	0.00	inches	\N
2523	320	315	\N	\N	0.00	inches	\N
2524	344	315	\N	\N	0.00	inches	\N
2525	329	315	\N	\N	0.00	inches	\N
2526	373	315	\N	\N	0.00	inches	\N
2527	321	315	\N	\N	0.00	inches	\N
2528	327	314	\N	\N	0.00	inches	\N
2529	361	313	\N	\N	0.00	inches	\N
2530	377	315	\N	\N	0.00	inches	\N
2531	379	313	\N	\N	0.00	inches	\N
2532	453	315	\N	\N	0.00	inches	\N
2533	415	314	\N	\N	0.00	inches	\N
2541	618	315	\N	\N	0.00	inches	\N
2542	598	313	\N	\N	0.00	inches	\N
2543	585	314	\N	\N	0.00	inches	\N
2544	661	315	\N	\N	0.00	inches	\N
2545	703	315	\N	\N	0.00	inches	\N
2546	684	313	\N	\N	0.00	inches	\N
2547	653	314	\N	\N	0.00	inches	\N
2548	700	314	\N	\N	0.00	inches	\N
2549	737	315	\N	\N	0.00	inches	\N
2550	743	315	\N	\N	0.00	inches	\N
2551	729	315	\N	\N	0.00	inches	\N
2552	509	291	\N	\N	62.00	inches	\N
2569	665	289	\N	\N	0.00	inches	\N
2553	522	291	\N	\N	62.00	inches	\N
2554	507	290	\N	\N	60.00	inches	\N
2555	564	290	\N	\N	0.00	inches	\N
2556	320	291	\N	\N	0.00	inches	\N
2557	344	291	\N	\N	0.00	inches	\N
2558	378	291	\N	\N	0.00	inches	\N
2559	345	289	\N	\N	0.00	inches	\N
2560	388	291	\N	\N	0.00	inches	\N
2561	401	290	\N	\N	0.00	inches	\N
2562	403	290	\N	\N	0.00	inches	\N
2563	433	290	\N	\N	0.00	inches	\N
2564	444	291	\N	\N	0.00	inches	\N
2565	570	291	\N	\N	0.00	inches	\N
2566	630	290	\N	\N	0.00	inches	\N
2567	690	290	\N	\N	0.00	inches	\N
2568	681	289	\N	\N	0.00	inches	\N
2570	714	291	\N	\N	0.00	inches	\N
2571	733	291	\N	\N	0.00	inches	\N
2583	622	295	\N	\N	0.00	inches	\N
2572	527	297	\N	\N	114.00	inches	\N
2573	505	297	\N	\N	102.00	inches	\N
2584	705	297	\N	\N	0.00	inches	\N
2574	493	297	\N	\N	102.00	inches	\N
2575	325	297	\N	\N	0.00	inches	\N
2576	376	297	\N	\N	0.00	inches	\N
2577	330	295	\N	\N	0.00	inches	\N
2578	364	295	\N	\N	0.00	inches	\N
2579	388	297	\N	\N	0.00	inches	\N
2580	629	297	\N	\N	0.00	inches	\N
2581	590	296	\N	\N	0.00	inches	\N
2582	630	296	\N	\N	0.00	inches	\N
2585	690	296	\N	\N	0.00	inches	\N
2586	681	295	\N	\N	0.00	inches	\N
2589	491	302	\N	\N	198.50	inches	\N
2587	509	303	\N	\N	210.00	inches	\N
2588	530	303	\N	\N	203.00	inches	\N
2593	575	301	\N	\N	166.00	inches	\N
2592	507	302	\N	\N	166.00	inches	\N
2590	579	301	\N	\N	174.00	inches	\N
2591	522	303	\N	\N	171.00	inches	\N
2594	580	302	\N	\N	158.00	inches	\N
2595	508	303	\N	\N	148.00	inches	\N
2596	519	302	\N	\N	0.00	inches	\N
2597	329	303	\N	\N	0.00	inches	\N
2598	375	303	\N	\N	0.00	inches	\N
2599	343	302	\N	\N	0.00	inches	\N
2600	345	301	\N	\N	0.00	inches	\N
2601	360	302	\N	\N	0.00	inches	\N
2602	374	301	\N	\N	0.00	inches	\N
2603	332	302	\N	\N	0.00	inches	\N
2604	370	302	\N	\N	0.00	inches	\N
2605	757	303	\N	\N	0.00	inches	\N
2606	758	302	\N	\N	0.00	inches	\N
2607	412	303	\N	\N	0.00	inches	\N
2608	430	303	\N	\N	0.00	inches	\N
2609	401	302	\N	\N	0.00	inches	\N
2610	403	302	\N	\N	0.00	inches	\N
2611	402	302	\N	\N	0.00	inches	\N
2612	433	302	\N	\N	0.00	inches	\N
2613	451	302	\N	\N	0.00	inches	\N
2614	459	302	\N	\N	0.00	inches	\N
2615	475	303	\N	\N	0.00	inches	\N
2616	478	302	\N	\N	0.00	inches	\N
2617	467	302	\N	\N	0.00	inches	\N
2618	479	301	\N	\N	0.00	inches	\N
2619	534	303	\N	\N	0.00	inches	\N
2620	766	303	\N	\N	0.00	inches	\N
2621	554	303	\N	\N	0.00	inches	\N
2622	629	303	\N	\N	0.00	inches	\N
2623	607	303	\N	\N	0.00	inches	\N
2624	705	303	\N	\N	0.00	inches	\N
2625	687	302	\N	\N	0.00	inches	\N
2626	659	303	\N	\N	0.00	inches	\N
2627	704	301	\N	\N	0.00	inches	\N
2628	714	303	\N	\N	0.00	inches	\N
2629	728	302	\N	\N	0.00	inches	\N
2630	732	303	\N	\N	0.00	inches	\N
2631	723	302	\N	\N	0.00	inches	\N
2632	733	303	\N	\N	0.00	inches	\N
2633	717	301	\N	\N	0.00	inches	\N
2634	721	303	\N	\N	0.00	inches	\N
2635	519	308	\N	\N	501.00	inches	\N
2636	509	309	\N	\N	467.00	inches	\N
2674	631	361	\N	\N	18.22	seconds	\N
2637	320	309	\N	\N	426.50	inches	\N
2638	530	309	\N	\N	420.50	inches	\N
2639	522	309	\N	\N	380.00	inches	\N
2675	537	361	\N	\N	18.37	seconds	\N
2640	511	309	\N	\N	379.00	inches	\N
2641	507	308	\N	\N	377.75	inches	\N
2676	769	361	\N	\N	99999999.00	seconds	\N
2642	508	309	\N	\N	347.00	inches	\N
2643	386	308	\N	\N	0.00	inches	\N
2644	359	309	\N	\N	0.00	inches	\N
2645	374	307	\N	\N	0.00	inches	\N
2646	412	309	\N	\N	0.00	inches	\N
2647	401	308	\N	\N	0.00	inches	\N
2648	403	308	\N	\N	0.00	inches	\N
2649	433	308	\N	\N	0.00	inches	\N
2650	451	308	\N	\N	0.00	inches	\N
2651	629	309	\N	\N	0.00	inches	\N
2652	607	309	\N	\N	0.00	inches	\N
2653	690	308	\N	\N	0.00	inches	\N
2654	714	309	\N	\N	0.00	inches	\N
2655	728	308	\N	\N	0.00	inches	\N
2656	732	309	\N	\N	0.00	inches	\N
2657	733	309	\N	\N	0.00	inches	\N
2658	645	361	\N	\N	12.15	seconds	\N
2677	770	362	\N	\N	99999999.00	seconds	\N
2659	647	362	\N	\N	13.32	seconds	\N
2660	528	363	\N	\N	13.80	seconds	\N
2678	777	362	\N	\N	99999999.00	seconds	\N
2661	719	361	\N	\N	13.88	seconds	\N
2662	566	362	\N	\N	14.08	seconds	\N
2679	720	363	\N	\N	99999999.00	seconds	\N
2663	632	361	\N	\N	14.14	seconds	\N
2664	735	361	\N	\N	14.69	seconds	\N
2707	489	355	\N	\N	78.47	seconds	\N
2665	745	363	\N	\N	15.02	seconds	\N
2680	645	379	\N	\N	24.88	seconds	\N
2666	736	363	\N	\N	15.57	seconds	\N
2667	710	363	\N	\N	15.72	seconds	\N
2668	644	362	\N	\N	16.28	seconds	\N
2681	528	381	\N	\N	29.29	seconds	\N
2669	477	362	\N	\N	16.41	seconds	\N
2670	640	362	\N	\N	16.52	seconds	\N
2708	773	355	\N	\N	99999999.00	seconds	\N
2671	464	363	\N	\N	16.67	seconds	\N
2682	569	380	\N	\N	31.92	seconds	\N
2672	557	362	\N	\N	16.89	seconds	\N
2673	741	361	\N	\N	16.94	seconds	\N
2683	489	379	\N	\N	32.82	seconds	\N
2709	776	356	\N	\N	99999999.00	seconds	\N
2684	529	379	\N	\N	34.11	seconds	\N
2685	637	380	\N	\N	34.73	seconds	\N
2686	464	381	\N	\N	99999999.00	seconds	\N
2687	477	380	\N	\N	99999999.00	seconds	\N
2688	557	380	\N	\N	99999999.00	seconds	\N
2689	537	379	\N	\N	99999999.00	seconds	\N
2690	731	379	\N	\N	99999999.00	seconds	\N
2691	735	379	\N	\N	99999999.00	seconds	\N
2692	719	379	\N	\N	99999999.00	seconds	\N
2693	710	381	\N	\N	99999999.00	seconds	\N
2694	736	381	\N	\N	99999999.00	seconds	\N
2695	745	381	\N	\N	99999999.00	seconds	\N
2696	770	380	\N	\N	99999999.00	seconds	\N
2697	777	380	\N	\N	99999999.00	seconds	\N
2698	631	379	\N	\N	99999999.00	seconds	\N
2699	641	379	\N	\N	99999999.00	seconds	\N
2700	635	380	\N	\N	99999999.00	seconds	\N
2701	720	381	\N	\N	99999999.00	seconds	\N
2702	741	379	\N	\N	99999999.00	seconds	\N
2710	731	355	\N	\N	99999999.00	seconds	\N
2703	645	355	\N	\N	61.57	seconds	\N
2704	462	355	\N	\N	67.97	seconds	\N
2711	734	357	\N	\N	99999999.00	seconds	\N
2705	569	356	\N	\N	72.49	seconds	\N
2706	529	355	\N	\N	75.35	seconds	\N
2722	773	367	\N	\N	99999999.00	seconds	\N
2712	521	367	\N	\N	176.73	seconds	\N
2713	499	367	\N	\N	178.61	seconds	\N
2723	776	368	\N	\N	99999999.00	seconds	\N
2714	556	368	\N	\N	179.82	seconds	\N
2715	314	369	\N	\N	182.70	seconds	\N
2724	774	368	\N	\N	99999999.00	seconds	\N
2716	311	367	\N	\N	183.23	seconds	\N
2717	545	369	\N	\N	190.10	seconds	\N
2730	486	331	\N	\N	390.43	seconds	\N
2718	642	367	\N	\N	198.05	seconds	\N
2725	469	333	\N	\N	372.04	seconds	\N
2719	318	368	\N	\N	199.56	seconds	\N
2720	639	367	\N	\N	205.03	seconds	\N
2721	462	367	\N	\N	99999999.00	seconds	\N
2726	521	331	\N	\N	379.81	seconds	\N
2734	318	332	\N	\N	443.05	seconds	\N
2727	492	332	\N	\N	380.60	seconds	\N
2731	545	333	\N	\N	402.17	seconds	\N
2728	499	331	\N	\N	386.01	seconds	\N
2729	556	332	\N	\N	388.31	seconds	\N
2738	793	333	\N	\N	545.67	seconds	\N
2732	314	333	\N	\N	416.01	seconds	\N
2735	642	331	\N	\N	450.58	seconds	\N
2733	541	331	\N	\N	440.33	seconds	\N
2737	803	333	\N	\N	510.91	seconds	\N
2736	639	331	\N	\N	451.33	seconds	\N
2739	474	331	\N	\N	99999999.00	seconds	\N
2740	776	332	\N	\N	99999999.00	seconds	\N
2741	774	332	\N	\N	99999999.00	seconds	\N
2742	814	331	\N	\N	99999999.00	seconds	\N
2743	816	331	\N	\N	99999999.00	seconds	\N
2744	521	385	\N	\N	819.91	seconds	\N
2745	492	386	\N	\N	824.97	seconds	\N
2746	499	385	\N	\N	868.61	seconds	\N
2747	486	385	\N	\N	868.65	seconds	\N
2748	540	386	\N	\N	909.46	seconds	\N
2749	541	385	\N	\N	944.78	seconds	\N
2750	469	387	\N	\N	99999999.00	seconds	\N
2751	774	386	\N	\N	99999999.00	seconds	\N
2752	549	387	\N	\N	99999999.00	seconds	\N
2753	633	337	\N	\N	17.23	seconds	\N
2754	566	338	\N	\N	17.61	seconds	\N
2755	636	339	\N	\N	19.26	seconds	\N
2756	517	337	\N	\N	20.17	seconds	\N
2814	647	404	\N	\N	154.25	inches	\N
2757	496	337	\N	\N	20.52	seconds	\N
2758	501	337	\N	\N	22.26	seconds	\N
2759	711	338	\N	\N	99999999.00	seconds	\N
2842	726	364	\N	\N	12.23	seconds	\N
2760	566	374	\N	\N	51.38	seconds	\N
2815	634	403	\N	\N	120.00	inches	\N
2761	636	375	\N	\N	52.49	seconds	\N
2762	633	373	\N	\N	53.11	seconds	\N
2763	638	374	\N	\N	54.56	seconds	\N
2816	501	403	\N	\N	78.00	inches	\N
2764	517	373	\N	\N	55.80	seconds	\N
2765	496	373	\N	\N	57.31	seconds	\N
2766	501	373	\N	\N	62.30	seconds	\N
2767	487	374	\N	\N	99999999.00	seconds	\N
2768	769	373	\N	\N	99999999.00	seconds	\N
2769	711	374	\N	\N	99999999.00	seconds	\N
2817	489	403	\N	\N	66.00	inches	\N
2770	503	427	\N	\N	323.00	inches	\N
2771	523	427	\N	\N	302.00	inches	\N
2843	551	364	\N	\N	12.33	seconds	\N
2772	315	428	\N	\N	293.25	inches	\N
2818	647	410	\N	\N	203.25	inches	\N
2773	526	427	\N	\N	276.50	inches	\N
2774	646	427	\N	\N	276.00	inches	\N
2775	500	428	\N	\N	262.50	inches	\N
2819	487	410	\N	\N	178.00	inches	\N
2776	710	429	\N	\N	248.50	inches	\N
2777	788	429	\N	\N	242.00	inches	\N
2859	478	365	\N	\N	13.50	seconds	\N
2778	731	427	\N	\N	178.00	inches	\N
2779	800	428	\N	\N	0.00	inches	\N
2780	738	427	\N	\N	0.00	inches	\N
2781	769	427	\N	\N	0.00	inches	\N
2782	811	428	\N	\N	0.00	inches	\N
2783	796	428	\N	\N	0.00	inches	\N
2784	713	428	\N	\N	0.00	inches	\N
2820	566	410	\N	\N	174.00	inches	\N
2785	503	421	\N	\N	1032.00	inches	\N
2786	523	421	\N	\N	957.50	inches	\N
2844	715	364	\N	\N	12.36	seconds	\N
2787	525	421	\N	\N	865.00	inches	\N
2821	498	410	\N	\N	169.00	inches	\N
2788	526	421	\N	\N	858.00	inches	\N
2789	500	422	\N	\N	654.00	inches	\N
2790	646	421	\N	\N	654.00	inches	\N
2822	632	409	\N	\N	162.50	inches	\N
2791	533	422	\N	\N	650.50	inches	\N
2792	788	423	\N	\N	633.00	inches	\N
2793	800	422	\N	\N	0.00	inches	\N
2794	796	422	\N	\N	0.00	inches	\N
2795	725	421	\N	\N	0.00	inches	\N
2796	769	421	\N	\N	0.00	inches	\N
2797	529	421	\N	\N	0.00	inches	\N
2798	811	422	\N	\N	0.00	inches	\N
2799	783	422	\N	\N	0.00	inches	\N
2800	710	423	\N	\N	0.00	inches	\N
2801	713	422	\N	\N	0.00	inches	\N
2802	738	421	\N	\N	0.00	inches	\N
2803	487	398	\N	\N	54.00	inches	\N
2823	533	410	\N	\N	162.00	inches	\N
2804	515	399	\N	\N	54.00	inches	\N
2805	634	397	\N	\N	52.00	inches	\N
2845	552	364	\N	\N	12.42	seconds	\N
2806	633	397	\N	\N	50.00	inches	\N
2824	638	410	\N	\N	154.00	inches	\N
2807	498	398	\N	\N	42.00	inches	\N
2808	644	398	\N	\N	0.00	inches	\N
2809	524	398	\N	\N	0.00	inches	\N
2810	569	398	\N	\N	0.00	inches	\N
2811	734	399	\N	\N	0.00	inches	\N
2812	711	398	\N	\N	0.00	inches	\N
2813	741	397	\N	\N	0.00	inches	\N
2825	636	411	\N	\N	154.00	inches	\N
2869	465	366	\N	\N	15.13	seconds	\N
2826	515	411	\N	\N	151.00	inches	\N
2846	794	366	\N	\N	12.51	seconds	\N
2827	536	409	\N	\N	148.00	inches	\N
2828	524	410	\N	\N	118.00	inches	\N
2829	720	411	\N	\N	0.00	inches	\N
2830	736	411	\N	\N	0.00	inches	\N
2860	809	366	\N	\N	13.53	seconds	\N
2831	634	415	\N	\N	430.50	inches	\N
2847	546	364	\N	\N	12.57	seconds	\N
2832	633	415	\N	\N	385.00	inches	\N
2833	632	415	\N	\N	373.25	inches	\N
2834	533	416	\N	\N	359.50	inches	\N
2848	530	364	\N	\N	12.63	seconds	\N
2835	515	417	\N	\N	350.00	inches	\N
2836	638	416	\N	\N	342.25	inches	\N
2837	636	417	\N	\N	329.00	inches	\N
2849	309	364	\N	\N	12.68	seconds	\N
2838	536	415	\N	\N	318.50	inches	\N
2839	498	416	\N	\N	316.00	inches	\N
2861	463	365	\N	\N	13.62	seconds	\N
2840	524	416	\N	\N	274.50	inches	\N
2850	728	365	\N	\N	12.98	seconds	\N
2841	520	364	\N	\N	11.78	seconds	\N
2851	801	365	\N	\N	13.00	seconds	\N
2870	482	364	\N	\N	99999999.00	seconds	\N
2852	779	366	\N	\N	13.10	seconds	\N
2862	502	365	\N	\N	13.73	seconds	\N
2853	721	364	\N	\N	13.10	seconds	\N
2854	771	365	\N	\N	13.15	seconds	\N
2855	473	366	\N	\N	13.18	seconds	\N
2863	484	366	\N	\N	13.80	seconds	\N
2856	785	366	\N	\N	13.29	seconds	\N
2857	564	365	\N	\N	13.36	seconds	\N
2871	511	364	\N	\N	99999999.00	seconds	\N
2858	790	366	\N	\N	13.41	seconds	\N
2864	471	366	\N	\N	14.05	seconds	\N
2865	548	365	\N	\N	14.25	seconds	\N
2872	485	364	\N	\N	99999999.00	seconds	\N
2866	723	365	\N	\N	14.46	seconds	\N
2867	716	366	\N	\N	14.51	seconds	\N
2873	480	365	\N	\N	99999999.00	seconds	\N
2868	475	364	\N	\N	14.83	seconds	\N
2874	476	366	\N	\N	99999999.00	seconds	\N
2875	479	366	\N	\N	99999999.00	seconds	\N
2876	806	364	\N	\N	99999999.00	seconds	\N
2877	807	366	\N	\N	99999999.00	seconds	\N
2878	813	364	\N	\N	99999999.00	seconds	\N
2879	733	364	\N	\N	99999999.00	seconds	\N
2880	748	365	\N	\N	99999999.00	seconds	\N
2882	794	384	\N	\N	25.26	seconds	\N
2881	520	382	\N	\N	24.21	seconds	\N
2883	726	382	\N	\N	25.60	seconds	\N
2884	309	382	\N	\N	26.99	seconds	\N
2885	779	384	\N	\N	27.02	seconds	\N
2886	790	384	\N	\N	28.14	seconds	\N
2887	502	383	\N	\N	28.94	seconds	\N
2888	548	383	\N	\N	29.57	seconds	\N
2889	465	384	\N	\N	30.00	seconds	\N
2890	482	382	\N	\N	99999999.00	seconds	\N
2891	463	383	\N	\N	99999999.00	seconds	\N
2892	471	384	\N	\N	99999999.00	seconds	\N
2893	473	384	\N	\N	99999999.00	seconds	\N
2894	484	384	\N	\N	99999999.00	seconds	\N
2895	511	382	\N	\N	99999999.00	seconds	\N
2896	551	382	\N	\N	99999999.00	seconds	\N
2897	552	382	\N	\N	99999999.00	seconds	\N
2898	546	382	\N	\N	99999999.00	seconds	\N
2899	715	382	\N	\N	99999999.00	seconds	\N
2900	723	383	\N	\N	99999999.00	seconds	\N
2901	716	384	\N	\N	99999999.00	seconds	\N
2902	749	383	\N	\N	99999999.00	seconds	\N
2903	748	383	\N	\N	99999999.00	seconds	\N
2904	485	382	\N	\N	99999999.00	seconds	\N
2905	480	383	\N	\N	99999999.00	seconds	\N
2906	476	384	\N	\N	99999999.00	seconds	\N
2907	479	384	\N	\N	99999999.00	seconds	\N
2908	806	382	\N	\N	99999999.00	seconds	\N
2909	542	382	\N	\N	99999999.00	seconds	\N
2910	813	382	\N	\N	99999999.00	seconds	\N
2911	564	383	\N	\N	99999999.00	seconds	\N
2912	567	384	\N	\N	99999999.00	seconds	\N
2913	718	384	\N	\N	99999999.00	seconds	\N
2914	721	382	\N	\N	99999999.00	seconds	\N
2915	312	358	\N	\N	55.41	seconds	\N
2959	746	370	\N	\N	99999999.00	seconds	\N
2916	802	360	\N	\N	56.20	seconds	\N
2917	780	360	\N	\N	56.42	seconds	\N
2960	772	370	\N	\N	99999999.00	seconds	\N
2918	749	359	\N	\N	56.66	seconds	\N
2919	495	359	\N	\N	57.54	seconds	\N
2961	712	370	\N	\N	99999999.00	seconds	\N
2920	531	358	\N	\N	57.59	seconds	\N
2921	727	358	\N	\N	59.02	seconds	\N
2962	739	370	\N	\N	99999999.00	seconds	\N
2922	712	358	\N	\N	59.74	seconds	\N
2923	544	358	\N	\N	60.36	seconds	\N
2963	751	370	\N	\N	99999999.00	seconds	\N
2924	766	358	\N	\N	61.86	seconds	\N
2925	785	360	\N	\N	62.72	seconds	\N
2964	750	370	\N	\N	99999999.00	seconds	\N
2926	319	358	\N	\N	66.42	seconds	\N
2927	722	358	\N	\N	70.63	seconds	\N
2965	815	371	\N	\N	99999999.00	seconds	\N
2928	567	360	\N	\N	74.32	seconds	\N
2929	562	359	\N	\N	75.00	seconds	\N
2966	754	372	\N	\N	99999999.00	seconds	\N
2930	561	360	\N	\N	80.48	seconds	\N
2931	482	358	\N	\N	99999999.00	seconds	\N
2932	463	359	\N	\N	99999999.00	seconds	\N
2933	480	359	\N	\N	99999999.00	seconds	\N
2934	465	360	\N	\N	99999999.00	seconds	\N
2935	476	360	\N	\N	99999999.00	seconds	\N
2936	473	360	\N	\N	99999999.00	seconds	\N
2937	484	360	\N	\N	99999999.00	seconds	\N
2938	543	358	\N	\N	99999999.00	seconds	\N
2939	718	360	\N	\N	99999999.00	seconds	\N
2940	817	358	\N	\N	99999999.00	seconds	\N
2941	516	370	\N	\N	117.76	seconds	\N
2942	752	371	\N	\N	130.13	seconds	\N
2967	516	334	\N	\N	262.73	seconds	\N
2943	470	371	\N	\N	131.33	seconds	\N
2944	312	370	\N	\N	131.96	seconds	\N
2989	535	334	\N	\N	370.08	seconds	\N
2945	555	371	\N	\N	132.33	seconds	\N
2968	752	335	\N	\N	281.18	seconds	\N
2946	490	370	\N	\N	132.35	seconds	\N
2947	514	372	\N	\N	133.01	seconds	\N
2948	481	370	\N	\N	135.99	seconds	\N
2969	810	335	\N	\N	286.57	seconds	\N
2949	787	372	\N	\N	140.03	seconds	\N
2950	543	370	\N	\N	140.14	seconds	\N
2951	717	372	\N	\N	145.20	seconds	\N
2970	490	334	\N	\N	289.61	seconds	\N
2952	562	371	\N	\N	151.62	seconds	\N
2953	504	371	\N	\N	152.31	seconds	\N
2990	746	334	\N	\N	391.39	seconds	\N
2954	316	371	\N	\N	155.05	seconds	\N
2971	514	336	\N	\N	293.87	seconds	\N
2955	812	371	\N	\N	155.31	seconds	\N
2956	319	370	\N	\N	170.18	seconds	\N
2957	568	370	\N	\N	182.75	seconds	\N
2972	470	335	\N	\N	294.71	seconds	\N
2958	744	370	\N	\N	188.71	seconds	\N
3007	568	388	\N	\N	867.65	seconds	\N
2973	815	335	\N	\N	294.72	seconds	\N
2991	568	334	\N	\N	396.33	seconds	\N
2974	481	334	\N	\N	295.84	seconds	\N
2975	787	336	\N	\N	306.46	seconds	\N
2976	466	334	\N	\N	315.14	seconds	\N
2992	483	335	\N	\N	405.17	seconds	\N
2977	550	336	\N	\N	319.22	seconds	\N
2978	717	336	\N	\N	319.49	seconds	\N
3008	535	388	\N	\N	99999999.00	seconds	\N
2979	317	334	\N	\N	324.32	seconds	\N
2993	561	336	\N	\N	410.64	seconds	\N
2980	739	334	\N	\N	336.97	seconds	\N
2981	795	336	\N	\N	339.01	seconds	\N
2982	316	335	\N	\N	340.20	seconds	\N
2994	567	336	\N	\N	414.31	seconds	\N
2983	744	334	\N	\N	343.37	seconds	\N
2984	542	334	\N	\N	346.00	seconds	\N
3009	317	388	\N	\N	99999999.00	seconds	\N
2985	504	335	\N	\N	353.11	seconds	\N
2995	472	336	\N	\N	433.02	seconds	\N
2986	538	335	\N	\N	358.13	seconds	\N
2987	771	335	\N	\N	358.30	seconds	\N
2996	751	334	\N	\N	99999999.00	seconds	\N
2988	554	334	\N	\N	365.53	seconds	\N
2997	750	334	\N	\N	99999999.00	seconds	\N
2998	754	336	\N	\N	99999999.00	seconds	\N
2999	772	334	\N	\N	99999999.00	seconds	\N
3000	562	335	\N	\N	99999999.00	seconds	\N
3001	516	388	\N	\N	604.07	seconds	\N
3010	316	389	\N	\N	99999999.00	seconds	\N
3002	490	388	\N	\N	626.47	seconds	\N
3003	560	388	\N	\N	654.90	seconds	\N
3011	772	388	\N	\N	99999999.00	seconds	\N
3004	787	390	\N	\N	686.89	seconds	\N
3005	795	390	\N	\N	729.70	seconds	\N
3012	470	389	\N	\N	99999999.00	seconds	\N
3006	562	389	\N	\N	739.44	seconds	\N
3013	466	388	\N	\N	99999999.00	seconds	\N
3014	472	390	\N	\N	99999999.00	seconds	\N
3015	514	390	\N	\N	99999999.00	seconds	\N
3016	504	389	\N	\N	99999999.00	seconds	\N
3017	559	389	\N	\N	99999999.00	seconds	\N
3018	547	389	\N	\N	99999999.00	seconds	\N
3019	538	389	\N	\N	99999999.00	seconds	\N
3020	746	388	\N	\N	99999999.00	seconds	\N
3021	739	388	\N	\N	99999999.00	seconds	\N
3022	717	390	\N	\N	99999999.00	seconds	\N
3025	727	346	\N	\N	21.05	seconds	\N
3023	527	346	\N	\N	18.53	seconds	\N
3024	491	347	\N	\N	18.79	seconds	\N
3027	478	347	\N	\N	21.40	seconds	\N
3026	494	346	\N	\N	21.21	seconds	\N
3029	808	347	\N	\N	99999999.00	seconds	\N
3028	513	346	\N	\N	23.00	seconds	\N
3030	799	348	\N	\N	99999999.00	seconds	\N
3031	784	348	\N	\N	99999999.00	seconds	\N
3032	802	348	\N	\N	99999999.00	seconds	\N
3033	802	378	\N	\N	46.55	seconds	\N
3034	491	377	\N	\N	46.81	seconds	\N
3035	527	376	\N	\N	47.68	seconds	\N
3036	478	377	\N	\N	49.92	seconds	\N
3037	494	376	\N	\N	51.49	seconds	\N
3038	481	376	\N	\N	52.71	seconds	\N
3039	799	378	\N	\N	53.10	seconds	\N
3040	784	378	\N	\N	54.12	seconds	\N
3041	495	377	\N	\N	99999999.00	seconds	\N
3042	727	376	\N	\N	99999999.00	seconds	\N
3043	722	376	\N	\N	99999999.00	seconds	\N
3044	712	376	\N	\N	99999999.00	seconds	\N
3045	497	430	\N	\N	492.00	inches	\N
3046	518	430	\N	\N	467.00	inches	\N
3047	737	430	\N	\N	437.25	inches	\N
3099	781	414	\N	\N	207.00	inches	\N
3048	512	430	\N	\N	427.75	inches	\N
3049	532	430	\N	\N	389.00	inches	\N
3165	701	473	\N	\N	17.04	seconds	\N
3050	313	430	\N	\N	377.00	inches	\N
3100	534	412	\N	\N	205.00	inches	\N
3051	506	430	\N	\N	355.00	inches	\N
3052	488	431	\N	\N	335.50	inches	\N
3132	530	418	\N	\N	420.50	inches	\N
3053	789	432	\N	\N	294.50	inches	\N
3101	507	413	\N	\N	204.00	inches	\N
3054	554	430	\N	\N	279.00	inches	\N
3055	775	432	\N	\N	264.50	inches	\N
3056	786	431	\N	\N	263.00	inches	\N
3102	478	413	\N	\N	202.00	inches	\N
3057	782	430	\N	\N	261.00	inches	\N
3058	792	432	\N	\N	0.00	inches	\N
3059	791	432	\N	\N	0.00	inches	\N
3060	804	432	\N	\N	0.00	inches	\N
3061	510	431	\N	\N	0.00	inches	\N
3062	723	431	\N	\N	0.00	inches	\N
3063	497	424	\N	\N	1441.00	inches	\N
3149	679	473	\N	\N	15.27	seconds	\N
3064	532	424	\N	\N	1273.00	inches	\N
3103	717	414	\N	\N	202.00	inches	\N
3065	518	424	\N	\N	1224.00	inches	\N
3066	313	424	\N	\N	1158.00	inches	\N
3133	507	419	\N	\N	401.00	inches	\N
3067	512	424	\N	\N	1087.00	inches	\N
3104	766	412	\N	\N	193.00	inches	\N
3068	320	424	\N	\N	1024.50	inches	\N
3069	506	424	\N	\N	1018.00	inches	\N
3070	488	425	\N	\N	903.00	inches	\N
3105	564	413	\N	\N	190.00	inches	\N
3071	564	425	\N	\N	883.00	inches	\N
3072	791	426	\N	\N	804.00	inches	\N
3073	554	424	\N	\N	751.00	inches	\N
3106	522	412	\N	\N	189.00	inches	\N
3074	542	424	\N	\N	725.00	inches	\N
3075	789	426	\N	\N	696.00	inches	\N
3134	508	418	\N	\N	397.00	inches	\N
3076	782	424	\N	\N	580.00	inches	\N
3107	475	412	\N	\N	183.00	inches	\N
3077	786	425	\N	\N	482.00	inches	\N
3078	775	426	\N	\N	0.00	inches	\N
3079	804	426	\N	\N	0.00	inches	\N
3080	792	426	\N	\N	0.00	inches	\N
3081	737	424	\N	\N	0.00	inches	\N
3082	510	425	\N	\N	0.00	inches	\N
3083	812	425	\N	\N	0.00	inches	\N
3084	733	400	\N	\N	68.00	inches	\N
3085	509	400	\N	\N	62.00	inches	\N
3108	721	412	\N	\N	177.50	inches	\N
3086	522	400	\N	\N	62.00	inches	\N
3087	507	401	\N	\N	60.00	inches	\N
3159	428	473	\N	\N	15.73	seconds	\N
3088	781	402	\N	\N	60.00	inches	\N
3109	728	413	\N	\N	171.00	inches	\N
3089	714	400	\N	\N	60.00	inches	\N
3090	805	402	\N	\N	58.00	inches	\N
3135	511	418	\N	\N	396.00	inches	\N
3091	527	406	\N	\N	126.00	inches	\N
3110	513	412	\N	\N	167.50	inches	\N
3092	505	406	\N	\N	120.00	inches	\N
3093	493	406	\N	\N	114.00	inches	\N
3094	732	412	\N	\N	218.00	inches	\N
3111	805	414	\N	\N	166.50	inches	\N
3095	733	412	\N	\N	216.00	inches	\N
3096	530	412	\N	\N	211.50	inches	\N
3150	702	473	\N	\N	15.34	seconds	\N
3097	491	413	\N	\N	211.50	inches	\N
3112	495	413	\N	\N	164.00	inches	\N
3098	509	412	\N	\N	210.00	inches	\N
3136	728	419	\N	\N	393.50	inches	\N
3113	797	414	\N	\N	164.00	inches	\N
3114	508	412	\N	\N	148.00	inches	\N
3115	771	413	\N	\N	0.00	inches	\N
3116	479	414	\N	\N	0.00	inches	\N
3117	519	413	\N	\N	0.00	inches	\N
3118	714	412	\N	\N	0.00	inches	\N
3119	313	412	\N	\N	0.00	inches	\N
3120	320	412	\N	\N	0.00	inches	\N
3121	480	413	\N	\N	0.00	inches	\N
3122	778	413	\N	\N	0.00	inches	\N
3123	476	414	\N	\N	0.00	inches	\N
3124	716	414	\N	\N	0.00	inches	\N
3125	519	419	\N	\N	501.00	inches	\N
3137	522	418	\N	\N	393.00	inches	\N
3126	509	418	\N	\N	467.00	inches	\N
3127	802	420	\N	\N	448.00	inches	\N
3128	733	418	\N	\N	444.00	inches	\N
3138	714	418	\N	\N	376.00	inches	\N
3129	320	418	\N	\N	426.50	inches	\N
3130	781	420	\N	\N	425.50	inches	\N
3151	424	474	\N	\N	15.42	seconds	\N
3131	732	418	\N	\N	425.00	inches	\N
3139	495	419	\N	\N	355.00	inches	\N
3140	513	418	\N	\N	346.50	inches	\N
3141	778	419	\N	\N	0.00	inches	\N
3142	617	473	\N	\N	13.50	seconds	\N
3152	706	474	\N	\N	15.43	seconds	\N
3143	660	474	\N	\N	14.47	seconds	\N
3144	764	474	\N	\N	14.67	seconds	\N
3160	695	474	\N	\N	15.78	seconds	\N
3145	423	473	\N	\N	14.97	seconds	\N
3153	614	473	\N	\N	15.48	seconds	\N
3146	429	472	\N	\N	14.98	seconds	\N
3147	447	472	\N	\N	14.98	seconds	\N
3148	452	472	\N	\N	15.15	seconds	\N
3154	654	474	\N	\N	15.49	seconds	\N
3169	620	474	\N	\N	17.61	seconds	\N
3155	416	474	\N	\N	15.51	seconds	\N
3161	328	474	\N	\N	15.80	seconds	\N
3156	763	474	\N	\N	15.66	seconds	\N
3157	408	473	\N	\N	15.69	seconds	\N
3166	686	474	\N	\N	17.38	seconds	\N
3158	649	472	\N	\N	15.69	seconds	\N
3162	594	474	\N	\N	15.96	seconds	\N
3163	456	474	\N	\N	16.15	seconds	\N
3164	621	473	\N	\N	16.83	seconds	\N
3170	674	474	\N	\N	99999999.00	seconds	\N
3167	420	474	\N	\N	17.51	seconds	\N
3168	394	474	\N	\N	17.52	seconds	\N
3173	357	473	\N	\N	99999999.00	seconds	\N
3171	658	474	\N	\N	99999999.00	seconds	\N
3172	355	473	\N	\N	99999999.00	seconds	\N
3174	369	472	\N	\N	99999999.00	seconds	\N
3175	825	472	\N	\N	99999999.00	seconds	\N
3176	827	474	\N	\N	99999999.00	seconds	\N
3177	602	474	\N	\N	99999999.00	seconds	\N
3178	663	474	\N	\N	99999999.00	seconds	\N
3179	627	490	\N	\N	28.00	seconds	\N
3180	628	490	\N	\N	28.78	seconds	\N
3181	708	491	\N	\N	29.81	seconds	\N
3182	660	492	\N	\N	30.39	seconds	\N
3183	764	492	\N	\N	30.61	seconds	\N
3184	447	490	\N	\N	31.64	seconds	\N
3185	663	492	\N	\N	31.68	seconds	\N
3186	611	491	\N	\N	31.74	seconds	\N
3187	452	490	\N	\N	31.83	seconds	\N
3188	649	490	\N	\N	32.04	seconds	\N
3189	706	492	\N	\N	32.11	seconds	\N
3190	763	492	\N	\N	32.29	seconds	\N
3191	695	492	\N	\N	32.64	seconds	\N
3244	683	480	\N	\N	183.67	seconds	\N
3192	416	492	\N	\N	32.74	seconds	\N
3193	623	490	\N	\N	32.78	seconds	\N
3274	688	496	\N	\N	783.18	seconds	\N
3194	428	491	\N	\N	32.84	seconds	\N
3245	422	478	\N	\N	185.71	seconds	\N
3195	328	492	\N	\N	33.00	seconds	\N
3196	384	491	\N	\N	33.37	seconds	\N
3197	594	492	\N	\N	33.47	seconds	\N
3246	694	478	\N	\N	188.49	seconds	\N
3198	456	492	\N	\N	33.62	seconds	\N
3199	424	492	\N	\N	33.90	seconds	\N
3295	674	450	\N	\N	99999999.00	seconds	\N
3200	385	492	\N	\N	34.05	seconds	\N
3247	672	479	\N	\N	188.77	seconds	\N
3201	358	492	\N	\N	34.22	seconds	\N
3202	408	491	\N	\N	34.84	seconds	\N
3275	707	497	\N	\N	803.52	seconds	\N
3203	342	492	\N	\N	35.20	seconds	\N
3248	606	478	\N	\N	193.62	seconds	\N
3204	394	492	\N	\N	37.17	seconds	\N
3205	620	492	\N	\N	37.71	seconds	\N
3206	420	492	\N	\N	38.32	seconds	\N
3207	701	491	\N	\N	99999999.00	seconds	\N
3208	654	492	\N	\N	99999999.00	seconds	\N
3209	334	492	\N	\N	99999999.00	seconds	\N
3210	825	490	\N	\N	99999999.00	seconds	\N
3211	602	492	\N	\N	99999999.00	seconds	\N
3212	676	492	\N	\N	99999999.00	seconds	\N
3213	657	491	\N	\N	99999999.00	seconds	\N
3249	419	478	\N	\N	197.35	seconds	\N
3214	367	467	\N	\N	60.62	seconds	\N
3215	676	468	\N	\N	64.77	seconds	\N
3216	708	467	\N	\N	65.23	seconds	\N
3250	678	479	\N	\N	198.29	seconds	\N
3217	628	466	\N	\N	66.00	seconds	\N
3218	611	467	\N	\N	70.57	seconds	\N
3276	831	497	\N	\N	821.95	seconds	\N
3219	623	466	\N	\N	73.85	seconds	\N
3251	392	480	\N	\N	208.80	seconds	\N
3220	385	468	\N	\N	78.19	seconds	\N
3221	424	468	\N	\N	78.79	seconds	\N
3252	335	479	\N	\N	99999999.00	seconds	\N
3222	358	468	\N	\N	79.48	seconds	\N
3223	342	468	\N	\N	81.90	seconds	\N
3253	362	480	\N	\N	99999999.00	seconds	\N
3224	408	467	\N	\N	82.12	seconds	\N
3225	394	468	\N	\N	83.88	seconds	\N
3254	651	478	\N	\N	99999999.00	seconds	\N
3226	654	468	\N	\N	85.12	seconds	\N
3227	420	468	\N	\N	87.87	seconds	\N
3228	702	467	\N	\N	99999999.00	seconds	\N
3229	335	467	\N	\N	99999999.00	seconds	\N
3230	380	468	\N	\N	99999999.00	seconds	\N
3231	428	467	\N	\N	99999999.00	seconds	\N
3232	456	468	\N	\N	99999999.00	seconds	\N
3233	763	468	\N	\N	99999999.00	seconds	\N
3234	624	478	\N	\N	154.31	seconds	\N
3255	624	442	\N	\N	340.93	seconds	\N
3235	676	480	\N	\N	155.08	seconds	\N
3236	367	479	\N	\N	156.23	seconds	\N
3237	366	480	\N	\N	156.27	seconds	\N
3256	366	444	\N	\N	344.46	seconds	\N
3238	595	479	\N	\N	160.04	seconds	\N
3239	688	478	\N	\N	164.58	seconds	\N
3277	694	496	\N	\N	895.73	seconds	\N
3240	455	480	\N	\N	168.03	seconds	\N
3257	595	443	\N	\N	353.44	seconds	\N
3241	831	479	\N	\N	169.06	seconds	\N
3242	707	479	\N	\N	176.51	seconds	\N
3243	341	480	\N	\N	182.10	seconds	\N
3258	688	442	\N	\N	354.44	seconds	\N
3296	617	485	\N	\N	50.00	seconds	\N
3259	362	444	\N	\N	368.07	seconds	\N
3278	672	497	\N	\N	902.58	seconds	\N
3260	455	444	\N	\N	368.80	seconds	\N
3261	831	443	\N	\N	374.08	seconds	\N
3262	683	444	\N	\N	386.14	seconds	\N
3279	683	498	\N	\N	955.33	seconds	\N
3263	707	443	\N	\N	386.17	seconds	\N
3264	422	442	\N	\N	395.87	seconds	\N
3280	819	497	\N	\N	99999999.00	seconds	\N
3265	341	444	\N	\N	396.28	seconds	\N
3266	323	444	\N	\N	396.71	seconds	\N
3281	323	498	\N	\N	99999999.00	seconds	\N
3267	694	442	\N	\N	404.68	seconds	\N
3268	672	443	\N	\N	410.75	seconds	\N
3282	341	498	\N	\N	99999999.00	seconds	\N
3269	419	442	\N	\N	423.48	seconds	\N
3270	678	443	\N	\N	434.71	seconds	\N
3283	366	498	\N	\N	99999999.00	seconds	\N
3271	392	444	\N	\N	472.68	seconds	\N
3272	651	442	\N	\N	505.12	seconds	\N
3273	819	443	\N	\N	99999999.00	seconds	\N
3284	419	496	\N	\N	99999999.00	seconds	\N
3285	392	498	\N	\N	99999999.00	seconds	\N
3286	422	496	\N	\N	99999999.00	seconds	\N
3287	455	498	\N	\N	99999999.00	seconds	\N
3288	606	496	\N	\N	99999999.00	seconds	\N
3311	406	539	\N	\N	260.50	inches	\N
3289	628	448	\N	\N	19.00	seconds	\N
3297	355	485	\N	\N	53.69	seconds	\N
3290	664	449	\N	\N	21.08	seconds	\N
3291	355	449	\N	\N	22.57	seconds	\N
3306	448	540	\N	\N	330.50	inches	\N
3292	657	449	\N	\N	23.20	seconds	\N
3298	664	485	\N	\N	57.80	seconds	\N
3293	679	449	\N	\N	26.49	seconds	\N
3294	658	450	\N	\N	28.18	seconds	\N
3299	657	485	\N	\N	64.34	seconds	\N
3300	679	485	\N	\N	67.65	seconds	\N
3301	380	486	\N	\N	99999999.00	seconds	\N
3302	674	486	\N	\N	99999999.00	seconds	\N
3303	658	486	\N	\N	99999999.00	seconds	\N
3307	677	539	\N	\N	313.25	inches	\N
3304	356	539	\N	\N	413.50	inches	\N
3305	440	539	\N	\N	338.50	inches	\N
3308	461	538	\N	\N	306.00	inches	\N
3312	390	538	\N	\N	257.00	inches	\N
3309	650	539	\N	\N	263.00	inches	\N
3310	334	540	\N	\N	262.50	inches	\N
3315	666	538	\N	\N	236.50	inches	\N
3313	692	538	\N	\N	243.50	inches	\N
3314	443	538	\N	\N	240.25	inches	\N
3316	601	538	\N	\N	229.00	inches	\N
3317	404	538	\N	\N	224.00	inches	\N
3318	680	539	\N	\N	207.50	inches	\N
3319	426	538	\N	\N	206.00	inches	\N
3320	686	540	\N	\N	197.25	inches	\N
3321	670	540	\N	\N	197.00	inches	\N
3322	675	539	\N	\N	189.00	inches	\N
3323	326	540	\N	\N	174.50	inches	\N
3324	667	538	\N	\N	147.50	inches	\N
3325	357	539	\N	\N	0.00	inches	\N
3326	821	539	\N	\N	0.00	inches	\N
3327	827	540	\N	\N	0.00	inches	\N
3328	829	539	\N	\N	0.00	inches	\N
3329	677	533	\N	\N	867.50	inches	\N
3330	440	533	\N	\N	816.00	inches	\N
3331	461	532	\N	\N	779.00	inches	\N
3332	448	534	\N	\N	644.00	inches	\N
3333	670	534	\N	\N	614.00	inches	\N
3334	692	532	\N	\N	610.00	inches	\N
3389	613	526	\N	\N	295.00	inches	\N
3335	406	533	\N	\N	606.00	inches	\N
3336	601	532	\N	\N	597.00	inches	\N
3390	408	527	\N	\N	0.00	inches	\N
3337	686	534	\N	\N	593.00	inches	\N
3338	680	533	\N	\N	558.00	inches	\N
3391	601	526	\N	\N	0.00	inches	\N
3339	426	532	\N	\N	557.00	inches	\N
3340	404	532	\N	\N	552.00	inches	\N
3392	649	526	\N	\N	0.00	inches	\N
3341	443	532	\N	\N	529.00	inches	\N
3342	667	532	\N	\N	517.00	inches	\N
3343	666	532	\N	\N	500.00	inches	\N
3393	597	469	\N	\N	11.62	seconds	\N
3344	650	533	\N	\N	473.25	inches	\N
3345	390	532	\N	\N	428.25	inches	\N
3419	762	471	\N	\N	13.85	seconds	\N
3346	334	534	\N	\N	427.00	inches	\N
3394	391	469	\N	\N	12.06	seconds	\N
3347	675	533	\N	\N	383.00	inches	\N
3348	356	533	\N	\N	0.00	inches	\N
3349	326	534	\N	\N	0.00	inches	\N
3350	357	533	\N	\N	0.00	inches	\N
3351	821	533	\N	\N	0.00	inches	\N
3352	827	534	\N	\N	0.00	inches	\N
3353	829	533	\N	\N	0.00	inches	\N
3354	333	508	\N	\N	58.00	inches	\N
3355	350	508	\N	\N	54.00	inches	\N
3395	386	470	\N	\N	12.21	seconds	\N
3356	626	508	\N	\N	52.00	inches	\N
3357	613	508	\N	\N	48.00	inches	\N
3438	687	470	\N	\N	99999999.00	seconds	\N
3358	664	509	\N	\N	48.00	inches	\N
3396	383	469	\N	\N	12.27	seconds	\N
3359	623	508	\N	\N	44.00	inches	\N
3360	667	508	\N	\N	44.00	inches	\N
3420	402	470	\N	\N	13.90	seconds	\N
3361	593	510	\N	\N	42.00	inches	\N
3362	380	510	\N	\N	0.00	inches	\N
3397	435	469	\N	\N	12.41	seconds	\N
3363	601	514	\N	\N	96.00	inches	\N
3364	384	515	\N	\N	0.00	inches	\N
3365	342	516	\N	\N	0.00	inches	\N
3366	664	515	\N	\N	0.00	inches	\N
3367	347	522	\N	\N	176.00	inches	\N
3368	452	520	\N	\N	172.00	inches	\N
3398	438	469	\N	\N	12.46	seconds	\N
3369	429	520	\N	\N	156.00	inches	\N
3370	322	520	\N	\N	152.50	inches	\N
3371	663	522	\N	\N	149.00	inches	\N
3399	370	470	\N	\N	12.51	seconds	\N
3372	424	522	\N	\N	148.00	inches	\N
3373	613	520	\N	\N	148.00	inches	\N
3421	382	469	\N	\N	13.91	seconds	\N
3374	649	520	\N	\N	148.00	inches	\N
3400	605	471	\N	\N	12.54	seconds	\N
3375	328	522	\N	\N	141.00	inches	\N
3376	651	520	\N	\N	136.00	inches	\N
3377	416	522	\N	\N	130.00	inches	\N
3401	689	469	\N	\N	12.57	seconds	\N
3378	678	521	\N	\N	114.50	inches	\N
3379	593	522	\N	\N	100.00	inches	\N
3380	333	520	\N	\N	0.00	inches	\N
3381	349	520	\N	\N	0.00	inches	\N
3382	701	521	\N	\N	0.00	inches	\N
3383	456	522	\N	\N	0.00	inches	\N
3384	394	522	\N	\N	0.00	inches	\N
3385	627	520	\N	\N	0.00	inches	\N
3439	668	470	\N	\N	99999999.00	seconds	\N
3386	626	526	\N	\N	347.50	inches	\N
3402	407	469	\N	\N	12.60	seconds	\N
3387	322	526	\N	\N	332.00	inches	\N
3388	429	526	\N	\N	325.00	inches	\N
3422	665	471	\N	\N	13.92	seconds	\N
3403	596	471	\N	\N	12.62	seconds	\N
3404	685	471	\N	\N	12.66	seconds	\N
3423	599	470	\N	\N	14.00	seconds	\N
3405	427	469	\N	\N	12.74	seconds	\N
3406	332	470	\N	\N	12.83	seconds	\N
3440	830	471	\N	\N	99999999.00	seconds	\N
3407	398	469	\N	\N	12.86	seconds	\N
3424	345	471	\N	\N	14.09	seconds	\N
3408	421	471	\N	\N	12.89	seconds	\N
3409	446	471	\N	\N	12.94	seconds	\N
3410	439	471	\N	\N	12.98	seconds	\N
3425	368	470	\N	\N	14.13	seconds	\N
3411	348	470	\N	\N	13.06	seconds	\N
3412	699	470	\N	\N	13.09	seconds	\N
3449	348	488	\N	\N	26.18	seconds	\N
3413	591	471	\N	\N	13.15	seconds	\N
3426	437	469	\N	\N	14.14	seconds	\N
3414	327	470	\N	\N	13.51	seconds	\N
3415	395	470	\N	\N	13.55	seconds	\N
3441	597	487	\N	\N	23.80	seconds	\N
3416	655	471	\N	\N	13.55	seconds	\N
3427	681	471	\N	\N	14.14	seconds	\N
3417	671	469	\N	\N	13.57	seconds	\N
3418	604	471	\N	\N	13.84	seconds	\N
3428	652	471	\N	\N	14.20	seconds	\N
3429	343	470	\N	\N	14.36	seconds	\N
3442	386	488	\N	\N	25.18	seconds	\N
3430	457	469	\N	\N	14.47	seconds	\N
3431	338	471	\N	\N	14.66	seconds	\N
3455	444	487	\N	\N	26.73	seconds	\N
3432	331	470	\N	\N	15.13	seconds	\N
3443	383	487	\N	\N	25.26	seconds	\N
3433	659	469	\N	\N	15.58	seconds	\N
3434	354	469	\N	\N	99999999.00	seconds	\N
3435	709	469	\N	\N	99999999.00	seconds	\N
3436	374	471	\N	\N	99999999.00	seconds	\N
3437	824	471	\N	\N	99999999.00	seconds	\N
3450	605	489	\N	\N	26.18	seconds	\N
3444	689	487	\N	\N	25.40	seconds	\N
3445	438	487	\N	\N	25.44	seconds	\N
3446	407	487	\N	\N	26.03	seconds	\N
3451	687	488	\N	\N	26.25	seconds	\N
3447	669	487	\N	\N	26.05	seconds	\N
3448	332	488	\N	\N	26.17	seconds	\N
3461	682	488	\N	\N	26.99	seconds	\N
3456	446	489	\N	\N	26.86	seconds	\N
3452	596	489	\N	\N	26.28	seconds	\N
3453	398	487	\N	\N	26.31	seconds	\N
3459	671	487	\N	\N	26.97	seconds	\N
3454	693	489	\N	\N	26.67	seconds	\N
3457	421	489	\N	\N	26.91	seconds	\N
3458	768	487	\N	\N	26.96	seconds	\N
3460	425	487	\N	\N	26.98	seconds	\N
3462	699	488	\N	\N	27.09	seconds	\N
3463	395	488	\N	\N	27.58	seconds	\N
3464	451	488	\N	\N	27.70	seconds	\N
3465	457	487	\N	\N	28.22	seconds	\N
3466	599	488	\N	\N	28.47	seconds	\N
3467	665	489	\N	\N	28.99	seconds	\N
3468	402	488	\N	\N	29.20	seconds	\N
3469	368	488	\N	\N	29.78	seconds	\N
3470	346	489	\N	\N	29.99	seconds	\N
3471	659	487	\N	\N	33.11	seconds	\N
3472	371	487	\N	\N	35.10	seconds	\N
3473	354	487	\N	\N	99999999.00	seconds	\N
3474	331	488	\N	\N	99999999.00	seconds	\N
3475	340	487	\N	\N	99999999.00	seconds	\N
3476	382	487	\N	\N	99999999.00	seconds	\N
3477	338	489	\N	\N	99999999.00	seconds	\N
3478	370	488	\N	\N	99999999.00	seconds	\N
3479	435	487	\N	\N	99999999.00	seconds	\N
3480	652	489	\N	\N	99999999.00	seconds	\N
3481	655	489	\N	\N	99999999.00	seconds	\N
3482	685	489	\N	\N	99999999.00	seconds	\N
3483	668	488	\N	\N	99999999.00	seconds	\N
3484	709	487	\N	\N	99999999.00	seconds	\N
3485	343	488	\N	\N	99999999.00	seconds	\N
3486	818	487	\N	\N	99999999.00	seconds	\N
3487	360	488	\N	\N	99999999.00	seconds	\N
3488	374	489	\N	\N	99999999.00	seconds	\N
3489	437	487	\N	\N	99999999.00	seconds	\N
3490	439	489	\N	\N	99999999.00	seconds	\N
3491	696	488	\N	\N	99999999.00	seconds	\N
3492	673	488	\N	\N	99999999.00	seconds	\N
3493	681	489	\N	\N	99999999.00	seconds	\N
3494	830	489	\N	\N	99999999.00	seconds	\N
3495	407	463	\N	\N	56.26	seconds	\N
3538	442	475	\N	\N	154.15	seconds	\N
3496	768	463	\N	\N	58.21	seconds	\N
3497	352	463	\N	\N	58.30	seconds	\N
3568	619	441	\N	\N	308.58	seconds	\N
3498	689	463	\N	\N	58.61	seconds	\N
3539	662	475	\N	\N	154.19	seconds	\N
3499	363	463	\N	\N	59.42	seconds	\N
3500	325	463	\N	\N	59.76	seconds	\N
3501	425	463	\N	\N	60.59	seconds	\N
3540	449	475	\N	\N	155.35	seconds	\N
3502	459	464	\N	\N	61.00	seconds	\N
3503	398	463	\N	\N	61.64	seconds	\N
3504	671	463	\N	\N	61.92	seconds	\N
3541	365	477	\N	\N	155.55	seconds	\N
3505	591	465	\N	\N	63.13	seconds	\N
3506	622	465	\N	\N	63.14	seconds	\N
3569	609	441	\N	\N	311.34	seconds	\N
3507	430	463	\N	\N	63.92	seconds	\N
3542	410	477	\N	\N	155.91	seconds	\N
3508	364	465	\N	\N	65.75	seconds	\N
3509	652	465	\N	\N	65.77	seconds	\N
3510	704	465	\N	\N	66.69	seconds	\N
3543	673	476	\N	\N	161.53	seconds	\N
3511	346	465	\N	\N	66.73	seconds	\N
3512	360	464	\N	\N	68.22	seconds	\N
3584	387	439	\N	\N	355.83	seconds	\N
3513	375	463	\N	\N	70.78	seconds	\N
3544	698	477	\N	\N	162.22	seconds	\N
3514	371	463	\N	\N	75.36	seconds	\N
3515	412	463	\N	\N	99999999.00	seconds	\N
3516	444	463	\N	\N	99999999.00	seconds	\N
3517	669	463	\N	\N	99999999.00	seconds	\N
3518	699	464	\N	\N	99999999.00	seconds	\N
3519	682	464	\N	\N	99999999.00	seconds	\N
3520	655	465	\N	\N	99999999.00	seconds	\N
3521	693	465	\N	\N	99999999.00	seconds	\N
3522	709	463	\N	\N	99999999.00	seconds	\N
3523	665	465	\N	\N	99999999.00	seconds	\N
3524	830	465	\N	\N	99999999.00	seconds	\N
3525	625	477	\N	\N	127.20	seconds	\N
3570	608	441	\N	\N	314.02	seconds	\N
3526	592	476	\N	\N	128.20	seconds	\N
3545	765	476	\N	\N	165.25	seconds	\N
3527	696	476	\N	\N	129.97	seconds	\N
3528	705	475	\N	\N	132.75	seconds	\N
3529	615	477	\N	\N	135.08	seconds	\N
3546	432	475	\N	\N	165.69	seconds	\N
3530	351	477	\N	\N	135.83	seconds	\N
3531	381	475	\N	\N	136.39	seconds	\N
3532	600	475	\N	\N	138.40	seconds	\N
3547	375	475	\N	\N	169.85	seconds	\N
3533	363	475	\N	\N	138.75	seconds	\N
3534	409	475	\N	\N	145.33	seconds	\N
3571	409	439	\N	\N	314.11	seconds	\N
3535	608	477	\N	\N	145.67	seconds	\N
3548	436	476	\N	\N	171.15	seconds	\N
3536	458	475	\N	\N	151.46	seconds	\N
3537	413	475	\N	\N	153.16	seconds	\N
3549	417	476	\N	\N	173.23	seconds	\N
3550	400	477	\N	\N	174.91	seconds	\N
3572	337	441	\N	\N	315.23	seconds	\N
3551	450	477	\N	\N	180.95	seconds	\N
3552	691	477	\N	\N	188.20	seconds	\N
3553	352	475	\N	\N	99999999.00	seconds	\N
3554	387	475	\N	\N	99999999.00	seconds	\N
3555	337	477	\N	\N	99999999.00	seconds	\N
3556	411	476	\N	\N	99999999.00	seconds	\N
3557	648	477	\N	\N	99999999.00	seconds	\N
3558	325	475	\N	\N	99999999.00	seconds	\N
3559	364	477	\N	\N	99999999.00	seconds	\N
3560	434	476	\N	\N	99999999.00	seconds	\N
3585	432	439	\N	\N	356.15	seconds	\N
3561	592	440	\N	\N	272.96	seconds	\N
3573	615	441	\N	\N	320.15	seconds	\N
3562	612	439	\N	\N	281.47	seconds	\N
3563	625	441	\N	\N	284.80	seconds	\N
3564	696	440	\N	\N	291.47	seconds	\N
3574	449	439	\N	\N	333.10	seconds	\N
3565	610	439	\N	\N	297.05	seconds	\N
3566	351	441	\N	\N	301.45	seconds	\N
3594	691	441	\N	\N	414.30	seconds	\N
3567	600	439	\N	\N	306.25	seconds	\N
3575	458	439	\N	\N	335.67	seconds	\N
3586	436	440	\N	\N	358.91	seconds	\N
3576	673	440	\N	\N	337.42	seconds	\N
3577	413	439	\N	\N	338.72	seconds	\N
3578	662	439	\N	\N	341.08	seconds	\N
3587	442	439	\N	\N	362.54	seconds	\N
3579	410	441	\N	\N	344.35	seconds	\N
3580	765	440	\N	\N	346.02	seconds	\N
3595	339	441	\N	\N	99999999.00	seconds	\N
3581	648	441	\N	\N	347.71	seconds	\N
3588	411	440	\N	\N	363.64	seconds	\N
3582	434	440	\N	\N	348.34	seconds	\N
3583	365	441	\N	\N	351.96	seconds	\N
3589	698	441	\N	\N	364.41	seconds	\N
3596	393	439	\N	\N	99999999.00	seconds	\N
3590	372	441	\N	\N	372.47	seconds	\N
3591	450	441	\N	\N	373.72	seconds	\N
3597	381	439	\N	\N	99999999.00	seconds	\N
3592	417	440	\N	\N	379.03	seconds	\N
3593	400	441	\N	\N	387.26	seconds	\N
3598	336	440	\N	\N	99999999.00	seconds	\N
3599	704	441	\N	\N	99999999.00	seconds	\N
3602	336	494	\N	\N	99999999.00	seconds	\N
3600	648	495	\N	\N	767.87	seconds	\N
3601	698	495	\N	\N	770.00	seconds	\N
3603	372	495	\N	\N	99999999.00	seconds	\N
3604	337	495	\N	\N	99999999.00	seconds	\N
3605	339	495	\N	\N	99999999.00	seconds	\N
3606	409	493	\N	\N	99999999.00	seconds	\N
3607	411	494	\N	\N	99999999.00	seconds	\N
3608	436	494	\N	\N	99999999.00	seconds	\N
3609	449	493	\N	\N	99999999.00	seconds	\N
3610	458	493	\N	\N	99999999.00	seconds	\N
3611	432	493	\N	\N	99999999.00	seconds	\N
3612	413	493	\N	\N	99999999.00	seconds	\N
3613	410	495	\N	\N	99999999.00	seconds	\N
3614	400	495	\N	\N	99999999.00	seconds	\N
3615	434	494	\N	\N	99999999.00	seconds	\N
3616	450	495	\N	\N	99999999.00	seconds	\N
3617	393	493	\N	\N	99999999.00	seconds	\N
3618	442	493	\N	\N	99999999.00	seconds	\N
3619	417	494	\N	\N	99999999.00	seconds	\N
3620	765	494	\N	\N	99999999.00	seconds	\N
3621	612	493	\N	\N	99999999.00	seconds	\N
3622	610	493	\N	\N	99999999.00	seconds	\N
3623	619	495	\N	\N	99999999.00	seconds	\N
3624	609	495	\N	\N	99999999.00	seconds	\N
3625	662	493	\N	\N	99999999.00	seconds	\N
3626	704	495	\N	\N	99999999.00	seconds	\N
3627	378	451	\N	\N	17.05	seconds	\N
3711	690	512	\N	\N	90.00	inches	\N
3628	656	451	\N	\N	18.22	seconds	\N
3677	445	529	\N	\N	813.00	inches	\N
3629	607	451	\N	\N	19.04	seconds	\N
3630	391	451	\N	\N	20.00	seconds	\N
3631	340	451	\N	\N	20.89	seconds	\N
3678	441	530	\N	\N	796.00	inches	\N
3632	396	451	\N	\N	21.85	seconds	\N
3633	376	451	\N	\N	21.91	seconds	\N
3634	604	453	\N	\N	21.95	seconds	\N
3679	431	529	\N	\N	747.50	inches	\N
3635	338	453	\N	\N	28.23	seconds	\N
3636	656	481	\N	\N	46.00	seconds	\N
3712	325	511	\N	\N	84.00	inches	\N
3637	378	481	\N	\N	46.35	seconds	\N
3680	414	530	\N	\N	652.00	inches	\N
3638	391	481	\N	\N	52.06	seconds	\N
3639	396	481	\N	\N	52.35	seconds	\N
3640	607	481	\N	\N	99999999.00	seconds	\N
3641	604	483	\N	\N	99999999.00	seconds	\N
3642	661	535	\N	\N	609.00	inches	\N
3681	598	531	\N	\N	565.00	inches	\N
3643	460	536	\N	\N	522.25	inches	\N
3644	344	535	\N	\N	448.00	inches	\N
3645	445	535	\N	\N	444.50	inches	\N
3682	684	531	\N	\N	319.00	inches	\N
3646	453	535	\N	\N	435.00	inches	\N
3647	431	535	\N	\N	416.75	inches	\N
3683	344	529	\N	\N	0.00	inches	\N
3648	703	535	\N	\N	403.50	inches	\N
3649	321	535	\N	\N	396.25	inches	\N
3684	329	529	\N	\N	0.00	inches	\N
3650	618	535	\N	\N	387.50	inches	\N
3651	653	536	\N	\N	385.50	inches	\N
3685	373	529	\N	\N	0.00	inches	\N
3652	397	536	\N	\N	381.00	inches	\N
3653	441	536	\N	\N	379.00	inches	\N
3686	321	529	\N	\N	0.00	inches	\N
3654	327	536	\N	\N	372.00	inches	\N
3655	700	536	\N	\N	356.00	inches	\N
3687	327	530	\N	\N	0.00	inches	\N
3656	373	535	\N	\N	350.25	inches	\N
3657	415	536	\N	\N	347.50	inches	\N
3688	820	531	\N	\N	0.00	inches	\N
3658	329	535	\N	\N	328.50	inches	\N
3659	377	535	\N	\N	328.50	inches	\N
3689	377	529	\N	\N	0.00	inches	\N
3660	414	536	\N	\N	309.75	inches	\N
3661	375	535	\N	\N	285.00	inches	\N
3690	379	531	\N	\N	0.00	inches	\N
3662	820	537	\N	\N	282.00	inches	\N
3663	598	537	\N	\N	224.50	inches	\N
3691	828	529	\N	\N	0.00	inches	\N
3664	684	537	\N	\N	204.50	inches	\N
3665	379	537	\N	\N	0.00	inches	\N
3666	828	535	\N	\N	0.00	inches	\N
3667	826	537	\N	\N	0.00	inches	\N
3668	661	529	\N	\N	1582.00	inches	\N
3692	826	531	\N	\N	0.00	inches	\N
3669	460	530	\N	\N	1315.00	inches	\N
3670	618	529	\N	\N	1121.50	inches	\N
3713	364	513	\N	\N	84.00	inches	\N
3671	653	530	\N	\N	1064.50	inches	\N
3693	378	505	\N	\N	72.00	inches	\N
3672	453	529	\N	\N	1059.00	inches	\N
3673	703	529	\N	\N	1020.50	inches	\N
3674	397	530	\N	\N	942.00	inches	\N
3694	388	505	\N	\N	64.00	inches	\N
3675	415	530	\N	\N	882.00	inches	\N
3676	700	530	\N	\N	844.00	inches	\N
3729	343	518	\N	\N	167.00	inches	\N
3695	345	507	\N	\N	60.00	inches	\N
3714	681	513	\N	\N	84.00	inches	\N
3696	630	506	\N	\N	60.00	inches	\N
3697	403	506	\N	\N	58.00	inches	\N
3715	622	513	\N	\N	0.00	inches	\N
3698	690	506	\N	\N	56.00	inches	\N
3699	665	507	\N	\N	56.00	inches	\N
3716	705	511	\N	\N	0.00	inches	\N
3700	444	505	\N	\N	54.00	inches	\N
3701	401	506	\N	\N	52.00	inches	\N
3702	430	505	\N	\N	0.00	inches	\N
3703	681	507	\N	\N	0.00	inches	\N
3704	433	506	\N	\N	0.00	inches	\N
3705	823	505	\N	\N	0.00	inches	\N
3706	376	511	\N	\N	132.00	inches	\N
3717	403	518	\N	\N	217.50	inches	\N
3707	629	511	\N	\N	120.00	inches	\N
3708	388	511	\N	\N	108.00	inches	\N
3743	433	518	\N	\N	0.00	inches	\N
3709	630	512	\N	\N	102.00	inches	\N
3718	374	519	\N	\N	210.00	inches	\N
3710	590	512	\N	\N	90.00	inches	\N
3730	704	519	\N	\N	165.00	inches	\N
3719	607	517	\N	\N	207.50	inches	\N
3720	332	518	\N	\N	202.00	inches	\N
3731	659	517	\N	\N	121.00	inches	\N
3721	401	518	\N	\N	199.00	inches	\N
3722	629	517	\N	\N	199.00	inches	\N
3732	329	517	\N	\N	0.00	inches	\N
3723	430	517	\N	\N	192.00	inches	\N
3724	451	518	\N	\N	180.00	inches	\N
3733	412	517	\N	\N	0.00	inches	\N
3725	459	518	\N	\N	177.00	inches	\N
3726	345	519	\N	\N	175.00	inches	\N
3734	705	517	\N	\N	0.00	inches	\N
3727	402	518	\N	\N	171.00	inches	\N
3728	375	517	\N	\N	170.00	inches	\N
3735	690	518	\N	\N	0.00	inches	\N
3736	378	517	\N	\N	0.00	inches	\N
3737	383	517	\N	\N	0.00	inches	\N
3738	376	517	\N	\N	0.00	inches	\N
3739	386	518	\N	\N	0.00	inches	\N
3740	340	517	\N	\N	0.00	inches	\N
3741	818	517	\N	\N	0.00	inches	\N
3742	388	517	\N	\N	0.00	inches	\N
3744	823	517	\N	\N	0.00	inches	\N
3745	822	517	\N	\N	0.00	inches	\N
3746	824	519	\N	\N	0.00	inches	\N
3747	604	519	\N	\N	0.00	inches	\N
3749	607	523	\N	\N	457.50	inches	\N
3748	376	523	\N	\N	463.00	inches	\N
3751	629	523	\N	\N	434.50	inches	\N
3750	403	524	\N	\N	450.00	inches	\N
3752	690	524	\N	\N	399.00	inches	\N
3753	401	524	\N	\N	396.50	inches	\N
3754	451	524	\N	\N	392.00	inches	\N
3755	430	523	\N	\N	383.50	inches	\N
3756	412	523	\N	\N	0.00	inches	\N
3757	340	523	\N	\N	0.00	inches	\N
3758	388	523	\N	\N	0.00	inches	\N
3759	824	525	\N	\N	0.00	inches	\N
3760	938	577	\N	\N	12.90	seconds	\N
3761	68	578	\N	\N	13.47	seconds	\N
3762	873	578	\N	\N	13.54	seconds	\N
3763	1037	578	\N	\N	13.54	seconds	\N
3764	528	577	\N	\N	13.72	seconds	\N
3765	1033	579	\N	\N	13.75	seconds	\N
3766	1101	577	\N	\N	13.77	seconds	\N
3767	1112	579	\N	\N	13.92	seconds	\N
3768	852	577	\N	\N	14.03	seconds	\N
3769	1046	577	\N	\N	14.08	seconds	\N
3850	676	583	\N	\N	152.10	seconds	\N
3770	916	579	\N	\N	14.18	seconds	\N
3819	529	597	\N	\N	34.11	seconds	\N
3771	660	577	\N	\N	14.28	seconds	\N
3772	925	579	\N	\N	14.35	seconds	\N
3773	943	578	\N	\N	14.35	seconds	\N
3820	640	596	\N	\N	34.50	seconds	\N
3774	918	579	\N	\N	14.41	seconds	\N
3775	764	577	\N	\N	14.43	seconds	\N
3892	694	549	\N	\N	395.73	seconds	\N
3776	1042	579	\N	\N	14.44	seconds	\N
3821	935	597	\N	\N	34.96	seconds	\N
3777	452	579	\N	\N	14.50	seconds	\N
3778	940	579	\N	\N	14.54	seconds	\N
3822	423	596	\N	\N	99999999.00	seconds	\N
3779	663	577	\N	\N	14.62	seconds	\N
3780	735	579	\N	\N	14.69	seconds	\N
3851	980	584	\N	\N	155.00	seconds	\N
3781	849	577	\N	\N	14.76	seconds	\N
3823	57	572	\N	\N	61.77	seconds	\N
3782	827	577	\N	\N	14.78	seconds	\N
3783	926	578	\N	\N	14.83	seconds	\N
3784	695	577	\N	\N	15.00	seconds	\N
3824	1084	573	\N	\N	62.58	seconds	\N
3785	594	577	\N	\N	15.17	seconds	\N
3786	416	577	\N	\N	15.21	seconds	\N
3869	419	585	\N	\N	197.35	seconds	\N
3787	908	579	\N	\N	15.29	seconds	\N
3825	676	571	\N	\N	62.99	seconds	\N
3788	489	579	\N	\N	15.64	seconds	\N
3789	933	579	\N	\N	16.66	seconds	\N
3852	939	584	\N	\N	160.72	seconds	\N
3790	935	579	\N	\N	17.73	seconds	\N
3791	498	578	\N	\N	99999999.00	seconds	\N
3826	708	572	\N	\N	64.25	seconds	\N
3792	938	595	\N	\N	27.77	seconds	\N
3793	57	596	\N	\N	28.01	seconds	\N
3794	1094	597	\N	\N	28.18	seconds	\N
3827	462	573	\N	\N	67.05	seconds	\N
3795	1101	595	\N	\N	28.47	seconds	\N
3796	1084	597	\N	\N	28.63	seconds	\N
3797	1042	597	\N	\N	28.76	seconds	\N
3828	946	573	\N	\N	67.56	seconds	\N
3798	708	596	\N	\N	28.89	seconds	\N
3799	943	596	\N	\N	29.00	seconds	\N
3853	462	585	\N	\N	164.16	seconds	\N
3800	528	595	\N	\N	29.08	seconds	\N
3829	875	573	\N	\N	70.80	seconds	\N
3801	852	595	\N	\N	29.40	seconds	\N
3802	1046	595	\N	\N	29.47	seconds	\N
3803	987	597	\N	\N	29.96	seconds	\N
3830	987	573	\N	\N	71.11	seconds	\N
3804	916	597	\N	\N	30.21	seconds	\N
3805	918	597	\N	\N	30.25	seconds	\N
3881	455	547	\N	\N	366.00	seconds	\N
3806	926	596	\N	\N	30.29	seconds	\N
3831	922	572	\N	\N	72.00	seconds	\N
3807	867	595	\N	\N	30.79	seconds	\N
3808	695	595	\N	\N	31.08	seconds	\N
3854	455	583	\N	\N	165.21	seconds	\N
3809	995	596	\N	\N	31.75	seconds	\N
3832	895	571	\N	\N	72.11	seconds	\N
3810	594	595	\N	\N	31.78	seconds	\N
3811	849	595	\N	\N	31.96	seconds	\N
3812	428	596	\N	\N	32.29	seconds	\N
3833	501	573	\N	\N	72.67	seconds	\N
3813	489	597	\N	\N	32.82	seconds	\N
3814	908	597	\N	\N	33.11	seconds	\N
3870	915	585	\N	\N	197.99	seconds	\N
3815	424	595	\N	\N	33.39	seconds	\N
3834	855	573	\N	\N	73.16	seconds	\N
3816	702	596	\N	\N	33.52	seconds	\N
3817	31	597	\N	\N	33.62	seconds	\N
3855	41	585	\N	\N	168.99	seconds	\N
3818	933	597	\N	\N	34.03	seconds	\N
3835	763	571	\N	\N	73.27	seconds	\N
3836	428	572	\N	\N	73.98	seconds	\N
3837	1001	572	\N	\N	74.47	seconds	\N
3856	831	584	\N	\N	169.06	seconds	\N
3838	640	572	\N	\N	74.50	seconds	\N
3839	489	573	\N	\N	74.68	seconds	\N
3871	1058	585	\N	\N	99999999.00	seconds	\N
3840	529	573	\N	\N	75.35	seconds	\N
3857	34	584	\N	\N	169.98	seconds	\N
3841	881	572	\N	\N	75.76	seconds	\N
3842	702	572	\N	\N	77.55	seconds	\N
3843	919	572	\N	\N	79.22	seconds	\N
3844	423	572	\N	\N	99999999.00	seconds	\N
3858	53	584	\N	\N	171.03	seconds	\N
3845	1118	583	\N	\N	144.41	seconds	\N
3846	1026	584	\N	\N	149.66	seconds	\N
3847	959	585	\N	\N	151.39	seconds	\N
3859	1120	585	\N	\N	171.29	seconds	\N
3848	624	585	\N	\N	151.78	seconds	\N
3849	865	585	\N	\N	152.00	seconds	\N
3872	624	549	\N	\N	335.93	seconds	\N
3860	963	585	\N	\N	173.53	seconds	\N
3888	499	549	\N	\N	386.01	seconds	\N
3861	694	585	\N	\N	173.68	seconds	\N
3873	595	548	\N	\N	337.35	seconds	\N
3862	521	585	\N	\N	176.73	seconds	\N
3863	889	584	\N	\N	177.12	seconds	\N
3882	707	548	\N	\N	373.16	seconds	\N
3864	499	585	\N	\N	178.61	seconds	\N
3874	1026	548	\N	\N	338.37	seconds	\N
3865	866	584	\N	\N	179.93	seconds	\N
3866	422	585	\N	\N	183.93	seconds	\N
3867	909	584	\N	\N	188.91	seconds	\N
3875	939	548	\N	\N	341.51	seconds	\N
3868	920	585	\N	\N	196.11	seconds	\N
3876	858	548	\N	\N	347.39	seconds	\N
3883	521	549	\N	\N	374.42	seconds	\N
3877	1099	548	\N	\N	347.96	seconds	\N
3878	688	549	\N	\N	351.16	seconds	\N
3879	1102	548	\N	\N	357.07	seconds	\N
3884	17	547	\N	\N	375.03	seconds	\N
3880	41	549	\N	\N	364.56	seconds	\N
3889	862	549	\N	\N	387.18	seconds	\N
3885	982	548	\N	\N	375.06	seconds	\N
3886	492	548	\N	\N	380.60	seconds	\N
3895	996	548	\N	\N	413.71	seconds	\N
3887	34	548	\N	\N	382.39	seconds	\N
3890	864	548	\N	\N	388.89	seconds	\N
3893	422	549	\N	\N	395.87	seconds	\N
3891	963	549	\N	\N	390.20	seconds	\N
3894	902	548	\N	\N	404.29	seconds	\N
3897	901	548	\N	\N	424.11	seconds	\N
3896	419	549	\N	\N	423.48	seconds	\N
3898	1058	549	\N	\N	454.91	seconds	\N
3899	904	549	\N	\N	99999999.00	seconds	\N
3900	1095	603	\N	\N	692.24	seconds	\N
3901	1026	602	\N	\N	739.62	seconds	\N
3902	688	603	\N	\N	749.10	seconds	\N
3903	858	602	\N	\N	755.81	seconds	\N
3904	980	602	\N	\N	768.22	seconds	\N
3905	707	602	\N	\N	788.37	seconds	\N
3906	831	602	\N	\N	790.99	seconds	\N
3907	862	603	\N	\N	799.36	seconds	\N
3908	17	601	\N	\N	805.55	seconds	\N
3909	521	603	\N	\N	808.09	seconds	\N
3910	982	602	\N	\N	820.16	seconds	\N
3911	905	603	\N	\N	823.05	seconds	\N
3912	492	602	\N	\N	824.97	seconds	\N
3913	904	603	\N	\N	824.99	seconds	\N
3914	455	601	\N	\N	850.45	seconds	\N
3994	952	639	\N	\N	1006.00	inches	\N
3915	866	602	\N	\N	853.93	seconds	\N
3964	1044	644	\N	\N	373.00	inches	\N
3916	486	603	\N	\N	868.65	seconds	\N
3917	422	603	\N	\N	875.03	seconds	\N
3918	958	602	\N	\N	927.98	seconds	\N
3919	56	602	\N	\N	99999999.00	seconds	\N
3965	1047	645	\N	\N	369.50	inches	\N
3920	1105	555	\N	\N	17.41	seconds	\N
3921	940	555	\N	\N	17.66	seconds	\N
3922	1094	555	\N	\N	18.31	seconds	\N
3966	953	645	\N	\N	364.50	inches	\N
3923	1043	553	\N	\N	18.94	seconds	\N
3924	1086	555	\N	\N	19.37	seconds	\N
3995	827	637	\N	\N	977.00	inches	\N
3925	496	555	\N	\N	19.42	seconds	\N
3967	835	645	\N	\N	352.50	inches	\N
3926	971	555	\N	\N	19.61	seconds	\N
3927	20	555	\N	\N	19.87	seconds	\N
3928	861	555	\N	\N	20.05	seconds	\N
3968	440	644	\N	\N	338.50	inches	\N
3929	517	555	\N	\N	20.17	seconds	\N
3930	860	555	\N	\N	20.32	seconds	\N
4013	1060	638	\N	\N	598.00	inches	\N
3931	1045	555	\N	\N	20.62	seconds	\N
3969	503	645	\N	\N	337.00	inches	\N
3932	1023	555	\N	\N	20.82	seconds	\N
3933	664	554	\N	\N	20.99	seconds	\N
3996	523	639	\N	\N	957.50	inches	\N
3934	891	555	\N	\N	21.25	seconds	\N
3970	1057	644	\N	\N	337.00	inches	\N
3935	1040	553	\N	\N	21.39	seconds	\N
3936	968	555	\N	\N	22.23	seconds	\N
3937	679	554	\N	\N	22.36	seconds	\N
3971	523	645	\N	\N	333.00	inches	\N
3938	977	554	\N	\N	23.16	seconds	\N
3939	657	554	\N	\N	23.20	seconds	\N
3940	638	554	\N	\N	99999999.00	seconds	\N
3941	1037	590	\N	\N	51.58	seconds	\N
3972	944	645	\N	\N	332.50	inches	\N
3942	940	591	\N	\N	53.25	seconds	\N
3943	664	590	\N	\N	54.10	seconds	\N
3997	14	638	\N	\N	939.00	inches	\N
3944	971	591	\N	\N	54.33	seconds	\N
3973	448	643	\N	\N	330.50	inches	\N
3945	1045	591	\N	\N	54.56	seconds	\N
3946	638	590	\N	\N	54.56	seconds	\N
3947	891	591	\N	\N	54.65	seconds	\N
3974	14	644	\N	\N	325.00	inches	\N
3948	1043	589	\N	\N	54.96	seconds	\N
3949	517	591	\N	\N	55.33	seconds	\N
4032	1035	621	\N	\N	108.00	inches	\N
3950	1086	591	\N	\N	56.01	seconds	\N
3975	677	644	\N	\N	313.25	inches	\N
3951	1023	591	\N	\N	56.56	seconds	\N
3952	861	591	\N	\N	56.68	seconds	\N
3998	1011	639	\N	\N	919.00	inches	\N
3953	496	591	\N	\N	57.31	seconds	\N
3976	461	645	\N	\N	312.25	inches	\N
3954	860	591	\N	\N	57.83	seconds	\N
3955	1040	589	\N	\N	58.80	seconds	\N
3956	923	590	\N	\N	60.01	seconds	\N
3977	850	645	\N	\N	312.00	inches	\N
3957	679	590	\N	\N	61.70	seconds	\N
3958	977	590	\N	\N	62.22	seconds	\N
4014	686	637	\N	\N	593.00	inches	\N
3959	501	591	\N	\N	62.30	seconds	\N
3978	21	644	\N	\N	307.50	inches	\N
3960	657	590	\N	\N	63.90	seconds	\N
3961	992	591	\N	\N	76.44	seconds	\N
3999	440	638	\N	\N	903.00	inches	\N
3962	30	645	\N	\N	443.75	inches	\N
3979	1011	645	\N	\N	305.00	inches	\N
3963	1041	645	\N	\N	399.75	inches	\N
3980	1016	645	\N	\N	298.00	inches	\N
3981	952	645	\N	\N	289.00	inches	\N
4000	677	638	\N	\N	867.50	inches	\N
3982	686	643	\N	\N	283.00	inches	\N
3983	1100	644	\N	\N	281.50	inches	\N
4025	498	614	\N	\N	48.00	inches	\N
3984	834	645	\N	\N	279.00	inches	\N
4001	461	639	\N	\N	865.00	inches	\N
3985	500	644	\N	\N	266.00	inches	\N
3986	692	645	\N	\N	243.50	inches	\N
4015	1105	615	\N	\N	62.00	inches	\N
3987	953	639	\N	\N	1245.00	inches	\N
4002	525	639	\N	\N	865.00	inches	\N
3988	1041	639	\N	\N	1237.00	inches	\N
3989	1123	639	\N	\N	1135.00	inches	\N
3990	835	639	\N	\N	1125.00	inches	\N
4003	850	639	\N	\N	850.00	inches	\N
3991	1044	638	\N	\N	1038.00	inches	\N
3992	503	639	\N	\N	1034.00	inches	\N
3993	1057	638	\N	\N	1010.00	inches	\N
4016	487	614	\N	\N	56.00	inches	\N
4004	1047	639	\N	\N	840.00	inches	\N
4005	1100	638	\N	\N	821.00	inches	\N
4006	1016	639	\N	\N	820.00	inches	\N
4017	1036	615	\N	\N	56.00	inches	\N
4007	848	637	\N	\N	772.00	inches	\N
4008	969	639	\N	\N	765.00	inches	\N
4026	967	615	\N	\N	48.00	inches	\N
4009	21	638	\N	\N	704.00	inches	\N
4018	515	613	\N	\N	54.00	inches	\N
4010	30	639	\N	\N	673.00	inches	\N
4011	448	637	\N	\N	659.00	inches	\N
4012	692	639	\N	\N	630.00	inches	\N
4019	938	613	\N	\N	52.00	inches	\N
4020	1097	615	\N	\N	52.00	inches	\N
4027	664	614	\N	\N	48.00	inches	\N
4021	860	615	\N	\N	50.00	inches	\N
4022	971	615	\N	\N	50.00	inches	\N
4033	1024	620	\N	\N	102.00	inches	\N
4023	849	613	\N	\N	48.00	inches	\N
4028	986	614	\N	\N	46.00	inches	\N
4024	925	615	\N	\N	48.00	inches	\N
4029	857	614	\N	\N	44.00	inches	\N
4040	664	620	\N	\N	0.00	inches	\N
4030	24	614	\N	\N	42.00	inches	\N
4031	408	614	\N	\N	0.00	inches	\N
4037	947	621	\N	\N	78.00	inches	\N
4034	1045	621	\N	\N	96.00	inches	\N
4035	1097	621	\N	\N	90.00	inches	\N
4036	501	621	\N	\N	78.00	inches	\N
4038	489	621	\N	\N	66.00	inches	\N
4039	993	621	\N	\N	0.00	inches	\N
4041	1046	619	\N	\N	0.00	inches	\N
4042	1094	627	\N	\N	195.00	inches	\N
4043	1048	627	\N	\N	187.00	inches	\N
4044	1049	627	\N	\N	186.00	inches	\N
4045	873	626	\N	\N	181.00	inches	\N
4046	487	626	\N	\N	178.00	inches	\N
4047	938	625	\N	\N	173.50	inches	\N
4048	1035	627	\N	\N	173.25	inches	\N
4049	925	627	\N	\N	173.00	inches	\N
4050	452	627	\N	\N	172.00	inches	\N
4051	943	626	\N	\N	171.00	inches	\N
4052	851	627	\N	\N	165.00	inches	\N
4053	1043	625	\N	\N	165.00	inches	\N
4054	533	626	\N	\N	162.00	inches	\N
4055	867	625	\N	\N	161.50	inches	\N
4056	515	625	\N	\N	157.00	inches	\N
4057	429	627	\N	\N	156.00	inches	\N
4058	638	626	\N	\N	154.00	inches	\N
4059	663	625	\N	\N	153.25	inches	\N
4140	665	580	\N	\N	13.72	seconds	\N
4060	424	625	\N	\N	148.00	inches	\N
4109	945	582	\N	\N	13.22	seconds	\N
4061	24	626	\N	\N	142.00	inches	\N
4062	984	626	\N	\N	139.75	inches	\N
4063	1004	626	\N	\N	138.00	inches	\N
4064	68	626	\N	\N	0.00	inches	\N
4110	896	582	\N	\N	13.56	seconds	\N
4065	1049	633	\N	\N	408.50	inches	\N
4066	1105	633	\N	\N	396.50	inches	\N
4159	25	600	\N	\N	25.41	seconds	\N
4067	1048	633	\N	\N	376.00	inches	\N
4111	911	582	\N	\N	13.69	seconds	\N
4068	1036	633	\N	\N	373.00	inches	\N
4069	1035	633	\N	\N	372.50	inches	\N
4141	932	581	\N	\N	14.33	seconds	\N
4070	1092	632	\N	\N	363.00	inches	\N
4112	1053	582	\N	\N	14.31	seconds	\N
4071	533	632	\N	\N	359.50	inches	\N
4072	851	633	\N	\N	357.50	inches	\N
4113	903	582	\N	\N	99999999.00	seconds	\N
4073	943	632	\N	\N	355.00	inches	\N
4074	515	631	\N	\N	351.50	inches	\N
4114	928	582	\N	\N	99999999.00	seconds	\N
4075	867	631	\N	\N	346.00	inches	\N
4076	638	632	\N	\N	342.25	inches	\N
4115	1085	582	\N	\N	99999999.00	seconds	\N
4077	429	633	\N	\N	325.00	inches	\N
4078	855	633	\N	\N	320.00	inches	\N
4079	961	632	\N	\N	319.00	inches	\N
4116	1082	580	\N	\N	11.77	seconds	\N
4080	498	632	\N	\N	317.50	inches	\N
4081	1004	632	\N	\N	311.00	inches	\N
4082	1112	633	\N	\N	0.00	inches	\N
4083	452	633	\N	\N	0.00	inches	\N
4084	1070	582	\N	\N	11.08	seconds	\N
4117	837	581	\N	\N	12.19	seconds	\N
4085	937	580	\N	\N	11.34	seconds	\N
4086	597	582	\N	\N	11.53	seconds	\N
4142	465	580	\N	\N	14.85	seconds	\N
4087	1020	582	\N	\N	11.64	seconds	\N
4118	794	580	\N	\N	12.21	seconds	\N
4088	876	582	\N	\N	11.78	seconds	\N
4089	520	582	\N	\N	11.78	seconds	\N
4090	871	582	\N	\N	11.79	seconds	\N
4119	950	580	\N	\N	12.30	seconds	\N
4091	1014	582	\N	\N	11.85	seconds	\N
4092	878	582	\N	\N	11.86	seconds	\N
4143	1055	581	\N	\N	99999999.00	seconds	\N
4093	1090	581	\N	\N	11.90	seconds	\N
4120	927	581	\N	\N	12.32	seconds	\N
4094	482	582	\N	\N	11.92	seconds	\N
4095	1069	582	\N	\N	11.93	seconds	\N
4096	391	582	\N	\N	11.99	seconds	\N
4121	1061	580	\N	\N	12.33	seconds	\N
4097	1064	582	\N	\N	11.99	seconds	\N
4098	65	582	\N	\N	12.11	seconds	\N
4144	749	581	\N	\N	99999999.00	seconds	\N
4099	25	582	\N	\N	12.14	seconds	\N
4122	1017	581	\N	\N	12.55	seconds	\N
4100	485	582	\N	\N	12.23	seconds	\N
4101	435	582	\N	\N	12.36	seconds	\N
4102	438	582	\N	\N	12.46	seconds	\N
4123	693	580	\N	\N	12.66	seconds	\N
4103	530	582	\N	\N	12.52	seconds	\N
4104	1122	582	\N	\N	12.55	seconds	\N
4105	798	582	\N	\N	12.60	seconds	\N
4124	519	581	\N	\N	12.67	seconds	\N
4106	669	582	\N	\N	12.62	seconds	\N
4107	47	582	\N	\N	12.66	seconds	\N
4145	597	600	\N	\N	23.35	seconds	\N
4108	671	582	\N	\N	13.17	seconds	\N
4125	52	581	\N	\N	12.70	seconds	\N
4126	998	581	\N	\N	12.72	seconds	\N
4160	924	600	\N	\N	25.60	seconds	\N
4127	771	581	\N	\N	12.82	seconds	\N
4146	937	598	\N	\N	23.48	seconds	\N
4128	421	580	\N	\N	12.89	seconds	\N
4129	801	581	\N	\N	12.89	seconds	\N
4130	748	581	\N	\N	12.91	seconds	\N
4147	1020	600	\N	\N	23.79	seconds	\N
4131	11	581	\N	\N	12.93	seconds	\N
4132	1038	581	\N	\N	12.94	seconds	\N
4171	391	600	\N	\N	99999999.00	seconds	\N
4133	863	580	\N	\N	13.12	seconds	\N
4148	1070	600	\N	\N	23.80	seconds	\N
4134	844	581	\N	\N	13.15	seconds	\N
4135	395	581	\N	\N	13.21	seconds	\N
4161	47	600	\N	\N	25.79	seconds	\N
4136	1003	580	\N	\N	13.22	seconds	\N
4149	1027	600	\N	\N	24.15	seconds	\N
4137	478	581	\N	\N	13.28	seconds	\N
4138	682	581	\N	\N	13.33	seconds	\N
4139	1031	580	\N	\N	13.35	seconds	\N
4150	520	600	\N	\N	24.21	seconds	\N
4162	1098	600	\N	\N	25.85	seconds	\N
4151	1030	600	\N	\N	24.82	seconds	\N
4152	65	600	\N	\N	24.89	seconds	\N
4172	928	600	\N	\N	99999999.00	seconds	\N
4153	438	600	\N	\N	24.98	seconds	\N
4163	407	600	\N	\N	26.03	seconds	\N
4154	1050	600	\N	\N	25.07	seconds	\N
4155	482	600	\N	\N	25.11	seconds	\N
4156	689	600	\N	\N	25.15	seconds	\N
4164	1122	600	\N	\N	26.04	seconds	\N
4157	912	600	\N	\N	25.21	seconds	\N
4158	669	600	\N	\N	25.38	seconds	\N
4173	936	600	\N	\N	99999999.00	seconds	\N
4165	945	600	\N	\N	26.08	seconds	\N
4174	972	600	\N	\N	99999999.00	seconds	\N
4166	485	600	\N	\N	26.39	seconds	\N
4167	806	600	\N	\N	26.84	seconds	\N
4175	1085	600	\N	\N	99999999.00	seconds	\N
4168	671	600	\N	\N	26.97	seconds	\N
4169	511	600	\N	\N	28.27	seconds	\N
4179	998	599	\N	\N	24.83	seconds	\N
4170	896	600	\N	\N	29.11	seconds	\N
4176	1072	598	\N	\N	23.80	seconds	\N
4177	837	599	\N	\N	24.59	seconds	\N
4185	5	599	\N	\N	25.52	seconds	\N
4178	927	599	\N	\N	24.80	seconds	\N
4183	838	599	\N	\N	25.36	seconds	\N
4180	877	598	\N	\N	24.88	seconds	\N
4181	794	598	\N	\N	25.13	seconds	\N
4182	1125	599	\N	\N	25.31	seconds	\N
4184	973	599	\N	\N	25.42	seconds	\N
4186	1088	599	\N	\N	25.74	seconds	\N
4187	898	599	\N	\N	25.89	seconds	\N
4188	61	598	\N	\N	26.00	seconds	\N
4189	1080	598	\N	\N	26.24	seconds	\N
4190	693	598	\N	\N	26.25	seconds	\N
4191	1091	598	\N	\N	26.28	seconds	\N
4192	900	599	\N	\N	26.31	seconds	\N
4193	749	599	\N	\N	26.53	seconds	\N
4194	1031	598	\N	\N	26.59	seconds	\N
4195	991	599	\N	\N	26.71	seconds	\N
4196	1062	598	\N	\N	26.73	seconds	\N
4197	421	598	\N	\N	26.91	seconds	\N
4198	682	599	\N	\N	26.99	seconds	\N
4199	748	599	\N	\N	26.99	seconds	\N
4200	931	599	\N	\N	27.49	seconds	\N
4201	395	599	\N	\N	27.58	seconds	\N
4202	917	599	\N	\N	27.62	seconds	\N
4203	451	599	\N	\N	27.70	seconds	\N
4204	801	599	\N	\N	28.67	seconds	\N
4253	682	575	\N	\N	64.12	seconds	\N
4205	502	599	\N	\N	28.94	seconds	\N
4206	665	598	\N	\N	28.99	seconds	\N
4285	929	588	\N	\N	99999999.00	seconds	\N
4207	465	598	\N	\N	30.00	seconds	\N
4208	1055	599	\N	\N	99999999.00	seconds	\N
4254	652	574	\N	\N	64.57	seconds	\N
4209	912	576	\N	\N	52.81	seconds	\N
4210	859	576	\N	\N	53.42	seconds	\N
4255	465	574	\N	\N	99999999.00	seconds	\N
4211	924	576	\N	\N	53.98	seconds	\N
4212	853	576	\N	\N	54.08	seconds	\N
4256	932	575	\N	\N	99999999.00	seconds	\N
4213	23	576	\N	\N	54.23	seconds	\N
4214	1066	576	\N	\N	55.10	seconds	\N
4257	1056	574	\N	\N	99999999.00	seconds	\N
4215	37	576	\N	\N	55.32	seconds	\N
4216	407	576	\N	\N	56.26	seconds	\N
4258	690	575	\N	\N	99999999.00	seconds	\N
4217	1109	576	\N	\N	56.42	seconds	\N
4218	1126	576	\N	\N	56.44	seconds	\N
4219	22	576	\N	\N	56.55	seconds	\N
4259	516	588	\N	\N	117.76	seconds	\N
4220	531	576	\N	\N	57.59	seconds	\N
4221	880	576	\N	\N	57.77	seconds	\N
4303	1079	587	\N	\N	140.32	seconds	\N
4222	689	576	\N	\N	57.89	seconds	\N
4260	1019	588	\N	\N	124.18	seconds	\N
4223	1050	576	\N	\N	58.61	seconds	\N
4224	1076	576	\N	\N	58.66	seconds	\N
4286	625	586	\N	\N	124.27	seconds	\N
4225	906	576	\N	\N	59.22	seconds	\N
4261	592	587	\N	\N	124.46	seconds	\N
4226	425	576	\N	\N	60.59	seconds	\N
4227	671	576	\N	\N	60.86	seconds	\N
4228	398	576	\N	\N	61.64	seconds	\N
4229	493	576	\N	\N	99999999.00	seconds	\N
4262	1117	588	\N	\N	125.00	seconds	\N
4230	802	574	\N	\N	53.31	seconds	\N
4231	997	575	\N	\N	53.71	seconds	\N
4232	898	575	\N	\N	54.56	seconds	\N
4263	1073	587	\N	\N	125.58	seconds	\N
4233	1110	574	\N	\N	55.41	seconds	\N
4234	877	574	\N	\N	55.44	seconds	\N
4287	997	587	\N	\N	126.36	seconds	\N
4235	1124	575	\N	\N	55.87	seconds	\N
4264	1077	588	\N	\N	126.18	seconds	\N
4236	780	574	\N	\N	56.42	seconds	\N
4237	749	575	\N	\N	56.66	seconds	\N
4238	900	575	\N	\N	56.91	seconds	\N
4265	1119	588	\N	\N	127.00	seconds	\N
4239	838	575	\N	\N	57.40	seconds	\N
4240	1072	574	\N	\N	57.51	seconds	\N
4241	495	575	\N	\N	57.54	seconds	\N
4266	972	588	\N	\N	128.97	seconds	\N
4242	1032	575	\N	\N	57.99	seconds	\N
4243	748	575	\N	\N	58.51	seconds	\N
4288	39	587	\N	\N	128.45	seconds	\N
4244	32	575	\N	\N	58.61	seconds	\N
4267	1074	588	\N	\N	130.00	seconds	\N
4245	991	575	\N	\N	59.53	seconds	\N
4246	1080	574	\N	\N	59.77	seconds	\N
4247	832	574	\N	\N	59.98	seconds	\N
4268	841	588	\N	\N	131.07	seconds	\N
4248	917	575	\N	\N	59.99	seconds	\N
4249	5	575	\N	\N	60.56	seconds	\N
4304	845	587	\N	\N	140.73	seconds	\N
4250	1062	574	\N	\N	60.95	seconds	\N
4269	481	588	\N	\N	135.15	seconds	\N
4251	990	575	\N	\N	61.09	seconds	\N
4252	931	575	\N	\N	61.50	seconds	\N
4289	1021	587	\N	\N	130.13	seconds	\N
4270	907	588	\N	\N	135.97	seconds	\N
4271	836	588	\N	\N	136.35	seconds	\N
4272	1126	588	\N	\N	136.53	seconds	\N
4290	752	587	\N	\N	130.13	seconds	\N
4273	906	588	\N	\N	139.11	seconds	\N
4274	839	588	\N	\N	139.42	seconds	\N
4275	910	587	\N	\N	139.81	seconds	\N
4291	999	587	\N	\N	131.31	seconds	\N
4276	988	588	\N	\N	140.42	seconds	\N
4277	1116	588	\N	\N	144.10	seconds	\N
4305	897	587	\N	\N	142.30	seconds	\N
4278	458	588	\N	\N	147.74	seconds	\N
4292	1034	587	\N	\N	132.73	seconds	\N
4279	936	588	\N	\N	148.39	seconds	\N
4280	413	588	\N	\N	149.56	seconds	\N
4281	662	588	\N	\N	150.12	seconds	\N
4293	810	587	\N	\N	132.90	seconds	\N
4282	975	588	\N	\N	150.37	seconds	\N
4283	449	588	\N	\N	152.35	seconds	\N
4315	1051	587	\N	\N	164.19	seconds	\N
4284	1052	588	\N	\N	233.29	seconds	\N
4294	514	586	\N	\N	133.01	seconds	\N
4306	815	587	\N	\N	144.15	seconds	\N
4295	1067	587	\N	\N	135.00	seconds	\N
4296	615	586	\N	\N	135.08	seconds	\N
4297	884	587	\N	\N	137.46	seconds	\N
4307	951	586	\N	\N	148.00	seconds	\N
4298	608	586	\N	\N	138.00	seconds	\N
4299	1078	587	\N	\N	138.07	seconds	\N
4300	48	587	\N	\N	138.20	seconds	\N
4308	847	586	\N	\N	151.66	seconds	\N
4301	1032	587	\N	\N	138.73	seconds	\N
4302	787	586	\N	\N	139.30	seconds	\N
4316	691	586	\N	\N	185.55	seconds	\N
4309	899	587	\N	\N	151.99	seconds	\N
4322	1077	552	\N	\N	291.48	seconds	\N
4310	410	586	\N	\N	155.91	seconds	\N
4317	516	552	\N	\N	262.73	seconds	\N
4311	754	586	\N	\N	160.55	seconds	\N
4312	765	587	\N	\N	161.12	seconds	\N
4313	434	587	\N	\N	161.72	seconds	\N
4318	592	551	\N	\N	272.96	seconds	\N
4314	698	586	\N	\N	162.22	seconds	\N
4326	841	552	\N	\N	300.46	seconds	\N
4319	1019	552	\N	\N	275.24	seconds	\N
4323	481	552	\N	\N	292.77	seconds	\N
4320	1073	551	\N	\N	278.74	seconds	\N
4321	490	552	\N	\N	286.65	seconds	\N
4324	911	552	\N	\N	296.91	seconds	\N
4330	869	552	\N	\N	309.84	seconds	\N
4325	910	551	\N	\N	298.11	seconds	\N
4327	970	552	\N	\N	302.93	seconds	\N
4329	833	552	\N	\N	307.59	seconds	\N
4328	978	552	\N	\N	303.99	seconds	\N
4331	1013	552	\N	\N	310.42	seconds	\N
4332	409	552	\N	\N	311.85	seconds	\N
4333	1074	552	\N	\N	316.10	seconds	\N
4334	458	552	\N	\N	327.22	seconds	\N
4335	975	552	\N	\N	328.26	seconds	\N
4336	413	552	\N	\N	331.00	seconds	\N
4337	662	552	\N	\N	333.17	seconds	\N
4338	903	552	\N	\N	335.16	seconds	\N
4339	929	552	\N	\N	99999999.00	seconds	\N
4340	752	551	\N	\N	281.18	seconds	\N
4341	625	550	\N	\N	283.59	seconds	\N
4342	470	551	\N	\N	284.93	seconds	\N
4343	810	551	\N	\N	286.51	seconds	\N
4344	1000	551	\N	\N	287.82	seconds	\N
4345	39	551	\N	\N	293.23	seconds	\N
4346	999	551	\N	\N	293.45	seconds	\N
4347	1021	551	\N	\N	293.84	seconds	\N
4397	929	606	\N	\N	99999999.00	seconds	\N
4348	514	550	\N	\N	293.87	seconds	\N
4349	815	551	\N	\N	294.72	seconds	\N
4350	874	551	\N	\N	297.35	seconds	\N
4398	1000	605	\N	\N	625.57	seconds	\N
4351	1034	551	\N	\N	300.89	seconds	\N
4352	1078	551	\N	\N	302.14	seconds	\N
4429	887	568	\N	\N	13.07	seconds	\N
4353	619	550	\N	\N	302.88	seconds	\N
4399	874	605	\N	\N	638.79	seconds	\N
4354	36	551	\N	\N	303.22	seconds	\N
4355	13	552	\N	\N	303.84	seconds	\N
4356	884	551	\N	\N	305.39	seconds	\N
4400	13	606	\N	\N	653.15	seconds	\N
4357	897	551	\N	\N	306.25	seconds	\N
4358	787	550	\N	\N	306.46	seconds	\N
4449	1093	594	\N	\N	41.18	seconds	\N
4359	845	551	\N	\N	306.68	seconds	\N
4401	36	605	\N	\N	653.20	seconds	\N
4360	609	550	\N	\N	307.41	seconds	\N
4361	1104	550	\N	\N	308.45	seconds	\N
4430	962	569	\N	\N	13.14	seconds	\N
4362	951	550	\N	\N	316.29	seconds	\N
4402	1015	605	\N	\N	663.22	seconds	\N
4363	1025	551	\N	\N	318.94	seconds	\N
4364	717	550	\N	\N	319.49	seconds	\N
4365	1067	551	\N	\N	325.00	seconds	\N
4403	1025	605	\N	\N	673.08	seconds	\N
4366	1079	551	\N	\N	328.96	seconds	\N
4367	410	550	\N	\N	344.35	seconds	\N
4431	478	569	\N	\N	99999999.00	seconds	\N
4368	765	551	\N	\N	346.02	seconds	\N
4404	965	605	\N	\N	681.05	seconds	\N
4369	436	551	\N	\N	347.78	seconds	\N
4370	754	550	\N	\N	352.03	seconds	\N
4371	1051	551	\N	\N	356.72	seconds	\N
4405	787	604	\N	\N	686.89	seconds	\N
4372	698	550	\N	\N	357.95	seconds	\N
4373	771	551	\N	\N	358.30	seconds	\N
4432	1059	569	\N	\N	99999999.00	seconds	\N
4374	932	551	\N	\N	365.64	seconds	\N
4406	717	604	\N	\N	694.37	seconds	\N
4375	899	551	\N	\N	366.99	seconds	\N
4376	921	551	\N	\N	381.07	seconds	\N
4377	691	550	\N	\N	414.30	seconds	\N
4407	883	605	\N	\N	700.12	seconds	\N
4378	472	550	\N	\N	433.02	seconds	\N
4379	516	606	\N	\N	604.07	seconds	\N
4433	1127	569	\N	\N	99999999.00	seconds	\N
4380	1103	606	\N	\N	613.19	seconds	\N
4408	795	604	\N	\N	729.67	seconds	\N
4381	490	606	\N	\N	620.79	seconds	\N
4382	1111	606	\N	\N	624.08	seconds	\N
4383	913	606	\N	\N	659.41	seconds	\N
4409	870	604	\N	\N	763.75	seconds	\N
4384	978	606	\N	\N	665.51	seconds	\N
4385	970	606	\N	\N	666.20	seconds	\N
4386	833	606	\N	\N	674.60	seconds	\N
4410	436	605	\N	\N	768.13	seconds	\N
4387	907	606	\N	\N	683.41	seconds	\N
4388	836	606	\N	\N	683.99	seconds	\N
4434	890	564	\N	\N	15.97	seconds	\N
4389	914	605	\N	\N	692.01	seconds	\N
4411	698	604	\N	\N	770.00	seconds	\N
4390	1013	606	\N	\N	695.38	seconds	\N
4391	409	606	\N	\N	712.35	seconds	\N
4392	458	606	\N	\N	713.48	seconds	\N
4412	765	605	\N	\N	784.34	seconds	\N
4393	662	606	\N	\N	734.81	seconds	\N
4394	432	606	\N	\N	786.98	seconds	\N
4460	1076	594	\N	\N	49.15	seconds	\N
4395	885	606	\N	\N	803.11	seconds	\N
4396	481	606	\N	\N	99999999.00	seconds	\N
4413	450	604	\N	\N	823.69	seconds	\N
4414	470	605	\N	\N	99999999.00	seconds	\N
4415	514	604	\N	\N	99999999.00	seconds	\N
4416	934	605	\N	\N	99999999.00	seconds	\N
4435	1108	564	\N	\N	16.06	seconds	\N
4417	491	569	\N	\N	10.18	seconds	\N
4418	802	568	\N	\N	10.52	seconds	\N
4450	879	594	\N	\N	43.27	seconds	\N
4419	62	569	\N	\N	10.70	seconds	\N
4436	54	564	\N	\N	17.18	seconds	\N
4420	8	569	\N	\N	10.99	seconds	\N
4421	893	569	\N	\N	11.05	seconds	\N
4422	1056	568	\N	\N	11.37	seconds	\N
4437	872	564	\N	\N	17.72	seconds	\N
4423	784	568	\N	\N	11.39	seconds	\N
4424	1017	569	\N	\N	11.56	seconds	\N
4425	1015	569	\N	\N	11.68	seconds	\N
4438	1081	564	\N	\N	17.77	seconds	\N
4426	1113	568	\N	\N	11.87	seconds	\N
4427	1075	569	\N	\N	11.96	seconds	\N
4451	656	594	\N	\N	44.13	seconds	\N
4428	983	568	\N	\N	12.42	seconds	\N
4439	527	564	\N	\N	17.84	seconds	\N
4440	656	564	\N	\N	18.04	seconds	\N
4467	1124	593	\N	\N	46.43	seconds	\N
4441	1007	564	\N	\N	18.14	seconds	\N
4452	54	594	\N	\N	44.92	seconds	\N
4442	1114	564	\N	\N	18.41	seconds	\N
4443	956	564	\N	\N	19.58	seconds	\N
4461	396	594	\N	\N	51.21	seconds	\N
4444	955	564	\N	\N	20.70	seconds	\N
4453	1064	594	\N	\N	45.12	seconds	\N
4445	396	564	\N	\N	21.67	seconds	\N
4446	799	562	\N	\N	22.13	seconds	\N
4447	1076	564	\N	\N	22.44	seconds	\N
4448	808	563	\N	\N	99999999.00	seconds	\N
4454	1066	594	\N	\N	45.32	seconds	\N
4455	872	594	\N	\N	45.35	seconds	\N
4462	955	594	\N	\N	52.94	seconds	\N
4456	890	594	\N	\N	45.40	seconds	\N
4457	527	594	\N	\N	46.33	seconds	\N
4463	808	593	\N	\N	99999999.00	seconds	\N
4458	1007	594	\N	\N	46.39	seconds	\N
4459	956	594	\N	\N	48.98	seconds	\N
4471	478	593	\N	\N	49.92	seconds	\N
4464	62	593	\N	\N	45.87	seconds	\N
4468	893	593	\N	\N	48.01	seconds	\N
4465	802	592	\N	\N	46.17	seconds	\N
4466	491	593	\N	\N	46.40	seconds	\N
4469	1015	593	\N	\N	49.32	seconds	\N
4475	887	592	\N	\N	57.10	seconds	\N
4470	8	593	\N	\N	49.88	seconds	\N
4472	1075	593	\N	\N	50.18	seconds	\N
4474	983	592	\N	\N	51.88	seconds	\N
4473	784	592	\N	\N	50.29	seconds	\N
4476	965	593	\N	\N	57.88	seconds	\N
4477	962	593	\N	\N	58.58	seconds	\N
4478	1059	593	\N	\N	99999999.00	seconds	\N
4479	1127	593	\N	\N	99999999.00	seconds	\N
4480	661	648	\N	\N	609.00	inches	\N
4481	878	648	\N	\N	577.00	inches	\N
4482	1096	648	\N	\N	516.50	inches	\N
4483	1121	648	\N	\N	503.25	inches	\N
4484	846	648	\N	\N	495.50	inches	\N
4485	497	648	\N	\N	495.00	inches	\N
4486	1083	648	\N	\N	493.00	inches	\N
4487	518	648	\N	\N	476.00	inches	\N
4488	966	648	\N	\N	468.00	inches	\N
4489	1071	648	\N	\N	450.50	inches	\N
4490	949	648	\N	\N	449.00	inches	\N
4491	445	648	\N	\N	444.50	inches	\N
4492	737	648	\N	\N	437.25	inches	\N
4572	826	640	\N	\N	838.00	inches	\N
4493	1087	648	\N	\N	436.00	inches	\N
4542	737	642	\N	\N	1260.00	inches	\N
4494	1107	648	\N	\N	435.00	inches	\N
4495	512	648	\N	\N	427.75	inches	\N
4496	431	648	\N	\N	423.00	inches	\N
4543	33	642	\N	\N	1222.00	inches	\N
4497	1065	648	\N	\N	420.00	inches	\N
4498	942	648	\N	\N	413.00	inches	\N
4591	948	617	\N	\N	62.00	inches	\N
4499	888	648	\N	\N	403.50	inches	\N
4544	50	642	\N	\N	1212.00	inches	\N
4500	703	648	\N	\N	403.50	inches	\N
4501	59	648	\N	\N	402.00	inches	\N
4573	1054	640	\N	\N	595.00	inches	\N
4502	1029	648	\N	\N	399.00	inches	\N
4545	949	642	\N	\N	1167.00	inches	\N
4503	33	648	\N	\N	394.50	inches	\N
4504	50	648	\N	\N	393.00	inches	\N
4505	1010	648	\N	\N	380.50	inches	\N
4546	703	642	\N	\N	1133.00	inches	\N
4506	1053	648	\N	\N	285.00	inches	\N
4507	1052	648	\N	\N	231.50	inches	\N
4508	460	647	\N	\N	557.00	inches	\N
4547	1010	642	\N	\N	1102.00	inches	\N
4509	856	647	\N	\N	466.00	inches	\N
4510	1002	647	\N	\N	460.00	inches	\N
4574	775	640	\N	\N	504.00	inches	\N
4511	792	646	\N	\N	454.50	inches	\N
4548	1071	642	\N	\N	1091.00	inches	\N
4512	76	647	\N	\N	447.00	inches	\N
4513	791	646	\N	\N	432.00	inches	\N
4514	981	647	\N	\N	417.00	inches	\N
4549	67	642	\N	\N	1083.00	inches	\N
4515	1128	646	\N	\N	405.00	inches	\N
4516	1012	646	\N	\N	399.00	inches	\N
4517	397	647	\N	\N	390.75	inches	\N
4550	431	642	\N	\N	877.00	inches	\N
4518	51	646	\N	\N	376.00	inches	\N
4519	700	647	\N	\N	356.00	inches	\N
4575	684	640	\N	\N	499.00	inches	\N
4520	826	646	\N	\N	344.75	inches	\N
4551	445	642	\N	\N	869.00	inches	\N
4521	488	647	\N	\N	335.50	inches	\N
4522	892	646	\N	\N	323.00	inches	\N
4523	775	646	\N	\N	288.00	inches	\N
4552	1029	642	\N	\N	856.00	inches	\N
4524	1054	646	\N	\N	272.50	inches	\N
4525	684	646	\N	\N	212.50	inches	\N
4526	957	646	\N	\N	0.00	inches	\N
4527	1068	647	\N	\N	0.00	inches	\N
4592	960	616	\N	\N	62.00	inches	\N
4528	878	642	\N	\N	1663.00	inches	\N
4553	842	642	\N	\N	722.00	inches	\N
4529	1096	642	\N	\N	1598.00	inches	\N
4530	661	642	\N	\N	1582.00	inches	\N
4576	985	618	\N	\N	70.00	inches	\N
4531	1087	642	\N	\N	1522.00	inches	\N
4554	1052	642	\N	\N	613.00	inches	\N
4532	1121	642	\N	\N	1518.00	inches	\N
4533	1089	642	\N	\N	1510.00	inches	\N
4534	497	642	\N	\N	1509.00	inches	\N
4555	1002	641	\N	\N	1346.00	inches	\N
4535	942	642	\N	\N	1457.00	inches	\N
4536	966	642	\N	\N	1399.00	inches	\N
4537	846	642	\N	\N	1322.00	inches	\N
4556	460	641	\N	\N	1315.00	inches	\N
4538	1065	642	\N	\N	1320.00	inches	\N
4539	1083	642	\N	\N	1281.00	inches	\N
4577	27	618	\N	\N	68.00	inches	\N
4540	532	642	\N	\N	1273.00	inches	\N
4557	954	641	\N	\N	1186.00	inches	\N
4541	518	642	\N	\N	1273.00	inches	\N
4558	856	641	\N	\N	1142.00	inches	\N
4604	681	616	\N	\N	0.00	inches	\N
4559	1068	641	\N	\N	1135.00	inches	\N
4578	1093	618	\N	\N	68.00	inches	\N
4560	76	641	\N	\N	1089.00	inches	\N
4561	488	641	\N	\N	1039.00	inches	\N
4593	976	616	\N	\N	62.00	inches	\N
4562	1128	640	\N	\N	1020.00	inches	\N
4579	879	618	\N	\N	66.00	inches	\N
4563	792	640	\N	\N	1002.00	inches	\N
4564	892	640	\N	\N	969.00	inches	\N
4565	397	641	\N	\N	967.00	inches	\N
4580	890	618	\N	\N	66.00	inches	\N
4566	941	640	\N	\N	965.00	inches	\N
4567	700	641	\N	\N	937.00	inches	\N
4568	791	640	\N	\N	922.00	inches	\N
4581	49	618	\N	\N	66.00	inches	\N
4569	921	641	\N	\N	920.00	inches	\N
4570	1012	640	\N	\N	870.00	inches	\N
4594	1021	617	\N	\N	62.00	inches	\N
4571	51	640	\N	\N	855.00	inches	\N
4582	509	618	\N	\N	64.00	inches	\N
4605	451	617	\N	\N	0.00	inches	\N
4583	1115	618	\N	\N	64.00	inches	\N
4595	403	617	\N	\N	60.00	inches	\N
4584	522	618	\N	\N	62.00	inches	\N
4585	872	618	\N	\N	60.00	inches	\N
4586	1039	618	\N	\N	60.00	inches	\N
4596	507	617	\N	\N	60.00	inches	\N
4587	823	618	\N	\N	58.00	inches	\N
4588	979	618	\N	\N	0.00	inches	\N
4589	781	616	\N	\N	70.00	inches	\N
4606	693	616	\N	\N	0.00	inches	\N
4590	1088	617	\N	\N	64.00	inches	\N
4597	630	617	\N	\N	60.00	inches	\N
4598	1080	616	\N	\N	60.00	inches	\N
4607	1106	624	\N	\N	156.00	inches	\N
4599	805	616	\N	\N	58.00	inches	\N
4600	665	616	\N	\N	56.00	inches	\N
4601	886	616	\N	\N	54.00	inches	\N
4602	843	617	\N	\N	0.00	inches	\N
4603	433	617	\N	\N	0.00	inches	\N
4608	1018	624	\N	\N	150.00	inches	\N
4612	956	624	\N	\N	120.00	inches	\N
4609	527	624	\N	\N	126.00	inches	\N
4610	989	624	\N	\N	126.00	inches	\N
4618	879	624	\N	\N	102.00	inches	\N
4611	505	624	\N	\N	120.00	inches	\N
4613	1006	624	\N	\N	120.00	inches	\N
4616	27	624	\N	\N	108.00	inches	\N
4614	629	624	\N	\N	120.00	inches	\N
4615	493	624	\N	\N	114.00	inches	\N
4617	1090	623	\N	\N	108.00	inches	\N
4620	833	624	\N	\N	0.00	inches	\N
4619	882	624	\N	\N	84.00	inches	\N
4621	79	622	\N	\N	120.00	inches	\N
4622	61	622	\N	\N	120.00	inches	\N
4623	1017	623	\N	\N	114.00	inches	\N
4624	1125	623	\N	\N	114.00	inches	\N
4625	630	623	\N	\N	102.00	inches	\N
4626	1061	622	\N	\N	102.00	inches	\N
4627	690	623	\N	\N	102.00	inches	\N
4628	1113	622	\N	\N	96.00	inches	\N
4629	71	623	\N	\N	90.00	inches	\N
4630	974	623	\N	\N	90.00	inches	\N
4631	950	622	\N	\N	90.00	inches	\N
4632	681	622	\N	\N	84.00	inches	\N
4633	964	622	\N	\N	0.00	inches	\N
4634	845	623	\N	\N	0.00	inches	\N
4635	1022	622	\N	\N	0.00	inches	\N
4636	937	628	\N	\N	253.00	inches	\N
4687	1063	636	\N	\N	457.50	inches	\N
4637	1018	630	\N	\N	249.00	inches	\N
4638	1070	630	\N	\N	241.50	inches	\N
4718	825	687	\N	\N	14.89	seconds	\N
4639	871	630	\N	\N	235.00	inches	\N
4688	530	636	\N	\N	420.50	inches	\N
4640	985	630	\N	\N	226.00	inches	\N
4641	859	630	\N	\N	225.00	inches	\N
4642	1014	630	\N	\N	218.00	inches	\N
4689	1039	636	\N	\N	412.50	inches	\N
4643	49	630	\N	\N	217.00	inches	\N
4644	1039	630	\N	\N	217.00	inches	\N
4756	385	679	\N	\N	76.80	seconds	\N
4645	509	630	\N	\N	216.00	inches	\N
4690	1009	636	\N	\N	412.50	inches	\N
4646	1063	630	\N	\N	215.00	inches	\N
4647	1122	630	\N	\N	212.50	inches	\N
4719	594	685	\N	\N	15.17	seconds	\N
4648	530	630	\N	\N	211.50	inches	\N
4691	989	636	\N	\N	404.00	inches	\N
4649	534	630	\N	\N	205.00	inches	\N
4650	989	630	\N	\N	204.50	inches	\N
4651	876	630	\N	\N	200.00	inches	\N
4692	508	636	\N	\N	397.00	inches	\N
4652	1081	630	\N	\N	197.00	inches	\N
4653	430	630	\N	\N	192.00	inches	\N
4737	385	703	\N	\N	33.69	seconds	\N
4654	412	630	\N	\N	188.75	inches	\N
4693	840	636	\N	\N	393.00	inches	\N
4655	823	630	\N	\N	150.50	inches	\N
4656	979	630	\N	\N	0.00	inches	\N
4657	689	630	\N	\N	0.00	inches	\N
4658	519	629	\N	\N	230.00	inches	\N
4720	328	685	\N	\N	15.39	seconds	\N
4659	1125	629	\N	\N	224.00	inches	\N
4694	430	636	\N	\N	383.50	inches	\N
4660	1110	628	\N	\N	223.00	inches	\N
4661	403	629	\N	\N	217.50	inches	\N
4662	1091	628	\N	\N	214.00	inches	\N
4695	979	636	\N	\N	381.50	inches	\N
4663	491	629	\N	\N	212.50	inches	\N
4664	1038	629	\N	\N	212.50	inches	\N
4665	1072	628	\N	\N	210.00	inches	\N
4696	868	636	\N	\N	379.00	inches	\N
4666	1075	629	\N	\N	209.50	inches	\N
4667	976	628	\N	\N	209.00	inches	\N
4721	369	687	\N	\N	15.46	seconds	\N
4668	781	628	\N	\N	207.00	inches	\N
4697	412	636	\N	\N	368.50	inches	\N
4669	1082	628	\N	\N	204.00	inches	\N
4670	478	629	\N	\N	202.00	inches	\N
4698	823	636	\N	\N	0.00	inches	\N
4671	973	629	\N	\N	198.50	inches	\N
4672	893	629	\N	\N	197.00	inches	\N
4673	771	629	\N	\N	195.25	inches	\N
4699	519	635	\N	\N	501.00	inches	\N
4674	844	629	\N	\N	193.00	inches	\N
4675	960	628	\N	\N	192.00	inches	\N
4750	611	680	\N	\N	70.57	seconds	\N
4676	690	629	\N	\N	191.00	inches	\N
4700	403	635	\N	\N	457.00	inches	\N
4677	451	629	\N	\N	181.00	inches	\N
4678	433	629	\N	\N	178.00	inches	\N
4722	477	686	\N	\N	16.23	seconds	\N
4679	843	629	\N	\N	174.50	inches	\N
4701	802	634	\N	\N	448.00	inches	\N
4680	1022	628	\N	\N	164.50	inches	\N
4681	1031	628	\N	\N	0.00	inches	\N
4682	1055	629	\N	\N	0.00	inches	\N
4683	1018	636	\N	\N	530.50	inches	\N
4684	985	636	\N	\N	487.00	inches	\N
4702	781	634	\N	\N	430.50	inches	\N
4685	859	636	\N	\N	475.50	inches	\N
4686	509	636	\N	\N	467.00	inches	\N
4738	342	703	\N	\N	34.77	seconds	\N
4723	464	685	\N	\N	16.53	seconds	\N
4703	1038	635	\N	\N	412.50	inches	\N
4704	948	635	\N	\N	411.50	inches	\N
4705	843	635	\N	\N	400.00	inches	\N
4724	620	685	\N	\N	17.30	seconds	\N
4706	844	635	\N	\N	399.50	inches	\N
4707	690	635	\N	\N	399.50	inches	\N
4708	451	635	\N	\N	392.00	inches	\N
4725	357	686	\N	\N	17.57	seconds	\N
4709	894	634	\N	\N	379.00	inches	\N
4710	994	635	\N	\N	377.00	inches	\N
4739	464	703	\N	\N	34.95	seconds	\N
4711	433	635	\N	\N	370.00	inches	\N
4726	777	686	\N	\N	17.91	seconds	\N
4712	974	635	\N	\N	352.50	inches	\N
4713	1022	634	\N	\N	324.50	inches	\N
4714	1055	635	\N	\N	0.00	inches	\N
4727	770	686	\N	\N	99999999.00	seconds	\N
4715	528	685	\N	\N	13.72	seconds	\N
4716	617	686	\N	\N	13.98	seconds	\N
4717	827	685	\N	\N	14.78	seconds	\N
4728	627	705	\N	\N	27.10	seconds	\N
4740	477	704	\N	\N	35.05	seconds	\N
4729	528	703	\N	\N	29.08	seconds	\N
4730	825	705	\N	\N	31.22	seconds	\N
4751	623	681	\N	\N	73.85	seconds	\N
4731	611	704	\N	\N	31.74	seconds	\N
4741	620	703	\N	\N	37.71	seconds	\N
4732	594	703	\N	\N	31.78	seconds	\N
4733	623	705	\N	\N	31.91	seconds	\N
4734	328	703	\N	\N	32.25	seconds	\N
4742	777	704	\N	\N	39.48	seconds	\N
4735	358	703	\N	\N	32.62	seconds	\N
4736	384	704	\N	\N	32.68	seconds	\N
4743	334	703	\N	\N	99999999.00	seconds	\N
4744	770	704	\N	\N	99999999.00	seconds	\N
4745	367	704	\N	\N	99999999.00	seconds	\N
4746	357	704	\N	\N	99999999.00	seconds	\N
4747	369	705	\N	\N	99999999.00	seconds	\N
4763	362	691	\N	\N	166.51	seconds	\N
4748	367	680	\N	\N	60.62	seconds	\N
4752	489	681	\N	\N	74.68	seconds	\N
4749	628	681	\N	\N	64.24	seconds	\N
4757	342	679	\N	\N	80.50	seconds	\N
4753	529	681	\N	\N	75.35	seconds	\N
4754	335	680	\N	\N	75.37	seconds	\N
4758	380	679	\N	\N	99999999.00	seconds	\N
4755	358	679	\N	\N	76.35	seconds	\N
4761	366	691	\N	\N	154.98	seconds	\N
4759	1130	680	\N	\N	99999999.00	seconds	\N
4760	624	693	\N	\N	151.78	seconds	\N
4762	595	692	\N	\N	157.31	seconds	\N
4764	335	692	\N	\N	173.75	seconds	\N
4765	521	693	\N	\N	176.73	seconds	\N
4766	499	693	\N	\N	178.61	seconds	\N
4767	341	691	\N	\N	182.10	seconds	\N
4768	606	693	\N	\N	183.96	seconds	\N
4769	474	693	\N	\N	192.31	seconds	\N
4770	469	691	\N	\N	99999999.00	seconds	\N
4771	819	692	\N	\N	99999999.00	seconds	\N
4772	624	657	\N	\N	335.93	seconds	\N
4773	595	656	\N	\N	337.35	seconds	\N
4774	366	655	\N	\N	338.73	seconds	\N
4775	819	656	\N	\N	339.01	seconds	\N
4776	362	655	\N	\N	362.37	seconds	\N
4777	469	655	\N	\N	372.04	seconds	\N
4778	521	657	\N	\N	374.42	seconds	\N
4779	492	656	\N	\N	380.60	seconds	\N
4780	499	657	\N	\N	386.01	seconds	\N
4833	623	723	\N	\N	44.00	inches	\N
4781	486	657	\N	\N	390.43	seconds	\N
4782	474	657	\N	\N	99999999.00	seconds	\N
4783	521	711	\N	\N	808.09	seconds	\N
4784	492	710	\N	\N	824.97	seconds	\N
4834	593	721	\N	\N	42.00	inches	\N
4785	341	709	\N	\N	859.35	seconds	\N
4786	499	711	\N	\N	868.61	seconds	\N
4835	524	722	\N	\N	0.00	inches	\N
4787	486	711	\N	\N	868.65	seconds	\N
4788	606	711	\N	\N	894.38	seconds	\N
4789	469	709	\N	\N	99999999.00	seconds	\N
4790	628	663	\N	\N	19.28	seconds	\N
4836	601	729	\N	\N	108.00	inches	\N
4791	496	663	\N	\N	19.42	seconds	\N
4792	517	663	\N	\N	20.17	seconds	\N
4864	383	690	\N	\N	12.19	seconds	\N
4793	355	662	\N	\N	20.78	seconds	\N
4837	501	729	\N	\N	78.00	inches	\N
4794	501	663	\N	\N	22.03	seconds	\N
4795	347	661	\N	\N	99999999.00	seconds	\N
4796	617	698	\N	\N	50.86	seconds	\N
4797	355	698	\N	\N	53.69	seconds	\N
4838	342	727	\N	\N	72.00	inches	\N
4798	517	699	\N	\N	55.33	seconds	\N
4799	496	699	\N	\N	57.31	seconds	\N
4905	383	708	\N	\N	25.26	seconds	\N
4800	501	699	\N	\N	62.30	seconds	\N
4801	380	697	\N	\N	99999999.00	seconds	\N
4839	489	729	\N	\N	66.00	inches	\N
4802	503	753	\N	\N	337.00	inches	\N
4803	523	753	\N	\N	333.00	inches	\N
4840	384	728	\N	\N	0.00	inches	\N
4804	827	751	\N	\N	293.00	inches	\N
4805	526	753	\N	\N	276.50	inches	\N
4865	794	688	\N	\N	12.21	seconds	\N
4806	500	752	\N	\N	266.00	inches	\N
4841	627	735	\N	\N	181.50	inches	\N
4807	334	751	\N	\N	262.50	inches	\N
4808	601	753	\N	\N	231.50	inches	\N
4809	357	752	\N	\N	198.50	inches	\N
4842	487	734	\N	\N	178.00	inches	\N
4810	326	751	\N	\N	174.50	inches	\N
4811	811	752	\N	\N	0.00	inches	\N
4812	349	753	\N	\N	0.00	inches	\N
4813	783	752	\N	\N	0.00	inches	\N
4814	503	747	\N	\N	1034.00	inches	\N
4882	478	689	\N	\N	13.28	seconds	\N
4815	827	745	\N	\N	977.00	inches	\N
4843	347	733	\N	\N	176.00	inches	\N
4816	523	747	\N	\N	957.50	inches	\N
4817	525	747	\N	\N	865.00	inches	\N
4866	485	690	\N	\N	12.23	seconds	\N
4818	526	747	\N	\N	858.00	inches	\N
4844	498	734	\N	\N	169.00	inches	\N
4819	601	747	\N	\N	749.75	inches	\N
4820	500	746	\N	\N	726.00	inches	\N
4821	533	746	\N	\N	650.50	inches	\N
4845	533	734	\N	\N	162.00	inches	\N
4822	334	745	\N	\N	454.00	inches	\N
4823	357	746	\N	\N	409.00	inches	\N
4824	326	745	\N	\N	344.00	inches	\N
4825	811	746	\N	\N	0.00	inches	\N
4826	349	747	\N	\N	0.00	inches	\N
4846	515	733	\N	\N	157.00	inches	\N
4827	350	723	\N	\N	58.00	inches	\N
4828	487	722	\N	\N	56.00	inches	\N
4867	370	689	\N	\N	12.41	seconds	\N
4829	515	721	\N	\N	54.00	inches	\N
4847	349	735	\N	\N	154.75	inches	\N
4830	380	721	\N	\N	52.00	inches	\N
4831	626	723	\N	\N	52.00	inches	\N
4832	498	722	\N	\N	48.00	inches	\N
4893	465	688	\N	\N	14.85	seconds	\N
4848	536	735	\N	\N	148.00	inches	\N
4868	605	688	\N	\N	12.46	seconds	\N
4849	328	733	\N	\N	141.00	inches	\N
4850	524	734	\N	\N	127.00	inches	\N
4883	327	689	\N	\N	13.29	seconds	\N
4851	593	733	\N	\N	100.00	inches	\N
4852	350	735	\N	\N	0.00	inches	\N
4869	530	690	\N	\N	12.52	seconds	\N
4853	601	741	\N	\N	367.50	inches	\N
4854	533	740	\N	\N	359.50	inches	\N
4855	515	739	\N	\N	351.50	inches	\N
4870	596	688	\N	\N	12.55	seconds	\N
4856	626	741	\N	\N	347.50	inches	\N
4857	536	741	\N	\N	318.50	inches	\N
4858	498	740	\N	\N	317.50	inches	\N
4871	591	688	\N	\N	12.62	seconds	\N
4859	524	740	\N	\N	274.50	inches	\N
4860	597	690	\N	\N	11.53	seconds	\N
4884	463	689	\N	\N	13.44	seconds	\N
4861	520	690	\N	\N	11.78	seconds	\N
4872	348	689	\N	\N	12.64	seconds	\N
4862	482	690	\N	\N	11.92	seconds	\N
4863	386	689	\N	\N	12.04	seconds	\N
4873	332	689	\N	\N	12.70	seconds	\N
4894	476	688	\N	\N	99999999.00	seconds	\N
4874	824	688	\N	\N	12.71	seconds	\N
4885	484	688	\N	\N	13.54	seconds	\N
4875	771	689	\N	\N	12.82	seconds	\N
4876	479	688	\N	\N	12.83	seconds	\N
4877	801	689	\N	\N	12.89	seconds	\N
4886	502	689	\N	\N	13.69	seconds	\N
4878	374	688	\N	\N	12.96	seconds	\N
4879	604	688	\N	\N	13.01	seconds	\N
4895	376	690	\N	\N	99999999.00	seconds	\N
4880	354	690	\N	\N	13.02	seconds	\N
4887	599	689	\N	\N	13.77	seconds	\N
4881	806	690	\N	\N	13.04	seconds	\N
4888	382	690	\N	\N	13.91	seconds	\N
4896	818	690	\N	\N	99999999.00	seconds	\N
4889	368	689	\N	\N	14.01	seconds	\N
4890	345	688	\N	\N	14.07	seconds	\N
4897	928	690	\N	\N	99999999.00	seconds	\N
4891	343	689	\N	\N	14.36	seconds	\N
4892	475	690	\N	\N	14.83	seconds	\N
4898	930	688	\N	\N	99999999.00	seconds	\N
4899	598	688	\N	\N	99999999.00	seconds	\N
4902	386	707	\N	\N	24.86	seconds	\N
4900	597	708	\N	\N	23.35	seconds	\N
4901	520	708	\N	\N	24.21	seconds	\N
4903	482	708	\N	\N	25.11	seconds	\N
4907	340	708	\N	\N	25.42	seconds	\N
4904	794	706	\N	\N	25.13	seconds	\N
4906	370	707	\N	\N	25.37	seconds	\N
4908	605	706	\N	\N	25.42	seconds	\N
4909	332	707	\N	\N	25.94	seconds	\N
4910	348	707	\N	\N	26.18	seconds	\N
4911	596	706	\N	\N	26.19	seconds	\N
4912	485	708	\N	\N	26.39	seconds	\N
4913	806	708	\N	\N	26.84	seconds	\N
4914	779	706	\N	\N	27.02	seconds	\N
4915	360	707	\N	\N	27.82	seconds	\N
4916	599	707	\N	\N	27.99	seconds	\N
4917	368	707	\N	\N	28.43	seconds	\N
4918	484	706	\N	\N	28.64	seconds	\N
4919	502	707	\N	\N	28.94	seconds	\N
4920	476	706	\N	\N	29.39	seconds	\N
4921	603	708	\N	\N	29.48	seconds	\N
4922	465	706	\N	\N	30.00	seconds	\N
4923	343	707	\N	\N	30.47	seconds	\N
4924	371	708	\N	\N	34.17	seconds	\N
4925	354	708	\N	\N	99999999.00	seconds	\N
4926	382	708	\N	\N	99999999.00	seconds	\N
4927	463	707	\N	\N	99999999.00	seconds	\N
4928	473	706	\N	\N	99999999.00	seconds	\N
4929	479	706	\N	\N	99999999.00	seconds	\N
4930	475	708	\N	\N	99999999.00	seconds	\N
4931	928	708	\N	\N	99999999.00	seconds	\N
4932	930	706	\N	\N	99999999.00	seconds	\N
4979	481	660	\N	\N	292.77	seconds	\N
4933	802	682	\N	\N	53.31	seconds	\N
4934	780	682	\N	\N	56.42	seconds	\N
5011	378	672	\N	\N	16.68	seconds	\N
4935	473	682	\N	\N	56.92	seconds	\N
4980	514	658	\N	\N	293.87	seconds	\N
4936	495	683	\N	\N	57.54	seconds	\N
4937	531	684	\N	\N	57.59	seconds	\N
4938	352	684	\N	\N	57.81	seconds	\N
4981	600	660	\N	\N	298.28	seconds	\N
4939	340	684	\N	\N	57.96	seconds	\N
4940	325	684	\N	\N	59.76	seconds	\N
4941	591	682	\N	\N	60.72	seconds	\N
4982	381	660	\N	\N	298.81	seconds	\N
4942	337	682	\N	\N	61.04	seconds	\N
4943	785	682	\N	\N	62.06	seconds	\N
5012	527	672	\N	\N	17.84	seconds	\N
4944	622	682	\N	\N	62.49	seconds	\N
4983	351	658	\N	\N	301.45	seconds	\N
4945	476	682	\N	\N	63.63	seconds	\N
4946	360	683	\N	\N	65.16	seconds	\N
4947	364	682	\N	\N	65.45	seconds	\N
4984	619	658	\N	\N	302.88	seconds	\N
4948	375	684	\N	\N	68.14	seconds	\N
4949	371	684	\N	\N	75.36	seconds	\N
4950	465	682	\N	\N	99999999.00	seconds	\N
4951	484	682	\N	\N	99999999.00	seconds	\N
5029	374	700	\N	\N	99999999.00	seconds	\N
4952	516	696	\N	\N	117.76	seconds	\N
4985	787	658	\N	\N	306.46	seconds	\N
4953	625	694	\N	\N	124.27	seconds	\N
4954	592	695	\N	\N	124.46	seconds	\N
5013	491	671	\N	\N	18.35	seconds	\N
4955	470	695	\N	\N	131.33	seconds	\N
4986	609	658	\N	\N	307.41	seconds	\N
4956	514	694	\N	\N	133.01	seconds	\N
4957	363	696	\N	\N	133.68	seconds	\N
4958	615	694	\N	\N	135.08	seconds	\N
4987	608	658	\N	\N	311.47	seconds	\N
4959	481	696	\N	\N	135.15	seconds	\N
4960	600	696	\N	\N	136.77	seconds	\N
4961	608	694	\N	\N	138.00	seconds	\N
4988	795	658	\N	\N	332.16	seconds	\N
4962	787	694	\N	\N	139.30	seconds	\N
4963	352	696	\N	\N	145.85	seconds	\N
5014	802	670	\N	\N	18.84	seconds	\N
4964	337	694	\N	\N	147.06	seconds	\N
4989	339	658	\N	\N	344.78	seconds	\N
4965	504	695	\N	\N	152.31	seconds	\N
4966	365	694	\N	\N	155.55	seconds	\N
4967	364	694	\N	\N	159.17	seconds	\N
4990	504	659	\N	\N	346.95	seconds	\N
4968	375	696	\N	\N	162.15	seconds	\N
4969	339	694	\N	\N	99999999.00	seconds	\N
4970	929	696	\N	\N	99999999.00	seconds	\N
4971	810	695	\N	\N	99999999.00	seconds	\N
4972	516	660	\N	\N	262.73	seconds	\N
5030	495	701	\N	\N	99999999.00	seconds	\N
4973	592	659	\N	\N	272.96	seconds	\N
4991	365	658	\N	\N	349.36	seconds	\N
4974	612	660	\N	\N	278.63	seconds	\N
4975	625	658	\N	\N	283.59	seconds	\N
5015	784	670	\N	\N	19.75	seconds	\N
4976	470	659	\N	\N	284.93	seconds	\N
4992	387	660	\N	\N	355.83	seconds	\N
4977	810	659	\N	\N	286.51	seconds	\N
4978	490	660	\N	\N	286.65	seconds	\N
4993	372	658	\N	\N	356.67	seconds	\N
5016	376	672	\N	\N	20.41	seconds	\N
4994	472	658	\N	\N	433.02	seconds	\N
4995	336	659	\N	\N	99999999.00	seconds	\N
4996	929	660	\N	\N	99999999.00	seconds	\N
4997	612	714	\N	\N	595.01	seconds	\N
5031	381	702	\N	\N	99999999.00	seconds	\N
4998	490	714	\N	\N	620.79	seconds	\N
5017	478	671	\N	\N	20.57	seconds	\N
4999	610	714	\N	\N	652.79	seconds	\N
5000	619	712	\N	\N	668.90	seconds	\N
5001	609	712	\N	\N	680.63	seconds	\N
5018	604	670	\N	\N	21.95	seconds	\N
5002	787	712	\N	\N	686.89	seconds	\N
5003	795	712	\N	\N	729.67	seconds	\N
5032	808	701	\N	\N	99999999.00	seconds	\N
5004	372	712	\N	\N	784.73	seconds	\N
5005	336	713	\N	\N	99999999.00	seconds	\N
5006	470	713	\N	\N	99999999.00	seconds	\N
5007	514	712	\N	\N	99999999.00	seconds	\N
5008	387	714	\N	\N	99999999.00	seconds	\N
5009	351	712	\N	\N	99999999.00	seconds	\N
5010	929	714	\N	\N	99999999.00	seconds	\N
5019	799	670	\N	\N	22.13	seconds	\N
5020	808	671	\N	\N	99999999.00	seconds	\N
5021	378	702	\N	\N	44.65	seconds	\N
5033	497	756	\N	\N	495.00	inches	\N
5022	802	700	\N	\N	46.17	seconds	\N
5023	527	702	\N	\N	46.33	seconds	\N
5024	491	701	\N	\N	46.40	seconds	\N
5034	518	756	\N	\N	476.00	inches	\N
5025	478	701	\N	\N	49.92	seconds	\N
5026	784	700	\N	\N	50.29	seconds	\N
5041	532	756	\N	\N	420.00	inches	\N
5027	799	700	\N	\N	52.54	seconds	\N
5035	327	755	\N	\N	475.00	inches	\N
5028	604	700	\N	\N	53.34	seconds	\N
5036	344	756	\N	\N	463.50	inches	\N
5050	820	754	\N	\N	313.75	inches	\N
5037	792	754	\N	\N	454.50	inches	\N
5042	321	756	\N	\N	402.00	inches	\N
5038	828	756	\N	\N	449.75	inches	\N
5039	791	754	\N	\N	432.00	inches	\N
5047	826	754	\N	\N	344.75	inches	\N
5040	512	756	\N	\N	427.75	inches	\N
5043	618	756	\N	\N	387.50	inches	\N
5044	373	756	\N	\N	362.00	inches	\N
5045	377	756	\N	\N	360.50	inches	\N
5048	329	756	\N	\N	337.50	inches	\N
5046	506	756	\N	\N	355.00	inches	\N
5052	782	756	\N	\N	300.00	inches	\N
5049	488	755	\N	\N	335.50	inches	\N
5051	375	756	\N	\N	308.00	inches	\N
5053	775	754	\N	\N	288.00	inches	\N
5054	786	755	\N	\N	263.00	inches	\N
5055	379	754	\N	\N	242.50	inches	\N
5056	598	754	\N	\N	224.50	inches	\N
5057	804	754	\N	\N	0.00	inches	\N
5058	510	755	\N	\N	0.00	inches	\N
5059	1129	755	\N	\N	0.00	inches	\N
5060	497	750	\N	\N	1509.00	inches	\N
5061	344	750	\N	\N	1363.00	inches	\N
5062	532	750	\N	\N	1273.00	inches	\N
5063	518	750	\N	\N	1273.00	inches	\N
5064	512	750	\N	\N	1130.00	inches	\N
5065	618	750	\N	\N	1121.50	inches	\N
5066	828	750	\N	\N	1112.00	inches	\N
5067	506	750	\N	\N	1082.00	inches	\N
5068	488	749	\N	\N	1039.00	inches	\N
5069	792	748	\N	\N	1002.00	inches	\N
5070	327	749	\N	\N	984.00	inches	\N
5071	791	748	\N	\N	922.00	inches	\N
5152	528	793	\N	\N	13.61	seconds	\N
5072	321	750	\N	\N	909.00	inches	\N
5121	386	737	\N	\N	197.00	inches	\N
5073	826	748	\N	\N	838.00	inches	\N
5074	373	750	\N	\N	785.00	inches	\N
5075	377	750	\N	\N	785.00	inches	\N
5122	771	737	\N	\N	195.25	inches	\N
5076	782	750	\N	\N	768.00	inches	\N
5077	598	748	\N	\N	741.00	inches	\N
5078	329	750	\N	\N	656.00	inches	\N
5123	522	738	\N	\N	193.75	inches	\N
5079	820	748	\N	\N	602.00	inches	\N
5080	775	748	\N	\N	504.00	inches	\N
5153	632	795	\N	\N	13.79	seconds	\N
5081	786	749	\N	\N	492.00	inches	\N
5124	495	737	\N	\N	193.00	inches	\N
5082	379	748	\N	\N	428.00	inches	\N
5083	804	748	\N	\N	0.00	inches	\N
5084	510	749	\N	\N	0.00	inches	\N
5085	1129	749	\N	\N	0.00	inches	\N
5086	378	726	\N	\N	72.00	inches	\N
5087	781	724	\N	\N	70.00	inches	\N
5125	329	738	\N	\N	189.00	inches	\N
5088	388	726	\N	\N	64.00	inches	\N
5089	509	726	\N	\N	64.00	inches	\N
5090	522	726	\N	\N	62.00	inches	\N
5126	818	738	\N	\N	189.00	inches	\N
5091	345	724	\N	\N	60.00	inches	\N
5092	507	725	\N	\N	60.00	inches	\N
5154	566	794	\N	\N	13.82	seconds	\N
5093	630	725	\N	\N	60.00	inches	\N
5127	475	738	\N	\N	183.00	inches	\N
5094	805	724	\N	\N	58.00	inches	\N
5095	344	726	\N	\N	56.00	inches	\N
5096	376	732	\N	\N	132.00	inches	\N
5128	345	736	\N	\N	180.00	inches	\N
5097	527	732	\N	\N	126.00	inches	\N
5098	505	732	\N	\N	120.00	inches	\N
5171	1147	794	\N	\N	16.17	seconds	\N
5099	629	732	\N	\N	120.00	inches	\N
5129	479	736	\N	\N	180.00	inches	\N
5100	493	732	\N	\N	114.00	inches	\N
5101	388	732	\N	\N	108.00	inches	\N
5155	719	795	\N	\N	13.87	seconds	\N
5102	630	731	\N	\N	102.00	inches	\N
5130	388	738	\N	\N	174.00	inches	\N
5103	590	731	\N	\N	96.00	inches	\N
5104	364	730	\N	\N	90.00	inches	\N
5105	325	732	\N	\N	84.00	inches	\N
5131	360	737	\N	\N	171.00	inches	\N
5106	622	730	\N	\N	78.00	inches	\N
5107	378	738	\N	\N	232.00	inches	\N
5108	519	737	\N	\N	230.00	inches	\N
5132	604	736	\N	\N	171.00	inches	\N
5109	509	738	\N	\N	216.00	inches	\N
5110	383	738	\N	\N	213.50	inches	\N
5156	588	795	\N	\N	14.06	seconds	\N
5111	491	737	\N	\N	212.50	inches	\N
5133	375	738	\N	\N	170.00	inches	\N
5112	332	737	\N	\N	212.00	inches	\N
5113	530	738	\N	\N	211.50	inches	\N
5114	374	736	\N	\N	210.00	inches	\N
5134	343	737	\N	\N	167.00	inches	\N
5115	781	736	\N	\N	207.00	inches	\N
5116	534	738	\N	\N	205.00	inches	\N
5135	340	738	\N	\N	0.00	inches	\N
5117	507	737	\N	\N	204.00	inches	\N
5118	478	737	\N	\N	202.00	inches	\N
5136	778	737	\N	\N	0.00	inches	\N
5119	824	736	\N	\N	201.00	inches	\N
5120	629	738	\N	\N	199.00	inches	\N
5137	519	743	\N	\N	501.00	inches	\N
5157	735	795	\N	\N	14.51	seconds	\N
5138	509	744	\N	\N	467.00	inches	\N
5139	376	744	\N	\N	463.00	inches	\N
5172	477	794	\N	\N	16.23	seconds	\N
5140	340	744	\N	\N	438.50	inches	\N
5158	355	794	\N	\N	14.70	seconds	\N
5141	629	744	\N	\N	434.50	inches	\N
5142	781	742	\N	\N	430.50	inches	\N
5143	530	744	\N	\N	420.50	inches	\N
5159	569	794	\N	\N	14.76	seconds	\N
5144	522	744	\N	\N	406.00	inches	\N
5145	511	744	\N	\N	406.00	inches	\N
5183	1146	812	\N	\N	29.20	seconds	\N
5146	507	743	\N	\N	401.00	inches	\N
5160	1133	793	\N	\N	14.82	seconds	\N
5147	508	744	\N	\N	397.00	inches	\N
5148	388	744	\N	\N	363.00	inches	\N
5173	464	793	\N	\N	16.39	seconds	\N
5149	495	743	\N	\N	355.00	inches	\N
5150	778	743	\N	\N	0.00	inches	\N
5161	515	793	\N	\N	14.85	seconds	\N
5151	647	794	\N	\N	13.27	seconds	\N
5162	736	793	\N	\N	14.93	seconds	\N
5174	557	794	\N	\N	16.89	seconds	\N
5163	1141	794	\N	\N	15.06	seconds	\N
5164	594	793	\N	\N	15.17	seconds	\N
5165	328	793	\N	\N	15.39	seconds	\N
5175	620	793	\N	\N	17.30	seconds	\N
5166	586	794	\N	\N	15.54	seconds	\N
5167	573	793	\N	\N	15.73	seconds	\N
5184	588	813	\N	\N	29.61	seconds	\N
5168	1132	793	\N	\N	16.07	seconds	\N
5176	357	794	\N	\N	17.57	seconds	\N
5169	767	793	\N	\N	16.10	seconds	\N
5170	641	795	\N	\N	16.12	seconds	\N
5177	777	794	\N	\N	17.62	seconds	\N
5178	755	795	\N	\N	99999999.00	seconds	\N
5190	611	812	\N	\N	31.74	seconds	\N
5179	645	813	\N	\N	24.88	seconds	\N
5185	719	813	\N	\N	30.96	seconds	\N
5180	627	813	\N	\N	27.10	seconds	\N
5181	528	811	\N	\N	28.69	seconds	\N
5182	634	813	\N	\N	28.80	seconds	\N
5186	569	812	\N	\N	31.36	seconds	\N
5194	1133	811	\N	\N	32.20	seconds	\N
5187	1141	812	\N	\N	31.60	seconds	\N
5191	594	811	\N	\N	31.78	seconds	\N
5188	745	811	\N	\N	31.61	seconds	\N
5189	578	812	\N	\N	31.66	seconds	\N
5192	358	811	\N	\N	31.83	seconds	\N
5198	769	813	\N	\N	33.13	seconds	\N
5193	623	813	\N	\N	31.91	seconds	\N
5195	328	811	\N	\N	32.25	seconds	\N
5197	489	813	\N	\N	32.82	seconds	\N
5196	384	812	\N	\N	32.54	seconds	\N
5199	720	811	\N	\N	33.25	seconds	\N
5200	710	811	\N	\N	33.29	seconds	\N
5201	385	811	\N	\N	33.69	seconds	\N
5202	464	811	\N	\N	33.84	seconds	\N
5203	736	811	\N	\N	33.84	seconds	\N
5204	735	813	\N	\N	33.96	seconds	\N
5205	477	812	\N	\N	34.01	seconds	\N
5206	586	812	\N	\N	34.06	seconds	\N
5207	529	813	\N	\N	34.11	seconds	\N
5208	644	812	\N	\N	34.12	seconds	\N
5209	767	811	\N	\N	34.22	seconds	\N
5210	574	811	\N	\N	34.40	seconds	\N
5211	342	811	\N	\N	34.61	seconds	\N
5212	334	811	\N	\N	34.99	seconds	\N
5213	635	812	\N	\N	36.28	seconds	\N
5214	557	812	\N	\N	36.99	seconds	\N
5300	587	819	\N	\N	661.55	seconds	\N
5215	620	811	\N	\N	37.71	seconds	\N
5266	541	801	\N	\N	195.93	seconds	\N
5216	631	813	\N	\N	38.11	seconds	\N
5217	777	812	\N	\N	39.04	seconds	\N
5218	357	812	\N	\N	40.52	seconds	\N
5219	1132	811	\N	\N	99999999.00	seconds	\N
5220	725	813	\N	\N	99999999.00	seconds	\N
5267	642	801	\N	\N	198.05	seconds	\N
5221	645	789	\N	\N	56.92	seconds	\N
5222	367	788	\N	\N	60.62	seconds	\N
5223	628	789	\N	\N	64.24	seconds	\N
5268	639	801	\N	\N	205.03	seconds	\N
5224	1146	788	\N	\N	65.40	seconds	\N
5225	462	789	\N	\N	67.05	seconds	\N
5269	776	800	\N	\N	99999999.00	seconds	\N
5226	584	788	\N	\N	67.92	seconds	\N
5227	569	788	\N	\N	70.53	seconds	\N
5270	769	801	\N	\N	99999999.00	seconds	\N
5228	611	788	\N	\N	70.57	seconds	\N
5229	380	787	\N	\N	71.07	seconds	\N
5271	584	800	\N	\N	99999999.00	seconds	\N
5230	623	789	\N	\N	72.55	seconds	\N
5231	740	789	\N	\N	72.72	seconds	\N
5272	724	801	\N	\N	99999999.00	seconds	\N
5232	358	787	\N	\N	73.19	seconds	\N
5233	469	787	\N	\N	73.62	seconds	\N
5273	740	801	\N	\N	99999999.00	seconds	\N
5234	501	789	\N	\N	73.67	seconds	\N
5235	573	787	\N	\N	73.74	seconds	\N
5274	730	801	\N	\N	99999999.00	seconds	\N
5236	384	788	\N	\N	74.35	seconds	\N
5237	725	789	\N	\N	74.43	seconds	\N
5275	814	801	\N	\N	99999999.00	seconds	\N
5238	335	788	\N	\N	74.59	seconds	\N
5239	489	789	\N	\N	74.68	seconds	\N
5276	816	801	\N	\N	99999999.00	seconds	\N
5240	385	787	\N	\N	74.73	seconds	\N
5241	640	788	\N	\N	75.03	seconds	\N
5301	492	818	\N	\N	743.93	seconds	\N
5242	529	789	\N	\N	75.35	seconds	\N
5277	624	765	\N	\N	329.26	seconds	\N
5243	745	787	\N	\N	75.85	seconds	\N
5244	734	787	\N	\N	76.28	seconds	\N
5245	731	789	\N	\N	76.96	seconds	\N
5278	595	764	\N	\N	337.35	seconds	\N
5246	342	787	\N	\N	80.12	seconds	\N
5247	713	788	\N	\N	82.18	seconds	\N
5248	776	788	\N	\N	99999999.00	seconds	\N
5249	578	788	\N	\N	99999999.00	seconds	\N
5250	777	788	\N	\N	99999999.00	seconds	\N
5319	566	770	\N	\N	17.29	seconds	\N
5251	624	801	\N	\N	148.04	seconds	\N
5279	366	763	\N	\N	338.73	seconds	\N
5252	595	800	\N	\N	151.40	seconds	\N
5253	367	800	\N	\N	156.23	seconds	\N
5302	366	817	\N	\N	763.20	seconds	\N
5254	583	801	\N	\N	160.40	seconds	\N
5280	583	765	\N	\N	347.39	seconds	\N
5255	462	801	\N	\N	164.16	seconds	\N
5256	362	799	\N	\N	166.51	seconds	\N
5257	549	799	\N	\N	166.89	seconds	\N
5281	362	763	\N	\N	362.37	seconds	\N
5258	734	799	\N	\N	172.15	seconds	\N
5259	335	800	\N	\N	173.75	seconds	\N
5260	521	801	\N	\N	175.08	seconds	\N
5282	521	765	\N	\N	365.12	seconds	\N
5261	499	801	\N	\N	178.01	seconds	\N
5262	553	800	\N	\N	178.93	seconds	\N
5303	521	819	\N	\N	808.09	seconds	\N
5263	606	801	\N	\N	183.96	seconds	\N
5283	816	765	\N	\N	371.70	seconds	\N
5264	759	801	\N	\N	184.15	seconds	\N
5265	1144	800	\N	\N	189.81	seconds	\N
5284	499	765	\N	\N	371.88	seconds	\N
5329	633	807	\N	\N	52.29	seconds	\N
5285	469	763	\N	\N	372.04	seconds	\N
5304	486	819	\N	\N	854.85	seconds	\N
5286	492	764	\N	\N	376.56	seconds	\N
5287	323	763	\N	\N	384.84	seconds	\N
5320	636	769	\N	\N	17.97	seconds	\N
5288	553	764	\N	\N	387.50	seconds	\N
5305	323	817	\N	\N	859.04	seconds	\N
5289	341	763	\N	\N	388.06	seconds	\N
5290	486	765	\N	\N	390.43	seconds	\N
5291	759	765	\N	\N	408.06	seconds	\N
5306	549	817	\N	\N	859.33	seconds	\N
5292	1144	764	\N	\N	422.39	seconds	\N
5293	642	765	\N	\N	434.98	seconds	\N
5294	639	765	\N	\N	451.33	seconds	\N
5295	776	764	\N	\N	99999999.00	seconds	\N
5296	1130	764	\N	\N	99999999.00	seconds	\N
5297	581	764	\N	\N	99999999.00	seconds	\N
5298	724	765	\N	\N	99999999.00	seconds	\N
5299	814	765	\N	\N	99999999.00	seconds	\N
5321	628	771	\N	\N	18.28	seconds	\N
5307	341	817	\N	\N	859.35	seconds	\N
5308	540	818	\N	\N	870.36	seconds	\N
5335	496	807	\N	\N	55.91	seconds	\N
5309	556	818	\N	\N	885.00	seconds	\N
5322	638	770	\N	\N	19.28	seconds	\N
5310	545	817	\N	\N	885.00	seconds	\N
5311	606	819	\N	\N	894.38	seconds	\N
5330	636	805	\N	\N	52.49	seconds	\N
5312	541	819	\N	\N	944.78	seconds	\N
5313	469	817	\N	\N	99999999.00	seconds	\N
5314	803	817	\N	\N	99999999.00	seconds	\N
5315	793	817	\N	\N	99999999.00	seconds	\N
5316	583	819	\N	\N	99999999.00	seconds	\N
5317	724	819	\N	\N	99999999.00	seconds	\N
5323	496	771	\N	\N	19.42	seconds	\N
5318	633	771	\N	\N	16.99	seconds	\N
5324	1133	769	\N	\N	20.04	seconds	\N
5325	517	771	\N	\N	20.17	seconds	\N
5331	517	807	\N	\N	53.25	seconds	\N
5326	711	770	\N	\N	21.12	seconds	\N
5327	577	771	\N	\N	99999999.00	seconds	\N
5328	566	806	\N	\N	51.12	seconds	\N
5339	755	807	\N	\N	99999999.00	seconds	\N
5332	638	806	\N	\N	53.66	seconds	\N
5336	380	805	\N	\N	58.98	seconds	\N
5333	355	806	\N	\N	53.69	seconds	\N
5334	487	806	\N	\N	54.15	seconds	\N
5337	711	806	\N	\N	59.70	seconds	\N
5338	637	806	\N	\N	61.48	seconds	\N
5340	356	860	\N	\N	418.50	inches	\N
5341	503	861	\N	\N	338.00	inches	\N
5342	523	861	\N	\N	333.00	inches	\N
5343	827	859	\N	\N	309.50	inches	\N
5344	601	861	\N	\N	289.00	inches	\N
5345	500	860	\N	\N	287.00	inches	\N
5346	646	861	\N	\N	283.00	inches	\N
5347	526	861	\N	\N	276.50	inches	\N
5348	710	859	\N	\N	266.00	inches	\N
5349	334	859	\N	\N	262.50	inches	\N
5350	811	860	\N	\N	250.00	inches	\N
5351	357	860	\N	\N	248.00	inches	\N
5352	349	861	\N	\N	231.50	inches	\N
5353	738	861	\N	\N	204.50	inches	\N
5354	731	861	\N	\N	193.00	inches	\N
5355	713	860	\N	\N	168.00	inches	\N
5356	1132	859	\N	\N	0.00	inches	\N
5357	814	861	\N	\N	0.00	inches	\N
5358	503	855	\N	\N	1136.00	inches	\N
5359	523	855	\N	\N	1045.00	inches	\N
5409	536	843	\N	\N	148.00	inches	\N
5360	827	853	\N	\N	983.00	inches	\N
5361	533	854	\N	\N	939.00	inches	\N
5441	520	798	\N	\N	11.55	seconds	\N
5362	356	854	\N	\N	894.00	inches	\N
5410	328	841	\N	\N	141.00	inches	\N
5363	525	855	\N	\N	865.00	inches	\N
5364	526	855	\N	\N	858.00	inches	\N
5365	710	853	\N	\N	789.00	inches	\N
5411	741	843	\N	\N	140.00	inches	\N
5366	601	855	\N	\N	772.00	inches	\N
5367	725	855	\N	\N	768.00	inches	\N
5368	349	855	\N	\N	762.00	inches	\N
5412	1141	842	\N	\N	139.00	inches	\N
5369	500	854	\N	\N	744.00	inches	\N
5370	646	855	\N	\N	724.00	inches	\N
5442	482	798	\N	\N	11.92	seconds	\N
5371	713	854	\N	\N	523.50	inches	\N
5413	1132	841	\N	\N	138.00	inches	\N
5372	357	854	\N	\N	476.00	inches	\N
5373	738	855	\N	\N	463.50	inches	\N
5374	334	853	\N	\N	454.00	inches	\N
5414	720	841	\N	\N	135.00	inches	\N
5375	730	855	\N	\N	446.25	inches	\N
5376	1133	853	\N	\N	0.00	inches	\N
5377	333	831	\N	\N	61.00	inches	\N
5471	478	797	\N	\N	13.28	seconds	\N
5378	350	831	\N	\N	58.00	inches	\N
5415	574	841	\N	\N	133.50	inches	\N
5379	487	830	\N	\N	56.00	inches	\N
5380	515	829	\N	\N	54.00	inches	\N
5443	386	797	\N	\N	11.93	seconds	\N
5381	633	831	\N	\N	54.00	inches	\N
5416	524	842	\N	\N	127.00	inches	\N
5382	626	831	\N	\N	52.00	inches	\N
5383	498	830	\N	\N	50.00	inches	\N
5384	569	830	\N	\N	50.00	inches	\N
5417	731	843	\N	\N	125.00	inches	\N
5385	734	829	\N	\N	50.00	inches	\N
5386	711	830	\N	\N	50.00	inches	\N
5460	348	797	\N	\N	12.64	seconds	\N
5387	644	830	\N	\N	46.00	inches	\N
5418	745	841	\N	\N	125.00	inches	\N
5388	741	831	\N	\N	46.00	inches	\N
5389	623	831	\N	\N	44.00	inches	\N
5444	519	797	\N	\N	12.01	seconds	\N
5390	593	829	\N	\N	42.00	inches	\N
5419	713	842	\N	\N	114.00	inches	\N
5391	647	836	\N	\N	158.00	inches	\N
5392	577	837	\N	\N	146.00	inches	\N
5393	634	837	\N	\N	123.00	inches	\N
5420	593	841	\N	\N	109.00	inches	\N
5394	601	837	\N	\N	108.00	inches	\N
5395	501	837	\N	\N	84.00	inches	\N
5396	384	836	\N	\N	81.00	inches	\N
5421	730	843	\N	\N	85.00	inches	\N
5397	342	835	\N	\N	78.00	inches	\N
5398	489	837	\N	\N	66.00	inches	\N
5399	1136	836	\N	\N	0.00	inches	\N
5422	333	843	\N	\N	0.00	inches	\N
5400	647	842	\N	\N	203.25	inches	\N
5401	627	843	\N	\N	186.50	inches	\N
5423	380	841	\N	\N	0.00	inches	\N
5402	487	842	\N	\N	180.75	inches	\N
5403	347	841	\N	\N	176.00	inches	\N
5445	794	796	\N	\N	12.06	seconds	\N
5404	632	843	\N	\N	173.50	inches	\N
5424	634	849	\N	\N	430.50	inches	\N
5405	498	842	\N	\N	169.00	inches	\N
5406	755	843	\N	\N	166.00	inches	\N
5407	533	842	\N	\N	162.00	inches	\N
5425	633	849	\N	\N	394.00	inches	\N
5408	322	843	\N	\N	158.00	inches	\N
5446	715	798	\N	\N	12.12	seconds	\N
5426	632	849	\N	\N	385.75	inches	\N
5427	515	847	\N	\N	381.00	inches	\N
5461	748	797	\N	\N	12.71	seconds	\N
5428	601	849	\N	\N	367.50	inches	\N
5447	485	798	\N	\N	12.17	seconds	\N
5429	533	848	\N	\N	359.50	inches	\N
5430	626	849	\N	\N	347.50	inches	\N
5431	755	849	\N	\N	336.75	inches	\N
5448	383	798	\N	\N	12.19	seconds	\N
5432	524	848	\N	\N	336.00	inches	\N
5433	322	849	\N	\N	332.00	inches	\N
5478	818	798	\N	\N	13.56	seconds	\N
5434	498	848	\N	\N	326.00	inches	\N
5449	726	798	\N	\N	12.21	seconds	\N
5435	536	849	\N	\N	318.50	inches	\N
5436	741	849	\N	\N	316.00	inches	\N
5462	721	798	\N	\N	12.74	seconds	\N
5437	720	847	\N	\N	289.00	inches	\N
5438	627	849	\N	\N	0.00	inches	\N
5439	710	847	\N	\N	0.00	inches	\N
5450	551	798	\N	\N	12.33	seconds	\N
5440	597	798	\N	\N	11.44	seconds	\N
5472	327	797	\N	\N	13.29	seconds	\N
5451	552	798	\N	\N	12.37	seconds	\N
5463	757	798	\N	\N	12.78	seconds	\N
5452	370	797	\N	\N	12.41	seconds	\N
5453	530	798	\N	\N	12.42	seconds	\N
5454	605	796	\N	\N	12.46	seconds	\N
5464	771	797	\N	\N	12.82	seconds	\N
5455	824	796	\N	\N	12.48	seconds	\N
5456	798	798	\N	\N	12.54	seconds	\N
5457	596	796	\N	\N	12.55	seconds	\N
5465	479	796	\N	\N	12.83	seconds	\N
5458	591	796	\N	\N	12.62	seconds	\N
5459	728	797	\N	\N	12.62	seconds	\N
5473	575	796	\N	\N	13.32	seconds	\N
5466	801	797	\N	\N	12.86	seconds	\N
5467	928	798	\N	\N	12.90	seconds	\N
5468	354	798	\N	\N	13.02	seconds	\N
5474	564	797	\N	\N	13.36	seconds	\N
5469	758	797	\N	\N	13.03	seconds	\N
5470	723	797	\N	\N	13.27	seconds	\N
5479	476	796	\N	\N	13.56	seconds	\N
5475	463	797	\N	\N	13.44	seconds	\N
5476	465	796	\N	\N	13.51	seconds	\N
5480	599	797	\N	\N	13.62	seconds	\N
5477	484	796	\N	\N	13.54	seconds	\N
5483	1145	797	\N	\N	13.91	seconds	\N
5481	598	796	\N	\N	13.68	seconds	\N
5487	716	796	\N	\N	14.01	seconds	\N
5482	382	798	\N	\N	13.91	seconds	\N
5484	480	797	\N	\N	13.93	seconds	\N
5486	368	797	\N	\N	14.01	seconds	\N
5485	548	797	\N	\N	13.94	seconds	\N
5488	345	796	\N	\N	14.05	seconds	\N
5489	331	797	\N	\N	14.07	seconds	\N
5490	343	797	\N	\N	14.34	seconds	\N
5491	475	798	\N	\N	14.83	seconds	\N
5492	1142	796	\N	\N	15.82	seconds	\N
5493	360	797	\N	\N	99999999.00	seconds	\N
5494	1131	798	\N	\N	99999999.00	seconds	\N
5495	813	798	\N	\N	99999999.00	seconds	\N
5496	567	796	\N	\N	99999999.00	seconds	\N
5497	1134	797	\N	\N	99999999.00	seconds	\N
5498	1137	796	\N	\N	99999999.00	seconds	\N
5499	597	816	\N	\N	22.98	seconds	\N
5500	482	816	\N	\N	23.94	seconds	\N
5501	520	816	\N	\N	24.19	seconds	\N
5502	386	815	\N	\N	24.69	seconds	\N
5503	794	814	\N	\N	24.77	seconds	\N
5556	363	816	\N	\N	99999999.00	seconds	\N
5504	802	814	\N	\N	24.86	seconds	\N
5505	582	816	\N	\N	25.05	seconds	\N
5557	1131	816	\N	\N	99999999.00	seconds	\N
5506	383	816	\N	\N	25.26	seconds	\N
5507	370	815	\N	\N	25.31	seconds	\N
5558	475	816	\N	\N	99999999.00	seconds	\N
5508	340	816	\N	\N	25.42	seconds	\N
5509	605	814	\N	\N	25.42	seconds	\N
5559	1134	815	\N	\N	99999999.00	seconds	\N
5510	596	814	\N	\N	25.55	seconds	\N
5511	726	816	\N	\N	25.60	seconds	\N
5560	1137	814	\N	\N	99999999.00	seconds	\N
5512	748	815	\N	\N	25.63	seconds	\N
5513	749	815	\N	\N	25.78	seconds	\N
5561	712	816	\N	\N	99999999.00	seconds	\N
5514	715	816	\N	\N	26.08	seconds	\N
5515	718	814	\N	\N	26.17	seconds	\N
5562	728	815	\N	\N	99999999.00	seconds	\N
5516	348	815	\N	\N	26.18	seconds	\N
5517	485	816	\N	\N	26.39	seconds	\N
5518	801	815	\N	\N	26.42	seconds	\N
5563	597	792	\N	\N	53.00	seconds	\N
5519	928	816	\N	\N	26.57	seconds	\N
5520	591	814	\N	\N	26.61	seconds	\N
5588	579	790	\N	\N	62.00	seconds	\N
5521	360	815	\N	\N	26.76	seconds	\N
5564	802	790	\N	\N	53.31	seconds	\N
5522	757	816	\N	\N	26.78	seconds	\N
5523	806	816	\N	\N	26.84	seconds	\N
5524	817	816	\N	\N	26.88	seconds	\N
5565	753	792	\N	\N	54.40	seconds	\N
5525	479	814	\N	\N	27.00	seconds	\N
5526	575	814	\N	\N	27.22	seconds	\N
5617	363	804	\N	\N	133.68	seconds	\N
5527	572	816	\N	\N	27.23	seconds	\N
5566	482	792	\N	\N	54.62	seconds	\N
5528	721	816	\N	\N	27.47	seconds	\N
5529	551	816	\N	\N	27.51	seconds	\N
5589	476	790	\N	\N	62.46	seconds	\N
5530	563	815	\N	\N	27.57	seconds	\N
5567	374	790	\N	\N	55.86	seconds	\N
5531	473	814	\N	\N	27.81	seconds	\N
5532	571	814	\N	\N	27.87	seconds	\N
5533	564	815	\N	\N	27.91	seconds	\N
5568	582	792	\N	\N	56.00	seconds	\N
5534	599	815	\N	\N	27.99	seconds	\N
5535	476	814	\N	\N	28.04	seconds	\N
5607	592	803	\N	\N	123.17	seconds	\N
5536	368	815	\N	\N	28.43	seconds	\N
5569	780	790	\N	\N	56.42	seconds	\N
5537	484	814	\N	\N	28.64	seconds	\N
5538	480	815	\N	\N	29.11	seconds	\N
5590	817	792	\N	\N	62.50	seconds	\N
5539	603	816	\N	\N	29.48	seconds	\N
5570	749	791	\N	\N	56.56	seconds	\N
5540	548	815	\N	\N	29.57	seconds	\N
5541	346	814	\N	\N	29.86	seconds	\N
5542	465	814	\N	\N	30.00	seconds	\N
5571	718	790	\N	\N	56.59	seconds	\N
5543	716	814	\N	\N	30.31	seconds	\N
5544	343	815	\N	\N	30.47	seconds	\N
5545	567	814	\N	\N	30.95	seconds	\N
5572	495	791	\N	\N	56.69	seconds	\N
5546	331	815	\N	\N	31.23	seconds	\N
5547	371	816	\N	\N	34.17	seconds	\N
5548	354	816	\N	\N	99999999.00	seconds	\N
5549	818	816	\N	\N	99999999.00	seconds	\N
5550	382	816	\N	\N	99999999.00	seconds	\N
5551	758	815	\N	\N	99999999.00	seconds	\N
5552	463	815	\N	\N	99999999.00	seconds	\N
5553	1139	815	\N	\N	99999999.00	seconds	\N
5554	579	814	\N	\N	99999999.00	seconds	\N
5555	723	815	\N	\N	99999999.00	seconds	\N
5591	364	790	\N	\N	63.78	seconds	\N
5573	473	790	\N	\N	56.92	seconds	\N
5574	531	792	\N	\N	56.92	seconds	\N
5575	352	792	\N	\N	57.81	seconds	\N
5592	756	792	\N	\N	63.98	seconds	\N
5576	340	792	\N	\N	57.96	seconds	\N
5577	727	792	\N	\N	58.02	seconds	\N
5608	625	802	\N	\N	124.27	seconds	\N
5578	768	792	\N	\N	58.21	seconds	\N
5593	346	790	\N	\N	65.48	seconds	\N
5579	325	792	\N	\N	58.41	seconds	\N
5580	748	791	\N	\N	58.51	seconds	\N
5581	576	791	\N	\N	58.54	seconds	\N
5594	375	792	\N	\N	68.14	seconds	\N
5582	712	792	\N	\N	58.78	seconds	\N
5583	785	790	\N	\N	59.70	seconds	\N
5584	815	791	\N	\N	59.73	seconds	\N
5595	465	790	\N	\N	69.14	seconds	\N
5585	563	791	\N	\N	60.19	seconds	\N
5586	571	790	\N	\N	61.76	seconds	\N
5609	810	803	\N	\N	128.31	seconds	\N
5587	484	790	\N	\N	61.86	seconds	\N
5596	722	792	\N	\N	70.63	seconds	\N
5597	1140	792	\N	\N	71.14	seconds	\N
5618	608	802	\N	\N	134.82	seconds	\N
5598	567	790	\N	\N	71.33	seconds	\N
5610	555	803	\N	\N	128.37	seconds	\N
5599	371	792	\N	\N	75.36	seconds	\N
5600	561	790	\N	\N	78.27	seconds	\N
5601	463	791	\N	\N	99999999.00	seconds	\N
5602	761	791	\N	\N	99999999.00	seconds	\N
5603	1138	792	\N	\N	99999999.00	seconds	\N
5604	1137	790	\N	\N	99999999.00	seconds	\N
5605	516	804	\N	\N	117.76	seconds	\N
5611	752	803	\N	\N	129.19	seconds	\N
5606	753	804	\N	\N	120.30	seconds	\N
5612	470	803	\N	\N	131.33	seconds	\N
5619	815	803	\N	\N	136.07	seconds	\N
5613	749	803	\N	\N	132.80	seconds	\N
5614	514	802	\N	\N	133.01	seconds	\N
5624	572	804	\N	\N	140.75	seconds	\N
5615	481	804	\N	\N	133.28	seconds	\N
5620	600	804	\N	\N	136.77	seconds	\N
5616	615	802	\N	\N	133.64	seconds	\N
5630	550	802	\N	\N	145.84	seconds	\N
5621	754	802	\N	\N	137.30	seconds	\N
5625	717	802	\N	\N	141.60	seconds	\N
5622	375	804	\N	\N	138.88	seconds	\N
5623	787	802	\N	\N	139.30	seconds	\N
5628	582	804	\N	\N	144.58	seconds	\N
5626	542	804	\N	\N	143.50	seconds	\N
5627	751	804	\N	\N	143.50	seconds	\N
5629	560	804	\N	\N	144.77	seconds	\N
5631	352	804	\N	\N	145.85	seconds	\N
5632	1135	802	\N	\N	146.06	seconds	\N
5633	576	803	\N	\N	147.22	seconds	\N
5634	750	804	\N	\N	147.49	seconds	\N
5635	364	802	\N	\N	150.79	seconds	\N
5636	559	803	\N	\N	151.16	seconds	\N
5637	761	803	\N	\N	154.01	seconds	\N
5638	746	804	\N	\N	161.09	seconds	\N
5639	539	803	\N	\N	186.00	seconds	\N
5640	744	804	\N	\N	188.71	seconds	\N
5641	756	804	\N	\N	99999999.00	seconds	\N
5642	929	804	\N	\N	99999999.00	seconds	\N
5643	1138	804	\N	\N	99999999.00	seconds	\N
5644	589	802	\N	\N	99999999.00	seconds	\N
5645	1140	804	\N	\N	99999999.00	seconds	\N
5646	516	768	\N	\N	262.73	seconds	\N
5647	592	767	\N	\N	267.31	seconds	\N
5648	929	768	\N	\N	275.77	seconds	\N
5649	490	768	\N	\N	277.73	seconds	\N
5698	787	820	\N	\N	669.43	seconds	\N
5650	625	766	\N	\N	278.31	seconds	\N
5651	810	767	\N	\N	280.40	seconds	\N
5652	470	767	\N	\N	284.23	seconds	\N
5699	1135	820	\N	\N	672.86	seconds	\N
5653	481	768	\N	\N	286.62	seconds	\N
5654	514	766	\N	\N	292.58	seconds	\N
5730	799	778	\N	\N	21.86	seconds	\N
5655	381	768	\N	\N	298.00	seconds	\N
5700	351	820	\N	\N	675.32	seconds	\N
5656	600	768	\N	\N	298.28	seconds	\N
5657	560	768	\N	\N	298.45	seconds	\N
5658	787	766	\N	\N	299.01	seconds	\N
5701	308	822	\N	\N	675.48	seconds	\N
5659	308	768	\N	\N	300.03	seconds	\N
5660	619	766	\N	\N	300.86	seconds	\N
5731	813	780	\N	\N	99999999.00	seconds	\N
5661	351	766	\N	\N	301.45	seconds	\N
5702	547	821	\N	\N	680.32	seconds	\N
5662	717	766	\N	\N	305.81	seconds	\N
5663	609	766	\N	\N	307.41	seconds	\N
5664	1135	766	\N	\N	309.96	seconds	\N
5703	609	820	\N	\N	680.63	seconds	\N
5665	615	766	\N	\N	310.93	seconds	\N
5666	317	768	\N	\N	311.58	seconds	\N
5732	548	779	\N	\N	99999999.00	seconds	\N
5667	559	767	\N	\N	321.60	seconds	\N
5704	717	820	\N	\N	688.19	seconds	\N
5668	562	767	\N	\N	322.79	seconds	\N
5669	570	768	\N	\N	323.54	seconds	\N
5670	754	766	\N	\N	327.61	seconds	\N
5705	543	822	\N	\N	690.00	seconds	\N
5671	316	767	\N	\N	330.10	seconds	\N
5672	744	768	\N	\N	331.58	seconds	\N
5673	336	767	\N	\N	334.28	seconds	\N
5706	739	822	\N	\N	692.67	seconds	\N
5674	339	766	\N	\N	334.38	seconds	\N
5675	739	768	\N	\N	336.97	seconds	\N
5733	378	810	\N	\N	44.65	seconds	\N
5676	750	768	\N	\N	339.27	seconds	\N
5707	316	821	\N	\N	697.60	seconds	\N
5677	589	766	\N	\N	340.22	seconds	\N
5678	542	768	\N	\N	344.46	seconds	\N
5679	761	767	\N	\N	345.26	seconds	\N
5708	550	820	\N	\N	698.78	seconds	\N
5680	538	767	\N	\N	348.15	seconds	\N
5681	756	768	\N	\N	349.50	seconds	\N
5750	344	864	\N	\N	463.50	inches	\N
5682	306	766	\N	\N	352.96	seconds	\N
5709	317	822	\N	\N	701.76	seconds	\N
5683	372	766	\N	\N	356.67	seconds	\N
5684	771	767	\N	\N	358.30	seconds	\N
5734	802	808	\N	\N	45.07	seconds	\N
5685	746	768	\N	\N	366.30	seconds	\N
5710	795	820	\N	\N	710.91	seconds	\N
5686	307	767	\N	\N	381.80	seconds	\N
5687	1143	766	\N	\N	384.52	seconds	\N
5688	561	766	\N	\N	387.56	seconds	\N
5711	562	821	\N	\N	715.78	seconds	\N
5689	483	767	\N	\N	393.75	seconds	\N
5690	472	766	\N	\N	419.86	seconds	\N
5691	563	767	\N	\N	99999999.00	seconds	\N
5692	470	821	\N	\N	604.50	seconds	\N
5712	336	821	\N	\N	719.84	seconds	\N
5693	490	822	\N	\N	609.97	seconds	\N
5694	929	822	\N	\N	619.53	seconds	\N
5735	491	809	\N	\N	45.43	seconds	\N
5695	555	821	\N	\N	635.95	seconds	\N
5713	306	820	\N	\N	751.54	seconds	\N
5696	481	822	\N	\N	640.48	seconds	\N
5697	619	820	\N	\N	668.90	seconds	\N
5714	339	820	\N	\N	762.18	seconds	\N
5761	618	864	\N	\N	387.50	inches	\N
5715	538	821	\N	\N	776.52	seconds	\N
5736	527	810	\N	\N	46.00	seconds	\N
5716	372	820	\N	\N	784.73	seconds	\N
5717	307	821	\N	\N	823.51	seconds	\N
5751	737	864	\N	\N	461.50	inches	\N
5718	561	820	\N	\N	924.09	seconds	\N
5719	535	822	\N	\N	99999999.00	seconds	\N
5720	504	821	\N	\N	99999999.00	seconds	\N
5721	563	821	\N	\N	99999999.00	seconds	\N
5737	727	810	\N	\N	48.01	seconds	\N
5722	378	780	\N	\N	16.68	seconds	\N
5723	527	780	\N	\N	17.60	seconds	\N
5724	491	779	\N	\N	18.35	seconds	\N
5738	808	809	\N	\N	48.21	seconds	\N
5725	784	778	\N	\N	19.75	seconds	\N
5726	808	779	\N	\N	20.20	seconds	\N
5727	478	779	\N	\N	20.26	seconds	\N
5739	478	809	\N	\N	48.72	seconds	\N
5728	727	780	\N	\N	20.40	seconds	\N
5729	376	780	\N	\N	20.41	seconds	\N
5752	729	864	\N	\N	460.00	inches	\N
5740	570	810	\N	\N	48.92	seconds	\N
5741	381	810	\N	\N	49.46	seconds	\N
5742	784	808	\N	\N	49.97	seconds	\N
5753	828	864	\N	\N	449.75	inches	\N
5743	374	808	\N	\N	50.29	seconds	\N
5744	799	808	\N	\N	51.31	seconds	\N
5762	792	862	\N	\N	381.00	inches	\N
5745	481	810	\N	\N	52.71	seconds	\N
5754	512	864	\N	\N	427.75	inches	\N
5746	551	810	\N	\N	52.85	seconds	\N
5747	813	810	\N	\N	60.00	seconds	\N
5748	722	810	\N	\N	99999999.00	seconds	\N
5749	497	864	\N	\N	495.00	inches	\N
5755	532	864	\N	\N	420.00	inches	\N
5768	826	862	\N	\N	344.75	inches	\N
5756	1148	864	\N	\N	412.00	inches	\N
5763	804	862	\N	\N	378.00	inches	\N
5757	327	863	\N	\N	410.00	inches	\N
5758	321	864	\N	\N	403.00	inches	\N
5759	791	862	\N	\N	401.00	inches	\N
5764	377	864	\N	\N	360.50	inches	\N
5760	812	863	\N	\N	390.75	inches	\N
5772	782	864	\N	\N	300.00	inches	\N
5765	585	863	\N	\N	359.25	inches	\N
5769	488	863	\N	\N	335.50	inches	\N
5766	506	864	\N	\N	355.00	inches	\N
5767	329	864	\N	\N	352.00	inches	\N
5770	820	862	\N	\N	313.75	inches	\N
5776	598	862	\N	\N	238.00	inches	\N
5771	375	864	\N	\N	308.00	inches	\N
5773	1142	862	\N	\N	293.75	inches	\N
5775	723	863	\N	\N	260.00	inches	\N
5774	775	862	\N	\N	288.00	inches	\N
5777	757	864	\N	\N	0.00	inches	\N
5778	1145	863	\N	\N	0.00	inches	\N
5779	758	863	\N	\N	0.00	inches	\N
5780	552	864	\N	\N	0.00	inches	\N
5781	1134	863	\N	\N	0.00	inches	\N
5782	497	858	\N	\N	1509.00	inches	\N
5783	737	858	\N	\N	1413.00	inches	\N
5784	344	858	\N	\N	1363.00	inches	\N
5785	532	858	\N	\N	1351.00	inches	\N
5786	792	856	\N	\N	1191.00	inches	\N
5787	512	858	\N	\N	1130.00	inches	\N
5788	618	858	\N	\N	1121.50	inches	\N
5789	828	858	\N	\N	1112.00	inches	\N
5790	506	858	\N	\N	1082.00	inches	\N
5791	327	857	\N	\N	1059.00	inches	\N
5792	804	856	\N	\N	1053.00	inches	\N
5844	491	845	\N	\N	212.50	inches	\N
5793	488	857	\N	\N	1039.00	inches	\N
5794	729	858	\N	\N	1028.50	inches	\N
5795	791	856	\N	\N	1002.00	inches	\N
5845	332	845	\N	\N	212.00	inches	\N
5796	585	857	\N	\N	954.00	inches	\N
5797	812	857	\N	\N	915.00	inches	\N
5894	827	901	\N	\N	14.36	seconds	\N
5798	321	858	\N	\N	909.00	inches	\N
5846	530	846	\N	\N	211.50	inches	\N
5799	564	857	\N	\N	883.00	inches	\N
5800	377	858	\N	\N	844.00	inches	\N
5875	733	852	\N	\N	458.00	inches	\N
5801	826	856	\N	\N	838.00	inches	\N
5847	374	844	\N	\N	210.00	inches	\N
5802	820	856	\N	\N	775.00	inches	\N
5803	782	858	\N	\N	768.00	inches	\N
5804	598	856	\N	\N	741.00	inches	\N
5848	781	844	\N	\N	207.00	inches	\N
5805	329	858	\N	\N	690.00	inches	\N
5806	775	856	\N	\N	627.00	inches	\N
5807	552	858	\N	\N	0.00	inches	\N
5808	1134	857	\N	\N	0.00	inches	\N
5809	378	834	\N	\N	72.00	inches	\N
5849	534	846	\N	\N	205.00	inches	\N
5810	733	834	\N	\N	68.00	inches	\N
5811	388	834	\N	\N	67.00	inches	\N
5876	732	852	\N	\N	457.50	inches	\N
5812	509	834	\N	\N	64.00	inches	\N
5850	507	845	\N	\N	204.00	inches	\N
5813	714	834	\N	\N	64.00	inches	\N
5814	332	833	\N	\N	63.00	inches	\N
5815	345	832	\N	\N	62.00	inches	\N
5851	629	846	\N	\N	203.50	inches	\N
5816	507	833	\N	\N	60.00	inches	\N
5817	781	832	\N	\N	60.00	inches	\N
5905	586	902	\N	\N	15.54	seconds	\N
5818	630	833	\N	\N	60.00	inches	\N
5852	478	845	\N	\N	203.25	inches	\N
5819	805	832	\N	\N	58.00	inches	\N
5820	570	834	\N	\N	58.00	inches	\N
5821	808	833	\N	\N	0.00	inches	\N
5822	718	832	\N	\N	0.00	inches	\N
5877	530	852	\N	\N	437.75	inches	\N
5823	629	840	\N	\N	135.00	inches	\N
5853	824	844	\N	\N	201.00	inches	\N
5824	376	840	\N	\N	132.00	inches	\N
5825	527	840	\N	\N	126.00	inches	\N
5826	505	840	\N	\N	120.00	inches	\N
5854	714	846	\N	\N	200.00	inches	\N
5827	630	839	\N	\N	114.00	inches	\N
5828	388	840	\N	\N	108.00	inches	\N
5895	735	903	\N	\N	14.51	seconds	\N
5829	364	838	\N	\N	105.00	inches	\N
5855	721	846	\N	\N	196.00	inches	\N
5830	784	838	\N	\N	97.00	inches	\N
5831	590	839	\N	\N	96.00	inches	\N
5878	629	852	\N	\N	434.50	inches	\N
5832	805	838	\N	\N	90.00	inches	\N
5856	771	845	\N	\N	195.25	inches	\N
5833	325	840	\N	\N	84.00	inches	\N
5834	534	840	\N	\N	0.00	inches	\N
5835	554	840	\N	\N	0.00	inches	\N
5836	715	846	\N	\N	235.50	inches	\N
5837	378	846	\N	\N	232.00	inches	\N
5857	818	846	\N	\N	194.50	inches	\N
5838	519	845	\N	\N	230.00	inches	\N
5839	733	846	\N	\N	224.00	inches	\N
5840	732	846	\N	\N	218.00	inches	\N
5858	778	845	\N	\N	194.00	inches	\N
5841	509	846	\N	\N	216.00	inches	\N
5842	383	846	\N	\N	213.50	inches	\N
5879	714	852	\N	\N	433.00	inches	\N
5843	386	845	\N	\N	213.00	inches	\N
5859	360	845	\N	\N	191.00	inches	\N
5860	329	846	\N	\N	189.00	inches	\N
5880	781	850	\N	\N	430.50	inches	\N
5861	479	844	\N	\N	189.00	inches	\N
5862	575	844	\N	\N	185.00	inches	\N
5896	755	903	\N	\N	14.71	seconds	\N
5863	475	846	\N	\N	183.00	inches	\N
5881	507	851	\N	\N	429.00	inches	\N
5864	345	844	\N	\N	180.00	inches	\N
5865	388	846	\N	\N	174.00	inches	\N
5866	579	844	\N	\N	174.00	inches	\N
5882	511	852	\N	\N	408.00	inches	\N
5867	375	846	\N	\N	170.00	inches	\N
5868	343	845	\N	\N	167.00	inches	\N
5916	1158	902	\N	\N	99999999.00	seconds	\N
5869	716	844	\N	\N	155.00	inches	\N
5870	723	845	\N	\N	0.00	inches	\N
5871	1139	845	\N	\N	0.00	inches	\N
5883	778	851	\N	\N	406.50	inches	\N
5872	519	851	\N	\N	501.00	inches	\N
5873	509	852	\N	\N	467.00	inches	\N
5897	569	902	\N	\N	14.76	seconds	\N
5874	376	852	\N	\N	463.00	inches	\N
5884	508	852	\N	\N	397.00	inches	\N
5885	824	850	\N	\N	392.00	inches	\N
5906	644	902	\N	\N	15.92	seconds	\N
5886	388	852	\N	\N	389.00	inches	\N
5887	332	851	\N	\N	0.00	inches	\N
5888	1139	851	\N	\N	0.00	inches	\N
5889	744	852	\N	\N	0.00	inches	\N
5898	1141	902	\N	\N	14.85	seconds	\N
5890	645	903	\N	\N	12.15	seconds	\N
5891	647	902	\N	\N	13.21	seconds	\N
5892	632	903	\N	\N	13.79	seconds	\N
5899	825	903	\N	\N	14.89	seconds	\N
5893	719	903	\N	\N	13.87	seconds	\N
5912	1152	902	\N	\N	17.13	seconds	\N
5907	1147	902	\N	\N	15.97	seconds	\N
5900	736	901	\N	\N	14.93	seconds	\N
5901	745	901	\N	\N	15.02	seconds	\N
5902	594	901	\N	\N	15.17	seconds	\N
5908	635	902	\N	\N	16.44	seconds	\N
5903	328	901	\N	\N	15.39	seconds	\N
5904	1132	901	\N	\N	15.48	seconds	\N
5913	620	901	\N	\N	17.30	seconds	\N
5909	621	902	\N	\N	16.83	seconds	\N
5910	557	902	\N	\N	16.89	seconds	\N
5917	1136	902	\N	\N	99999999.00	seconds	\N
5911	1165	903	\N	\N	17.06	seconds	\N
5914	357	902	\N	\N	17.57	seconds	\N
5915	1157	903	\N	\N	18.41	seconds	\N
5918	1167	903	\N	\N	99999999.00	seconds	\N
5919	1171	903	\N	\N	99999999.00	seconds	\N
5920	1172	903	\N	\N	99999999.00	seconds	\N
5921	645	921	\N	\N	24.76	seconds	\N
5922	627	921	\N	\N	27.10	seconds	\N
5923	634	921	\N	\N	28.34	seconds	\N
5924	719	921	\N	\N	28.71	seconds	\N
5925	367	920	\N	\N	28.80	seconds	\N
5926	1141	920	\N	\N	30.80	seconds	\N
5927	825	921	\N	\N	31.22	seconds	\N
5928	569	920	\N	\N	31.36	seconds	\N
5929	594	919	\N	\N	31.55	seconds	\N
5930	745	919	\N	\N	31.61	seconds	\N
5931	611	920	\N	\N	31.74	seconds	\N
5932	1133	919	\N	\N	31.79	seconds	\N
5933	358	919	\N	\N	31.83	seconds	\N
5934	623	921	\N	\N	31.91	seconds	\N
5935	725	921	\N	\N	32.11	seconds	\N
5936	384	920	\N	\N	32.12	seconds	\N
5937	573	919	\N	\N	32.13	seconds	\N
6020	1162	871	\N	\N	382.24	seconds	\N
5938	328	919	\N	\N	32.25	seconds	\N
5989	581	908	\N	\N	160.28	seconds	\N
5939	720	919	\N	\N	32.36	seconds	\N
5940	769	921	\N	\N	33.13	seconds	\N
5941	586	920	\N	\N	33.41	seconds	\N
5990	362	907	\N	\N	162.53	seconds	\N
5942	385	919	\N	\N	33.69	seconds	\N
5943	644	920	\N	\N	34.12	seconds	\N
6039	323	925	\N	\N	859.04	seconds	\N
5944	767	919	\N	\N	34.22	seconds	\N
5991	1154	907	\N	\N	166.58	seconds	\N
5945	574	919	\N	\N	34.40	seconds	\N
5946	342	919	\N	\N	34.61	seconds	\N
6021	323	871	\N	\N	384.84	seconds	\N
5947	334	919	\N	\N	34.99	seconds	\N
5992	584	908	\N	\N	167.60	seconds	\N
5948	1132	919	\N	\N	35.30	seconds	\N
5949	641	921	\N	\N	35.61	seconds	\N
5950	557	920	\N	\N	35.80	seconds	\N
5993	540	908	\N	\N	168.97	seconds	\N
5951	1160	920	\N	\N	36.14	seconds	\N
5952	631	921	\N	\N	36.99	seconds	\N
5953	1165	921	\N	\N	37.07	seconds	\N
5994	816	909	\N	\N	170.98	seconds	\N
5954	620	919	\N	\N	37.71	seconds	\N
5955	1152	920	\N	\N	38.08	seconds	\N
6022	341	871	\N	\N	388.06	seconds	\N
5956	1157	921	\N	\N	39.98	seconds	\N
5995	335	908	\N	\N	173.75	seconds	\N
5957	357	920	\N	\N	40.52	seconds	\N
5958	581	920	\N	\N	99999999.00	seconds	\N
5959	1158	920	\N	\N	99999999.00	seconds	\N
5960	1155	919	\N	\N	99999999.00	seconds	\N
5961	1171	921	\N	\N	99999999.00	seconds	\N
5962	1172	921	\N	\N	99999999.00	seconds	\N
5963	1175	921	\N	\N	99999999.00	seconds	\N
5964	645	897	\N	\N	56.00	seconds	\N
5965	367	896	\N	\N	60.62	seconds	\N
5996	769	909	\N	\N	174.03	seconds	\N
5966	627	897	\N	\N	62.00	seconds	\N
5967	581	896	\N	\N	67.22	seconds	\N
6050	566	914	\N	\N	51.12	seconds	\N
5968	584	896	\N	\N	67.92	seconds	\N
5997	314	907	\N	\N	182.70	seconds	\N
5969	1153	896	\N	\N	70.49	seconds	\N
5970	611	896	\N	\N	70.57	seconds	\N
6023	556	872	\N	\N	388.31	seconds	\N
5971	740	897	\N	\N	71.26	seconds	\N
5998	311	909	\N	\N	183.23	seconds	\N
5972	384	896	\N	\N	71.79	seconds	\N
5973	623	897	\N	\N	72.55	seconds	\N
5974	573	895	\N	\N	72.98	seconds	\N
5999	759	909	\N	\N	184.15	seconds	\N
5975	725	897	\N	\N	73.04	seconds	\N
5976	358	895	\N	\N	73.19	seconds	\N
6040	341	925	\N	\N	859.35	seconds	\N
5977	335	896	\N	\N	74.59	seconds	\N
6000	1162	907	\N	\N	186.31	seconds	\N
5978	385	895	\N	\N	74.73	seconds	\N
5979	640	896	\N	\N	75.03	seconds	\N
6024	545	871	\N	\N	388.65	seconds	\N
5980	731	897	\N	\N	76.96	seconds	\N
6001	740	909	\N	\N	189.27	seconds	\N
5981	1155	895	\N	\N	78.14	seconds	\N
5982	342	895	\N	\N	80.12	seconds	\N
5983	334	895	\N	\N	80.45	seconds	\N
6002	1144	908	\N	\N	189.81	seconds	\N
5984	713	896	\N	\N	81.60	seconds	\N
5985	1160	896	\N	\N	84.34	seconds	\N
5986	587	909	\N	\N	143.38	seconds	\N
6003	541	909	\N	\N	195.93	seconds	\N
5987	624	909	\N	\N	148.04	seconds	\N
5988	595	908	\N	\N	151.40	seconds	\N
6025	540	872	\N	\N	395.16	seconds	\N
6004	642	909	\N	\N	198.05	seconds	\N
6005	730	909	\N	\N	202.46	seconds	\N
6006	639	909	\N	\N	204.03	seconds	\N
6007	315	908	\N	\N	99999999.00	seconds	\N
6008	1149	908	\N	\N	99999999.00	seconds	\N
6009	1153	908	\N	\N	99999999.00	seconds	\N
6010	1177	907	\N	\N	99999999.00	seconds	\N
6026	314	871	\N	\N	396.61	seconds	\N
6011	587	873	\N	\N	298.53	seconds	\N
6012	624	873	\N	\N	327.78	seconds	\N
6041	606	927	\N	\N	894.38	seconds	\N
6013	595	872	\N	\N	336.97	seconds	\N
6027	311	873	\N	\N	398.87	seconds	\N
6014	366	871	\N	\N	338.73	seconds	\N
6015	362	871	\N	\N	354.72	seconds	\N
6016	816	873	\N	\N	366.15	seconds	\N
6028	759	873	\N	\N	408.06	seconds	\N
6017	549	871	\N	\N	370.35	seconds	\N
6018	724	873	\N	\N	378.98	seconds	\N
6061	827	967	\N	\N	309.50	inches	\N
6019	1154	871	\N	\N	381.76	seconds	\N
6042	633	879	\N	\N	16.81	seconds	\N
6029	1144	872	\N	\N	422.39	seconds	\N
6030	541	873	\N	\N	426.38	seconds	\N
6051	633	915	\N	\N	51.36	seconds	\N
6031	642	873	\N	\N	434.98	seconds	\N
6043	566	878	\N	\N	17.29	seconds	\N
6032	318	872	\N	\N	435.52	seconds	\N
6033	639	873	\N	\N	451.33	seconds	\N
6034	315	872	\N	\N	99999999.00	seconds	\N
6035	1149	872	\N	\N	99999999.00	seconds	\N
6036	1172	873	\N	\N	99999999.00	seconds	\N
6037	366	925	\N	\N	763.20	seconds	\N
6044	628	879	\N	\N	17.46	seconds	\N
6038	553	926	\N	\N	810.62	seconds	\N
6057	711	914	\N	\N	58.71	seconds	\N
6052	628	915	\N	\N	52.00	seconds	\N
6045	636	877	\N	\N	17.97	seconds	\N
6046	638	878	\N	\N	19.00	seconds	\N
6047	1133	877	\N	\N	19.45	seconds	\N
6053	636	913	\N	\N	52.49	seconds	\N
6048	711	878	\N	\N	21.12	seconds	\N
6049	617	914	\N	\N	50.86	seconds	\N
6058	637	914	\N	\N	60.46	seconds	\N
6054	355	914	\N	\N	53.06	seconds	\N
6055	638	914	\N	\N	53.66	seconds	\N
6059	755	915	\N	\N	99999999.00	seconds	\N
6056	380	913	\N	\N	57.78	seconds	\N
6060	356	968	\N	\N	418.50	inches	\N
6065	710	967	\N	\N	267.75	inches	\N
6062	601	969	\N	\N	289.00	inches	\N
6064	1178	968	\N	\N	276.00	inches	\N
6063	646	969	\N	\N	283.00	inches	\N
6066	334	967	\N	\N	262.50	inches	\N
6067	357	968	\N	\N	248.00	inches	\N
6068	349	969	\N	\N	245.00	inches	\N
6069	730	969	\N	\N	206.50	inches	\N
6070	738	969	\N	\N	204.50	inches	\N
6071	731	969	\N	\N	201.25	inches	\N
6072	713	968	\N	\N	168.00	inches	\N
6073	356	962	\N	\N	1018.00	inches	\N
6074	827	961	\N	\N	983.00	inches	\N
6075	601	963	\N	\N	922.00	inches	\N
6076	1178	962	\N	\N	799.00	inches	\N
6077	725	963	\N	\N	798.00	inches	\N
6078	710	961	\N	\N	789.00	inches	\N
6079	349	963	\N	\N	777.00	inches	\N
6080	646	963	\N	\N	724.00	inches	\N
6081	1133	961	\N	\N	630.00	inches	\N
6132	745	955	\N	\N	270.00	inches	\N
6082	334	961	\N	\N	554.00	inches	\N
6083	713	962	\N	\N	523.50	inches	\N
6162	343	905	\N	\N	13.83	seconds	\N
6084	357	962	\N	\N	476.00	inches	\N
6133	597	906	\N	\N	11.44	seconds	\N
6085	738	963	\N	\N	463.50	inches	\N
6086	730	963	\N	\N	450.00	inches	\N
6087	333	939	\N	\N	61.00	inches	\N
6134	386	905	\N	\N	11.93	seconds	\N
6088	350	939	\N	\N	58.00	inches	\N
6089	626	939	\N	\N	54.00	inches	\N
6090	633	939	\N	\N	54.00	inches	\N
6135	715	906	\N	\N	12.09	seconds	\N
6091	380	937	\N	\N	52.00	inches	\N
6092	569	938	\N	\N	50.00	inches	\N
6163	1145	905	\N	\N	13.91	seconds	\N
6093	711	938	\N	\N	50.00	inches	\N
6136	383	906	\N	\N	12.14	seconds	\N
6094	741	939	\N	\N	48.00	inches	\N
6095	644	938	\N	\N	46.00	inches	\N
6096	623	939	\N	\N	44.00	inches	\N
6137	605	904	\N	\N	12.21	seconds	\N
6097	593	937	\N	\N	44.00	inches	\N
6098	647	944	\N	\N	158.00	inches	\N
6183	718	922	\N	\N	25.56	seconds	\N
6099	634	945	\N	\N	123.00	inches	\N
6138	551	906	\N	\N	12.25	seconds	\N
6100	601	945	\N	\N	108.00	inches	\N
6101	1136	944	\N	\N	96.00	inches	\N
6164	345	904	\N	\N	13.93	seconds	\N
6102	384	944	\N	\N	84.00	inches	\N
6139	370	905	\N	\N	12.41	seconds	\N
6103	342	943	\N	\N	78.00	inches	\N
6104	647	950	\N	\N	203.25	inches	\N
6105	627	951	\N	\N	194.00	inches	\N
6140	824	904	\N	\N	12.48	seconds	\N
6106	632	951	\N	\N	178.00	inches	\N
6107	347	949	\N	\N	176.00	inches	\N
6108	755	951	\N	\N	172.00	inches	\N
6141	596	904	\N	\N	12.49	seconds	\N
6109	322	951	\N	\N	158.00	inches	\N
6110	720	949	\N	\N	155.00	inches	\N
6165	548	905	\N	\N	13.94	seconds	\N
6111	741	951	\N	\N	153.00	inches	\N
6142	582	906	\N	\N	12.49	seconds	\N
6112	1132	949	\N	\N	146.00	inches	\N
6113	731	951	\N	\N	141.50	inches	\N
6114	328	949	\N	\N	141.00	inches	\N
6143	1131	906	\N	\N	12.54	seconds	\N
6115	1141	950	\N	\N	139.00	inches	\N
6116	574	949	\N	\N	137.00	inches	\N
6194	580	923	\N	\N	26.72	seconds	\N
6117	593	949	\N	\N	109.00	inches	\N
6144	591	904	\N	\N	12.62	seconds	\N
6118	730	951	\N	\N	85.00	inches	\N
6119	333	951	\N	\N	0.00	inches	\N
6120	350	951	\N	\N	0.00	inches	\N
6121	1136	950	\N	\N	0.00	inches	\N
6122	634	957	\N	\N	434.50	inches	\N
6166	368	905	\N	\N	14.01	seconds	\N
6123	633	957	\N	\N	394.00	inches	\N
6145	309	906	\N	\N	12.68	seconds	\N
6124	632	957	\N	\N	385.75	inches	\N
6125	601	957	\N	\N	367.50	inches	\N
6126	626	957	\N	\N	347.50	inches	\N
6146	748	905	\N	\N	12.71	seconds	\N
6127	755	957	\N	\N	342.50	inches	\N
6128	741	957	\N	\N	334.75	inches	\N
6184	749	923	\N	\N	25.57	seconds	\N
6129	322	957	\N	\N	332.00	inches	\N
6147	721	906	\N	\N	12.74	seconds	\N
6130	710	955	\N	\N	297.00	inches	\N
6131	720	955	\N	\N	290.75	inches	\N
6167	567	904	\N	\N	14.79	seconds	\N
6148	757	906	\N	\N	12.78	seconds	\N
6149	1179	906	\N	\N	12.78	seconds	\N
6168	1164	906	\N	\N	14.98	seconds	\N
6150	818	906	\N	\N	12.79	seconds	\N
6151	758	905	\N	\N	12.91	seconds	\N
6152	354	906	\N	\N	12.98	seconds	\N
6169	1142	904	\N	\N	15.82	seconds	\N
6153	580	905	\N	\N	13.24	seconds	\N
6154	723	905	\N	\N	13.27	seconds	\N
6170	603	906	\N	\N	99999999.00	seconds	\N
6155	327	905	\N	\N	13.29	seconds	\N
6156	575	904	\N	\N	13.32	seconds	\N
6171	1169	904	\N	\N	99999999.00	seconds	\N
6157	564	905	\N	\N	13.36	seconds	\N
6158	1137	904	\N	\N	13.41	seconds	\N
6172	1176	906	\N	\N	99999999.00	seconds	\N
6159	598	904	\N	\N	13.50	seconds	\N
6160	599	905	\N	\N	13.62	seconds	\N
6173	1168	906	\N	\N	99999999.00	seconds	\N
6161	331	905	\N	\N	13.75	seconds	\N
6185	748	923	\N	\N	25.63	seconds	\N
6174	1170	904	\N	\N	99999999.00	seconds	\N
6175	597	924	\N	\N	22.98	seconds	\N
6176	715	924	\N	\N	24.57	seconds	\N
6186	818	924	\N	\N	25.75	seconds	\N
6177	386	923	\N	\N	24.69	seconds	\N
6178	605	922	\N	\N	24.97	seconds	\N
6195	309	924	\N	\N	26.99	seconds	\N
6179	712	924	\N	\N	25.18	seconds	\N
6187	551	924	\N	\N	25.83	seconds	\N
6180	383	924	\N	\N	25.26	seconds	\N
6181	370	923	\N	\N	25.31	seconds	\N
6182	596	922	\N	\N	25.55	seconds	\N
6188	591	922	\N	\N	25.87	seconds	\N
6201	571	922	\N	\N	27.87	seconds	\N
6189	552	924	\N	\N	26.17	seconds	\N
6196	575	922	\N	\N	27.22	seconds	\N
6190	758	923	\N	\N	26.30	seconds	\N
6191	728	923	\N	\N	26.32	seconds	\N
6192	757	924	\N	\N	26.52	seconds	\N
6197	813	924	\N	\N	27.26	seconds	\N
6193	360	923	\N	\N	26.64	seconds	\N
6205	603	924	\N	\N	28.53	seconds	\N
6198	817	924	\N	\N	27.40	seconds	\N
6202	599	923	\N	\N	27.90	seconds	\N
6199	721	924	\N	\N	27.47	seconds	\N
6200	723	923	\N	\N	27.65	seconds	\N
6203	564	923	\N	\N	27.91	seconds	\N
6209	548	923	\N	\N	29.57	seconds	\N
6204	368	923	\N	\N	28.43	seconds	\N
6206	1137	922	\N	\N	28.53	seconds	\N
6208	331	923	\N	\N	29.09	seconds	\N
6207	343	923	\N	\N	28.83	seconds	\N
6210	346	922	\N	\N	29.86	seconds	\N
6211	716	922	\N	\N	29.93	seconds	\N
6212	567	922	\N	\N	30.95	seconds	\N
6213	371	924	\N	\N	33.53	seconds	\N
6214	354	924	\N	\N	99999999.00	seconds	\N
6215	374	922	\N	\N	99999999.00	seconds	\N
6216	1131	924	\N	\N	99999999.00	seconds	\N
6217	375	924	\N	\N	99999999.00	seconds	\N
6218	1176	924	\N	\N	99999999.00	seconds	\N
6219	1168	924	\N	\N	99999999.00	seconds	\N
6220	1170	922	\N	\N	99999999.00	seconds	\N
6221	1179	924	\N	\N	99999999.00	seconds	\N
6222	597	900	\N	\N	52.00	seconds	\N
6223	753	900	\N	\N	52.80	seconds	\N
6224	608	898	\N	\N	55.00	seconds	\N
6225	374	898	\N	\N	55.45	seconds	\N
6226	718	898	\N	\N	55.67	seconds	\N
6227	582	900	\N	\N	55.78	seconds	\N
6278	1156	911	\N	\N	156.80	seconds	\N
6228	727	900	\N	\N	56.43	seconds	\N
6229	749	899	\N	\N	56.56	seconds	\N
6338	562	929	\N	\N	702.53	seconds	\N
6230	712	900	\N	\N	57.32	seconds	\N
6279	563	911	\N	\N	157.11	seconds	\N
6231	768	900	\N	\N	57.48	seconds	\N
6232	352	900	\N	\N	57.81	seconds	\N
6309	744	876	\N	\N	320.08	seconds	\N
6233	325	900	\N	\N	58.41	seconds	\N
6280	746	912	\N	\N	159.30	seconds	\N
6234	748	899	\N	\N	58.51	seconds	\N
6235	337	898	\N	\N	58.77	seconds	\N
6236	1179	900	\N	\N	59.30	seconds	\N
6281	319	912	\N	\N	169.89	seconds	\N
6237	552	900	\N	\N	59.90	seconds	\N
6238	758	899	\N	\N	59.95	seconds	\N
6327	612	930	\N	\N	592.00	seconds	\N
6239	1163	900	\N	\N	60.61	seconds	\N
6282	372	910	\N	\N	173.05	seconds	\N
6240	571	898	\N	\N	61.76	seconds	\N
6241	1166	898	\N	\N	62.49	seconds	\N
6310	562	875	\N	\N	322.79	seconds	\N
6242	817	900	\N	\N	62.50	seconds	\N
6283	539	911	\N	\N	178.30	seconds	\N
6243	346	898	\N	\N	65.48	seconds	\N
6244	319	900	\N	\N	66.42	seconds	\N
6284	756	912	\N	\N	99999999.00	seconds	\N
6245	375	900	\N	\N	68.14	seconds	\N
6246	567	898	\N	\N	68.97	seconds	\N
6285	1150	910	\N	\N	99999999.00	seconds	\N
6247	722	900	\N	\N	70.63	seconds	\N
6248	1140	900	\N	\N	71.14	seconds	\N
6249	371	900	\N	\N	74.66	seconds	\N
6250	381	900	\N	\N	99999999.00	seconds	\N
6251	818	900	\N	\N	99999999.00	seconds	\N
6252	1150	898	\N	\N	99999999.00	seconds	\N
6253	1156	899	\N	\N	99999999.00	seconds	\N
6254	618	900	\N	\N	99999999.00	seconds	\N
6255	1135	898	\N	\N	99999999.00	seconds	\N
6286	592	875	\N	\N	263.39	seconds	\N
6256	753	912	\N	\N	120.11	seconds	\N
6257	625	910	\N	\N	120.44	seconds	\N
6258	592	911	\N	\N	123.17	seconds	\N
6287	752	875	\N	\N	273.19	seconds	\N
6259	752	911	\N	\N	127.97	seconds	\N
6260	751	912	\N	\N	132.15	seconds	\N
6311	570	876	\N	\N	323.54	seconds	\N
6261	749	911	\N	\N	132.42	seconds	\N
6288	625	874	\N	\N	278.31	seconds	\N
6262	615	910	\N	\N	133.64	seconds	\N
6263	363	912	\N	\N	133.68	seconds	\N
6264	608	910	\N	\N	134.82	seconds	\N
6289	612	876	\N	\N	278.63	seconds	\N
6265	600	912	\N	\N	135.76	seconds	\N
6266	815	911	\N	\N	136.07	seconds	\N
6267	754	910	\N	\N	137.30	seconds	\N
6290	555	875	\N	\N	280.96	seconds	\N
6268	1161	911	\N	\N	138.54	seconds	\N
6269	352	912	\N	\N	141.19	seconds	\N
6312	754	874	\N	\N	327.61	seconds	\N
6270	337	910	\N	\N	141.24	seconds	\N
6291	815	875	\N	\N	286.03	seconds	\N
6271	750	912	\N	\N	142.26	seconds	\N
6272	744	912	\N	\N	143.35	seconds	\N
6273	542	912	\N	\N	143.50	seconds	\N
6292	610	876	\N	\N	288.59	seconds	\N
6274	1135	910	\N	\N	144.45	seconds	\N
6275	317	912	\N	\N	144.88	seconds	\N
6328	560	930	\N	\N	642.34	seconds	\N
6276	589	910	\N	\N	149.64	seconds	\N
6293	600	876	\N	\N	296.73	seconds	\N
6277	761	911	\N	\N	153.71	seconds	\N
6313	316	875	\N	\N	330.10	seconds	\N
6294	308	876	\N	\N	298.01	seconds	\N
6295	560	876	\N	\N	298.45	seconds	\N
6296	547	875	\N	\N	299.90	seconds	\N
6314	761	875	\N	\N	331.39	seconds	\N
6297	543	876	\N	\N	299.90	seconds	\N
6298	619	874	\N	\N	300.86	seconds	\N
6299	351	874	\N	\N	301.45	seconds	\N
6315	339	874	\N	\N	332.43	seconds	\N
6300	1161	875	\N	\N	302.15	seconds	\N
6301	717	874	\N	\N	305.81	seconds	\N
6329	610	930	\N	\N	650.24	seconds	\N
6302	615	874	\N	\N	306.24	seconds	\N
6316	336	875	\N	\N	334.28	seconds	\N
6303	609	874	\N	\N	307.41	seconds	\N
6304	317	876	\N	\N	307.53	seconds	\N
6305	1135	874	\N	\N	309.96	seconds	\N
6317	589	874	\N	\N	336.43	seconds	\N
6306	1163	876	\N	\N	310.25	seconds	\N
6307	550	874	\N	\N	316.22	seconds	\N
6339	336	929	\N	\N	719.84	seconds	\N
6308	751	876	\N	\N	319.67	seconds	\N
6318	739	876	\N	\N	336.97	seconds	\N
6330	559	929	\N	\N	655.60	seconds	\N
6319	750	876	\N	\N	339.27	seconds	\N
6320	756	876	\N	\N	349.50	seconds	\N
6321	306	874	\N	\N	350.63	seconds	\N
6331	619	928	\N	\N	665.76	seconds	\N
6322	372	874	\N	\N	356.67	seconds	\N
6323	746	876	\N	\N	357.01	seconds	\N
6346	815	929	\N	\N	99999999.00	seconds	\N
6324	307	875	\N	\N	368.26	seconds	\N
6332	739	930	\N	\N	673.79	seconds	\N
6325	1143	874	\N	\N	384.52	seconds	\N
6326	561	874	\N	\N	387.56	seconds	\N
6340	306	928	\N	\N	751.54	seconds	\N
6333	351	928	\N	\N	675.32	seconds	\N
6334	308	930	\N	\N	675.48	seconds	\N
6335	609	928	\N	\N	680.63	seconds	\N
6341	339	928	\N	\N	756.48	seconds	\N
6336	717	928	\N	\N	688.19	seconds	\N
6337	316	929	\N	\N	697.60	seconds	\N
6350	376	888	\N	\N	20.36	seconds	\N
6347	378	888	\N	\N	16.68	seconds	\N
6342	538	929	\N	\N	776.52	seconds	\N
6343	307	929	\N	\N	823.51	seconds	\N
6344	561	928	\N	\N	881.26	seconds	\N
6345	563	929	\N	\N	99999999.00	seconds	\N
6348	607	888	\N	\N	17.63	seconds	\N
6349	727	888	\N	\N	19.76	seconds	\N
6354	381	918	\N	\N	46.38	seconds	\N
6351	813	888	\N	\N	21.36	seconds	\N
6353	727	918	\N	\N	45.88	seconds	\N
6352	378	918	\N	\N	44.65	seconds	\N
6355	570	918	\N	\N	46.96	seconds	\N
6356	607	918	\N	\N	48.31	seconds	\N
6357	712	918	\N	\N	50.73	seconds	\N
6358	813	918	\N	\N	52.19	seconds	\N
6359	722	918	\N	\N	59.59	seconds	\N
6360	340	918	\N	\N	99999999.00	seconds	\N
6361	344	972	\N	\N	463.50	inches	\N
6362	737	972	\N	\N	461.50	inches	\N
6363	1148	972	\N	\N	428.75	inches	\N
6364	327	971	\N	\N	421.00	inches	\N
6365	618	972	\N	\N	390.00	inches	\N
6366	377	972	\N	\N	370.00	inches	\N
6367	329	972	\N	\N	366.50	inches	\N
6368	373	972	\N	\N	362.00	inches	\N
6369	585	971	\N	\N	359.25	inches	\N
6370	548	971	\N	\N	353.50	inches	\N
6454	824	958	\N	\N	392.00	inches	\N
6371	826	970	\N	\N	344.75	inches	\N
6422	332	953	\N	\N	212.00	inches	\N
6372	820	970	\N	\N	329.50	inches	\N
6373	758	971	\N	\N	312.50	inches	\N
6374	1142	970	\N	\N	311.00	inches	\N
6423	374	952	\N	\N	210.00	inches	\N
6375	375	972	\N	\N	308.00	inches	\N
6376	757	972	\N	\N	290.00	inches	\N
6377	723	971	\N	\N	261.50	inches	\N
6424	607	954	\N	\N	209.50	inches	\N
6378	1145	971	\N	\N	254.50	inches	\N
6379	598	970	\N	\N	251.50	inches	\N
6455	388	960	\N	\N	389.00	inches	\N
6380	737	966	\N	\N	1413.00	inches	\N
6425	629	954	\N	\N	203.50	inches	\N
6381	344	966	\N	\N	1363.00	inches	\N
6382	618	966	\N	\N	1121.50	inches	\N
6383	327	965	\N	\N	1059.00	inches	\N
6426	824	952	\N	\N	201.00	inches	\N
6384	585	965	\N	\N	954.00	inches	\N
6385	564	965	\N	\N	883.00	inches	\N
6472	429	1011	\N	\N	14.53	seconds	\N
6386	377	966	\N	\N	844.00	inches	\N
6427	728	953	\N	\N	201.00	inches	\N
6387	826	964	\N	\N	838.00	inches	\N
6388	329	966	\N	\N	809.00	inches	\N
6456	1139	959	\N	\N	363.50	inches	\N
6389	373	966	\N	\N	785.00	inches	\N
6428	721	954	\N	\N	196.00	inches	\N
6390	598	964	\N	\N	782.00	inches	\N
6391	820	964	\N	\N	775.00	inches	\N
6392	563	965	\N	\N	679.00	inches	\N
6429	360	953	\N	\N	191.00	inches	\N
6393	378	942	\N	\N	72.00	inches	\N
6394	733	942	\N	\N	69.00	inches	\N
6395	388	942	\N	\N	67.00	inches	\N
6430	329	954	\N	\N	189.00	inches	\N
6396	714	942	\N	\N	66.00	inches	\N
6397	332	941	\N	\N	63.00	inches	\N
6457	645	1011	\N	\N	12.15	seconds	\N
6398	345	940	\N	\N	62.00	inches	\N
6431	575	952	\N	\N	185.00	inches	\N
6399	630	941	\N	\N	60.00	inches	\N
6400	570	942	\N	\N	58.00	inches	\N
6401	344	942	\N	\N	56.00	inches	\N
6402	340	942	\N	\N	0.00	inches	\N
6403	1139	941	\N	\N	0.00	inches	\N
6404	1169	940	\N	\N	0.00	inches	\N
6405	1170	940	\N	\N	0.00	inches	\N
6432	343	953	\N	\N	182.00	inches	\N
6406	376	948	\N	\N	138.00	inches	\N
6407	629	948	\N	\N	138.00	inches	\N
6483	695	1009	\N	\N	15.00	seconds	\N
6408	388	948	\N	\N	120.00	inches	\N
6433	345	952	\N	\N	180.00	inches	\N
6409	630	947	\N	\N	120.00	inches	\N
6410	590	947	\N	\N	108.00	inches	\N
6458	647	1010	\N	\N	13.21	seconds	\N
6411	364	946	\N	\N	105.00	inches	\N
6434	723	953	\N	\N	175.00	inches	\N
6412	1166	946	\N	\N	96.00	inches	\N
6413	325	948	\N	\N	84.00	inches	\N
6414	718	946	\N	\N	0.00	inches	\N
6415	733	954	\N	\N	236.00	inches	\N
6435	388	954	\N	\N	174.00	inches	\N
6416	715	954	\N	\N	235.50	inches	\N
6417	378	954	\N	\N	232.00	inches	\N
6473	416	1009	\N	\N	14.66	seconds	\N
6418	714	954	\N	\N	218.00	inches	\N
6436	1139	953	\N	\N	172.00	inches	\N
6419	732	954	\N	\N	218.00	inches	\N
6420	383	954	\N	\N	213.50	inches	\N
6459	528	1009	\N	\N	13.61	seconds	\N
6421	386	953	\N	\N	213.00	inches	\N
6437	375	954	\N	\N	170.00	inches	\N
6438	716	952	\N	\N	155.00	inches	\N
6439	340	954	\N	\N	0.00	inches	\N
6440	373	954	\N	\N	0.00	inches	\N
6441	561	952	\N	\N	0.00	inches	\N
6442	1169	952	\N	\N	0.00	inches	\N
6443	1176	954	\N	\N	0.00	inches	\N
6444	1168	954	\N	\N	0.00	inches	\N
6445	1170	952	\N	\N	0.00	inches	\N
6446	733	960	\N	\N	478.75	inches	\N
6460	632	1011	\N	\N	13.79	seconds	\N
6447	376	960	\N	\N	463.00	inches	\N
6448	607	960	\N	\N	457.50	inches	\N
6449	732	960	\N	\N	457.50	inches	\N
6461	566	1010	\N	\N	13.82	seconds	\N
6450	332	959	\N	\N	440.00	inches	\N
6451	629	960	\N	\N	434.50	inches	\N
6474	355	1010	\N	\N	14.70	seconds	\N
6452	714	960	\N	\N	433.00	inches	\N
6462	719	1011	\N	\N	13.87	seconds	\N
6453	728	959	\N	\N	412.00	inches	\N
6463	660	1009	\N	\N	13.92	seconds	\N
6475	706	1009	\N	\N	14.71	seconds	\N
6464	617	1010	\N	\N	13.98	seconds	\N
6465	588	1011	\N	\N	14.06	seconds	\N
6484	573	1009	\N	\N	15.51	seconds	\N
6466	827	1009	\N	\N	14.30	seconds	\N
6476	825	1011	\N	\N	14.80	seconds	\N
6467	663	1009	\N	\N	14.34	seconds	\N
6468	452	1011	\N	\N	14.35	seconds	\N
6469	764	1009	\N	\N	14.35	seconds	\N
6477	1133	1009	\N	\N	14.82	seconds	\N
6470	423	1010	\N	\N	14.42	seconds	\N
6471	735	1011	\N	\N	14.51	seconds	\N
6490	645	1029	\N	\N	24.76	seconds	\N
6478	1141	1010	\N	\N	14.85	seconds	\N
6485	586	1010	\N	\N	15.54	seconds	\N
6479	424	1009	\N	\N	14.89	seconds	\N
6480	702	1010	\N	\N	14.89	seconds	\N
6481	736	1009	\N	\N	14.89	seconds	\N
6486	644	1010	\N	\N	15.92	seconds	\N
6482	578	1010	\N	\N	14.95	seconds	\N
6494	719	1029	\N	\N	28.10	seconds	\N
6487	641	1011	\N	\N	16.12	seconds	\N
6491	627	1029	\N	\N	26.90	seconds	\N
6488	635	1010	\N	\N	16.44	seconds	\N
6489	631	1011	\N	\N	17.58	seconds	\N
6492	708	1028	\N	\N	27.96	seconds	\N
6498	660	1027	\N	\N	29.71	seconds	\N
6493	367	1028	\N	\N	28.02	seconds	\N
6495	634	1029	\N	\N	28.34	seconds	\N
6497	588	1029	\N	\N	29.61	seconds	\N
6496	528	1027	\N	\N	28.69	seconds	\N
6499	764	1027	\N	\N	30.38	seconds	\N
6500	663	1027	\N	\N	30.73	seconds	\N
6501	1141	1028	\N	\N	30.80	seconds	\N
6502	706	1027	\N	\N	30.84	seconds	\N
6503	825	1029	\N	\N	30.90	seconds	\N
6504	416	1027	\N	\N	30.93	seconds	\N
6505	695	1027	\N	\N	31.08	seconds	\N
6506	594	1027	\N	\N	31.10	seconds	\N
6507	745	1027	\N	\N	31.20	seconds	\N
6508	763	1027	\N	\N	31.23	seconds	\N
6509	702	1028	\N	\N	31.50	seconds	\N
6510	1133	1027	\N	\N	31.79	seconds	\N
6511	573	1027	\N	\N	32.13	seconds	\N
6512	586	1028	\N	\N	32.29	seconds	\N
6513	424	1027	\N	\N	33.01	seconds	\N
6514	769	1029	\N	\N	33.13	seconds	\N
6515	456	1027	\N	\N	33.28	seconds	\N
6516	644	1028	\N	\N	34.12	seconds	\N
6517	408	1028	\N	\N	34.58	seconds	\N
6565	639	1017	\N	\N	204.03	seconds	\N
6518	635	1028	\N	\N	35.42	seconds	\N
6519	641	1029	\N	\N	35.61	seconds	\N
6520	631	1029	\N	\N	36.99	seconds	\N
6566	587	981	\N	\N	298.53	seconds	\N
6521	645	1005	\N	\N	56.00	seconds	\N
6522	367	1004	\N	\N	60.62	seconds	\N
6596	587	1035	\N	\N	661.55	seconds	\N
6523	708	1004	\N	\N	63.60	seconds	\N
6567	624	981	\N	\N	327.78	seconds	\N
6524	627	1005	\N	\N	66.29	seconds	\N
6525	584	1004	\N	\N	67.92	seconds	\N
6526	423	1004	\N	\N	70.40	seconds	\N
6568	583	981	\N	\N	336.32	seconds	\N
6527	763	1003	\N	\N	70.48	seconds	\N
6528	611	1004	\N	\N	70.57	seconds	\N
6529	380	1003	\N	\N	71.07	seconds	\N
6569	595	980	\N	\N	336.97	seconds	\N
6530	623	1005	\N	\N	71.14	seconds	\N
6531	740	1005	\N	\N	71.26	seconds	\N
6597	688	1035	\N	\N	728.29	seconds	\N
6532	384	1004	\N	\N	71.34	seconds	\N
6570	366	979	\N	\N	338.73	seconds	\N
6533	362	1003	\N	\N	72.24	seconds	\N
6534	725	1005	\N	\N	72.54	seconds	\N
6535	501	1005	\N	\N	73.67	seconds	\N
6571	688	981	\N	\N	345.20	seconds	\N
6536	489	1005	\N	\N	74.68	seconds	\N
6537	529	1005	\N	\N	75.35	seconds	\N
6615	419	1035	\N	\N	914.13	seconds	\N
6538	456	1003	\N	\N	76.24	seconds	\N
6572	362	979	\N	\N	354.72	seconds	\N
6539	394	1003	\N	\N	78.47	seconds	\N
6540	424	1003	\N	\N	78.79	seconds	\N
6598	492	1034	\N	\N	743.93	seconds	\N
6541	1130	1004	\N	\N	79.84	seconds	\N
6573	455	979	\N	\N	356.26	seconds	\N
6542	624	1017	\N	\N	148.04	seconds	\N
6543	595	1016	\N	\N	151.40	seconds	\N
6544	587	1017	\N	\N	153.47	seconds	\N
6574	831	980	\N	\N	361.02	seconds	\N
6545	366	1015	\N	\N	154.98	seconds	\N
6546	581	1016	\N	\N	159.76	seconds	\N
6547	455	1015	\N	\N	160.68	seconds	\N
6575	816	981	\N	\N	363.73	seconds	\N
6548	688	1017	\N	\N	160.73	seconds	\N
6549	549	1015	\N	\N	161.27	seconds	\N
6599	624	1035	\N	\N	750.44	seconds	\N
6550	362	1015	\N	\N	162.53	seconds	\N
6576	521	981	\N	\N	365.12	seconds	\N
6551	831	1016	\N	\N	166.07	seconds	\N
6552	556	1016	\N	\N	169.40	seconds	\N
6553	816	1017	\N	\N	170.98	seconds	\N
6577	540	980	\N	\N	368.40	seconds	\N
6554	734	1015	\N	\N	172.15	seconds	\N
6555	521	1017	\N	\N	173.57	seconds	\N
6638	380	1021	\N	\N	57.78	seconds	\N
6556	335	1016	\N	\N	173.75	seconds	\N
6578	549	979	\N	\N	370.35	seconds	\N
6557	769	1017	\N	\N	174.03	seconds	\N
6558	499	1017	\N	\N	178.01	seconds	\N
6600	583	1035	\N	\N	750.85	seconds	\N
6559	740	1017	\N	\N	180.20	seconds	\N
6579	499	981	\N	\N	371.88	seconds	\N
6560	422	1017	\N	\N	183.93	seconds	\N
6561	1144	1016	\N	\N	189.81	seconds	\N
6562	419	1017	\N	\N	191.97	seconds	\N
6580	707	980	\N	\N	373.11	seconds	\N
6563	392	1015	\N	\N	191.99	seconds	\N
6564	642	1017	\N	\N	196.33	seconds	\N
6616	633	987	\N	\N	16.81	seconds	\N
6581	492	980	\N	\N	375.22	seconds	\N
6601	366	1033	\N	\N	752.55	seconds	\N
6582	683	979	\N	\N	378.64	seconds	\N
6583	486	981	\N	\N	381.00	seconds	\N
6584	545	979	\N	\N	383.01	seconds	\N
6602	521	1035	\N	\N	787.16	seconds	\N
6585	323	979	\N	\N	384.84	seconds	\N
6586	341	979	\N	\N	388.06	seconds	\N
6627	657	986	\N	\N	21.89	seconds	\N
6587	314	979	\N	\N	394.01	seconds	\N
6603	707	1034	\N	\N	788.37	seconds	\N
6588	422	981	\N	\N	395.87	seconds	\N
6589	311	981	\N	\N	398.87	seconds	\N
6617	566	986	\N	\N	17.29	seconds	\N
6590	419	981	\N	\N	410.75	seconds	\N
6604	831	1034	\N	\N	790.99	seconds	\N
6591	541	981	\N	\N	418.03	seconds	\N
6592	1144	980	\N	\N	422.39	seconds	\N
6593	392	979	\N	\N	426.26	seconds	\N
6605	553	1034	\N	\N	810.62	seconds	\N
6594	642	981	\N	\N	431.98	seconds	\N
6595	639	981	\N	\N	451.33	seconds	\N
6606	556	1034	\N	\N	822.42	seconds	\N
6618	628	987	\N	\N	17.46	seconds	\N
6607	540	1034	\N	\N	826.51	seconds	\N
6608	455	1033	\N	\N	834.83	seconds	\N
6634	664	1022	\N	\N	53.07	seconds	\N
6609	683	1033	\N	\N	837.28	seconds	\N
6619	636	985	\N	\N	17.97	seconds	\N
6610	314	1033	\N	\N	840.62	seconds	\N
6611	486	1035	\N	\N	853.10	seconds	\N
6628	617	1022	\N	\N	48.10	seconds	\N
6612	323	1033	\N	\N	859.04	seconds	\N
6620	638	986	\N	\N	19.00	seconds	\N
6613	341	1033	\N	\N	859.35	seconds	\N
6614	422	1035	\N	\N	875.03	seconds	\N
6621	496	987	\N	\N	19.36	seconds	\N
6622	517	987	\N	\N	19.44	seconds	\N
6629	566	1022	\N	\N	51.12	seconds	\N
6623	1133	985	\N	\N	19.45	seconds	\N
6624	664	986	\N	\N	20.48	seconds	\N
6625	711	986	\N	\N	21.12	seconds	\N
6630	633	1023	\N	\N	51.36	seconds	\N
6626	679	986	\N	\N	21.75	seconds	\N
6635	517	1023	\N	\N	53.25	seconds	\N
6631	628	1023	\N	\N	51.95	seconds	\N
6632	636	1021	\N	\N	52.49	seconds	\N
6641	637	1022	\N	\N	60.38	seconds	\N
6633	355	1022	\N	\N	53.06	seconds	\N
6636	638	1022	\N	\N	53.66	seconds	\N
6639	711	1022	\N	\N	58.71	seconds	\N
6637	496	1023	\N	\N	55.75	seconds	\N
6640	679	1022	\N	\N	60.04	seconds	\N
6643	356	1076	\N	\N	418.50	inches	\N
6642	657	1022	\N	\N	63.71	seconds	\N
6644	440	1076	\N	\N	357.00	inches	\N
6645	503	1077	\N	\N	338.00	inches	\N
6646	523	1077	\N	\N	333.00	inches	\N
6647	461	1077	\N	\N	331.00	inches	\N
6648	448	1075	\N	\N	330.50	inches	\N
6649	500	1076	\N	\N	326.00	inches	\N
6650	650	1076	\N	\N	316.00	inches	\N
6651	677	1076	\N	\N	313.25	inches	\N
6652	827	1075	\N	\N	309.50	inches	\N
6653	526	1077	\N	\N	290.75	inches	\N
6654	601	1077	\N	\N	289.00	inches	\N
6655	646	1077	\N	\N	283.00	inches	\N
6656	1178	1076	\N	\N	274.00	inches	\N
6657	406	1076	\N	\N	273.50	inches	\N
6658	710	1075	\N	\N	267.75	inches	\N
6659	692	1077	\N	\N	265.50	inches	\N
6660	334	1075	\N	\N	262.50	inches	\N
6709	634	1053	\N	\N	123.00	inches	\N
6661	667	1077	\N	\N	261.00	inches	\N
6662	390	1077	\N	\N	257.00	inches	\N
6663	811	1076	\N	\N	252.00	inches	\N
6710	601	1053	\N	\N	108.00	inches	\N
6664	357	1076	\N	\N	248.00	inches	\N
6665	443	1077	\N	\N	240.25	inches	\N
6740	626	1065	\N	\N	370.00	inches	\N
6666	731	1077	\N	\N	201.25	inches	\N
6711	1136	1052	\N	\N	102.00	inches	\N
6667	503	1071	\N	\N	1136.00	inches	\N
6668	533	1070	\N	\N	1136.00	inches	\N
6669	461	1071	\N	\N	1063.00	inches	\N
6712	501	1053	\N	\N	90.00	inches	\N
6670	827	1069	\N	\N	1053.00	inches	\N
6671	523	1071	\N	\N	1045.00	inches	\N
6759	519	1013	\N	\N	12.01	seconds	\N
6672	356	1070	\N	\N	1018.00	inches	\N
6713	384	1052	\N	\N	84.00	inches	\N
6673	677	1070	\N	\N	963.00	inches	\N
6674	440	1070	\N	\N	926.00	inches	\N
6741	601	1065	\N	\N	367.50	inches	\N
6675	601	1071	\N	\N	922.00	inches	\N
6714	342	1051	\N	\N	78.00	inches	\N
6676	526	1071	\N	\N	912.00	inches	\N
6677	349	1071	\N	\N	874.00	inches	\N
6678	525	1071	\N	\N	865.00	inches	\N
6715	647	1058	\N	\N	203.25	inches	\N
6679	1178	1070	\N	\N	835.50	inches	\N
6680	725	1071	\N	\N	802.00	inches	\N
6681	710	1069	\N	\N	789.00	inches	\N
6716	627	1059	\N	\N	194.00	inches	\N
6682	692	1071	\N	\N	776.00	inches	\N
6683	500	1070	\N	\N	744.00	inches	\N
6742	533	1064	\N	\N	359.50	inches	\N
6684	448	1069	\N	\N	730.00	inches	\N
6717	487	1058	\N	\N	180.75	inches	\N
6685	646	1071	\N	\N	724.00	inches	\N
6686	406	1070	\N	\N	713.00	inches	\N
6687	670	1069	\N	\N	701.00	inches	\N
6718	515	1057	\N	\N	178.00	inches	\N
6688	650	1070	\N	\N	694.00	inches	\N
6689	667	1071	\N	\N	642.50	inches	\N
6782	309	1014	\N	\N	12.68	seconds	\N
6690	334	1069	\N	\N	633.50	inches	\N
6719	632	1059	\N	\N	178.00	inches	\N
6691	1133	1069	\N	\N	630.00	inches	\N
6692	713	1070	\N	\N	567.00	inches	\N
6743	322	1065	\N	\N	356.00	inches	\N
6693	443	1071	\N	\N	566.00	inches	\N
6720	347	1057	\N	\N	176.00	inches	\N
6694	390	1071	\N	\N	520.00	inches	\N
6695	333	1047	\N	\N	62.00	inches	\N
6696	350	1047	\N	\N	58.00	inches	\N
6721	566	1058	\N	\N	174.00	inches	\N
6697	487	1046	\N	\N	56.00	inches	\N
6698	515	1045	\N	\N	54.00	inches	\N
6760	794	1012	\N	\N	12.06	seconds	\N
6699	626	1047	\N	\N	54.00	inches	\N
6722	452	1059	\N	\N	172.00	inches	\N
6700	633	1047	\N	\N	54.00	inches	\N
6701	498	1046	\N	\N	50.00	inches	\N
6744	708	1064	\N	\N	345.50	inches	\N
6702	734	1045	\N	\N	50.00	inches	\N
6723	498	1058	\N	\N	169.00	inches	\N
6703	711	1046	\N	\N	50.00	inches	\N
6704	741	1047	\N	\N	50.00	inches	\N
6705	644	1046	\N	\N	48.00	inches	\N
6724	429	1059	\N	\N	166.50	inches	\N
6706	664	1046	\N	\N	48.00	inches	\N
6707	647	1052	\N	\N	158.00	inches	\N
6708	577	1053	\N	\N	146.00	inches	\N
6725	322	1059	\N	\N	164.00	inches	\N
6745	429	1065	\N	\N	343.00	inches	\N
6726	663	1057	\N	\N	158.50	inches	\N
6727	424	1057	\N	\N	158.00	inches	\N
6771	407	1014	\N	\N	12.34	seconds	\N
6728	741	1059	\N	\N	156.50	inches	\N
6746	741	1065	\N	\N	334.75	inches	\N
6729	720	1057	\N	\N	155.00	inches	\N
6730	349	1059	\N	\N	154.75	inches	\N
6761	715	1014	\N	\N	12.09	seconds	\N
6731	1141	1058	\N	\N	151.00	inches	\N
6747	536	1065	\N	\N	332.50	inches	\N
6732	416	1057	\N	\N	149.50	inches	\N
6733	536	1059	\N	\N	148.00	inches	\N
6734	731	1059	\N	\N	141.50	inches	\N
6748	452	1065	\N	\N	329.00	inches	\N
6735	408	1058	\N	\N	136.50	inches	\N
6736	634	1065	\N	\N	434.50	inches	\N
6737	633	1065	\N	\N	394.00	inches	\N
6749	663	1063	\N	\N	322.00	inches	\N
6738	632	1065	\N	\N	385.75	inches	\N
6739	515	1063	\N	\N	381.00	inches	\N
6762	726	1014	\N	\N	12.10	seconds	\N
6750	408	1064	\N	\N	301.00	inches	\N
6751	710	1063	\N	\N	297.00	inches	\N
6778	728	1013	\N	\N	12.50	seconds	\N
6752	745	1063	\N	\N	291.00	inches	\N
6763	383	1014	\N	\N	12.14	seconds	\N
6753	720	1063	\N	\N	290.75	inches	\N
6754	597	1014	\N	\N	11.40	seconds	\N
6772	530	1014	\N	\N	12.35	seconds	\N
6755	520	1014	\N	\N	11.55	seconds	\N
6764	669	1014	\N	\N	12.14	seconds	\N
6756	391	1014	\N	\N	11.59	seconds	\N
6757	482	1014	\N	\N	11.78	seconds	\N
6758	386	1013	\N	\N	11.93	seconds	\N
6765	435	1014	\N	\N	12.15	seconds	\N
6766	696	1013	\N	\N	12.19	seconds	\N
6773	552	1014	\N	\N	12.37	seconds	\N
6767	605	1012	\N	\N	12.21	seconds	\N
6768	798	1014	\N	\N	12.22	seconds	\N
6769	551	1014	\N	\N	12.25	seconds	\N
6774	693	1012	\N	\N	12.40	seconds	\N
6770	689	1014	\N	\N	12.30	seconds	\N
6779	427	1014	\N	\N	12.55	seconds	\N
6775	370	1013	\N	\N	12.41	seconds	\N
6776	438	1014	\N	\N	12.46	seconds	\N
6785	580	1013	\N	\N	13.24	seconds	\N
6777	582	1014	\N	\N	12.49	seconds	\N
6780	668	1013	\N	\N	12.59	seconds	\N
6783	801	1013	\N	\N	12.70	seconds	\N
6781	398	1014	\N	\N	12.65	seconds	\N
6784	748	1013	\N	\N	12.71	seconds	\N
6787	575	1012	\N	\N	13.32	seconds	\N
6786	1137	1012	\N	\N	13.30	seconds	\N
6788	564	1013	\N	\N	13.36	seconds	\N
6789	567	1012	\N	\N	14.79	seconds	\N
6790	597	1032	\N	\N	22.80	seconds	\N
6791	391	1032	\N	\N	23.02	seconds	\N
6792	482	1032	\N	\N	23.75	seconds	\N
6793	656	1032	\N	\N	24.15	seconds	\N
6794	520	1032	\N	\N	24.19	seconds	\N
6795	689	1032	\N	\N	24.37	seconds	\N
6796	802	1030	\N	\N	24.50	seconds	\N
6797	715	1032	\N	\N	24.57	seconds	\N
6798	726	1032	\N	\N	24.59	seconds	\N
6799	582	1032	\N	\N	24.65	seconds	\N
6800	386	1031	\N	\N	24.69	seconds	\N
6801	794	1030	\N	\N	24.77	seconds	\N
6802	712	1032	\N	\N	24.80	seconds	\N
6803	605	1030	\N	\N	24.97	seconds	\N
6804	438	1032	\N	\N	24.98	seconds	\N
6805	383	1032	\N	\N	25.26	seconds	\N
6806	928	1032	\N	\N	25.26	seconds	\N
6854	682	1007	\N	\N	59.77	seconds	\N
6807	693	1030	\N	\N	25.28	seconds	\N
6808	370	1031	\N	\N	25.31	seconds	\N
6809	340	1032	\N	\N	25.35	seconds	\N
6855	425	1008	\N	\N	59.85	seconds	\N
6810	435	1032	\N	\N	25.41	seconds	\N
6811	596	1030	\N	\N	25.55	seconds	\N
6885	432	1020	\N	\N	150.93	seconds	\N
6812	749	1031	\N	\N	25.57	seconds	\N
6856	563	1007	\N	\N	60.19	seconds	\N
6813	748	1031	\N	\N	25.63	seconds	\N
6814	671	1032	\N	\N	25.85	seconds	\N
6815	439	1030	\N	\N	25.86	seconds	\N
6857	398	1008	\N	\N	61.64	seconds	\N
6816	801	1031	\N	\N	26.00	seconds	\N
6817	495	1031	\N	\N	26.00	seconds	\N
6818	779	1030	\N	\N	26.00	seconds	\N
6858	571	1006	\N	\N	61.76	seconds	\N
6819	444	1032	\N	\N	26.24	seconds	\N
6820	398	1032	\N	\N	26.31	seconds	\N
6886	563	1019	\N	\N	157.11	seconds	\N
6821	668	1031	\N	\N	26.43	seconds	\N
6859	430	1008	\N	\N	61.86	seconds	\N
6822	580	1031	\N	\N	26.72	seconds	\N
6823	682	1031	\N	\N	26.73	seconds	\N
6824	309	1032	\N	\N	26.99	seconds	\N
6860	579	1006	\N	\N	62.00	seconds	\N
6825	575	1030	\N	\N	27.22	seconds	\N
6826	563	1031	\N	\N	27.31	seconds	\N
6904	543	984	\N	\N	304.59	seconds	\N
6827	817	1032	\N	\N	27.40	seconds	\N
6861	412	1008	\N	\N	62.02	seconds	\N
6828	1137	1030	\N	\N	27.85	seconds	\N
6829	571	1030	\N	\N	27.87	seconds	\N
6887	746	1020	\N	\N	159.30	seconds	\N
6830	564	1031	\N	\N	27.91	seconds	\N
6862	817	1008	\N	\N	62.17	seconds	\N
6831	567	1030	\N	\N	30.95	seconds	\N
6832	597	1008	\N	\N	52.00	seconds	\N
6833	753	1008	\N	\N	52.80	seconds	\N
6863	567	1006	\N	\N	66.95	seconds	\N
6834	802	1006	\N	\N	53.31	seconds	\N
6835	608	1006	\N	\N	54.50	seconds	\N
6836	407	1008	\N	\N	54.59	seconds	\N
6864	516	1020	\N	\N	117.76	seconds	\N
6837	374	1006	\N	\N	54.91	seconds	\N
6838	582	1008	\N	\N	54.97	seconds	\N
6888	436	1019	\N	\N	161.05	seconds	\N
6839	718	1006	\N	\N	55.20	seconds	\N
6865	753	1020	\N	\N	120.11	seconds	\N
6840	618	1008	\N	\N	56.30	seconds	\N
6841	780	1006	\N	\N	56.42	seconds	\N
6842	727	1008	\N	\N	56.43	seconds	\N
6866	625	1018	\N	\N	120.44	seconds	\N
6843	749	1007	\N	\N	56.56	seconds	\N
6844	712	1008	\N	\N	56.59	seconds	\N
6927	516	1038	\N	\N	604.07	seconds	\N
6845	495	1007	\N	\N	56.69	seconds	\N
6867	592	1019	\N	\N	123.17	seconds	\N
6846	381	1008	\N	\N	57.00	seconds	\N
6847	340	1008	\N	\N	57.14	seconds	\N
6889	516	984	\N	\N	258.40	seconds	\N
6848	768	1008	\N	\N	57.40	seconds	\N
6868	696	1019	\N	\N	124.50	seconds	\N
6849	785	1006	\N	\N	58.46	seconds	\N
6850	748	1007	\N	\N	58.51	seconds	\N
6851	576	1007	\N	\N	58.54	seconds	\N
6869	810	1019	\N	\N	126.70	seconds	\N
6852	444	1008	\N	\N	58.68	seconds	\N
6853	671	1008	\N	\N	58.68	seconds	\N
6905	739	984	\N	\N	305.59	seconds	\N
6870	752	1019	\N	\N	127.97	seconds	\N
6890	592	983	\N	\N	263.39	seconds	\N
6871	751	1020	\N	\N	132.15	seconds	\N
6872	749	1019	\N	\N	132.42	seconds	\N
6873	514	1018	\N	\N	132.92	seconds	\N
6891	696	983	\N	\N	273.00	seconds	\N
6874	615	1018	\N	\N	133.64	seconds	\N
6875	363	1020	\N	\N	133.68	seconds	\N
6916	570	984	\N	\N	323.32	seconds	\N
6876	815	1019	\N	\N	136.07	seconds	\N
6892	929	984	\N	\N	273.02	seconds	\N
6877	754	1018	\N	\N	137.30	seconds	\N
6878	409	1020	\N	\N	137.77	seconds	\N
6906	717	982	\N	\N	305.81	seconds	\N
6879	572	1020	\N	\N	137.90	seconds	\N
6893	752	983	\N	\N	273.19	seconds	\N
6880	458	1020	\N	\N	138.82	seconds	\N
6881	542	1020	\N	\N	143.50	seconds	\N
6882	449	1020	\N	\N	145.48	seconds	\N
6894	753	984	\N	\N	276.92	seconds	\N
6883	662	1020	\N	\N	147.39	seconds	\N
6884	413	1020	\N	\N	147.52	seconds	\N
6895	490	984	\N	\N	277.73	seconds	\N
6907	744	984	\N	\N	305.90	seconds	\N
6896	810	983	\N	\N	280.40	seconds	\N
6897	555	983	\N	\N	280.96	seconds	\N
6923	765	983	\N	\N	332.80	seconds	\N
6898	470	983	\N	\N	284.23	seconds	\N
6908	1135	982	\N	\N	306.66	seconds	\N
6899	815	983	\N	\N	286.03	seconds	\N
6900	514	982	\N	\N	292.58	seconds	\N
6917	750	984	\N	\N	323.74	seconds	\N
6901	351	982	\N	\N	294.91	seconds	\N
6909	547	983	\N	\N	306.68	seconds	\N
6902	308	984	\N	\N	298.01	seconds	\N
6903	560	984	\N	\N	298.45	seconds	\N
6910	458	984	\N	\N	309.69	seconds	\N
6911	409	984	\N	\N	311.85	seconds	\N
6918	411	983	\N	\N	324.00	seconds	\N
6912	542	984	\N	\N	313.20	seconds	\N
6913	662	984	\N	\N	317.37	seconds	\N
6914	751	984	\N	\N	319.67	seconds	\N
6919	432	984	\N	\N	326.17	seconds	\N
6915	413	984	\N	\N	323.22	seconds	\N
6924	561	982	\N	\N	387.56	seconds	\N
6920	316	983	\N	\N	326.72	seconds	\N
6921	754	982	\N	\N	327.61	seconds	\N
6930	815	1037	\N	\N	636.80	seconds	\N
6922	589	982	\N	\N	329.89	seconds	\N
6925	612	1038	\N	\N	592.00	seconds	\N
6928	470	1037	\N	\N	604.50	seconds	\N
6926	490	1038	\N	\N	596.81	seconds	\N
6929	929	1038	\N	\N	619.53	seconds	\N
6932	787	1036	\N	\N	641.38	seconds	\N
6931	610	1038	\N	\N	637.30	seconds	\N
6933	560	1038	\N	\N	642.34	seconds	\N
6934	619	1036	\N	\N	653.90	seconds	\N
6935	550	1036	\N	\N	655.50	seconds	\N
6936	559	1037	\N	\N	655.60	seconds	\N
6937	547	1037	\N	\N	657.90	seconds	\N
6938	1135	1036	\N	\N	667.89	seconds	\N
6939	739	1038	\N	\N	673.79	seconds	\N
6940	351	1036	\N	\N	675.32	seconds	\N
6941	308	1038	\N	\N	675.48	seconds	\N
6942	609	1036	\N	\N	678.80	seconds	\N
6943	717	1036	\N	\N	688.19	seconds	\N
6944	543	1038	\N	\N	689.93	seconds	\N
6945	411	1037	\N	\N	691.80	seconds	\N
6946	409	1038	\N	\N	695.42	seconds	\N
6947	317	1038	\N	\N	696.55	seconds	\N
6948	316	1037	\N	\N	697.60	seconds	\N
6998	344	1080	\N	\N	463.50	inches	\N
6949	662	1038	\N	\N	703.06	seconds	\N
6950	337	1036	\N	\N	704.68	seconds	\N
6951	413	1038	\N	\N	705.69	seconds	\N
6999	737	1080	\N	\N	461.50	inches	\N
6952	795	1036	\N	\N	706.01	seconds	\N
6953	458	1038	\N	\N	713.48	seconds	\N
7029	506	1074	\N	\N	1082.00	inches	\N
6954	306	1036	\N	\N	725.74	seconds	\N
7000	1148	1080	\N	\N	449.50	inches	\N
6955	434	1037	\N	\N	728.81	seconds	\N
6956	410	1036	\N	\N	765.27	seconds	\N
6957	504	1037	\N	\N	767.08	seconds	\N
7001	512	1080	\N	\N	449.00	inches	\N
6958	561	1036	\N	\N	865.06	seconds	\N
6959	378	996	\N	\N	16.68	seconds	\N
7048	570	1050	\N	\N	58.00	inches	\N
6960	491	995	\N	\N	17.34	seconds	\N
7002	431	1080	\N	\N	440.00	inches	\N
6961	656	996	\N	\N	17.36	seconds	\N
6962	607	996	\N	\N	17.54	seconds	\N
7030	488	1073	\N	\N	1080.00	inches	\N
6963	527	996	\N	\N	17.60	seconds	\N
7003	321	1080	\N	\N	432.75	inches	\N
6964	813	996	\N	\N	18.64	seconds	\N
6965	784	994	\N	\N	19.19	seconds	\N
6966	478	995	\N	\N	19.37	seconds	\N
7004	792	1078	\N	\N	428.50	inches	\N
6967	396	996	\N	\N	19.73	seconds	\N
6968	727	996	\N	\N	19.76	seconds	\N
6969	799	994	\N	\N	21.17	seconds	\N
7005	791	1078	\N	\N	425.50	inches	\N
6970	395	995	\N	\N	22.94	seconds	\N
6971	450	994	\N	\N	25.39	seconds	\N
6972	421	994	\N	\N	99999999.00	seconds	\N
7031	791	1072	\N	\N	1061.75	inches	\N
6973	656	1026	\N	\N	43.52	seconds	\N
7006	552	1080	\N	\N	422.00	inches	\N
6974	491	1025	\N	\N	44.20	seconds	\N
6975	378	1026	\N	\N	44.65	seconds	\N
6976	802	1024	\N	\N	45.07	seconds	\N
7007	327	1079	\N	\N	421.00	inches	\N
6977	381	1026	\N	\N	45.80	seconds	\N
6978	607	1026	\N	\N	45.82	seconds	\N
7071	403	1061	\N	\N	224.00	inches	\N
6979	727	1026	\N	\N	45.88	seconds	\N
7008	532	1080	\N	\N	420.00	inches	\N
6980	527	1026	\N	\N	46.00	seconds	\N
6981	570	1026	\N	\N	46.96	seconds	\N
7032	729	1074	\N	\N	1028.50	inches	\N
6982	784	1024	\N	\N	47.80	seconds	\N
7009	506	1080	\N	\N	393.50	inches	\N
6983	396	1026	\N	\N	48.08	seconds	\N
6984	478	1025	\N	\N	48.72	seconds	\N
6985	421	1024	\N	\N	50.14	seconds	\N
7010	397	1079	\N	\N	390.75	inches	\N
6986	799	1024	\N	\N	51.31	seconds	\N
6987	813	1026	\N	\N	51.50	seconds	\N
7049	690	1049	\N	\N	58.00	inches	\N
6988	551	1026	\N	\N	52.85	seconds	\N
7011	618	1080	\N	\N	390.00	inches	\N
6989	395	1025	\N	\N	57.19	seconds	\N
6990	722	1026	\N	\N	59.59	seconds	\N
7033	700	1073	\N	\N	1000.00	inches	\N
6991	450	1024	\N	\N	60.50	seconds	\N
7012	585	1079	\N	\N	359.25	inches	\N
6992	661	1080	\N	\N	609.00	inches	\N
6993	460	1079	\N	\N	557.00	inches	\N
6994	497	1080	\N	\N	497.00	inches	\N
7013	1142	1078	\N	\N	311.00	inches	\N
6995	729	1080	\N	\N	481.25	inches	\N
6996	703	1080	\N	\N	471.50	inches	\N
6997	669	1080	\N	\N	471.00	inches	\N
7034	585	1073	\N	\N	991.50	inches	\N
7014	1145	1079	\N	\N	259.75	inches	\N
7015	661	1074	\N	\N	1782.00	inches	\N
7060	590	1055	\N	\N	108.00	inches	\N
7016	460	1073	\N	\N	1580.50	inches	\N
7035	564	1073	\N	\N	883.00	inches	\N
7017	497	1074	\N	\N	1509.00	inches	\N
7018	532	1074	\N	\N	1425.50	inches	\N
7050	693	1048	\N	\N	56.00	inches	\N
7019	737	1074	\N	\N	1413.00	inches	\N
7036	378	1050	\N	\N	72.00	inches	\N
7020	344	1074	\N	\N	1363.00	inches	\N
7021	792	1072	\N	\N	1191.00	inches	\N
7022	703	1074	\N	\N	1133.00	inches	\N
7037	781	1048	\N	\N	70.00	inches	\N
7023	512	1074	\N	\N	1130.00	inches	\N
7024	618	1074	\N	\N	1121.50	inches	\N
7025	431	1074	\N	\N	1118.00	inches	\N
7038	733	1050	\N	\N	70.00	inches	\N
7026	548	1073	\N	\N	1106.50	inches	\N
7027	397	1073	\N	\N	1092.00	inches	\N
7051	430	1050	\N	\N	52.00	inches	\N
7028	327	1073	\N	\N	1090.00	inches	\N
7039	714	1050	\N	\N	68.00	inches	\N
7040	388	1050	\N	\N	67.00	inches	\N
7067	715	1062	\N	\N	235.50	inches	\N
7041	509	1050	\N	\N	64.00	inches	\N
7052	376	1056	\N	\N	138.00	inches	\N
7042	630	1049	\N	\N	64.00	inches	\N
7043	332	1049	\N	\N	63.00	inches	\N
7061	718	1054	\N	\N	108.00	inches	\N
7044	345	1048	\N	\N	62.00	inches	\N
7053	629	1056	\N	\N	138.00	inches	\N
7045	507	1049	\N	\N	60.00	inches	\N
7046	451	1049	\N	\N	58.00	inches	\N
7047	823	1050	\N	\N	58.00	inches	\N
7054	527	1056	\N	\N	126.00	inches	\N
7055	630	1055	\N	\N	126.00	inches	\N
7062	690	1055	\N	\N	102.00	inches	\N
7056	388	1056	\N	\N	120.00	inches	\N
7057	505	1056	\N	\N	120.00	inches	\N
7058	364	1054	\N	\N	108.00	inches	\N
7063	784	1054	\N	\N	97.00	inches	\N
7059	805	1054	\N	\N	108.00	inches	\N
7068	378	1062	\N	\N	232.00	inches	\N
7064	1166	1054	\N	\N	96.00	inches	\N
7065	325	1056	\N	\N	84.00	inches	\N
7074	714	1062	\N	\N	218.00	inches	\N
7066	733	1062	\N	\N	236.00	inches	\N
7069	519	1061	\N	\N	230.00	inches	\N
7072	689	1062	\N	\N	223.50	inches	\N
7070	491	1061	\N	\N	227.75	inches	\N
7073	607	1062	\N	\N	221.50	inches	\N
7076	520	1062	\N	\N	216.00	inches	\N
7075	732	1062	\N	\N	218.00	inches	\N
7077	509	1062	\N	\N	216.00	inches	\N
7078	383	1062	\N	\N	213.50	inches	\N
7079	386	1061	\N	\N	213.00	inches	\N
7080	332	1061	\N	\N	212.00	inches	\N
7081	530	1062	\N	\N	211.75	inches	\N
7082	478	1061	\N	\N	210.50	inches	\N
7083	661	1062	\N	\N	207.75	inches	\N
7084	781	1060	\N	\N	207.00	inches	\N
7085	824	1060	\N	\N	206.00	inches	\N
7086	778	1061	\N	\N	205.25	inches	\N
7087	507	1061	\N	\N	204.00	inches	\N
7088	721	1062	\N	\N	201.00	inches	\N
7089	451	1061	\N	\N	198.75	inches	\N
7090	430	1062	\N	\N	194.25	inches	\N
7091	690	1061	\N	\N	191.00	inches	\N
7092	412	1062	\N	\N	188.75	inches	\N
7093	575	1060	\N	\N	185.00	inches	\N
7094	1180	1062	\N	\N	182.50	inches	\N
7095	579	1060	\N	\N	179.00	inches	\N
7143	736	1117	\N	\N	14.89	seconds	\N
7096	433	1061	\N	\N	178.00	inches	\N
7097	561	1060	\N	\N	157.00	inches	\N
7098	519	1067	\N	\N	501.00	inches	\N
7144	578	1118	\N	\N	14.95	seconds	\N
7099	733	1068	\N	\N	478.75	inches	\N
7100	403	1067	\N	\N	475.75	inches	\N
7174	755	1137	\N	\N	32.08	seconds	\N
7101	509	1068	\N	\N	467.00	inches	\N
7145	695	1117	\N	\N	15.00	seconds	\N
7102	732	1068	\N	\N	467.00	inches	\N
7103	607	1068	\N	\N	466.00	inches	\N
7104	376	1068	\N	\N	463.00	inches	\N
7146	1132	1117	\N	\N	15.48	seconds	\N
7105	530	1068	\N	\N	453.50	inches	\N
7106	781	1066	\N	\N	442.00	inches	\N
7107	332	1067	\N	\N	440.00	inches	\N
7147	573	1117	\N	\N	15.51	seconds	\N
7108	714	1068	\N	\N	433.00	inches	\N
7109	507	1067	\N	\N	430.00	inches	\N
7175	573	1135	\N	\N	32.13	seconds	\N
7110	430	1068	\N	\N	424.00	inches	\N
7148	586	1118	\N	\N	15.54	seconds	\N
7111	690	1067	\N	\N	421.50	inches	\N
7112	728	1067	\N	\N	412.00	inches	\N
7113	778	1067	\N	\N	406.50	inches	\N
7149	644	1118	\N	\N	15.92	seconds	\N
7114	451	1067	\N	\N	395.25	inches	\N
7115	412	1068	\N	\N	388.25	inches	\N
7193	611	1112	\N	\N	70.57	seconds	\N
7116	1180	1068	\N	\N	377.00	inches	\N
7150	641	1119	\N	\N	16.12	seconds	\N
7117	433	1067	\N	\N	370.00	inches	\N
7118	645	1119	\N	\N	12.15	seconds	\N
7176	586	1136	\N	\N	32.29	seconds	\N
7119	647	1118	\N	\N	13.21	seconds	\N
7151	635	1118	\N	\N	16.44	seconds	\N
7120	528	1117	\N	\N	13.61	seconds	\N
7121	632	1119	\N	\N	13.79	seconds	\N
7122	566	1118	\N	\N	13.82	seconds	\N
7152	631	1119	\N	\N	17.58	seconds	\N
7123	719	1119	\N	\N	13.87	seconds	\N
7124	660	1117	\N	\N	13.92	seconds	\N
7125	617	1118	\N	\N	13.98	seconds	\N
7153	645	1137	\N	\N	24.76	seconds	\N
7126	588	1119	\N	\N	14.06	seconds	\N
7127	827	1117	\N	\N	14.30	seconds	\N
7177	424	1135	\N	\N	33.01	seconds	\N
7128	663	1117	\N	\N	14.34	seconds	\N
7154	627	1137	\N	\N	26.90	seconds	\N
7129	452	1119	\N	\N	14.35	seconds	\N
7130	764	1117	\N	\N	14.35	seconds	\N
7131	423	1118	\N	\N	14.42	seconds	\N
7155	708	1136	\N	\N	27.96	seconds	\N
7132	735	1119	\N	\N	14.51	seconds	\N
7133	755	1119	\N	\N	14.52	seconds	\N
7216	831	1124	\N	\N	166.07	seconds	\N
7134	429	1119	\N	\N	14.53	seconds	\N
7156	367	1136	\N	\N	28.02	seconds	\N
7135	416	1117	\N	\N	14.66	seconds	\N
7136	355	1118	\N	\N	14.70	seconds	\N
7178	769	1137	\N	\N	33.13	seconds	\N
7137	706	1117	\N	\N	14.71	seconds	\N
7157	719	1137	\N	\N	28.10	seconds	\N
7138	825	1119	\N	\N	14.80	seconds	\N
7139	1133	1117	\N	\N	14.82	seconds	\N
7140	1141	1118	\N	\N	14.85	seconds	\N
7158	634	1137	\N	\N	28.34	seconds	\N
7141	424	1117	\N	\N	14.89	seconds	\N
7142	702	1118	\N	\N	14.89	seconds	\N
7194	380	1111	\N	\N	71.07	seconds	\N
7159	528	1135	\N	\N	28.69	seconds	\N
7179	456	1135	\N	\N	33.28	seconds	\N
7160	588	1137	\N	\N	29.61	seconds	\N
7161	660	1135	\N	\N	29.71	seconds	\N
7162	764	1135	\N	\N	30.38	seconds	\N
7180	644	1136	\N	\N	34.12	seconds	\N
7163	663	1135	\N	\N	30.73	seconds	\N
7164	1141	1136	\N	\N	30.80	seconds	\N
7205	424	1111	\N	\N	78.79	seconds	\N
7165	706	1135	\N	\N	30.84	seconds	\N
7181	408	1136	\N	\N	34.58	seconds	\N
7166	825	1137	\N	\N	30.90	seconds	\N
7167	416	1135	\N	\N	30.93	seconds	\N
7195	623	1113	\N	\N	71.14	seconds	\N
7168	695	1135	\N	\N	31.08	seconds	\N
7182	1132	1135	\N	\N	35.30	seconds	\N
7169	594	1135	\N	\N	31.10	seconds	\N
7170	745	1135	\N	\N	31.20	seconds	\N
7171	763	1135	\N	\N	31.23	seconds	\N
7183	635	1136	\N	\N	35.42	seconds	\N
7172	702	1136	\N	\N	31.50	seconds	\N
7173	1133	1135	\N	\N	31.79	seconds	\N
7184	641	1137	\N	\N	35.61	seconds	\N
7196	740	1113	\N	\N	71.26	seconds	\N
7185	631	1137	\N	\N	36.99	seconds	\N
7186	645	1113	\N	\N	56.00	seconds	\N
7212	455	1123	\N	\N	160.68	seconds	\N
7187	367	1112	\N	\N	60.62	seconds	\N
7197	384	1112	\N	\N	71.34	seconds	\N
7188	708	1112	\N	\N	63.60	seconds	\N
7189	627	1113	\N	\N	66.29	seconds	\N
7206	1130	1112	\N	\N	79.84	seconds	\N
7190	584	1112	\N	\N	67.92	seconds	\N
7198	362	1111	\N	\N	72.24	seconds	\N
7191	423	1112	\N	\N	70.40	seconds	\N
7192	763	1111	\N	\N	70.48	seconds	\N
7199	725	1113	\N	\N	72.54	seconds	\N
7200	501	1113	\N	\N	73.67	seconds	\N
7207	624	1125	\N	\N	148.04	seconds	\N
7201	489	1113	\N	\N	74.68	seconds	\N
7202	529	1113	\N	\N	75.35	seconds	\N
7203	456	1111	\N	\N	76.24	seconds	\N
7208	595	1124	\N	\N	151.40	seconds	\N
7204	394	1111	\N	\N	78.47	seconds	\N
7213	688	1125	\N	\N	160.73	seconds	\N
7209	587	1125	\N	\N	153.47	seconds	\N
7210	366	1123	\N	\N	154.98	seconds	\N
7219	734	1123	\N	\N	172.15	seconds	\N
7211	581	1124	\N	\N	159.76	seconds	\N
7214	549	1123	\N	\N	161.27	seconds	\N
7217	556	1124	\N	\N	169.40	seconds	\N
7215	362	1123	\N	\N	162.53	seconds	\N
7218	816	1125	\N	\N	170.98	seconds	\N
7221	335	1124	\N	\N	173.75	seconds	\N
7220	521	1125	\N	\N	173.57	seconds	\N
7222	769	1125	\N	\N	174.03	seconds	\N
7223	499	1125	\N	\N	178.01	seconds	\N
7224	740	1125	\N	\N	180.20	seconds	\N
7225	422	1125	\N	\N	183.93	seconds	\N
7226	759	1125	\N	\N	184.15	seconds	\N
7227	1144	1124	\N	\N	189.81	seconds	\N
7228	419	1125	\N	\N	191.97	seconds	\N
7229	392	1123	\N	\N	191.99	seconds	\N
7230	642	1125	\N	\N	196.33	seconds	\N
7231	639	1125	\N	\N	204.03	seconds	\N
7232	587	1089	\N	\N	298.53	seconds	\N
7233	624	1089	\N	\N	327.78	seconds	\N
7234	583	1089	\N	\N	336.32	seconds	\N
7235	595	1088	\N	\N	336.97	seconds	\N
7236	366	1087	\N	\N	338.73	seconds	\N
7237	688	1089	\N	\N	345.20	seconds	\N
7238	362	1087	\N	\N	354.72	seconds	\N
7287	638	1094	\N	\N	19.00	seconds	\N
7239	455	1087	\N	\N	356.26	seconds	\N
7240	831	1088	\N	\N	361.02	seconds	\N
7241	816	1089	\N	\N	363.73	seconds	\N
7288	496	1095	\N	\N	19.36	seconds	\N
7242	521	1089	\N	\N	365.12	seconds	\N
7243	540	1088	\N	\N	368.40	seconds	\N
7318	677	1184	\N	\N	313.25	inches	\N
7244	549	1087	\N	\N	370.35	seconds	\N
7289	517	1095	\N	\N	19.44	seconds	\N
7245	499	1089	\N	\N	371.88	seconds	\N
7246	707	1088	\N	\N	373.11	seconds	\N
7247	492	1088	\N	\N	375.22	seconds	\N
7290	1133	1093	\N	\N	19.45	seconds	\N
7248	683	1087	\N	\N	378.64	seconds	\N
7249	486	1089	\N	\N	381.00	seconds	\N
7337	827	1177	\N	\N	1053.00	inches	\N
7250	545	1087	\N	\N	383.01	seconds	\N
7291	664	1094	\N	\N	20.48	seconds	\N
7251	323	1087	\N	\N	384.84	seconds	\N
7252	341	1087	\N	\N	388.06	seconds	\N
7319	827	1183	\N	\N	309.50	inches	\N
7253	314	1087	\N	\N	394.01	seconds	\N
7292	711	1094	\N	\N	21.12	seconds	\N
7254	759	1089	\N	\N	394.17	seconds	\N
7255	422	1089	\N	\N	395.87	seconds	\N
7256	311	1089	\N	\N	398.87	seconds	\N
7293	679	1094	\N	\N	21.75	seconds	\N
7257	419	1089	\N	\N	410.75	seconds	\N
7258	541	1089	\N	\N	418.03	seconds	\N
7259	1144	1088	\N	\N	422.39	seconds	\N
7294	657	1094	\N	\N	21.89	seconds	\N
7260	392	1087	\N	\N	426.26	seconds	\N
7261	642	1089	\N	\N	431.98	seconds	\N
7320	526	1185	\N	\N	290.75	inches	\N
7262	639	1089	\N	\N	451.33	seconds	\N
7295	617	1130	\N	\N	48.10	seconds	\N
7263	587	1143	\N	\N	661.55	seconds	\N
7264	688	1143	\N	\N	728.29	seconds	\N
7265	492	1142	\N	\N	743.93	seconds	\N
7296	566	1130	\N	\N	51.12	seconds	\N
7266	624	1143	\N	\N	750.44	seconds	\N
7267	583	1143	\N	\N	750.85	seconds	\N
7360	443	1179	\N	\N	566.00	inches	\N
7268	366	1141	\N	\N	752.55	seconds	\N
7297	633	1131	\N	\N	51.36	seconds	\N
7269	521	1143	\N	\N	787.16	seconds	\N
7270	707	1142	\N	\N	788.37	seconds	\N
7321	601	1185	\N	\N	289.00	inches	\N
7271	831	1142	\N	\N	790.99	seconds	\N
7298	628	1131	\N	\N	51.95	seconds	\N
7272	553	1142	\N	\N	810.62	seconds	\N
7273	556	1142	\N	\N	822.42	seconds	\N
7274	540	1142	\N	\N	826.51	seconds	\N
7299	636	1129	\N	\N	52.49	seconds	\N
7275	455	1141	\N	\N	834.83	seconds	\N
7276	683	1141	\N	\N	837.28	seconds	\N
7338	523	1179	\N	\N	1045.00	inches	\N
7277	314	1141	\N	\N	840.62	seconds	\N
7300	355	1130	\N	\N	53.06	seconds	\N
7278	486	1143	\N	\N	853.10	seconds	\N
7279	323	1141	\N	\N	859.04	seconds	\N
7322	646	1185	\N	\N	283.00	inches	\N
7280	341	1141	\N	\N	859.35	seconds	\N
7301	664	1130	\N	\N	53.07	seconds	\N
7281	422	1143	\N	\N	875.03	seconds	\N
7282	419	1143	\N	\N	914.13	seconds	\N
7283	633	1095	\N	\N	16.81	seconds	\N
7302	517	1131	\N	\N	53.25	seconds	\N
7284	566	1094	\N	\N	17.29	seconds	\N
7285	628	1095	\N	\N	17.46	seconds	\N
7286	636	1093	\N	\N	17.97	seconds	\N
7303	638	1130	\N	\N	53.66	seconds	\N
7323	1178	1184	\N	\N	274.00	inches	\N
7304	496	1131	\N	\N	55.75	seconds	\N
7305	380	1129	\N	\N	57.78	seconds	\N
7349	692	1179	\N	\N	776.00	inches	\N
7306	711	1130	\N	\N	58.71	seconds	\N
7324	406	1184	\N	\N	273.50	inches	\N
7307	679	1130	\N	\N	60.04	seconds	\N
7308	637	1130	\N	\N	60.38	seconds	\N
7339	356	1178	\N	\N	1018.00	inches	\N
7309	657	1130	\N	\N	63.71	seconds	\N
7325	710	1183	\N	\N	267.75	inches	\N
7310	356	1184	\N	\N	418.50	inches	\N
7311	440	1184	\N	\N	357.00	inches	\N
7312	503	1185	\N	\N	338.00	inches	\N
7326	692	1185	\N	\N	265.50	inches	\N
7313	523	1185	\N	\N	333.00	inches	\N
7314	461	1185	\N	\N	331.00	inches	\N
7315	448	1183	\N	\N	330.50	inches	\N
7327	334	1183	\N	\N	262.50	inches	\N
7316	500	1184	\N	\N	326.00	inches	\N
7317	650	1184	\N	\N	316.00	inches	\N
7340	677	1178	\N	\N	963.00	inches	\N
7328	667	1185	\N	\N	261.00	inches	\N
7329	390	1185	\N	\N	257.00	inches	\N
7356	667	1179	\N	\N	642.50	inches	\N
7330	811	1184	\N	\N	252.00	inches	\N
7341	440	1178	\N	\N	926.00	inches	\N
7331	357	1184	\N	\N	248.00	inches	\N
7332	443	1185	\N	\N	240.25	inches	\N
7350	500	1178	\N	\N	744.00	inches	\N
7333	731	1185	\N	\N	201.25	inches	\N
7342	601	1179	\N	\N	922.00	inches	\N
7334	503	1179	\N	\N	1136.00	inches	\N
7335	533	1178	\N	\N	1136.00	inches	\N
7336	461	1179	\N	\N	1063.00	inches	\N
7343	526	1179	\N	\N	912.00	inches	\N
7344	349	1179	\N	\N	874.00	inches	\N
7351	448	1177	\N	\N	730.00	inches	\N
7345	525	1179	\N	\N	865.00	inches	\N
7346	1178	1178	\N	\N	835.50	inches	\N
7347	725	1179	\N	\N	802.00	inches	\N
7352	646	1179	\N	\N	724.00	inches	\N
7348	710	1177	\N	\N	789.00	inches	\N
7357	334	1177	\N	\N	633.50	inches	\N
7353	406	1178	\N	\N	713.00	inches	\N
7354	670	1177	\N	\N	701.00	inches	\N
7363	350	1155	\N	\N	58.00	inches	\N
7355	650	1178	\N	\N	694.00	inches	\N
7358	1133	1177	\N	\N	630.00	inches	\N
7361	390	1179	\N	\N	520.00	inches	\N
7359	713	1178	\N	\N	567.00	inches	\N
7362	333	1155	\N	\N	62.00	inches	\N
7365	515	1153	\N	\N	54.00	inches	\N
7364	487	1154	\N	\N	56.00	inches	\N
7366	626	1155	\N	\N	54.00	inches	\N
7367	633	1155	\N	\N	54.00	inches	\N
7368	498	1154	\N	\N	50.00	inches	\N
7369	734	1153	\N	\N	50.00	inches	\N
7370	711	1154	\N	\N	50.00	inches	\N
7371	741	1155	\N	\N	50.00	inches	\N
7372	644	1154	\N	\N	48.00	inches	\N
7373	664	1154	\N	\N	48.00	inches	\N
7374	647	1160	\N	\N	158.00	inches	\N
7375	577	1161	\N	\N	146.00	inches	\N
7376	634	1161	\N	\N	123.00	inches	\N
7377	601	1161	\N	\N	108.00	inches	\N
7378	1136	1160	\N	\N	102.00	inches	\N
7379	501	1161	\N	\N	90.00	inches	\N
7380	384	1160	\N	\N	84.00	inches	\N
7381	342	1159	\N	\N	78.00	inches	\N
7382	647	1166	\N	\N	203.25	inches	\N
7383	627	1167	\N	\N	194.00	inches	\N
7384	487	1166	\N	\N	180.75	inches	\N
7432	726	1122	\N	\N	12.10	seconds	\N
7385	515	1165	\N	\N	178.00	inches	\N
7386	632	1167	\N	\N	178.00	inches	\N
7387	347	1165	\N	\N	176.00	inches	\N
7433	383	1122	\N	\N	12.14	seconds	\N
7388	566	1166	\N	\N	174.00	inches	\N
7389	755	1167	\N	\N	172.00	inches	\N
7463	391	1140	\N	\N	23.02	seconds	\N
7390	452	1167	\N	\N	172.00	inches	\N
7434	669	1122	\N	\N	12.14	seconds	\N
7391	498	1166	\N	\N	169.00	inches	\N
7392	429	1167	\N	\N	166.50	inches	\N
7393	322	1167	\N	\N	164.00	inches	\N
7435	435	1122	\N	\N	12.15	seconds	\N
7394	663	1165	\N	\N	158.50	inches	\N
7395	424	1165	\N	\N	158.00	inches	\N
7396	741	1167	\N	\N	156.50	inches	\N
7436	696	1121	\N	\N	12.19	seconds	\N
7397	720	1165	\N	\N	155.00	inches	\N
7398	349	1167	\N	\N	154.75	inches	\N
7464	482	1140	\N	\N	23.75	seconds	\N
7399	1141	1166	\N	\N	151.00	inches	\N
7437	605	1120	\N	\N	12.21	seconds	\N
7400	416	1165	\N	\N	149.50	inches	\N
7401	536	1167	\N	\N	148.00	inches	\N
7402	1132	1165	\N	\N	146.00	inches	\N
7438	798	1122	\N	\N	12.22	seconds	\N
7403	731	1167	\N	\N	141.50	inches	\N
7404	408	1166	\N	\N	136.50	inches	\N
7482	435	1140	\N	\N	25.41	seconds	\N
7405	634	1173	\N	\N	434.50	inches	\N
7439	551	1122	\N	\N	12.25	seconds	\N
7406	633	1173	\N	\N	394.00	inches	\N
7407	632	1173	\N	\N	385.75	inches	\N
7465	656	1140	\N	\N	24.15	seconds	\N
7408	515	1171	\N	\N	381.00	inches	\N
7440	689	1122	\N	\N	12.30	seconds	\N
7409	626	1173	\N	\N	370.00	inches	\N
7410	601	1173	\N	\N	367.50	inches	\N
7411	533	1172	\N	\N	359.50	inches	\N
7441	407	1122	\N	\N	12.34	seconds	\N
7412	322	1173	\N	\N	356.00	inches	\N
7413	755	1173	\N	\N	353.00	inches	\N
7414	708	1172	\N	\N	345.50	inches	\N
7442	530	1122	\N	\N	12.35	seconds	\N
7415	429	1173	\N	\N	343.00	inches	\N
7416	741	1173	\N	\N	334.75	inches	\N
7466	520	1140	\N	\N	24.19	seconds	\N
7417	536	1173	\N	\N	332.50	inches	\N
7443	552	1122	\N	\N	12.37	seconds	\N
7418	452	1173	\N	\N	329.00	inches	\N
7419	663	1171	\N	\N	322.00	inches	\N
7420	408	1172	\N	\N	301.00	inches	\N
7444	693	1120	\N	\N	12.40	seconds	\N
7421	710	1171	\N	\N	297.00	inches	\N
7422	745	1171	\N	\N	291.00	inches	\N
7505	567	1138	\N	\N	30.95	seconds	\N
7423	720	1171	\N	\N	290.75	inches	\N
7445	370	1121	\N	\N	12.41	seconds	\N
7424	597	1122	\N	\N	11.40	seconds	\N
7425	520	1122	\N	\N	11.55	seconds	\N
7467	689	1140	\N	\N	24.37	seconds	\N
7426	391	1122	\N	\N	11.59	seconds	\N
7446	438	1122	\N	\N	12.46	seconds	\N
7427	482	1122	\N	\N	11.78	seconds	\N
7428	386	1121	\N	\N	11.93	seconds	\N
7429	519	1121	\N	\N	12.01	seconds	\N
7447	582	1122	\N	\N	12.49	seconds	\N
7430	794	1120	\N	\N	12.06	seconds	\N
7431	715	1122	\N	\N	12.09	seconds	\N
7483	596	1138	\N	\N	25.55	seconds	\N
7448	728	1121	\N	\N	12.50	seconds	\N
7468	802	1138	\N	\N	24.50	seconds	\N
7449	427	1122	\N	\N	12.55	seconds	\N
7450	668	1121	\N	\N	12.59	seconds	\N
7451	398	1122	\N	\N	12.65	seconds	\N
7469	715	1140	\N	\N	24.57	seconds	\N
7452	309	1122	\N	\N	12.68	seconds	\N
7453	801	1121	\N	\N	12.70	seconds	\N
7494	668	1139	\N	\N	26.43	seconds	\N
7454	748	1121	\N	\N	12.71	seconds	\N
7470	726	1140	\N	\N	24.59	seconds	\N
7455	757	1122	\N	\N	12.78	seconds	\N
7456	758	1121	\N	\N	12.91	seconds	\N
7484	749	1139	\N	\N	25.57	seconds	\N
7457	580	1121	\N	\N	13.24	seconds	\N
7471	582	1140	\N	\N	24.65	seconds	\N
7458	1137	1120	\N	\N	13.30	seconds	\N
7459	575	1120	\N	\N	13.32	seconds	\N
7460	564	1121	\N	\N	13.36	seconds	\N
7472	386	1139	\N	\N	24.69	seconds	\N
7461	567	1120	\N	\N	14.79	seconds	\N
7462	597	1140	\N	\N	22.80	seconds	\N
7473	794	1138	\N	\N	24.77	seconds	\N
7485	748	1139	\N	\N	25.63	seconds	\N
7474	712	1140	\N	\N	24.80	seconds	\N
7475	605	1138	\N	\N	24.97	seconds	\N
7501	817	1140	\N	\N	27.40	seconds	\N
7476	438	1140	\N	\N	24.98	seconds	\N
7486	671	1140	\N	\N	25.85	seconds	\N
7477	383	1140	\N	\N	25.26	seconds	\N
7478	928	1140	\N	\N	25.26	seconds	\N
7495	757	1140	\N	\N	26.52	seconds	\N
7479	693	1138	\N	\N	25.28	seconds	\N
7487	439	1138	\N	\N	25.86	seconds	\N
7480	370	1139	\N	\N	25.31	seconds	\N
7481	340	1140	\N	\N	25.35	seconds	\N
7488	801	1139	\N	\N	26.00	seconds	\N
7489	495	1139	\N	\N	26.00	seconds	\N
7496	580	1139	\N	\N	26.72	seconds	\N
7490	779	1138	\N	\N	26.00	seconds	\N
7491	444	1140	\N	\N	26.24	seconds	\N
7492	758	1139	\N	\N	26.30	seconds	\N
7497	682	1139	\N	\N	26.73	seconds	\N
7493	398	1140	\N	\N	26.31	seconds	\N
7502	1137	1138	\N	\N	27.85	seconds	\N
7498	309	1140	\N	\N	26.99	seconds	\N
7499	575	1138	\N	\N	27.22	seconds	\N
7508	802	1114	\N	\N	53.31	seconds	\N
7500	563	1139	\N	\N	27.31	seconds	\N
7503	571	1138	\N	\N	27.87	seconds	\N
7506	597	1116	\N	\N	52.00	seconds	\N
7504	564	1139	\N	\N	27.91	seconds	\N
7507	753	1116	\N	\N	52.80	seconds	\N
7510	407	1116	\N	\N	54.59	seconds	\N
7509	608	1114	\N	\N	54.50	seconds	\N
7511	374	1114	\N	\N	54.91	seconds	\N
7512	582	1116	\N	\N	54.97	seconds	\N
7513	718	1114	\N	\N	55.20	seconds	\N
7514	618	1116	\N	\N	56.30	seconds	\N
7515	780	1114	\N	\N	56.42	seconds	\N
7516	727	1116	\N	\N	56.43	seconds	\N
7517	749	1115	\N	\N	56.56	seconds	\N
7518	712	1116	\N	\N	56.59	seconds	\N
7519	495	1115	\N	\N	56.69	seconds	\N
7520	381	1116	\N	\N	57.00	seconds	\N
7521	340	1116	\N	\N	57.14	seconds	\N
7522	768	1116	\N	\N	57.40	seconds	\N
7523	785	1114	\N	\N	58.46	seconds	\N
7524	748	1115	\N	\N	58.51	seconds	\N
7525	576	1115	\N	\N	58.54	seconds	\N
7526	444	1116	\N	\N	58.68	seconds	\N
7576	555	1091	\N	\N	280.96	seconds	\N
7527	671	1116	\N	\N	58.68	seconds	\N
7528	682	1115	\N	\N	59.77	seconds	\N
7529	425	1116	\N	\N	59.85	seconds	\N
7577	470	1091	\N	\N	284.23	seconds	\N
7530	758	1115	\N	\N	59.95	seconds	\N
7531	563	1115	\N	\N	60.19	seconds	\N
7607	490	1146	\N	\N	596.81	seconds	\N
7532	398	1116	\N	\N	61.64	seconds	\N
7578	815	1091	\N	\N	286.03	seconds	\N
7533	571	1114	\N	\N	61.76	seconds	\N
7534	430	1116	\N	\N	61.86	seconds	\N
7535	579	1114	\N	\N	62.00	seconds	\N
7579	514	1090	\N	\N	292.58	seconds	\N
7536	412	1116	\N	\N	62.02	seconds	\N
7537	817	1116	\N	\N	62.17	seconds	\N
7626	411	1145	\N	\N	691.80	seconds	\N
7538	761	1115	\N	\N	63.56	seconds	\N
7580	351	1090	\N	\N	294.91	seconds	\N
7539	756	1116	\N	\N	63.98	seconds	\N
7540	567	1114	\N	\N	66.95	seconds	\N
7608	516	1146	\N	\N	604.07	seconds	\N
7541	516	1128	\N	\N	117.76	seconds	\N
7581	308	1092	\N	\N	298.01	seconds	\N
7542	753	1128	\N	\N	120.11	seconds	\N
7543	625	1126	\N	\N	120.44	seconds	\N
7544	592	1127	\N	\N	123.17	seconds	\N
7582	560	1092	\N	\N	298.45	seconds	\N
7545	696	1127	\N	\N	124.50	seconds	\N
7546	810	1127	\N	\N	126.70	seconds	\N
7547	752	1127	\N	\N	127.97	seconds	\N
7583	543	1092	\N	\N	304.59	seconds	\N
7548	751	1128	\N	\N	132.15	seconds	\N
7549	749	1127	\N	\N	132.42	seconds	\N
7609	470	1145	\N	\N	604.50	seconds	\N
7550	514	1126	\N	\N	132.92	seconds	\N
7584	739	1092	\N	\N	305.59	seconds	\N
7551	615	1126	\N	\N	133.64	seconds	\N
7552	363	1128	\N	\N	133.68	seconds	\N
7553	815	1127	\N	\N	136.07	seconds	\N
7585	717	1090	\N	\N	305.81	seconds	\N
7554	754	1126	\N	\N	137.30	seconds	\N
7555	409	1128	\N	\N	137.77	seconds	\N
7649	727	1104	\N	\N	19.76	seconds	\N
7556	572	1128	\N	\N	137.90	seconds	\N
7586	744	1092	\N	\N	305.90	seconds	\N
7557	458	1128	\N	\N	138.82	seconds	\N
7558	542	1128	\N	\N	143.50	seconds	\N
7610	929	1146	\N	\N	619.53	seconds	\N
7559	449	1128	\N	\N	145.48	seconds	\N
7587	1135	1090	\N	\N	306.66	seconds	\N
7560	662	1128	\N	\N	147.39	seconds	\N
7561	413	1128	\N	\N	147.52	seconds	\N
7562	761	1127	\N	\N	150.34	seconds	\N
7588	547	1091	\N	\N	306.68	seconds	\N
7563	432	1128	\N	\N	150.93	seconds	\N
7564	563	1127	\N	\N	157.11	seconds	\N
7627	409	1146	\N	\N	695.42	seconds	\N
7565	746	1128	\N	\N	159.30	seconds	\N
7589	458	1092	\N	\N	309.69	seconds	\N
7566	436	1127	\N	\N	161.05	seconds	\N
7567	756	1128	\N	\N	99999999.00	seconds	\N
7568	516	1092	\N	\N	258.40	seconds	\N
7611	815	1145	\N	\N	636.80	seconds	\N
7569	592	1091	\N	\N	263.39	seconds	\N
7590	409	1092	\N	\N	311.85	seconds	\N
7570	696	1091	\N	\N	273.00	seconds	\N
7571	929	1092	\N	\N	273.02	seconds	\N
7572	752	1091	\N	\N	273.19	seconds	\N
7591	542	1092	\N	\N	313.20	seconds	\N
7573	753	1092	\N	\N	276.92	seconds	\N
7574	490	1092	\N	\N	277.73	seconds	\N
7575	810	1091	\N	\N	280.40	seconds	\N
7612	610	1146	\N	\N	637.30	seconds	\N
7592	662	1092	\N	\N	317.37	seconds	\N
7593	751	1092	\N	\N	319.67	seconds	\N
7638	504	1145	\N	\N	767.08	seconds	\N
7594	413	1092	\N	\N	323.22	seconds	\N
7613	787	1144	\N	\N	641.38	seconds	\N
7595	570	1092	\N	\N	323.32	seconds	\N
7596	750	1092	\N	\N	323.74	seconds	\N
7628	317	1146	\N	\N	696.55	seconds	\N
7597	411	1091	\N	\N	324.00	seconds	\N
7614	560	1146	\N	\N	642.34	seconds	\N
7598	432	1092	\N	\N	326.17	seconds	\N
7599	316	1091	\N	\N	326.72	seconds	\N
7600	754	1090	\N	\N	327.61	seconds	\N
7615	619	1144	\N	\N	653.90	seconds	\N
7601	761	1091	\N	\N	329.40	seconds	\N
7602	589	1090	\N	\N	329.89	seconds	\N
7603	765	1091	\N	\N	332.80	seconds	\N
7616	550	1144	\N	\N	655.50	seconds	\N
7604	756	1092	\N	\N	349.50	seconds	\N
7605	561	1090	\N	\N	387.56	seconds	\N
7629	316	1145	\N	\N	697.60	seconds	\N
7606	612	1146	\N	\N	592.00	seconds	\N
7617	559	1145	\N	\N	655.60	seconds	\N
7618	547	1145	\N	\N	657.90	seconds	\N
7645	813	1104	\N	\N	18.64	seconds	\N
7619	1135	1144	\N	\N	667.89	seconds	\N
7630	662	1146	\N	\N	703.06	seconds	\N
7620	739	1146	\N	\N	673.79	seconds	\N
7621	351	1144	\N	\N	675.32	seconds	\N
7639	561	1144	\N	\N	865.06	seconds	\N
7622	308	1146	\N	\N	675.48	seconds	\N
7631	337	1144	\N	\N	704.68	seconds	\N
7623	609	1144	\N	\N	678.80	seconds	\N
7624	717	1144	\N	\N	688.19	seconds	\N
7625	543	1146	\N	\N	689.93	seconds	\N
7632	413	1146	\N	\N	705.69	seconds	\N
7633	795	1144	\N	\N	706.01	seconds	\N
7640	378	1104	\N	\N	16.68	seconds	\N
7634	458	1146	\N	\N	713.48	seconds	\N
7635	306	1144	\N	\N	725.74	seconds	\N
7636	434	1145	\N	\N	728.81	seconds	\N
7641	491	1103	\N	\N	17.34	seconds	\N
7637	410	1144	\N	\N	765.27	seconds	\N
7646	784	1102	\N	\N	19.19	seconds	\N
7642	656	1104	\N	\N	17.36	seconds	\N
7643	607	1104	\N	\N	17.54	seconds	\N
7652	450	1102	\N	\N	25.39	seconds	\N
7644	527	1104	\N	\N	17.60	seconds	\N
7647	478	1103	\N	\N	19.37	seconds	\N
7650	799	1102	\N	\N	21.17	seconds	\N
7648	396	1104	\N	\N	19.73	seconds	\N
7653	421	1102	\N	\N	99999999.00	seconds	\N
7651	395	1103	\N	\N	22.94	seconds	\N
7654	656	1134	\N	\N	43.52	seconds	\N
7655	491	1133	\N	\N	44.20	seconds	\N
7656	378	1134	\N	\N	44.65	seconds	\N
7657	802	1132	\N	\N	45.07	seconds	\N
7658	381	1134	\N	\N	45.80	seconds	\N
7659	607	1134	\N	\N	45.82	seconds	\N
7660	727	1134	\N	\N	45.88	seconds	\N
7661	527	1134	\N	\N	46.00	seconds	\N
7662	570	1134	\N	\N	46.96	seconds	\N
7663	784	1132	\N	\N	47.80	seconds	\N
7664	396	1134	\N	\N	48.08	seconds	\N
7665	478	1133	\N	\N	48.72	seconds	\N
7666	421	1132	\N	\N	50.14	seconds	\N
7667	799	1132	\N	\N	51.31	seconds	\N
7668	813	1134	\N	\N	51.50	seconds	\N
7669	551	1134	\N	\N	52.85	seconds	\N
7670	395	1133	\N	\N	57.19	seconds	\N
7671	722	1134	\N	\N	59.59	seconds	\N
7672	450	1132	\N	\N	60.50	seconds	\N
7673	661	1188	\N	\N	609.00	inches	\N
7721	733	1158	\N	\N	70.00	inches	\N
7674	460	1187	\N	\N	557.00	inches	\N
7675	497	1188	\N	\N	497.00	inches	\N
7676	729	1188	\N	\N	481.25	inches	\N
7722	714	1158	\N	\N	68.00	inches	\N
7677	703	1188	\N	\N	471.50	inches	\N
7678	669	1188	\N	\N	471.00	inches	\N
7752	519	1169	\N	\N	230.00	inches	\N
7679	344	1188	\N	\N	463.50	inches	\N
7723	388	1158	\N	\N	67.00	inches	\N
7680	737	1188	\N	\N	461.50	inches	\N
7681	1148	1188	\N	\N	449.50	inches	\N
7682	512	1188	\N	\N	449.00	inches	\N
7724	509	1158	\N	\N	64.00	inches	\N
7683	431	1188	\N	\N	440.00	inches	\N
7684	321	1188	\N	\N	432.75	inches	\N
7685	792	1186	\N	\N	428.50	inches	\N
7725	630	1157	\N	\N	64.00	inches	\N
7686	791	1186	\N	\N	425.50	inches	\N
7687	552	1188	\N	\N	422.00	inches	\N
7753	491	1169	\N	\N	227.75	inches	\N
7688	327	1187	\N	\N	421.00	inches	\N
7726	332	1157	\N	\N	63.00	inches	\N
7689	532	1188	\N	\N	420.00	inches	\N
7690	506	1188	\N	\N	393.50	inches	\N
7691	397	1187	\N	\N	390.75	inches	\N
7727	345	1156	\N	\N	62.00	inches	\N
7692	618	1188	\N	\N	390.00	inches	\N
7693	585	1187	\N	\N	359.25	inches	\N
7771	721	1170	\N	\N	201.00	inches	\N
7694	758	1187	\N	\N	312.50	inches	\N
7728	507	1157	\N	\N	60.00	inches	\N
7695	1142	1186	\N	\N	311.00	inches	\N
7696	757	1188	\N	\N	290.00	inches	\N
7754	403	1169	\N	\N	224.00	inches	\N
7697	1145	1187	\N	\N	259.75	inches	\N
7729	451	1157	\N	\N	58.00	inches	\N
7698	661	1182	\N	\N	1782.00	inches	\N
7699	460	1181	\N	\N	1580.50	inches	\N
7700	497	1182	\N	\N	1509.00	inches	\N
7730	823	1158	\N	\N	58.00	inches	\N
7701	532	1182	\N	\N	1425.50	inches	\N
7702	737	1182	\N	\N	1413.00	inches	\N
7703	344	1182	\N	\N	1363.00	inches	\N
7731	570	1158	\N	\N	58.00	inches	\N
7704	792	1180	\N	\N	1191.00	inches	\N
7705	703	1182	\N	\N	1133.00	inches	\N
7755	689	1170	\N	\N	223.50	inches	\N
7706	512	1182	\N	\N	1130.00	inches	\N
7732	690	1157	\N	\N	58.00	inches	\N
7707	618	1182	\N	\N	1121.50	inches	\N
7708	431	1182	\N	\N	1118.00	inches	\N
7709	548	1181	\N	\N	1106.50	inches	\N
7733	693	1156	\N	\N	56.00	inches	\N
7710	397	1181	\N	\N	1092.00	inches	\N
7711	327	1181	\N	\N	1090.00	inches	\N
7794	690	1175	\N	\N	421.50	inches	\N
7712	506	1182	\N	\N	1082.00	inches	\N
7734	430	1158	\N	\N	52.00	inches	\N
7713	488	1181	\N	\N	1080.00	inches	\N
7714	791	1180	\N	\N	1061.75	inches	\N
7756	607	1170	\N	\N	221.50	inches	\N
7715	729	1182	\N	\N	1028.50	inches	\N
7735	376	1164	\N	\N	138.00	inches	\N
7716	700	1181	\N	\N	1000.00	inches	\N
7717	585	1181	\N	\N	991.50	inches	\N
7718	564	1181	\N	\N	883.00	inches	\N
7736	629	1164	\N	\N	138.00	inches	\N
7719	378	1158	\N	\N	72.00	inches	\N
7720	781	1156	\N	\N	70.00	inches	\N
7772	451	1169	\N	\N	198.75	inches	\N
7737	527	1164	\N	\N	126.00	inches	\N
7757	714	1170	\N	\N	218.00	inches	\N
7738	630	1163	\N	\N	126.00	inches	\N
7739	388	1164	\N	\N	120.00	inches	\N
7740	505	1164	\N	\N	120.00	inches	\N
7758	732	1170	\N	\N	218.00	inches	\N
7741	364	1162	\N	\N	108.00	inches	\N
7742	805	1162	\N	\N	108.00	inches	\N
7783	403	1175	\N	\N	475.75	inches	\N
7743	590	1163	\N	\N	108.00	inches	\N
7759	520	1170	\N	\N	216.00	inches	\N
7744	718	1162	\N	\N	108.00	inches	\N
7745	690	1163	\N	\N	102.00	inches	\N
7773	430	1170	\N	\N	194.25	inches	\N
7746	784	1162	\N	\N	97.00	inches	\N
7760	509	1170	\N	\N	216.00	inches	\N
7747	1166	1162	\N	\N	96.00	inches	\N
7748	325	1164	\N	\N	84.00	inches	\N
7749	733	1170	\N	\N	236.00	inches	\N
7761	383	1170	\N	\N	213.50	inches	\N
7750	715	1170	\N	\N	235.50	inches	\N
7751	378	1170	\N	\N	232.00	inches	\N
7762	386	1169	\N	\N	213.00	inches	\N
7774	690	1169	\N	\N	191.00	inches	\N
7763	332	1169	\N	\N	212.00	inches	\N
7764	530	1170	\N	\N	211.75	inches	\N
7790	332	1175	\N	\N	440.00	inches	\N
7765	478	1169	\N	\N	210.50	inches	\N
7775	412	1170	\N	\N	188.75	inches	\N
7766	661	1170	\N	\N	207.75	inches	\N
7767	781	1168	\N	\N	207.00	inches	\N
7784	509	1176	\N	\N	467.00	inches	\N
7768	824	1168	\N	\N	206.00	inches	\N
7776	575	1168	\N	\N	185.00	inches	\N
7769	778	1169	\N	\N	205.25	inches	\N
7770	507	1169	\N	\N	204.00	inches	\N
7777	1180	1170	\N	\N	182.50	inches	\N
7778	579	1168	\N	\N	179.00	inches	\N
7785	732	1176	\N	\N	467.00	inches	\N
7779	433	1169	\N	\N	178.00	inches	\N
7780	561	1168	\N	\N	157.00	inches	\N
7781	519	1175	\N	\N	501.00	inches	\N
7786	607	1176	\N	\N	466.00	inches	\N
7782	733	1176	\N	\N	478.75	inches	\N
7791	714	1176	\N	\N	433.00	inches	\N
7787	376	1176	\N	\N	463.00	inches	\N
7788	530	1176	\N	\N	453.50	inches	\N
7797	451	1175	\N	\N	395.25	inches	\N
7789	781	1174	\N	\N	442.00	inches	\N
7792	507	1175	\N	\N	430.00	inches	\N
7795	728	1175	\N	\N	412.00	inches	\N
7793	430	1176	\N	\N	424.00	inches	\N
7796	778	1175	\N	\N	406.50	inches	\N
7799	1180	1176	\N	\N	377.00	inches	\N
7798	412	1176	\N	\N	388.25	inches	\N
7800	433	1175	\N	\N	370.00	inches	\N
\.


--
-- Name: entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.entries_id_seq', 7800, true);


--
-- Data for Name: event_defs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_defs (code, name, etype, max_per_heat) FROM stdin;
60M	60 Meter	sprint	8
100M	100 Meter	sprint	8
200M	200 Meter	sprint	8
400M	400 Meter	sprint	8
600M	600 Meter	sprint	8
800M	800 Meter	sprint	12
1000M	1000 Meter	sprint	12
1500M	1500 Meter	distance	15
1600M	1600 Meter	distance	15
MILE	Mile	distance	15
3000M	3000 Meter	distance	18
3200M	3200 Meter	distance	18
5000M	5000 Meter	distance	24
10000M	10000 Meter	distance	30
3000S	3000 Meter Steeplechase	distance	18
4x100M	4x100 Meter Relay	relay	15
4x400M	4x400 Meter Relay	relay	15
DMR	Distance Medley Relay	relay	8
4x800M	4x800 Meter Relay	relay	8
55H	55 Meter Hurdles	hurdle	8
60H	60 Meter Hurdles	hurdle	8
65H	65 Meter Hurdles	hurdle	8
100H	100 Meter Hurdles (Girls Only)	hurdle	8
110H	110 Meter Hurdles (Boys Only)	hurdle	8
300H	300 Meter Hurdles	hurdle	8
400H	400 Meter Hurdles	hurdle	8
LJ	Long Jump	horzjump	13
TJ	Triple Jump	horzjump	13
DT	Discus Throw	throw	13
SP	Shot Put	throw	13
JT	Javelin Throw	throw	13
HT	Hammer Throw	throw	13
WT	Weight Throw	throw	13
HJ	High Jump	vertjump	20
PV	Pole Vault	vertjump	20
\.


--
-- Data for Name: event_ordering; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_ordering (id, meet_id, event_code, seq_num) FROM stdin;
1	1	4x100M	1
2	1	1600M	2
3	1	100H	3
4	1	110H	4
5	1	65H	5
6	1	400M	6
7	1	100M	7
8	1	800M	8
9	1	300H	9
10	1	200M	10
11	1	3200M	11
12	1	4x400M	12
13	1	HJ	13
14	1	PV	14
15	1	LJ	15
16	1	TJ	16
17	1	DT	17
18	1	SP	18
19	2	4x100M	1
20	2	1600M	2
21	2	100H	3
22	2	110H	4
23	2	65H	5
24	2	400M	6
25	2	100M	7
26	2	800M	8
27	2	300H	9
28	2	200M	10
29	2	3200M	11
30	2	4x400M	12
31	2	HJ	13
32	2	PV	14
33	2	LJ	15
34	2	TJ	16
35	2	DT	17
36	2	SP	18
37	3	4x100M	1
38	3	1600M	2
39	3	100H	3
40	3	110H	4
41	3	65H	5
42	3	400M	6
43	3	100M	7
44	3	800M	8
45	3	300H	9
46	3	200M	10
47	3	3200M	11
48	3	4x400M	12
49	3	HJ	13
50	3	PV	14
51	3	LJ	15
52	3	TJ	16
53	3	DT	17
54	3	SP	18
55	4	4x100M	1
56	4	1600M	2
57	4	100H	3
58	4	110H	4
59	4	65H	5
60	4	400M	6
61	4	100M	7
62	4	800M	8
63	4	300H	9
64	4	200M	10
65	4	3200M	11
66	4	4x400M	12
67	4	HJ	13
68	4	PV	14
69	4	LJ	15
70	4	TJ	16
71	4	DT	17
72	4	SP	18
73	5	4x100M	1
74	5	1600M	2
75	5	100H	3
76	5	110H	4
77	5	65H	5
78	5	400M	6
79	5	100M	7
80	5	800M	8
81	5	300H	9
82	5	200M	10
83	5	3200M	11
84	5	4x400M	12
85	5	HJ	13
86	5	PV	14
87	5	LJ	15
88	5	TJ	16
89	5	DT	17
90	5	SP	18
91	6	4x100M	1
92	6	1600M	2
93	6	100H	3
94	6	110H	4
95	6	65H	5
96	6	400M	6
97	6	100M	7
98	6	800M	8
99	6	300H	9
100	6	200M	10
101	6	3200M	11
102	6	4x400M	12
103	6	HJ	13
104	6	PV	14
105	6	LJ	15
106	6	TJ	16
107	6	DT	17
108	6	SP	18
109	7	4x100M	1
110	7	1600M	2
111	7	100H	3
112	7	110H	4
113	7	65H	5
114	7	400M	6
115	7	100M	7
116	7	800M	8
117	7	300H	9
118	7	200M	10
119	7	3200M	11
120	7	4x400M	12
121	7	HJ	13
122	7	PV	14
123	7	LJ	15
124	7	TJ	16
125	7	DT	17
126	7	SP	18
127	8	4x100M	1
128	8	1600M	2
129	8	100H	3
130	8	110H	4
131	8	65H	5
132	8	400M	6
133	8	100M	7
134	8	800M	8
135	8	300H	9
136	8	200M	10
137	8	3200M	11
138	8	4x400M	12
139	8	HJ	13
140	8	PV	14
141	8	LJ	15
142	8	TJ	16
143	8	DT	17
144	8	SP	18
145	9	4x100M	1
146	9	1600M	2
147	9	100H	3
148	9	110H	4
149	9	65H	5
150	9	400M	6
151	9	100M	7
152	9	800M	8
153	9	300H	9
154	9	200M	10
155	9	3200M	11
156	9	4x400M	12
157	9	HJ	13
158	9	PV	14
159	9	LJ	15
160	9	TJ	16
161	9	DT	17
162	9	SP	18
163	10	4x100M	1
164	10	1600M	2
165	10	100H	3
166	10	110H	4
167	10	65H	5
168	10	400M	6
169	10	100M	7
170	10	800M	8
171	10	300H	9
172	10	200M	10
173	10	3200M	11
174	10	4x400M	12
175	10	HJ	13
176	10	PV	14
177	10	LJ	15
178	10	TJ	16
179	10	DT	17
180	10	SP	18
181	11	4x100M	1
182	11	1600M	2
183	11	100H	3
184	11	110H	4
185	11	65H	5
186	11	400M	6
187	11	100M	7
188	11	800M	8
189	11	300H	9
190	11	200M	10
191	11	3200M	11
192	11	4x400M	12
193	11	HJ	13
194	11	PV	14
195	11	LJ	15
196	11	TJ	16
197	11	DT	17
198	11	SP	18
199	12	1600M	1
200	12	100H	2
\.


--
-- Name: event_ordering_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.event_ordering_id_seq', 200, true);


--
-- Data for Name: heats; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.heats (id, seq_num) FROM stdin;
\.


--
-- Name: heats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.heats_id_seq', 1, false);


--
-- Data for Name: meet_division_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meet_division_events (id, div_id, meet_id, event_code, seq_num, qualifying_mark, status, mde_notes, max_heats) FROM stdin;
1	4	1	4x100M	1	\N	Unassigned	\N	\N
2	5	1	4x100M	2	\N	Unassigned	\N	\N
3	6	1	4x100M	3	\N	Unassigned	\N	\N
4	1	1	4x100M	4	\N	Unassigned	\N	\N
5	2	1	4x100M	5	\N	Unassigned	\N	\N
6	3	1	4x100M	6	\N	Unassigned	\N	\N
7	4	1	1600M	7	\N	Unassigned	\N	\N
8	5	1	1600M	8	\N	Unassigned	\N	\N
9	6	1	1600M	9	\N	Unassigned	\N	\N
10	1	1	1600M	10	\N	Unassigned	\N	\N
11	2	1	1600M	11	\N	Unassigned	\N	\N
12	3	1	1600M	12	\N	Unassigned	\N	\N
13	4	1	100H	13	\N	Unassigned	\N	\N
14	5	1	100H	14	\N	Unassigned	\N	\N
15	6	1	100H	15	\N	Unassigned	\N	\N
16	1	1	100H	16	\N	Unassigned	\N	\N
17	2	1	100H	17	\N	Unassigned	\N	\N
18	3	1	100H	18	\N	Unassigned	\N	\N
19	4	1	110H	19	\N	Unassigned	\N	\N
20	5	1	110H	20	\N	Unassigned	\N	\N
21	6	1	110H	21	\N	Unassigned	\N	\N
22	1	1	110H	22	\N	Unassigned	\N	\N
23	2	1	110H	23	\N	Unassigned	\N	\N
24	3	1	110H	24	\N	Unassigned	\N	\N
25	4	1	65H	25	\N	Unassigned	\N	\N
26	5	1	65H	26	\N	Unassigned	\N	\N
27	6	1	65H	27	\N	Unassigned	\N	\N
28	1	1	65H	28	\N	Unassigned	\N	\N
29	2	1	65H	29	\N	Unassigned	\N	\N
30	3	1	65H	30	\N	Unassigned	\N	\N
31	4	1	400M	31	\N	Unassigned	\N	\N
32	5	1	400M	32	\N	Unassigned	\N	\N
33	6	1	400M	33	\N	Unassigned	\N	\N
34	1	1	400M	34	\N	Unassigned	\N	\N
35	2	1	400M	35	\N	Unassigned	\N	\N
36	3	1	400M	36	\N	Unassigned	\N	\N
37	4	1	100M	37	\N	Unassigned	\N	\N
38	5	1	100M	38	\N	Unassigned	\N	\N
39	6	1	100M	39	\N	Unassigned	\N	\N
40	1	1	100M	40	\N	Unassigned	\N	\N
41	2	1	100M	41	\N	Unassigned	\N	\N
42	3	1	100M	42	\N	Unassigned	\N	\N
43	4	1	800M	43	\N	Unassigned	\N	\N
44	5	1	800M	44	\N	Unassigned	\N	\N
45	6	1	800M	45	\N	Unassigned	\N	\N
46	1	1	800M	46	\N	Unassigned	\N	\N
47	2	1	800M	47	\N	Unassigned	\N	\N
48	3	1	800M	48	\N	Unassigned	\N	\N
49	4	1	300H	49	\N	Unassigned	\N	\N
50	5	1	300H	50	\N	Unassigned	\N	\N
51	6	1	300H	51	\N	Unassigned	\N	\N
52	1	1	300H	52	\N	Unassigned	\N	\N
53	2	1	300H	53	\N	Unassigned	\N	\N
54	3	1	300H	54	\N	Unassigned	\N	\N
55	4	1	200M	55	\N	Unassigned	\N	\N
56	5	1	200M	56	\N	Unassigned	\N	\N
57	6	1	200M	57	\N	Unassigned	\N	\N
58	1	1	200M	58	\N	Unassigned	\N	\N
59	2	1	200M	59	\N	Unassigned	\N	\N
60	3	1	200M	60	\N	Unassigned	\N	\N
61	4	1	3200M	61	\N	Unassigned	\N	\N
62	5	1	3200M	62	\N	Unassigned	\N	\N
63	6	1	3200M	63	\N	Unassigned	\N	\N
64	1	1	3200M	64	\N	Unassigned	\N	\N
65	2	1	3200M	65	\N	Unassigned	\N	\N
66	3	1	3200M	66	\N	Unassigned	\N	\N
67	4	1	4x400M	67	\N	Unassigned	\N	\N
68	5	1	4x400M	68	\N	Unassigned	\N	\N
69	6	1	4x400M	69	\N	Unassigned	\N	\N
70	1	1	4x400M	70	\N	Unassigned	\N	\N
71	2	1	4x400M	71	\N	Unassigned	\N	\N
72	3	1	4x400M	72	\N	Unassigned	\N	\N
73	4	1	HJ	73	\N	Unassigned	\N	\N
74	5	1	HJ	74	\N	Unassigned	\N	\N
75	6	1	HJ	75	\N	Unassigned	\N	\N
76	1	1	HJ	76	\N	Unassigned	\N	\N
77	2	1	HJ	77	\N	Unassigned	\N	\N
78	3	1	HJ	78	\N	Unassigned	\N	\N
79	4	1	PV	79	\N	Unassigned	\N	\N
80	5	1	PV	80	\N	Unassigned	\N	\N
81	6	1	PV	81	\N	Unassigned	\N	\N
82	1	1	PV	82	\N	Unassigned	\N	\N
83	2	1	PV	83	\N	Unassigned	\N	\N
84	3	1	PV	84	\N	Unassigned	\N	\N
85	4	1	LJ	85	\N	Unassigned	\N	\N
86	5	1	LJ	86	\N	Unassigned	\N	\N
87	6	1	LJ	87	\N	Unassigned	\N	\N
88	1	1	LJ	88	\N	Unassigned	\N	\N
89	2	1	LJ	89	\N	Unassigned	\N	\N
90	3	1	LJ	90	\N	Unassigned	\N	\N
91	4	1	TJ	91	\N	Unassigned	\N	\N
92	5	1	TJ	92	\N	Unassigned	\N	\N
93	6	1	TJ	93	\N	Unassigned	\N	\N
94	1	1	TJ	94	\N	Unassigned	\N	\N
95	2	1	TJ	95	\N	Unassigned	\N	\N
96	3	1	TJ	96	\N	Unassigned	\N	\N
97	4	1	DT	97	\N	Unassigned	\N	\N
98	5	1	DT	98	\N	Unassigned	\N	\N
99	6	1	DT	99	\N	Unassigned	\N	\N
100	1	1	DT	100	\N	Unassigned	\N	\N
101	2	1	DT	101	\N	Unassigned	\N	\N
102	3	1	DT	102	\N	Unassigned	\N	\N
103	4	1	SP	103	\N	Unassigned	\N	\N
104	5	1	SP	104	\N	Unassigned	\N	\N
105	6	1	SP	105	\N	Unassigned	\N	\N
106	1	1	SP	106	\N	Unassigned	\N	\N
107	2	1	SP	107	\N	Unassigned	\N	\N
108	3	1	SP	108	\N	Unassigned	\N	\N
109	4	2	4x100M	1	\N	Unassigned	\N	\N
110	5	2	4x100M	2	\N	Unassigned	\N	\N
111	6	2	4x100M	3	\N	Unassigned	\N	\N
112	1	2	4x100M	4	\N	Unassigned	\N	\N
113	2	2	4x100M	5	\N	Unassigned	\N	\N
114	3	2	4x100M	6	\N	Unassigned	\N	\N
115	4	2	1600M	7	\N	Unassigned	\N	\N
116	5	2	1600M	8	\N	Unassigned	\N	\N
117	6	2	1600M	9	\N	Unassigned	\N	\N
118	1	2	1600M	10	\N	Unassigned	\N	\N
119	2	2	1600M	11	\N	Unassigned	\N	\N
120	3	2	1600M	12	\N	Unassigned	\N	\N
121	4	2	100H	13	\N	Unassigned	\N	\N
122	5	2	100H	14	\N	Unassigned	\N	\N
123	6	2	100H	15	\N	Unassigned	\N	\N
124	1	2	100H	16	\N	Unassigned	\N	\N
125	2	2	100H	17	\N	Unassigned	\N	\N
126	3	2	100H	18	\N	Unassigned	\N	\N
127	4	2	110H	19	\N	Unassigned	\N	\N
128	5	2	110H	20	\N	Unassigned	\N	\N
129	6	2	110H	21	\N	Unassigned	\N	\N
130	1	2	110H	22	\N	Unassigned	\N	\N
131	2	2	110H	23	\N	Unassigned	\N	\N
132	3	2	110H	24	\N	Unassigned	\N	\N
133	4	2	65H	25	\N	Unassigned	\N	\N
134	5	2	65H	26	\N	Unassigned	\N	\N
135	6	2	65H	27	\N	Unassigned	\N	\N
136	1	2	65H	28	\N	Unassigned	\N	\N
137	2	2	65H	29	\N	Unassigned	\N	\N
138	3	2	65H	30	\N	Unassigned	\N	\N
139	4	2	400M	31	\N	Unassigned	\N	\N
140	5	2	400M	32	\N	Unassigned	\N	\N
141	6	2	400M	33	\N	Unassigned	\N	\N
142	1	2	400M	34	\N	Unassigned	\N	\N
143	2	2	400M	35	\N	Unassigned	\N	\N
144	3	2	400M	36	\N	Unassigned	\N	\N
145	4	2	100M	37	\N	Unassigned	\N	\N
146	5	2	100M	38	\N	Unassigned	\N	\N
147	6	2	100M	39	\N	Unassigned	\N	\N
148	1	2	100M	40	\N	Unassigned	\N	\N
149	2	2	100M	41	\N	Unassigned	\N	\N
150	3	2	100M	42	\N	Unassigned	\N	\N
151	4	2	800M	43	\N	Unassigned	\N	\N
152	5	2	800M	44	\N	Unassigned	\N	\N
153	6	2	800M	45	\N	Unassigned	\N	\N
154	1	2	800M	46	\N	Unassigned	\N	\N
155	2	2	800M	47	\N	Unassigned	\N	\N
156	3	2	800M	48	\N	Unassigned	\N	\N
157	4	2	300H	49	\N	Unassigned	\N	\N
158	5	2	300H	50	\N	Unassigned	\N	\N
159	6	2	300H	51	\N	Unassigned	\N	\N
160	1	2	300H	52	\N	Unassigned	\N	\N
161	2	2	300H	53	\N	Unassigned	\N	\N
162	3	2	300H	54	\N	Unassigned	\N	\N
163	4	2	200M	55	\N	Unassigned	\N	\N
164	5	2	200M	56	\N	Unassigned	\N	\N
165	6	2	200M	57	\N	Unassigned	\N	\N
166	1	2	200M	58	\N	Unassigned	\N	\N
167	2	2	200M	59	\N	Unassigned	\N	\N
168	3	2	200M	60	\N	Unassigned	\N	\N
169	4	2	3200M	61	\N	Unassigned	\N	\N
170	5	2	3200M	62	\N	Unassigned	\N	\N
171	6	2	3200M	63	\N	Unassigned	\N	\N
172	1	2	3200M	64	\N	Unassigned	\N	\N
173	2	2	3200M	65	\N	Unassigned	\N	\N
174	3	2	3200M	66	\N	Unassigned	\N	\N
175	4	2	4x400M	67	\N	Unassigned	\N	\N
176	5	2	4x400M	68	\N	Unassigned	\N	\N
177	6	2	4x400M	69	\N	Unassigned	\N	\N
178	1	2	4x400M	70	\N	Unassigned	\N	\N
179	2	2	4x400M	71	\N	Unassigned	\N	\N
180	3	2	4x400M	72	\N	Unassigned	\N	\N
181	4	2	HJ	73	\N	Unassigned	\N	\N
182	5	2	HJ	74	\N	Unassigned	\N	\N
183	6	2	HJ	75	\N	Unassigned	\N	\N
184	1	2	HJ	76	\N	Unassigned	\N	\N
185	2	2	HJ	77	\N	Unassigned	\N	\N
186	3	2	HJ	78	\N	Unassigned	\N	\N
187	4	2	PV	79	\N	Unassigned	\N	\N
188	5	2	PV	80	\N	Unassigned	\N	\N
189	6	2	PV	81	\N	Unassigned	\N	\N
190	1	2	PV	82	\N	Unassigned	\N	\N
191	2	2	PV	83	\N	Unassigned	\N	\N
192	3	2	PV	84	\N	Unassigned	\N	\N
193	4	2	LJ	85	\N	Unassigned	\N	\N
194	5	2	LJ	86	\N	Unassigned	\N	\N
195	6	2	LJ	87	\N	Unassigned	\N	\N
196	1	2	LJ	88	\N	Unassigned	\N	\N
197	2	2	LJ	89	\N	Unassigned	\N	\N
198	3	2	LJ	90	\N	Unassigned	\N	\N
199	4	2	TJ	91	\N	Unassigned	\N	\N
200	5	2	TJ	92	\N	Unassigned	\N	\N
201	6	2	TJ	93	\N	Unassigned	\N	\N
202	1	2	TJ	94	\N	Unassigned	\N	\N
203	2	2	TJ	95	\N	Unassigned	\N	\N
204	3	2	TJ	96	\N	Unassigned	\N	\N
205	4	2	DT	97	\N	Unassigned	\N	\N
206	5	2	DT	98	\N	Unassigned	\N	\N
207	6	2	DT	99	\N	Unassigned	\N	\N
208	1	2	DT	100	\N	Unassigned	\N	\N
209	2	2	DT	101	\N	Unassigned	\N	\N
210	3	2	DT	102	\N	Unassigned	\N	\N
211	4	2	SP	103	\N	Unassigned	\N	\N
212	5	2	SP	104	\N	Unassigned	\N	\N
213	6	2	SP	105	\N	Unassigned	\N	\N
214	1	2	SP	106	\N	Unassigned	\N	\N
215	2	2	SP	107	\N	Unassigned	\N	\N
216	3	2	SP	108	\N	Unassigned	\N	\N
217	1	3	4x100M	1	\N	Unassigned	\N	\N
218	2	3	4x100M	2	\N	Unassigned	\N	\N
219	3	3	4x100M	3	\N	Unassigned	\N	\N
220	4	3	4x100M	4	\N	Unassigned	\N	\N
221	5	3	4x100M	5	\N	Unassigned	\N	\N
222	6	3	4x100M	6	\N	Unassigned	\N	\N
223	1	3	1600M	7	\N	Unassigned	\N	\N
224	2	3	1600M	8	\N	Unassigned	\N	\N
225	3	3	1600M	9	\N	Unassigned	\N	\N
226	4	3	1600M	10	\N	Unassigned	\N	\N
227	5	3	1600M	11	\N	Unassigned	\N	\N
228	6	3	1600M	12	\N	Unassigned	\N	\N
229	1	3	100H	13	\N	Unassigned	\N	\N
230	2	3	100H	14	\N	Unassigned	\N	\N
231	3	3	100H	15	\N	Unassigned	\N	\N
232	4	3	100H	16	\N	Unassigned	\N	\N
233	5	3	100H	17	\N	Unassigned	\N	\N
234	6	3	100H	18	\N	Unassigned	\N	\N
235	1	3	110H	19	\N	Unassigned	\N	\N
236	2	3	110H	20	\N	Unassigned	\N	\N
237	3	3	110H	21	\N	Unassigned	\N	\N
238	4	3	110H	22	\N	Unassigned	\N	\N
239	5	3	110H	23	\N	Unassigned	\N	\N
240	6	3	110H	24	\N	Unassigned	\N	\N
241	1	3	65H	25	\N	Unassigned	\N	\N
242	2	3	65H	26	\N	Unassigned	\N	\N
243	3	3	65H	27	\N	Unassigned	\N	\N
244	4	3	65H	28	\N	Unassigned	\N	\N
245	5	3	65H	29	\N	Unassigned	\N	\N
246	6	3	65H	30	\N	Unassigned	\N	\N
247	1	3	400M	31	\N	Unassigned	\N	\N
248	2	3	400M	32	\N	Unassigned	\N	\N
249	3	3	400M	33	\N	Unassigned	\N	\N
250	4	3	400M	34	\N	Unassigned	\N	\N
251	5	3	400M	35	\N	Unassigned	\N	\N
252	6	3	400M	36	\N	Unassigned	\N	\N
253	1	3	100M	37	\N	Unassigned	\N	\N
254	2	3	100M	38	\N	Unassigned	\N	\N
255	3	3	100M	39	\N	Unassigned	\N	\N
256	4	3	100M	40	\N	Unassigned	\N	\N
257	5	3	100M	41	\N	Unassigned	\N	\N
258	6	3	100M	42	\N	Unassigned	\N	\N
259	1	3	800M	43	\N	Unassigned	\N	\N
260	2	3	800M	44	\N	Unassigned	\N	\N
261	3	3	800M	45	\N	Unassigned	\N	\N
262	4	3	800M	46	\N	Unassigned	\N	\N
263	5	3	800M	47	\N	Unassigned	\N	\N
264	6	3	800M	48	\N	Unassigned	\N	\N
265	1	3	300H	49	\N	Unassigned	\N	\N
266	2	3	300H	50	\N	Unassigned	\N	\N
267	3	3	300H	51	\N	Unassigned	\N	\N
268	4	3	300H	52	\N	Unassigned	\N	\N
269	5	3	300H	53	\N	Unassigned	\N	\N
270	6	3	300H	54	\N	Unassigned	\N	\N
271	1	3	200M	55	\N	Unassigned	\N	\N
272	2	3	200M	56	\N	Unassigned	\N	\N
273	3	3	200M	57	\N	Unassigned	\N	\N
274	4	3	200M	58	\N	Unassigned	\N	\N
275	5	3	200M	59	\N	Unassigned	\N	\N
276	6	3	200M	60	\N	Unassigned	\N	\N
277	1	3	3200M	61	\N	Unassigned	\N	\N
278	2	3	3200M	62	\N	Unassigned	\N	\N
279	3	3	3200M	63	\N	Unassigned	\N	\N
280	4	3	3200M	64	\N	Unassigned	\N	\N
281	5	3	3200M	65	\N	Unassigned	\N	\N
282	6	3	3200M	66	\N	Unassigned	\N	\N
283	1	3	4x400M	67	\N	Unassigned	\N	\N
284	2	3	4x400M	68	\N	Unassigned	\N	\N
285	3	3	4x400M	69	\N	Unassigned	\N	\N
286	4	3	4x400M	70	\N	Unassigned	\N	\N
287	5	3	4x400M	71	\N	Unassigned	\N	\N
288	6	3	4x400M	72	\N	Unassigned	\N	\N
289	1	3	HJ	73	\N	Unassigned	\N	\N
290	2	3	HJ	74	\N	Unassigned	\N	\N
291	3	3	HJ	75	\N	Unassigned	\N	\N
292	4	3	HJ	76	\N	Unassigned	\N	\N
293	5	3	HJ	77	\N	Unassigned	\N	\N
294	6	3	HJ	78	\N	Unassigned	\N	\N
295	1	3	PV	79	\N	Unassigned	\N	\N
296	2	3	PV	80	\N	Unassigned	\N	\N
297	3	3	PV	81	\N	Unassigned	\N	\N
298	4	3	PV	82	\N	Unassigned	\N	\N
299	5	3	PV	83	\N	Unassigned	\N	\N
300	6	3	PV	84	\N	Unassigned	\N	\N
301	1	3	LJ	85	\N	Unassigned	\N	\N
302	2	3	LJ	86	\N	Unassigned	\N	\N
303	3	3	LJ	87	\N	Unassigned	\N	\N
304	4	3	LJ	88	\N	Unassigned	\N	\N
305	5	3	LJ	89	\N	Unassigned	\N	\N
306	6	3	LJ	90	\N	Unassigned	\N	\N
307	1	3	TJ	91	\N	Unassigned	\N	\N
308	2	3	TJ	92	\N	Unassigned	\N	\N
309	3	3	TJ	93	\N	Unassigned	\N	\N
310	4	3	TJ	94	\N	Unassigned	\N	\N
311	5	3	TJ	95	\N	Unassigned	\N	\N
312	6	3	TJ	96	\N	Unassigned	\N	\N
313	1	3	DT	97	\N	Unassigned	\N	\N
314	2	3	DT	98	\N	Unassigned	\N	\N
315	3	3	DT	99	\N	Unassigned	\N	\N
316	4	3	DT	100	\N	Unassigned	\N	\N
317	5	3	DT	101	\N	Unassigned	\N	\N
318	6	3	DT	102	\N	Unassigned	\N	\N
319	1	3	SP	103	\N	Unassigned	\N	\N
320	2	3	SP	104	\N	Unassigned	\N	\N
321	3	3	SP	105	\N	Unassigned	\N	\N
322	4	3	SP	106	\N	Unassigned	\N	\N
323	5	3	SP	107	\N	Unassigned	\N	\N
324	6	3	SP	108	\N	Unassigned	\N	\N
325	6	4	4x100M	1	\N	Unassigned	\N	\N
326	5	4	4x100M	2	\N	Unassigned	\N	\N
327	4	4	4x100M	3	\N	Unassigned	\N	\N
328	3	4	4x100M	4	\N	Unassigned	\N	\N
329	2	4	4x100M	5	\N	Unassigned	\N	\N
330	1	4	4x100M	6	\N	Unassigned	\N	\N
331	6	4	1600M	7	\N	Unassigned	\N	\N
332	5	4	1600M	8	\N	Unassigned	\N	\N
333	4	4	1600M	9	\N	Unassigned	\N	\N
334	3	4	1600M	10	\N	Unassigned	\N	\N
335	2	4	1600M	11	\N	Unassigned	\N	\N
336	1	4	1600M	12	\N	Unassigned	\N	\N
337	6	4	100H	13	\N	Unassigned	\N	\N
338	5	4	100H	14	\N	Unassigned	\N	\N
339	4	4	100H	15	\N	Unassigned	\N	\N
340	3	4	100H	16	\N	Unassigned	\N	\N
341	2	4	100H	17	\N	Unassigned	\N	\N
342	1	4	100H	18	\N	Unassigned	\N	\N
343	6	4	110H	19	\N	Unassigned	\N	\N
344	5	4	110H	20	\N	Unassigned	\N	\N
345	4	4	110H	21	\N	Unassigned	\N	\N
346	3	4	110H	22	\N	Unassigned	\N	\N
347	2	4	110H	23	\N	Unassigned	\N	\N
348	1	4	110H	24	\N	Unassigned	\N	\N
349	6	4	65H	25	\N	Unassigned	\N	\N
350	5	4	65H	26	\N	Unassigned	\N	\N
351	4	4	65H	27	\N	Unassigned	\N	\N
352	3	4	65H	28	\N	Unassigned	\N	\N
353	2	4	65H	29	\N	Unassigned	\N	\N
354	1	4	65H	30	\N	Unassigned	\N	\N
355	6	4	400M	31	\N	Unassigned	\N	\N
356	5	4	400M	32	\N	Unassigned	\N	\N
357	4	4	400M	33	\N	Unassigned	\N	\N
358	3	4	400M	34	\N	Unassigned	\N	\N
359	2	4	400M	35	\N	Unassigned	\N	\N
360	1	4	400M	36	\N	Unassigned	\N	\N
361	6	4	100M	37	\N	Unassigned	\N	\N
362	5	4	100M	38	\N	Unassigned	\N	\N
363	4	4	100M	39	\N	Unassigned	\N	\N
364	3	4	100M	40	\N	Unassigned	\N	\N
365	2	4	100M	41	\N	Unassigned	\N	\N
366	1	4	100M	42	\N	Unassigned	\N	\N
367	6	4	800M	43	\N	Unassigned	\N	\N
368	5	4	800M	44	\N	Unassigned	\N	\N
369	4	4	800M	45	\N	Unassigned	\N	\N
370	3	4	800M	46	\N	Unassigned	\N	\N
371	2	4	800M	47	\N	Unassigned	\N	\N
372	1	4	800M	48	\N	Unassigned	\N	\N
373	6	4	300H	49	\N	Unassigned	\N	\N
374	5	4	300H	50	\N	Unassigned	\N	\N
375	4	4	300H	51	\N	Unassigned	\N	\N
376	3	4	300H	52	\N	Unassigned	\N	\N
377	2	4	300H	53	\N	Unassigned	\N	\N
378	1	4	300H	54	\N	Unassigned	\N	\N
379	6	4	200M	55	\N	Unassigned	\N	\N
380	5	4	200M	56	\N	Unassigned	\N	\N
381	4	4	200M	57	\N	Unassigned	\N	\N
382	3	4	200M	58	\N	Unassigned	\N	\N
383	2	4	200M	59	\N	Unassigned	\N	\N
384	1	4	200M	60	\N	Unassigned	\N	\N
385	6	4	3200M	61	\N	Unassigned	\N	\N
386	5	4	3200M	62	\N	Unassigned	\N	\N
387	4	4	3200M	63	\N	Unassigned	\N	\N
388	3	4	3200M	64	\N	Unassigned	\N	\N
389	2	4	3200M	65	\N	Unassigned	\N	\N
390	1	4	3200M	66	\N	Unassigned	\N	\N
391	6	4	4x400M	67	\N	Unassigned	\N	\N
392	5	4	4x400M	68	\N	Unassigned	\N	\N
393	4	4	4x400M	69	\N	Unassigned	\N	\N
394	3	4	4x400M	70	\N	Unassigned	\N	\N
395	2	4	4x400M	71	\N	Unassigned	\N	\N
396	1	4	4x400M	72	\N	Unassigned	\N	\N
397	6	4	HJ	73	\N	Unassigned	\N	\N
398	5	4	HJ	74	\N	Unassigned	\N	\N
399	4	4	HJ	75	\N	Unassigned	\N	\N
400	3	4	HJ	76	\N	Unassigned	\N	\N
401	2	4	HJ	77	\N	Unassigned	\N	\N
402	1	4	HJ	78	\N	Unassigned	\N	\N
403	6	4	PV	79	\N	Unassigned	\N	\N
404	5	4	PV	80	\N	Unassigned	\N	\N
405	4	4	PV	81	\N	Unassigned	\N	\N
406	3	4	PV	82	\N	Unassigned	\N	\N
407	2	4	PV	83	\N	Unassigned	\N	\N
408	1	4	PV	84	\N	Unassigned	\N	\N
409	6	4	LJ	85	\N	Unassigned	\N	\N
410	5	4	LJ	86	\N	Unassigned	\N	\N
411	4	4	LJ	87	\N	Unassigned	\N	\N
412	3	4	LJ	88	\N	Unassigned	\N	\N
413	2	4	LJ	89	\N	Unassigned	\N	\N
414	1	4	LJ	90	\N	Unassigned	\N	\N
415	6	4	TJ	91	\N	Unassigned	\N	\N
416	5	4	TJ	92	\N	Unassigned	\N	\N
417	4	4	TJ	93	\N	Unassigned	\N	\N
418	3	4	TJ	94	\N	Unassigned	\N	\N
419	2	4	TJ	95	\N	Unassigned	\N	\N
420	1	4	TJ	96	\N	Unassigned	\N	\N
421	6	4	DT	97	\N	Unassigned	\N	\N
422	5	4	DT	98	\N	Unassigned	\N	\N
423	4	4	DT	99	\N	Unassigned	\N	\N
424	3	4	DT	100	\N	Unassigned	\N	\N
425	2	4	DT	101	\N	Unassigned	\N	\N
426	1	4	DT	102	\N	Unassigned	\N	\N
427	6	4	SP	103	\N	Unassigned	\N	\N
428	5	4	SP	104	\N	Unassigned	\N	\N
429	4	4	SP	105	\N	Unassigned	\N	\N
430	3	4	SP	106	\N	Unassigned	\N	\N
431	2	4	SP	107	\N	Unassigned	\N	\N
432	1	4	SP	108	\N	Unassigned	\N	\N
433	3	5	4x100M	1	\N	Unassigned	\N	\N
434	2	5	4x100M	2	\N	Unassigned	\N	\N
435	1	5	4x100M	3	\N	Unassigned	\N	\N
436	6	5	4x100M	4	\N	Unassigned	\N	\N
437	5	5	4x100M	5	\N	Unassigned	\N	\N
438	4	5	4x100M	6	\N	Unassigned	\N	\N
439	3	5	1600M	7	\N	Unassigned	\N	\N
440	2	5	1600M	8	\N	Unassigned	\N	\N
441	1	5	1600M	9	\N	Unassigned	\N	\N
442	6	5	1600M	10	\N	Unassigned	\N	\N
443	5	5	1600M	11	\N	Unassigned	\N	\N
444	4	5	1600M	12	\N	Unassigned	\N	\N
445	3	5	100H	13	\N	Unassigned	\N	\N
446	2	5	100H	14	\N	Unassigned	\N	\N
447	1	5	100H	15	\N	Unassigned	\N	\N
448	6	5	100H	16	\N	Unassigned	\N	\N
449	5	5	100H	17	\N	Unassigned	\N	\N
450	4	5	100H	18	\N	Unassigned	\N	\N
451	3	5	110H	19	\N	Unassigned	\N	\N
452	2	5	110H	20	\N	Unassigned	\N	\N
453	1	5	110H	21	\N	Unassigned	\N	\N
454	6	5	110H	22	\N	Unassigned	\N	\N
455	5	5	110H	23	\N	Unassigned	\N	\N
456	4	5	110H	24	\N	Unassigned	\N	\N
457	3	5	65H	25	\N	Unassigned	\N	\N
458	2	5	65H	26	\N	Unassigned	\N	\N
459	1	5	65H	27	\N	Unassigned	\N	\N
460	6	5	65H	28	\N	Unassigned	\N	\N
461	5	5	65H	29	\N	Unassigned	\N	\N
462	4	5	65H	30	\N	Unassigned	\N	\N
463	3	5	400M	31	\N	Unassigned	\N	\N
464	2	5	400M	32	\N	Unassigned	\N	\N
465	1	5	400M	33	\N	Unassigned	\N	\N
466	6	5	400M	34	\N	Unassigned	\N	\N
467	5	5	400M	35	\N	Unassigned	\N	\N
468	4	5	400M	36	\N	Unassigned	\N	\N
469	3	5	100M	37	\N	Unassigned	\N	\N
470	2	5	100M	38	\N	Unassigned	\N	\N
471	1	5	100M	39	\N	Unassigned	\N	\N
472	6	5	100M	40	\N	Unassigned	\N	\N
473	5	5	100M	41	\N	Unassigned	\N	\N
474	4	5	100M	42	\N	Unassigned	\N	\N
475	3	5	800M	43	\N	Unassigned	\N	\N
476	2	5	800M	44	\N	Unassigned	\N	\N
477	1	5	800M	45	\N	Unassigned	\N	\N
478	6	5	800M	46	\N	Unassigned	\N	\N
479	5	5	800M	47	\N	Unassigned	\N	\N
480	4	5	800M	48	\N	Unassigned	\N	\N
481	3	5	300H	49	\N	Unassigned	\N	\N
482	2	5	300H	50	\N	Unassigned	\N	\N
483	1	5	300H	51	\N	Unassigned	\N	\N
484	6	5	300H	52	\N	Unassigned	\N	\N
485	5	5	300H	53	\N	Unassigned	\N	\N
486	4	5	300H	54	\N	Unassigned	\N	\N
487	3	5	200M	55	\N	Unassigned	\N	\N
488	2	5	200M	56	\N	Unassigned	\N	\N
489	1	5	200M	57	\N	Unassigned	\N	\N
490	6	5	200M	58	\N	Unassigned	\N	\N
491	5	5	200M	59	\N	Unassigned	\N	\N
492	4	5	200M	60	\N	Unassigned	\N	\N
493	3	5	3200M	61	\N	Unassigned	\N	\N
494	2	5	3200M	62	\N	Unassigned	\N	\N
495	1	5	3200M	63	\N	Unassigned	\N	\N
496	6	5	3200M	64	\N	Unassigned	\N	\N
497	5	5	3200M	65	\N	Unassigned	\N	\N
498	4	5	3200M	66	\N	Unassigned	\N	\N
499	3	5	4x400M	67	\N	Unassigned	\N	\N
500	2	5	4x400M	68	\N	Unassigned	\N	\N
501	1	5	4x400M	69	\N	Unassigned	\N	\N
502	6	5	4x400M	70	\N	Unassigned	\N	\N
503	5	5	4x400M	71	\N	Unassigned	\N	\N
504	4	5	4x400M	72	\N	Unassigned	\N	\N
505	3	5	HJ	73	\N	Unassigned	\N	\N
506	2	5	HJ	74	\N	Unassigned	\N	\N
507	1	5	HJ	75	\N	Unassigned	\N	\N
508	6	5	HJ	76	\N	Unassigned	\N	\N
509	5	5	HJ	77	\N	Unassigned	\N	\N
510	4	5	HJ	78	\N	Unassigned	\N	\N
511	3	5	PV	79	\N	Unassigned	\N	\N
512	2	5	PV	80	\N	Unassigned	\N	\N
513	1	5	PV	81	\N	Unassigned	\N	\N
514	6	5	PV	82	\N	Unassigned	\N	\N
515	5	5	PV	83	\N	Unassigned	\N	\N
516	4	5	PV	84	\N	Unassigned	\N	\N
517	3	5	LJ	85	\N	Unassigned	\N	\N
518	2	5	LJ	86	\N	Unassigned	\N	\N
519	1	5	LJ	87	\N	Unassigned	\N	\N
520	6	5	LJ	88	\N	Unassigned	\N	\N
521	5	5	LJ	89	\N	Unassigned	\N	\N
522	4	5	LJ	90	\N	Unassigned	\N	\N
523	3	5	TJ	91	\N	Unassigned	\N	\N
524	2	5	TJ	92	\N	Unassigned	\N	\N
525	1	5	TJ	93	\N	Unassigned	\N	\N
526	6	5	TJ	94	\N	Unassigned	\N	\N
527	5	5	TJ	95	\N	Unassigned	\N	\N
528	4	5	TJ	96	\N	Unassigned	\N	\N
529	3	5	DT	97	\N	Unassigned	\N	\N
530	2	5	DT	98	\N	Unassigned	\N	\N
531	1	5	DT	99	\N	Unassigned	\N	\N
532	6	5	DT	100	\N	Unassigned	\N	\N
533	5	5	DT	101	\N	Unassigned	\N	\N
534	4	5	DT	102	\N	Unassigned	\N	\N
535	3	5	SP	103	\N	Unassigned	\N	\N
536	2	5	SP	104	\N	Unassigned	\N	\N
537	1	5	SP	105	\N	Unassigned	\N	\N
538	6	5	SP	106	\N	Unassigned	\N	\N
539	5	5	SP	107	\N	Unassigned	\N	\N
540	4	5	SP	108	\N	Unassigned	\N	\N
541	4	6	4x100M	1	\N	Unassigned	\N	\N
542	5	6	4x100M	2	\N	Unassigned	\N	\N
543	6	6	4x100M	3	\N	Unassigned	\N	\N
544	1	6	4x100M	4	\N	Unassigned	\N	\N
545	2	6	4x100M	5	\N	Unassigned	\N	\N
546	3	6	4x100M	6	\N	Unassigned	\N	\N
547	4	6	1600M	7	\N	Unassigned	\N	\N
548	5	6	1600M	8	\N	Unassigned	\N	\N
549	6	6	1600M	9	\N	Unassigned	\N	\N
550	1	6	1600M	10	\N	Unassigned	\N	\N
551	2	6	1600M	11	\N	Unassigned	\N	\N
552	3	6	1600M	12	\N	Unassigned	\N	\N
553	4	6	100H	13	\N	Unassigned	\N	\N
554	5	6	100H	14	\N	Unassigned	\N	\N
555	6	6	100H	15	\N	Unassigned	\N	\N
556	1	6	100H	16	\N	Unassigned	\N	\N
557	2	6	100H	17	\N	Unassigned	\N	\N
558	3	6	100H	18	\N	Unassigned	\N	\N
559	4	6	110H	19	\N	Unassigned	\N	\N
560	5	6	110H	20	\N	Unassigned	\N	\N
561	6	6	110H	21	\N	Unassigned	\N	\N
562	1	6	110H	22	\N	Unassigned	\N	\N
563	2	6	110H	23	\N	Unassigned	\N	\N
564	3	6	110H	24	\N	Unassigned	\N	\N
565	4	6	65H	25	\N	Unassigned	\N	\N
566	5	6	65H	26	\N	Unassigned	\N	\N
567	6	6	65H	27	\N	Unassigned	\N	\N
568	1	6	65H	28	\N	Unassigned	\N	\N
569	2	6	65H	29	\N	Unassigned	\N	\N
570	3	6	65H	30	\N	Unassigned	\N	\N
571	4	6	400M	31	\N	Unassigned	\N	\N
572	5	6	400M	32	\N	Unassigned	\N	\N
573	6	6	400M	33	\N	Unassigned	\N	\N
574	1	6	400M	34	\N	Unassigned	\N	\N
575	2	6	400M	35	\N	Unassigned	\N	\N
576	3	6	400M	36	\N	Unassigned	\N	\N
577	4	6	100M	37	\N	Unassigned	\N	\N
578	5	6	100M	38	\N	Unassigned	\N	\N
579	6	6	100M	39	\N	Unassigned	\N	\N
580	1	6	100M	40	\N	Unassigned	\N	\N
581	2	6	100M	41	\N	Unassigned	\N	\N
582	3	6	100M	42	\N	Unassigned	\N	\N
583	4	6	800M	43	\N	Unassigned	\N	\N
584	5	6	800M	44	\N	Unassigned	\N	\N
585	6	6	800M	45	\N	Unassigned	\N	\N
586	1	6	800M	46	\N	Unassigned	\N	\N
587	2	6	800M	47	\N	Unassigned	\N	\N
588	3	6	800M	48	\N	Unassigned	\N	\N
589	4	6	300H	49	\N	Unassigned	\N	\N
590	5	6	300H	50	\N	Unassigned	\N	\N
591	6	6	300H	51	\N	Unassigned	\N	\N
592	1	6	300H	52	\N	Unassigned	\N	\N
593	2	6	300H	53	\N	Unassigned	\N	\N
594	3	6	300H	54	\N	Unassigned	\N	\N
595	4	6	200M	55	\N	Unassigned	\N	\N
596	5	6	200M	56	\N	Unassigned	\N	\N
597	6	6	200M	57	\N	Unassigned	\N	\N
598	1	6	200M	58	\N	Unassigned	\N	\N
599	2	6	200M	59	\N	Unassigned	\N	\N
600	3	6	200M	60	\N	Unassigned	\N	\N
601	4	6	3200M	61	\N	Unassigned	\N	\N
602	5	6	3200M	62	\N	Unassigned	\N	\N
603	6	6	3200M	63	\N	Unassigned	\N	\N
604	1	6	3200M	64	\N	Unassigned	\N	\N
605	2	6	3200M	65	\N	Unassigned	\N	\N
606	3	6	3200M	66	\N	Unassigned	\N	\N
607	4	6	4x400M	67	\N	Unassigned	\N	\N
608	5	6	4x400M	68	\N	Unassigned	\N	\N
609	6	6	4x400M	69	\N	Unassigned	\N	\N
610	1	6	4x400M	70	\N	Unassigned	\N	\N
611	2	6	4x400M	71	\N	Unassigned	\N	\N
612	3	6	4x400M	72	\N	Unassigned	\N	\N
613	4	6	HJ	73	\N	Unassigned	\N	\N
614	5	6	HJ	74	\N	Unassigned	\N	\N
615	6	6	HJ	75	\N	Unassigned	\N	\N
616	1	6	HJ	76	\N	Unassigned	\N	\N
617	2	6	HJ	77	\N	Unassigned	\N	\N
618	3	6	HJ	78	\N	Unassigned	\N	\N
619	4	6	PV	79	\N	Unassigned	\N	\N
620	5	6	PV	80	\N	Unassigned	\N	\N
621	6	6	PV	81	\N	Unassigned	\N	\N
622	1	6	PV	82	\N	Unassigned	\N	\N
623	2	6	PV	83	\N	Unassigned	\N	\N
624	3	6	PV	84	\N	Unassigned	\N	\N
625	4	6	LJ	85	\N	Unassigned	\N	\N
626	5	6	LJ	86	\N	Unassigned	\N	\N
627	6	6	LJ	87	\N	Unassigned	\N	\N
628	1	6	LJ	88	\N	Unassigned	\N	\N
629	2	6	LJ	89	\N	Unassigned	\N	\N
630	3	6	LJ	90	\N	Unassigned	\N	\N
631	4	6	TJ	91	\N	Unassigned	\N	\N
632	5	6	TJ	92	\N	Unassigned	\N	\N
633	6	6	TJ	93	\N	Unassigned	\N	\N
634	1	6	TJ	94	\N	Unassigned	\N	\N
635	2	6	TJ	95	\N	Unassigned	\N	\N
636	3	6	TJ	96	\N	Unassigned	\N	\N
637	4	6	DT	97	\N	Unassigned	\N	\N
638	5	6	DT	98	\N	Unassigned	\N	\N
639	6	6	DT	99	\N	Unassigned	\N	\N
640	1	6	DT	100	\N	Unassigned	\N	\N
641	2	6	DT	101	\N	Unassigned	\N	\N
642	3	6	DT	102	\N	Unassigned	\N	\N
643	4	6	SP	103	\N	Unassigned	\N	\N
644	5	6	SP	104	\N	Unassigned	\N	\N
645	6	6	SP	105	\N	Unassigned	\N	\N
646	1	6	SP	106	\N	Unassigned	\N	\N
647	2	6	SP	107	\N	Unassigned	\N	\N
648	3	6	SP	108	\N	Unassigned	\N	\N
649	4	7	4x100M	1	\N	Unassigned	\N	\N
650	5	7	4x100M	2	\N	Unassigned	\N	\N
651	6	7	4x100M	3	\N	Unassigned	\N	\N
652	1	7	4x100M	4	\N	Unassigned	\N	\N
653	2	7	4x100M	5	\N	Unassigned	\N	\N
654	3	7	4x100M	6	\N	Unassigned	\N	\N
655	4	7	1600M	7	\N	Unassigned	\N	\N
656	5	7	1600M	8	\N	Unassigned	\N	\N
657	6	7	1600M	9	\N	Unassigned	\N	\N
658	1	7	1600M	10	\N	Unassigned	\N	\N
659	2	7	1600M	11	\N	Unassigned	\N	\N
660	3	7	1600M	12	\N	Unassigned	\N	\N
661	4	7	100H	13	\N	Unassigned	\N	\N
662	5	7	100H	14	\N	Unassigned	\N	\N
663	6	7	100H	15	\N	Unassigned	\N	\N
664	1	7	100H	16	\N	Unassigned	\N	\N
665	2	7	100H	17	\N	Unassigned	\N	\N
666	3	7	100H	18	\N	Unassigned	\N	\N
667	4	7	110H	19	\N	Unassigned	\N	\N
668	5	7	110H	20	\N	Unassigned	\N	\N
669	6	7	110H	21	\N	Unassigned	\N	\N
670	1	7	110H	22	\N	Unassigned	\N	\N
671	2	7	110H	23	\N	Unassigned	\N	\N
672	3	7	110H	24	\N	Unassigned	\N	\N
673	4	7	65H	25	\N	Unassigned	\N	\N
674	5	7	65H	26	\N	Unassigned	\N	\N
675	6	7	65H	27	\N	Unassigned	\N	\N
676	1	7	65H	28	\N	Unassigned	\N	\N
677	2	7	65H	29	\N	Unassigned	\N	\N
678	3	7	65H	30	\N	Unassigned	\N	\N
679	4	7	400M	31	\N	Unassigned	\N	\N
680	5	7	400M	32	\N	Unassigned	\N	\N
681	6	7	400M	33	\N	Unassigned	\N	\N
682	1	7	400M	34	\N	Unassigned	\N	\N
683	2	7	400M	35	\N	Unassigned	\N	\N
684	3	7	400M	36	\N	Unassigned	\N	\N
685	4	7	100M	37	\N	Unassigned	\N	\N
686	5	7	100M	38	\N	Unassigned	\N	\N
687	6	7	100M	39	\N	Unassigned	\N	\N
688	1	7	100M	40	\N	Unassigned	\N	\N
689	2	7	100M	41	\N	Unassigned	\N	\N
690	3	7	100M	42	\N	Unassigned	\N	\N
691	4	7	800M	43	\N	Unassigned	\N	\N
692	5	7	800M	44	\N	Unassigned	\N	\N
693	6	7	800M	45	\N	Unassigned	\N	\N
694	1	7	800M	46	\N	Unassigned	\N	\N
695	2	7	800M	47	\N	Unassigned	\N	\N
696	3	7	800M	48	\N	Unassigned	\N	\N
697	4	7	300H	49	\N	Unassigned	\N	\N
698	5	7	300H	50	\N	Unassigned	\N	\N
699	6	7	300H	51	\N	Unassigned	\N	\N
700	1	7	300H	52	\N	Unassigned	\N	\N
701	2	7	300H	53	\N	Unassigned	\N	\N
702	3	7	300H	54	\N	Unassigned	\N	\N
703	4	7	200M	55	\N	Unassigned	\N	\N
704	5	7	200M	56	\N	Unassigned	\N	\N
705	6	7	200M	57	\N	Unassigned	\N	\N
706	1	7	200M	58	\N	Unassigned	\N	\N
707	2	7	200M	59	\N	Unassigned	\N	\N
708	3	7	200M	60	\N	Unassigned	\N	\N
709	4	7	3200M	61	\N	Unassigned	\N	\N
710	5	7	3200M	62	\N	Unassigned	\N	\N
711	6	7	3200M	63	\N	Unassigned	\N	\N
712	1	7	3200M	64	\N	Unassigned	\N	\N
713	2	7	3200M	65	\N	Unassigned	\N	\N
714	3	7	3200M	66	\N	Unassigned	\N	\N
715	4	7	4x400M	67	\N	Unassigned	\N	\N
716	5	7	4x400M	68	\N	Unassigned	\N	\N
717	6	7	4x400M	69	\N	Unassigned	\N	\N
718	1	7	4x400M	70	\N	Unassigned	\N	\N
719	2	7	4x400M	71	\N	Unassigned	\N	\N
720	3	7	4x400M	72	\N	Unassigned	\N	\N
721	4	7	HJ	73	\N	Unassigned	\N	\N
722	5	7	HJ	74	\N	Unassigned	\N	\N
723	6	7	HJ	75	\N	Unassigned	\N	\N
724	1	7	HJ	76	\N	Unassigned	\N	\N
725	2	7	HJ	77	\N	Unassigned	\N	\N
726	3	7	HJ	78	\N	Unassigned	\N	\N
727	4	7	PV	79	\N	Unassigned	\N	\N
728	5	7	PV	80	\N	Unassigned	\N	\N
729	6	7	PV	81	\N	Unassigned	\N	\N
730	1	7	PV	82	\N	Unassigned	\N	\N
731	2	7	PV	83	\N	Unassigned	\N	\N
732	3	7	PV	84	\N	Unassigned	\N	\N
733	4	7	LJ	85	\N	Unassigned	\N	\N
734	5	7	LJ	86	\N	Unassigned	\N	\N
735	6	7	LJ	87	\N	Unassigned	\N	\N
736	1	7	LJ	88	\N	Unassigned	\N	\N
737	2	7	LJ	89	\N	Unassigned	\N	\N
738	3	7	LJ	90	\N	Unassigned	\N	\N
739	4	7	TJ	91	\N	Unassigned	\N	\N
740	5	7	TJ	92	\N	Unassigned	\N	\N
741	6	7	TJ	93	\N	Unassigned	\N	\N
742	1	7	TJ	94	\N	Unassigned	\N	\N
743	2	7	TJ	95	\N	Unassigned	\N	\N
744	3	7	TJ	96	\N	Unassigned	\N	\N
745	4	7	DT	97	\N	Unassigned	\N	\N
746	5	7	DT	98	\N	Unassigned	\N	\N
747	6	7	DT	99	\N	Unassigned	\N	\N
748	1	7	DT	100	\N	Unassigned	\N	\N
749	2	7	DT	101	\N	Unassigned	\N	\N
750	3	7	DT	102	\N	Unassigned	\N	\N
751	4	7	SP	103	\N	Unassigned	\N	\N
752	5	7	SP	104	\N	Unassigned	\N	\N
753	6	7	SP	105	\N	Unassigned	\N	\N
754	1	7	SP	106	\N	Unassigned	\N	\N
755	2	7	SP	107	\N	Unassigned	\N	\N
756	3	7	SP	108	\N	Unassigned	\N	\N
757	4	8	4x100M	1	\N	Unassigned	\N	\N
758	5	8	4x100M	2	\N	Unassigned	\N	\N
759	6	8	4x100M	3	\N	Unassigned	\N	\N
760	1	8	4x100M	4	\N	Unassigned	\N	\N
761	2	8	4x100M	5	\N	Unassigned	\N	\N
762	3	8	4x100M	6	\N	Unassigned	\N	\N
763	4	8	1600M	7	\N	Unassigned	\N	\N
764	5	8	1600M	8	\N	Unassigned	\N	\N
765	6	8	1600M	9	\N	Unassigned	\N	\N
766	1	8	1600M	10	\N	Unassigned	\N	\N
767	2	8	1600M	11	\N	Unassigned	\N	\N
768	3	8	1600M	12	\N	Unassigned	\N	\N
769	4	8	100H	13	\N	Unassigned	\N	\N
770	5	8	100H	14	\N	Unassigned	\N	\N
771	6	8	100H	15	\N	Unassigned	\N	\N
772	1	8	100H	16	\N	Unassigned	\N	\N
773	2	8	100H	17	\N	Unassigned	\N	\N
774	3	8	100H	18	\N	Unassigned	\N	\N
775	4	8	110H	19	\N	Unassigned	\N	\N
776	5	8	110H	20	\N	Unassigned	\N	\N
777	6	8	110H	21	\N	Unassigned	\N	\N
778	1	8	110H	22	\N	Unassigned	\N	\N
779	2	8	110H	23	\N	Unassigned	\N	\N
780	3	8	110H	24	\N	Unassigned	\N	\N
781	4	8	65H	25	\N	Unassigned	\N	\N
782	5	8	65H	26	\N	Unassigned	\N	\N
783	6	8	65H	27	\N	Unassigned	\N	\N
784	1	8	65H	28	\N	Unassigned	\N	\N
785	2	8	65H	29	\N	Unassigned	\N	\N
786	3	8	65H	30	\N	Unassigned	\N	\N
787	4	8	400M	31	\N	Unassigned	\N	\N
788	5	8	400M	32	\N	Unassigned	\N	\N
789	6	8	400M	33	\N	Unassigned	\N	\N
790	1	8	400M	34	\N	Unassigned	\N	\N
791	2	8	400M	35	\N	Unassigned	\N	\N
792	3	8	400M	36	\N	Unassigned	\N	\N
793	4	8	100M	37	\N	Unassigned	\N	\N
794	5	8	100M	38	\N	Unassigned	\N	\N
795	6	8	100M	39	\N	Unassigned	\N	\N
796	1	8	100M	40	\N	Unassigned	\N	\N
797	2	8	100M	41	\N	Unassigned	\N	\N
798	3	8	100M	42	\N	Unassigned	\N	\N
799	4	8	800M	43	\N	Unassigned	\N	\N
800	5	8	800M	44	\N	Unassigned	\N	\N
801	6	8	800M	45	\N	Unassigned	\N	\N
802	1	8	800M	46	\N	Unassigned	\N	\N
803	2	8	800M	47	\N	Unassigned	\N	\N
804	3	8	800M	48	\N	Unassigned	\N	\N
805	4	8	300H	49	\N	Unassigned	\N	\N
806	5	8	300H	50	\N	Unassigned	\N	\N
807	6	8	300H	51	\N	Unassigned	\N	\N
808	1	8	300H	52	\N	Unassigned	\N	\N
809	2	8	300H	53	\N	Unassigned	\N	\N
810	3	8	300H	54	\N	Unassigned	\N	\N
811	4	8	200M	55	\N	Unassigned	\N	\N
812	5	8	200M	56	\N	Unassigned	\N	\N
813	6	8	200M	57	\N	Unassigned	\N	\N
814	1	8	200M	58	\N	Unassigned	\N	\N
815	2	8	200M	59	\N	Unassigned	\N	\N
816	3	8	200M	60	\N	Unassigned	\N	\N
817	4	8	3200M	61	\N	Unassigned	\N	\N
818	5	8	3200M	62	\N	Unassigned	\N	\N
819	6	8	3200M	63	\N	Unassigned	\N	\N
820	1	8	3200M	64	\N	Unassigned	\N	\N
821	2	8	3200M	65	\N	Unassigned	\N	\N
822	3	8	3200M	66	\N	Unassigned	\N	\N
823	4	8	4x400M	67	\N	Unassigned	\N	\N
824	5	8	4x400M	68	\N	Unassigned	\N	\N
825	6	8	4x400M	69	\N	Unassigned	\N	\N
826	1	8	4x400M	70	\N	Unassigned	\N	\N
827	2	8	4x400M	71	\N	Unassigned	\N	\N
828	3	8	4x400M	72	\N	Unassigned	\N	\N
829	4	8	HJ	73	\N	Unassigned	\N	\N
830	5	8	HJ	74	\N	Unassigned	\N	\N
831	6	8	HJ	75	\N	Unassigned	\N	\N
832	1	8	HJ	76	\N	Unassigned	\N	\N
833	2	8	HJ	77	\N	Unassigned	\N	\N
834	3	8	HJ	78	\N	Unassigned	\N	\N
835	4	8	PV	79	\N	Unassigned	\N	\N
836	5	8	PV	80	\N	Unassigned	\N	\N
837	6	8	PV	81	\N	Unassigned	\N	\N
838	1	8	PV	82	\N	Unassigned	\N	\N
839	2	8	PV	83	\N	Unassigned	\N	\N
840	3	8	PV	84	\N	Unassigned	\N	\N
841	4	8	LJ	85	\N	Unassigned	\N	\N
842	5	8	LJ	86	\N	Unassigned	\N	\N
843	6	8	LJ	87	\N	Unassigned	\N	\N
844	1	8	LJ	88	\N	Unassigned	\N	\N
845	2	8	LJ	89	\N	Unassigned	\N	\N
846	3	8	LJ	90	\N	Unassigned	\N	\N
847	4	8	TJ	91	\N	Unassigned	\N	\N
848	5	8	TJ	92	\N	Unassigned	\N	\N
849	6	8	TJ	93	\N	Unassigned	\N	\N
850	1	8	TJ	94	\N	Unassigned	\N	\N
851	2	8	TJ	95	\N	Unassigned	\N	\N
852	3	8	TJ	96	\N	Unassigned	\N	\N
853	4	8	DT	97	\N	Unassigned	\N	\N
854	5	8	DT	98	\N	Unassigned	\N	\N
855	6	8	DT	99	\N	Unassigned	\N	\N
856	1	8	DT	100	\N	Unassigned	\N	\N
857	2	8	DT	101	\N	Unassigned	\N	\N
858	3	8	DT	102	\N	Unassigned	\N	\N
859	4	8	SP	103	\N	Unassigned	\N	\N
860	5	8	SP	104	\N	Unassigned	\N	\N
861	6	8	SP	105	\N	Unassigned	\N	\N
862	1	8	SP	106	\N	Unassigned	\N	\N
863	2	8	SP	107	\N	Unassigned	\N	\N
864	3	8	SP	108	\N	Unassigned	\N	\N
865	4	9	4x100M	1	\N	Unassigned	\N	\N
866	5	9	4x100M	2	\N	Unassigned	\N	\N
867	6	9	4x100M	3	\N	Unassigned	\N	\N
868	1	9	4x100M	4	\N	Unassigned	\N	\N
869	2	9	4x100M	5	\N	Unassigned	\N	\N
870	3	9	4x100M	6	\N	Unassigned	\N	\N
871	4	9	1600M	7	\N	Unassigned	\N	\N
872	5	9	1600M	8	\N	Unassigned	\N	\N
873	6	9	1600M	9	\N	Unassigned	\N	\N
874	1	9	1600M	10	\N	Unassigned	\N	\N
875	2	9	1600M	11	\N	Unassigned	\N	\N
876	3	9	1600M	12	\N	Unassigned	\N	\N
877	4	9	100H	13	\N	Unassigned	\N	\N
878	5	9	100H	14	\N	Unassigned	\N	\N
879	6	9	100H	15	\N	Unassigned	\N	\N
880	1	9	100H	16	\N	Unassigned	\N	\N
881	2	9	100H	17	\N	Unassigned	\N	\N
882	3	9	100H	18	\N	Unassigned	\N	\N
883	4	9	110H	19	\N	Unassigned	\N	\N
884	5	9	110H	20	\N	Unassigned	\N	\N
885	6	9	110H	21	\N	Unassigned	\N	\N
886	1	9	110H	22	\N	Unassigned	\N	\N
887	2	9	110H	23	\N	Unassigned	\N	\N
888	3	9	110H	24	\N	Unassigned	\N	\N
889	4	9	65H	25	\N	Unassigned	\N	\N
890	5	9	65H	26	\N	Unassigned	\N	\N
891	6	9	65H	27	\N	Unassigned	\N	\N
892	1	9	65H	28	\N	Unassigned	\N	\N
893	2	9	65H	29	\N	Unassigned	\N	\N
894	3	9	65H	30	\N	Unassigned	\N	\N
895	4	9	400M	31	\N	Unassigned	\N	\N
896	5	9	400M	32	\N	Unassigned	\N	\N
897	6	9	400M	33	\N	Unassigned	\N	\N
898	1	9	400M	34	\N	Unassigned	\N	\N
899	2	9	400M	35	\N	Unassigned	\N	\N
900	3	9	400M	36	\N	Unassigned	\N	\N
901	4	9	100M	37	\N	Unassigned	\N	\N
902	5	9	100M	38	\N	Unassigned	\N	\N
903	6	9	100M	39	\N	Unassigned	\N	\N
904	1	9	100M	40	\N	Unassigned	\N	\N
905	2	9	100M	41	\N	Unassigned	\N	\N
906	3	9	100M	42	\N	Unassigned	\N	\N
907	4	9	800M	43	\N	Unassigned	\N	\N
908	5	9	800M	44	\N	Unassigned	\N	\N
909	6	9	800M	45	\N	Unassigned	\N	\N
910	1	9	800M	46	\N	Unassigned	\N	\N
911	2	9	800M	47	\N	Unassigned	\N	\N
912	3	9	800M	48	\N	Unassigned	\N	\N
913	4	9	300H	49	\N	Unassigned	\N	\N
914	5	9	300H	50	\N	Unassigned	\N	\N
915	6	9	300H	51	\N	Unassigned	\N	\N
916	1	9	300H	52	\N	Unassigned	\N	\N
917	2	9	300H	53	\N	Unassigned	\N	\N
918	3	9	300H	54	\N	Unassigned	\N	\N
919	4	9	200M	55	\N	Unassigned	\N	\N
920	5	9	200M	56	\N	Unassigned	\N	\N
921	6	9	200M	57	\N	Unassigned	\N	\N
922	1	9	200M	58	\N	Unassigned	\N	\N
923	2	9	200M	59	\N	Unassigned	\N	\N
924	3	9	200M	60	\N	Unassigned	\N	\N
925	4	9	3200M	61	\N	Unassigned	\N	\N
926	5	9	3200M	62	\N	Unassigned	\N	\N
927	6	9	3200M	63	\N	Unassigned	\N	\N
928	1	9	3200M	64	\N	Unassigned	\N	\N
929	2	9	3200M	65	\N	Unassigned	\N	\N
930	3	9	3200M	66	\N	Unassigned	\N	\N
931	4	9	4x400M	67	\N	Unassigned	\N	\N
932	5	9	4x400M	68	\N	Unassigned	\N	\N
933	6	9	4x400M	69	\N	Unassigned	\N	\N
934	1	9	4x400M	70	\N	Unassigned	\N	\N
935	2	9	4x400M	71	\N	Unassigned	\N	\N
936	3	9	4x400M	72	\N	Unassigned	\N	\N
937	4	9	HJ	73	\N	Unassigned	\N	\N
938	5	9	HJ	74	\N	Unassigned	\N	\N
939	6	9	HJ	75	\N	Unassigned	\N	\N
940	1	9	HJ	76	\N	Unassigned	\N	\N
941	2	9	HJ	77	\N	Unassigned	\N	\N
942	3	9	HJ	78	\N	Unassigned	\N	\N
943	4	9	PV	79	\N	Unassigned	\N	\N
944	5	9	PV	80	\N	Unassigned	\N	\N
945	6	9	PV	81	\N	Unassigned	\N	\N
946	1	9	PV	82	\N	Unassigned	\N	\N
947	2	9	PV	83	\N	Unassigned	\N	\N
948	3	9	PV	84	\N	Unassigned	\N	\N
949	4	9	LJ	85	\N	Unassigned	\N	\N
950	5	9	LJ	86	\N	Unassigned	\N	\N
951	6	9	LJ	87	\N	Unassigned	\N	\N
952	1	9	LJ	88	\N	Unassigned	\N	\N
953	2	9	LJ	89	\N	Unassigned	\N	\N
954	3	9	LJ	90	\N	Unassigned	\N	\N
955	4	9	TJ	91	\N	Unassigned	\N	\N
956	5	9	TJ	92	\N	Unassigned	\N	\N
957	6	9	TJ	93	\N	Unassigned	\N	\N
958	1	9	TJ	94	\N	Unassigned	\N	\N
959	2	9	TJ	95	\N	Unassigned	\N	\N
960	3	9	TJ	96	\N	Unassigned	\N	\N
961	4	9	DT	97	\N	Unassigned	\N	\N
962	5	9	DT	98	\N	Unassigned	\N	\N
963	6	9	DT	99	\N	Unassigned	\N	\N
964	1	9	DT	100	\N	Unassigned	\N	\N
965	2	9	DT	101	\N	Unassigned	\N	\N
966	3	9	DT	102	\N	Unassigned	\N	\N
967	4	9	SP	103	\N	Unassigned	\N	\N
968	5	9	SP	104	\N	Unassigned	\N	\N
969	6	9	SP	105	\N	Unassigned	\N	\N
970	1	9	SP	106	\N	Unassigned	\N	\N
971	2	9	SP	107	\N	Unassigned	\N	\N
972	3	9	SP	108	\N	Unassigned	\N	\N
973	4	10	4x100M	1	\N	Unassigned	\N	\N
974	5	10	4x100M	2	\N	Unassigned	\N	\N
975	6	10	4x100M	3	\N	Unassigned	\N	\N
976	1	10	4x100M	4	\N	Unassigned	\N	\N
977	2	10	4x100M	5	\N	Unassigned	\N	\N
978	3	10	4x100M	6	\N	Unassigned	\N	\N
979	4	10	1600M	7	\N	Unassigned	\N	\N
980	5	10	1600M	8	\N	Unassigned	\N	\N
981	6	10	1600M	9	\N	Unassigned	\N	\N
982	1	10	1600M	10	\N	Unassigned	\N	\N
983	2	10	1600M	11	\N	Unassigned	\N	\N
984	3	10	1600M	12	\N	Unassigned	\N	\N
985	4	10	100H	13	\N	Unassigned	\N	\N
986	5	10	100H	14	\N	Unassigned	\N	\N
987	6	10	100H	15	\N	Unassigned	\N	\N
988	1	10	100H	16	\N	Unassigned	\N	\N
989	2	10	100H	17	\N	Unassigned	\N	\N
990	3	10	100H	18	\N	Unassigned	\N	\N
991	4	10	110H	19	\N	Unassigned	\N	\N
992	5	10	110H	20	\N	Unassigned	\N	\N
993	6	10	110H	21	\N	Unassigned	\N	\N
994	1	10	110H	22	\N	Unassigned	\N	\N
995	2	10	110H	23	\N	Unassigned	\N	\N
996	3	10	110H	24	\N	Unassigned	\N	\N
997	4	10	65H	25	\N	Unassigned	\N	\N
998	5	10	65H	26	\N	Unassigned	\N	\N
999	6	10	65H	27	\N	Unassigned	\N	\N
1000	1	10	65H	28	\N	Unassigned	\N	\N
1001	2	10	65H	29	\N	Unassigned	\N	\N
1002	3	10	65H	30	\N	Unassigned	\N	\N
1003	4	10	400M	31	\N	Unassigned	\N	\N
1004	5	10	400M	32	\N	Unassigned	\N	\N
1005	6	10	400M	33	\N	Unassigned	\N	\N
1006	1	10	400M	34	\N	Unassigned	\N	\N
1007	2	10	400M	35	\N	Unassigned	\N	\N
1008	3	10	400M	36	\N	Unassigned	\N	\N
1009	4	10	100M	37	\N	Unassigned	\N	\N
1010	5	10	100M	38	\N	Unassigned	\N	\N
1011	6	10	100M	39	\N	Unassigned	\N	\N
1012	1	10	100M	40	\N	Unassigned	\N	\N
1013	2	10	100M	41	\N	Unassigned	\N	\N
1014	3	10	100M	42	\N	Unassigned	\N	\N
1015	4	10	800M	43	\N	Unassigned	\N	\N
1016	5	10	800M	44	\N	Unassigned	\N	\N
1017	6	10	800M	45	\N	Unassigned	\N	\N
1018	1	10	800M	46	\N	Unassigned	\N	\N
1019	2	10	800M	47	\N	Unassigned	\N	\N
1020	3	10	800M	48	\N	Unassigned	\N	\N
1021	4	10	300H	49	\N	Unassigned	\N	\N
1022	5	10	300H	50	\N	Unassigned	\N	\N
1023	6	10	300H	51	\N	Unassigned	\N	\N
1024	1	10	300H	52	\N	Unassigned	\N	\N
1025	2	10	300H	53	\N	Unassigned	\N	\N
1026	3	10	300H	54	\N	Unassigned	\N	\N
1027	4	10	200M	55	\N	Unassigned	\N	\N
1028	5	10	200M	56	\N	Unassigned	\N	\N
1029	6	10	200M	57	\N	Unassigned	\N	\N
1030	1	10	200M	58	\N	Unassigned	\N	\N
1031	2	10	200M	59	\N	Unassigned	\N	\N
1032	3	10	200M	60	\N	Unassigned	\N	\N
1033	4	10	3200M	61	\N	Unassigned	\N	\N
1034	5	10	3200M	62	\N	Unassigned	\N	\N
1035	6	10	3200M	63	\N	Unassigned	\N	\N
1036	1	10	3200M	64	\N	Unassigned	\N	\N
1037	2	10	3200M	65	\N	Unassigned	\N	\N
1038	3	10	3200M	66	\N	Unassigned	\N	\N
1039	4	10	4x400M	67	\N	Unassigned	\N	\N
1040	5	10	4x400M	68	\N	Unassigned	\N	\N
1041	6	10	4x400M	69	\N	Unassigned	\N	\N
1042	1	10	4x400M	70	\N	Unassigned	\N	\N
1043	2	10	4x400M	71	\N	Unassigned	\N	\N
1044	3	10	4x400M	72	\N	Unassigned	\N	\N
1045	4	10	HJ	73	\N	Unassigned	\N	\N
1046	5	10	HJ	74	\N	Unassigned	\N	\N
1047	6	10	HJ	75	\N	Unassigned	\N	\N
1048	1	10	HJ	76	\N	Unassigned	\N	\N
1049	2	10	HJ	77	\N	Unassigned	\N	\N
1050	3	10	HJ	78	\N	Unassigned	\N	\N
1051	4	10	PV	79	\N	Unassigned	\N	\N
1052	5	10	PV	80	\N	Unassigned	\N	\N
1053	6	10	PV	81	\N	Unassigned	\N	\N
1054	1	10	PV	82	\N	Unassigned	\N	\N
1055	2	10	PV	83	\N	Unassigned	\N	\N
1056	3	10	PV	84	\N	Unassigned	\N	\N
1057	4	10	LJ	85	\N	Unassigned	\N	\N
1058	5	10	LJ	86	\N	Unassigned	\N	\N
1059	6	10	LJ	87	\N	Unassigned	\N	\N
1060	1	10	LJ	88	\N	Unassigned	\N	\N
1061	2	10	LJ	89	\N	Unassigned	\N	\N
1062	3	10	LJ	90	\N	Unassigned	\N	\N
1063	4	10	TJ	91	\N	Unassigned	\N	\N
1064	5	10	TJ	92	\N	Unassigned	\N	\N
1065	6	10	TJ	93	\N	Unassigned	\N	\N
1066	1	10	TJ	94	\N	Unassigned	\N	\N
1067	2	10	TJ	95	\N	Unassigned	\N	\N
1068	3	10	TJ	96	\N	Unassigned	\N	\N
1069	4	10	DT	97	\N	Unassigned	\N	\N
1070	5	10	DT	98	\N	Unassigned	\N	\N
1071	6	10	DT	99	\N	Unassigned	\N	\N
1072	1	10	DT	100	\N	Unassigned	\N	\N
1073	2	10	DT	101	\N	Unassigned	\N	\N
1074	3	10	DT	102	\N	Unassigned	\N	\N
1075	4	10	SP	103	\N	Unassigned	\N	\N
1076	5	10	SP	104	\N	Unassigned	\N	\N
1077	6	10	SP	105	\N	Unassigned	\N	\N
1078	1	10	SP	106	\N	Unassigned	\N	\N
1079	2	10	SP	107	\N	Unassigned	\N	\N
1080	3	10	SP	108	\N	Unassigned	\N	\N
1081	4	11	4x100M	1	\N	Unassigned	\N	\N
1082	5	11	4x100M	2	\N	Unassigned	\N	\N
1083	6	11	4x100M	3	\N	Unassigned	\N	\N
1084	1	11	4x100M	4	\N	Unassigned	\N	\N
1085	2	11	4x100M	5	\N	Unassigned	\N	\N
1086	3	11	4x100M	6	\N	Unassigned	\N	\N
1087	4	11	1600M	7	\N	Unassigned	\N	\N
1088	5	11	1600M	8	\N	Unassigned	\N	\N
1089	6	11	1600M	9	\N	Unassigned	\N	\N
1090	1	11	1600M	10	\N	Unassigned	\N	\N
1091	2	11	1600M	11	\N	Unassigned	\N	\N
1092	3	11	1600M	12	\N	Unassigned	\N	\N
1093	4	11	100H	13	\N	Unassigned	\N	\N
1094	5	11	100H	14	\N	Unassigned	\N	\N
1095	6	11	100H	15	\N	Unassigned	\N	\N
1096	1	11	100H	16	\N	Unassigned	\N	\N
1097	2	11	100H	17	\N	Unassigned	\N	\N
1098	3	11	100H	18	\N	Unassigned	\N	\N
1099	4	11	110H	19	\N	Unassigned	\N	\N
1100	5	11	110H	20	\N	Unassigned	\N	\N
1101	6	11	110H	21	\N	Unassigned	\N	\N
1102	1	11	110H	22	\N	Unassigned	\N	\N
1103	2	11	110H	23	\N	Unassigned	\N	\N
1104	3	11	110H	24	\N	Unassigned	\N	\N
1105	4	11	65H	25	\N	Unassigned	\N	\N
1106	5	11	65H	26	\N	Unassigned	\N	\N
1107	6	11	65H	27	\N	Unassigned	\N	\N
1108	1	11	65H	28	\N	Unassigned	\N	\N
1109	2	11	65H	29	\N	Unassigned	\N	\N
1110	3	11	65H	30	\N	Unassigned	\N	\N
1111	4	11	400M	31	\N	Unassigned	\N	\N
1112	5	11	400M	32	\N	Unassigned	\N	\N
1113	6	11	400M	33	\N	Unassigned	\N	\N
1114	1	11	400M	34	\N	Unassigned	\N	\N
1115	2	11	400M	35	\N	Unassigned	\N	\N
1116	3	11	400M	36	\N	Unassigned	\N	\N
1117	4	11	100M	37	\N	Unassigned	\N	\N
1118	5	11	100M	38	\N	Unassigned	\N	\N
1119	6	11	100M	39	\N	Unassigned	\N	\N
1120	1	11	100M	40	\N	Unassigned	\N	\N
1121	2	11	100M	41	\N	Unassigned	\N	\N
1122	3	11	100M	42	\N	Unassigned	\N	\N
1123	4	11	800M	43	\N	Unassigned	\N	\N
1124	5	11	800M	44	\N	Unassigned	\N	\N
1125	6	11	800M	45	\N	Unassigned	\N	\N
1126	1	11	800M	46	\N	Unassigned	\N	\N
1127	2	11	800M	47	\N	Unassigned	\N	\N
1128	3	11	800M	48	\N	Unassigned	\N	\N
1129	4	11	300H	49	\N	Unassigned	\N	\N
1130	5	11	300H	50	\N	Unassigned	\N	\N
1131	6	11	300H	51	\N	Unassigned	\N	\N
1132	1	11	300H	52	\N	Unassigned	\N	\N
1133	2	11	300H	53	\N	Unassigned	\N	\N
1134	3	11	300H	54	\N	Unassigned	\N	\N
1135	4	11	200M	55	\N	Unassigned	\N	\N
1136	5	11	200M	56	\N	Unassigned	\N	\N
1137	6	11	200M	57	\N	Unassigned	\N	\N
1138	1	11	200M	58	\N	Unassigned	\N	\N
1139	2	11	200M	59	\N	Unassigned	\N	\N
1140	3	11	200M	60	\N	Unassigned	\N	\N
1141	4	11	3200M	61	\N	Unassigned	\N	\N
1142	5	11	3200M	62	\N	Unassigned	\N	\N
1143	6	11	3200M	63	\N	Unassigned	\N	\N
1144	1	11	3200M	64	\N	Unassigned	\N	\N
1145	2	11	3200M	65	\N	Unassigned	\N	\N
1146	3	11	3200M	66	\N	Unassigned	\N	\N
1147	4	11	4x400M	67	\N	Unassigned	\N	\N
1148	5	11	4x400M	68	\N	Unassigned	\N	\N
1149	6	11	4x400M	69	\N	Unassigned	\N	\N
1150	1	11	4x400M	70	\N	Unassigned	\N	\N
1151	2	11	4x400M	71	\N	Unassigned	\N	\N
1152	3	11	4x400M	72	\N	Unassigned	\N	\N
1153	4	11	HJ	73	\N	Unassigned	\N	\N
1154	5	11	HJ	74	\N	Unassigned	\N	\N
1155	6	11	HJ	75	\N	Unassigned	\N	\N
1156	1	11	HJ	76	\N	Unassigned	\N	\N
1157	2	11	HJ	77	\N	Unassigned	\N	\N
1158	3	11	HJ	78	\N	Unassigned	\N	\N
1159	4	11	PV	79	\N	Unassigned	\N	\N
1160	5	11	PV	80	\N	Unassigned	\N	\N
1161	6	11	PV	81	\N	Unassigned	\N	\N
1162	1	11	PV	82	\N	Unassigned	\N	\N
1163	2	11	PV	83	\N	Unassigned	\N	\N
1164	3	11	PV	84	\N	Unassigned	\N	\N
1165	4	11	LJ	85	\N	Unassigned	\N	\N
1166	5	11	LJ	86	\N	Unassigned	\N	\N
1167	6	11	LJ	87	\N	Unassigned	\N	\N
1168	1	11	LJ	88	\N	Unassigned	\N	\N
1169	2	11	LJ	89	\N	Unassigned	\N	\N
1170	3	11	LJ	90	\N	Unassigned	\N	\N
1171	4	11	TJ	91	\N	Unassigned	\N	\N
1172	5	11	TJ	92	\N	Unassigned	\N	\N
1173	6	11	TJ	93	\N	Unassigned	\N	\N
1174	1	11	TJ	94	\N	Unassigned	\N	\N
1175	2	11	TJ	95	\N	Unassigned	\N	\N
1176	3	11	TJ	96	\N	Unassigned	\N	\N
1177	4	11	DT	97	\N	Unassigned	\N	\N
1178	5	11	DT	98	\N	Unassigned	\N	\N
1179	6	11	DT	99	\N	Unassigned	\N	\N
1180	1	11	DT	100	\N	Unassigned	\N	\N
1181	2	11	DT	101	\N	Unassigned	\N	\N
1182	3	11	DT	102	\N	Unassigned	\N	\N
1183	4	11	SP	103	\N	Unassigned	\N	\N
1184	5	11	SP	104	\N	Unassigned	\N	\N
1185	6	11	SP	105	\N	Unassigned	\N	\N
1186	1	11	SP	106	\N	Unassigned	\N	\N
1187	2	11	SP	107	\N	Unassigned	\N	\N
1188	3	11	SP	108	\N	Unassigned	\N	\N
1189	8	12	1600M	1	\N	Unassigned	\N	\N
1190	7	12	1600M	2	\N	Unassigned	\N	\N
1191	8	12	100H	3	\N	Unassigned	\N	\N
1192	7	12	100H	4	\N	Unassigned	\N	\N
\.


--
-- Name: meet_division_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meet_division_events_id_seq', 1192, true);


--
-- Data for Name: meets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meets (id, name, date, host_school_id, description, status, max_entries_per_athlete, max_relays_per_athlete, max_teammates_per_event, max_heats_per_mde) FROM stdin;
3	PCAL League Practice Meet #2	2019-03-22 00:00:00	8	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
4	PCAL League Practice Meet #3	2019-03-22 00:00:00	9	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
5	PCAL League Practice Meet #4	2019-03-29 00:00:00	14	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
7	PCAL League Practice Meet #6	2019-04-12 00:00:00	8	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
8	PCAL League Practice Meet #7	2019-04-17 00:00:00	5	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
9	PCAL League Practice Meet #8	2019-04-24 00:00:00	9	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
10	PCAL League Practice Meet #9	2019-05-01 00:00:00	14	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
11	PCAL League Championships	2019-05-08 00:00:00	5	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
1	PCAL: San Benito (Hollister) vs. Everett Alvarez	2019-03-08 00:00:00	5	 San Benito at Everett Alvarez. Meet starts at 3pm.\n        Entries must be submitted by noon the day before.\n                       	Accepting Entries	4	2	12	1
2	PCAL: League Practice Meet #1	2019-03-10 00:00:00	5	 Meet starts at 3pm, at Los Gatos High School.\n            	Accepting Entries	4	2	12	1
6	PCAL League Practice Meet #5	2019-04-05 00:00:00	5	 Meet starts at 3pm.\n            	Accepting Entries	4	2	12	1
12	Unpublished Meet	2019-05-08 00:00:00	5		Unpublished	4	2	12	1
\.


--
-- Name: meets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meets_id_seq', 12, true);


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schools (id, code, name, league, section, city, state) FROM stdin;
1	UNA	Unattached	\N	\N	\N	\N
2	ALVA	Everett Alvarez	\N	\N	\N	\N
3	SABE	San Benito (Hollister)	\N	\N	\N	\N
4	ANZR	Anzar (Aromas-San Juan)	\N	\N	\N	\N
5	CARM	Carmel	\N	\N	\N	\N
6	GONZ	Gonzales	\N	\N	\N	\N
7	GRNF	Greenfield	\N	\N	\N	\N
8	KICI	King City	\N	\N	\N	\N
9	MaHS	Marina	\N	\N	\N	\N
10	OAKW	Oakwood	\N	\N	\N	\N
11	PCS	Pacific Collegiate	\N	\N	\N	\N
12	PAGR	Pacific Grove	\N	\N	\N	\N
13	SCAT	Santa Catalina	\N	\N	\N	\N
14	SOLE	Soledad	\N	\N	\N	\N
15	STEV	Stevenson	\N	\N	\N	\N
16	YORK	The York School	\N	\N	\N	\N
17	GBK	GB Kirby	\N	\N	\N	\N
18	ALIS	Alisal	\N	\N	\N	\N
19	EACP	Eastside College Prep	\N	\N	\N	\N
20	LVLA	Luis Valdez Leadership Acade	\N	\N	\N	\N
21	MONT	Monterey	\N	\N	\N	\N
22	NOMO	North Monterey County	\N	\N	\N	\N
23	NSAL	North Salinas	\N	\N	\N	\N
24	NDCC	Notre Dame (Salinas)	\N	\N	\N	\N
25	PAJA	Pajaro Valley	\N	\N	\N	\N
26	PALM	Palma	\N	\N	\N	\N
27	SALI	Salinas	\N	\N	\N	\N
28	TKA	The King’s Academy	\N	\N	\N	\N
29	WATS	Watsonville	\N	\N	\N	\N
30	TCHS	Trinity Christian	\N	\N	\N	\N
31	LCPA	Latino College Prep	\N	\N	\N	\N
32	PPCS	Pacific Point	\N	\N	\N	\N
\.


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schools_id_seq', 32, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password, school_id, role) FROM stdin;
1	sraisty@spcinc.com	12345	\N	superuser
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: athletes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_pkey PRIMARY KEY (id);


--
-- Name: div_orderings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.div_orderings
    ADD CONSTRAINT div_orderings_pkey PRIMARY KEY (id);


--
-- Name: divisions_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_code_key UNIQUE (code);


--
-- Name: divisions_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_name_key UNIQUE (name);


--
-- Name: divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: event_defs_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_defs
    ADD CONSTRAINT event_defs_name_key UNIQUE (name);


--
-- Name: event_defs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_defs
    ADD CONSTRAINT event_defs_pkey PRIMARY KEY (code);


--
-- Name: event_ordering_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_ordering
    ADD CONSTRAINT event_ordering_pkey PRIMARY KEY (id);


--
-- Name: heats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heats
    ADD CONSTRAINT heats_pkey PRIMARY KEY (id);


--
-- Name: meet_division_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_pkey PRIMARY KEY (id);


--
-- Name: meets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meets
    ADD CONSTRAINT meets_pkey PRIMARY KEY (id);


--
-- Name: schools_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_code_key UNIQUE (code);


--
-- Name: schools_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_name_key UNIQUE (name);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: athletes_div_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_div_id_fkey FOREIGN KEY (div_id) REFERENCES public.divisions(id);


--
-- Name: athletes_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id);


--
-- Name: div_orderings_div_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.div_orderings
    ADD CONSTRAINT div_orderings_div_id_fkey FOREIGN KEY (div_id) REFERENCES public.divisions(id);


--
-- Name: div_orderings_meet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.div_orderings
    ADD CONSTRAINT div_orderings_meet_id_fkey FOREIGN KEY (meet_id) REFERENCES public.meets(id);


--
-- Name: entries_athlete_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_athlete_id_fkey FOREIGN KEY (athlete_id) REFERENCES public.athletes(id);


--
-- Name: entries_heat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_heat_id_fkey FOREIGN KEY (heat_id) REFERENCES public.heats(id);


--
-- Name: entries_mde_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_mde_id_fkey FOREIGN KEY (mde_id) REFERENCES public.meet_division_events(id);


--
-- Name: event_ordering_event_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_ordering
    ADD CONSTRAINT event_ordering_event_code_fkey FOREIGN KEY (event_code) REFERENCES public.event_defs(code);


--
-- Name: event_ordering_meet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_ordering
    ADD CONSTRAINT event_ordering_meet_id_fkey FOREIGN KEY (meet_id) REFERENCES public.meets(id);


--
-- Name: meet_division_events_div_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_div_id_fkey FOREIGN KEY (div_id) REFERENCES public.divisions(id);


--
-- Name: meet_division_events_event_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_event_code_fkey FOREIGN KEY (event_code) REFERENCES public.event_defs(code);


--
-- Name: meet_division_events_meet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_meet_id_fkey FOREIGN KEY (meet_id) REFERENCES public.meets(id);


--
-- Name: meets_host_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meets
    ADD CONSTRAINT meets_host_school_id_fkey FOREIGN KEY (host_school_id) REFERENCES public.schools(id);


--
-- Name: users_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

