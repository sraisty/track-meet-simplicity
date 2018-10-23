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

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adultchild; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.adultchild AS ENUM (
    'adult',
    'child'
);


ALTER TYPE public.adultchild OWNER TO vagrant;

--
-- Name: event_types; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.event_types AS ENUM (
    'sprint',
    'distance',
    'relay',
    'vertjump',
    'horzjump',
    'throw'
);


ALTER TYPE public.event_types OWNER TO vagrant;

--
-- Name: gender; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.gender AS ENUM (
    'M',
    'F'
);


ALTER TYPE public.gender OWNER TO vagrant;

--
-- Name: grade; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.grade AS ENUM (
    '6',
    '7',
    '8'
);


ALTER TYPE public.grade OWNER TO vagrant;

--
-- Name: mark_type; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.mark_type AS ENUM (
    'seconds',
    'inches',
    'meters'
);


ALTER TYPE public.mark_type OWNER TO vagrant;

--
-- Name: meet_status; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.meet_status AS ENUM (
    'Not Published',
    'Accepting Entries',
    'Awaiting Assignment',
    'Assignments Done',
    'Meet In Progress',
    'Completed'
);


ALTER TYPE public.meet_status OWNER TO vagrant;

--
-- Name: user_roles; Type: TYPE; Schema: public; Owner: vagrant
--

CREATE TYPE public.user_roles AS ENUM (
    'meet_director',
    'coach',
    'athlete',
    'other'
);


ALTER TYPE public.user_roles OWNER TO vagrant;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: athletes; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.athletes (
    id integer NOT NULL,
    fname character varying(30) NOT NULL,
    lname character varying(30) NOT NULL,
    minitial character varying(1),
    phone character varying(12),
    school_id integer,
    div_id integer NOT NULL
);


ALTER TABLE public.athletes OWNER TO vagrant;

--
-- Name: athletes_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.athletes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.athletes_id_seq OWNER TO vagrant;

--
-- Name: athletes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.athletes_id_seq OWNED BY public.athletes.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.divisions (
    id integer NOT NULL,
    gender public.gender NOT NULL,
    grade public.grade,
    adult_child public.adultchild NOT NULL
);


ALTER TABLE public.divisions OWNER TO vagrant;

--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.divisions_id_seq OWNER TO vagrant;

--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.divisions_id_seq OWNED BY public.divisions.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.entries (
    id integer NOT NULL,
    athlete_id integer NOT NULL,
    mde_id integer NOT NULL,
    mark numeric(7,2),
    mark_type public.mark_type
);


ALTER TABLE public.entries OWNER TO vagrant;

--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entries_id_seq OWNER TO vagrant;

--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.entries_id_seq OWNED BY public.entries.id;


--
-- Name: event_defs; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.event_defs (
    code character varying(8) NOT NULL,
    name character varying(50) NOT NULL,
    etype public.event_types NOT NULL
);


ALTER TABLE public.event_defs OWNER TO vagrant;

--
-- Name: meet_division_events; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.meet_division_events (
    id integer NOT NULL,
    div_id integer NOT NULL,
    meet_id integer NOT NULL,
    event_code character varying(8) NOT NULL
);


ALTER TABLE public.meet_division_events OWNER TO vagrant;

--
-- Name: meet_division_events_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.meet_division_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.meet_division_events_id_seq OWNER TO vagrant;

--
-- Name: meet_division_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.meet_division_events_id_seq OWNED BY public.meet_division_events.id;


--
-- Name: meets; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.meets (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    date timestamp without time zone,
    host_school_id integer,
    description character varying(300),
    status public.meet_status NOT NULL,
    max_entries_per_athlete integer,
    max_team_entries_per_event integer
);


ALTER TABLE public.meets OWNER TO vagrant;

--
-- Name: meets_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.meets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.meets_id_seq OWNER TO vagrant;

--
-- Name: meets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.meets_id_seq OWNED BY public.meets.id;


--
-- Name: schools; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.schools (
    id integer NOT NULL,
    abbrev character varying(8) NOT NULL,
    name character varying(50) NOT NULL,
    league character varying(6),
    section character varying(12),
    city character varying(30),
    state character varying(2)
);


ALTER TABLE public.schools OWNER TO vagrant;

--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.schools_id_seq OWNER TO vagrant;

--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.schools_id_seq OWNED BY public.schools.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(64),
    password character varying(64),
    school_id integer,
    role public.user_roles NOT NULL
);


ALTER TABLE public.users OWNER TO vagrant;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO vagrant;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.athletes ALTER COLUMN id SET DEFAULT nextval('public.athletes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.divisions ALTER COLUMN id SET DEFAULT nextval('public.divisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meet_division_events ALTER COLUMN id SET DEFAULT nextval('public.meet_division_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meets ALTER COLUMN id SET DEFAULT nextval('public.meets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.schools ALTER COLUMN id SET DEFAULT nextval('public.schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: athletes; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.athletes (id, fname, lname, minitial, phone, school_id, div_id) FROM stdin;
1	Elijah	Alvarez		\N	2	2
2	Ricky	Alvarez		\N	2	1
3	Valerie	Barocio		\N	2	5
4	Hazel	Batara		\N	2	4
5	Daniel	Brathwaite		\N	2	2
6	Jaydan	Brathwaite		\N	2	1
7	Nerina	Campos		\N	2	6
8	Gregorio	Castro		\N	2	2
9	Mia	Corona		\N	2	5
10	Tristan	Cortez		\N	2	1
11	Jed	Dionisio		\N	2	2
12	Ramiro	Garcia		\N	2	3
13	Steven	Garcia		\N	2	3
14	Makiala	Gonzales		\N	2	5
15	Lorena	Gonzalez		\N	2	6
16	Manuel	Gonzalez		\N	2	2
17	Michelle	Gonzalez		\N	2	4
18	Sergio	Gonzalez		\N	2	2
19	Jennifer	Guarneros		\N	2	4
20	Paige	Gularte		\N	2	6
21	Sabria	Henry-Hunter		\N	2	5
22	Irving	Hermosillo		\N	2	3
23	Angel	Hernandez		\N	2	3
24	Claudia	Hernandez		\N	2	5
25	Jenning De'Amonte	Huntley		\N	2	3
26	Deandre	Jaime		\N	2	3
27	Brian	Jimenez		\N	2	3
28	Brian	Jimenez H		\N	2	2
29	Tayjak	Johnson		\N	2	6
30	Tyshell	Johnson		\N	2	6
31	Gladys	Jovel		\N	2	6
32	Ricardo	Juan		\N	2	2
33	Hector	Juarez		\N	2	3
34	Jeyri	Leon		\N	2	5
35	Sebastian	Lepe		\N	2	3
36	Jordi	Lizaola		\N	2	2
37	Alan	Llamas		\N	2	3
38	Jose	Lomeli		\N	2	2
39	Francisco	Maciel		\N	2	2
40	Carlos	Madrigal		\N	2	3
41	Fatima	Mandujano		\N	2	6
42	Andres	Martinez		\N	2	3
43	Antonio	Martinez		\N	2	2
44	Illiana	Martinez		\N	2	4
45	Kaymberlin	Mendoza		\N	2	6
46	Luis	Mendoza		\N	2	2
47	Andrei	Mina		\N	2	3
48	Joshua	Monctezuma		\N	2	2
49	Jared	Montalvo		\N	2	3
50	Jose	Morado		\N	2	3
51	Alexis	Morales		\N	2	1
52	Juan	Morales		\N	2	2
53	Sarah	Muradas		\N	2	5
54	Juan	Murillo		\N	2	3
55	Nathan	Nagata		\N	2	3
56	Darshana	Nahnd		\N	2	5
57	Esmeralda	Navarro		\N	2	5
58	Sophia	Nunez		\N	2	6
59	Xavier	Ortiz		\N	2	3
60	Nancy	Oviedo		\N	2	5
61	Koby	Pearson		\N	2	1
62	Efrain	Perez		\N	2	2
63	Gabriel	Perez		\N	2	1
64	Gerardo	Perez		\N	2	3
65	Frank	Pinedo		\N	2	3
66	Valerie	Quinonez		\N	2	6
67	Eleazar	Rico		\N	2	3
68	Aliyah	Robles		\N	2	5
69	Jonathan	Rodriguez		\N	2	2
70	Jonny	Rodriguez		\N	2	2
71	Michael	Sanchez		\N	2	2
72	Rigoberto	Sanchez		\N	2	3
73	Keighon	Serrano		\N	2	3
74	Jennie	Tang		\N	2	4
75	Cristian	Tonalixco		\N	2	2
76	Xavier	Torres		\N	2	2
77	Emmanuel	Valdez		\N	2	2
78	Nayeli	Valencia		\N	2	4
79	Vicentejordan	Vanderlipe		\N	2	1
80	Brian	Vasquez		\N	2	2
81	Kimberly	Yanez		\N	2	5
82	Colby	Aalgaard		\N	3	2
83	Cooper	Aiello		\N	3	3
84	Yanira	Alvarez Munoz		\N	3	5
85	Ashlyn	Archibeque		\N	3	6
86	Julian	Arreola		\N	3	2
87	Samuel	Arreola		\N	3	1
88	Richardo	Arreola Padilla		\N	3	3
89	John	Ash		\N	3	3
90	Adrian	Avila		\N	3	3
91	Adrian	Avila Hurtado		\N	3	3
92	Raul	Azcona		\N	3	3
93	Kenna	Barrett		\N	3	6
94	Cesar	Bedolla		\N	3	2
95	Ivan	Benitez		\N	3	2
96	Johnathan	Betz		\N	3	3
97	Chloe	Blackwood		\N	3	5
98	Annie	Breger		\N	3	6
99	Jack	Breger		\N	3	3
100	Kami	Brewer Pozzi		\N	3	5
101	Jenette	Cabrera		\N	3	6
102	Tristan	Camacho		\N	3	1
103	Chelsey	Cameron		\N	3	5
104	Michael	Campos		\N	3	1
105	Nancy	Campos		\N	3	6
106	Christina	Carvalho		\N	3	6
107	Christian	Casarez		\N	3	2
108	William	Castellanos		\N	3	2
109	Gustavo	Castillo		\N	3	1
110	Stephanie	Castillo		\N	3	5
111	Marianna	Castro		\N	3	5
112	Angel	Cesareo		\N	3	3
113	Mariah	Changco		\N	3	5
114	Robert	Chapa		\N	3	3
115	Arturo	Chavez		\N	3	3
116	Christian	Chavez		\N	3	1
117	Nezly	Chavez		\N	3	5
118	Mario Alfonso	Chavez Escobar		\N	3	2
119	Karina	Collins		\N	3	6
120	Shelbey	Conley		\N	3	6
121	Jose	Contreras Rodriguez		\N	3	2
122	Clarissa	Corona		\N	3	5
123	Angel	Cortes		\N	3	3
124	Samantha	Cortez		\N	3	6
125	Gabrielle	Cross		\N	3	6
126	Hailey	Cross		\N	3	5
127	Natalia	Del Moral		\N	3	4
128	Anthony	Delgado		\N	3	2
129	Brandon	Dell		\N	3	3
130	Evan	Duran		\N	3	1
131	Christian	Elizarraras		\N	3	3
132	Dillon	Engler		\N	3	2
133	Ariana	Espinoza		\N	3	4
134	Ryan	Evans		\N	3	1
135	Elian	Fileto		\N	3	3
136	Jordan	Finister		\N	3	3
137	Camille	Finley		\N	3	6
138	Lauren	Flaherty		\N	3	6
139	Ruben	Flores		\N	3	1
140	Ulices	Flores		\N	3	3
141	Hunter	Fu		\N	3	2
142	Marco	Gaitan		\N	3	3
143	Guadalupe	Galvan		\N	3	5
144	Oliver	Garcia		\N	3	3
145	Vanessa	Garcia		\N	3	5
146	Francesca	Giannotta		\N	3	4
147	Caitlyn	Gonzalez		\N	3	6
148	Jonathan	Gonzalez		\N	3	3
149	Yasmin	Gonzalez		\N	3	5
150	Eric	Green		\N	3	1
151	Abigail	Greene		\N	3	6
152	Ray	Guerrero		\N	3	3
153	Antonio	Guerrero Magdaleno		\N	3	1
154	Isaac	Gutierrez		\N	3	1
155	Jasmine	Gutierrez		\N	3	6
156	Niko	Gutierrez		\N	3	1
157	Romaldo	Gutierrez		\N	3	1
158	Benjamin	Hagan		\N	3	2
159	Nevaeh	Henry		\N	3	4
160	Fernando	Hernandez		\N	3	2
161	Jacob	Hernandez		\N	3	1
162	Kelvyn	Hernandez		\N	3	2
163	Vivian	Hernandez		\N	3	6
164	Sonya	Hervey		\N	3	5
165	McKenzie	Hoff		\N	3	5
166	Andre	Holder		\N	3	2
167	Trent	Hurtado		\N	3	2
168	Elizabeth	Jacuinde		\N	3	5
169	Adam	Jimenez		\N	3	1
170	Chris	Johst		\N	3	3
171	Cristal	Juarez Farfan		\N	3	5
172	Richard	Justo		\N	3	3
173	Ethan	Kimber		\N	3	3
174	Megan	Kistner		\N	3	6
175	Elli	Kliewer		\N	3	6
176	Mateo	Koch		\N	3	2
177	Pedro	Laguna		\N	3	2
178	Adrianna	Ledesma		\N	3	6
179	Sarah	Lima		\N	3	4
180	Holly	Lompa		\N	3	6
181	Dennys	Lopez		\N	3	5
182	Leslie	Lopez		\N	3	6
183	Marc	Lopez		\N	3	3
184	Joseph	Loredo		\N	3	2
185	Alexis	Lozano		\N	3	4
186	Samantha	Lucatero		\N	3	4
187	Che	Luevano		\N	3	1
188	Christopher	Maes		\N	3	3
189	Kyle	Manley		\N	3	3
190	Matthew	Manley		\N	3	3
191	Johana	Manzo		\N	3	5
192	Yazmin	Manzo		\N	3	4
193	Abraham	Manzo Hernandez		\N	3	1
194	Gerald	Maresh		\N	3	2
195	Brianna	Martin		\N	3	6
196	Edgar	Martinez		\N	3	1
197	Mia	Martinez		\N	3	6
198	Oscar	Martinez		\N	3	3
199	Badiana	Martinez Garcia		\N	3	5
200	Melissa	McGinnis		\N	3	6
201	Andres	Medina		\N	3	3
202	Christian	Medina		\N	3	3
203	Galilea	Medina Ruiz		\N	3	5
204	Nayeli	Medina Ruiz		\N	3	5
205	Joseph	Medrano		\N	3	2
206	Michelle	Medrano Sanchez		\N	3	6
207	Luis	Melo		\N	3	3
208	Adam	Mendoza		\N	3	3
209	Ivan	Mendoza		\N	3	1
210	Luis	Mendoza		\N	3	3
211	Robert	Mendoza		\N	3	2
212	Taryn	Mills		\N	3	4
213	Rafael	Miramontes		\N	3	2
214	Maritza	Molina		\N	3	6
215	Brittany	Moore		\N	3	4
216	Raighan	Mooshabad		\N	3	4
217	Manuel	Mora		\N	3	1
218	Axel	Mora Bravo		\N	3	1
219	Kimberly	Morales		\N	3	6
220	Samantha	Moran		\N	3	4
221	Brandon	Morgan		\N	3	2
222	Nathan	Morioka		\N	3	3
223	Anai	Murillo Gonzalez		\N	3	5
224	Brittany	Navarro		\N	3	6
225	Jessica	Neff		\N	3	5
226	Lisa	Nguyen		\N	3	6
227	Colby	Noble		\N	3	3
228	Ricardo	Nunez		\N	3	1
229	Hunter	Nye		\N	3	3
230	Trey	Oldakowski		\N	3	1
231	Sebastian	Orozco		\N	3	3
232	Chris	Outman		\N	3	3
233	Leah	Overman		\N	3	6
234	Carlos	Paniagua		\N	3	3
235	Chris	Parga		\N	3	3
236	Makenna	Parks		\N	3	6
237	Ella Shara	Pascua		\N	3	4
238	Daniel	Pasillas		\N	3	3
239	Julia	Pearson		\N	3	5
240	Steven	Pedersen		\N	3	2
241	Cheyenne	Peebles		\N	3	5
242	Dakota	Peebles		\N	3	6
243	Jimmy	Pelaiz		\N	3	2
244	Jesus	Perez		\N	3	1
245	Marcos	Perez		\N	3	2
246	Jacqueline	Perez Archibeque		\N	3	5
247	Aaliyah	Perillo		\N	3	4
248	Maya	Peterson		\N	3	4
249	Izia	Polanco		\N	3	2
250	Sara	Power		\N	3	6
251	Aiden	Pung		\N	3	2
252	Emily	Quinby		\N	3	5
253	Kathryn	Quinones		\N	3	6
254	Emiliano	Quintero		\N	3	1
255	Diego	Ramirez		\N	3	2
256	Lisbeth	Ramirez		\N	3	5
257	Lucero	Ramirez		\N	3	6
258	Emily	Ramirez Lagunas		\N	3	6
259	Jonathan	Ramos		\N	3	2
260	Kristian	Reardon		\N	3	2
261	Nolan	Redman		\N	3	2
262	Isaac	Regalado		\N	3	3
263	Peter	Reikowski		\N	3	3
264	Amber	Rericha		\N	3	4
265	Theodore	Rialson		\N	3	1
266	Nathaniel	Robles		\N	3	1
267	Brandon	Rodriguez		\N	3	3
268	James	Rodriguez		\N	3	2
269	Michelle	Rodriguez		\N	3	6
270	Rudy	Rodriguez		\N	3	1
271	Yazmin	Rodriguez		\N	3	6
272	Iris Yuliana	Roman Guzman		\N	3	6
273	Joseph	Romero		\N	3	1
274	Jasmine	Rosales Castillo		\N	3	5
275	Elliot	Ruiz		\N	3	2
276	Annie	Ruvalcaba		\N	3	5
277	Emma	Saguindel		\N	3	4
278	Michael	Sainz		\N	3	3
279	Alexander	San Miguel		\N	3	2
280	Bobby	Sanchez		\N	3	1
281	Joseph	Sanchez		\N	3	3
282	Katalina	Santiago		\N	3	5
283	Hailey	Schleeter-Powell		\N	3	6
284	Cameron	Schmuckle		\N	3	1
285	Carson	Schmuckle		\N	3	3
286	Erik	Servin		\N	3	1
287	Tyler	Shelton		\N	3	2
288	Ian	Sills		\N	3	2
289	Ryan	Sims		\N	3	6
290	Ashley	Smith		\N	3	6
291	Shaelynne	Smith		\N	3	6
292	Cloey	Stiers		\N	3	4
293	Mackenzie	Stoner		\N	3	5
294	Nicole	Taluban		\N	3	6
295	Cesar	Tapia		\N	3	2
296	Jada	Taylor		\N	3	5
297	Kaitlyn	Tedesco		\N	3	5
298	Ray	Tiscareno		\N	3	3
299	Grace	Tomasini		\N	3	4
300	Jerry	Torres		\N	3	3
301	Hannah	Trimble		\N	3	5
302	Jose	Velarde-Ruiz		\N	3	2
303	Summer	Vowinkle		\N	3	4
304	Hailee	Westrick		\N	3	4
305	Anna	Williams		\N	3	6
306	Alex	Avila		\N	4	1
307	Cesar	Avila		\N	4	2
308	Jacob	Avila		\N	4	3
309	Addam	Banuelos		\N	4	3
310	Arely	Campos		\N	4	5
311	Ella	De Amaral		\N	4	6
312	Angel	Garcia		\N	4	3
313	Martin	Guzman		\N	4	3
314	Gianna	Herbert		\N	4	4
315	Peyton	Masuen		\N	4	5
316	Daniel	Melendez		\N	4	2
317	Luis	Morales		\N	4	3
318	Jasmine	Rios		\N	4	5
319	Ethan	Woehrmann		\N	4	3
320	Travis	Wronksi		\N	4	3
321	Diego	Almaraz		\N	5	3
322	Ellie	Alto		\N	5	6
323	Sienna	Anderson		\N	5	4
324	Skye	Arle		\N	5	3
325	Sam	Boone		\N	5	3
326	Gabrielle	Borges		\N	5	4
327	Robert	Brown		\N	5	2
328	Savannah	Chappell		\N	5	4
329	Maxim	Clark		\N	5	3
330	Noah	Conklin		\N	5	1
331	Luke	Danzer		\N	5	2
332	Zach	DeZee		\N	5	2
333	Jessica	Dilullo		\N	5	6
334	Kiana	Dorantes		\N	5	4
335	Maggie	Ellison		\N	5	5
336	Peter	Ellison		\N	5	2
337	Svenn	Eyjolfsson		\N	5	1
338	Jamison	Farrington		\N	5	1
339	Alex	Faxon		\N	5	1
340	Tommaso	Feo		\N	5	3
341	Michelle	Foley		\N	5	4
342	Amaya	Gomez		\N	5	4
343	Jonathan	Hamilton		\N	5	2
344	Connor	Hatch		\N	5	3
345	Hunter	Heger		\N	5	1
346	Sebastian	Hendricks		\N	5	1
347	Gillian	Horak		\N	5	4
348	Connor	Houlihan		\N	5	2
349	Jessica	Hwang		\N	5	6
350	Tara	Jones		\N	5	6
351	Zachary	Keaton		\N	5	1
352	Noah	Kirsch		\N	5	3
353	Annalise	Krueger		\N	5	5
354	Nick	Krueger		\N	5	3
355	Ashley	Langley		\N	5	5
356	Soana	Laulotu		\N	5	5
357	Emily	Lazarus		\N	5	5
358	LiMei	Louis		\N	5	4
359	Andy	Ma		\N	5	3
360	Angel	Madrigal		\N	5	2
361	Orlandis	Mathes		\N	5	1
362	Natalie	Mazaud		\N	5	4
363	Scott	McMahon		\N	5	3
364	Michael	Meheen		\N	5	1
365	Muni	Mohamed		\N	5	1
366	Pascale	Montgomery		\N	5	4
367	Sarah	Morgan		\N	5	5
368	Robert	Mowry		\N	5	2
369	Gabrielle	Obligacion		\N	5	6
370	Nathan	Oros		\N	5	2
371	Cody	O'Rourke		\N	5	3
372	Miles	Prekoski		\N	5	1
373	Dalton	Quilty		\N	5	3
374	Adam	Ramlawi		\N	5	1
375	Vincent	Ravalin		\N	5	3
376	Julian	Resendiz		\N	5	3
377	Carlos	Robles		\N	5	3
378	Zach	Rossi		\N	5	3
379	Nathan	Schneiderman		\N	5	1
380	Katie	Short		\N	5	4
381	Nathan	Suess		\N	5	3
382	Elijah	Thompson		\N	5	3
383	Tio	Turrini-Smith		\N	5	3
384	Melanie	Verga		\N	5	5
385	Madison	Vernon		\N	5	4
386	Rashaan	Ward		\N	5	2
387	Rohan	Warner		\N	5	3
388	West	Whittaker		\N	5	3
389	Alexis	Aceves		\N	6	3
390	Melissa	Aceves		\N	6	6
391	Damian	Acosta		\N	6	3
392	Anissa	Aguilar		\N	6	4
393	Jesus	Alcantar		\N	6	3
394	Mireya	Alvarez		\N	6	4
395	Jacob	Amador		\N	6	2
396	Angel	Anguiano		\N	6	3
397	Miguel	Arreola		\N	6	2
398	Edgar	Arriola		\N	6	3
399	Jack	Banuelos		\N	6	2
400	Angel	Bautista		\N	6	1
401	Damian	Castaneda		\N	6	2
402	Ivan	Correa		\N	6	2
403	Matthew	Cortez		\N	6	2
404	Stephanie	Delgado		\N	6	6
405	Ismael	Duarte		\N	6	3
406	Cecilia	Espinoza		\N	6	5
407	Ulysses	Fierros		\N	6	3
408	Alex	Flores		\N	6	5
409	Nick	Flores		\N	6	3
410	Andrew	Funk		\N	6	1
411	Scott	Funk		\N	6	2
412	Miguel	Garcia		\N	6	3
413	Rodrigo	Garcia		\N	6	3
414	Greg	Gudino		\N	6	2
415	Juan	Hernandez		\N	6	2
416	Leslie	Hernandez		\N	6	4
417	Octavio	Hernandez		\N	6	2
418	Angel	Huerta		\N	6	3
419	Kathleen	Humphries		\N	6	6
420	Danielle	Javier		\N	6	4
421	Xavier	Jimenez		\N	6	1
422	Helga	Klemezdottir		\N	6	6
423	Athena	Landeros		\N	6	5
424	Maria	Lopez		\N	6	4
425	Ray	Lopez		\N	6	3
426	Iris	Manriquez		\N	6	6
427	Jorge	Manriquez		\N	6	3
428	Sarah	Marmolejo		\N	6	5
429	Alyssa	Martinez		\N	6	6
430	Mario	Martinez		\N	6	3
431	Jairo	Medina		\N	6	3
432	Faustino	Mendez		\N	6	3
433	Martin	Mendez		\N	6	2
434	Pablo	Mendoza		\N	6	2
435	Hernan	Mojica		\N	6	3
436	Christian	Patino		\N	6	2
437	Andy	Perez		\N	6	3
438	Jaime	Perez		\N	6	3
439	Nathan	Perez		\N	6	1
440	Jackie	Ramirez		\N	6	5
441	Jorge	Ramirez		\N	6	2
442	Genaro	Renteria		\N	6	3
443	Patricia	Resendiz		\N	6	6
444	Elias	Rico		\N	6	3
445	Gil	Rodriguez		\N	6	3
446	Julian	Rodriguez		\N	6	1
447	Marilyn	Rodriguez		\N	6	6
448	Veronica	Rodriguez		\N	6	4
449	Felix	Romero		\N	6	3
450	Jerome	Russell		\N	6	1
451	Luis	Sainz		\N	6	2
452	Bianca	Sanchez		\N	6	6
453	Jose	Sanchez		\N	6	3
454	Madison	Schweitzer		\N	6	4
455	Jazmin	Useda		\N	6	4
456	Jade	Valdez		\N	6	4
457	Jose	Valdez		\N	6	3
458	Jossue	Valdez		\N	6	3
459	Nael	Vazquez		\N	6	2
460	Pablo	Villasenor		\N	6	2
461	Jasmin	Yadao		\N	6	6
462	Celeste	Castro		\N	7	6
463	Daniel	Cerna		\N	7	2
464	Marina Jane	Cerna		\N	7	4
465	Andrew	Dang		\N	7	1
466	Alejandro	De Jesus		\N	7	3
467	Abraham	Dominquez Perez		\N	7	2
468	Daniel	Dominquez Perez		\N	7	1
469	Gladis	Garcia		\N	7	4
470	Rodrigo	Garcia		\N	7	2
471	Daniel	Gonzales		\N	7	1
472	Martin	Hernandez Ramos		\N	7	1
473	Isaac	Lopez		\N	7	1
474	Maria	Malagon		\N	7	6
475	Kristian	Maldonado		\N	7	3
476	Adrian	Martinez		\N	7	1
477	Ericka	Martinez		\N	7	5
478	Kenny	Martinez		\N	7	2
479	Sebastian	Meza		\N	7	1
480	Jesus	Ortega		\N	7	2
481	Luis	Perez		\N	7	3
482	Hector	Ramirez		\N	7	3
483	Alexis	Sanchez		\N	7	2
484	Francisco	Sanchez		\N	7	1
485	Jonathon	Villegas		\N	7	3
486	Noemi	Amezcua		\N	8	6
487	Nancy	Andrade		\N	8	5
488	Rodrigo	Andrade		\N	8	2
489	Gisela	Aparicio		\N	8	6
490	Jesus	Avalos		\N	8	3
491	Jhames	Bautista		\N	8	2
492	Daniela	Bedolla		\N	8	5
493	Joe	Black		\N	8	3
494	Emmitt	Blacks		\N	8	3
495	Luis	Briseño		\N	8	2
496	Elizabeth	Bryant		\N	8	6
497	Isidro	Cabrera		\N	8	3
498	Delaney	Carroll		\N	8	5
499	Elizabeth	Cazares		\N	8	6
500	Daisy	Chavez		\N	8	5
501	Emily	Chavez		\N	8	6
502	Xabier	Espinoza		\N	8	2
503	Cassidy	Flores		\N	8	6
504	Federico	Flores		\N	8	2
505	Freddy	Garcia		\N	8	3
506	Esteban	Gonzales		\N	8	3
507	Isaias	Gonzales		\N	8	2
508	Israel	Gutierrez		\N	8	3
509	Michael	Hart		\N	8	3
510	Isaac	Huerta		\N	8	2
511	Luis	Luna		\N	8	3
512	Justin	Mantel		\N	8	3
513	Miguel	Martinez		\N	8	3
514	Fausto	Medina		\N	8	1
515	Jalen	Mendez		\N	8	4
516	Roman	Munoz		\N	8	3
517	Cali	Murillo		\N	8	6
518	Kyle	Near		\N	8	3
519	Dylan	Oliveros		\N	8	2
520	Christian	Olmos		\N	8	3
521	Milagros	Ortega		\N	8	6
522	Kevin	Pena		\N	8	3
523	Stephanie	Politron		\N	8	6
524	Bella	Rava		\N	8	5
525	Jackie	Rios		\N	8	6
526	Lauren	Rist		\N	8	6
527	Ismael	Rocha		\N	8	3
528	Kajar	Rodgers		\N	8	4
529	Edith	Rojas		\N	8	6
530	Christian	Rose		\N	8	3
531	Ricardo	Ruelas		\N	8	3
532	Cody	Scrivner		\N	8	3
533	Grace	Shepherd		\N	8	5
534	Drury	Tankersley		\N	8	3
535	Jose V.	Torres		\N	8	3
536	Jackelyn	Zavala		\N	8	6
537	Rosa Elena	Acevedo		\N	9	6
538	Ali	Alkhawldy		\N	9	2
539	Bryan	Arredondo		\N	9	2
540	Leanne	Bagood		\N	9	5
541	Smilepreet	Bal		\N	9	6
542	Sukhneet	Bal		\N	9	3
543	David	Brooks		\N	9	3
544	Michael	Dronet		\N	9	3
545	Andrea	Escobedo		\N	9	4
546	Fermin	Gabot		\N	9	3
547	Michael	Garcia-Reyes		\N	9	2
548	Isaias	Guizar		\N	9	2
549	Karla	Herrera		\N	9	4
550	Leo	Isidro		\N	9	1
551	Jefferson	Lagudas		\N	9	3
552	Will	Leander		\N	9	3
553	Olivia	Lehman		\N	9	5
554	Daniel	Lucas		\N	9	3
555	Christopher	Plascencia		\N	9	2
556	Sierra	Ravinski		\N	9	5
557	Jackie	Reyes		\N	9	5
558	Bruno	Salcido		\N	9	3
559	Amadeus	Soria		\N	9	2
560	Robert	Valencia		\N	9	3
561	Alberto (A.J.)	Gastelum		\N	10	1
562	Jeb	Goldman		\N	10	2
563	Nicholas	Kawwas		\N	10	2
564	Adam	Kim		\N	10	2
565	Jack (Yize)	Ma		\N	10	1
566	Maryam	Moghaddami		\N	10	5
567	Jashan	Pabla		\N	10	1
568	Gabe	Piper		\N	10	3
569	Hannah	Selby		\N	10	5
570	Nathan	Walker		\N	10	3
571	Eric	Aldrich		\N	11	1
572	Kevin	Antonino		\N	11	3
573	Elizabeth	Armstrong		\N	11	4
574	Chloe	Chipman		\N	11	4
575	Conor	Driscoll-Natale		\N	11	1
576	Liam	Failor-Wass		\N	11	2
577	Corey	Friedenbach		\N	11	6
578	Kathryn	Haney		\N	11	5
579	Jack	Isacson		\N	11	1
580	Cameron	Kies		\N	11	2
581	Roxana	Ortiz		\N	11	5
582	Tristan	Peterson		\N	11	3
583	Erika	Pistor		\N	11	6
584	Catharina	Rogaczewski		\N	11	5
585	Milo	Rudman		\N	11	2
586	Anna	Spangrud		\N	11	5
587	Alex	Stout		\N	11	6
588	Sachiko	Tate		\N	11	6
589	Miles	Voenell		\N	11	1
590	Max	Afifi		\N	12	2
591	Tiago	Agostini		\N	12	1
592	Jake	Alt		\N	12	2
593	Hannah	Bennett		\N	12	4
594	Noor	Benny		\N	12	4
595	Taylor	Biondi		\N	12	5
596	Ray	Birkett		\N	12	1
597	Nick	Coppla		\N	12	3
598	Andrew	Crannell		\N	12	1
599	Batuhan	Demir		\N	12	2
600	Zach	Goodwin		\N	12	3
601	Mary	Grebing		\N	12	6
602	Courtney	Gurries		\N	12	4
603	Paul	Gurries		\N	12	3
604	Julius	Gutierrez		\N	12	1
605	Delson	Hays		\N	12	1
606	Rachel	House		\N	12	6
607	Gavin	James		\N	12	3
608	Thomas	Jameson		\N	12	1
609	Leo	Lauritzen		\N	12	1
610	Luca	Lauritzen		\N	12	3
611	Christine	Lee		\N	12	5
612	Henry	Loh		\N	12	3
613	India	Maaske		\N	12	6
614	Callie	McGraw		\N	12	5
615	Bryce	Montgomery		\N	12	1
616	Mike	Paff		\N	12	3
617	Taylor	Rainey		\N	12	5
618	Cameron	Reeves		\N	12	3
619	Robertson	Rice		\N	12	1
620	Bella	Rohrer		\N	12	4
621	Rachel	Sands		\N	12	5
622	Tyler	Smithro		\N	12	1
623	Parker	Staples		\N	12	6
624	Anna	Stefanou		\N	12	6
625	Will	Stefanou		\N	12	1
626	Nami	Suzuki		\N	12	6
627	Kulaea	Tulua		\N	12	6
628	Jada	Ware		\N	12	6
629	Jacob	Wren		\N	12	3
630	Jacob	Zeidberg		\N	12	2
631	Rosa	Aguilar		\N	13	6
632	Barbara	Avalos		\N	13	6
633	Carolina	Bishop		\N	13	6
634	Avery	Blanco		\N	13	6
635	Yvett	Cardenas		\N	13	5
636	Lauren	Dean		\N	13	4
637	Caitlyn	Giannini		\N	13	5
638	Kacey	Konya		\N	13	5
639	Ana	Leon		\N	13	6
640	Annie	Luo		\N	13	5
641	Ana Sofia	Magana		\N	13	6
642	Daniela	Mastretta		\N	13	6
643	Orlinka	Mitoko-Kereere		\N	13	6
644	Maya	Pruthi		\N	13	5
645	Mikayla	Revera		\N	13	6
646	Emma	Roffler		\N	13	6
647	Laurel	Wong		\N	13	5
648	Luis	Alba		\N	14	1
649	Lyla	Alderete		\N	14	6
650	Preciosa	Almaraz		\N	14	5
651	Marlene	Alonza		\N	14	6
652	Axel	Amaro		\N	14	1
653	Edward	Bachtel		\N	14	2
654	Alyssa	Borbon		\N	14	4
655	Jacob	Burgoz		\N	14	1
656	Ulises	Camarena		\N	14	3
657	Destiny	Carrillo		\N	14	5
658	Tamara	Castillo		\N	14	4
659	Christian	Chan		\N	14	3
660	Theresa	Chavez		\N	14	4
661	Daniel	Contawe		\N	14	3
662	Anselmo	De Jesus		\N	14	3
663	Gyrallene	Degarcia		\N	14	4
664	Belen	Flores		\N	14	5
665	Josiah	Freeman		\N	14	1
666	Gabriella	Gasca		\N	14	6
667	Aliyah	Gonzalez		\N	14	6
668	Christopher	Gonzalez		\N	14	2
669	Miguel	Gonzalez		\N	14	3
670	Ramona	Granillo		\N	14	4
671	Julian	Hernandez		\N	14	3
672	Jessica	Herrera		\N	14	5
673	Christopher	Huerta		\N	14	2
674	Leslie	Jimenez		\N	14	4
675	Neidi	Jorge		\N	14	5
676	Danyelle	Landeros		\N	14	4
677	Andrea	Martinez		\N	14	5
678	Estefani	Martinez		\N	14	5
679	Talia	Medina		\N	14	5
680	Elise	Melchor		\N	14	5
681	Adrian	Mellin		\N	14	1
682	Salvador	Meza		\N	14	2
683	Estefania	Montel		\N	14	4
684	Jonathan	Morales		\N	14	1
685	Marcus	Morales		\N	14	1
686	Crystal	Moreno		\N	14	4
687	Angel	Olivas		\N	14	2
688	Lauryn	Orozco		\N	14	6
689	Emanual	Ortega		\N	14	3
690	Andrew	Palmerin		\N	14	2
691	Miguel	Paredes		\N	14	1
692	Odalys	Paredes		\N	14	6
693	Victor	Phillips		\N	14	1
694	Arilene	Rios		\N	14	6
695	Vivianna	Robledo		\N	14	4
696	Jesus	Rodriguez		\N	14	2
697	Iris	Ruis		\N	14	5
698	Francisco	Sanchez		\N	14	1
699	Juan	Sanchez		\N	14	2
700	Iziah	Stone		\N	14	2
701	Isabel	Suarez		\N	14	5
702	Emily	Tinajero		\N	14	5
703	Raul	Trujillo		\N	14	3
704	Jose	Velasco		\N	14	1
705	Jose	Villalobos		\N	14	3
706	Krystal	Villegas		\N	14	4
707	Daisy	Virgen		\N	14	5
708	Denise	Virgen		\N	14	5
709	Treyon	Walker		\N	14	3
710	Emily	Adomako		\N	15	4
711	Lillian	Agar		\N	15	5
712	Cyrus	Barringer		\N	15	3
713	Gabrielle	Butler		\N	15	5
714	Ray	Cai		\N	15	3
715	Harry	Cheung		\N	15	3
716	Clarence	Chou		\N	15	1
717	Kieren	Daste		\N	15	1
718	Guido	Davi		\N	15	1
719	Eliza	Foster		\N	15	6
720	Grace	Ingram		\N	15	4
721	Alexander	Jensen		\N	15	3
722	Hale	Jones		\N	15	3
723	Philo	Katzman		\N	15	2
724	Carlin	Kempt		\N	15	6
725	Fauve	Koontz		\N	15	6
726	Cade	Laranang		\N	15	3
727	Nathan	Ma		\N	15	3
728	Colin	McEachen		\N	15	2
729	Alexander	Meredith		\N	15	3
730	Nicole	Naquin		\N	15	6
731	Helen	Nickerson		\N	15	6
732	Emilio	Orozco		\N	15	3
733	Tom	Phan		\N	15	3
734	Faith	Pinnow		\N	15	4
735	Annika	Roberts		\N	15	6
736	Erika	Roberts		\N	15	4
737	Charles	Shim		\N	15	3
738	Csilla	Smith		\N	15	6
739	Peter	Song		\N	15	3
740	Quynh	Stanoff		\N	15	6
741	Madison	Strickling		\N	15	6
742	Flora	Tamm		\N	15	5
743	Lucas	Tilly		\N	15	3
744	Jacob	Wang		\N	15	3
745	Lola	Wilcox		\N	15	4
746	Tony	Zhou		\N	15	3
747	Kaden	Agha		\N	16	3
748	Max	Burke		\N	16	2
749	Tristen	Laney		\N	16	2
750	Evan	Li		\N	16	3
751	Joseph	Rhee		\N	16	3
752	Adam	Shapiro		\N	16	2
753	Washakie	Tibbetts		\N	16	3
754	Jonathan	Zhao		\N	16	1
755	Gracie	Antrim-Kerr		\N	17	6
756	Uirassu	de Almeida		\N	17	3
757	Connor	Hetzler		\N	17	3
758	Keinan	Mactins		\N	17	2
759	Chloe	Ortiz		\N	17	6
760	Jasmin	schulz		\N	17	4
761	Elijah	Stone		\N	17	2
762	Anthony	Gonzalez		\N	6	1
763	Isabel	Mendoza		\N	6	4
764	Madisyn	Schweitzer		\N	6	4
765	Jesus	Trujillo		\N	6	2
766	Christian	Derbonne-Sipal		\N	9	3
767	Rina	Rossi		\N	11	4
768	Deaven	Keller		\N	12	3
769	Destiny	Hansen		\N	4	6
770	Nayeli	De Jesus		\N	7	5
771	Abraham	Dominguez Perez		\N	7	2
772	Jaime	Martinez		\N	7	3
773	Evelin	Meza		\N	7	6
774	Nancy	Ortiz		\N	7	5
775	Daniel	Perez		\N	7	1
776	Monica	Reyes		\N	7	5
777	Maria	Santiago		\N	7	5
778	Edward	Villagomez		\N	7	2
779	Gage	Barmes		\N	8	1
780	David	Black		\N	8	1
781	Cesar	Chavez		\N	8	1
782	George	Chavez		\N	8	3
783	Yoali	Cid		\N	8	5
784	Dominic	Conricode		\N	8	1
785	Felipe	Cruz		\N	8	1
786	Jesal	Desai		\N	8	2
787	Ricardo	Diaz		\N	8	1
788	Syrina	Espinoza		\N	8	4
789	Andy	Garcia		\N	8	1
790	Draven	Halstead		\N	8	1
791	Ashton	Headley		\N	8	1
792	Kyras	Headley		\N	8	1
793	Maria	Lobato		\N	8	4
794	Bryce	McEwen		\N	8	1
795	Luis	Morales		\N	8	1
796	Cassandra	Murillo		\N	8	5
797	Abel	Quintero		\N	8	1
798	Robert	Reyes		\N	8	3
799	Allen	Rocha		\N	8	1
800	Monica	Rodriguez		\N	8	5
801	Carson	Roylance		\N	8	2
802	Xavier	Salone		\N	8	1
803	Gloria	Sanchez		\N	8	4
804	Francisco	Sandoval		\N	8	1
805	Jose	Santos		\N	8	1
806	Pablo	Silva		\N	8	3
807	Daniel	Smith		\N	8	1
808	Carter	Tugel		\N	8	2
809	Francisco	Vega		\N	8	1
810	Miguel	Zendejas		\N	8	2
811	Hannia	Zuniga		\N	8	5
812	Edson	Ortiz		\N	9	2
813	Andrew	Perez		\N	9	3
814	Laura	Bauman		\N	16	6
815	Jaryd	Mercer		\N	16	2
816	Genevieve	Roeder-Hensley		\N	16	6
817	Jack	Whilden		\N	16	3
818	Quincy	Hendricks		\N	5	3
819	Colleen	Lang		\N	5	5
820	Olandis	Mathes		\N	5	1
821	Jennifer	Delgado		\N	6	5
822	Jonathan	Hernandez		\N	6	3
823	Angel	Vasquez		\N	6	3
824	Eric	Arias		\N	12	1
825	Thuy	Burshtein		\N	12	6
826	Miles	Moore		\N	12	1
827	Rebecca	Raschulewski		\N	12	4
828	Foster	Smith		\N	12	3
829	Estrella	Garcia		\N	14	5
830	Nathanial	Munk		\N	14	1
831	Iris	Ruiz		\N	14	5
832	Anthony	Aguilar		\N	18	1
833	Javier	Alcala		\N	18	3
834	Corina	Alcantar		\N	18	6
835	Cristina	Alcantar		\N	18	6
836	Jesus	Alfaro		\N	18	3
837	Andrew	Alonzo		\N	18	2
838	Adrian	Altamirano		\N	18	2
839	Herklin	Amaro		\N	18	3
840	Ricardo	Avalos		\N	18	3
841	Diego	Barajas		\N	18	3
842	Mitchell	Cabanas		\N	18	3
843	Luis	Canseco		\N	18	2
844	Ulises	Carbajal		\N	18	2
845	Nestor	Cardenas		\N	18	2
846	Miguel	Cardenaz		\N	18	3
847	Christopher	Castro		\N	18	1
848	Yamilet	Castro		\N	18	4
849	Monse	Cortez		\N	18	4
850	Yaqueline	Cruz		\N	18	6
851	Joanna	Cuevas		\N	18	6
852	Dulce	Del Aguilar		\N	18	4
853	Josue	Del Real		\N	18	3
854	Jesus	Delgadillo		\N	18	1
855	Maria	Diaz		\N	18	6
856	Isaac	Duenas		\N	18	2
857	Maria	Espinoza		\N	18	5
858	Yesenia	Espinoza		\N	18	5
859	Manuel	Figueroa		\N	18	3
860	Alexis	Garcia		\N	18	6
861	Desteney	Garcia		\N	18	6
862	Diana C	Garcia		\N	18	6
863	Mario	Garcia		\N	18	1
864	Viviana	Gonzalez		\N	18	5
865	Florencia	Gregorio		\N	18	6
866	Noralys	Hernandez		\N	18	5
867	Laura	Huitron		\N	18	4
868	Jesus	Iturbe		\N	18	3
869	Flavio	Jaramillo		\N	18	3
870	Maximos	Lopez		\N	18	1
871	Javion	Macias		\N	18	3
872	Francisco	Maciel		\N	18	3
873	Ilai	Maciel		\N	18	5
874	Peter	Maciel		\N	18	2
875	Kelly	Magana		\N	18	6
876	Jonathan	Martinez		\N	18	3
877	Luis	Martinez		\N	18	1
878	Carlos	Mendoza		\N	18	3
879	Joseph Jay	Montesclaros		\N	18	3
880	Emmanuel	Nieto		\N	18	3
881	Ariana	Ochoa		\N	18	5
882	Chris	Oseguera		\N	18	3
883	Joel	Ramirez		\N	18	2
884	Diego	Raya		\N	18	2
885	Antonio	Reyes		\N	18	3
886	Oscar	Rodriguez		\N	18	1
887	Ruben	Santana		\N	18	1
888	Moziah	Stewart		\N	18	3
889	Yaritza	Tinoco		\N	18	5
890	Rex	Tomimbang		\N	18	3
891	Kimberly	Torres		\N	18	6
892	Pablo	Trujillo		\N	18	1
893	Ruben	Vega		\N	18	2
894	Nathaniel	Velasquez		\N	18	1
895	Xochilth	Aguila		\N	19	4
896	Alan	Calderon		\N	19	3
897	Emiliano	Calvario		\N	19	2
898	Ivan	Carillo		\N	19	2
899	Alexis	Carlos-Soto		\N	19	2
900	Cristian	Cisneros		\N	19	2
901	Jacqueline	Gallardo		\N	19	5
902	Giselle	Garcia		\N	19	5
903	Nolvin	Guerra		\N	19	3
904	Anahí	Gurrola		\N	19	6
905	Clarissa	Guzman		\N	19	6
906	Diego	Hernandez		\N	19	3
907	Erick	Hernandez		\N	19	3
908	Mikayla	Kalem		\N	19	6
909	Karina	Maldonado		\N	19	5
910	Cristopher	Mansilla		\N	19	2
911	Joshua	Mendez		\N	19	3
912	Jose	Munoz		\N	19	3
913	Alexis	Nunez		\N	19	3
914	Carlos Anye	Nunez		\N	19	2
915	Margaret	Pazos		\N	19	6
916	Brene	Pita		\N	19	6
917	Juan	Plata		\N	19	2
918	Desiree	Rawls		\N	19	6
919	Keily	Romero		\N	19	5
920	Veronika	Romero		\N	19	6
921	Luis	Rosas		\N	19	2
922	Shanya	Singh		\N	19	5
923	Mina	Tameilau		\N	19	5
924	Max	Velazquez		\N	19	3
925	Tayjah	Johnson		\N	2	6
926	Ana	Rosas		\N	2	5
927	Randell	Yasay		\N	2	2
928	Rodrigo	Frias		\N	7	3
929	Luis	Meza		\N	7	3
930	Irvin	Vergara		\N	8	1
931	Francisco	Alejo		\N	20	2
932	Diego	Angeles		\N	20	2
933	Karina	Campos		\N	20	6
934	Juan	Centeno		\N	20	2
935	Grecia	Rodriguez		\N	20	6
936	Eduardo	Tletlepantzi		\N	20	3
937	Azjani	McGill		\N	21	1
938	Trinity	Mobley		\N	21	4
939	Itsel	Oseguera Reyes		\N	21	5
940	Fiaaulagi	Tautolo		\N	21	6
941	Carlos	Alfaro		\N	22	1
942	Ricardo	Alfaro		\N	22	3
943	Nayla	Anastacio		\N	22	5
944	Nicole	Anastacio		\N	22	6
945	Jesus	Avalos		\N	22	3
946	Brianna	Baughman		\N	22	6
947	Brenda	Bermudez		\N	22	6
948	Joseph	Bertao		\N	22	2
949	Fernando	Bugarin		\N	22	3
950	Brian	Cabanillas		\N	22	1
951	Eric	Castillo		\N	22	1
952	Alondra	Cazarez		\N	22	6
953	Jocelyn	Cazarez		\N	22	6
954	Joe	Chavez		\N	22	2
955	Andy	Chhoun		\N	22	3
956	Luis	Contridas		\N	22	3
957	Ruben	Cornejo		\N	22	1
958	Ashley	Corona		\N	22	5
959	Sarah	Delgado		\N	22	6
960	Brandon	Ducusin		\N	22	1
961	Shakira	Figueroa		\N	22	5
962	Alex	Flores		\N	22	2
963	Alexandra	Garcia		\N	22	6
964	Gabriel	Garcia		\N	22	1
965	Jiovanni	Garcia		\N	22	2
966	Guy	Gida		\N	22	3
967	Grayson	Griffin		\N	22	6
968	Abril	Guzman		\N	22	6
969	Odalys	Guzman		\N	22	6
970	Cuauhtemoc	Hernandez		\N	22	3
971	Elisa	Ibarra		\N	22	6
972	Hugo	Jimenez		\N	22	3
973	Justin	Landacre		\N	22	2
974	Esteban	Lemus		\N	22	2
975	Javier	Lemus		\N	22	3
976	Samuel	Madrigal		\N	22	1
977	Jacqueline	Magallon		\N	22	5
978	Edgar	Medina		\N	22	3
979	Salvador	Melo		\N	22	3
980	Faith	Mora		\N	22	5
981	Christian	Moreno		\N	22	2
982	Daniela	Munoz		\N	22	5
983	Fabrisio	Naranjo		\N	22	1
984	Shally	Navarro		\N	22	5
985	Ryan	Orlando		\N	22	3
986	Nayeli	Ortiz		\N	22	5
987	Reyna	Ortiz		\N	22	6
988	Gerardo	Perez		\N	22	3
989	Cameron	Reyes		\N	22	3
990	Eduardo	Rios		\N	22	2
991	Ricardo	Rios		\N	22	2
992	Yesenia	Rivera		\N	22	6
993	Linda	Rocha		\N	22	6
994	Abel	Ruiz		\N	22	2
995	Cindy	Rule		\N	22	5
996	Mayra	Salas		\N	22	5
997	Agustin	Saldivar		\N	22	2
998	Lupe	Sanchez		\N	22	2
999	Rafael	Tapia		\N	22	2
1000	Anthony	Valdivia		\N	22	2
1001	Stephanie	Valdivia		\N	22	5
1002	Konan	Van Lear		\N	22	2
1003	Ricardo	Vasquez		\N	22	1
1004	Itzel	Venegas		\N	22	5
1005	Constantino	Villegas		\N	22	2
1006	Bryan	Zamudio		\N	22	3
1007	Rodrick	Alberto		\N	23	3
1008	Nina	Arias		\N	23	6
1009	Benhur	Aromin		\N	23	3
1010	Cristo	Ayo		\N	23	3
1011	Alyssa	Ceja Pena		\N	23	6
1012	Victor	Ceja-Pena		\N	23	1
1013	Jesus	Diaz		\N	23	3
1014	Harry	Do		\N	23	3
1015	Cristopher	Escalante		\N	23	2
1016	Brittany	Fickas		\N	23	6
1017	Alex	Galvan		\N	23	2
1018	Isaiah	Guerra		\N	23	3
1019	Brandon	Gutierrez		\N	23	3
1020	Timothy	Hunter		\N	23	3
1021	Jimenez	Jesus		\N	23	2
1022	Christian	Lonero		\N	23	1
1023	Leslie	Medina		\N	23	6
1024	Makaelah	Napolitano		\N	23	5
1025	Johnny	Olivares		\N	23	2
1026	Elizabeth	Padilla		\N	23	5
1027	Justin	Robante		\N	23	3
1028	Julia	Ruiz		\N	23	6
1029	Christoper	Sibal		\N	23	3
1030	Daniel	Simo		\N	23	3
1031	Jake	Sotelo		\N	23	1
1032	Hiroki	Terada		\N	23	2
1033	Dennise	Torres-Alfaro		\N	23	6
1034	Lucas	Urquidez		\N	23	2
1035	Anesa	Vanderlipe		\N	23	6
1036	Samantha	Vargas		\N	23	6
1037	Andrea	Villalbos		\N	23	5
1038	Elijah	Washington		\N	23	2
1039	Daniel	Wason		\N	23	3
1040	Kelly	Kinon		\N	24	4
1041	Sophia	Lazzerini		\N	24	6
1042	Lauryn	Nimis		\N	24	6
1043	Grace	O'Connor		\N	24	4
1044	Jessie	Pavek		\N	24	5
1045	Chloe	Plumley		\N	24	6
1046	Mariah	Schlaper		\N	24	4
1047	Keona	Stopper		\N	24	6
1048	Christine	Wooler		\N	24	6
1049	Katie	Zernicke		\N	24	6
1050	Christian	Aguilar		\N	25	3
1051	Marco	Fragoso		\N	25	2
1052	Sam	Hernadez		\N	25	3
1053	Jordan	Jimanez		\N	25	3
1054	Cristo	Lopez		\N	25	1
1055	David	Madrigal		\N	25	2
1056	Bernie	Mora		\N	25	1
1057	Sofia	Nolasco		\N	25	5
1058	Amely	Zamora		\N	25	6
1059	Isaac	Zamora		\N	25	2
1060	Monica	Zepeda		\N	25	5
1061	Ben	Eastman		\N	26	1
1062	Brent	Eastman		\N	26	1
1063	Zach	Flores		\N	26	3
1064	Christian	Galardo		\N	26	3
1065	Pedro	Gomez		\N	26	3
1066	Kyle	Haas		\N	26	3
1067	Erin	Limbo		\N	26	2
1068	Miguel	Lizaola		\N	26	2
1069	Daudi	London		\N	26	3
1070	Emilio	Martinez		\N	26	3
1071	Christian	Neisonger		\N	26	3
1072	Micah	Olivas		\N	26	1
1073	Thomas	Padilla		\N	26	2
1074	Arturo	Ponce		\N	26	3
1075	Andrew	Rivera		\N	26	2
1076	Sam	Robinson		\N	26	3
1077	Octavio	Rubio		\N	26	3
1078	Oscar	Rubio		\N	26	2
1079	Caspar	Silvania		\N	26	2
1080	Phil	Sites		\N	26	1
1081	Zack	Taylor		\N	26	3
1082	Anthony	Villegas		\N	26	1
1083	Beau	Winslow		\N	26	3
1084	Veronica	Aguilar		\N	27	6
1085	Sergio	Arreola		\N	27	3
1086	Lilly	Baez		\N	27	6
1087	Thomas	Balian		\N	27	3
1088	Ricardo	Beltran		\N	27	2
1089	Isaiah	Brown		\N	27	3
1090	Cole	Burk		\N	27	2
1091	Tully	Cannon		\N	27	1
1092	Christina	Chagnon		\N	27	5
1093	Jonathan	Chagnon		\N	27	3
1094	Kimi	Chin		\N	27	6
1095	Kayla	Clayton		\N	27	6
1096	Wyatt	Conner		\N	27	3
1097	Elle	Froistad		\N	27	6
1098	Isaaic	Gallegos		\N	27	3
1099	Nicole	Gorczyca		\N	27	5
1100	Haley	Hibbs		\N	27	5
1101	Taylor	Hibino		\N	27	4
1102	Brisia	Martinez		\N	27	5
1103	Alfredo	Mejia		\N	27	3
1104	Fermin	Moreno		\N	27	1
1105	Dante	Morr		\N	27	6
1106	Brandon	Partido		\N	27	3
1107	Jonathan	Partido		\N	27	3
1108	Brett	Reade		\N	27	3
1109	Carlos	Reyes		\N	27	3
1110	Carl	Richardson		\N	27	1
1111	Andres	Rodriguez		\N	27	3
1112	Nicole	Stearns		\N	27	6
1113	Andy	Tavares		\N	27	1
1114	Peter	Tavares		\N	27	3
1115	Matthew	Vasher		\N	27	3
1116	Charlie	Jung		\N	28	3
1117	Jeremy	Miller		\N	28	3
1118	Anna	Mokkapati		\N	28	4
1119	Ryan	Negrette		\N	28	3
1120	Ursula	Ott		\N	28	6
1121	Pedro	Alcantara		\N	29	3
1122	Braydon	Arnold		\N	29	3
1123	Daniela	Castro		\N	29	6
1124	Jesse	Mandujano		\N	29	2
1125	Xavier	Marinez		\N	29	2
1126	Raul	Martinez		\N	29	3
1127	Carlos	Santiago		\N	29	2
1128	Pablo	Valle		\N	29	1
1129	Zach	Ahern		\N	5	2
1130	Angelyna	Ragsdale		\N	8	5
1131	Carson	Coppinger		\N	5	3
1132	Jasmin	Schulz		\N	17	4
1133	Ashley	Bruning		\N	10	4
1134	Jordan	Matthew		\N	10	2
1135	Taegan	Dunton		\N	11	1
1136	Lauren	Hubbell		\N	11	5
1137	Sahil	Patel		\N	11	1
1138	Tai	White		\N	11	3
1139	Matthew	Lo		\N	12	2
1140	Joseph	Cohen		\N	15	3
1141	Belle	Kreitler		\N	15	5
1142	Francesco	Carriglio		\N	16	1
1143	Stuart	Carruthers		\N	16	1
1144	Natalie	Sanford		\N	16	5
1145	Henry	Xiang		\N	16	2
1146	Kathryn	Yeager		\N	16	5
1147	Taylor	Colello		\N	30	5
1148	Zach	Davidson		\N	30	3
1149	Carla	McEwen		\N	4	5
1150	Jahziel	Alfaro		\N	31	1
1151	Hugo	Ayala		\N	31	3
1152	Guadalupe	Contreras		\N	31	5
1153	Noely	Contreras		\N	31	5
1154	Marlen	De La Cruz		\N	31	4
1155	Jessica	De Reza		\N	31	4
1156	Charley	Garcia		\N	31	2
1157	Daniela	Garcia		\N	31	6
1158	Vanessa	Garcia		\N	31	5
1159	Miguel	Gutierrez		\N	31	3
1160	Tais	Hernandez		\N	31	5
1161	Axel	Martinez		\N	31	2
1162	Liliana	Mireles		\N	31	4
1163	Christian	Napoles		\N	31	3
1164	Daniel	Rivera		\N	31	3
1165	Lucy	Robles		\N	31	6
1166	Tyler	Smithtro		\N	12	1
1167	Symone	Crawley		\N	32	6
1168	Edward	De Guzman		\N	32	3
1169	Kamoana	De Guzman		\N	32	1
1170	Ethan	Fry		\N	32	1
1171	Makenzie	Giovannoni		\N	32	6
1172	Eliesse	Kwok		\N	32	6
1173	Joshua	Montenegro		\N	32	1
1174	Catherine	Slevin		\N	32	6
1175	Rebecca	Slevin		\N	32	6
1176	Kaleb	Windsor		\N	32	3
1177	Valeria	Cortina		\N	13	4
1178	Alicia	Rector		\N	13	5
1179	Eric	Wright		\N	30	3
1180	Leo	Ruiz		\N	6	3
\.


--
-- Name: athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.athletes_id_seq', 1180, true);


--
-- Data for Name: divisions; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.divisions (id, gender, grade, adult_child) FROM stdin;
1	M	6	child
2	M	7	child
3	M	8	child
4	F	6	child
5	F	7	child
6	F	8	child
\.


--
-- Name: divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.divisions_id_seq', 6, true);


--
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.entries (id, athlete_id, mde_id, mark, mark_type) FROM stdin;
1	68	5	13.47	seconds
2	101	6	13.74	seconds
3	98	6	13.90	seconds
4	271	6	14.00	seconds
5	294	6	14.00	seconds
6	110	5	14.00	seconds
7	178	6	14.20	seconds
8	151	6	14.50	seconds
9	125	6	14.50	seconds
10	233	6	14.50	seconds
11	15	6	14.58	seconds
12	253	6	15.10	seconds
13	138	6	15.50	seconds
14	14	5	15.65	seconds
15	31	6	16.07	seconds
16	305	6	16.20	seconds
17	81	5	16.38	seconds
18	226	6	16.60	seconds
19	180	6	\N	\N
20	29	6	\N	\N
21	272	6	\N	\N
22	122	5	14.20	seconds
23	215	4	14.20	seconds
24	103	5	14.50	seconds
25	164	5	14.50	seconds
26	297	5	15.00	seconds
27	168	5	15.10	seconds
28	247	4	15.10	seconds
29	301	5	15.20	seconds
30	84	5	15.24	seconds
31	117	5	15.30	seconds
32	282	5	15.40	seconds
33	199	5	15.50	seconds
34	111	5	15.60	seconds
35	149	5	16.30	seconds
36	74	4	16.44	seconds
37	171	5	16.60	seconds
38	191	5	16.70	seconds
39	97	5	\N	\N
40	145	5	\N	\N
41	146	4	\N	\N
42	204	5	\N	\N
43	237	4	\N	\N
44	248	4	\N	\N
45	296	5	\N	\N
46	304	4	\N	\N
47	239	5	\N	\N
48	159	4	\N	\N
49	256	5	\N	\N
50	66	12	27.74	seconds
51	101	12	28.74	seconds
52	110	11	29.00	seconds
53	125	12	29.19	seconds
54	214	12	29.40	seconds
55	271	12	30.00	seconds
56	233	12	30.66	seconds
57	294	12	31.00	seconds
58	180	12	31.12	seconds
59	253	12	31.40	seconds
60	138	12	32.00	seconds
61	119	12	32.00	seconds
62	31	12	34.35	seconds
63	305	12	35.53	seconds
64	57	11	\N	\N
65	29	12	\N	\N
66	178	12	\N	\N
67	272	12	\N	\N
68	122	11	30.00	seconds
69	103	11	31.00	seconds
70	164	11	31.00	seconds
71	215	10	31.00	seconds
72	297	11	31.40	seconds
73	168	11	31.60	seconds
74	247	10	31.66	seconds
75	84	11	32.70	seconds
76	301	11	33.20	seconds
77	117	11	33.40	seconds
78	199	11	33.50	seconds
79	171	11	35.64	seconds
80	191	11	\N	\N
81	74	10	\N	\N
82	97	11	\N	\N
83	145	11	\N	\N
84	146	10	\N	\N
85	248	10	\N	\N
86	282	11	\N	\N
87	296	11	\N	\N
88	304	10	\N	\N
89	159	10	\N	\N
90	256	11	\N	\N
91	252	17	63.86	seconds
92	126	17	64.00	seconds
93	214	18	65.00	seconds
94	57	17	65.08	seconds
95	119	18	70.00	seconds
96	252	23	156.70	seconds
97	236	24	157.00	seconds
98	175	24	157.70	seconds
99	7	24	167.18	seconds
100	53	23	181.31	seconds
101	41	24	\N	\N
102	34	23	\N	\N
103	126	23	\N	\N
104	133	22	178.44	seconds
105	56	23	187.79	seconds
106	299	22	194.45	seconds
107	143	23	197.81	seconds
108	127	22	\N	\N
109	192	22	\N	\N
110	303	22	\N	\N
111	175	30	340.28	seconds
112	195	30	352.09	seconds
113	236	30	354.52	seconds
114	124	30	359.98	seconds
115	113	29	370.55	seconds
116	7	30	370.80	seconds
117	9	29	385.03	seconds
118	17	28	386.27	seconds
119	53	29	399.87	seconds
120	44	28	408.19	seconds
121	24	29	455.42	seconds
122	41	30	\N	\N
123	34	29	\N	\N
124	58	30	\N	\N
125	133	28	408.38	seconds
126	56	29	413.51	seconds
127	192	28	416.74	seconds
128	60	29	428.03	seconds
129	264	28	432.88	seconds
130	143	29	435.57	seconds
131	276	29	442.39	seconds
132	3	29	458.93	seconds
133	303	28	499.51	seconds
134	127	28	503.49	seconds
135	19	28	\N	\N
136	78	28	\N	\N
137	4	28	\N	\N
138	299	28	\N	\N
139	195	36	760.39	seconds
140	124	36	763.21	seconds
141	113	35	793.41	seconds
142	9	35	797.56	seconds
143	17	34	845.25	seconds
144	44	34	900.90	seconds
145	58	36	\N	\N
146	60	35	951.90	seconds
147	264	34	1089.70	seconds
148	276	35	\N	\N
149	3	35	\N	\N
150	19	34	\N	\N
151	78	34	\N	\N
152	4	34	\N	\N
153	291	60	18.21	seconds
154	219	60	20.83	seconds
155	151	60	20.96	seconds
156	257	60	20.99	seconds
157	20	60	\N	\N
158	226	60	\N	\N
159	269	60	\N	\N
160	241	59	18.87	seconds
161	274	59	\N	\N
162	111	59	\N	\N
163	242	72	53.44	seconds
164	219	72	58.04	seconds
165	257	72	58.04	seconds
166	151	72	58.74	seconds
167	226	72	66.64	seconds
168	174	72	\N	\N
169	269	72	\N	\N
170	241	71	56.44	seconds
171	274	71	\N	\N
172	111	71	\N	\N
173	204	71	\N	\N
174	290	96	321.00	inches
175	68	95	313.00	inches
176	200	96	309.00	inches
177	14	95	279.00	inches
178	21	95	259.50	inches
179	197	96	245.00	inches
180	224	96	225.50	inches
181	155	96	225.00	inches
182	206	96	219.00	inches
183	258	96	217.50	inches
184	106	96	211.00	inches
185	30	96	\N	\N
186	147	96	\N	\N
187	250	96	\N	\N
188	163	96	\N	\N
189	85	96	\N	\N
190	237	94	283.00	inches
191	225	95	252.00	inches
192	100	95	250.50	inches
193	277	94	212.00	inches
194	181	95	195.00	inches
195	212	94	192.00	inches
196	292	94	165.50	inches
197	223	95	\N	\N
198	165	95	\N	\N
199	179	94	\N	\N
200	186	94	\N	\N
201	203	95	\N	\N
202	293	95	\N	\N
203	246	95	\N	\N
204	250	90	968.00	inches
205	68	89	905.00	inches
206	14	89	857.00	inches
207	290	90	801.00	inches
208	258	90	695.00	inches
209	200	90	693.00	inches
210	21	89	679.00	inches
211	206	90	637.00	inches
212	106	90	631.00	inches
213	155	90	625.00	inches
214	197	90	560.00	inches
215	224	90	478.00	inches
216	30	90	\N	\N
217	147	90	\N	\N
218	163	90	\N	\N
219	85	90	\N	\N
220	225	89	784.00	inches
221	237	88	688.00	inches
222	181	89	584.00	inches
223	100	89	553.00	inches
224	277	88	546.00	inches
225	212	88	530.00	inches
226	292	88	477.00	inches
227	223	89	\N	\N
228	165	89	\N	\N
229	179	88	\N	\N
230	186	88	\N	\N
231	203	89	\N	\N
232	293	89	\N	\N
233	246	89	\N	\N
234	137	102	62.00	inches
235	98	102	56.00	inches
236	29	102	\N	\N
237	220	100	54.00	inches
238	149	101	\N	\N
239	239	101	\N	\N
240	180	108	102.00	inches
241	45	108	78.00	inches
242	81	107	72.00	inches
243	174	108	72.00	inches
244	182	108	72.00	inches
245	289	108	\N	\N
246	219	108	\N	\N
247	226	108	\N	\N
248	282	107	\N	\N
249	98	78	179.00	inches
250	137	78	177.00	inches
251	24	77	132.50	inches
252	66	78	\N	\N
253	105	78	\N	\N
254	120	78	\N	\N
255	93	78	\N	\N
256	233	78	\N	\N
257	283	78	\N	\N
258	220	76	154.00	inches
259	241	77	152.00	inches
260	216	76	139.00	inches
261	185	76	98.00	inches
262	146	76	\N	\N
263	149	77	\N	\N
264	239	77	\N	\N
265	98	84	402.50	inches
266	137	84	399.00	inches
267	105	84	\N	\N
268	120	84	\N	\N
269	283	84	\N	\N
270	241	83	304.00	inches
271	220	82	293.50	inches
272	216	82	273.50	inches
273	93	84	\N	\N
274	185	82	\N	\N
275	99	3	11.33	seconds
276	108	2	11.80	seconds
277	148	3	11.90	seconds
278	285	3	12.00	seconds
279	89	3	12.02	seconds
280	208	3	12.04	seconds
281	190	3	12.18	seconds
282	229	3	12.20	seconds
283	189	3	12.29	seconds
284	6	1	12.31	seconds
285	65	3	12.33	seconds
286	61	1	12.84	seconds
287	131	3	13.00	seconds
288	112	3	13.20	seconds
289	26	3	13.46	seconds
290	202	3	13.64	seconds
291	183	3	13.80	seconds
292	234	3	13.80	seconds
293	173	3	14.10	seconds
294	25	3	\N	\N
295	47	3	\N	\N
296	79	1	\N	\N
297	50	3	\N	\N
298	298	3	\N	\N
299	136	3	\N	\N
300	83	3	\N	\N
301	254	1	12.00	seconds
302	102	1	12.30	seconds
303	169	1	12.40	seconds
304	209	1	12.40	seconds
305	11	2	12.96	seconds
306	244	1	13.10	seconds
307	150	1	13.20	seconds
308	1	2	13.21	seconds
309	70	2	13.27	seconds
310	52	2	13.31	seconds
311	261	2	13.40	seconds
312	130	1	13.40	seconds
313	134	1	13.40	seconds
314	2	1	13.48	seconds
315	167	2	13.60	seconds
316	213	2	13.60	seconds
317	80	2	13.68	seconds
318	75	2	13.75	seconds
319	38	2	13.91	seconds
320	166	2	14.00	seconds
321	218	1	14.10	seconds
322	104	1	14.50	seconds
323	63	1	14.90	seconds
324	71	2	15.46	seconds
325	43	2	\N	\N
326	69	2	\N	\N
327	51	1	\N	\N
328	10	1	\N	\N
329	87	1	\N	\N
330	109	1	\N	\N
331	139	1	\N	\N
332	157	1	\N	\N
333	217	1	\N	\N
334	230	1	\N	\N
335	259	2	\N	\N
336	273	1	\N	\N
337	280	1	\N	\N
338	187	1	\N	\N
339	94	2	\N	\N
340	99	9	23.00	seconds
341	108	8	23.50	seconds
342	208	9	24.50	seconds
343	144	9	25.00	seconds
344	229	9	25.00	seconds
345	285	9	25.00	seconds
346	37	9	25.02	seconds
347	148	9	25.40	seconds
348	6	7	25.52	seconds
349	89	9	25.58	seconds
350	189	9	25.73	seconds
351	27	9	26.12	seconds
352	5	8	26.22	seconds
353	131	9	26.29	seconds
354	47	9	26.49	seconds
355	112	9	27.00	seconds
356	202	9	27.50	seconds
357	35	9	27.64	seconds
358	234	9	28.60	seconds
359	173	9	28.74	seconds
360	22	9	\N	\N
361	23	9	\N	\N
362	25	9	\N	\N
363	65	9	\N	\N
364	12	9	\N	\N
365	39	8	\N	\N
366	50	9	\N	\N
367	26	9	\N	\N
368	42	9	\N	\N
369	183	9	\N	\N
370	298	9	\N	\N
371	83	9	\N	\N
372	102	7	25.00	seconds
373	209	7	25.00	seconds
374	211	8	25.00	seconds
375	141	8	25.50	seconds
376	284	7	25.70	seconds
377	265	7	26.00	seconds
378	52	8	26.78	seconds
379	279	8	27.00	seconds
380	70	8	27.12	seconds
381	2	7	27.31	seconds
382	11	8	27.52	seconds
383	134	7	27.60	seconds
384	150	7	27.80	seconds
385	244	7	27.80	seconds
386	261	8	28.00	seconds
387	166	8	28.20	seconds
388	38	8	28.23	seconds
389	80	8	28.53	seconds
390	130	7	28.70	seconds
391	230	7	29.74	seconds
392	63	7	\N	\N
393	43	8	\N	\N
394	1	8	\N	\N
395	69	8	\N	\N
396	51	7	\N	\N
397	10	7	\N	\N
398	75	8	\N	\N
399	167	8	\N	\N
400	213	8	\N	\N
401	286	7	\N	\N
402	109	7	\N	\N
403	139	7	\N	\N
404	161	7	\N	\N
405	218	7	\N	\N
406	217	7	\N	\N
407	259	8	\N	\N
408	273	7	\N	\N
409	280	7	\N	\N
410	187	7	\N	\N
411	144	15	55.00	seconds
412	23	15	55.56	seconds
413	37	15	56.04	seconds
414	42	15	57.44	seconds
415	35	15	65.79	seconds
416	22	15	\N	\N
417	12	15	\N	\N
418	141	14	57.00	seconds
419	211	14	57.00	seconds
420	284	13	60.00	seconds
421	279	14	\N	\N
422	32	14	\N	\N
423	265	13	\N	\N
424	286	13	\N	\N
425	161	13	\N	\N
426	222	21	131.73	seconds
427	275	20	131.73	seconds
428	39	20	133.94	seconds
429	201	21	143.34	seconds
430	115	21	143.73	seconds
431	129	21	144.55	seconds
432	232	21	146.32	seconds
433	13	21	146.90	seconds
434	90	21	159.44	seconds
435	72	21	\N	\N
436	46	20	\N	\N
437	48	20	\N	\N
438	207	21	\N	\N
439	88	21	\N	\N
440	270	19	143.90	seconds
441	92	21	\N	\N
442	162	20	\N	\N
443	245	20	\N	\N
444	121	20	\N	\N
445	177	20	\N	\N
446	205	20	\N	\N
447	156	19	\N	\N
448	266	19	\N	\N
449	193	19	\N	\N
450	275	26	293.29	seconds
451	210	27	293.87	seconds
452	184	26	299.81	seconds
453	123	27	303.54	seconds
454	194	26	305.57	seconds
455	36	26	306.20	seconds
456	13	27	306.52	seconds
457	16	26	320.59	seconds
458	207	27	323.36	seconds
459	48	26	323.45	seconds
460	201	27	328.55	seconds
461	77	26	337.52	seconds
462	232	27	344.31	seconds
463	90	27	345.30	seconds
464	18	26	\N	\N
465	72	27	\N	\N
466	46	26	\N	\N
467	222	27	\N	\N
468	107	26	\N	\N
469	88	27	\N	\N
470	116	25	312.92	seconds
471	115	27	314.45	seconds
472	154	25	319.78	seconds
473	270	25	319.83	seconds
474	129	27	326.13	seconds
475	121	26	332.45	seconds
476	245	26	335.46	seconds
477	302	26	336.78	seconds
478	86	26	337.08	seconds
479	162	26	338.69	seconds
480	92	27	381.26	seconds
481	28	26	\N	\N
482	176	26	\N	\N
483	177	26	\N	\N
484	205	26	\N	\N
485	156	25	\N	\N
486	228	25	\N	\N
487	266	25	\N	\N
488	193	25	\N	\N
489	123	33	643.80	seconds
490	210	33	647.20	seconds
491	16	32	\N	\N
492	77	32	\N	\N
493	36	32	\N	\N
494	18	32	\N	\N
495	194	32	\N	\N
496	107	32	\N	\N
497	116	31	690.80	seconds
498	154	31	699.80	seconds
499	86	32	733.10	seconds
500	28	32	\N	\N
501	121	32	\N	\N
502	176	32	\N	\N
503	228	31	\N	\N
504	302	32	\N	\N
505	260	50	11.58	seconds
506	132	50	12.14	seconds
507	288	50	12.67	seconds
508	295	50	12.90	seconds
509	87	49	\N	\N
510	104	49	\N	\N
511	262	63	15.40	seconds
512	128	62	15.80	seconds
513	96	63	18.17	seconds
514	54	63	18.22	seconds
515	267	63	18.50	seconds
516	170	63	20.22	seconds
517	263	63	22.01	seconds
518	8	62	\N	\N
519	128	68	43.92	seconds
520	267	69	45.01	seconds
521	54	69	46.53	seconds
522	96	69	47.38	seconds
523	170	69	51.23	seconds
524	8	68	53.23	seconds
525	173	69	\N	\N
526	260	68	47.50	seconds
527	249	68	52.12	seconds
528	288	68	54.04	seconds
529	87	67	\N	\N
530	104	67	\N	\N
531	295	68	\N	\N
532	238	93	492.00	inches
533	227	93	473.00	inches
534	76	92	447.00	inches
535	235	93	395.50	inches
536	50	93	367.00	inches
537	33	93	364.00	inches
538	67	93	347.50	inches
539	64	93	347.00	inches
540	140	93	344.00	inches
541	188	93	328.00	inches
542	55	93	303.00	inches
543	59	93	\N	\N
544	172	93	\N	\N
545	114	93	\N	\N
546	95	92	429.50	inches
547	221	92	393.00	inches
548	118	92	383.00	inches
549	251	92	373.50	inches
550	240	92	362.00	inches
551	243	92	343.50	inches
552	196	91	335.00	inches
553	255	92	333.00	inches
554	80	92	\N	\N
555	82	92	\N	\N
556	150	91	\N	\N
557	94	92	\N	\N
558	238	87	1128.50	inches
559	227	87	1126.00	inches
560	33	87	1103.00	inches
561	67	87	1061.00	inches
562	50	87	1054.00	inches
563	76	86	1048.00	inches
564	235	87	1027.00	inches
565	64	87	959.00	inches
566	140	87	876.00	inches
567	188	87	837.00	inches
568	55	87	816.00	inches
569	59	87	\N	\N
570	172	87	\N	\N
571	114	87	\N	\N
572	251	86	1208.00	inches
573	221	86	1128.00	inches
574	118	86	1096.00	inches
575	95	86	1050.00	inches
576	196	85	870.00	inches
577	255	86	789.00	inches
578	243	86	759.00	inches
579	240	86	721.00	inches
580	80	86	\N	\N
581	82	86	\N	\N
582	94	86	\N	\N
583	27	99	68.00	inches
584	262	99	68.00	inches
585	49	99	64.00	inches
586	142	99	62.00	inches
587	73	99	\N	\N
588	62	98	\N	\N
589	5	98	\N	\N
590	278	99	\N	\N
591	107	98	\N	\N
592	2	97	\N	\N
593	141	98	\N	\N
594	249	98	\N	\N
595	158	98	\N	\N
596	265	97	\N	\N
597	259	98	\N	\N
598	263	105	144.00	inches
599	267	105	126.00	inches
600	152	105	126.00	inches
601	183	105	120.00	inches
602	135	105	120.00	inches
603	91	105	108.00	inches
604	198	105	108.00	inches
605	61	103	102.00	inches
606	79	103	96.00	inches
607	40	105	\N	\N
608	49	105	\N	\N
609	27	105	\N	\N
610	73	105	\N	\N
611	71	104	84.00	inches
612	213	104	\N	\N
613	287	104	\N	\N
614	102	103	\N	\N
615	153	103	\N	\N
616	262	75	218.00	inches
617	300	75	210.00	inches
618	49	75	195.25	inches
619	23	75	178.00	inches
620	190	75	167.00	inches
621	112	75	159.00	inches
622	231	75	158.00	inches
623	13	75	136.75	inches
624	25	75	\N	\N
625	73	75	\N	\N
626	62	74	\N	\N
627	281	75	\N	\N
628	278	75	\N	\N
629	142	75	\N	\N
630	136	75	\N	\N
631	132	74	223.00	inches
632	265	73	209.00	inches
633	169	73	209.00	inches
634	254	73	204.00	inches
635	249	74	183.00	inches
636	166	74	183.00	inches
637	130	73	174.00	inches
638	268	74	134.00	inches
639	158	74	\N	\N
640	157	73	\N	\N
641	259	74	\N	\N
642	99	81	470.50	inches
643	262	81	468.50	inches
644	300	81	466.00	inches
645	142	81	456.00	inches
646	231	81	408.50	inches
647	152	81	\N	\N
648	136	81	\N	\N
649	254	79	462.50	inches
650	169	79	435.00	inches
651	162	80	399.50	inches
652	160	80	399.00	inches
653	249	80	397.50	inches
654	268	80	388.00	inches
655	130	79	373.00	inches
656	96	81	\N	\N
657	158	80	\N	\N
658	645	114	12.15	seconds
659	647	113	13.50	seconds
660	632	114	14.00	seconds
661	588	114	14.50	seconds
662	584	113	14.59	seconds
663	454	112	14.88	seconds
664	578	113	14.97	seconds
665	429	114	14.98	seconds
666	452	114	15.15	seconds
667	489	114	15.84	seconds
668	586	113	16.15	seconds
669	355	113	\N	\N
670	328	112	\N	\N
671	349	114	\N	\N
672	357	113	\N	\N
673	369	114	\N	\N
674	428	113	\N	\N
675	408	113	\N	\N
676	416	112	\N	\N
677	420	112	\N	\N
678	423	113	\N	\N
679	424	112	\N	\N
680	456	112	\N	\N
681	447	114	\N	\N
682	394	112	\N	\N
683	464	112	\N	\N
684	477	113	\N	\N
685	557	113	\N	\N
686	537	114	\N	\N
687	594	112	\N	\N
688	602	112	\N	\N
689	621	113	\N	\N
690	614	113	\N	\N
691	620	112	\N	\N
692	577	114	\N	\N
693	574	112	\N	\N
694	573	112	\N	\N
695	631	114	\N	\N
696	641	114	\N	\N
697	635	113	\N	\N
698	640	113	\N	\N
699	644	113	\N	\N
700	702	113	\N	\N
701	701	113	\N	\N
702	654	112	\N	\N
703	706	112	\N	\N
704	674	112	\N	\N
705	658	112	\N	\N
706	660	112	\N	\N
707	686	112	\N	\N
708	679	113	\N	\N
709	649	114	\N	\N
710	695	112	\N	\N
711	735	114	\N	\N
712	719	114	\N	\N
713	742	113	\N	\N
714	710	112	\N	\N
715	713	113	\N	\N
716	720	112	\N	\N
717	736	112	\N	\N
718	738	114	\N	\N
719	741	114	\N	\N
720	745	112	\N	\N
721	645	120	24.88	seconds
722	569	119	32.77	seconds
723	586	119	34.60	seconds
724	384	119	\N	\N
725	328	118	\N	\N
726	342	118	\N	\N
727	358	118	\N	\N
728	369	120	\N	\N
729	385	118	\N	\N
730	347	118	\N	\N
731	452	120	\N	\N
732	428	119	\N	\N
733	408	119	\N	\N
734	416	118	\N	\N
735	420	118	\N	\N
736	424	118	\N	\N
737	454	118	\N	\N
738	456	118	\N	\N
739	447	120	\N	\N
740	394	118	\N	\N
741	464	118	\N	\N
742	477	119	\N	\N
743	557	119	\N	\N
744	537	120	\N	\N
745	627	120	\N	\N
746	623	120	\N	\N
747	611	119	\N	\N
748	594	118	\N	\N
749	628	120	\N	\N
750	620	118	\N	\N
751	583	120	\N	\N
752	581	119	\N	\N
753	578	119	\N	\N
754	588	120	\N	\N
755	574	118	\N	\N
756	573	118	\N	\N
757	637	119	\N	\N
758	643	120	\N	\N
759	644	119	\N	\N
760	708	119	\N	\N
761	702	119	\N	\N
762	701	119	\N	\N
763	654	118	\N	\N
764	706	118	\N	\N
765	660	118	\N	\N
766	663	118	\N	\N
767	649	120	\N	\N
768	695	118	\N	\N
769	731	120	\N	\N
770	735	120	\N	\N
771	719	120	\N	\N
772	725	120	\N	\N
773	710	118	\N	\N
774	720	118	\N	\N
775	730	120	\N	\N
776	736	118	\N	\N
777	645	126	57.50	seconds
778	569	125	74.11	seconds
779	529	126	75.35	seconds
780	335	125	\N	\N
781	367	125	\N	\N
782	342	124	\N	\N
783	353	125	\N	\N
784	358	124	\N	\N
785	385	124	\N	\N
786	347	124	\N	\N
787	380	124	\N	\N
788	408	125	\N	\N
789	420	124	\N	\N
790	424	124	\N	\N
791	394	124	\N	\N
792	462	126	\N	\N
793	469	124	\N	\N
794	489	126	\N	\N
795	623	126	\N	\N
796	611	125	\N	\N
797	581	125	\N	\N
798	584	125	\N	\N
799	637	125	\N	\N
800	708	125	\N	\N
801	702	125	\N	\N
802	654	124	\N	\N
803	676	124	\N	\N
804	660	124	\N	\N
805	724	126	\N	\N
806	740	126	\N	\N
807	549	130	176.00	seconds
808	553	131	178.00	seconds
809	521	132	178.18	seconds
810	556	131	179.82	seconds
811	314	130	182.70	seconds
812	311	132	183.23	seconds
813	541	132	200.00	seconds
814	318	131	\N	\N
815	310	131	\N	\N
816	335	131	\N	\N
817	367	131	\N	\N
818	323	130	\N	\N
819	341	130	\N	\N
820	362	130	\N	\N
821	366	130	\N	\N
822	353	131	\N	\N
823	419	132	\N	\N
824	392	130	\N	\N
825	422	132	\N	\N
826	455	130	\N	\N
827	462	132	\N	\N
828	474	132	\N	\N
829	469	130	\N	\N
830	499	132	\N	\N
831	492	131	\N	\N
832	606	132	\N	\N
833	595	131	\N	\N
834	624	132	\N	\N
835	583	132	\N	\N
836	581	131	\N	\N
837	587	132	\N	\N
838	639	132	\N	\N
839	642	132	\N	\N
840	688	132	\N	\N
841	694	132	\N	\N
842	651	132	\N	\N
843	672	131	\N	\N
844	697	131	\N	\N
845	707	131	\N	\N
846	678	131	\N	\N
847	683	130	\N	\N
848	676	130	\N	\N
849	734	130	\N	\N
850	711	131	\N	\N
851	587	138	298.53	seconds
852	549	136	371.68	seconds
853	492	137	380.60	seconds
854	521	138	384.25	seconds
855	553	137	387.50	seconds
856	556	137	390.00	seconds
857	486	138	390.43	seconds
858	499	138	390.76	seconds
859	540	137	408.42	seconds
860	311	138	411.96	seconds
861	545	136	421.00	seconds
862	541	138	440.33	seconds
863	318	137	\N	\N
864	314	136	\N	\N
865	310	137	\N	\N
866	323	136	\N	\N
867	341	136	\N	\N
868	362	136	\N	\N
869	366	136	\N	\N
870	419	138	\N	\N
871	392	136	\N	\N
872	422	138	\N	\N
873	455	136	\N	\N
874	474	138	\N	\N
875	469	136	\N	\N
876	606	138	\N	\N
877	595	137	\N	\N
878	624	138	\N	\N
879	639	138	\N	\N
880	642	138	\N	\N
881	688	138	\N	\N
882	694	138	\N	\N
883	651	138	\N	\N
884	672	137	\N	\N
885	697	137	\N	\N
886	707	137	\N	\N
887	678	137	\N	\N
888	683	136	\N	\N
889	734	136	\N	\N
890	688	144	\N	\N
891	694	144	\N	\N
892	672	143	\N	\N
893	697	143	\N	\N
894	707	143	\N	\N
895	678	143	\N	\N
896	683	142	\N	\N
897	633	168	17.25	seconds
898	566	167	17.97	seconds
899	636	166	19.49	seconds
900	517	168	20.17	seconds
901	496	168	21.01	seconds
902	501	168	24.12	seconds
903	355	167	\N	\N
904	628	168	\N	\N
905	674	166	\N	\N
906	658	166	\N	\N
907	664	167	\N	\N
908	657	167	\N	\N
909	679	167	\N	\N
910	633	180	53.11	seconds
911	566	179	53.64	seconds
912	636	178	55.73	seconds
913	517	180	55.80	seconds
914	496	180	57.45	seconds
915	501	180	62.30	seconds
916	355	179	\N	\N
917	380	178	\N	\N
918	617	179	\N	\N
919	638	179	\N	\N
920	664	179	\N	\N
921	657	179	\N	\N
922	679	179	\N	\N
923	440	203	338.50	inches
924	448	202	330.50	inches
925	503	204	323.00	inches
926	461	204	302.00	inches
927	523	204	282.00	inches
928	526	204	266.00	inches
929	500	203	245.00	inches
930	315	203	\N	\N
931	356	203	\N	\N
932	326	202	\N	\N
933	334	202	\N	\N
934	357	203	\N	\N
935	404	204	\N	\N
936	390	204	\N	\N
937	426	204	\N	\N
938	443	204	\N	\N
939	406	203	\N	\N
940	601	204	\N	\N
941	646	204	\N	\N
942	677	203	\N	\N
943	666	204	\N	\N
944	670	202	\N	\N
945	686	202	\N	\N
946	680	203	\N	\N
947	675	203	\N	\N
948	650	203	\N	\N
949	667	204	\N	\N
950	692	204	\N	\N
951	731	204	\N	\N
952	710	202	\N	\N
953	738	204	\N	\N
954	503	198	1032.00	inches
955	523	198	871.00	inches
956	525	198	865.00	inches
957	526	198	858.00	inches
958	440	197	816.00	inches
959	461	198	779.00	inches
960	448	196	644.00	inches
961	500	197	582.00	inches
962	356	197	\N	\N
963	326	196	\N	\N
964	334	196	\N	\N
965	357	197	\N	\N
966	404	198	\N	\N
967	390	198	\N	\N
968	426	198	\N	\N
969	443	198	\N	\N
970	406	197	\N	\N
971	533	197	\N	\N
972	601	198	\N	\N
973	646	198	\N	\N
974	677	197	\N	\N
975	666	198	\N	\N
976	670	196	\N	\N
977	686	196	\N	\N
978	680	197	\N	\N
979	675	197	\N	\N
980	650	197	\N	\N
981	667	198	\N	\N
982	692	198	\N	\N
983	725	198	\N	\N
984	633	210	54.00	inches
985	487	209	52.00	inches
986	498	209	\N	\N
987	333	210	\N	\N
988	350	210	\N	\N
989	380	208	\N	\N
990	613	210	\N	\N
991	626	210	\N	\N
992	623	210	\N	\N
993	593	208	\N	\N
994	634	210	\N	\N
995	644	209	\N	\N
996	664	209	\N	\N
997	667	210	\N	\N
998	647	215	154.25	inches
999	577	216	138.00	inches
1000	634	216	114.00	inches
1001	501	216	78.00	inches
1002	489	216	66.00	inches
1003	384	215	\N	\N
1004	342	214	\N	\N
1005	613	216	\N	\N
1006	601	216	\N	\N
1007	664	215	\N	\N
1008	647	185	198.50	inches
1009	566	185	174.00	inches
1010	487	185	163.00	inches
1011	536	186	123.50	inches
1012	524	185	118.00	inches
1013	498	185	\N	\N
1014	533	185	\N	\N
1015	333	186	\N	\N
1016	322	186	\N	\N
1017	328	184	\N	\N
1018	349	186	\N	\N
1019	347	184	\N	\N
1020	429	186	\N	\N
1021	452	186	\N	\N
1022	416	184	\N	\N
1023	424	184	\N	\N
1024	569	185	\N	\N
1025	613	186	\N	\N
1026	593	184	\N	\N
1027	620	184	\N	\N
1028	577	186	\N	\N
1029	574	184	\N	\N
1030	632	186	\N	\N
1031	638	185	\N	\N
1032	651	186	\N	\N
1033	701	185	\N	\N
1034	663	184	\N	\N
1035	649	186	\N	\N
1036	742	185	\N	\N
1037	711	185	\N	\N
1038	713	185	\N	\N
1039	720	184	\N	\N
1040	730	186	\N	\N
1041	634	192	430.50	inches
1042	633	192	385.00	inches
1043	533	191	359.50	inches
1044	636	190	329.00	inches
1045	536	192	299.00	inches
1046	524	191	249.50	inches
1047	498	191	\N	\N
1048	322	192	\N	\N
1049	429	192	\N	\N
1050	408	191	\N	\N
1051	626	192	\N	\N
1052	632	192	\N	\N
1053	638	191	\N	\N
1054	597	111	11.60	seconds
1055	520	111	11.88	seconds
1056	391	111	12.54	seconds
1057	435	111	12.60	seconds
1058	438	111	12.72	seconds
1059	530	111	12.72	seconds
1060	564	110	13.36	seconds
1061	575	109	13.64	seconds
1062	395	110	13.97	seconds
1063	502	110	14.07	seconds
1064	320	111	\N	\N
1065	309	111	\N	\N
1066	381	111	\N	\N
1067	354	111	\N	\N
1068	383	111	\N	\N
1069	327	110	\N	\N
1070	348	110	\N	\N
1071	386	110	\N	\N
1072	331	110	\N	\N
1073	340	111	\N	\N
1074	343	110	\N	\N
1075	345	109	\N	\N
1076	359	111	\N	\N
1077	368	110	\N	\N
1078	382	111	\N	\N
1079	324	111	\N	\N
1080	330	109	\N	\N
1081	332	110	\N	\N
1082	338	109	\N	\N
1083	364	109	\N	\N
1084	370	110	\N	\N
1085	402	110	\N	\N
1086	398	111	\N	\N
1087	407	111	\N	\N
1088	421	109	\N	\N
1089	437	111	\N	\N
1090	439	109	\N	\N
1091	446	109	\N	\N
1092	457	111	\N	\N
1093	427	111	\N	\N
1094	482	111	\N	\N
1095	475	111	\N	\N
1096	485	111	\N	\N
1097	478	110	\N	\N
1098	463	110	\N	\N
1099	480	110	\N	\N
1100	467	110	\N	\N
1101	465	109	\N	\N
1102	476	109	\N	\N
1103	471	109	\N	\N
1104	473	109	\N	\N
1105	479	109	\N	\N
1106	484	109	\N	\N
1107	551	111	\N	\N
1108	558	111	\N	\N
1109	548	110	\N	\N
1110	552	111	\N	\N
1111	546	111	\N	\N
1112	563	110	\N	\N
1113	565	109	\N	\N
1114	599	110	\N	\N
1115	596	109	\N	\N
1116	605	109	\N	\N
1117	591	109	\N	\N
1118	604	109	\N	\N
1119	582	111	\N	\N
1120	580	110	\N	\N
1121	669	111	\N	\N
1122	699	110	\N	\N
1123	682	110	\N	\N
1124	652	109	\N	\N
1125	655	109	\N	\N
1126	693	109	\N	\N
1127	681	109	\N	\N
1128	685	109	\N	\N
1129	659	111	\N	\N
1130	709	111	\N	\N
1131	665	109	\N	\N
1132	689	111	\N	\N
1133	704	109	\N	\N
1134	728	110	\N	\N
1135	715	111	\N	\N
1136	723	110	\N	\N
1137	729	111	\N	\N
1138	726	111	\N	\N
1139	716	109	\N	\N
1140	718	109	\N	\N
1141	721	111	\N	\N
1142	597	117	23.00	seconds
1143	520	117	24.39	seconds
1144	580	116	26.72	seconds
1145	575	115	27.24	seconds
1146	511	117	\N	\N
1147	309	117	\N	\N
1148	354	117	\N	\N
1149	383	117	\N	\N
1150	348	116	\N	\N
1151	386	116	\N	\N
1152	331	116	\N	\N
1153	340	117	\N	\N
1154	346	115	\N	\N
1155	359	117	\N	\N
1156	368	116	\N	\N
1157	371	117	\N	\N
1158	382	117	\N	\N
1159	330	115	\N	\N
1160	332	116	\N	\N
1161	338	115	\N	\N
1162	370	116	\N	\N
1163	388	117	\N	\N
1164	412	117	\N	\N
1165	435	117	\N	\N
1166	430	117	\N	\N
1167	402	116	\N	\N
1168	425	117	\N	\N
1169	395	116	\N	\N
1170	398	117	\N	\N
1171	407	117	\N	\N
1172	421	115	\N	\N
1173	438	117	\N	\N
1174	446	115	\N	\N
1175	451	116	\N	\N
1176	457	117	\N	\N
1177	459	116	\N	\N
1178	444	117	\N	\N
1179	482	117	\N	\N
1180	485	117	\N	\N
1181	463	116	\N	\N
1182	480	116	\N	\N
1183	465	115	\N	\N
1184	476	115	\N	\N
1185	471	115	\N	\N
1186	473	115	\N	\N
1187	484	115	\N	\N
1188	502	116	\N	\N
1189	551	117	\N	\N
1190	558	117	\N	\N
1191	544	117	\N	\N
1192	548	116	\N	\N
1193	552	117	\N	\N
1194	546	117	\N	\N
1195	565	115	\N	\N
1196	599	116	\N	\N
1197	596	115	\N	\N
1198	603	117	\N	\N
1199	605	115	\N	\N
1200	572	117	\N	\N
1201	571	115	\N	\N
1202	582	117	\N	\N
1203	579	115	\N	\N
1204	669	117	\N	\N
1205	699	116	\N	\N
1206	682	116	\N	\N
1207	652	115	\N	\N
1208	655	115	\N	\N
1209	693	115	\N	\N
1210	685	115	\N	\N
1211	687	116	\N	\N
1212	668	116	\N	\N
1213	659	117	\N	\N
1214	671	117	\N	\N
1215	709	117	\N	\N
1216	689	117	\N	\N
1217	704	115	\N	\N
1218	715	117	\N	\N
1219	723	116	\N	\N
1220	726	117	\N	\N
1221	716	115	\N	\N
1222	718	115	\N	\N
1223	749	116	\N	\N
1224	748	116	\N	\N
1225	312	123	55.66	seconds
1226	749	122	56.66	seconds
1227	495	122	57.54	seconds
1228	531	123	57.59	seconds
1229	748	122	58.51	seconds
1230	544	123	61.00	seconds
1231	571	121	61.76	seconds
1232	579	121	62.00	seconds
1233	542	123	63.00	seconds
1234	319	123	66.42	seconds
1235	316	122	\N	\N
1236	325	123	\N	\N
1237	352	123	\N	\N
1238	363	123	\N	\N
1239	375	123	\N	\N
1240	346	121	\N	\N
1241	360	122	\N	\N
1242	371	123	\N	\N
1243	364	121	\N	\N
1244	412	123	\N	\N
1245	430	123	\N	\N
1246	425	123	\N	\N
1247	398	123	\N	\N
1248	407	123	\N	\N
1249	459	122	\N	\N
1250	472	121	\N	\N
1251	570	123	\N	\N
1252	563	122	\N	\N
1253	567	121	\N	\N
1254	561	121	\N	\N
1255	622	121	\N	\N
1256	603	123	\N	\N
1257	591	121	\N	\N
1258	576	122	\N	\N
1259	652	121	\N	\N
1260	681	121	\N	\N
1261	685	121	\N	\N
1262	687	122	\N	\N
1263	668	122	\N	\N
1264	671	123	\N	\N
1265	689	123	\N	\N
1266	704	121	\N	\N
1267	712	123	\N	\N
1268	727	123	\N	\N
1269	722	123	\N	\N
1270	516	129	119.70	seconds
1271	312	129	131.96	seconds
1272	493	129	134.70	seconds
1273	555	128	135.00	seconds
1274	514	127	136.62	seconds
1275	560	129	143.00	seconds
1276	547	128	143.00	seconds
1277	543	129	144.00	seconds
1278	531	129	144.02	seconds
1279	572	129	145.30	seconds
1280	582	129	145.75	seconds
1281	550	127	148.00	seconds
1282	559	128	152.00	seconds
1283	317	129	158.82	seconds
1284	504	128	158.96	seconds
1285	538	128	168.00	seconds
1286	319	129	173.13	seconds
1287	567	127	191.45	seconds
1288	539	128	240.00	seconds
1289	308	129	\N	\N
1290	307	128	\N	\N
1291	306	127	\N	\N
1292	316	128	\N	\N
1293	352	129	\N	\N
1294	363	129	\N	\N
1295	375	129	\N	\N
1296	381	129	\N	\N
1297	336	128	\N	\N
1298	387	129	\N	\N
1299	372	127	\N	\N
1300	337	127	\N	\N
1301	339	127	\N	\N
1302	351	127	\N	\N
1303	365	127	\N	\N
1304	409	129	\N	\N
1305	411	128	\N	\N
1306	436	128	\N	\N
1307	449	129	\N	\N
1308	458	129	\N	\N
1309	432	129	\N	\N
1310	413	129	\N	\N
1311	389	129	\N	\N
1312	399	128	\N	\N
1313	410	127	\N	\N
1314	400	127	\N	\N
1315	405	129	\N	\N
1316	418	129	\N	\N
1317	450	127	\N	\N
1318	393	129	\N	\N
1319	442	129	\N	\N
1320	417	128	\N	\N
1321	481	129	\N	\N
1322	470	128	\N	\N
1323	466	129	\N	\N
1324	472	127	\N	\N
1325	490	129	\N	\N
1326	510	128	\N	\N
1327	562	128	\N	\N
1328	568	129	\N	\N
1329	600	129	\N	\N
1330	612	129	\N	\N
1331	610	129	\N	\N
1332	592	128	\N	\N
1333	619	127	\N	\N
1334	625	127	\N	\N
1335	609	127	\N	\N
1336	615	127	\N	\N
1337	608	127	\N	\N
1338	576	128	\N	\N
1339	705	129	\N	\N
1340	696	128	\N	\N
1341	673	128	\N	\N
1342	698	127	\N	\N
1343	648	127	\N	\N
1344	691	127	\N	\N
1345	662	129	\N	\N
1346	744	129	\N	\N
1347	746	129	\N	\N
1348	739	129	\N	\N
1349	743	129	\N	\N
1350	717	127	\N	\N
1351	753	129	\N	\N
1352	752	128	\N	\N
1353	514	133	253.86	seconds
1354	516	135	265.88	seconds
1355	592	134	272.96	seconds
1356	753	135	276.92	seconds
1357	747	135	283.75	seconds
1358	752	134	283.75	seconds
1359	555	134	287.21	seconds
1360	612	135	290.00	seconds
1361	625	133	290.58	seconds
1362	493	135	294.65	seconds
1363	490	135	295.99	seconds
1364	308	135	305.37	seconds
1365	547	134	306.96	seconds
1366	560	135	307.48	seconds
1367	543	135	307.76	seconds
1368	550	133	319.22	seconds
1369	559	134	329.61	seconds
1370	317	135	345.08	seconds
1371	538	134	358.51	seconds
1372	504	134	362.44	seconds
1373	535	135	370.08	seconds
1374	554	135	390.00	seconds
1375	568	135	396.33	seconds
1376	312	135	\N	\N
1377	307	134	\N	\N
1378	306	133	\N	\N
1379	316	134	\N	\N
1380	336	134	\N	\N
1381	387	135	\N	\N
1382	372	133	\N	\N
1383	337	133	\N	\N
1384	339	133	\N	\N
1385	351	133	\N	\N
1386	365	133	\N	\N
1387	409	135	\N	\N
1388	411	134	\N	\N
1389	436	134	\N	\N
1390	449	135	\N	\N
1391	458	135	\N	\N
1392	432	135	\N	\N
1393	413	135	\N	\N
1394	389	135	\N	\N
1395	399	134	\N	\N
1396	410	133	\N	\N
1397	400	133	\N	\N
1398	434	134	\N	\N
1399	405	135	\N	\N
1400	418	135	\N	\N
1401	450	133	\N	\N
1402	393	135	\N	\N
1403	442	135	\N	\N
1404	417	134	\N	\N
1405	481	135	\N	\N
1406	470	134	\N	\N
1407	467	134	\N	\N
1408	466	135	\N	\N
1409	472	133	\N	\N
1410	483	134	\N	\N
1411	567	133	\N	\N
1412	561	133	\N	\N
1413	600	135	\N	\N
1414	610	135	\N	\N
1415	619	133	\N	\N
1416	609	133	\N	\N
1417	615	133	\N	\N
1418	608	133	\N	\N
1419	589	133	\N	\N
1420	696	134	\N	\N
1421	673	134	\N	\N
1422	698	133	\N	\N
1423	648	133	\N	\N
1424	691	133	\N	\N
1425	662	135	\N	\N
1426	744	135	\N	\N
1427	746	135	\N	\N
1428	739	135	\N	\N
1429	717	133	\N	\N
1430	751	135	\N	\N
1431	750	135	\N	\N
1432	754	133	\N	\N
1433	673	140	\N	\N
1434	648	139	\N	\N
1435	662	141	\N	\N
1436	527	171	18.94	seconds
1437	494	171	21.21	seconds
1438	513	171	23.20	seconds
1439	378	171	\N	\N
1440	376	171	\N	\N
1441	340	171	\N	\N
1442	343	170	\N	\N
1443	338	169	\N	\N
1444	391	171	\N	\N
1445	396	171	\N	\N
1446	478	170	\N	\N
1447	491	170	\N	\N
1448	607	171	\N	\N
1449	604	169	\N	\N
1450	690	170	\N	\N
1451	656	171	\N	\N
1452	727	171	\N	\N
1453	527	177	48.60	seconds
1454	491	176	48.99	seconds
1455	570	177	49.98	seconds
1456	494	177	51.49	seconds
1457	378	177	\N	\N
1458	374	175	\N	\N
1459	324	177	\N	\N
1460	391	177	\N	\N
1461	396	177	\N	\N
1462	434	176	\N	\N
1463	481	177	\N	\N
1464	478	176	\N	\N
1465	495	176	\N	\N
1466	607	177	\N	\N
1467	727	177	\N	\N
1468	722	177	\N	\N
1469	497	201	475.50	inches
1470	518	201	467.00	inches
1471	512	201	407.00	inches
1472	532	201	388.00	inches
1473	488	200	335.50	inches
1474	506	201	331.50	inches
1475	313	201	\N	\N
1476	344	201	\N	\N
1477	329	201	\N	\N
1478	375	201	\N	\N
1479	373	201	\N	\N
1480	321	201	\N	\N
1481	327	200	\N	\N
1482	361	199	\N	\N
1483	377	201	\N	\N
1484	453	201	\N	\N
1485	415	200	\N	\N
1486	460	200	\N	\N
1487	414	200	\N	\N
1488	397	200	\N	\N
1489	445	201	\N	\N
1490	431	201	\N	\N
1491	441	200	\N	\N
1492	468	199	\N	\N
1493	554	201	\N	\N
1494	563	200	\N	\N
1495	618	201	\N	\N
1496	616	201	\N	\N
1497	598	199	\N	\N
1498	585	200	\N	\N
1499	661	201	\N	\N
1500	703	201	\N	\N
1501	684	199	\N	\N
1502	653	200	\N	\N
1503	700	200	\N	\N
1504	737	201	\N	\N
1505	729	201	\N	\N
1506	497	195	1441.00	inches
1507	460	194	1315.00	inches
1508	518	195	1224.00	inches
1509	532	195	1146.00	inches
1510	512	195	1087.00	inches
1511	506	195	1018.00	inches
1512	488	194	903.00	inches
1513	564	194	883.00	inches
1514	397	194	810.00	inches
1515	313	195	\N	\N
1516	344	195	\N	\N
1517	329	195	\N	\N
1518	373	195	\N	\N
1519	321	195	\N	\N
1520	327	194	\N	\N
1521	361	193	\N	\N
1522	377	195	\N	\N
1523	379	193	\N	\N
1524	453	195	\N	\N
1525	415	194	\N	\N
1526	414	194	\N	\N
1527	445	195	\N	\N
1528	431	195	\N	\N
1529	441	194	\N	\N
1530	468	193	\N	\N
1531	542	195	\N	\N
1532	554	195	\N	\N
1533	618	195	\N	\N
1534	616	195	\N	\N
1535	598	193	\N	\N
1536	585	194	\N	\N
1537	661	195	\N	\N
1538	703	195	\N	\N
1539	684	193	\N	\N
1540	653	194	\N	\N
1541	700	194	\N	\N
1542	737	195	\N	\N
1543	743	195	\N	\N
1544	729	195	\N	\N
1545	509	207	62.00	inches
1546	522	207	62.00	inches
1547	507	206	60.00	inches
1548	564	206	\N	\N
1549	320	207	\N	\N
1550	344	207	\N	\N
1551	378	207	\N	\N
1552	345	205	\N	\N
1553	388	207	\N	\N
1554	401	206	\N	\N
1555	403	206	\N	\N
1556	433	206	\N	\N
1557	570	207	\N	\N
1558	630	206	\N	\N
1559	690	206	\N	\N
1560	681	205	\N	\N
1561	665	205	\N	\N
1562	714	207	\N	\N
1563	733	207	\N	\N
1564	527	213	114.00	inches
1565	505	213	102.00	inches
1566	493	213	102.00	inches
1567	325	213	\N	\N
1568	376	213	\N	\N
1569	330	211	\N	\N
1570	364	211	\N	\N
1571	388	213	\N	\N
1572	629	213	\N	\N
1573	590	212	\N	\N
1574	630	212	\N	\N
1575	622	211	\N	\N
1576	705	213	\N	\N
1577	690	212	\N	\N
1578	681	211	\N	\N
1579	509	183	210.00	inches
1580	530	183	203.00	inches
1581	491	182	198.50	inches
1582	579	181	174.00	inches
1583	522	183	171.00	inches
1584	507	182	166.00	inches
1585	575	181	166.00	inches
1586	580	182	158.00	inches
1587	508	183	148.00	inches
1588	519	182	\N	\N
1589	329	183	\N	\N
1590	375	183	\N	\N
1591	343	182	\N	\N
1592	345	181	\N	\N
1593	360	182	\N	\N
1594	374	181	\N	\N
1595	332	182	\N	\N
1596	370	182	\N	\N
1597	412	183	\N	\N
1598	430	183	\N	\N
1599	401	182	\N	\N
1600	403	182	\N	\N
1601	402	182	\N	\N
1602	433	182	\N	\N
1603	451	182	\N	\N
1604	459	182	\N	\N
1605	475	183	\N	\N
1606	478	182	\N	\N
1607	467	182	\N	\N
1608	479	181	\N	\N
1609	534	183	\N	\N
1610	554	183	\N	\N
1611	629	183	\N	\N
1612	607	183	\N	\N
1613	705	183	\N	\N
1614	687	182	\N	\N
1615	659	183	\N	\N
1616	704	181	\N	\N
1617	714	183	\N	\N
1618	728	182	\N	\N
1619	732	183	\N	\N
1620	723	182	\N	\N
1621	733	183	\N	\N
1622	717	181	\N	\N
1623	721	183	\N	\N
1624	519	188	501.00	inches
1625	509	189	467.00	inches
1626	320	189	426.50	inches
1627	530	189	420.50	inches
1628	522	189	380.00	inches
1629	511	189	379.00	inches
1630	507	188	377.75	inches
1631	508	189	347.00	inches
1632	386	188	\N	\N
1633	359	189	\N	\N
1634	374	187	\N	\N
1635	412	189	\N	\N
1636	401	188	\N	\N
1637	403	188	\N	\N
1638	433	188	\N	\N
1639	451	188	\N	\N
1640	629	189	\N	\N
1641	607	189	\N	\N
1642	690	188	\N	\N
1643	714	189	\N	\N
1644	728	188	\N	\N
1645	732	189	\N	\N
1646	733	189	\N	\N
1647	645	222	12.15	seconds
1648	647	221	13.50	seconds
1649	632	222	14.00	seconds
1650	588	222	14.50	seconds
1651	584	221	14.59	seconds
1652	764	220	14.88	seconds
1653	578	221	14.97	seconds
1654	429	222	14.98	seconds
1655	452	222	15.15	seconds
1656	489	222	15.84	seconds
1657	586	221	16.15	seconds
1658	328	220	\N	\N
1659	349	222	\N	\N
1660	357	221	\N	\N
1661	760	220	\N	\N
1662	428	221	\N	\N
1663	408	221	\N	\N
1664	416	220	\N	\N
1665	420	220	\N	\N
1666	423	221	\N	\N
1667	424	220	\N	\N
1668	456	220	\N	\N
1669	447	222	\N	\N
1670	394	220	\N	\N
1671	763	220	\N	\N
1672	464	220	\N	\N
1673	477	221	\N	\N
1674	557	221	\N	\N
1675	537	222	\N	\N
1676	594	220	\N	\N
1677	621	221	\N	\N
1678	614	221	\N	\N
1679	620	220	\N	\N
1680	577	222	\N	\N
1681	767	220	\N	\N
1682	574	220	\N	\N
1683	573	220	\N	\N
1684	631	222	\N	\N
1685	641	222	\N	\N
1686	635	221	\N	\N
1687	640	221	\N	\N
1688	644	221	\N	\N
1689	702	221	\N	\N
1690	701	221	\N	\N
1691	654	220	\N	\N
1692	706	220	\N	\N
1693	674	220	\N	\N
1694	658	220	\N	\N
1695	660	220	\N	\N
1696	686	220	\N	\N
1697	679	221	\N	\N
1698	649	222	\N	\N
1699	695	220	\N	\N
1700	735	222	\N	\N
1701	719	222	\N	\N
1702	742	221	\N	\N
1703	710	220	\N	\N
1704	713	221	\N	\N
1705	720	220	\N	\N
1706	736	220	\N	\N
1707	738	222	\N	\N
1708	741	222	\N	\N
1709	745	220	\N	\N
1710	645	228	24.88	seconds
1711	569	227	32.77	seconds
1712	586	227	34.60	seconds
1713	384	227	\N	\N
1714	328	226	\N	\N
1715	342	226	\N	\N
1716	358	226	\N	\N
1717	385	226	\N	\N
1718	347	226	\N	\N
1719	755	228	\N	\N
1720	760	226	\N	\N
1721	452	228	\N	\N
1722	428	227	\N	\N
1723	408	227	\N	\N
1724	416	226	\N	\N
1725	420	226	\N	\N
1726	424	226	\N	\N
1727	764	226	\N	\N
1728	456	226	\N	\N
1729	447	228	\N	\N
1730	394	226	\N	\N
1731	763	226	\N	\N
1732	464	226	\N	\N
1733	477	227	\N	\N
1734	557	227	\N	\N
1735	537	228	\N	\N
1736	627	228	\N	\N
1737	623	228	\N	\N
1738	611	227	\N	\N
1739	594	226	\N	\N
1740	628	228	\N	\N
1741	620	226	\N	\N
1742	583	228	\N	\N
1743	581	227	\N	\N
1744	578	227	\N	\N
1745	588	228	\N	\N
1746	767	226	\N	\N
1747	574	226	\N	\N
1748	573	226	\N	\N
1749	637	227	\N	\N
1750	643	228	\N	\N
1751	644	227	\N	\N
1752	708	227	\N	\N
1753	702	227	\N	\N
1754	701	227	\N	\N
1755	654	226	\N	\N
1756	706	226	\N	\N
1757	660	226	\N	\N
1758	663	226	\N	\N
1759	649	228	\N	\N
1760	695	226	\N	\N
1761	731	228	\N	\N
1762	735	228	\N	\N
1763	719	228	\N	\N
1764	725	228	\N	\N
1765	710	226	\N	\N
1766	730	228	\N	\N
1767	736	226	\N	\N
1768	745	226	\N	\N
1769	645	234	57.50	seconds
1770	569	233	74.11	seconds
1771	529	234	75.35	seconds
1772	335	233	\N	\N
1773	367	233	\N	\N
1774	342	232	\N	\N
1775	353	233	\N	\N
1776	358	232	\N	\N
1777	385	232	\N	\N
1778	347	232	\N	\N
1779	380	232	\N	\N
1780	755	234	\N	\N
1781	408	233	\N	\N
1782	420	232	\N	\N
1783	424	232	\N	\N
1784	394	232	\N	\N
1785	462	234	\N	\N
1786	469	232	\N	\N
1787	489	234	\N	\N
1788	623	234	\N	\N
1789	611	233	\N	\N
1790	581	233	\N	\N
1791	584	233	\N	\N
1792	637	233	\N	\N
1793	708	233	\N	\N
1794	702	233	\N	\N
1795	654	232	\N	\N
1796	676	232	\N	\N
1797	660	232	\N	\N
1798	740	234	\N	\N
1799	587	240	147.00	seconds
1800	549	238	176.00	seconds
1801	553	239	178.00	seconds
1802	521	240	178.18	seconds
1803	556	239	179.82	seconds
1804	314	238	182.70	seconds
1805	311	240	183.23	seconds
1806	541	240	200.00	seconds
1807	318	239	\N	\N
1808	310	239	\N	\N
1809	335	239	\N	\N
1810	367	239	\N	\N
1811	323	238	\N	\N
1812	341	238	\N	\N
1813	362	238	\N	\N
1814	366	238	\N	\N
1815	353	239	\N	\N
1816	759	240	\N	\N
1817	419	240	\N	\N
1818	392	238	\N	\N
1819	422	240	\N	\N
1820	455	238	\N	\N
1821	462	240	\N	\N
1822	474	240	\N	\N
1823	469	238	\N	\N
1824	499	240	\N	\N
1825	492	239	\N	\N
1826	606	240	\N	\N
1827	595	239	\N	\N
1828	624	240	\N	\N
1829	583	240	\N	\N
1830	581	239	\N	\N
1831	639	240	\N	\N
1832	642	240	\N	\N
1833	688	240	\N	\N
1834	694	240	\N	\N
1835	651	240	\N	\N
1836	672	239	\N	\N
1837	697	239	\N	\N
1838	707	239	\N	\N
1839	678	239	\N	\N
1840	683	238	\N	\N
1841	676	238	\N	\N
1842	711	239	\N	\N
1843	587	246	298.53	seconds
1844	549	244	371.68	seconds
1845	492	245	380.60	seconds
1846	521	246	384.25	seconds
1847	553	245	387.50	seconds
1848	556	245	390.00	seconds
1849	486	246	390.43	seconds
1850	499	246	390.76	seconds
1851	540	245	408.42	seconds
1852	311	246	411.96	seconds
1853	545	244	421.00	seconds
1854	541	246	440.33	seconds
1855	318	245	\N	\N
1856	314	244	\N	\N
1857	310	245	\N	\N
1858	323	244	\N	\N
1859	341	244	\N	\N
1860	362	244	\N	\N
1861	366	244	\N	\N
1862	759	246	\N	\N
1863	419	246	\N	\N
1864	392	244	\N	\N
1865	422	246	\N	\N
1866	455	244	\N	\N
1867	474	246	\N	\N
1868	469	244	\N	\N
1869	606	246	\N	\N
1870	595	245	\N	\N
1871	624	246	\N	\N
1872	639	246	\N	\N
1873	642	246	\N	\N
1874	688	246	\N	\N
1875	694	246	\N	\N
1876	651	246	\N	\N
1877	672	245	\N	\N
1878	697	245	\N	\N
1879	707	245	\N	\N
1880	678	245	\N	\N
1881	683	244	\N	\N
1882	734	244	\N	\N
1883	688	252	\N	\N
1884	694	252	\N	\N
1885	672	251	\N	\N
1886	697	251	\N	\N
1887	707	251	\N	\N
1888	678	251	\N	\N
1889	683	250	\N	\N
1890	633	276	17.25	seconds
1891	566	275	17.97	seconds
1892	636	274	19.49	seconds
1893	517	276	20.17	seconds
1894	496	276	21.01	seconds
1895	501	276	24.12	seconds
1896	355	275	\N	\N
1897	628	276	\N	\N
1898	674	274	\N	\N
1899	658	274	\N	\N
1900	664	275	\N	\N
1901	657	275	\N	\N
1902	679	275	\N	\N
1903	633	288	53.11	seconds
1904	566	287	53.64	seconds
1905	636	286	55.73	seconds
1906	517	288	55.80	seconds
1907	496	288	57.45	seconds
1908	501	288	62.30	seconds
1909	355	287	\N	\N
1910	380	286	\N	\N
1911	617	287	\N	\N
1912	638	287	\N	\N
1913	664	287	\N	\N
1914	657	287	\N	\N
1915	679	287	\N	\N
1916	440	311	338.50	inches
1917	448	310	330.50	inches
1918	503	312	323.00	inches
1919	461	312	302.00	inches
1920	523	312	282.00	inches
1921	526	312	266.00	inches
1922	500	311	245.00	inches
1923	315	311	\N	\N
1924	356	311	\N	\N
1925	326	310	\N	\N
1926	334	310	\N	\N
1927	357	311	\N	\N
1928	760	310	\N	\N
1929	404	312	\N	\N
1930	390	312	\N	\N
1931	426	312	\N	\N
1932	443	312	\N	\N
1933	406	311	\N	\N
1934	601	312	\N	\N
1935	646	312	\N	\N
1936	677	311	\N	\N
1937	666	312	\N	\N
1938	670	310	\N	\N
1939	686	310	\N	\N
1940	680	311	\N	\N
1941	675	311	\N	\N
1942	650	311	\N	\N
1943	667	312	\N	\N
1944	692	312	\N	\N
1945	731	312	\N	\N
1946	710	310	\N	\N
1947	738	312	\N	\N
1948	503	306	1032.00	inches
1949	523	306	871.00	inches
1950	525	306	865.00	inches
1951	526	306	858.00	inches
1952	440	305	816.00	inches
1953	461	306	779.00	inches
1954	448	304	644.00	inches
1955	500	305	582.00	inches
1956	356	305	\N	\N
1957	326	304	\N	\N
1958	334	304	\N	\N
1959	357	305	\N	\N
1960	404	306	\N	\N
1961	390	306	\N	\N
1962	426	306	\N	\N
1963	443	306	\N	\N
1964	406	305	\N	\N
1965	533	305	\N	\N
1966	601	306	\N	\N
1967	646	306	\N	\N
1968	677	305	\N	\N
1969	666	306	\N	\N
1970	670	304	\N	\N
1971	686	304	\N	\N
1972	680	305	\N	\N
1973	675	305	\N	\N
1974	650	305	\N	\N
1975	667	306	\N	\N
1976	692	306	\N	\N
1977	725	306	\N	\N
1978	633	318	54.00	inches
1979	487	317	52.00	inches
1980	498	317	\N	\N
1981	333	318	\N	\N
1982	350	318	\N	\N
1983	380	316	\N	\N
1984	613	318	\N	\N
1985	626	318	\N	\N
1986	623	318	\N	\N
1987	593	316	\N	\N
1988	634	318	\N	\N
1989	644	317	\N	\N
1990	664	317	\N	\N
1991	667	318	\N	\N
1992	647	323	154.25	inches
1993	577	324	138.00	inches
1994	634	324	114.00	inches
1995	501	324	78.00	inches
1996	489	324	66.00	inches
1997	384	323	\N	\N
1998	342	322	\N	\N
1999	613	324	\N	\N
2000	601	324	\N	\N
2001	664	323	\N	\N
2002	647	293	198.50	inches
2003	566	293	174.00	inches
2004	487	293	163.00	inches
2005	536	294	123.50	inches
2006	524	293	118.00	inches
2007	498	293	\N	\N
2008	533	293	\N	\N
2009	333	294	\N	\N
2010	322	294	\N	\N
2011	328	292	\N	\N
2012	349	294	\N	\N
2013	347	292	\N	\N
2014	755	294	\N	\N
2015	760	292	\N	\N
2016	429	294	\N	\N
2017	452	294	\N	\N
2018	416	292	\N	\N
2019	424	292	\N	\N
2020	569	293	\N	\N
2021	613	294	\N	\N
2022	593	292	\N	\N
2023	620	292	\N	\N
2024	577	294	\N	\N
2025	574	292	\N	\N
2026	632	294	\N	\N
2027	638	293	\N	\N
2028	651	294	\N	\N
2029	701	293	\N	\N
2030	663	292	\N	\N
2031	649	294	\N	\N
2032	742	293	\N	\N
2033	713	293	\N	\N
2034	730	294	\N	\N
2035	634	300	430.50	inches
2036	633	300	385.00	inches
2037	533	299	359.50	inches
2038	636	298	329.00	inches
2039	536	300	299.00	inches
2040	524	299	249.50	inches
2041	498	299	\N	\N
2042	322	300	\N	\N
2043	755	300	\N	\N
2044	429	300	\N	\N
2045	408	299	\N	\N
2046	626	300	\N	\N
2047	632	300	\N	\N
2048	638	299	\N	\N
2049	597	219	11.60	seconds
2050	520	219	11.88	seconds
2051	391	219	12.54	seconds
2052	435	219	12.60	seconds
2053	438	219	12.72	seconds
2054	530	219	12.72	seconds
2055	564	218	13.36	seconds
2056	575	217	13.64	seconds
2057	395	218	13.97	seconds
2058	502	218	14.07	seconds
2059	309	219	\N	\N
2060	381	219	\N	\N
2061	354	219	\N	\N
2062	383	219	\N	\N
2063	327	218	\N	\N
2064	348	218	\N	\N
2065	386	218	\N	\N
2066	331	218	\N	\N
2067	340	219	\N	\N
2068	343	218	\N	\N
2069	345	217	\N	\N
2070	368	218	\N	\N
2071	382	219	\N	\N
2072	324	219	\N	\N
2073	330	217	\N	\N
2074	332	218	\N	\N
2075	338	217	\N	\N
2076	364	217	\N	\N
2077	370	218	\N	\N
2078	757	219	\N	\N
2079	758	218	\N	\N
2080	402	218	\N	\N
2081	398	219	\N	\N
2082	407	219	\N	\N
2083	421	217	\N	\N
2084	437	219	\N	\N
2085	439	217	\N	\N
2086	446	217	\N	\N
2087	457	219	\N	\N
2088	427	219	\N	\N
2089	762	217	\N	\N
2090	444	219	\N	\N
2091	482	219	\N	\N
2092	475	219	\N	\N
2093	485	219	\N	\N
2094	478	218	\N	\N
2095	463	218	\N	\N
2096	480	218	\N	\N
2097	467	218	\N	\N
2098	465	217	\N	\N
2099	476	217	\N	\N
2100	471	217	\N	\N
2101	473	217	\N	\N
2102	479	217	\N	\N
2103	484	217	\N	\N
2104	551	219	\N	\N
2105	558	219	\N	\N
2106	548	218	\N	\N
2107	552	219	\N	\N
2108	546	219	\N	\N
2109	563	218	\N	\N
2110	565	217	\N	\N
2111	599	218	\N	\N
2112	596	217	\N	\N
2113	605	217	\N	\N
2114	591	217	\N	\N
2115	604	217	\N	\N
2116	582	219	\N	\N
2117	580	218	\N	\N
2118	669	219	\N	\N
2119	699	218	\N	\N
2120	682	218	\N	\N
2121	652	217	\N	\N
2122	655	217	\N	\N
2123	693	217	\N	\N
2124	681	217	\N	\N
2125	685	217	\N	\N
2126	659	219	\N	\N
2127	709	219	\N	\N
2128	665	217	\N	\N
2129	689	219	\N	\N
2130	704	217	\N	\N
2131	728	218	\N	\N
2132	715	219	\N	\N
2133	723	218	\N	\N
2134	729	219	\N	\N
2135	726	219	\N	\N
2136	716	217	\N	\N
2137	718	217	\N	\N
2138	721	219	\N	\N
2139	597	225	23.00	seconds
2140	520	225	24.39	seconds
2141	580	224	26.72	seconds
2142	575	223	27.24	seconds
2143	511	225	\N	\N
2144	309	225	\N	\N
2145	354	225	\N	\N
2146	383	225	\N	\N
2147	348	224	\N	\N
2148	386	224	\N	\N
2149	331	224	\N	\N
2150	340	225	\N	\N
2151	346	223	\N	\N
2152	368	224	\N	\N
2153	371	225	\N	\N
2154	382	225	\N	\N
2155	330	223	\N	\N
2156	332	224	\N	\N
2157	338	223	\N	\N
2158	370	224	\N	\N
2159	388	225	\N	\N
2160	757	225	\N	\N
2161	758	224	\N	\N
2162	412	225	\N	\N
2163	435	225	\N	\N
2164	430	225	\N	\N
2165	402	224	\N	\N
2166	425	225	\N	\N
2167	395	224	\N	\N
2168	398	225	\N	\N
2169	407	225	\N	\N
2170	421	223	\N	\N
2171	438	225	\N	\N
2172	446	223	\N	\N
2173	451	224	\N	\N
2174	457	225	\N	\N
2175	459	224	\N	\N
2176	762	223	\N	\N
2177	444	225	\N	\N
2178	482	225	\N	\N
2179	485	225	\N	\N
2180	463	224	\N	\N
2181	480	224	\N	\N
2182	465	223	\N	\N
2183	476	223	\N	\N
2184	471	223	\N	\N
2185	473	223	\N	\N
2186	484	223	\N	\N
2187	502	224	\N	\N
2188	551	225	\N	\N
2189	558	225	\N	\N
2190	544	225	\N	\N
2191	548	224	\N	\N
2192	552	225	\N	\N
2193	546	225	\N	\N
2194	565	223	\N	\N
2195	599	224	\N	\N
2196	768	225	\N	\N
2197	596	223	\N	\N
2198	603	225	\N	\N
2199	605	223	\N	\N
2200	572	225	\N	\N
2201	571	223	\N	\N
2202	582	225	\N	\N
2203	579	223	\N	\N
2204	669	225	\N	\N
2205	699	224	\N	\N
2206	682	224	\N	\N
2207	652	223	\N	\N
2208	655	223	\N	\N
2209	693	223	\N	\N
2210	685	223	\N	\N
2211	687	224	\N	\N
2212	668	224	\N	\N
2213	659	225	\N	\N
2214	671	225	\N	\N
2215	709	225	\N	\N
2216	689	225	\N	\N
2217	704	223	\N	\N
2218	715	225	\N	\N
2219	723	224	\N	\N
2220	726	225	\N	\N
2221	716	223	\N	\N
2222	718	223	\N	\N
2223	749	224	\N	\N
2224	748	224	\N	\N
2225	312	231	55.66	seconds
2226	749	230	56.66	seconds
2227	495	230	57.54	seconds
2228	531	231	57.59	seconds
2229	748	230	58.51	seconds
2230	766	231	60.00	seconds
2231	544	231	61.00	seconds
2232	571	229	61.76	seconds
2233	579	229	62.00	seconds
2234	542	231	63.00	seconds
2235	319	231	66.42	seconds
2236	316	230	\N	\N
2237	325	231	\N	\N
2238	352	231	\N	\N
2239	363	231	\N	\N
2240	375	231	\N	\N
2241	346	229	\N	\N
2242	360	230	\N	\N
2243	371	231	\N	\N
2244	364	229	\N	\N
2245	756	231	\N	\N
2246	758	230	\N	\N
2247	412	231	\N	\N
2248	430	231	\N	\N
2249	425	231	\N	\N
2250	398	231	\N	\N
2251	407	231	\N	\N
2252	459	230	\N	\N
2253	472	229	\N	\N
2254	570	231	\N	\N
2255	563	230	\N	\N
2256	567	229	\N	\N
2257	561	229	\N	\N
2258	768	231	\N	\N
2259	622	229	\N	\N
2260	603	231	\N	\N
2261	591	229	\N	\N
2262	576	230	\N	\N
2263	652	229	\N	\N
2264	681	229	\N	\N
2265	685	229	\N	\N
2266	687	230	\N	\N
2267	668	230	\N	\N
2268	671	231	\N	\N
2269	689	231	\N	\N
2270	704	229	\N	\N
2271	712	231	\N	\N
2272	727	231	\N	\N
2273	722	231	\N	\N
2274	516	237	119.70	seconds
2275	312	237	131.96	seconds
2276	493	237	134.70	seconds
2277	555	236	135.00	seconds
2278	514	235	136.62	seconds
2279	560	237	143.00	seconds
2280	547	236	143.00	seconds
2281	543	237	144.00	seconds
2282	531	237	144.02	seconds
2283	572	237	145.30	seconds
2284	582	237	145.75	seconds
2285	550	235	148.00	seconds
2286	559	236	152.00	seconds
2287	317	237	158.82	seconds
2288	504	236	158.96	seconds
2289	538	236	168.00	seconds
2290	319	237	173.13	seconds
2291	567	235	191.45	seconds
2292	539	236	240.00	seconds
2293	308	237	\N	\N
2294	307	236	\N	\N
2295	306	235	\N	\N
2296	316	236	\N	\N
2297	352	237	\N	\N
2298	363	237	\N	\N
2299	375	237	\N	\N
2300	381	237	\N	\N
2301	336	236	\N	\N
2302	387	237	\N	\N
2303	372	235	\N	\N
2304	337	235	\N	\N
2305	339	235	\N	\N
2306	351	235	\N	\N
2307	365	235	\N	\N
2308	756	237	\N	\N
2309	761	236	\N	\N
2310	409	237	\N	\N
2311	411	236	\N	\N
2312	436	236	\N	\N
2313	449	237	\N	\N
2314	458	237	\N	\N
2315	432	237	\N	\N
2316	413	237	\N	\N
2317	389	237	\N	\N
2318	399	236	\N	\N
2319	410	235	\N	\N
2320	400	235	\N	\N
2321	405	237	\N	\N
2322	450	235	\N	\N
2323	393	237	\N	\N
2324	442	237	\N	\N
2325	417	236	\N	\N
2326	765	236	\N	\N
2327	481	237	\N	\N
2328	470	236	\N	\N
2329	466	237	\N	\N
2330	472	235	\N	\N
2331	490	237	\N	\N
2332	510	236	\N	\N
2333	562	236	\N	\N
2334	568	237	\N	\N
2335	600	237	\N	\N
2336	612	237	\N	\N
2337	610	237	\N	\N
2338	592	236	\N	\N
2339	619	235	\N	\N
2340	625	235	\N	\N
2341	609	235	\N	\N
2342	615	235	\N	\N
2343	608	235	\N	\N
2344	576	236	\N	\N
2345	705	237	\N	\N
2346	696	236	\N	\N
2347	673	236	\N	\N
2348	698	235	\N	\N
2349	648	235	\N	\N
2350	691	235	\N	\N
2351	662	237	\N	\N
2352	744	237	\N	\N
2353	746	237	\N	\N
2354	739	237	\N	\N
2355	743	237	\N	\N
2356	717	235	\N	\N
2357	753	237	\N	\N
2358	752	236	\N	\N
2359	514	241	253.86	seconds
2360	516	243	265.88	seconds
2361	592	242	272.96	seconds
2362	753	243	276.92	seconds
2363	747	243	283.75	seconds
2364	752	242	283.75	seconds
2365	555	242	287.21	seconds
2366	612	243	290.00	seconds
2367	625	241	290.58	seconds
2368	493	243	294.65	seconds
2369	490	243	295.99	seconds
2370	308	243	305.37	seconds
2371	547	242	306.96	seconds
2372	560	243	307.48	seconds
2373	543	243	307.76	seconds
2374	550	241	319.22	seconds
2375	559	242	329.61	seconds
2376	317	243	345.08	seconds
2377	538	242	358.51	seconds
2378	504	242	362.44	seconds
2379	535	243	370.08	seconds
2380	554	243	390.00	seconds
2381	568	243	396.33	seconds
2382	307	242	\N	\N
2383	306	241	\N	\N
2384	316	242	\N	\N
2385	336	242	\N	\N
2386	387	243	\N	\N
2387	372	241	\N	\N
2388	337	241	\N	\N
2389	339	241	\N	\N
2390	351	241	\N	\N
2391	365	241	\N	\N
2392	756	243	\N	\N
2393	761	242	\N	\N
2394	409	243	\N	\N
2395	411	242	\N	\N
2396	436	242	\N	\N
2397	449	243	\N	\N
2398	458	243	\N	\N
2399	432	243	\N	\N
2400	413	243	\N	\N
2401	389	243	\N	\N
2402	399	242	\N	\N
2403	410	241	\N	\N
2404	400	241	\N	\N
2405	434	242	\N	\N
2406	405	243	\N	\N
2407	450	241	\N	\N
2408	393	243	\N	\N
2409	442	243	\N	\N
2410	417	242	\N	\N
2411	765	242	\N	\N
2412	481	243	\N	\N
2413	470	242	\N	\N
2414	467	242	\N	\N
2415	466	243	\N	\N
2416	472	241	\N	\N
2417	483	242	\N	\N
2418	567	241	\N	\N
2419	561	241	\N	\N
2420	600	243	\N	\N
2421	610	243	\N	\N
2422	619	241	\N	\N
2423	609	241	\N	\N
2424	615	241	\N	\N
2425	608	241	\N	\N
2426	589	241	\N	\N
2427	696	242	\N	\N
2428	673	242	\N	\N
2429	698	241	\N	\N
2430	648	241	\N	\N
2431	691	241	\N	\N
2432	662	243	\N	\N
2433	744	243	\N	\N
2434	746	243	\N	\N
2435	739	243	\N	\N
2436	717	241	\N	\N
2437	751	243	\N	\N
2438	750	243	\N	\N
2439	754	241	\N	\N
2440	673	248	\N	\N
2441	648	247	\N	\N
2442	662	249	\N	\N
2443	527	279	18.94	seconds
2444	494	279	21.21	seconds
2445	513	279	23.20	seconds
2446	378	279	\N	\N
2447	376	279	\N	\N
2448	340	279	\N	\N
2449	343	278	\N	\N
2450	338	277	\N	\N
2451	391	279	\N	\N
2452	396	279	\N	\N
2453	478	278	\N	\N
2454	491	278	\N	\N
2455	607	279	\N	\N
2456	604	277	\N	\N
2457	690	278	\N	\N
2458	656	279	\N	\N
2459	727	279	\N	\N
2460	527	285	48.60	seconds
2461	491	284	48.99	seconds
2462	570	285	49.98	seconds
2463	494	285	51.49	seconds
2464	378	285	\N	\N
2465	374	283	\N	\N
2466	324	285	\N	\N
2467	391	285	\N	\N
2468	396	285	\N	\N
2469	434	284	\N	\N
2470	481	285	\N	\N
2471	478	284	\N	\N
2472	495	284	\N	\N
2473	607	285	\N	\N
2474	727	285	\N	\N
2475	722	285	\N	\N
2476	497	309	475.50	inches
2477	518	309	467.00	inches
2478	512	309	407.00	inches
2479	532	309	388.00	inches
2480	488	308	335.50	inches
2481	506	309	331.50	inches
2482	313	309	\N	\N
2483	344	309	\N	\N
2484	329	309	\N	\N
2485	375	309	\N	\N
2486	373	309	\N	\N
2487	321	309	\N	\N
2488	327	308	\N	\N
2489	361	307	\N	\N
2490	377	309	\N	\N
2491	757	309	\N	\N
2492	453	309	\N	\N
2493	415	308	\N	\N
2494	460	308	\N	\N
2495	414	308	\N	\N
2496	397	308	\N	\N
2497	445	309	\N	\N
2498	431	309	\N	\N
2499	441	308	\N	\N
2500	468	307	\N	\N
2501	554	309	\N	\N
2502	563	308	\N	\N
2503	618	309	\N	\N
2504	598	307	\N	\N
2505	585	308	\N	\N
2506	661	309	\N	\N
2507	703	309	\N	\N
2508	684	307	\N	\N
2509	653	308	\N	\N
2510	700	308	\N	\N
2511	737	309	\N	\N
2512	729	309	\N	\N
2513	497	303	1441.00	inches
2514	460	302	1315.00	inches
2515	518	303	1224.00	inches
2516	532	303	1146.00	inches
2517	512	303	1087.00	inches
2518	506	303	1018.00	inches
2519	488	302	903.00	inches
2520	564	302	883.00	inches
2521	397	302	810.00	inches
2522	313	303	\N	\N
2523	320	303	\N	\N
2524	344	303	\N	\N
2525	329	303	\N	\N
2526	373	303	\N	\N
2527	321	303	\N	\N
2528	327	302	\N	\N
2529	361	301	\N	\N
2530	377	303	\N	\N
2531	379	301	\N	\N
2532	453	303	\N	\N
2533	415	302	\N	\N
2534	414	302	\N	\N
2535	445	303	\N	\N
2536	431	303	\N	\N
2537	441	302	\N	\N
2538	468	301	\N	\N
2539	542	303	\N	\N
2540	554	303	\N	\N
2541	618	303	\N	\N
2542	598	301	\N	\N
2543	585	302	\N	\N
2544	661	303	\N	\N
2545	703	303	\N	\N
2546	684	301	\N	\N
2547	653	302	\N	\N
2548	700	302	\N	\N
2549	737	303	\N	\N
2550	743	303	\N	\N
2551	729	303	\N	\N
2552	509	315	62.00	inches
2553	522	315	62.00	inches
2554	507	314	60.00	inches
2555	564	314	\N	\N
2556	320	315	\N	\N
2557	344	315	\N	\N
2558	378	315	\N	\N
2559	345	313	\N	\N
2560	388	315	\N	\N
2561	401	314	\N	\N
2562	403	314	\N	\N
2563	433	314	\N	\N
2564	444	315	\N	\N
2565	570	315	\N	\N
2566	630	314	\N	\N
2567	690	314	\N	\N
2568	681	313	\N	\N
2569	665	313	\N	\N
2570	714	315	\N	\N
2571	733	315	\N	\N
2572	527	321	114.00	inches
2573	505	321	102.00	inches
2574	493	321	102.00	inches
2575	325	321	\N	\N
2576	376	321	\N	\N
2577	330	319	\N	\N
2578	364	319	\N	\N
2579	388	321	\N	\N
2580	629	321	\N	\N
2581	590	320	\N	\N
2582	630	320	\N	\N
2583	622	319	\N	\N
2584	705	321	\N	\N
2585	690	320	\N	\N
2586	681	319	\N	\N
2587	509	291	210.00	inches
2588	530	291	203.00	inches
2589	491	290	198.50	inches
2590	579	289	174.00	inches
2591	522	291	171.00	inches
2592	507	290	166.00	inches
2593	575	289	166.00	inches
2594	580	290	158.00	inches
2595	508	291	148.00	inches
2596	519	290	\N	\N
2597	329	291	\N	\N
2598	375	291	\N	\N
2599	343	290	\N	\N
2600	345	289	\N	\N
2601	360	290	\N	\N
2602	374	289	\N	\N
2603	332	290	\N	\N
2604	370	290	\N	\N
2605	757	291	\N	\N
2606	758	290	\N	\N
2607	412	291	\N	\N
2608	430	291	\N	\N
2609	401	290	\N	\N
2610	403	290	\N	\N
2611	402	290	\N	\N
2612	433	290	\N	\N
2613	451	290	\N	\N
2614	459	290	\N	\N
2615	475	291	\N	\N
2616	478	290	\N	\N
2617	467	290	\N	\N
2618	479	289	\N	\N
2619	534	291	\N	\N
2620	766	291	\N	\N
2621	554	291	\N	\N
2622	629	291	\N	\N
2623	607	291	\N	\N
2624	705	291	\N	\N
2625	687	290	\N	\N
2626	659	291	\N	\N
2627	704	289	\N	\N
2628	714	291	\N	\N
2629	728	290	\N	\N
2630	732	291	\N	\N
2631	723	290	\N	\N
2632	733	291	\N	\N
2633	717	289	\N	\N
2634	721	291	\N	\N
2635	519	296	501.00	inches
2636	509	297	467.00	inches
2637	320	297	426.50	inches
2638	530	297	420.50	inches
2639	522	297	380.00	inches
2640	511	297	379.00	inches
2641	507	296	377.75	inches
2642	508	297	347.00	inches
2643	386	296	\N	\N
2644	359	297	\N	\N
2645	374	295	\N	\N
2646	412	297	\N	\N
2647	401	296	\N	\N
2648	403	296	\N	\N
2649	433	296	\N	\N
2650	451	296	\N	\N
2651	629	297	\N	\N
2652	607	297	\N	\N
2653	690	296	\N	\N
2654	714	297	\N	\N
2655	728	296	\N	\N
2656	732	297	\N	\N
2657	733	297	\N	\N
2658	645	330	12.15	seconds
2659	647	329	13.32	seconds
2660	528	328	13.80	seconds
2661	719	330	13.88	seconds
2662	566	329	14.08	seconds
2663	632	330	14.14	seconds
2664	735	330	14.69	seconds
2665	745	328	15.02	seconds
2666	736	328	15.57	seconds
2667	710	328	15.72	seconds
2668	644	329	16.28	seconds
2669	477	329	16.41	seconds
2670	640	329	16.52	seconds
2671	464	328	16.67	seconds
2672	557	329	16.89	seconds
2673	741	330	16.94	seconds
2674	631	330	18.22	seconds
2675	537	330	18.37	seconds
2676	769	330	\N	\N
2677	770	329	\N	\N
2678	777	329	\N	\N
2679	720	328	\N	\N
2680	645	336	24.88	seconds
2681	528	334	29.29	seconds
2682	569	335	31.92	seconds
2683	489	336	32.82	seconds
2684	529	336	34.11	seconds
2685	637	335	34.73	seconds
2686	464	334	\N	\N
2687	477	335	\N	\N
2688	557	335	\N	\N
2689	537	336	\N	\N
2690	731	336	\N	\N
2691	735	336	\N	\N
2692	719	336	\N	\N
2693	710	334	\N	\N
2694	736	334	\N	\N
2695	745	334	\N	\N
2696	770	335	\N	\N
2697	777	335	\N	\N
2698	631	336	\N	\N
2699	641	336	\N	\N
2700	635	335	\N	\N
2701	720	334	\N	\N
2702	741	336	\N	\N
2703	645	342	61.57	seconds
2704	462	342	67.97	seconds
2705	569	341	72.49	seconds
2706	529	342	75.35	seconds
2707	489	342	78.47	seconds
2708	773	342	\N	\N
2709	776	341	\N	\N
2710	731	342	\N	\N
2711	734	340	\N	\N
2712	521	348	176.73	seconds
2713	499	348	178.61	seconds
2714	556	347	179.82	seconds
2715	314	346	182.70	seconds
2716	311	348	183.23	seconds
2717	545	346	190.10	seconds
2718	642	348	198.05	seconds
2719	318	347	199.56	seconds
2720	639	348	205.03	seconds
2721	462	348	\N	\N
2722	773	348	\N	\N
2723	776	347	\N	\N
2724	774	347	\N	\N
2725	469	352	372.04	seconds
2726	521	354	379.81	seconds
2727	492	353	380.60	seconds
2728	499	354	386.01	seconds
2729	556	353	388.31	seconds
2730	486	354	390.43	seconds
2731	545	352	402.17	seconds
2732	314	352	416.01	seconds
2733	541	354	440.33	seconds
2734	318	353	443.05	seconds
2735	642	354	450.58	seconds
2736	639	354	451.33	seconds
2737	803	352	510.91	seconds
2738	793	352	545.67	seconds
2739	474	354	\N	\N
2740	776	353	\N	\N
2741	774	353	\N	\N
2742	814	354	\N	\N
2743	816	354	\N	\N
2744	521	360	819.91	seconds
2745	492	359	824.97	seconds
2746	499	360	868.61	seconds
2747	486	360	868.65	seconds
2748	540	359	909.46	seconds
2749	541	360	944.78	seconds
2750	469	358	\N	\N
2751	774	359	\N	\N
2752	549	358	\N	\N
2753	633	384	17.23	seconds
2754	566	383	17.61	seconds
2755	636	382	19.26	seconds
2756	517	384	20.17	seconds
2757	496	384	20.52	seconds
2758	501	384	22.26	seconds
2759	711	383	\N	\N
2760	566	395	51.38	seconds
2761	636	394	52.49	seconds
2762	633	396	53.11	seconds
2763	638	395	54.56	seconds
2764	517	396	55.80	seconds
2765	496	396	57.31	seconds
2766	501	396	62.30	seconds
2767	487	395	\N	\N
2768	769	396	\N	\N
2769	711	395	\N	\N
2770	503	420	323.00	inches
2771	523	420	302.00	inches
2772	315	419	293.25	inches
2773	526	420	276.50	inches
2774	646	420	276.00	inches
2775	500	419	262.50	inches
2776	710	418	248.50	inches
2777	788	418	242.00	inches
2778	731	420	178.00	inches
2779	800	419	\N	\N
2780	738	420	\N	\N
2781	769	420	\N	\N
2782	811	419	\N	\N
2783	796	419	\N	\N
2784	713	419	\N	\N
2785	503	414	1032.00	inches
2786	523	414	957.50	inches
2787	525	414	865.00	inches
2788	526	414	858.00	inches
2789	500	413	654.00	inches
2790	646	414	654.00	inches
2791	533	413	650.50	inches
2792	788	412	633.00	inches
2793	800	413	\N	\N
2794	796	413	\N	\N
2795	725	414	\N	\N
2796	769	414	\N	\N
2797	529	414	\N	\N
2798	811	413	\N	\N
2799	783	413	\N	\N
2800	710	412	\N	\N
2801	713	413	\N	\N
2802	738	414	\N	\N
2803	487	425	54.00	inches
2804	515	424	54.00	inches
2805	634	426	52.00	inches
2806	633	426	50.00	inches
2807	498	425	42.00	inches
2808	644	425	\N	\N
2809	524	425	\N	\N
2810	569	425	\N	\N
2811	734	424	\N	\N
2812	711	425	\N	\N
2813	741	426	\N	\N
2814	647	431	154.25	inches
2815	634	432	120.00	inches
2816	501	432	78.00	inches
2817	489	432	66.00	inches
2818	647	401	203.25	inches
2819	487	401	178.00	inches
2820	566	401	174.00	inches
2821	498	401	169.00	inches
2822	632	402	162.50	inches
2823	533	401	162.00	inches
2824	638	401	154.00	inches
2825	636	400	154.00	inches
2826	515	400	151.00	inches
2827	536	402	148.00	inches
2828	524	401	118.00	inches
2829	720	400	\N	\N
2830	736	400	\N	\N
2831	634	408	430.50	inches
2832	633	408	385.00	inches
2833	632	408	373.25	inches
2834	533	407	359.50	inches
2835	515	406	350.00	inches
2836	638	407	342.25	inches
2837	636	406	329.00	inches
2838	536	408	318.50	inches
2839	498	407	316.00	inches
2840	524	407	274.50	inches
2841	520	327	11.78	seconds
2842	726	327	12.23	seconds
2843	551	327	12.33	seconds
2844	715	327	12.36	seconds
2845	552	327	12.42	seconds
2846	794	325	12.51	seconds
2847	546	327	12.57	seconds
2848	530	327	12.63	seconds
2849	309	327	12.68	seconds
2850	728	326	12.98	seconds
2851	801	326	13.00	seconds
2852	779	325	13.10	seconds
2853	721	327	13.10	seconds
2854	771	326	13.15	seconds
2855	473	325	13.18	seconds
2856	785	325	13.29	seconds
2857	564	326	13.36	seconds
2858	790	325	13.41	seconds
2859	478	326	13.50	seconds
2860	809	325	13.53	seconds
2861	463	326	13.62	seconds
2862	502	326	13.73	seconds
2863	484	325	13.80	seconds
2864	471	325	14.05	seconds
2865	548	326	14.25	seconds
2866	723	326	14.46	seconds
2867	716	325	14.51	seconds
2868	475	327	14.83	seconds
2869	465	325	15.13	seconds
2870	482	327	\N	\N
2871	511	327	\N	\N
2872	485	327	\N	\N
2873	480	326	\N	\N
2874	476	325	\N	\N
2875	479	325	\N	\N
2876	806	327	\N	\N
2877	807	325	\N	\N
2878	813	327	\N	\N
2879	733	327	\N	\N
2880	748	326	\N	\N
2881	520	333	24.21	seconds
2882	794	331	25.26	seconds
2883	726	333	25.60	seconds
2884	309	333	26.99	seconds
2885	779	331	27.02	seconds
2886	790	331	28.14	seconds
2887	502	332	28.94	seconds
2888	548	332	29.57	seconds
2889	465	331	30.00	seconds
2890	482	333	\N	\N
2891	463	332	\N	\N
2892	471	331	\N	\N
2893	473	331	\N	\N
2894	484	331	\N	\N
2895	511	333	\N	\N
2896	551	333	\N	\N
2897	552	333	\N	\N
2898	546	333	\N	\N
2899	715	333	\N	\N
2900	723	332	\N	\N
2901	716	331	\N	\N
2902	749	332	\N	\N
2903	748	332	\N	\N
2904	485	333	\N	\N
2905	480	332	\N	\N
2906	476	331	\N	\N
2907	479	331	\N	\N
2908	806	333	\N	\N
2909	542	333	\N	\N
2910	813	333	\N	\N
2911	564	332	\N	\N
2912	567	331	\N	\N
2913	718	331	\N	\N
2914	721	333	\N	\N
2915	312	339	55.41	seconds
2916	802	337	56.20	seconds
2917	780	337	56.42	seconds
2918	749	338	56.66	seconds
2919	495	338	57.54	seconds
2920	531	339	57.59	seconds
2921	727	339	59.02	seconds
2922	712	339	59.74	seconds
2923	544	339	60.36	seconds
2924	766	339	61.86	seconds
2925	785	337	62.72	seconds
2926	319	339	66.42	seconds
2927	722	339	70.63	seconds
2928	567	337	74.32	seconds
2929	562	338	75.00	seconds
2930	561	337	80.48	seconds
2931	482	339	\N	\N
2932	463	338	\N	\N
2933	480	338	\N	\N
2934	465	337	\N	\N
2935	476	337	\N	\N
2936	473	337	\N	\N
2937	484	337	\N	\N
2938	543	339	\N	\N
2939	718	337	\N	\N
2940	817	339	\N	\N
2941	516	345	117.76	seconds
2942	752	344	130.13	seconds
2943	470	344	131.33	seconds
2944	312	345	131.96	seconds
2945	555	344	132.33	seconds
2946	490	345	132.35	seconds
2947	514	343	133.01	seconds
2948	481	345	135.99	seconds
2949	787	343	140.03	seconds
2950	543	345	140.14	seconds
2951	717	343	145.20	seconds
2952	562	344	151.62	seconds
2953	504	344	152.31	seconds
2954	316	344	155.05	seconds
2955	812	344	155.31	seconds
2956	319	345	170.18	seconds
2957	568	345	182.75	seconds
2958	744	345	188.71	seconds
2959	746	345	\N	\N
2960	772	345	\N	\N
2961	712	345	\N	\N
2962	739	345	\N	\N
2963	751	345	\N	\N
2964	750	345	\N	\N
2965	815	344	\N	\N
2966	754	343	\N	\N
2967	516	351	262.73	seconds
2968	752	350	281.18	seconds
2969	810	350	286.57	seconds
2970	490	351	289.61	seconds
2971	514	349	293.87	seconds
2972	470	350	294.71	seconds
2973	815	350	294.72	seconds
2974	481	351	295.84	seconds
2975	787	349	306.46	seconds
2976	466	351	315.14	seconds
2977	550	349	319.22	seconds
2978	717	349	319.49	seconds
2979	317	351	324.32	seconds
2980	739	351	336.97	seconds
2981	795	349	339.01	seconds
2982	316	350	340.20	seconds
2983	744	351	343.37	seconds
2984	542	351	346.00	seconds
2985	504	350	353.11	seconds
2986	538	350	358.13	seconds
2987	771	350	358.30	seconds
2988	554	351	365.53	seconds
2989	535	351	370.08	seconds
2990	746	351	391.39	seconds
2991	568	351	396.33	seconds
2992	483	350	405.17	seconds
2993	561	349	410.64	seconds
2994	567	349	414.31	seconds
2995	472	349	433.02	seconds
2996	751	351	\N	\N
2997	750	351	\N	\N
2998	754	349	\N	\N
2999	772	351	\N	\N
3000	562	350	\N	\N
3001	516	357	604.07	seconds
3002	490	357	626.47	seconds
3003	560	357	654.90	seconds
3004	787	355	686.89	seconds
3005	795	355	729.70	seconds
3006	562	356	739.44	seconds
3007	568	357	867.65	seconds
3008	535	357	\N	\N
3009	317	357	\N	\N
3010	316	356	\N	\N
3011	772	357	\N	\N
3012	470	356	\N	\N
3013	466	357	\N	\N
3014	472	355	\N	\N
3015	514	355	\N	\N
3016	504	356	\N	\N
3017	559	356	\N	\N
3018	547	356	\N	\N
3019	538	356	\N	\N
3020	746	357	\N	\N
3021	739	357	\N	\N
3022	717	355	\N	\N
3023	527	387	18.53	seconds
3024	491	386	18.79	seconds
3025	727	387	21.05	seconds
3026	494	387	21.21	seconds
3027	478	386	21.40	seconds
3028	513	387	23.00	seconds
3029	808	386	\N	\N
3030	799	385	\N	\N
3031	784	385	\N	\N
3032	802	385	\N	\N
3033	802	391	46.55	seconds
3034	491	392	46.81	seconds
3035	527	393	47.68	seconds
3036	478	392	49.92	seconds
3037	494	393	51.49	seconds
3038	481	393	52.71	seconds
3039	799	391	53.10	seconds
3040	784	391	54.12	seconds
3041	495	392	\N	\N
3042	727	393	\N	\N
3043	722	393	\N	\N
3044	712	393	\N	\N
3045	497	417	492.00	inches
3046	518	417	467.00	inches
3047	737	417	437.25	inches
3048	512	417	427.75	inches
3049	532	417	389.00	inches
3050	313	417	377.00	inches
3051	506	417	355.00	inches
3052	488	416	335.50	inches
3053	789	415	294.50	inches
3054	554	417	279.00	inches
3055	775	415	264.50	inches
3056	786	416	263.00	inches
3057	782	417	261.00	inches
3058	792	415	\N	\N
3059	791	415	\N	\N
3060	804	415	\N	\N
3061	510	416	\N	\N
3062	723	416	\N	\N
3063	497	411	1441.00	inches
3064	532	411	1273.00	inches
3065	518	411	1224.00	inches
3066	313	411	1158.00	inches
3067	512	411	1087.00	inches
3068	320	411	1024.50	inches
3069	506	411	1018.00	inches
3070	488	410	903.00	inches
3071	564	410	883.00	inches
3072	791	409	804.00	inches
3073	554	411	751.00	inches
3074	542	411	725.00	inches
3075	789	409	696.00	inches
3076	782	411	580.00	inches
3077	786	410	482.00	inches
3078	775	409	\N	\N
3079	804	409	\N	\N
3080	792	409	\N	\N
3081	737	411	\N	\N
3082	510	410	\N	\N
3083	812	410	\N	\N
3084	733	423	68.00	inches
3085	509	423	62.00	inches
3086	522	423	62.00	inches
3087	507	422	60.00	inches
3088	781	421	60.00	inches
3089	714	423	60.00	inches
3090	805	421	58.00	inches
3091	527	429	126.00	inches
3092	505	429	120.00	inches
3093	493	429	114.00	inches
3094	732	399	218.00	inches
3095	733	399	216.00	inches
3096	530	399	211.50	inches
3097	491	398	211.50	inches
3098	509	399	210.00	inches
3099	781	397	207.00	inches
3100	534	399	205.00	inches
3101	507	398	204.00	inches
3102	478	398	202.00	inches
3103	717	397	202.00	inches
3104	766	399	193.00	inches
3105	564	398	190.00	inches
3106	522	399	189.00	inches
3107	475	399	183.00	inches
3108	721	399	177.50	inches
3109	728	398	171.00	inches
3110	513	399	167.50	inches
3111	805	397	166.50	inches
3112	495	398	164.00	inches
3113	797	397	164.00	inches
3114	508	399	148.00	inches
3115	771	398	\N	\N
3116	479	397	\N	\N
3117	519	398	\N	\N
3118	714	399	\N	\N
3119	313	399	\N	\N
3120	320	399	\N	\N
3121	480	398	\N	\N
3122	778	398	\N	\N
3123	476	397	\N	\N
3124	716	397	\N	\N
3125	519	404	501.00	inches
3126	509	405	467.00	inches
3127	802	403	448.00	inches
3128	733	405	444.00	inches
3129	320	405	426.50	inches
3130	781	403	425.50	inches
3131	732	405	425.00	inches
3132	530	405	420.50	inches
3133	507	404	401.00	inches
3134	508	405	397.00	inches
3135	511	405	396.00	inches
3136	728	404	393.50	inches
3137	522	405	393.00	inches
3138	714	405	376.00	inches
3139	495	404	355.00	inches
3140	513	405	346.50	inches
3141	778	404	\N	\N
3142	617	437	13.50	seconds
3143	660	436	14.47	seconds
3144	764	436	14.67	seconds
3145	423	437	14.97	seconds
3146	429	438	14.98	seconds
3147	447	438	14.98	seconds
3148	452	438	15.15	seconds
3149	679	437	15.27	seconds
3150	702	437	15.34	seconds
3151	424	436	15.42	seconds
3152	706	436	15.43	seconds
3153	614	437	15.48	seconds
3154	654	436	15.49	seconds
3155	416	436	15.51	seconds
3156	763	436	15.66	seconds
3157	408	437	15.69	seconds
3158	649	438	15.69	seconds
3159	428	437	15.73	seconds
3160	695	436	15.78	seconds
3161	328	436	15.80	seconds
3162	594	436	15.96	seconds
3163	456	436	16.15	seconds
3164	621	437	16.83	seconds
3165	701	437	17.04	seconds
3166	686	436	17.38	seconds
3167	420	436	17.51	seconds
3168	394	436	17.52	seconds
3169	620	436	17.61	seconds
3170	674	436	\N	\N
3171	658	436	\N	\N
3172	355	437	\N	\N
3173	357	437	\N	\N
3174	369	438	\N	\N
3175	825	438	\N	\N
3176	827	436	\N	\N
3177	602	436	\N	\N
3178	663	436	\N	\N
3179	627	444	28.00	seconds
3180	628	444	28.78	seconds
3181	708	443	29.81	seconds
3182	660	442	30.39	seconds
3183	764	442	30.61	seconds
3184	447	444	31.64	seconds
3185	663	442	31.68	seconds
3186	611	443	31.74	seconds
3187	452	444	31.83	seconds
3188	649	444	32.04	seconds
3189	706	442	32.11	seconds
3190	763	442	32.29	seconds
3191	695	442	32.64	seconds
3192	416	442	32.74	seconds
3193	623	444	32.78	seconds
3194	428	443	32.84	seconds
3195	328	442	33.00	seconds
3196	384	443	33.37	seconds
3197	594	442	33.47	seconds
3198	456	442	33.62	seconds
3199	424	442	33.90	seconds
3200	385	442	34.05	seconds
3201	358	442	34.22	seconds
3202	408	443	34.84	seconds
3203	342	442	35.20	seconds
3204	394	442	37.17	seconds
3205	620	442	37.71	seconds
3206	420	442	38.32	seconds
3207	701	443	\N	\N
3208	654	442	\N	\N
3209	334	442	\N	\N
3210	825	444	\N	\N
3211	602	442	\N	\N
3212	676	442	\N	\N
3213	657	443	\N	\N
3214	367	449	60.62	seconds
3215	676	448	64.77	seconds
3216	708	449	65.23	seconds
3217	628	450	66.00	seconds
3218	611	449	70.57	seconds
3219	623	450	73.85	seconds
3220	385	448	78.19	seconds
3221	424	448	78.79	seconds
3222	358	448	79.48	seconds
3223	342	448	81.90	seconds
3224	408	449	82.12	seconds
3225	394	448	83.88	seconds
3226	654	448	85.12	seconds
3227	420	448	87.87	seconds
3228	702	449	\N	\N
3229	335	449	\N	\N
3230	380	448	\N	\N
3231	428	449	\N	\N
3232	456	448	\N	\N
3233	763	448	\N	\N
3234	624	456	154.31	seconds
3235	676	454	155.08	seconds
3236	367	455	156.23	seconds
3237	366	454	156.27	seconds
3238	595	455	160.04	seconds
3239	688	456	164.58	seconds
3240	455	454	168.03	seconds
3241	831	455	169.06	seconds
3242	707	455	176.51	seconds
3243	341	454	182.10	seconds
3244	683	454	183.67	seconds
3245	422	456	185.71	seconds
3246	694	456	188.49	seconds
3247	672	455	188.77	seconds
3248	606	456	193.62	seconds
3249	419	456	197.35	seconds
3250	678	455	198.29	seconds
3251	392	454	208.80	seconds
3252	335	455	\N	\N
3253	362	454	\N	\N
3254	651	456	\N	\N
3255	624	462	340.93	seconds
3256	366	460	344.46	seconds
3257	595	461	353.44	seconds
3258	688	462	354.44	seconds
3259	362	460	368.07	seconds
3260	455	460	368.80	seconds
3261	831	461	374.08	seconds
3262	683	460	386.14	seconds
3263	707	461	386.17	seconds
3264	422	462	395.87	seconds
3265	341	460	396.28	seconds
3266	323	460	396.71	seconds
3267	694	462	404.68	seconds
3268	672	461	410.75	seconds
3269	419	462	423.48	seconds
3270	678	461	434.71	seconds
3271	392	460	472.68	seconds
3272	651	462	505.12	seconds
3273	819	461	\N	\N
3274	688	468	783.18	seconds
3275	707	467	803.52	seconds
3276	831	467	821.95	seconds
3277	694	468	895.73	seconds
3278	672	467	902.58	seconds
3279	683	466	955.33	seconds
3280	819	467	\N	\N
3281	323	466	\N	\N
3282	341	466	\N	\N
3283	366	466	\N	\N
3284	419	468	\N	\N
3285	392	466	\N	\N
3286	422	468	\N	\N
3287	455	466	\N	\N
3288	606	468	\N	\N
3289	628	492	19.00	seconds
3290	664	491	21.08	seconds
3291	355	491	22.57	seconds
3292	657	491	23.20	seconds
3293	679	491	26.49	seconds
3294	658	490	28.18	seconds
3295	674	490	\N	\N
3296	617	503	50.00	seconds
3297	355	503	53.69	seconds
3298	664	503	57.80	seconds
3299	657	503	64.34	seconds
3300	679	503	67.65	seconds
3301	380	502	\N	\N
3302	674	502	\N	\N
3303	658	502	\N	\N
3304	356	527	413.50	inches
3305	440	527	338.50	inches
3306	448	526	330.50	inches
3307	677	527	313.25	inches
3308	461	528	306.00	inches
3309	650	527	263.00	inches
3310	334	526	262.50	inches
3311	406	527	260.50	inches
3312	390	528	257.00	inches
3313	692	528	243.50	inches
3314	443	528	240.25	inches
3315	666	528	236.50	inches
3316	601	528	229.00	inches
3317	404	528	224.00	inches
3318	680	527	207.50	inches
3319	426	528	206.00	inches
3320	686	526	197.25	inches
3321	670	526	197.00	inches
3322	675	527	189.00	inches
3323	326	526	174.50	inches
3324	667	528	147.50	inches
3325	357	527	\N	\N
3326	821	527	\N	\N
3327	827	526	\N	\N
3328	829	527	\N	\N
3329	677	521	867.50	inches
3330	440	521	816.00	inches
3331	461	522	779.00	inches
3332	448	520	644.00	inches
3333	670	520	614.00	inches
3334	692	522	610.00	inches
3335	406	521	606.00	inches
3336	601	522	597.00	inches
3337	686	520	593.00	inches
3338	680	521	558.00	inches
3339	426	522	557.00	inches
3340	404	522	552.00	inches
3341	443	522	529.00	inches
3342	667	522	517.00	inches
3343	666	522	500.00	inches
3344	650	521	473.25	inches
3345	390	522	428.25	inches
3346	334	520	427.00	inches
3347	675	521	383.00	inches
3348	356	521	\N	\N
3349	326	520	\N	\N
3350	357	521	\N	\N
3351	821	521	\N	\N
3352	827	520	\N	\N
3353	829	521	\N	\N
3354	333	534	58.00	inches
3355	350	534	54.00	inches
3356	626	534	52.00	inches
3357	613	534	48.00	inches
3358	664	533	48.00	inches
3359	623	534	44.00	inches
3360	667	534	44.00	inches
3361	593	532	42.00	inches
3362	380	532	\N	\N
3363	601	540	96.00	inches
3364	384	539	\N	\N
3365	342	538	\N	\N
3366	664	539	\N	\N
3367	347	508	176.00	inches
3368	452	510	172.00	inches
3369	429	510	156.00	inches
3370	322	510	152.50	inches
3371	663	508	149.00	inches
3372	424	508	148.00	inches
3373	613	510	148.00	inches
3374	649	510	148.00	inches
3375	328	508	141.00	inches
3376	651	510	136.00	inches
3377	416	508	130.00	inches
3378	678	509	114.50	inches
3379	593	508	100.00	inches
3380	333	510	\N	\N
3381	349	510	\N	\N
3382	701	509	\N	\N
3383	456	508	\N	\N
3384	394	508	\N	\N
3385	627	510	\N	\N
3386	626	516	347.50	inches
3387	322	516	332.00	inches
3388	429	516	325.00	inches
3389	613	516	295.00	inches
3390	408	515	\N	\N
3391	601	516	\N	\N
3392	649	516	\N	\N
3393	597	435	11.62	seconds
3394	391	435	12.06	seconds
3395	386	434	12.21	seconds
3396	383	435	12.27	seconds
3397	435	435	12.41	seconds
3398	438	435	12.46	seconds
3399	370	434	12.51	seconds
3400	605	433	12.54	seconds
3401	689	435	12.57	seconds
3402	407	435	12.60	seconds
3403	596	433	12.62	seconds
3404	685	433	12.66	seconds
3405	427	435	12.74	seconds
3406	332	434	12.83	seconds
3407	398	435	12.86	seconds
3408	421	433	12.89	seconds
3409	446	433	12.94	seconds
3410	439	433	12.98	seconds
3411	348	434	13.06	seconds
3412	699	434	13.09	seconds
3413	591	433	13.15	seconds
3414	327	434	13.51	seconds
3415	395	434	13.55	seconds
3416	655	433	13.55	seconds
3417	671	435	13.57	seconds
3418	604	433	13.84	seconds
3419	762	433	13.85	seconds
3420	402	434	13.90	seconds
3421	382	435	13.91	seconds
3422	665	433	13.92	seconds
3423	599	434	14.00	seconds
3424	345	433	14.09	seconds
3425	368	434	14.13	seconds
3426	437	435	14.14	seconds
3427	681	433	14.14	seconds
3428	652	433	14.20	seconds
3429	343	434	14.36	seconds
3430	457	435	14.47	seconds
3431	338	433	14.66	seconds
3432	331	434	15.13	seconds
3433	659	435	15.58	seconds
3434	354	435	\N	\N
3435	709	435	\N	\N
3436	374	433	\N	\N
3437	824	433	\N	\N
3438	687	434	\N	\N
3439	668	434	\N	\N
3440	830	433	\N	\N
3441	597	441	23.80	seconds
3442	386	440	25.18	seconds
3443	383	441	25.26	seconds
3444	689	441	25.40	seconds
3445	438	441	25.44	seconds
3446	407	441	26.03	seconds
3447	669	441	26.05	seconds
3448	332	440	26.17	seconds
3449	348	440	26.18	seconds
3450	605	439	26.18	seconds
3451	687	440	26.25	seconds
3452	596	439	26.28	seconds
3453	398	441	26.31	seconds
3454	693	439	26.67	seconds
3455	444	441	26.73	seconds
3456	446	439	26.86	seconds
3457	421	439	26.91	seconds
3458	768	441	26.96	seconds
3459	671	441	26.97	seconds
3460	425	441	26.98	seconds
3461	682	440	26.99	seconds
3462	699	440	27.09	seconds
3463	395	440	27.58	seconds
3464	451	440	27.70	seconds
3465	457	441	28.22	seconds
3466	599	440	28.47	seconds
3467	665	439	28.99	seconds
3468	402	440	29.20	seconds
3469	368	440	29.78	seconds
3470	346	439	29.99	seconds
3471	659	441	33.11	seconds
3472	371	441	35.10	seconds
3473	354	441	\N	\N
3474	331	440	\N	\N
3475	340	441	\N	\N
3476	382	441	\N	\N
3477	338	439	\N	\N
3478	370	440	\N	\N
3479	435	441	\N	\N
3480	652	439	\N	\N
3481	655	439	\N	\N
3482	685	439	\N	\N
3483	668	440	\N	\N
3484	709	441	\N	\N
3485	343	440	\N	\N
3486	818	441	\N	\N
3487	360	440	\N	\N
3488	374	439	\N	\N
3489	437	441	\N	\N
3490	439	439	\N	\N
3491	696	440	\N	\N
3492	673	440	\N	\N
3493	681	439	\N	\N
3494	830	439	\N	\N
3495	407	447	56.26	seconds
3496	768	447	58.21	seconds
3497	352	447	58.30	seconds
3498	689	447	58.61	seconds
3499	363	447	59.42	seconds
3500	325	447	59.76	seconds
3501	425	447	60.59	seconds
3502	459	446	61.00	seconds
3503	398	447	61.64	seconds
3504	671	447	61.92	seconds
3505	591	445	63.13	seconds
3506	622	445	63.14	seconds
3507	430	447	63.92	seconds
3508	364	445	65.75	seconds
3509	652	445	65.77	seconds
3510	704	445	66.69	seconds
3511	346	445	66.73	seconds
3512	360	446	68.22	seconds
3513	375	447	70.78	seconds
3514	371	447	75.36	seconds
3515	412	447	\N	\N
3516	444	447	\N	\N
3517	669	447	\N	\N
3518	699	446	\N	\N
3519	682	446	\N	\N
3520	655	445	\N	\N
3521	693	445	\N	\N
3522	709	447	\N	\N
3523	665	445	\N	\N
3524	830	445	\N	\N
3525	625	451	127.20	seconds
3526	592	452	128.20	seconds
3527	696	452	129.97	seconds
3528	705	453	132.75	seconds
3529	615	451	135.08	seconds
3530	351	451	135.83	seconds
3531	381	453	136.39	seconds
3532	600	453	138.40	seconds
3533	363	453	138.75	seconds
3534	409	453	145.33	seconds
3535	608	451	145.67	seconds
3536	458	453	151.46	seconds
3537	413	453	153.16	seconds
3538	442	453	154.15	seconds
3539	662	453	154.19	seconds
3540	449	453	155.35	seconds
3541	365	451	155.55	seconds
3542	410	451	155.91	seconds
3543	673	452	161.53	seconds
3544	698	451	162.22	seconds
3545	765	452	165.25	seconds
3546	432	453	165.69	seconds
3547	375	453	169.85	seconds
3548	436	452	171.15	seconds
3549	417	452	173.23	seconds
3550	400	451	174.91	seconds
3551	450	451	180.95	seconds
3552	691	451	188.20	seconds
3553	352	453	\N	\N
3554	387	453	\N	\N
3555	337	451	\N	\N
3556	411	452	\N	\N
3557	648	451	\N	\N
3558	325	453	\N	\N
3559	364	451	\N	\N
3560	434	452	\N	\N
3561	592	458	272.96	seconds
3562	612	459	281.47	seconds
3563	625	457	284.80	seconds
3564	696	458	291.47	seconds
3565	610	459	297.05	seconds
3566	351	457	301.45	seconds
3567	600	459	306.25	seconds
3568	619	457	308.58	seconds
3569	609	457	311.34	seconds
3570	608	457	314.02	seconds
3571	409	459	314.11	seconds
3572	337	457	315.23	seconds
3573	615	457	320.15	seconds
3574	449	459	333.10	seconds
3575	458	459	335.67	seconds
3576	673	458	337.42	seconds
3577	413	459	338.72	seconds
3578	662	459	341.08	seconds
3579	410	457	344.35	seconds
3580	765	458	346.02	seconds
3581	648	457	347.71	seconds
3582	434	458	348.34	seconds
3583	365	457	351.96	seconds
3584	387	459	355.83	seconds
3585	432	459	356.15	seconds
3586	436	458	358.91	seconds
3587	442	459	362.54	seconds
3588	411	458	363.64	seconds
3589	698	457	364.41	seconds
3590	372	457	372.47	seconds
3591	450	457	373.72	seconds
3592	417	458	379.03	seconds
3593	400	457	387.26	seconds
3594	691	457	414.30	seconds
3595	339	457	\N	\N
3596	393	459	\N	\N
3597	381	459	\N	\N
3598	336	458	\N	\N
3599	704	457	\N	\N
3600	648	463	767.87	seconds
3601	698	463	770.00	seconds
3602	336	464	\N	\N
3603	372	463	\N	\N
3604	337	463	\N	\N
3605	339	463	\N	\N
3606	409	465	\N	\N
3607	411	464	\N	\N
3608	436	464	\N	\N
3609	449	465	\N	\N
3610	458	465	\N	\N
3611	432	465	\N	\N
3612	413	465	\N	\N
3613	410	463	\N	\N
3614	400	463	\N	\N
3615	434	464	\N	\N
3616	450	463	\N	\N
3617	393	465	\N	\N
3618	442	465	\N	\N
3619	417	464	\N	\N
3620	765	464	\N	\N
3621	612	465	\N	\N
3622	610	465	\N	\N
3623	619	463	\N	\N
3624	609	463	\N	\N
3625	662	465	\N	\N
3626	704	463	\N	\N
3627	378	495	17.05	seconds
3628	656	495	18.22	seconds
3629	607	495	19.04	seconds
3630	391	495	20.00	seconds
3631	340	495	20.89	seconds
3632	396	495	21.85	seconds
3633	376	495	21.91	seconds
3634	604	493	21.95	seconds
3635	338	493	28.23	seconds
3636	656	501	46.00	seconds
3637	378	501	46.35	seconds
3638	391	501	52.06	seconds
3639	396	501	52.35	seconds
3640	607	501	\N	\N
3641	604	499	\N	\N
3642	661	525	609.00	inches
3643	460	524	522.25	inches
3644	344	525	448.00	inches
3645	445	525	444.50	inches
3646	453	525	435.00	inches
3647	431	525	416.75	inches
3648	703	525	403.50	inches
3649	321	525	396.25	inches
3650	618	525	387.50	inches
3651	653	524	385.50	inches
3652	397	524	381.00	inches
3653	441	524	379.00	inches
3654	327	524	372.00	inches
3655	700	524	356.00	inches
3656	373	525	350.25	inches
3657	415	524	347.50	inches
3658	329	525	328.50	inches
3659	377	525	328.50	inches
3660	414	524	309.75	inches
3661	375	525	285.00	inches
3662	820	523	282.00	inches
3663	598	523	224.50	inches
3664	684	523	204.50	inches
3665	379	523	\N	\N
3666	828	525	\N	\N
3667	826	523	\N	\N
3668	661	519	1582.00	inches
3669	460	518	1315.00	inches
3670	618	519	1121.50	inches
3671	653	518	1064.50	inches
3672	453	519	1059.00	inches
3673	703	519	1020.50	inches
3674	397	518	942.00	inches
3675	415	518	882.00	inches
3676	700	518	844.00	inches
3677	445	519	813.00	inches
3678	441	518	796.00	inches
3679	431	519	747.50	inches
3680	414	518	652.00	inches
3681	598	517	565.00	inches
3682	684	517	319.00	inches
3683	344	519	\N	\N
3684	329	519	\N	\N
3685	373	519	\N	\N
3686	321	519	\N	\N
3687	327	518	\N	\N
3688	820	517	\N	\N
3689	377	519	\N	\N
3690	379	517	\N	\N
3691	828	519	\N	\N
3692	826	517	\N	\N
3693	378	531	72.00	inches
3694	388	531	64.00	inches
3695	345	529	60.00	inches
3696	630	530	60.00	inches
3697	403	530	58.00	inches
3698	690	530	56.00	inches
3699	665	529	56.00	inches
3700	444	531	54.00	inches
3701	401	530	52.00	inches
3702	430	531	\N	\N
3703	681	529	\N	\N
3704	433	530	\N	\N
3705	823	531	\N	\N
3706	376	537	132.00	inches
3707	629	537	120.00	inches
3708	388	537	108.00	inches
3709	630	536	102.00	inches
3710	590	536	90.00	inches
3711	690	536	90.00	inches
3712	325	537	84.00	inches
3713	364	535	84.00	inches
3714	681	535	84.00	inches
3715	622	535	\N	\N
3716	705	537	\N	\N
3717	403	506	217.50	inches
3718	374	505	210.00	inches
3719	607	507	207.50	inches
3720	332	506	202.00	inches
3721	401	506	199.00	inches
3722	629	507	199.00	inches
3723	430	507	192.00	inches
3724	451	506	180.00	inches
3725	459	506	177.00	inches
3726	345	505	175.00	inches
3727	402	506	171.00	inches
3728	375	507	170.00	inches
3729	343	506	167.00	inches
3730	704	505	165.00	inches
3731	659	507	121.00	inches
3732	329	507	\N	\N
3733	412	507	\N	\N
3734	705	507	\N	\N
3735	690	506	\N	\N
3736	378	507	\N	\N
3737	383	507	\N	\N
3738	376	507	\N	\N
3739	386	506	\N	\N
3740	340	507	\N	\N
3741	818	507	\N	\N
3742	388	507	\N	\N
3743	433	506	\N	\N
3744	823	507	\N	\N
3745	822	507	\N	\N
3746	824	505	\N	\N
3747	604	505	\N	\N
3748	376	513	463.00	inches
3749	607	513	457.50	inches
3750	403	512	450.00	inches
3751	629	513	434.50	inches
3752	690	512	399.00	inches
3753	401	512	396.50	inches
3754	451	512	392.00	inches
3755	430	513	383.50	inches
3756	412	513	\N	\N
3757	340	513	\N	\N
3758	388	513	\N	\N
3759	824	511	\N	\N
3760	938	544	12.90	seconds
3761	68	545	13.47	seconds
3762	873	545	13.54	seconds
3763	1037	545	13.54	seconds
3764	528	544	13.72	seconds
3765	1033	546	13.75	seconds
3766	1101	544	13.77	seconds
3767	1112	546	13.92	seconds
3768	852	544	14.03	seconds
3769	1046	544	14.08	seconds
3770	916	546	14.18	seconds
3771	660	544	14.28	seconds
3772	925	546	14.35	seconds
3773	943	545	14.35	seconds
3774	918	546	14.41	seconds
3775	764	544	14.43	seconds
3776	1042	546	14.44	seconds
3777	452	546	14.50	seconds
3778	940	546	14.54	seconds
3779	663	544	14.62	seconds
3780	735	546	14.69	seconds
3781	849	544	14.76	seconds
3782	827	544	14.78	seconds
3783	926	545	14.83	seconds
3784	695	544	15.00	seconds
3785	594	544	15.17	seconds
3786	416	544	15.21	seconds
3787	908	546	15.29	seconds
3788	489	546	15.64	seconds
3789	933	546	16.66	seconds
3790	935	546	17.73	seconds
3791	498	545	\N	\N
3792	938	550	27.77	seconds
3793	57	551	28.01	seconds
3794	1094	552	28.18	seconds
3795	1101	550	28.47	seconds
3796	1084	552	28.63	seconds
3797	1042	552	28.76	seconds
3798	708	551	28.89	seconds
3799	943	551	29.00	seconds
3800	528	550	29.08	seconds
3801	852	550	29.40	seconds
3802	1046	550	29.47	seconds
3803	987	552	29.96	seconds
3804	916	552	30.21	seconds
3805	918	552	30.25	seconds
3806	926	551	30.29	seconds
3807	867	550	30.79	seconds
3808	695	550	31.08	seconds
3809	995	551	31.75	seconds
3810	594	550	31.78	seconds
3811	849	550	31.96	seconds
3812	428	551	32.29	seconds
3813	489	552	32.82	seconds
3814	908	552	33.11	seconds
3815	424	550	33.39	seconds
3816	702	551	33.52	seconds
3817	31	552	33.62	seconds
3818	933	552	34.03	seconds
3819	529	552	34.11	seconds
3820	640	551	34.50	seconds
3821	935	552	34.96	seconds
3822	423	551	\N	\N
3823	57	557	61.77	seconds
3824	1084	558	62.58	seconds
3825	676	556	62.99	seconds
3826	708	557	64.25	seconds
3827	462	558	67.05	seconds
3828	946	558	67.56	seconds
3829	875	558	70.80	seconds
3830	987	558	71.11	seconds
3831	922	557	72.00	seconds
3832	895	556	72.11	seconds
3833	501	558	72.67	seconds
3834	855	558	73.16	seconds
3835	763	556	73.27	seconds
3836	428	557	73.98	seconds
3837	1001	557	74.47	seconds
3838	640	557	74.50	seconds
3839	489	558	74.68	seconds
3840	529	558	75.35	seconds
3841	881	557	75.76	seconds
3842	702	557	77.55	seconds
3843	919	557	79.22	seconds
3844	423	557	\N	\N
3845	1118	562	144.41	seconds
3846	1026	563	149.66	seconds
3847	959	564	151.39	seconds
3848	624	564	151.78	seconds
3849	865	564	152.00	seconds
3850	676	562	152.10	seconds
3851	980	563	155.00	seconds
3852	939	563	160.72	seconds
3853	462	564	164.16	seconds
3854	455	562	165.21	seconds
3855	41	564	168.99	seconds
3856	831	563	169.06	seconds
3857	34	563	169.98	seconds
3858	53	563	171.03	seconds
3859	1120	564	171.29	seconds
3860	963	564	173.53	seconds
3861	694	564	173.68	seconds
3862	521	564	176.73	seconds
3863	889	563	177.12	seconds
3864	499	564	178.61	seconds
3865	866	563	179.93	seconds
3866	422	564	183.93	seconds
3867	909	563	188.91	seconds
3868	920	564	196.11	seconds
3869	419	564	197.35	seconds
3870	915	564	197.99	seconds
3871	1058	564	\N	\N
3872	624	570	335.93	seconds
3873	595	569	337.35	seconds
3874	1026	569	338.37	seconds
3875	939	569	341.51	seconds
3876	858	569	347.39	seconds
3877	1099	569	347.96	seconds
3878	688	570	351.16	seconds
3879	1102	569	357.07	seconds
3880	41	570	364.56	seconds
3881	455	568	366.00	seconds
3882	707	569	373.16	seconds
3883	521	570	374.42	seconds
3884	17	568	375.03	seconds
3885	982	569	375.06	seconds
3886	492	569	380.60	seconds
3887	34	569	382.39	seconds
3888	499	570	386.01	seconds
3889	862	570	387.18	seconds
3890	864	569	388.89	seconds
3891	963	570	390.20	seconds
3892	694	570	395.73	seconds
3893	422	570	395.87	seconds
3894	902	569	404.29	seconds
3895	996	569	413.71	seconds
3896	419	570	423.48	seconds
3897	901	569	424.11	seconds
3898	1058	570	454.91	seconds
3899	904	570	\N	\N
3900	1095	576	692.24	seconds
3901	1026	575	739.62	seconds
3902	688	576	749.10	seconds
3903	858	575	755.81	seconds
3904	980	575	768.22	seconds
3905	707	575	788.37	seconds
3906	831	575	790.99	seconds
3907	862	576	799.36	seconds
3908	17	574	805.55	seconds
3909	521	576	808.09	seconds
3910	982	575	820.16	seconds
3911	905	576	823.05	seconds
3912	492	575	824.97	seconds
3913	904	576	824.99	seconds
3914	455	574	850.45	seconds
3915	866	575	853.93	seconds
3916	486	576	868.65	seconds
3917	422	576	875.03	seconds
3918	958	575	927.98	seconds
3919	56	575	\N	\N
3920	1105	600	17.41	seconds
3921	940	600	17.66	seconds
3922	1094	600	18.31	seconds
3923	1043	598	18.94	seconds
3924	1086	600	19.37	seconds
3925	496	600	19.42	seconds
3926	971	600	19.61	seconds
3927	20	600	19.87	seconds
3928	861	600	20.05	seconds
3929	517	600	20.17	seconds
3930	860	600	20.32	seconds
3931	1045	600	20.62	seconds
3932	1023	600	20.82	seconds
3933	664	599	20.99	seconds
3934	891	600	21.25	seconds
3935	1040	598	21.39	seconds
3936	968	600	22.23	seconds
3937	679	599	22.36	seconds
3938	977	599	23.16	seconds
3939	657	599	23.20	seconds
3940	638	599	\N	\N
3941	1037	611	51.58	seconds
3942	940	612	53.25	seconds
3943	664	611	54.10	seconds
3944	971	612	54.33	seconds
3945	1045	612	54.56	seconds
3946	638	611	54.56	seconds
3947	891	612	54.65	seconds
3948	1043	610	54.96	seconds
3949	517	612	55.33	seconds
3950	1086	612	56.01	seconds
3951	1023	612	56.56	seconds
3952	861	612	56.68	seconds
3953	496	612	57.31	seconds
3954	860	612	57.83	seconds
3955	1040	610	58.80	seconds
3956	923	611	60.01	seconds
3957	679	611	61.70	seconds
3958	977	611	62.22	seconds
3959	501	612	62.30	seconds
3960	657	611	63.90	seconds
3961	992	612	76.44	seconds
3962	30	636	443.75	inches
3963	1041	636	399.75	inches
3964	1044	635	373.00	inches
3965	1047	636	369.50	inches
3966	953	636	364.50	inches
3967	835	636	352.50	inches
3968	440	635	338.50	inches
3969	503	636	337.00	inches
3970	1057	635	337.00	inches
3971	523	636	333.00	inches
3972	944	636	332.50	inches
3973	448	634	330.50	inches
3974	14	635	325.00	inches
3975	677	635	313.25	inches
3976	461	636	312.25	inches
3977	850	636	312.00	inches
3978	21	635	307.50	inches
3979	1011	636	305.00	inches
3980	1016	636	298.00	inches
3981	952	636	289.00	inches
3982	686	634	283.00	inches
3983	1100	635	281.50	inches
3984	834	636	279.00	inches
3985	500	635	266.00	inches
3986	692	636	243.50	inches
3987	953	630	1245.00	inches
3988	1041	630	1237.00	inches
3989	1123	630	1135.00	inches
3990	835	630	1125.00	inches
3991	1044	629	1038.00	inches
3992	503	630	1034.00	inches
3993	1057	629	1010.00	inches
3994	952	630	1006.00	inches
3995	827	628	977.00	inches
3996	523	630	957.50	inches
3997	14	629	939.00	inches
3998	1011	630	919.00	inches
3999	440	629	903.00	inches
4000	677	629	867.50	inches
4001	461	630	865.00	inches
4002	525	630	865.00	inches
4003	850	630	850.00	inches
4004	1047	630	840.00	inches
4005	1100	629	821.00	inches
4006	1016	630	820.00	inches
4007	848	628	772.00	inches
4008	969	630	765.00	inches
4009	21	629	704.00	inches
4010	30	630	673.00	inches
4011	448	628	659.00	inches
4012	692	630	630.00	inches
4013	1060	629	598.00	inches
4014	686	628	593.00	inches
4015	1105	642	62.00	inches
4016	487	641	56.00	inches
4017	1036	642	56.00	inches
4018	515	640	54.00	inches
4019	938	640	52.00	inches
4020	1097	642	52.00	inches
4021	860	642	50.00	inches
4022	971	642	50.00	inches
4023	849	640	48.00	inches
4024	925	642	48.00	inches
4025	498	641	48.00	inches
4026	967	642	48.00	inches
4027	664	641	48.00	inches
4028	986	641	46.00	inches
4029	857	641	44.00	inches
4030	24	641	42.00	inches
4031	408	641	\N	\N
4032	1035	648	108.00	inches
4033	1024	647	102.00	inches
4034	1045	648	96.00	inches
4035	1097	648	90.00	inches
4036	501	648	78.00	inches
4037	947	648	78.00	inches
4038	489	648	66.00	inches
4039	993	648	\N	\N
4040	664	647	\N	\N
4041	1046	646	\N	\N
4042	1094	618	195.00	inches
4043	1048	618	187.00	inches
4044	1049	618	186.00	inches
4045	873	617	181.00	inches
4046	487	617	178.00	inches
4047	938	616	173.50	inches
4048	1035	618	173.25	inches
4049	925	618	173.00	inches
4050	452	618	172.00	inches
4051	943	617	171.00	inches
4052	851	618	165.00	inches
4053	1043	616	165.00	inches
4054	533	617	162.00	inches
4055	867	616	161.50	inches
4056	515	616	157.00	inches
4057	429	618	156.00	inches
4058	638	617	154.00	inches
4059	663	616	153.25	inches
4060	424	616	148.00	inches
4061	24	617	142.00	inches
4062	984	617	139.75	inches
4063	1004	617	138.00	inches
4064	68	617	\N	\N
4065	1049	624	408.50	inches
4066	1105	624	396.50	inches
4067	1048	624	376.00	inches
4068	1036	624	373.00	inches
4069	1035	624	372.50	inches
4070	1092	623	363.00	inches
4071	533	623	359.50	inches
4072	851	624	357.50	inches
4073	943	623	355.00	inches
4074	515	622	351.50	inches
4075	867	622	346.00	inches
4076	638	623	342.25	inches
4077	429	624	325.00	inches
4078	855	624	320.00	inches
4079	961	623	319.00	inches
4080	498	623	317.50	inches
4081	1004	623	311.00	inches
4082	1112	624	\N	\N
4083	452	624	\N	\N
4084	1070	543	11.08	seconds
4085	937	541	11.34	seconds
4086	597	543	11.53	seconds
4087	1020	543	11.64	seconds
4088	876	543	11.78	seconds
4089	520	543	11.78	seconds
4090	871	543	11.79	seconds
4091	1014	543	11.85	seconds
4092	878	543	11.86	seconds
4093	1090	542	11.90	seconds
4094	482	543	11.92	seconds
4095	1069	543	11.93	seconds
4096	391	543	11.99	seconds
4097	1064	543	11.99	seconds
4098	65	543	12.11	seconds
4099	25	543	12.14	seconds
4100	485	543	12.23	seconds
4101	435	543	12.36	seconds
4102	438	543	12.46	seconds
4103	530	543	12.52	seconds
4104	1122	543	12.55	seconds
4105	798	543	12.60	seconds
4106	669	543	12.62	seconds
4107	47	543	12.66	seconds
4108	671	543	13.17	seconds
4109	945	543	13.22	seconds
4110	896	543	13.56	seconds
4111	911	543	13.69	seconds
4112	1053	543	14.31	seconds
4113	903	543	\N	\N
4114	928	543	\N	\N
4115	1085	543	\N	\N
4116	1082	541	11.77	seconds
4117	837	542	12.19	seconds
4118	794	541	12.21	seconds
4119	950	541	12.30	seconds
4120	927	542	12.32	seconds
4121	1061	541	12.33	seconds
4122	1017	542	12.55	seconds
4123	693	541	12.66	seconds
4124	519	542	12.67	seconds
4125	52	542	12.70	seconds
4126	998	542	12.72	seconds
4127	771	542	12.82	seconds
4128	421	541	12.89	seconds
4129	801	542	12.89	seconds
4130	748	542	12.91	seconds
4131	11	542	12.93	seconds
4132	1038	542	12.94	seconds
4133	863	541	13.12	seconds
4134	844	542	13.15	seconds
4135	395	542	13.21	seconds
4136	1003	541	13.22	seconds
4137	478	542	13.28	seconds
4138	682	542	13.33	seconds
4139	1031	541	13.35	seconds
4140	665	541	13.72	seconds
4141	932	542	14.33	seconds
4142	465	541	14.85	seconds
4143	1055	542	\N	\N
4144	749	542	\N	\N
4145	597	549	23.35	seconds
4146	937	547	23.48	seconds
4147	1020	549	23.79	seconds
4148	1070	549	23.80	seconds
4149	1027	549	24.15	seconds
4150	520	549	24.21	seconds
4151	1030	549	24.82	seconds
4152	65	549	24.89	seconds
4153	438	549	24.98	seconds
4154	1050	549	25.07	seconds
4155	482	549	25.11	seconds
4156	689	549	25.15	seconds
4157	912	549	25.21	seconds
4158	669	549	25.38	seconds
4159	25	549	25.41	seconds
4160	924	549	25.60	seconds
4161	47	549	25.79	seconds
4162	1098	549	25.85	seconds
4163	407	549	26.03	seconds
4164	1122	549	26.04	seconds
4165	945	549	26.08	seconds
4166	485	549	26.39	seconds
4167	806	549	26.84	seconds
4168	671	549	26.97	seconds
4169	511	549	28.27	seconds
4170	896	549	29.11	seconds
4171	391	549	\N	\N
4172	928	549	\N	\N
4173	936	549	\N	\N
4174	972	549	\N	\N
4175	1085	549	\N	\N
4176	1072	547	23.80	seconds
4177	837	548	24.59	seconds
4178	927	548	24.80	seconds
4179	998	548	24.83	seconds
4180	877	547	24.88	seconds
4181	794	547	25.13	seconds
4182	1125	548	25.31	seconds
4183	838	548	25.36	seconds
4184	973	548	25.42	seconds
4185	5	548	25.52	seconds
4186	1088	548	25.74	seconds
4187	898	548	25.89	seconds
4188	61	547	26.00	seconds
4189	1080	547	26.24	seconds
4190	693	547	26.25	seconds
4191	1091	547	26.28	seconds
4192	900	548	26.31	seconds
4193	749	548	26.53	seconds
4194	1031	547	26.59	seconds
4195	991	548	26.71	seconds
4196	1062	547	26.73	seconds
4197	421	547	26.91	seconds
4198	682	548	26.99	seconds
4199	748	548	26.99	seconds
4200	931	548	27.49	seconds
4201	395	548	27.58	seconds
4202	917	548	27.62	seconds
4203	451	548	27.70	seconds
4204	801	548	28.67	seconds
4205	502	548	28.94	seconds
4206	665	547	28.99	seconds
4207	465	547	30.00	seconds
4208	1055	548	\N	\N
4209	912	555	52.81	seconds
4210	859	555	53.42	seconds
4211	924	555	53.98	seconds
4212	853	555	54.08	seconds
4213	23	555	54.23	seconds
4214	1066	555	55.10	seconds
4215	37	555	55.32	seconds
4216	407	555	56.26	seconds
4217	1109	555	56.42	seconds
4218	1126	555	56.44	seconds
4219	22	555	56.55	seconds
4220	531	555	57.59	seconds
4221	880	555	57.77	seconds
4222	689	555	57.89	seconds
4223	1050	555	58.61	seconds
4224	1076	555	58.66	seconds
4225	906	555	59.22	seconds
4226	425	555	60.59	seconds
4227	671	555	60.86	seconds
4228	398	555	61.64	seconds
4229	493	555	\N	\N
4230	802	553	53.31	seconds
4231	997	554	53.71	seconds
4232	898	554	54.56	seconds
4233	1110	553	55.41	seconds
4234	877	553	55.44	seconds
4235	1124	554	55.87	seconds
4236	780	553	56.42	seconds
4237	749	554	56.66	seconds
4238	900	554	56.91	seconds
4239	838	554	57.40	seconds
4240	1072	553	57.51	seconds
4241	495	554	57.54	seconds
4242	1032	554	57.99	seconds
4243	748	554	58.51	seconds
4244	32	554	58.61	seconds
4245	991	554	59.53	seconds
4246	1080	553	59.77	seconds
4247	832	553	59.98	seconds
4248	917	554	59.99	seconds
4249	5	554	60.56	seconds
4250	1062	553	60.95	seconds
4251	990	554	61.09	seconds
4252	931	554	61.50	seconds
4253	682	554	64.12	seconds
4254	652	553	64.57	seconds
4255	465	553	\N	\N
4256	932	554	\N	\N
4257	1056	553	\N	\N
4258	690	554	\N	\N
4259	516	561	117.76	seconds
4260	1019	561	124.18	seconds
4261	592	560	124.46	seconds
4262	1117	561	125.00	seconds
4263	1073	560	125.58	seconds
4264	1077	561	126.18	seconds
4265	1119	561	127.00	seconds
4266	972	561	128.97	seconds
4267	1074	561	130.00	seconds
4268	841	561	131.07	seconds
4269	481	561	135.15	seconds
4270	907	561	135.97	seconds
4271	836	561	136.35	seconds
4272	1126	561	136.53	seconds
4273	906	561	139.11	seconds
4274	839	561	139.42	seconds
4275	910	560	139.81	seconds
4276	988	561	140.42	seconds
4277	1116	561	144.10	seconds
4278	458	561	147.74	seconds
4279	936	561	148.39	seconds
4280	413	561	149.56	seconds
4281	662	561	150.12	seconds
4282	975	561	150.37	seconds
4283	449	561	152.35	seconds
4284	1052	561	233.29	seconds
4285	929	561	\N	\N
4286	625	559	124.27	seconds
4287	997	560	126.36	seconds
4288	39	560	128.45	seconds
4289	1021	560	130.13	seconds
4290	752	560	130.13	seconds
4291	999	560	131.31	seconds
4292	1034	560	132.73	seconds
4293	810	560	132.90	seconds
4294	514	559	133.01	seconds
4295	1067	560	135.00	seconds
4296	615	559	135.08	seconds
4297	884	560	137.46	seconds
4298	608	559	138.00	seconds
4299	1078	560	138.07	seconds
4300	48	560	138.20	seconds
4301	1032	560	138.73	seconds
4302	787	559	139.30	seconds
4303	1079	560	140.32	seconds
4304	845	560	140.73	seconds
4305	897	560	142.30	seconds
4306	815	560	144.15	seconds
4307	951	559	148.00	seconds
4308	847	559	151.66	seconds
4309	899	560	151.99	seconds
4310	410	559	155.91	seconds
4311	754	559	160.55	seconds
4312	765	560	161.12	seconds
4313	434	560	161.72	seconds
4314	698	559	162.22	seconds
4315	1051	560	164.19	seconds
4316	691	559	185.55	seconds
4317	516	567	262.73	seconds
4318	592	566	272.96	seconds
4319	1019	567	275.24	seconds
4320	1073	566	278.74	seconds
4321	490	567	286.65	seconds
4322	1077	567	291.48	seconds
4323	481	567	292.77	seconds
4324	911	567	296.91	seconds
4325	910	566	298.11	seconds
4326	841	567	300.46	seconds
4327	970	567	302.93	seconds
4328	978	567	303.99	seconds
4329	833	567	307.59	seconds
4330	869	567	309.84	seconds
4331	1013	567	310.42	seconds
4332	409	567	311.85	seconds
4333	1074	567	316.10	seconds
4334	458	567	327.22	seconds
4335	975	567	328.26	seconds
4336	413	567	331.00	seconds
4337	662	567	333.17	seconds
4338	903	567	335.16	seconds
4339	929	567	\N	\N
4340	752	566	281.18	seconds
4341	625	565	283.59	seconds
4342	470	566	284.93	seconds
4343	810	566	286.51	seconds
4344	1000	566	287.82	seconds
4345	39	566	293.23	seconds
4346	999	566	293.45	seconds
4347	1021	566	293.84	seconds
4348	514	565	293.87	seconds
4349	815	566	294.72	seconds
4350	874	566	297.35	seconds
4351	1034	566	300.89	seconds
4352	1078	566	302.14	seconds
4353	619	565	302.88	seconds
4354	36	566	303.22	seconds
4355	13	567	303.84	seconds
4356	884	566	305.39	seconds
4357	897	566	306.25	seconds
4358	787	565	306.46	seconds
4359	845	566	306.68	seconds
4360	609	565	307.41	seconds
4361	1104	565	308.45	seconds
4362	951	565	316.29	seconds
4363	1025	566	318.94	seconds
4364	717	565	319.49	seconds
4365	1067	566	325.00	seconds
4366	1079	566	328.96	seconds
4367	410	565	344.35	seconds
4368	765	566	346.02	seconds
4369	436	566	347.78	seconds
4370	754	565	352.03	seconds
4371	1051	566	356.72	seconds
4372	698	565	357.95	seconds
4373	771	566	358.30	seconds
4374	932	566	365.64	seconds
4375	899	566	366.99	seconds
4376	921	566	381.07	seconds
4377	691	565	414.30	seconds
4378	472	565	433.02	seconds
4379	516	573	604.07	seconds
4380	1103	573	613.19	seconds
4381	490	573	620.79	seconds
4382	1111	573	624.08	seconds
4383	913	573	659.41	seconds
4384	978	573	665.51	seconds
4385	970	573	666.20	seconds
4386	833	573	674.60	seconds
4387	907	573	683.41	seconds
4388	836	573	683.99	seconds
4389	914	572	692.01	seconds
4390	1013	573	695.38	seconds
4391	409	573	712.35	seconds
4392	458	573	713.48	seconds
4393	662	573	734.81	seconds
4394	432	573	786.98	seconds
4395	885	573	803.11	seconds
4396	481	573	\N	\N
4397	929	573	\N	\N
4398	1000	572	625.57	seconds
4399	874	572	638.79	seconds
4400	13	573	653.15	seconds
4401	36	572	653.20	seconds
4402	1015	572	663.22	seconds
4403	1025	572	673.08	seconds
4404	965	572	681.05	seconds
4405	787	571	686.89	seconds
4406	717	571	694.37	seconds
4407	883	572	700.12	seconds
4408	795	571	729.67	seconds
4409	870	571	763.75	seconds
4410	436	572	768.13	seconds
4411	698	571	770.00	seconds
4412	765	572	784.34	seconds
4413	450	571	823.69	seconds
4414	470	572	\N	\N
4415	514	571	\N	\N
4416	934	572	\N	\N
4417	491	590	10.18	seconds
4418	802	589	10.52	seconds
4419	62	590	10.70	seconds
4420	8	590	10.99	seconds
4421	893	590	11.05	seconds
4422	1056	589	11.37	seconds
4423	784	589	11.39	seconds
4424	1017	590	11.56	seconds
4425	1015	590	11.68	seconds
4426	1113	589	11.87	seconds
4427	1075	590	11.96	seconds
4428	983	589	12.42	seconds
4429	887	589	13.07	seconds
4430	962	590	13.14	seconds
4431	478	590	\N	\N
4432	1059	590	\N	\N
4433	1127	590	\N	\N
4434	890	603	15.97	seconds
4435	1108	603	16.06	seconds
4436	54	603	17.18	seconds
4437	872	603	17.72	seconds
4438	1081	603	17.77	seconds
4439	527	603	17.84	seconds
4440	656	603	18.04	seconds
4441	1007	603	18.14	seconds
4442	1114	603	18.41	seconds
4443	956	603	19.58	seconds
4444	955	603	20.70	seconds
4445	396	603	21.67	seconds
4446	799	601	22.13	seconds
4447	1076	603	22.44	seconds
4448	808	602	\N	\N
4449	1093	609	41.18	seconds
4450	879	609	43.27	seconds
4451	656	609	44.13	seconds
4452	54	609	44.92	seconds
4453	1064	609	45.12	seconds
4454	1066	609	45.32	seconds
4455	872	609	45.35	seconds
4456	890	609	45.40	seconds
4457	527	609	46.33	seconds
4458	1007	609	46.39	seconds
4459	956	609	48.98	seconds
4460	1076	609	49.15	seconds
4461	396	609	51.21	seconds
4462	955	609	52.94	seconds
4463	808	608	\N	\N
4464	62	608	45.87	seconds
4465	802	607	46.17	seconds
4466	491	608	46.40	seconds
4467	1124	608	46.43	seconds
4468	893	608	48.01	seconds
4469	1015	608	49.32	seconds
4470	8	608	49.88	seconds
4471	478	608	49.92	seconds
4472	1075	608	50.18	seconds
4473	784	607	50.29	seconds
4474	983	607	51.88	seconds
4475	887	607	57.10	seconds
4476	965	608	57.88	seconds
4477	962	608	58.58	seconds
4478	1059	608	\N	\N
4479	1127	608	\N	\N
4480	661	633	609.00	inches
4481	878	633	577.00	inches
4482	1096	633	516.50	inches
4483	1121	633	503.25	inches
4484	846	633	495.50	inches
4485	497	633	495.00	inches
4486	1083	633	493.00	inches
4487	518	633	476.00	inches
4488	966	633	468.00	inches
4489	1071	633	450.50	inches
4490	949	633	449.00	inches
4491	445	633	444.50	inches
4492	737	633	437.25	inches
4493	1087	633	436.00	inches
4494	1107	633	435.00	inches
4495	512	633	427.75	inches
4496	431	633	423.00	inches
4497	1065	633	420.00	inches
4498	942	633	413.00	inches
4499	888	633	403.50	inches
4500	703	633	403.50	inches
4501	59	633	402.00	inches
4502	1029	633	399.00	inches
4503	33	633	394.50	inches
4504	50	633	393.00	inches
4505	1010	633	380.50	inches
4506	1053	633	285.00	inches
4507	1052	633	231.50	inches
4508	460	632	557.00	inches
4509	856	632	466.00	inches
4510	1002	632	460.00	inches
4511	792	631	454.50	inches
4512	76	632	447.00	inches
4513	791	631	432.00	inches
4514	981	632	417.00	inches
4515	1128	631	405.00	inches
4516	1012	631	399.00	inches
4517	397	632	390.75	inches
4518	51	631	376.00	inches
4519	700	632	356.00	inches
4520	826	631	344.75	inches
4521	488	632	335.50	inches
4522	892	631	323.00	inches
4523	775	631	288.00	inches
4524	1054	631	272.50	inches
4525	684	631	212.50	inches
4526	957	631	\N	\N
4527	1068	632	\N	\N
4528	878	627	1663.00	inches
4529	1096	627	1598.00	inches
4530	661	627	1582.00	inches
4531	1087	627	1522.00	inches
4532	1121	627	1518.00	inches
4533	1089	627	1510.00	inches
4534	497	627	1509.00	inches
4535	942	627	1457.00	inches
4536	966	627	1399.00	inches
4537	846	627	1322.00	inches
4538	1065	627	1320.00	inches
4539	1083	627	1281.00	inches
4540	532	627	1273.00	inches
4541	518	627	1273.00	inches
4542	737	627	1260.00	inches
4543	33	627	1222.00	inches
4544	50	627	1212.00	inches
4545	949	627	1167.00	inches
4546	703	627	1133.00	inches
4547	1010	627	1102.00	inches
4548	1071	627	1091.00	inches
4549	67	627	1083.00	inches
4550	431	627	877.00	inches
4551	445	627	869.00	inches
4552	1029	627	856.00	inches
4553	842	627	722.00	inches
4554	1052	627	613.00	inches
4555	1002	626	1346.00	inches
4556	460	626	1315.00	inches
4557	954	626	1186.00	inches
4558	856	626	1142.00	inches
4559	1068	626	1135.00	inches
4560	76	626	1089.00	inches
4561	488	626	1039.00	inches
4562	1128	625	1020.00	inches
4563	792	625	1002.00	inches
4564	892	625	969.00	inches
4565	397	626	967.00	inches
4566	941	625	965.00	inches
4567	700	626	937.00	inches
4568	791	625	922.00	inches
4569	921	626	920.00	inches
4570	1012	625	870.00	inches
4571	51	625	855.00	inches
4572	826	625	838.00	inches
4573	1054	625	595.00	inches
4574	775	625	504.00	inches
4575	684	625	499.00	inches
4576	985	639	70.00	inches
4577	27	639	68.00	inches
4578	1093	639	68.00	inches
4579	879	639	66.00	inches
4580	890	639	66.00	inches
4581	49	639	66.00	inches
4582	509	639	64.00	inches
4583	1115	639	64.00	inches
4584	522	639	62.00	inches
4585	872	639	60.00	inches
4586	1039	639	60.00	inches
4587	823	639	58.00	inches
4588	979	639	\N	\N
4589	781	637	70.00	inches
4590	1088	638	64.00	inches
4591	948	638	62.00	inches
4592	960	637	62.00	inches
4593	976	637	62.00	inches
4594	1021	638	62.00	inches
4595	403	638	60.00	inches
4596	507	638	60.00	inches
4597	630	638	60.00	inches
4598	1080	637	60.00	inches
4599	805	637	58.00	inches
4600	665	637	56.00	inches
4601	886	637	54.00	inches
4602	843	638	\N	\N
4603	433	638	\N	\N
4604	681	637	\N	\N
4605	451	638	\N	\N
4606	693	637	\N	\N
4607	1106	645	156.00	inches
4608	1018	645	150.00	inches
4609	527	645	126.00	inches
4610	989	645	126.00	inches
4611	505	645	120.00	inches
4612	956	645	120.00	inches
4613	1006	645	120.00	inches
4614	629	645	120.00	inches
4615	493	645	114.00	inches
4616	27	645	108.00	inches
4617	1090	644	108.00	inches
4618	879	645	102.00	inches
4619	882	645	84.00	inches
4620	833	645	\N	\N
4621	79	643	120.00	inches
4622	61	643	120.00	inches
4623	1017	644	114.00	inches
4624	1125	644	114.00	inches
4625	630	644	102.00	inches
4626	1061	643	102.00	inches
4627	690	644	102.00	inches
4628	1113	643	96.00	inches
4629	71	644	90.00	inches
4630	974	644	90.00	inches
4631	950	643	90.00	inches
4632	681	643	84.00	inches
4633	964	643	\N	\N
4634	845	644	\N	\N
4635	1022	643	\N	\N
4636	937	613	253.00	inches
4637	1018	615	249.00	inches
4638	1070	615	241.50	inches
4639	871	615	235.00	inches
4640	985	615	226.00	inches
4641	859	615	225.00	inches
4642	1014	615	218.00	inches
4643	49	615	217.00	inches
4644	1039	615	217.00	inches
4645	509	615	216.00	inches
4646	1063	615	215.00	inches
4647	1122	615	212.50	inches
4648	530	615	211.50	inches
4649	534	615	205.00	inches
4650	989	615	204.50	inches
4651	876	615	200.00	inches
4652	1081	615	197.00	inches
4653	430	615	192.00	inches
4654	412	615	188.75	inches
4655	823	615	150.50	inches
4656	979	615	\N	\N
4657	689	615	\N	\N
4658	519	614	230.00	inches
4659	1125	614	224.00	inches
4660	1110	613	223.00	inches
4661	403	614	217.50	inches
4662	1091	613	214.00	inches
4663	491	614	212.50	inches
4664	1038	614	212.50	inches
4665	1072	613	210.00	inches
4666	1075	614	209.50	inches
4667	976	613	209.00	inches
4668	781	613	207.00	inches
4669	1082	613	204.00	inches
4670	478	614	202.00	inches
4671	973	614	198.50	inches
4672	893	614	197.00	inches
4673	771	614	195.25	inches
4674	844	614	193.00	inches
4675	960	613	192.00	inches
4676	690	614	191.00	inches
4677	451	614	181.00	inches
4678	433	614	178.00	inches
4679	843	614	174.50	inches
4680	1022	613	164.50	inches
4681	1031	613	\N	\N
4682	1055	614	\N	\N
4683	1018	621	530.50	inches
4684	985	621	487.00	inches
4685	859	621	475.50	inches
4686	509	621	467.00	inches
4687	1063	621	457.50	inches
4688	530	621	420.50	inches
4689	1039	621	412.50	inches
4690	1009	621	412.50	inches
4691	989	621	404.00	inches
4692	508	621	397.00	inches
4693	840	621	393.00	inches
4694	430	621	383.50	inches
4695	979	621	381.50	inches
4696	868	621	379.00	inches
4697	412	621	368.50	inches
4698	823	621	\N	\N
4699	519	620	501.00	inches
4700	403	620	457.00	inches
4701	802	619	448.00	inches
4702	781	619	430.50	inches
4703	1038	620	412.50	inches
4704	948	620	411.50	inches
4705	843	620	400.00	inches
4706	844	620	399.50	inches
4707	690	620	399.50	inches
4708	451	620	392.00	inches
4709	894	619	379.00	inches
4710	994	620	377.00	inches
4711	433	620	370.00	inches
4712	974	620	352.50	inches
4713	1022	619	324.50	inches
4714	1055	620	\N	\N
4715	528	652	13.72	seconds
4716	617	653	13.98	seconds
4717	827	652	14.78	seconds
4718	825	654	14.89	seconds
4719	594	652	15.17	seconds
4720	328	652	15.39	seconds
4721	369	654	15.46	seconds
4722	477	653	16.23	seconds
4723	464	652	16.53	seconds
4724	620	652	17.30	seconds
4725	357	653	17.57	seconds
4726	777	653	17.91	seconds
4727	770	653	\N	\N
4728	627	660	27.10	seconds
4729	528	658	29.08	seconds
4730	825	660	31.22	seconds
4731	611	659	31.74	seconds
4732	594	658	31.78	seconds
4733	623	660	31.91	seconds
4734	328	658	32.25	seconds
4735	358	658	32.62	seconds
4736	384	659	32.68	seconds
4737	385	658	33.69	seconds
4738	342	658	34.77	seconds
4739	464	658	34.95	seconds
4740	477	659	35.05	seconds
4741	620	658	37.71	seconds
4742	777	659	39.48	seconds
4743	334	658	\N	\N
4744	770	659	\N	\N
4745	367	659	\N	\N
4746	357	659	\N	\N
4747	369	660	\N	\N
4748	367	665	60.62	seconds
4749	628	666	64.24	seconds
4750	611	665	70.57	seconds
4751	623	666	73.85	seconds
4752	489	666	74.68	seconds
4753	529	666	75.35	seconds
4754	335	665	75.37	seconds
4755	358	664	76.35	seconds
4756	385	664	76.80	seconds
4757	342	664	80.50	seconds
4758	380	664	\N	\N
4759	1130	665	\N	\N
4760	624	672	151.78	seconds
4761	366	670	154.98	seconds
4762	595	671	157.31	seconds
4763	362	670	166.51	seconds
4764	335	671	173.75	seconds
4765	521	672	176.73	seconds
4766	499	672	178.61	seconds
4767	341	670	182.10	seconds
4768	606	672	183.96	seconds
4769	474	672	192.31	seconds
4770	469	670	\N	\N
4771	819	671	\N	\N
4772	624	678	335.93	seconds
4773	595	677	337.35	seconds
4774	366	676	338.73	seconds
4775	819	677	339.01	seconds
4776	362	676	362.37	seconds
4777	469	676	372.04	seconds
4778	521	678	374.42	seconds
4779	492	677	380.60	seconds
4780	499	678	386.01	seconds
4781	486	678	390.43	seconds
4782	474	678	\N	\N
4783	521	684	808.09	seconds
4784	492	683	824.97	seconds
4785	341	682	859.35	seconds
4786	499	684	868.61	seconds
4787	486	684	868.65	seconds
4788	606	684	894.38	seconds
4789	469	682	\N	\N
4790	628	708	19.28	seconds
4791	496	708	19.42	seconds
4792	517	708	20.17	seconds
4793	355	707	20.78	seconds
4794	501	708	22.03	seconds
4795	347	706	\N	\N
4796	617	719	50.86	seconds
4797	355	719	53.69	seconds
4798	517	720	55.33	seconds
4799	496	720	57.31	seconds
4800	501	720	62.30	seconds
4801	380	718	\N	\N
4802	503	744	337.00	inches
4803	523	744	333.00	inches
4804	827	742	293.00	inches
4805	526	744	276.50	inches
4806	500	743	266.00	inches
4807	334	742	262.50	inches
4808	601	744	231.50	inches
4809	357	743	198.50	inches
4810	326	742	174.50	inches
4811	811	743	\N	\N
4812	349	744	\N	\N
4813	783	743	\N	\N
4814	503	738	1034.00	inches
4815	827	736	977.00	inches
4816	523	738	957.50	inches
4817	525	738	865.00	inches
4818	526	738	858.00	inches
4819	601	738	749.75	inches
4820	500	737	726.00	inches
4821	533	737	650.50	inches
4822	334	736	454.00	inches
4823	357	737	409.00	inches
4824	326	736	344.00	inches
4825	811	737	\N	\N
4826	349	738	\N	\N
4827	350	750	58.00	inches
4828	487	749	56.00	inches
4829	515	748	54.00	inches
4830	380	748	52.00	inches
4831	626	750	52.00	inches
4832	498	749	48.00	inches
4833	623	750	44.00	inches
4834	593	748	42.00	inches
4835	524	749	\N	\N
4836	601	756	108.00	inches
4837	501	756	78.00	inches
4838	342	754	72.00	inches
4839	489	756	66.00	inches
4840	384	755	\N	\N
4841	627	726	181.50	inches
4842	487	725	178.00	inches
4843	347	724	176.00	inches
4844	498	725	169.00	inches
4845	533	725	162.00	inches
4846	515	724	157.00	inches
4847	349	726	154.75	inches
4848	536	726	148.00	inches
4849	328	724	141.00	inches
4850	524	725	127.00	inches
4851	593	724	100.00	inches
4852	350	726	\N	\N
4853	601	732	367.50	inches
4854	533	731	359.50	inches
4855	515	730	351.50	inches
4856	626	732	347.50	inches
4857	536	732	318.50	inches
4858	498	731	317.50	inches
4859	524	731	274.50	inches
4860	597	651	11.53	seconds
4861	520	651	11.78	seconds
4862	482	651	11.92	seconds
4863	386	650	12.04	seconds
4864	383	651	12.19	seconds
4865	794	649	12.21	seconds
4866	485	651	12.23	seconds
4867	370	650	12.41	seconds
4868	605	649	12.46	seconds
4869	530	651	12.52	seconds
4870	596	649	12.55	seconds
4871	591	649	12.62	seconds
4872	348	650	12.64	seconds
4873	332	650	12.70	seconds
4874	824	649	12.71	seconds
4875	771	650	12.82	seconds
4876	479	649	12.83	seconds
4877	801	650	12.89	seconds
4878	374	649	12.96	seconds
4879	604	649	13.01	seconds
4880	354	651	13.02	seconds
4881	806	651	13.04	seconds
4882	478	650	13.28	seconds
4883	327	650	13.29	seconds
4884	463	650	13.44	seconds
4885	484	649	13.54	seconds
4886	502	650	13.69	seconds
4887	599	650	13.77	seconds
4888	382	651	13.91	seconds
4889	368	650	14.01	seconds
4890	345	649	14.07	seconds
4891	343	650	14.36	seconds
4892	475	651	14.83	seconds
4893	465	649	14.85	seconds
4894	476	649	\N	\N
4895	376	651	\N	\N
4896	818	651	\N	\N
4897	928	651	\N	\N
4898	930	649	\N	\N
4899	598	649	\N	\N
4900	597	657	23.35	seconds
4901	520	657	24.21	seconds
4902	386	656	24.86	seconds
4903	482	657	25.11	seconds
4904	794	655	25.13	seconds
4905	383	657	25.26	seconds
4906	370	656	25.37	seconds
4907	340	657	25.42	seconds
4908	605	655	25.42	seconds
4909	332	656	25.94	seconds
4910	348	656	26.18	seconds
4911	596	655	26.19	seconds
4912	485	657	26.39	seconds
4913	806	657	26.84	seconds
4914	779	655	27.02	seconds
4915	360	656	27.82	seconds
4916	599	656	27.99	seconds
4917	368	656	28.43	seconds
4918	484	655	28.64	seconds
4919	502	656	28.94	seconds
4920	476	655	29.39	seconds
4921	603	657	29.48	seconds
4922	465	655	30.00	seconds
4923	343	656	30.47	seconds
4924	371	657	34.17	seconds
4925	354	657	\N	\N
4926	382	657	\N	\N
4927	463	656	\N	\N
4928	473	655	\N	\N
4929	479	655	\N	\N
4930	475	657	\N	\N
4931	928	657	\N	\N
4932	930	655	\N	\N
4933	802	661	53.31	seconds
4934	780	661	56.42	seconds
4935	473	661	56.92	seconds
4936	495	662	57.54	seconds
4937	531	663	57.59	seconds
4938	352	663	57.81	seconds
4939	340	663	57.96	seconds
4940	325	663	59.76	seconds
4941	591	661	60.72	seconds
4942	337	661	61.04	seconds
4943	785	661	62.06	seconds
4944	622	661	62.49	seconds
4945	476	661	63.63	seconds
4946	360	662	65.16	seconds
4947	364	661	65.45	seconds
4948	375	663	68.14	seconds
4949	371	663	75.36	seconds
4950	465	661	\N	\N
4951	484	661	\N	\N
4952	516	669	117.76	seconds
4953	625	667	124.27	seconds
4954	592	668	124.46	seconds
4955	470	668	131.33	seconds
4956	514	667	133.01	seconds
4957	363	669	133.68	seconds
4958	615	667	135.08	seconds
4959	481	669	135.15	seconds
4960	600	669	136.77	seconds
4961	608	667	138.00	seconds
4962	787	667	139.30	seconds
4963	352	669	145.85	seconds
4964	337	667	147.06	seconds
4965	504	668	152.31	seconds
4966	365	667	155.55	seconds
4967	364	667	159.17	seconds
4968	375	669	162.15	seconds
4969	339	667	\N	\N
4970	929	669	\N	\N
4971	810	668	\N	\N
4972	516	675	262.73	seconds
4973	592	674	272.96	seconds
4974	612	675	278.63	seconds
4975	625	673	283.59	seconds
4976	470	674	284.93	seconds
4977	810	674	286.51	seconds
4978	490	675	286.65	seconds
4979	481	675	292.77	seconds
4980	514	673	293.87	seconds
4981	600	675	298.28	seconds
4982	381	675	298.81	seconds
4983	351	673	301.45	seconds
4984	619	673	302.88	seconds
4985	787	673	306.46	seconds
4986	609	673	307.41	seconds
4987	608	673	311.47	seconds
4988	795	673	332.16	seconds
4989	339	673	344.78	seconds
4990	504	674	346.95	seconds
4991	365	673	349.36	seconds
4992	387	675	355.83	seconds
4993	372	673	356.67	seconds
4994	472	673	433.02	seconds
4995	336	674	\N	\N
4996	929	675	\N	\N
4997	612	681	595.01	seconds
4998	490	681	620.79	seconds
4999	610	681	652.79	seconds
5000	619	679	668.90	seconds
5001	609	679	680.63	seconds
5002	787	679	686.89	seconds
5003	795	679	729.67	seconds
5004	372	679	784.73	seconds
5005	336	680	\N	\N
5006	470	680	\N	\N
5007	514	679	\N	\N
5008	387	681	\N	\N
5009	351	679	\N	\N
5010	929	681	\N	\N
5011	378	711	16.68	seconds
5012	527	711	17.84	seconds
5013	491	710	18.35	seconds
5014	802	709	18.84	seconds
5015	784	709	19.75	seconds
5016	376	711	20.41	seconds
5017	478	710	20.57	seconds
5018	604	709	21.95	seconds
5019	799	709	22.13	seconds
5020	808	710	\N	\N
5021	378	717	44.65	seconds
5022	802	715	46.17	seconds
5023	527	717	46.33	seconds
5024	491	716	46.40	seconds
5025	478	716	49.92	seconds
5026	784	715	50.29	seconds
5027	799	715	52.54	seconds
5028	604	715	53.34	seconds
5029	374	715	\N	\N
5030	495	716	\N	\N
5031	381	717	\N	\N
5032	808	716	\N	\N
5033	497	741	495.00	inches
5034	518	741	476.00	inches
5035	327	740	475.00	inches
5036	344	741	463.50	inches
5037	792	739	454.50	inches
5038	828	741	449.75	inches
5039	791	739	432.00	inches
5040	512	741	427.75	inches
5041	532	741	420.00	inches
5042	321	741	402.00	inches
5043	618	741	387.50	inches
5044	373	741	362.00	inches
5045	377	741	360.50	inches
5046	506	741	355.00	inches
5047	826	739	344.75	inches
5048	329	741	337.50	inches
5049	488	740	335.50	inches
5050	820	739	313.75	inches
5051	375	741	308.00	inches
5052	782	741	300.00	inches
5053	775	739	288.00	inches
5054	786	740	263.00	inches
5055	379	739	242.50	inches
5056	598	739	224.50	inches
5057	804	739	\N	\N
5058	510	740	\N	\N
5059	1129	740	\N	\N
5060	497	735	1509.00	inches
5061	344	735	1363.00	inches
5062	532	735	1273.00	inches
5063	518	735	1273.00	inches
5064	512	735	1130.00	inches
5065	618	735	1121.50	inches
5066	828	735	1112.00	inches
5067	506	735	1082.00	inches
5068	488	734	1039.00	inches
5069	792	733	1002.00	inches
5070	327	734	984.00	inches
5071	791	733	922.00	inches
5072	321	735	909.00	inches
5073	826	733	838.00	inches
5074	373	735	785.00	inches
5075	377	735	785.00	inches
5076	782	735	768.00	inches
5077	598	733	741.00	inches
5078	329	735	656.00	inches
5079	820	733	602.00	inches
5080	775	733	504.00	inches
5081	786	734	492.00	inches
5082	379	733	428.00	inches
5083	804	733	\N	\N
5084	510	734	\N	\N
5085	1129	734	\N	\N
5086	378	747	72.00	inches
5087	781	745	70.00	inches
5088	388	747	64.00	inches
5089	509	747	64.00	inches
5090	522	747	62.00	inches
5091	345	745	60.00	inches
5092	507	746	60.00	inches
5093	630	746	60.00	inches
5094	805	745	58.00	inches
5095	344	747	56.00	inches
5096	376	753	132.00	inches
5097	527	753	126.00	inches
5098	505	753	120.00	inches
5099	629	753	120.00	inches
5100	493	753	114.00	inches
5101	388	753	108.00	inches
5102	630	752	102.00	inches
5103	590	752	96.00	inches
5104	364	751	90.00	inches
5105	325	753	84.00	inches
5106	622	751	78.00	inches
5107	378	723	232.00	inches
5108	519	722	230.00	inches
5109	509	723	216.00	inches
5110	383	723	213.50	inches
5111	491	722	212.50	inches
5112	332	722	212.00	inches
5113	530	723	211.50	inches
5114	374	721	210.00	inches
5115	781	721	207.00	inches
5116	534	723	205.00	inches
5117	507	722	204.00	inches
5118	478	722	202.00	inches
5119	824	721	201.00	inches
5120	629	723	199.00	inches
5121	386	722	197.00	inches
5122	771	722	195.25	inches
5123	522	723	193.75	inches
5124	495	722	193.00	inches
5125	329	723	189.00	inches
5126	818	723	189.00	inches
5127	475	723	183.00	inches
5128	345	721	180.00	inches
5129	479	721	180.00	inches
5130	388	723	174.00	inches
5131	360	722	171.00	inches
5132	604	721	171.00	inches
5133	375	723	170.00	inches
5134	343	722	167.00	inches
5135	340	723	\N	\N
5136	778	722	\N	\N
5137	519	728	501.00	inches
5138	509	729	467.00	inches
5139	376	729	463.00	inches
5140	340	729	438.50	inches
5141	629	729	434.50	inches
5142	781	727	430.50	inches
5143	530	729	420.50	inches
5144	522	729	406.00	inches
5145	511	729	406.00	inches
5146	507	728	401.00	inches
5147	508	729	397.00	inches
5148	388	729	363.00	inches
5149	495	728	355.00	inches
5150	778	728	\N	\N
5151	647	761	13.27	seconds
5152	528	760	13.61	seconds
5153	632	762	13.79	seconds
5154	566	761	13.82	seconds
5155	719	762	13.87	seconds
5156	588	762	14.06	seconds
5157	735	762	14.51	seconds
5158	355	761	14.70	seconds
5159	569	761	14.76	seconds
5160	1133	760	14.82	seconds
5161	515	760	14.85	seconds
5162	736	760	14.93	seconds
5163	1141	761	15.06	seconds
5164	594	760	15.17	seconds
5165	328	760	15.39	seconds
5166	586	761	15.54	seconds
5167	573	760	15.73	seconds
5168	1132	760	16.07	seconds
5169	767	760	16.10	seconds
5170	641	762	16.12	seconds
5171	1147	761	16.17	seconds
5172	477	761	16.23	seconds
5173	464	760	16.39	seconds
5174	557	761	16.89	seconds
5175	620	760	17.30	seconds
5176	357	761	17.57	seconds
5177	777	761	17.62	seconds
5178	755	762	\N	\N
5179	645	768	24.88	seconds
5180	627	768	27.10	seconds
5181	528	766	28.69	seconds
5182	634	768	28.80	seconds
5183	1146	767	29.20	seconds
5184	588	768	29.61	seconds
5185	719	768	30.96	seconds
5186	569	767	31.36	seconds
5187	1141	767	31.60	seconds
5188	745	766	31.61	seconds
5189	578	767	31.66	seconds
5190	611	767	31.74	seconds
5191	594	766	31.78	seconds
5192	358	766	31.83	seconds
5193	623	768	31.91	seconds
5194	1133	766	32.20	seconds
5195	328	766	32.25	seconds
5196	384	767	32.54	seconds
5197	489	768	32.82	seconds
5198	769	768	33.13	seconds
5199	720	766	33.25	seconds
5200	710	766	33.29	seconds
5201	385	766	33.69	seconds
5202	464	766	33.84	seconds
5203	736	766	33.84	seconds
5204	735	768	33.96	seconds
5205	477	767	34.01	seconds
5206	586	767	34.06	seconds
5207	529	768	34.11	seconds
5208	644	767	34.12	seconds
5209	767	766	34.22	seconds
5210	574	766	34.40	seconds
5211	342	766	34.61	seconds
5212	334	766	34.99	seconds
5213	635	767	36.28	seconds
5214	557	767	36.99	seconds
5215	620	766	37.71	seconds
5216	631	768	38.11	seconds
5217	777	767	39.04	seconds
5218	357	767	40.52	seconds
5219	1132	766	\N	\N
5220	725	768	\N	\N
5221	645	774	56.92	seconds
5222	367	773	60.62	seconds
5223	628	774	64.24	seconds
5224	1146	773	65.40	seconds
5225	462	774	67.05	seconds
5226	584	773	67.92	seconds
5227	569	773	70.53	seconds
5228	611	773	70.57	seconds
5229	380	772	71.07	seconds
5230	623	774	72.55	seconds
5231	740	774	72.72	seconds
5232	358	772	73.19	seconds
5233	469	772	73.62	seconds
5234	501	774	73.67	seconds
5235	573	772	73.74	seconds
5236	384	773	74.35	seconds
5237	725	774	74.43	seconds
5238	335	773	74.59	seconds
5239	489	774	74.68	seconds
5240	385	772	74.73	seconds
5241	640	773	75.03	seconds
5242	529	774	75.35	seconds
5243	745	772	75.85	seconds
5244	734	772	76.28	seconds
5245	731	774	76.96	seconds
5246	342	772	80.12	seconds
5247	713	773	82.18	seconds
5248	776	773	\N	\N
5249	578	773	\N	\N
5250	777	773	\N	\N
5251	624	780	148.04	seconds
5252	595	779	151.40	seconds
5253	367	779	156.23	seconds
5254	583	780	160.40	seconds
5255	462	780	164.16	seconds
5256	362	778	166.51	seconds
5257	549	778	166.89	seconds
5258	734	778	172.15	seconds
5259	335	779	173.75	seconds
5260	521	780	175.08	seconds
5261	499	780	178.01	seconds
5262	553	779	178.93	seconds
5263	606	780	183.96	seconds
5264	759	780	184.15	seconds
5265	1144	779	189.81	seconds
5266	541	780	195.93	seconds
5267	642	780	198.05	seconds
5268	639	780	205.03	seconds
5269	776	779	\N	\N
5270	769	780	\N	\N
5271	584	779	\N	\N
5272	724	780	\N	\N
5273	740	780	\N	\N
5274	730	780	\N	\N
5275	814	780	\N	\N
5276	816	780	\N	\N
5277	624	786	329.26	seconds
5278	595	785	337.35	seconds
5279	366	784	338.73	seconds
5280	583	786	347.39	seconds
5281	362	784	362.37	seconds
5282	521	786	365.12	seconds
5283	816	786	371.70	seconds
5284	499	786	371.88	seconds
5285	469	784	372.04	seconds
5286	492	785	376.56	seconds
5287	323	784	384.84	seconds
5288	553	785	387.50	seconds
5289	341	784	388.06	seconds
5290	486	786	390.43	seconds
5291	759	786	408.06	seconds
5292	1144	785	422.39	seconds
5293	642	786	434.98	seconds
5294	639	786	451.33	seconds
5295	776	785	\N	\N
5296	1130	785	\N	\N
5297	581	785	\N	\N
5298	724	786	\N	\N
5299	814	786	\N	\N
5300	587	792	661.55	seconds
5301	492	791	743.93	seconds
5302	366	790	763.20	seconds
5303	521	792	808.09	seconds
5304	486	792	854.85	seconds
5305	323	790	859.04	seconds
5306	549	790	859.33	seconds
5307	341	790	859.35	seconds
5308	540	791	870.36	seconds
5309	556	791	885.00	seconds
5310	545	790	885.00	seconds
5311	606	792	894.38	seconds
5312	541	792	944.78	seconds
5313	469	790	\N	\N
5314	803	790	\N	\N
5315	793	790	\N	\N
5316	583	792	\N	\N
5317	724	792	\N	\N
5318	633	816	16.99	seconds
5319	566	815	17.29	seconds
5320	636	814	17.97	seconds
5321	628	816	18.28	seconds
5322	638	815	19.28	seconds
5323	496	816	19.42	seconds
5324	1133	814	20.04	seconds
5325	517	816	20.17	seconds
5326	711	815	21.12	seconds
5327	577	816	\N	\N
5328	566	827	51.12	seconds
5329	633	828	52.29	seconds
5330	636	826	52.49	seconds
5331	517	828	53.25	seconds
5332	638	827	53.66	seconds
5333	355	827	53.69	seconds
5334	487	827	54.15	seconds
5335	496	828	55.91	seconds
5336	380	826	58.98	seconds
5337	711	827	59.70	seconds
5338	637	827	61.48	seconds
5339	755	828	\N	\N
5340	356	851	418.50	inches
5341	503	852	338.00	inches
5342	523	852	333.00	inches
5343	827	850	309.50	inches
5344	601	852	289.00	inches
5345	500	851	287.00	inches
5346	646	852	283.00	inches
5347	526	852	276.50	inches
5348	710	850	266.00	inches
5349	334	850	262.50	inches
5350	811	851	250.00	inches
5351	357	851	248.00	inches
5352	349	852	231.50	inches
5353	738	852	204.50	inches
5354	731	852	193.00	inches
5355	713	851	168.00	inches
5356	1132	850	\N	\N
5357	814	852	\N	\N
5358	503	846	1136.00	inches
5359	523	846	1045.00	inches
5360	827	844	983.00	inches
5361	533	845	939.00	inches
5362	356	845	894.00	inches
5363	525	846	865.00	inches
5364	526	846	858.00	inches
5365	710	844	789.00	inches
5366	601	846	772.00	inches
5367	725	846	768.00	inches
5368	349	846	762.00	inches
5369	500	845	744.00	inches
5370	646	846	724.00	inches
5371	713	845	523.50	inches
5372	357	845	476.00	inches
5373	738	846	463.50	inches
5374	334	844	454.00	inches
5375	730	846	446.25	inches
5376	1133	844	\N	\N
5377	333	858	61.00	inches
5378	350	858	58.00	inches
5379	487	857	56.00	inches
5380	515	856	54.00	inches
5381	633	858	54.00	inches
5382	626	858	52.00	inches
5383	498	857	50.00	inches
5384	569	857	50.00	inches
5385	734	856	50.00	inches
5386	711	857	50.00	inches
5387	644	857	46.00	inches
5388	741	858	46.00	inches
5389	623	858	44.00	inches
5390	593	856	42.00	inches
5391	647	863	158.00	inches
5392	577	864	146.00	inches
5393	634	864	123.00	inches
5394	601	864	108.00	inches
5395	501	864	84.00	inches
5396	384	863	81.00	inches
5397	342	862	78.00	inches
5398	489	864	66.00	inches
5399	1136	863	\N	\N
5400	647	833	203.25	inches
5401	627	834	186.50	inches
5402	487	833	180.75	inches
5403	347	832	176.00	inches
5404	632	834	173.50	inches
5405	498	833	169.00	inches
5406	755	834	166.00	inches
5407	533	833	162.00	inches
5408	322	834	158.00	inches
5409	536	834	148.00	inches
5410	328	832	141.00	inches
5411	741	834	140.00	inches
5412	1141	833	139.00	inches
5413	1132	832	138.00	inches
5414	720	832	135.00	inches
5415	574	832	133.50	inches
5416	524	833	127.00	inches
5417	731	834	125.00	inches
5418	745	832	125.00	inches
5419	713	833	114.00	inches
5420	593	832	109.00	inches
5421	730	834	85.00	inches
5422	333	834	\N	\N
5423	380	832	\N	\N
5424	634	840	430.50	inches
5425	633	840	394.00	inches
5426	632	840	385.75	inches
5427	515	838	381.00	inches
5428	601	840	367.50	inches
5429	533	839	359.50	inches
5430	626	840	347.50	inches
5431	755	840	336.75	inches
5432	524	839	336.00	inches
5433	322	840	332.00	inches
5434	498	839	326.00	inches
5435	536	840	318.50	inches
5436	741	840	316.00	inches
5437	720	838	289.00	inches
5438	627	840	\N	\N
5439	710	838	\N	\N
5440	597	759	11.44	seconds
5441	520	759	11.55	seconds
5442	482	759	11.92	seconds
5443	386	758	11.93	seconds
5444	519	758	12.01	seconds
5445	794	757	12.06	seconds
5446	715	759	12.12	seconds
5447	485	759	12.17	seconds
5448	383	759	12.19	seconds
5449	726	759	12.21	seconds
5450	551	759	12.33	seconds
5451	552	759	12.37	seconds
5452	370	758	12.41	seconds
5453	530	759	12.42	seconds
5454	605	757	12.46	seconds
5455	824	757	12.48	seconds
5456	798	759	12.54	seconds
5457	596	757	12.55	seconds
5458	591	757	12.62	seconds
5459	728	758	12.62	seconds
5460	348	758	12.64	seconds
5461	748	758	12.71	seconds
5462	721	759	12.74	seconds
5463	757	759	12.78	seconds
5464	771	758	12.82	seconds
5465	479	757	12.83	seconds
5466	801	758	12.86	seconds
5467	928	759	12.90	seconds
5468	354	759	13.02	seconds
5469	758	758	13.03	seconds
5470	723	758	13.27	seconds
5471	478	758	13.28	seconds
5472	327	758	13.29	seconds
5473	575	757	13.32	seconds
5474	564	758	13.36	seconds
5475	463	758	13.44	seconds
5476	465	757	13.51	seconds
5477	484	757	13.54	seconds
5478	818	759	13.56	seconds
5479	476	757	13.56	seconds
5480	599	758	13.62	seconds
5481	598	757	13.68	seconds
5482	382	759	13.91	seconds
5483	1145	758	13.91	seconds
5484	480	758	13.93	seconds
5485	548	758	13.94	seconds
5486	368	758	14.01	seconds
5487	716	757	14.01	seconds
5488	345	757	14.05	seconds
5489	331	758	14.07	seconds
5490	343	758	14.34	seconds
5491	475	759	14.83	seconds
5492	1142	757	15.82	seconds
5493	360	758	\N	\N
5494	1131	759	\N	\N
5495	813	759	\N	\N
5496	567	757	\N	\N
5497	1134	758	\N	\N
5498	1137	757	\N	\N
5499	597	765	22.98	seconds
5500	482	765	23.94	seconds
5501	520	765	24.19	seconds
5502	386	764	24.69	seconds
5503	794	763	24.77	seconds
5504	802	763	24.86	seconds
5505	582	765	25.05	seconds
5506	383	765	25.26	seconds
5507	370	764	25.31	seconds
5508	340	765	25.42	seconds
5509	605	763	25.42	seconds
5510	596	763	25.55	seconds
5511	726	765	25.60	seconds
5512	748	764	25.63	seconds
5513	749	764	25.78	seconds
5514	715	765	26.08	seconds
5515	718	763	26.17	seconds
5516	348	764	26.18	seconds
5517	485	765	26.39	seconds
5518	801	764	26.42	seconds
5519	928	765	26.57	seconds
5520	591	763	26.61	seconds
5521	360	764	26.76	seconds
5522	757	765	26.78	seconds
5523	806	765	26.84	seconds
5524	817	765	26.88	seconds
5525	479	763	27.00	seconds
5526	575	763	27.22	seconds
5527	572	765	27.23	seconds
5528	721	765	27.47	seconds
5529	551	765	27.51	seconds
5530	563	764	27.57	seconds
5531	473	763	27.81	seconds
5532	571	763	27.87	seconds
5533	564	764	27.91	seconds
5534	599	764	27.99	seconds
5535	476	763	28.04	seconds
5536	368	764	28.43	seconds
5537	484	763	28.64	seconds
5538	480	764	29.11	seconds
5539	603	765	29.48	seconds
5540	548	764	29.57	seconds
5541	346	763	29.86	seconds
5542	465	763	30.00	seconds
5543	716	763	30.31	seconds
5544	343	764	30.47	seconds
5545	567	763	30.95	seconds
5546	331	764	31.23	seconds
5547	371	765	34.17	seconds
5548	354	765	\N	\N
5549	818	765	\N	\N
5550	382	765	\N	\N
5551	758	764	\N	\N
5552	463	764	\N	\N
5553	1139	764	\N	\N
5554	579	763	\N	\N
5555	723	764	\N	\N
5556	363	765	\N	\N
5557	1131	765	\N	\N
5558	475	765	\N	\N
5559	1134	764	\N	\N
5560	1137	763	\N	\N
5561	712	765	\N	\N
5562	728	764	\N	\N
5563	597	771	53.00	seconds
5564	802	769	53.31	seconds
5565	753	771	54.40	seconds
5566	482	771	54.62	seconds
5567	374	769	55.86	seconds
5568	582	771	56.00	seconds
5569	780	769	56.42	seconds
5570	749	770	56.56	seconds
5571	718	769	56.59	seconds
5572	495	770	56.69	seconds
5573	473	769	56.92	seconds
5574	531	771	56.92	seconds
5575	352	771	57.81	seconds
5576	340	771	57.96	seconds
5577	727	771	58.02	seconds
5578	768	771	58.21	seconds
5579	325	771	58.41	seconds
5580	748	770	58.51	seconds
5581	576	770	58.54	seconds
5582	712	771	58.78	seconds
5583	785	769	59.70	seconds
5584	815	770	59.73	seconds
5585	563	770	60.19	seconds
5586	571	769	61.76	seconds
5587	484	769	61.86	seconds
5588	579	769	62.00	seconds
5589	476	769	62.46	seconds
5590	817	771	62.50	seconds
5591	364	769	63.78	seconds
5592	756	771	63.98	seconds
5593	346	769	65.48	seconds
5594	375	771	68.14	seconds
5595	465	769	69.14	seconds
5596	722	771	70.63	seconds
5597	1140	771	71.14	seconds
5598	567	769	71.33	seconds
5599	371	771	75.36	seconds
5600	561	769	78.27	seconds
5601	463	770	\N	\N
5602	761	770	\N	\N
5603	1138	771	\N	\N
5604	1137	769	\N	\N
5605	516	777	117.76	seconds
5606	753	777	120.30	seconds
5607	592	776	123.17	seconds
5608	625	775	124.27	seconds
5609	810	776	128.31	seconds
5610	555	776	128.37	seconds
5611	752	776	129.19	seconds
5612	470	776	131.33	seconds
5613	749	776	132.80	seconds
5614	514	775	133.01	seconds
5615	481	777	133.28	seconds
5616	615	775	133.64	seconds
5617	363	777	133.68	seconds
5618	608	775	134.82	seconds
5619	815	776	136.07	seconds
5620	600	777	136.77	seconds
5621	754	775	137.30	seconds
5622	375	777	138.88	seconds
5623	787	775	139.30	seconds
5624	572	777	140.75	seconds
5625	717	775	141.60	seconds
5626	542	777	143.50	seconds
5627	751	777	143.50	seconds
5628	582	777	144.58	seconds
5629	560	777	144.77	seconds
5630	550	775	145.84	seconds
5631	352	777	145.85	seconds
5632	1135	775	146.06	seconds
5633	576	776	147.22	seconds
5634	750	777	147.49	seconds
5635	364	775	150.79	seconds
5636	559	776	151.16	seconds
5637	761	776	154.01	seconds
5638	746	777	161.09	seconds
5639	539	776	186.00	seconds
5640	744	777	188.71	seconds
5641	756	777	\N	\N
5642	929	777	\N	\N
5643	1138	777	\N	\N
5644	589	775	\N	\N
5645	1140	777	\N	\N
5646	516	783	262.73	seconds
5647	592	782	267.31	seconds
5648	929	783	275.77	seconds
5649	490	783	277.73	seconds
5650	625	781	278.31	seconds
5651	810	782	280.40	seconds
5652	470	782	284.23	seconds
5653	481	783	286.62	seconds
5654	514	781	292.58	seconds
5655	381	783	298.00	seconds
5656	600	783	298.28	seconds
5657	560	783	298.45	seconds
5658	787	781	299.01	seconds
5659	308	783	300.03	seconds
5660	619	781	300.86	seconds
5661	351	781	301.45	seconds
5662	717	781	305.81	seconds
5663	609	781	307.41	seconds
5664	1135	781	309.96	seconds
5665	615	781	310.93	seconds
5666	317	783	311.58	seconds
5667	559	782	321.60	seconds
5668	562	782	322.79	seconds
5669	570	783	323.54	seconds
5670	754	781	327.61	seconds
5671	316	782	330.10	seconds
5672	744	783	331.58	seconds
5673	336	782	334.28	seconds
5674	339	781	334.38	seconds
5675	739	783	336.97	seconds
5676	750	783	339.27	seconds
5677	589	781	340.22	seconds
5678	542	783	344.46	seconds
5679	761	782	345.26	seconds
5680	538	782	348.15	seconds
5681	756	783	349.50	seconds
5682	306	781	352.96	seconds
5683	372	781	356.67	seconds
5684	771	782	358.30	seconds
5685	746	783	366.30	seconds
5686	307	782	381.80	seconds
5687	1143	781	384.52	seconds
5688	561	781	387.56	seconds
5689	483	782	393.75	seconds
5690	472	781	419.86	seconds
5691	563	782	\N	\N
5692	470	788	604.50	seconds
5693	490	789	609.97	seconds
5694	929	789	619.53	seconds
5695	555	788	635.95	seconds
5696	481	789	640.48	seconds
5697	619	787	668.90	seconds
5698	787	787	669.43	seconds
5699	1135	787	672.86	seconds
5700	351	787	675.32	seconds
5701	308	789	675.48	seconds
5702	547	788	680.32	seconds
5703	609	787	680.63	seconds
5704	717	787	688.19	seconds
5705	543	789	690.00	seconds
5706	739	789	692.67	seconds
5707	316	788	697.60	seconds
5708	550	787	698.78	seconds
5709	317	789	701.76	seconds
5710	795	787	710.91	seconds
5711	562	788	715.78	seconds
5712	336	788	719.84	seconds
5713	306	787	751.54	seconds
5714	339	787	762.18	seconds
5715	538	788	776.52	seconds
5716	372	787	784.73	seconds
5717	307	788	823.51	seconds
5718	561	787	924.09	seconds
5719	535	789	\N	\N
5720	504	788	\N	\N
5721	563	788	\N	\N
5722	378	819	16.68	seconds
5723	527	819	17.60	seconds
5724	491	818	18.35	seconds
5725	784	817	19.75	seconds
5726	808	818	20.20	seconds
5727	478	818	20.26	seconds
5728	727	819	20.40	seconds
5729	376	819	20.41	seconds
5730	799	817	21.86	seconds
5731	813	819	\N	\N
5732	548	818	\N	\N
5733	378	825	44.65	seconds
5734	802	823	45.07	seconds
5735	491	824	45.43	seconds
5736	527	825	46.00	seconds
5737	727	825	48.01	seconds
5738	808	824	48.21	seconds
5739	478	824	48.72	seconds
5740	570	825	48.92	seconds
5741	381	825	49.46	seconds
5742	784	823	49.97	seconds
5743	374	823	50.29	seconds
5744	799	823	51.31	seconds
5745	481	825	52.71	seconds
5746	551	825	52.85	seconds
5747	813	825	60.00	seconds
5748	722	825	\N	\N
5749	497	849	495.00	inches
5750	344	849	463.50	inches
5751	737	849	461.50	inches
5752	729	849	460.00	inches
5753	828	849	449.75	inches
5754	512	849	427.75	inches
5755	532	849	420.00	inches
5756	1148	849	412.00	inches
5757	327	848	410.00	inches
5758	321	849	403.00	inches
5759	791	847	401.00	inches
5760	812	848	390.75	inches
5761	618	849	387.50	inches
5762	792	847	381.00	inches
5763	804	847	378.00	inches
5764	377	849	360.50	inches
5765	585	848	359.25	inches
5766	506	849	355.00	inches
5767	329	849	352.00	inches
5768	826	847	344.75	inches
5769	488	848	335.50	inches
5770	820	847	313.75	inches
5771	375	849	308.00	inches
5772	782	849	300.00	inches
5773	1142	847	293.75	inches
5774	775	847	288.00	inches
5775	723	848	260.00	inches
5776	598	847	238.00	inches
5777	757	849	\N	\N
5778	1145	848	\N	\N
5779	758	848	\N	\N
5780	552	849	\N	\N
5781	1134	848	\N	\N
5782	497	843	1509.00	inches
5783	737	843	1413.00	inches
5784	344	843	1363.00	inches
5785	532	843	1351.00	inches
5786	792	841	1191.00	inches
5787	512	843	1130.00	inches
5788	618	843	1121.50	inches
5789	828	843	1112.00	inches
5790	506	843	1082.00	inches
5791	327	842	1059.00	inches
5792	804	841	1053.00	inches
5793	488	842	1039.00	inches
5794	729	843	1028.50	inches
5795	791	841	1002.00	inches
5796	585	842	954.00	inches
5797	812	842	915.00	inches
5798	321	843	909.00	inches
5799	564	842	883.00	inches
5800	377	843	844.00	inches
5801	826	841	838.00	inches
5802	820	841	775.00	inches
5803	782	843	768.00	inches
5804	598	841	741.00	inches
5805	329	843	690.00	inches
5806	775	841	627.00	inches
5807	552	843	\N	\N
5808	1134	842	\N	\N
5809	378	855	72.00	inches
5810	733	855	68.00	inches
5811	388	855	67.00	inches
5812	509	855	64.00	inches
5813	714	855	64.00	inches
5814	332	854	63.00	inches
5815	345	853	62.00	inches
5816	507	854	60.00	inches
5817	781	853	60.00	inches
5818	630	854	60.00	inches
5819	805	853	58.00	inches
5820	570	855	58.00	inches
5821	808	854	\N	\N
5822	718	853	\N	\N
5823	629	861	135.00	inches
5824	376	861	132.00	inches
5825	527	861	126.00	inches
5826	505	861	120.00	inches
5827	630	860	114.00	inches
5828	388	861	108.00	inches
5829	364	859	105.00	inches
5830	784	859	97.00	inches
5831	590	860	96.00	inches
5832	805	859	90.00	inches
5833	325	861	84.00	inches
5834	534	861	\N	\N
5835	554	861	\N	\N
5836	715	831	235.50	inches
5837	378	831	232.00	inches
5838	519	830	230.00	inches
5839	733	831	224.00	inches
5840	732	831	218.00	inches
5841	509	831	216.00	inches
5842	383	831	213.50	inches
5843	386	830	213.00	inches
5844	491	830	212.50	inches
5845	332	830	212.00	inches
5846	530	831	211.50	inches
5847	374	829	210.00	inches
5848	781	829	207.00	inches
5849	534	831	205.00	inches
5850	507	830	204.00	inches
5851	629	831	203.50	inches
5852	478	830	203.25	inches
5853	824	829	201.00	inches
5854	714	831	200.00	inches
5855	721	831	196.00	inches
5856	771	830	195.25	inches
5857	818	831	194.50	inches
5858	778	830	194.00	inches
5859	360	830	191.00	inches
5860	329	831	189.00	inches
5861	479	829	189.00	inches
5862	575	829	185.00	inches
5863	475	831	183.00	inches
5864	345	829	180.00	inches
5865	388	831	174.00	inches
5866	579	829	174.00	inches
5867	375	831	170.00	inches
5868	343	830	167.00	inches
5869	716	829	155.00	inches
5870	723	830	\N	\N
5871	1139	830	\N	\N
5872	519	836	501.00	inches
5873	509	837	467.00	inches
5874	376	837	463.00	inches
5875	733	837	458.00	inches
5876	732	837	457.50	inches
5877	530	837	437.75	inches
5878	629	837	434.50	inches
5879	714	837	433.00	inches
5880	781	835	430.50	inches
5881	507	836	429.00	inches
5882	511	837	408.00	inches
5883	778	836	406.50	inches
5884	508	837	397.00	inches
5885	824	835	392.00	inches
5886	388	837	389.00	inches
5887	332	836	\N	\N
5888	1139	836	\N	\N
5889	744	837	\N	\N
5890	645	870	12.15	seconds
5891	647	869	13.21	seconds
5892	632	870	13.79	seconds
5893	719	870	13.87	seconds
5894	827	868	14.36	seconds
5895	735	870	14.51	seconds
5896	755	870	14.71	seconds
5897	569	869	14.76	seconds
5898	1141	869	14.85	seconds
5899	825	870	14.89	seconds
5900	736	868	14.93	seconds
5901	745	868	15.02	seconds
5902	594	868	15.17	seconds
5903	328	868	15.39	seconds
5904	1132	868	15.48	seconds
5905	586	869	15.54	seconds
5906	644	869	15.92	seconds
5907	1147	869	15.97	seconds
5908	635	869	16.44	seconds
5909	621	869	16.83	seconds
5910	557	869	16.89	seconds
5911	1165	870	17.06	seconds
5912	1152	869	17.13	seconds
5913	620	868	17.30	seconds
5914	357	869	17.57	seconds
5915	1157	870	18.41	seconds
5916	1158	869	\N	\N
5917	1136	869	\N	\N
5918	1167	870	\N	\N
5919	1171	870	\N	\N
5920	1172	870	\N	\N
5921	645	876	24.76	seconds
5922	627	876	27.10	seconds
5923	634	876	28.34	seconds
5924	719	876	28.71	seconds
5925	367	875	28.80	seconds
5926	1141	875	30.80	seconds
5927	825	876	31.22	seconds
5928	569	875	31.36	seconds
5929	594	874	31.55	seconds
5930	745	874	31.61	seconds
5931	611	875	31.74	seconds
5932	1133	874	31.79	seconds
5933	358	874	31.83	seconds
5934	623	876	31.91	seconds
5935	725	876	32.11	seconds
5936	384	875	32.12	seconds
5937	573	874	32.13	seconds
5938	328	874	32.25	seconds
5939	720	874	32.36	seconds
5940	769	876	33.13	seconds
5941	586	875	33.41	seconds
5942	385	874	33.69	seconds
5943	644	875	34.12	seconds
5944	767	874	34.22	seconds
5945	574	874	34.40	seconds
5946	342	874	34.61	seconds
5947	334	874	34.99	seconds
5948	1132	874	35.30	seconds
5949	641	876	35.61	seconds
5950	557	875	35.80	seconds
5951	1160	875	36.14	seconds
5952	631	876	36.99	seconds
5953	1165	876	37.07	seconds
5954	620	874	37.71	seconds
5955	1152	875	38.08	seconds
5956	1157	876	39.98	seconds
5957	357	875	40.52	seconds
5958	581	875	\N	\N
5959	1158	875	\N	\N
5960	1155	874	\N	\N
5961	1171	876	\N	\N
5962	1172	876	\N	\N
5963	1175	876	\N	\N
5964	645	882	56.00	seconds
5965	367	881	60.62	seconds
5966	627	882	62.00	seconds
5967	581	881	67.22	seconds
5968	584	881	67.92	seconds
5969	1153	881	70.49	seconds
5970	611	881	70.57	seconds
5971	740	882	71.26	seconds
5972	384	881	71.79	seconds
5973	623	882	72.55	seconds
5974	573	880	72.98	seconds
5975	725	882	73.04	seconds
5976	358	880	73.19	seconds
5977	335	881	74.59	seconds
5978	385	880	74.73	seconds
5979	640	881	75.03	seconds
5980	731	882	76.96	seconds
5981	1155	880	78.14	seconds
5982	342	880	80.12	seconds
5983	334	880	80.45	seconds
5984	713	881	81.60	seconds
5985	1160	881	84.34	seconds
5986	587	888	143.38	seconds
5987	624	888	148.04	seconds
5988	595	887	151.40	seconds
5989	581	887	160.28	seconds
5990	362	886	162.53	seconds
5991	1154	886	166.58	seconds
5992	584	887	167.60	seconds
5993	540	887	168.97	seconds
5994	816	888	170.98	seconds
5995	335	887	173.75	seconds
5996	769	888	174.03	seconds
5997	314	886	182.70	seconds
5998	311	888	183.23	seconds
5999	759	888	184.15	seconds
6000	1162	886	186.31	seconds
6001	740	888	189.27	seconds
6002	1144	887	189.81	seconds
6003	541	888	195.93	seconds
6004	642	888	198.05	seconds
6005	730	888	202.46	seconds
6006	639	888	204.03	seconds
6007	315	887	\N	\N
6008	1149	887	\N	\N
6009	1153	887	\N	\N
6010	1177	886	\N	\N
6011	587	894	298.53	seconds
6012	624	894	327.78	seconds
6013	595	893	336.97	seconds
6014	366	892	338.73	seconds
6015	362	892	354.72	seconds
6016	816	894	366.15	seconds
6017	549	892	370.35	seconds
6018	724	894	378.98	seconds
6019	1154	892	381.76	seconds
6020	1162	892	382.24	seconds
6021	323	892	384.84	seconds
6022	341	892	388.06	seconds
6023	556	893	388.31	seconds
6024	545	892	388.65	seconds
6025	540	893	395.16	seconds
6026	314	892	396.61	seconds
6027	311	894	398.87	seconds
6028	759	894	408.06	seconds
6029	1144	893	422.39	seconds
6030	541	894	426.38	seconds
6031	642	894	434.98	seconds
6032	318	893	435.52	seconds
6033	639	894	451.33	seconds
6034	315	893	\N	\N
6035	1149	893	\N	\N
6036	1172	894	\N	\N
6037	366	898	763.20	seconds
6038	553	899	810.62	seconds
6039	323	898	859.04	seconds
6040	341	898	859.35	seconds
6041	606	900	894.38	seconds
6042	633	924	16.81	seconds
6043	566	923	17.29	seconds
6044	628	924	17.46	seconds
6045	636	922	17.97	seconds
6046	638	923	19.00	seconds
6047	1133	922	19.45	seconds
6048	711	923	21.12	seconds
6049	617	935	50.86	seconds
6050	566	935	51.12	seconds
6051	633	936	51.36	seconds
6052	628	936	52.00	seconds
6053	636	934	52.49	seconds
6054	355	935	53.06	seconds
6055	638	935	53.66	seconds
6056	380	934	57.78	seconds
6057	711	935	58.71	seconds
6058	637	935	60.46	seconds
6059	755	936	\N	\N
6060	356	959	418.50	inches
6061	827	958	309.50	inches
6062	601	960	289.00	inches
6063	646	960	283.00	inches
6064	1178	959	276.00	inches
6065	710	958	267.75	inches
6066	334	958	262.50	inches
6067	357	959	248.00	inches
6068	349	960	245.00	inches
6069	730	960	206.50	inches
6070	738	960	204.50	inches
6071	731	960	201.25	inches
6072	713	959	168.00	inches
6073	356	953	1018.00	inches
6074	827	952	983.00	inches
6075	601	954	922.00	inches
6076	1178	953	799.00	inches
6077	725	954	798.00	inches
6078	710	952	789.00	inches
6079	349	954	777.00	inches
6080	646	954	724.00	inches
6081	1133	952	630.00	inches
6082	334	952	554.00	inches
6083	713	953	523.50	inches
6084	357	953	476.00	inches
6085	738	954	463.50	inches
6086	730	954	450.00	inches
6087	333	966	61.00	inches
6088	350	966	58.00	inches
6089	626	966	54.00	inches
6090	633	966	54.00	inches
6091	380	964	52.00	inches
6092	569	965	50.00	inches
6093	711	965	50.00	inches
6094	741	966	48.00	inches
6095	644	965	46.00	inches
6096	623	966	44.00	inches
6097	593	964	44.00	inches
6098	647	971	158.00	inches
6099	634	972	123.00	inches
6100	601	972	108.00	inches
6101	1136	971	96.00	inches
6102	384	971	84.00	inches
6103	342	970	78.00	inches
6104	647	941	203.25	inches
6105	627	942	194.00	inches
6106	632	942	178.00	inches
6107	347	940	176.00	inches
6108	755	942	172.00	inches
6109	322	942	158.00	inches
6110	720	940	155.00	inches
6111	741	942	153.00	inches
6112	1132	940	146.00	inches
6113	731	942	141.50	inches
6114	328	940	141.00	inches
6115	1141	941	139.00	inches
6116	574	940	137.00	inches
6117	593	940	109.00	inches
6118	730	942	85.00	inches
6119	333	942	\N	\N
6120	350	942	\N	\N
6121	1136	941	\N	\N
6122	634	948	434.50	inches
6123	633	948	394.00	inches
6124	632	948	385.75	inches
6125	601	948	367.50	inches
6126	626	948	347.50	inches
6127	755	948	342.50	inches
6128	741	948	334.75	inches
6129	322	948	332.00	inches
6130	710	946	297.00	inches
6131	720	946	290.75	inches
6132	745	946	270.00	inches
6133	597	867	11.44	seconds
6134	386	866	11.93	seconds
6135	715	867	12.09	seconds
6136	383	867	12.14	seconds
6137	605	865	12.21	seconds
6138	551	867	12.25	seconds
6139	370	866	12.41	seconds
6140	824	865	12.48	seconds
6141	596	865	12.49	seconds
6142	582	867	12.49	seconds
6143	1131	867	12.54	seconds
6144	591	865	12.62	seconds
6145	309	867	12.68	seconds
6146	748	866	12.71	seconds
6147	721	867	12.74	seconds
6148	757	867	12.78	seconds
6149	1179	867	12.78	seconds
6150	818	867	12.79	seconds
6151	758	866	12.91	seconds
6152	354	867	12.98	seconds
6153	580	866	13.24	seconds
6154	723	866	13.27	seconds
6155	327	866	13.29	seconds
6156	575	865	13.32	seconds
6157	564	866	13.36	seconds
6158	1137	865	13.41	seconds
6159	598	865	13.50	seconds
6160	599	866	13.62	seconds
6161	331	866	13.75	seconds
6162	343	866	13.83	seconds
6163	1145	866	13.91	seconds
6164	345	865	13.93	seconds
6165	548	866	13.94	seconds
6166	368	866	14.01	seconds
6167	567	865	14.79	seconds
6168	1164	867	14.98	seconds
6169	1142	865	15.82	seconds
6170	603	867	\N	\N
6171	1169	865	\N	\N
6172	1176	867	\N	\N
6173	1168	867	\N	\N
6174	1170	865	\N	\N
6175	597	873	22.98	seconds
6176	715	873	24.57	seconds
6177	386	872	24.69	seconds
6178	605	871	24.97	seconds
6179	712	873	25.18	seconds
6180	383	873	25.26	seconds
6181	370	872	25.31	seconds
6182	596	871	25.55	seconds
6183	718	871	25.56	seconds
6184	749	872	25.57	seconds
6185	748	872	25.63	seconds
6186	818	873	25.75	seconds
6187	551	873	25.83	seconds
6188	591	871	25.87	seconds
6189	552	873	26.17	seconds
6190	758	872	26.30	seconds
6191	728	872	26.32	seconds
6192	757	873	26.52	seconds
6193	360	872	26.64	seconds
6194	580	872	26.72	seconds
6195	309	873	26.99	seconds
6196	575	871	27.22	seconds
6197	813	873	27.26	seconds
6198	817	873	27.40	seconds
6199	721	873	27.47	seconds
6200	723	872	27.65	seconds
6201	571	871	27.87	seconds
6202	599	872	27.90	seconds
6203	564	872	27.91	seconds
6204	368	872	28.43	seconds
6205	603	873	28.53	seconds
6206	1137	871	28.53	seconds
6207	343	872	28.83	seconds
6208	331	872	29.09	seconds
6209	548	872	29.57	seconds
6210	346	871	29.86	seconds
6211	716	871	29.93	seconds
6212	567	871	30.95	seconds
6213	371	873	33.53	seconds
6214	354	873	\N	\N
6215	374	871	\N	\N
6216	1131	873	\N	\N
6217	375	873	\N	\N
6218	1176	873	\N	\N
6219	1168	873	\N	\N
6220	1170	871	\N	\N
6221	1179	873	\N	\N
6222	597	879	52.00	seconds
6223	753	879	52.80	seconds
6224	608	877	55.00	seconds
6225	374	877	55.45	seconds
6226	718	877	55.67	seconds
6227	582	879	55.78	seconds
6228	727	879	56.43	seconds
6229	749	878	56.56	seconds
6230	712	879	57.32	seconds
6231	768	879	57.48	seconds
6232	352	879	57.81	seconds
6233	325	879	58.41	seconds
6234	748	878	58.51	seconds
6235	337	877	58.77	seconds
6236	1179	879	59.30	seconds
6237	552	879	59.90	seconds
6238	758	878	59.95	seconds
6239	1163	879	60.61	seconds
6240	571	877	61.76	seconds
6241	1166	877	62.49	seconds
6242	817	879	62.50	seconds
6243	346	877	65.48	seconds
6244	319	879	66.42	seconds
6245	375	879	68.14	seconds
6246	567	877	68.97	seconds
6247	722	879	70.63	seconds
6248	1140	879	71.14	seconds
6249	371	879	74.66	seconds
6250	381	879	\N	\N
6251	818	879	\N	\N
6252	1150	877	\N	\N
6253	1156	878	\N	\N
6254	618	879	\N	\N
6255	1135	877	\N	\N
6256	753	885	120.11	seconds
6257	625	883	120.44	seconds
6258	592	884	123.17	seconds
6259	752	884	127.97	seconds
6260	751	885	132.15	seconds
6261	749	884	132.42	seconds
6262	615	883	133.64	seconds
6263	363	885	133.68	seconds
6264	608	883	134.82	seconds
6265	600	885	135.76	seconds
6266	815	884	136.07	seconds
6267	754	883	137.30	seconds
6268	1161	884	138.54	seconds
6269	352	885	141.19	seconds
6270	337	883	141.24	seconds
6271	750	885	142.26	seconds
6272	744	885	143.35	seconds
6273	542	885	143.50	seconds
6274	1135	883	144.45	seconds
6275	317	885	144.88	seconds
6276	589	883	149.64	seconds
6277	761	884	153.71	seconds
6278	1156	884	156.80	seconds
6279	563	884	157.11	seconds
6280	746	885	159.30	seconds
6281	319	885	169.89	seconds
6282	372	883	173.05	seconds
6283	539	884	178.30	seconds
6284	756	885	\N	\N
6285	1150	883	\N	\N
6286	592	890	263.39	seconds
6287	752	890	273.19	seconds
6288	625	889	278.31	seconds
6289	612	891	278.63	seconds
6290	555	890	280.96	seconds
6291	815	890	286.03	seconds
6292	610	891	288.59	seconds
6293	600	891	296.73	seconds
6294	308	891	298.01	seconds
6295	560	891	298.45	seconds
6296	547	890	299.90	seconds
6297	543	891	299.90	seconds
6298	619	889	300.86	seconds
6299	351	889	301.45	seconds
6300	1161	890	302.15	seconds
6301	717	889	305.81	seconds
6302	615	889	306.24	seconds
6303	609	889	307.41	seconds
6304	317	891	307.53	seconds
6305	1135	889	309.96	seconds
6306	1163	891	310.25	seconds
6307	550	889	316.22	seconds
6308	751	891	319.67	seconds
6309	744	891	320.08	seconds
6310	562	890	322.79	seconds
6311	570	891	323.54	seconds
6312	754	889	327.61	seconds
6313	316	890	330.10	seconds
6314	761	890	331.39	seconds
6315	339	889	332.43	seconds
6316	336	890	334.28	seconds
6317	589	889	336.43	seconds
6318	739	891	336.97	seconds
6319	750	891	339.27	seconds
6320	756	891	349.50	seconds
6321	306	889	350.63	seconds
6322	372	889	356.67	seconds
6323	746	891	357.01	seconds
6324	307	890	368.26	seconds
6325	1143	889	384.52	seconds
6326	561	889	387.56	seconds
6327	612	897	592.00	seconds
6328	560	897	642.34	seconds
6329	610	897	650.24	seconds
6330	559	896	655.60	seconds
6331	619	895	665.76	seconds
6332	739	897	673.79	seconds
6333	351	895	675.32	seconds
6334	308	897	675.48	seconds
6335	609	895	680.63	seconds
6336	717	895	688.19	seconds
6337	316	896	697.60	seconds
6338	562	896	702.53	seconds
6339	336	896	719.84	seconds
6340	306	895	751.54	seconds
6341	339	895	756.48	seconds
6342	538	896	776.52	seconds
6343	307	896	823.51	seconds
6344	561	895	881.26	seconds
6345	563	896	\N	\N
6346	815	896	\N	\N
6347	378	927	16.68	seconds
6348	607	927	17.63	seconds
6349	727	927	19.76	seconds
6350	376	927	20.36	seconds
6351	813	927	21.36	seconds
6352	378	933	44.65	seconds
6353	727	933	45.88	seconds
6354	381	933	46.38	seconds
6355	570	933	46.96	seconds
6356	607	933	48.31	seconds
6357	712	933	50.73	seconds
6358	813	933	52.19	seconds
6359	722	933	59.59	seconds
6360	340	933	\N	\N
6361	344	957	463.50	inches
6362	737	957	461.50	inches
6363	1148	957	428.75	inches
6364	327	956	421.00	inches
6365	618	957	390.00	inches
6366	377	957	370.00	inches
6367	329	957	366.50	inches
6368	373	957	362.00	inches
6369	585	956	359.25	inches
6370	548	956	353.50	inches
6371	826	955	344.75	inches
6372	820	955	329.50	inches
6373	758	956	312.50	inches
6374	1142	955	311.00	inches
6375	375	957	308.00	inches
6376	757	957	290.00	inches
6377	723	956	261.50	inches
6378	1145	956	254.50	inches
6379	598	955	251.50	inches
6380	737	951	1413.00	inches
6381	344	951	1363.00	inches
6382	618	951	1121.50	inches
6383	327	950	1059.00	inches
6384	585	950	954.00	inches
6385	564	950	883.00	inches
6386	377	951	844.00	inches
6387	826	949	838.00	inches
6388	329	951	809.00	inches
6389	373	951	785.00	inches
6390	598	949	782.00	inches
6391	820	949	775.00	inches
6392	563	950	679.00	inches
6393	378	963	72.00	inches
6394	733	963	69.00	inches
6395	388	963	67.00	inches
6396	714	963	66.00	inches
6397	332	962	63.00	inches
6398	345	961	62.00	inches
6399	630	962	60.00	inches
6400	570	963	58.00	inches
6401	344	963	56.00	inches
6402	340	963	\N	\N
6403	1139	962	\N	\N
6404	1169	961	\N	\N
6405	1170	961	\N	\N
6406	376	969	138.00	inches
6407	629	969	138.00	inches
6408	388	969	120.00	inches
6409	630	968	120.00	inches
6410	590	968	108.00	inches
6411	364	967	105.00	inches
6412	1166	967	96.00	inches
6413	325	969	84.00	inches
6414	718	967	\N	\N
6415	733	939	236.00	inches
6416	715	939	235.50	inches
6417	378	939	232.00	inches
6418	714	939	218.00	inches
6419	732	939	218.00	inches
6420	383	939	213.50	inches
6421	386	938	213.00	inches
6422	332	938	212.00	inches
6423	374	937	210.00	inches
6424	607	939	209.50	inches
6425	629	939	203.50	inches
6426	824	937	201.00	inches
6427	728	938	201.00	inches
6428	721	939	196.00	inches
6429	360	938	191.00	inches
6430	329	939	189.00	inches
6431	575	937	185.00	inches
6432	343	938	182.00	inches
6433	345	937	180.00	inches
6434	723	938	175.00	inches
6435	388	939	174.00	inches
6436	1139	938	172.00	inches
6437	375	939	170.00	inches
6438	716	937	155.00	inches
6439	340	939	\N	\N
6440	373	939	\N	\N
6441	561	937	\N	\N
6442	1169	937	\N	\N
6443	1176	939	\N	\N
6444	1168	939	\N	\N
6445	1170	937	\N	\N
6446	733	945	478.75	inches
6447	376	945	463.00	inches
6448	607	945	457.50	inches
6449	732	945	457.50	inches
6450	332	944	440.00	inches
6451	629	945	434.50	inches
6452	714	945	433.00	inches
6453	728	944	412.00	inches
6454	824	943	392.00	inches
6455	388	945	389.00	inches
6456	1139	944	363.50	inches
6457	645	978	12.15	seconds
6458	647	977	13.21	seconds
6459	528	976	13.61	seconds
6460	632	978	13.79	seconds
6461	566	977	13.82	seconds
6462	719	978	13.87	seconds
6463	660	976	13.92	seconds
6464	617	977	13.98	seconds
6465	588	978	14.06	seconds
6466	827	976	14.30	seconds
6467	663	976	14.34	seconds
6468	452	978	14.35	seconds
6469	764	976	14.35	seconds
6470	423	977	14.42	seconds
6471	735	978	14.51	seconds
6472	429	978	14.53	seconds
6473	416	976	14.66	seconds
6474	355	977	14.70	seconds
6475	706	976	14.71	seconds
6476	825	978	14.80	seconds
6477	1133	976	14.82	seconds
6478	1141	977	14.85	seconds
6479	424	976	14.89	seconds
6480	702	977	14.89	seconds
6481	736	976	14.89	seconds
6482	578	977	14.95	seconds
6483	695	976	15.00	seconds
6484	573	976	15.51	seconds
6485	586	977	15.54	seconds
6486	644	977	15.92	seconds
6487	641	978	16.12	seconds
6488	635	977	16.44	seconds
6489	631	978	17.58	seconds
6490	645	984	24.76	seconds
6491	627	984	26.90	seconds
6492	708	983	27.96	seconds
6493	367	983	28.02	seconds
6494	719	984	28.10	seconds
6495	634	984	28.34	seconds
6496	528	982	28.69	seconds
6497	588	984	29.61	seconds
6498	660	982	29.71	seconds
6499	764	982	30.38	seconds
6500	663	982	30.73	seconds
6501	1141	983	30.80	seconds
6502	706	982	30.84	seconds
6503	825	984	30.90	seconds
6504	416	982	30.93	seconds
6505	695	982	31.08	seconds
6506	594	982	31.10	seconds
6507	745	982	31.20	seconds
6508	763	982	31.23	seconds
6509	702	983	31.50	seconds
6510	1133	982	31.79	seconds
6511	573	982	32.13	seconds
6512	586	983	32.29	seconds
6513	424	982	33.01	seconds
6514	769	984	33.13	seconds
6515	456	982	33.28	seconds
6516	644	983	34.12	seconds
6517	408	983	34.58	seconds
6518	635	983	35.42	seconds
6519	641	984	35.61	seconds
6520	631	984	36.99	seconds
6521	645	990	56.00	seconds
6522	367	989	60.62	seconds
6523	708	989	63.60	seconds
6524	627	990	66.29	seconds
6525	584	989	67.92	seconds
6526	423	989	70.40	seconds
6527	763	988	70.48	seconds
6528	611	989	70.57	seconds
6529	380	988	71.07	seconds
6530	623	990	71.14	seconds
6531	740	990	71.26	seconds
6532	384	989	71.34	seconds
6533	362	988	72.24	seconds
6534	725	990	72.54	seconds
6535	501	990	73.67	seconds
6536	489	990	74.68	seconds
6537	529	990	75.35	seconds
6538	456	988	76.24	seconds
6539	394	988	78.47	seconds
6540	424	988	78.79	seconds
6541	1130	989	79.84	seconds
6542	624	996	148.04	seconds
6543	595	995	151.40	seconds
6544	587	996	153.47	seconds
6545	366	994	154.98	seconds
6546	581	995	159.76	seconds
6547	455	994	160.68	seconds
6548	688	996	160.73	seconds
6549	549	994	161.27	seconds
6550	362	994	162.53	seconds
6551	831	995	166.07	seconds
6552	556	995	169.40	seconds
6553	816	996	170.98	seconds
6554	734	994	172.15	seconds
6555	521	996	173.57	seconds
6556	335	995	173.75	seconds
6557	769	996	174.03	seconds
6558	499	996	178.01	seconds
6559	740	996	180.20	seconds
6560	422	996	183.93	seconds
6561	1144	995	189.81	seconds
6562	419	996	191.97	seconds
6563	392	994	191.99	seconds
6564	642	996	196.33	seconds
6565	639	996	204.03	seconds
6566	587	1002	298.53	seconds
6567	624	1002	327.78	seconds
6568	583	1002	336.32	seconds
6569	595	1001	336.97	seconds
6570	366	1000	338.73	seconds
6571	688	1002	345.20	seconds
6572	362	1000	354.72	seconds
6573	455	1000	356.26	seconds
6574	831	1001	361.02	seconds
6575	816	1002	363.73	seconds
6576	521	1002	365.12	seconds
6577	540	1001	368.40	seconds
6578	549	1000	370.35	seconds
6579	499	1002	371.88	seconds
6580	707	1001	373.11	seconds
6581	492	1001	375.22	seconds
6582	683	1000	378.64	seconds
6583	486	1002	381.00	seconds
6584	545	1000	383.01	seconds
6585	323	1000	384.84	seconds
6586	341	1000	388.06	seconds
6587	314	1000	394.01	seconds
6588	422	1002	395.87	seconds
6589	311	1002	398.87	seconds
6590	419	1002	410.75	seconds
6591	541	1002	418.03	seconds
6592	1144	1001	422.39	seconds
6593	392	1000	426.26	seconds
6594	642	1002	431.98	seconds
6595	639	1002	451.33	seconds
6596	587	1008	661.55	seconds
6597	688	1008	728.29	seconds
6598	492	1007	743.93	seconds
6599	624	1008	750.44	seconds
6600	583	1008	750.85	seconds
6601	366	1006	752.55	seconds
6602	521	1008	787.16	seconds
6603	707	1007	788.37	seconds
6604	831	1007	790.99	seconds
6605	553	1007	810.62	seconds
6606	556	1007	822.42	seconds
6607	540	1007	826.51	seconds
6608	455	1006	834.83	seconds
6609	683	1006	837.28	seconds
6610	314	1006	840.62	seconds
6611	486	1008	853.10	seconds
6612	323	1006	859.04	seconds
6613	341	1006	859.35	seconds
6614	422	1008	875.03	seconds
6615	419	1008	914.13	seconds
6616	633	1032	16.81	seconds
6617	566	1031	17.29	seconds
6618	628	1032	17.46	seconds
6619	636	1030	17.97	seconds
6620	638	1031	19.00	seconds
6621	496	1032	19.36	seconds
6622	517	1032	19.44	seconds
6623	1133	1030	19.45	seconds
6624	664	1031	20.48	seconds
6625	711	1031	21.12	seconds
6626	679	1031	21.75	seconds
6627	657	1031	21.89	seconds
6628	617	1043	48.10	seconds
6629	566	1043	51.12	seconds
6630	633	1044	51.36	seconds
6631	628	1044	51.95	seconds
6632	636	1042	52.49	seconds
6633	355	1043	53.06	seconds
6634	664	1043	53.07	seconds
6635	517	1044	53.25	seconds
6636	638	1043	53.66	seconds
6637	496	1044	55.75	seconds
6638	380	1042	57.78	seconds
6639	711	1043	58.71	seconds
6640	679	1043	60.04	seconds
6641	637	1043	60.38	seconds
6642	657	1043	63.71	seconds
6643	356	1067	418.50	inches
6644	440	1067	357.00	inches
6645	503	1068	338.00	inches
6646	523	1068	333.00	inches
6647	461	1068	331.00	inches
6648	448	1066	330.50	inches
6649	500	1067	326.00	inches
6650	650	1067	316.00	inches
6651	677	1067	313.25	inches
6652	827	1066	309.50	inches
6653	526	1068	290.75	inches
6654	601	1068	289.00	inches
6655	646	1068	283.00	inches
6656	1178	1067	274.00	inches
6657	406	1067	273.50	inches
6658	710	1066	267.75	inches
6659	692	1068	265.50	inches
6660	334	1066	262.50	inches
6661	667	1068	261.00	inches
6662	390	1068	257.00	inches
6663	811	1067	252.00	inches
6664	357	1067	248.00	inches
6665	443	1068	240.25	inches
6666	731	1068	201.25	inches
6667	503	1062	1136.00	inches
6668	533	1061	1136.00	inches
6669	461	1062	1063.00	inches
6670	827	1060	1053.00	inches
6671	523	1062	1045.00	inches
6672	356	1061	1018.00	inches
6673	677	1061	963.00	inches
6674	440	1061	926.00	inches
6675	601	1062	922.00	inches
6676	526	1062	912.00	inches
6677	349	1062	874.00	inches
6678	525	1062	865.00	inches
6679	1178	1061	835.50	inches
6680	725	1062	802.00	inches
6681	710	1060	789.00	inches
6682	692	1062	776.00	inches
6683	500	1061	744.00	inches
6684	448	1060	730.00	inches
6685	646	1062	724.00	inches
6686	406	1061	713.00	inches
6687	670	1060	701.00	inches
6688	650	1061	694.00	inches
6689	667	1062	642.50	inches
6690	334	1060	633.50	inches
6691	1133	1060	630.00	inches
6692	713	1061	567.00	inches
6693	443	1062	566.00	inches
6694	390	1062	520.00	inches
6695	333	1074	62.00	inches
6696	350	1074	58.00	inches
6697	487	1073	56.00	inches
6698	515	1072	54.00	inches
6699	626	1074	54.00	inches
6700	633	1074	54.00	inches
6701	498	1073	50.00	inches
6702	734	1072	50.00	inches
6703	711	1073	50.00	inches
6704	741	1074	50.00	inches
6705	644	1073	48.00	inches
6706	664	1073	48.00	inches
6707	647	1079	158.00	inches
6708	577	1080	146.00	inches
6709	634	1080	123.00	inches
6710	601	1080	108.00	inches
6711	1136	1079	102.00	inches
6712	501	1080	90.00	inches
6713	384	1079	84.00	inches
6714	342	1078	78.00	inches
6715	647	1049	203.25	inches
6716	627	1050	194.00	inches
6717	487	1049	180.75	inches
6718	515	1048	178.00	inches
6719	632	1050	178.00	inches
6720	347	1048	176.00	inches
6721	566	1049	174.00	inches
6722	452	1050	172.00	inches
6723	498	1049	169.00	inches
6724	429	1050	166.50	inches
6725	322	1050	164.00	inches
6726	663	1048	158.50	inches
6727	424	1048	158.00	inches
6728	741	1050	156.50	inches
6729	720	1048	155.00	inches
6730	349	1050	154.75	inches
6731	1141	1049	151.00	inches
6732	416	1048	149.50	inches
6733	536	1050	148.00	inches
6734	731	1050	141.50	inches
6735	408	1049	136.50	inches
6736	634	1056	434.50	inches
6737	633	1056	394.00	inches
6738	632	1056	385.75	inches
6739	515	1054	381.00	inches
6740	626	1056	370.00	inches
6741	601	1056	367.50	inches
6742	533	1055	359.50	inches
6743	322	1056	356.00	inches
6744	708	1055	345.50	inches
6745	429	1056	343.00	inches
6746	741	1056	334.75	inches
6747	536	1056	332.50	inches
6748	452	1056	329.00	inches
6749	663	1054	322.00	inches
6750	408	1055	301.00	inches
6751	710	1054	297.00	inches
6752	745	1054	291.00	inches
6753	720	1054	290.75	inches
6754	597	975	11.40	seconds
6755	520	975	11.55	seconds
6756	391	975	11.59	seconds
6757	482	975	11.78	seconds
6758	386	974	11.93	seconds
6759	519	974	12.01	seconds
6760	794	973	12.06	seconds
6761	715	975	12.09	seconds
6762	726	975	12.10	seconds
6763	383	975	12.14	seconds
6764	669	975	12.14	seconds
6765	435	975	12.15	seconds
6766	696	974	12.19	seconds
6767	605	973	12.21	seconds
6768	798	975	12.22	seconds
6769	551	975	12.25	seconds
6770	689	975	12.30	seconds
6771	407	975	12.34	seconds
6772	530	975	12.35	seconds
6773	552	975	12.37	seconds
6774	693	973	12.40	seconds
6775	370	974	12.41	seconds
6776	438	975	12.46	seconds
6777	582	975	12.49	seconds
6778	728	974	12.50	seconds
6779	427	975	12.55	seconds
6780	668	974	12.59	seconds
6781	398	975	12.65	seconds
6782	309	975	12.68	seconds
6783	801	974	12.70	seconds
6784	748	974	12.71	seconds
6785	580	974	13.24	seconds
6786	1137	973	13.30	seconds
6787	575	973	13.32	seconds
6788	564	974	13.36	seconds
6789	567	973	14.79	seconds
6790	597	981	22.80	seconds
6791	391	981	23.02	seconds
6792	482	981	23.75	seconds
6793	656	981	24.15	seconds
6794	520	981	24.19	seconds
6795	689	981	24.37	seconds
6796	802	979	24.50	seconds
6797	715	981	24.57	seconds
6798	726	981	24.59	seconds
6799	582	981	24.65	seconds
6800	386	980	24.69	seconds
6801	794	979	24.77	seconds
6802	712	981	24.80	seconds
6803	605	979	24.97	seconds
6804	438	981	24.98	seconds
6805	383	981	25.26	seconds
6806	928	981	25.26	seconds
6807	693	979	25.28	seconds
6808	370	980	25.31	seconds
6809	340	981	25.35	seconds
6810	435	981	25.41	seconds
6811	596	979	25.55	seconds
6812	749	980	25.57	seconds
6813	748	980	25.63	seconds
6814	671	981	25.85	seconds
6815	439	979	25.86	seconds
6816	801	980	26.00	seconds
6817	495	980	26.00	seconds
6818	779	979	26.00	seconds
6819	444	981	26.24	seconds
6820	398	981	26.31	seconds
6821	668	980	26.43	seconds
6822	580	980	26.72	seconds
6823	682	980	26.73	seconds
6824	309	981	26.99	seconds
6825	575	979	27.22	seconds
6826	563	980	27.31	seconds
6827	817	981	27.40	seconds
6828	1137	979	27.85	seconds
6829	571	979	27.87	seconds
6830	564	980	27.91	seconds
6831	567	979	30.95	seconds
6832	597	987	52.00	seconds
6833	753	987	52.80	seconds
6834	802	985	53.31	seconds
6835	608	985	54.50	seconds
6836	407	987	54.59	seconds
6837	374	985	54.91	seconds
6838	582	987	54.97	seconds
6839	718	985	55.20	seconds
6840	618	987	56.30	seconds
6841	780	985	56.42	seconds
6842	727	987	56.43	seconds
6843	749	986	56.56	seconds
6844	712	987	56.59	seconds
6845	495	986	56.69	seconds
6846	381	987	57.00	seconds
6847	340	987	57.14	seconds
6848	768	987	57.40	seconds
6849	785	985	58.46	seconds
6850	748	986	58.51	seconds
6851	576	986	58.54	seconds
6852	444	987	58.68	seconds
6853	671	987	58.68	seconds
6854	682	986	59.77	seconds
6855	425	987	59.85	seconds
6856	563	986	60.19	seconds
6857	398	987	61.64	seconds
6858	571	985	61.76	seconds
6859	430	987	61.86	seconds
6860	579	985	62.00	seconds
6861	412	987	62.02	seconds
6862	817	987	62.17	seconds
6863	567	985	66.95	seconds
6864	516	993	117.76	seconds
6865	753	993	120.11	seconds
6866	625	991	120.44	seconds
6867	592	992	123.17	seconds
6868	696	992	124.50	seconds
6869	810	992	126.70	seconds
6870	752	992	127.97	seconds
6871	751	993	132.15	seconds
6872	749	992	132.42	seconds
6873	514	991	132.92	seconds
6874	615	991	133.64	seconds
6875	363	993	133.68	seconds
6876	815	992	136.07	seconds
6877	754	991	137.30	seconds
6878	409	993	137.77	seconds
6879	572	993	137.90	seconds
6880	458	993	138.82	seconds
6881	542	993	143.50	seconds
6882	449	993	145.48	seconds
6883	662	993	147.39	seconds
6884	413	993	147.52	seconds
6885	432	993	150.93	seconds
6886	563	992	157.11	seconds
6887	746	993	159.30	seconds
6888	436	992	161.05	seconds
6889	516	999	258.40	seconds
6890	592	998	263.39	seconds
6891	696	998	273.00	seconds
6892	929	999	273.02	seconds
6893	752	998	273.19	seconds
6894	753	999	276.92	seconds
6895	490	999	277.73	seconds
6896	810	998	280.40	seconds
6897	555	998	280.96	seconds
6898	470	998	284.23	seconds
6899	815	998	286.03	seconds
6900	514	997	292.58	seconds
6901	351	997	294.91	seconds
6902	308	999	298.01	seconds
6903	560	999	298.45	seconds
6904	543	999	304.59	seconds
6905	739	999	305.59	seconds
6906	717	997	305.81	seconds
6907	744	999	305.90	seconds
6908	1135	997	306.66	seconds
6909	547	998	306.68	seconds
6910	458	999	309.69	seconds
6911	409	999	311.85	seconds
6912	542	999	313.20	seconds
6913	662	999	317.37	seconds
6914	751	999	319.67	seconds
6915	413	999	323.22	seconds
6916	570	999	323.32	seconds
6917	750	999	323.74	seconds
6918	411	998	324.00	seconds
6919	432	999	326.17	seconds
6920	316	998	326.72	seconds
6921	754	997	327.61	seconds
6922	589	997	329.89	seconds
6923	765	998	332.80	seconds
6924	561	997	387.56	seconds
6925	612	1005	592.00	seconds
6926	490	1005	596.81	seconds
6927	516	1005	604.07	seconds
6928	470	1004	604.50	seconds
6929	929	1005	619.53	seconds
6930	815	1004	636.80	seconds
6931	610	1005	637.30	seconds
6932	787	1003	641.38	seconds
6933	560	1005	642.34	seconds
6934	619	1003	653.90	seconds
6935	550	1003	655.50	seconds
6936	559	1004	655.60	seconds
6937	547	1004	657.90	seconds
6938	1135	1003	667.89	seconds
6939	739	1005	673.79	seconds
6940	351	1003	675.32	seconds
6941	308	1005	675.48	seconds
6942	609	1003	678.80	seconds
6943	717	1003	688.19	seconds
6944	543	1005	689.93	seconds
6945	411	1004	691.80	seconds
6946	409	1005	695.42	seconds
6947	317	1005	696.55	seconds
6948	316	1004	697.60	seconds
6949	662	1005	703.06	seconds
6950	337	1003	704.68	seconds
6951	413	1005	705.69	seconds
6952	795	1003	706.01	seconds
6953	458	1005	713.48	seconds
6954	306	1003	725.74	seconds
6955	434	1004	728.81	seconds
6956	410	1003	765.27	seconds
6957	504	1004	767.08	seconds
6958	561	1003	865.06	seconds
6959	378	1035	16.68	seconds
6960	491	1034	17.34	seconds
6961	656	1035	17.36	seconds
6962	607	1035	17.54	seconds
6963	527	1035	17.60	seconds
6964	813	1035	18.64	seconds
6965	784	1033	19.19	seconds
6966	478	1034	19.37	seconds
6967	396	1035	19.73	seconds
6968	727	1035	19.76	seconds
6969	799	1033	21.17	seconds
6970	395	1034	22.94	seconds
6971	450	1033	25.39	seconds
6972	421	1033	\N	\N
6973	656	1041	43.52	seconds
6974	491	1040	44.20	seconds
6975	378	1041	44.65	seconds
6976	802	1039	45.07	seconds
6977	381	1041	45.80	seconds
6978	607	1041	45.82	seconds
6979	727	1041	45.88	seconds
6980	527	1041	46.00	seconds
6981	570	1041	46.96	seconds
6982	784	1039	47.80	seconds
6983	396	1041	48.08	seconds
6984	478	1040	48.72	seconds
6985	421	1039	50.14	seconds
6986	799	1039	51.31	seconds
6987	813	1041	51.50	seconds
6988	551	1041	52.85	seconds
6989	395	1040	57.19	seconds
6990	722	1041	59.59	seconds
6991	450	1039	60.50	seconds
6992	661	1065	609.00	inches
6993	460	1064	557.00	inches
6994	497	1065	497.00	inches
6995	729	1065	481.25	inches
6996	703	1065	471.50	inches
6997	669	1065	471.00	inches
6998	344	1065	463.50	inches
6999	737	1065	461.50	inches
7000	1148	1065	449.50	inches
7001	512	1065	449.00	inches
7002	431	1065	440.00	inches
7003	321	1065	432.75	inches
7004	792	1063	428.50	inches
7005	791	1063	425.50	inches
7006	552	1065	422.00	inches
7007	327	1064	421.00	inches
7008	532	1065	420.00	inches
7009	506	1065	393.50	inches
7010	397	1064	390.75	inches
7011	618	1065	390.00	inches
7012	585	1064	359.25	inches
7013	1142	1063	311.00	inches
7014	1145	1064	259.75	inches
7015	661	1059	1782.00	inches
7016	460	1058	1580.50	inches
7017	497	1059	1509.00	inches
7018	532	1059	1425.50	inches
7019	737	1059	1413.00	inches
7020	344	1059	1363.00	inches
7021	792	1057	1191.00	inches
7022	703	1059	1133.00	inches
7023	512	1059	1130.00	inches
7024	618	1059	1121.50	inches
7025	431	1059	1118.00	inches
7026	548	1058	1106.50	inches
7027	397	1058	1092.00	inches
7028	327	1058	1090.00	inches
7029	506	1059	1082.00	inches
7030	488	1058	1080.00	inches
7031	791	1057	1061.75	inches
7032	729	1059	1028.50	inches
7033	700	1058	1000.00	inches
7034	585	1058	991.50	inches
7035	564	1058	883.00	inches
7036	378	1071	72.00	inches
7037	781	1069	70.00	inches
7038	733	1071	70.00	inches
7039	714	1071	68.00	inches
7040	388	1071	67.00	inches
7041	509	1071	64.00	inches
7042	630	1070	64.00	inches
7043	332	1070	63.00	inches
7044	345	1069	62.00	inches
7045	507	1070	60.00	inches
7046	451	1070	58.00	inches
7047	823	1071	58.00	inches
7048	570	1071	58.00	inches
7049	690	1070	58.00	inches
7050	693	1069	56.00	inches
7051	430	1071	52.00	inches
7052	376	1077	138.00	inches
7053	629	1077	138.00	inches
7054	527	1077	126.00	inches
7055	630	1076	126.00	inches
7056	388	1077	120.00	inches
7057	505	1077	120.00	inches
7058	364	1075	108.00	inches
7059	805	1075	108.00	inches
7060	590	1076	108.00	inches
7061	718	1075	108.00	inches
7062	690	1076	102.00	inches
7063	784	1075	97.00	inches
7064	1166	1075	96.00	inches
7065	325	1077	84.00	inches
7066	733	1047	236.00	inches
7067	715	1047	235.50	inches
7068	378	1047	232.00	inches
7069	519	1046	230.00	inches
7070	491	1046	227.75	inches
7071	403	1046	224.00	inches
7072	689	1047	223.50	inches
7073	607	1047	221.50	inches
7074	714	1047	218.00	inches
7075	732	1047	218.00	inches
7076	520	1047	216.00	inches
7077	509	1047	216.00	inches
7078	383	1047	213.50	inches
7079	386	1046	213.00	inches
7080	332	1046	212.00	inches
7081	530	1047	211.75	inches
7082	478	1046	210.50	inches
7083	661	1047	207.75	inches
7084	781	1045	207.00	inches
7085	824	1045	206.00	inches
7086	778	1046	205.25	inches
7087	507	1046	204.00	inches
7088	721	1047	201.00	inches
7089	451	1046	198.75	inches
7090	430	1047	194.25	inches
7091	690	1046	191.00	inches
7092	412	1047	188.75	inches
7093	575	1045	185.00	inches
7094	1180	1047	182.50	inches
7095	579	1045	179.00	inches
7096	433	1046	178.00	inches
7097	561	1045	157.00	inches
7098	519	1052	501.00	inches
7099	733	1053	478.75	inches
7100	403	1052	475.75	inches
7101	509	1053	467.00	inches
7102	732	1053	467.00	inches
7103	607	1053	466.00	inches
7104	376	1053	463.00	inches
7105	530	1053	453.50	inches
7106	781	1051	442.00	inches
7107	332	1052	440.00	inches
7108	714	1053	433.00	inches
7109	507	1052	430.00	inches
7110	430	1053	424.00	inches
7111	690	1052	421.50	inches
7112	728	1052	412.00	inches
7113	778	1052	406.50	inches
7114	451	1052	395.25	inches
7115	412	1053	388.25	inches
7116	1180	1053	377.00	inches
7117	433	1052	370.00	inches
7118	645	1086	12.15	seconds
7119	647	1085	13.21	seconds
7120	528	1084	13.61	seconds
7121	632	1086	13.79	seconds
7122	566	1085	13.82	seconds
7123	719	1086	13.87	seconds
7124	660	1084	13.92	seconds
7125	617	1085	13.98	seconds
7126	588	1086	14.06	seconds
7127	827	1084	14.30	seconds
7128	663	1084	14.34	seconds
7129	452	1086	14.35	seconds
7130	764	1084	14.35	seconds
7131	423	1085	14.42	seconds
7132	735	1086	14.51	seconds
7133	755	1086	14.52	seconds
7134	429	1086	14.53	seconds
7135	416	1084	14.66	seconds
7136	355	1085	14.70	seconds
7137	706	1084	14.71	seconds
7138	825	1086	14.80	seconds
7139	1133	1084	14.82	seconds
7140	1141	1085	14.85	seconds
7141	424	1084	14.89	seconds
7142	702	1085	14.89	seconds
7143	736	1084	14.89	seconds
7144	578	1085	14.95	seconds
7145	695	1084	15.00	seconds
7146	1132	1084	15.48	seconds
7147	573	1084	15.51	seconds
7148	586	1085	15.54	seconds
7149	644	1085	15.92	seconds
7150	641	1086	16.12	seconds
7151	635	1085	16.44	seconds
7152	631	1086	17.58	seconds
7153	645	1092	24.76	seconds
7154	627	1092	26.90	seconds
7155	708	1091	27.96	seconds
7156	367	1091	28.02	seconds
7157	719	1092	28.10	seconds
7158	634	1092	28.34	seconds
7159	528	1090	28.69	seconds
7160	588	1092	29.61	seconds
7161	660	1090	29.71	seconds
7162	764	1090	30.38	seconds
7163	663	1090	30.73	seconds
7164	1141	1091	30.80	seconds
7165	706	1090	30.84	seconds
7166	825	1092	30.90	seconds
7167	416	1090	30.93	seconds
7168	695	1090	31.08	seconds
7169	594	1090	31.10	seconds
7170	745	1090	31.20	seconds
7171	763	1090	31.23	seconds
7172	702	1091	31.50	seconds
7173	1133	1090	31.79	seconds
7174	755	1092	32.08	seconds
7175	573	1090	32.13	seconds
7176	586	1091	32.29	seconds
7177	424	1090	33.01	seconds
7178	769	1092	33.13	seconds
7179	456	1090	33.28	seconds
7180	644	1091	34.12	seconds
7181	408	1091	34.58	seconds
7182	1132	1090	35.30	seconds
7183	635	1091	35.42	seconds
7184	641	1092	35.61	seconds
7185	631	1092	36.99	seconds
7186	645	1098	56.00	seconds
7187	367	1097	60.62	seconds
7188	708	1097	63.60	seconds
7189	627	1098	66.29	seconds
7190	584	1097	67.92	seconds
7191	423	1097	70.40	seconds
7192	763	1096	70.48	seconds
7193	611	1097	70.57	seconds
7194	380	1096	71.07	seconds
7195	623	1098	71.14	seconds
7196	740	1098	71.26	seconds
7197	384	1097	71.34	seconds
7198	362	1096	72.24	seconds
7199	725	1098	72.54	seconds
7200	501	1098	73.67	seconds
7201	489	1098	74.68	seconds
7202	529	1098	75.35	seconds
7203	456	1096	76.24	seconds
7204	394	1096	78.47	seconds
7205	424	1096	78.79	seconds
7206	1130	1097	79.84	seconds
7207	624	1104	148.04	seconds
7208	595	1103	151.40	seconds
7209	587	1104	153.47	seconds
7210	366	1102	154.98	seconds
7211	581	1103	159.76	seconds
7212	455	1102	160.68	seconds
7213	688	1104	160.73	seconds
7214	549	1102	161.27	seconds
7215	362	1102	162.53	seconds
7216	831	1103	166.07	seconds
7217	556	1103	169.40	seconds
7218	816	1104	170.98	seconds
7219	734	1102	172.15	seconds
7220	521	1104	173.57	seconds
7221	335	1103	173.75	seconds
7222	769	1104	174.03	seconds
7223	499	1104	178.01	seconds
7224	740	1104	180.20	seconds
7225	422	1104	183.93	seconds
7226	759	1104	184.15	seconds
7227	1144	1103	189.81	seconds
7228	419	1104	191.97	seconds
7229	392	1102	191.99	seconds
7230	642	1104	196.33	seconds
7231	639	1104	204.03	seconds
7232	587	1110	298.53	seconds
7233	624	1110	327.78	seconds
7234	583	1110	336.32	seconds
7235	595	1109	336.97	seconds
7236	366	1108	338.73	seconds
7237	688	1110	345.20	seconds
7238	362	1108	354.72	seconds
7239	455	1108	356.26	seconds
7240	831	1109	361.02	seconds
7241	816	1110	363.73	seconds
7242	521	1110	365.12	seconds
7243	540	1109	368.40	seconds
7244	549	1108	370.35	seconds
7245	499	1110	371.88	seconds
7246	707	1109	373.11	seconds
7247	492	1109	375.22	seconds
7248	683	1108	378.64	seconds
7249	486	1110	381.00	seconds
7250	545	1108	383.01	seconds
7251	323	1108	384.84	seconds
7252	341	1108	388.06	seconds
7253	314	1108	394.01	seconds
7254	759	1110	394.17	seconds
7255	422	1110	395.87	seconds
7256	311	1110	398.87	seconds
7257	419	1110	410.75	seconds
7258	541	1110	418.03	seconds
7259	1144	1109	422.39	seconds
7260	392	1108	426.26	seconds
7261	642	1110	431.98	seconds
7262	639	1110	451.33	seconds
7263	587	1116	661.55	seconds
7264	688	1116	728.29	seconds
7265	492	1115	743.93	seconds
7266	624	1116	750.44	seconds
7267	583	1116	750.85	seconds
7268	366	1114	752.55	seconds
7269	521	1116	787.16	seconds
7270	707	1115	788.37	seconds
7271	831	1115	790.99	seconds
7272	553	1115	810.62	seconds
7273	556	1115	822.42	seconds
7274	540	1115	826.51	seconds
7275	455	1114	834.83	seconds
7276	683	1114	837.28	seconds
7277	314	1114	840.62	seconds
7278	486	1116	853.10	seconds
7279	323	1114	859.04	seconds
7280	341	1114	859.35	seconds
7281	422	1116	875.03	seconds
7282	419	1116	914.13	seconds
7283	633	1140	16.81	seconds
7284	566	1139	17.29	seconds
7285	628	1140	17.46	seconds
7286	636	1138	17.97	seconds
7287	638	1139	19.00	seconds
7288	496	1140	19.36	seconds
7289	517	1140	19.44	seconds
7290	1133	1138	19.45	seconds
7291	664	1139	20.48	seconds
7292	711	1139	21.12	seconds
7293	679	1139	21.75	seconds
7294	657	1139	21.89	seconds
7295	617	1151	48.10	seconds
7296	566	1151	51.12	seconds
7297	633	1152	51.36	seconds
7298	628	1152	51.95	seconds
7299	636	1150	52.49	seconds
7300	355	1151	53.06	seconds
7301	664	1151	53.07	seconds
7302	517	1152	53.25	seconds
7303	638	1151	53.66	seconds
7304	496	1152	55.75	seconds
7305	380	1150	57.78	seconds
7306	711	1151	58.71	seconds
7307	679	1151	60.04	seconds
7308	637	1151	60.38	seconds
7309	657	1151	63.71	seconds
7310	356	1175	418.50	inches
7311	440	1175	357.00	inches
7312	503	1176	338.00	inches
7313	523	1176	333.00	inches
7314	461	1176	331.00	inches
7315	448	1174	330.50	inches
7316	500	1175	326.00	inches
7317	650	1175	316.00	inches
7318	677	1175	313.25	inches
7319	827	1174	309.50	inches
7320	526	1176	290.75	inches
7321	601	1176	289.00	inches
7322	646	1176	283.00	inches
7323	1178	1175	274.00	inches
7324	406	1175	273.50	inches
7325	710	1174	267.75	inches
7326	692	1176	265.50	inches
7327	334	1174	262.50	inches
7328	667	1176	261.00	inches
7329	390	1176	257.00	inches
7330	811	1175	252.00	inches
7331	357	1175	248.00	inches
7332	443	1176	240.25	inches
7333	731	1176	201.25	inches
7334	503	1170	1136.00	inches
7335	533	1169	1136.00	inches
7336	461	1170	1063.00	inches
7337	827	1168	1053.00	inches
7338	523	1170	1045.00	inches
7339	356	1169	1018.00	inches
7340	677	1169	963.00	inches
7341	440	1169	926.00	inches
7342	601	1170	922.00	inches
7343	526	1170	912.00	inches
7344	349	1170	874.00	inches
7345	525	1170	865.00	inches
7346	1178	1169	835.50	inches
7347	725	1170	802.00	inches
7348	710	1168	789.00	inches
7349	692	1170	776.00	inches
7350	500	1169	744.00	inches
7351	448	1168	730.00	inches
7352	646	1170	724.00	inches
7353	406	1169	713.00	inches
7354	670	1168	701.00	inches
7355	650	1169	694.00	inches
7356	667	1170	642.50	inches
7357	334	1168	633.50	inches
7358	1133	1168	630.00	inches
7359	713	1169	567.00	inches
7360	443	1170	566.00	inches
7361	390	1170	520.00	inches
7362	333	1182	62.00	inches
7363	350	1182	58.00	inches
7364	487	1181	56.00	inches
7365	515	1180	54.00	inches
7366	626	1182	54.00	inches
7367	633	1182	54.00	inches
7368	498	1181	50.00	inches
7369	734	1180	50.00	inches
7370	711	1181	50.00	inches
7371	741	1182	50.00	inches
7372	644	1181	48.00	inches
7373	664	1181	48.00	inches
7374	647	1187	158.00	inches
7375	577	1188	146.00	inches
7376	634	1188	123.00	inches
7377	601	1188	108.00	inches
7378	1136	1187	102.00	inches
7379	501	1188	90.00	inches
7380	384	1187	84.00	inches
7381	342	1186	78.00	inches
7382	647	1157	203.25	inches
7383	627	1158	194.00	inches
7384	487	1157	180.75	inches
7385	515	1156	178.00	inches
7386	632	1158	178.00	inches
7387	347	1156	176.00	inches
7388	566	1157	174.00	inches
7389	755	1158	172.00	inches
7390	452	1158	172.00	inches
7391	498	1157	169.00	inches
7392	429	1158	166.50	inches
7393	322	1158	164.00	inches
7394	663	1156	158.50	inches
7395	424	1156	158.00	inches
7396	741	1158	156.50	inches
7397	720	1156	155.00	inches
7398	349	1158	154.75	inches
7399	1141	1157	151.00	inches
7400	416	1156	149.50	inches
7401	536	1158	148.00	inches
7402	1132	1156	146.00	inches
7403	731	1158	141.50	inches
7404	408	1157	136.50	inches
7405	634	1164	434.50	inches
7406	633	1164	394.00	inches
7407	632	1164	385.75	inches
7408	515	1162	381.00	inches
7409	626	1164	370.00	inches
7410	601	1164	367.50	inches
7411	533	1163	359.50	inches
7412	322	1164	356.00	inches
7413	755	1164	353.00	inches
7414	708	1163	345.50	inches
7415	429	1164	343.00	inches
7416	741	1164	334.75	inches
7417	536	1164	332.50	inches
7418	452	1164	329.00	inches
7419	663	1162	322.00	inches
7420	408	1163	301.00	inches
7421	710	1162	297.00	inches
7422	745	1162	291.00	inches
7423	720	1162	290.75	inches
7424	597	1083	11.40	seconds
7425	520	1083	11.55	seconds
7426	391	1083	11.59	seconds
7427	482	1083	11.78	seconds
7428	386	1082	11.93	seconds
7429	519	1082	12.01	seconds
7430	794	1081	12.06	seconds
7431	715	1083	12.09	seconds
7432	726	1083	12.10	seconds
7433	383	1083	12.14	seconds
7434	669	1083	12.14	seconds
7435	435	1083	12.15	seconds
7436	696	1082	12.19	seconds
7437	605	1081	12.21	seconds
7438	798	1083	12.22	seconds
7439	551	1083	12.25	seconds
7440	689	1083	12.30	seconds
7441	407	1083	12.34	seconds
7442	530	1083	12.35	seconds
7443	552	1083	12.37	seconds
7444	693	1081	12.40	seconds
7445	370	1082	12.41	seconds
7446	438	1083	12.46	seconds
7447	582	1083	12.49	seconds
7448	728	1082	12.50	seconds
7449	427	1083	12.55	seconds
7450	668	1082	12.59	seconds
7451	398	1083	12.65	seconds
7452	309	1083	12.68	seconds
7453	801	1082	12.70	seconds
7454	748	1082	12.71	seconds
7455	757	1083	12.78	seconds
7456	758	1082	12.91	seconds
7457	580	1082	13.24	seconds
7458	1137	1081	13.30	seconds
7459	575	1081	13.32	seconds
7460	564	1082	13.36	seconds
7461	567	1081	14.79	seconds
7462	597	1089	22.80	seconds
7463	391	1089	23.02	seconds
7464	482	1089	23.75	seconds
7465	656	1089	24.15	seconds
7466	520	1089	24.19	seconds
7467	689	1089	24.37	seconds
7468	802	1087	24.50	seconds
7469	715	1089	24.57	seconds
7470	726	1089	24.59	seconds
7471	582	1089	24.65	seconds
7472	386	1088	24.69	seconds
7473	794	1087	24.77	seconds
7474	712	1089	24.80	seconds
7475	605	1087	24.97	seconds
7476	438	1089	24.98	seconds
7477	383	1089	25.26	seconds
7478	928	1089	25.26	seconds
7479	693	1087	25.28	seconds
7480	370	1088	25.31	seconds
7481	340	1089	25.35	seconds
7482	435	1089	25.41	seconds
7483	596	1087	25.55	seconds
7484	749	1088	25.57	seconds
7485	748	1088	25.63	seconds
7486	671	1089	25.85	seconds
7487	439	1087	25.86	seconds
7488	801	1088	26.00	seconds
7489	495	1088	26.00	seconds
7490	779	1087	26.00	seconds
7491	444	1089	26.24	seconds
7492	758	1088	26.30	seconds
7493	398	1089	26.31	seconds
7494	668	1088	26.43	seconds
7495	757	1089	26.52	seconds
7496	580	1088	26.72	seconds
7497	682	1088	26.73	seconds
7498	309	1089	26.99	seconds
7499	575	1087	27.22	seconds
7500	563	1088	27.31	seconds
7501	817	1089	27.40	seconds
7502	1137	1087	27.85	seconds
7503	571	1087	27.87	seconds
7504	564	1088	27.91	seconds
7505	567	1087	30.95	seconds
7506	597	1095	52.00	seconds
7507	753	1095	52.80	seconds
7508	802	1093	53.31	seconds
7509	608	1093	54.50	seconds
7510	407	1095	54.59	seconds
7511	374	1093	54.91	seconds
7512	582	1095	54.97	seconds
7513	718	1093	55.20	seconds
7514	618	1095	56.30	seconds
7515	780	1093	56.42	seconds
7516	727	1095	56.43	seconds
7517	749	1094	56.56	seconds
7518	712	1095	56.59	seconds
7519	495	1094	56.69	seconds
7520	381	1095	57.00	seconds
7521	340	1095	57.14	seconds
7522	768	1095	57.40	seconds
7523	785	1093	58.46	seconds
7524	748	1094	58.51	seconds
7525	576	1094	58.54	seconds
7526	444	1095	58.68	seconds
7527	671	1095	58.68	seconds
7528	682	1094	59.77	seconds
7529	425	1095	59.85	seconds
7530	758	1094	59.95	seconds
7531	563	1094	60.19	seconds
7532	398	1095	61.64	seconds
7533	571	1093	61.76	seconds
7534	430	1095	61.86	seconds
7535	579	1093	62.00	seconds
7536	412	1095	62.02	seconds
7537	817	1095	62.17	seconds
7538	761	1094	63.56	seconds
7539	756	1095	63.98	seconds
7540	567	1093	66.95	seconds
7541	516	1101	117.76	seconds
7542	753	1101	120.11	seconds
7543	625	1099	120.44	seconds
7544	592	1100	123.17	seconds
7545	696	1100	124.50	seconds
7546	810	1100	126.70	seconds
7547	752	1100	127.97	seconds
7548	751	1101	132.15	seconds
7549	749	1100	132.42	seconds
7550	514	1099	132.92	seconds
7551	615	1099	133.64	seconds
7552	363	1101	133.68	seconds
7553	815	1100	136.07	seconds
7554	754	1099	137.30	seconds
7555	409	1101	137.77	seconds
7556	572	1101	137.90	seconds
7557	458	1101	138.82	seconds
7558	542	1101	143.50	seconds
7559	449	1101	145.48	seconds
7560	662	1101	147.39	seconds
7561	413	1101	147.52	seconds
7562	761	1100	150.34	seconds
7563	432	1101	150.93	seconds
7564	563	1100	157.11	seconds
7565	746	1101	159.30	seconds
7566	436	1100	161.05	seconds
7567	756	1101	\N	\N
7568	516	1107	258.40	seconds
7569	592	1106	263.39	seconds
7570	696	1106	273.00	seconds
7571	929	1107	273.02	seconds
7572	752	1106	273.19	seconds
7573	753	1107	276.92	seconds
7574	490	1107	277.73	seconds
7575	810	1106	280.40	seconds
7576	555	1106	280.96	seconds
7577	470	1106	284.23	seconds
7578	815	1106	286.03	seconds
7579	514	1105	292.58	seconds
7580	351	1105	294.91	seconds
7581	308	1107	298.01	seconds
7582	560	1107	298.45	seconds
7583	543	1107	304.59	seconds
7584	739	1107	305.59	seconds
7585	717	1105	305.81	seconds
7586	744	1107	305.90	seconds
7587	1135	1105	306.66	seconds
7588	547	1106	306.68	seconds
7589	458	1107	309.69	seconds
7590	409	1107	311.85	seconds
7591	542	1107	313.20	seconds
7592	662	1107	317.37	seconds
7593	751	1107	319.67	seconds
7594	413	1107	323.22	seconds
7595	570	1107	323.32	seconds
7596	750	1107	323.74	seconds
7597	411	1106	324.00	seconds
7598	432	1107	326.17	seconds
7599	316	1106	326.72	seconds
7600	754	1105	327.61	seconds
7601	761	1106	329.40	seconds
7602	589	1105	329.89	seconds
7603	765	1106	332.80	seconds
7604	756	1107	349.50	seconds
7605	561	1105	387.56	seconds
7606	612	1113	592.00	seconds
7607	490	1113	596.81	seconds
7608	516	1113	604.07	seconds
7609	470	1112	604.50	seconds
7610	929	1113	619.53	seconds
7611	815	1112	636.80	seconds
7612	610	1113	637.30	seconds
7613	787	1111	641.38	seconds
7614	560	1113	642.34	seconds
7615	619	1111	653.90	seconds
7616	550	1111	655.50	seconds
7617	559	1112	655.60	seconds
7618	547	1112	657.90	seconds
7619	1135	1111	667.89	seconds
7620	739	1113	673.79	seconds
7621	351	1111	675.32	seconds
7622	308	1113	675.48	seconds
7623	609	1111	678.80	seconds
7624	717	1111	688.19	seconds
7625	543	1113	689.93	seconds
7626	411	1112	691.80	seconds
7627	409	1113	695.42	seconds
7628	317	1113	696.55	seconds
7629	316	1112	697.60	seconds
7630	662	1113	703.06	seconds
7631	337	1111	704.68	seconds
7632	413	1113	705.69	seconds
7633	795	1111	706.01	seconds
7634	458	1113	713.48	seconds
7635	306	1111	725.74	seconds
7636	434	1112	728.81	seconds
7637	410	1111	765.27	seconds
7638	504	1112	767.08	seconds
7639	561	1111	865.06	seconds
7640	378	1143	16.68	seconds
7641	491	1142	17.34	seconds
7642	656	1143	17.36	seconds
7643	607	1143	17.54	seconds
7644	527	1143	17.60	seconds
7645	813	1143	18.64	seconds
7646	784	1141	19.19	seconds
7647	478	1142	19.37	seconds
7648	396	1143	19.73	seconds
7649	727	1143	19.76	seconds
7650	799	1141	21.17	seconds
7651	395	1142	22.94	seconds
7652	450	1141	25.39	seconds
7653	421	1141	\N	\N
7654	656	1149	43.52	seconds
7655	491	1148	44.20	seconds
7656	378	1149	44.65	seconds
7657	802	1147	45.07	seconds
7658	381	1149	45.80	seconds
7659	607	1149	45.82	seconds
7660	727	1149	45.88	seconds
7661	527	1149	46.00	seconds
7662	570	1149	46.96	seconds
7663	784	1147	47.80	seconds
7664	396	1149	48.08	seconds
7665	478	1148	48.72	seconds
7666	421	1147	50.14	seconds
7667	799	1147	51.31	seconds
7668	813	1149	51.50	seconds
7669	551	1149	52.85	seconds
7670	395	1148	57.19	seconds
7671	722	1149	59.59	seconds
7672	450	1147	60.50	seconds
7673	661	1173	609.00	inches
7674	460	1172	557.00	inches
7675	497	1173	497.00	inches
7676	729	1173	481.25	inches
7677	703	1173	471.50	inches
7678	669	1173	471.00	inches
7679	344	1173	463.50	inches
7680	737	1173	461.50	inches
7681	1148	1173	449.50	inches
7682	512	1173	449.00	inches
7683	431	1173	440.00	inches
7684	321	1173	432.75	inches
7685	792	1171	428.50	inches
7686	791	1171	425.50	inches
7687	552	1173	422.00	inches
7688	327	1172	421.00	inches
7689	532	1173	420.00	inches
7690	506	1173	393.50	inches
7691	397	1172	390.75	inches
7692	618	1173	390.00	inches
7693	585	1172	359.25	inches
7694	758	1172	312.50	inches
7695	1142	1171	311.00	inches
7696	757	1173	290.00	inches
7697	1145	1172	259.75	inches
7698	661	1167	1782.00	inches
7699	460	1166	1580.50	inches
7700	497	1167	1509.00	inches
7701	532	1167	1425.50	inches
7702	737	1167	1413.00	inches
7703	344	1167	1363.00	inches
7704	792	1165	1191.00	inches
7705	703	1167	1133.00	inches
7706	512	1167	1130.00	inches
7707	618	1167	1121.50	inches
7708	431	1167	1118.00	inches
7709	548	1166	1106.50	inches
7710	397	1166	1092.00	inches
7711	327	1166	1090.00	inches
7712	506	1167	1082.00	inches
7713	488	1166	1080.00	inches
7714	791	1165	1061.75	inches
7715	729	1167	1028.50	inches
7716	700	1166	1000.00	inches
7717	585	1166	991.50	inches
7718	564	1166	883.00	inches
7719	378	1179	72.00	inches
7720	781	1177	70.00	inches
7721	733	1179	70.00	inches
7722	714	1179	68.00	inches
7723	388	1179	67.00	inches
7724	509	1179	64.00	inches
7725	630	1178	64.00	inches
7726	332	1178	63.00	inches
7727	345	1177	62.00	inches
7728	507	1178	60.00	inches
7729	451	1178	58.00	inches
7730	823	1179	58.00	inches
7731	570	1179	58.00	inches
7732	690	1178	58.00	inches
7733	693	1177	56.00	inches
7734	430	1179	52.00	inches
7735	376	1185	138.00	inches
7736	629	1185	138.00	inches
7737	527	1185	126.00	inches
7738	630	1184	126.00	inches
7739	388	1185	120.00	inches
7740	505	1185	120.00	inches
7741	364	1183	108.00	inches
7742	805	1183	108.00	inches
7743	590	1184	108.00	inches
7744	718	1183	108.00	inches
7745	690	1184	102.00	inches
7746	784	1183	97.00	inches
7747	1166	1183	96.00	inches
7748	325	1185	84.00	inches
7749	733	1155	236.00	inches
7750	715	1155	235.50	inches
7751	378	1155	232.00	inches
7752	519	1154	230.00	inches
7753	491	1154	227.75	inches
7754	403	1154	224.00	inches
7755	689	1155	223.50	inches
7756	607	1155	221.50	inches
7757	714	1155	218.00	inches
7758	732	1155	218.00	inches
7759	520	1155	216.00	inches
7760	509	1155	216.00	inches
7761	383	1155	213.50	inches
7762	386	1154	213.00	inches
7763	332	1154	212.00	inches
7764	530	1155	211.75	inches
7765	478	1154	210.50	inches
7766	661	1155	207.75	inches
7767	781	1153	207.00	inches
7768	824	1153	206.00	inches
7769	778	1154	205.25	inches
7770	507	1154	204.00	inches
7771	721	1155	201.00	inches
7772	451	1154	198.75	inches
7773	430	1155	194.25	inches
7774	690	1154	191.00	inches
7775	412	1155	188.75	inches
7776	575	1153	185.00	inches
7777	1180	1155	182.50	inches
7778	579	1153	179.00	inches
7779	433	1154	178.00	inches
7780	561	1153	157.00	inches
7781	519	1160	501.00	inches
7782	733	1161	478.75	inches
7783	403	1160	475.75	inches
7784	509	1161	467.00	inches
7785	732	1161	467.00	inches
7786	607	1161	466.00	inches
7787	376	1161	463.00	inches
7788	530	1161	453.50	inches
7789	781	1159	442.00	inches
7790	332	1160	440.00	inches
7791	714	1161	433.00	inches
7792	507	1160	430.00	inches
7793	430	1161	424.00	inches
7794	690	1160	421.50	inches
7795	728	1160	412.00	inches
7796	778	1160	406.50	inches
7797	451	1160	395.25	inches
7798	412	1161	388.25	inches
7799	1180	1161	377.00	inches
7800	433	1160	370.00	inches
\.


--
-- Name: entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.entries_id_seq', 7800, true);


--
-- Data for Name: event_defs; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.event_defs (code, name, etype) FROM stdin;
100M	100 Meter	sprint
200M	200 Meter	sprint
400M	400 Meter	sprint
800M	800 Meter	sprint
1600M	1600 Meter	distance
3200M	3200 Meter	distance
4x100M	4x100 Meter Relay	relay
4x400M	4x400 Meter Relay	relay
65H	65 Meter Hurdles	sprint
100H	100 Meter Hurdles (Girls Only)	sprint
110H	110 Meter Hurdles (Boys Only)	sprint
300H	300 Meter Hurdles	sprint
LJ	Long Jump	horzjump
TJ	Triple Jump	horzjump
DT	Discus Throw	throw
SP	Shot Put Throw	throw
HJ	High Jump	vertjump
PV	Pole Vault	vertjump
\.


--
-- Data for Name: meet_division_events; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.meet_division_events (id, div_id, meet_id, event_code) FROM stdin;
1	1	1	100M
2	2	1	100M
3	3	1	100M
4	4	1	100M
5	5	1	100M
6	6	1	100M
7	1	1	200M
8	2	1	200M
9	3	1	200M
10	4	1	200M
11	5	1	200M
12	6	1	200M
13	1	1	400M
14	2	1	400M
15	3	1	400M
16	4	1	400M
17	5	1	400M
18	6	1	400M
19	1	1	800M
20	2	1	800M
21	3	1	800M
22	4	1	800M
23	5	1	800M
24	6	1	800M
25	1	1	1600M
26	2	1	1600M
27	3	1	1600M
28	4	1	1600M
29	5	1	1600M
30	6	1	1600M
31	1	1	3200M
32	2	1	3200M
33	3	1	3200M
34	4	1	3200M
35	5	1	3200M
36	6	1	3200M
37	1	1	4x100M
38	2	1	4x100M
39	3	1	4x100M
40	4	1	4x100M
41	5	1	4x100M
42	6	1	4x100M
43	1	1	4x400M
44	2	1	4x400M
45	3	1	4x400M
46	4	1	4x400M
47	5	1	4x400M
48	6	1	4x400M
49	1	1	65H
50	2	1	65H
51	3	1	65H
52	4	1	65H
53	5	1	65H
54	6	1	65H
55	1	1	100H
56	2	1	100H
57	3	1	100H
58	4	1	100H
59	5	1	100H
60	6	1	100H
61	1	1	110H
62	2	1	110H
63	3	1	110H
64	4	1	110H
65	5	1	110H
66	6	1	110H
67	1	1	300H
68	2	1	300H
69	3	1	300H
70	4	1	300H
71	5	1	300H
72	6	1	300H
73	1	1	LJ
74	2	1	LJ
75	3	1	LJ
76	4	1	LJ
77	5	1	LJ
78	6	1	LJ
79	1	1	TJ
80	2	1	TJ
81	3	1	TJ
82	4	1	TJ
83	5	1	TJ
84	6	1	TJ
85	1	1	DT
86	2	1	DT
87	3	1	DT
88	4	1	DT
89	5	1	DT
90	6	1	DT
91	1	1	SP
92	2	1	SP
93	3	1	SP
94	4	1	SP
95	5	1	SP
96	6	1	SP
97	1	1	HJ
98	2	1	HJ
99	3	1	HJ
100	4	1	HJ
101	5	1	HJ
102	6	1	HJ
103	1	1	PV
104	2	1	PV
105	3	1	PV
106	4	1	PV
107	5	1	PV
108	6	1	PV
109	1	2	100M
110	2	2	100M
111	3	2	100M
112	4	2	100M
113	5	2	100M
114	6	2	100M
115	1	2	200M
116	2	2	200M
117	3	2	200M
118	4	2	200M
119	5	2	200M
120	6	2	200M
121	1	2	400M
122	2	2	400M
123	3	2	400M
124	4	2	400M
125	5	2	400M
126	6	2	400M
127	1	2	800M
128	2	2	800M
129	3	2	800M
130	4	2	800M
131	5	2	800M
132	6	2	800M
133	1	2	1600M
134	2	2	1600M
135	3	2	1600M
136	4	2	1600M
137	5	2	1600M
138	6	2	1600M
139	1	2	3200M
140	2	2	3200M
141	3	2	3200M
142	4	2	3200M
143	5	2	3200M
144	6	2	3200M
145	1	2	4x100M
146	2	2	4x100M
147	3	2	4x100M
148	4	2	4x100M
149	5	2	4x100M
150	6	2	4x100M
151	1	2	4x400M
152	2	2	4x400M
153	3	2	4x400M
154	4	2	4x400M
155	5	2	4x400M
156	6	2	4x400M
157	1	2	65H
158	2	2	65H
159	3	2	65H
160	4	2	65H
161	5	2	65H
162	6	2	65H
163	1	2	100H
164	2	2	100H
165	3	2	100H
166	4	2	100H
167	5	2	100H
168	6	2	100H
169	1	2	110H
170	2	2	110H
171	3	2	110H
172	4	2	110H
173	5	2	110H
174	6	2	110H
175	1	2	300H
176	2	2	300H
177	3	2	300H
178	4	2	300H
179	5	2	300H
180	6	2	300H
181	1	2	LJ
182	2	2	LJ
183	3	2	LJ
184	4	2	LJ
185	5	2	LJ
186	6	2	LJ
187	1	2	TJ
188	2	2	TJ
189	3	2	TJ
190	4	2	TJ
191	5	2	TJ
192	6	2	TJ
193	1	2	DT
194	2	2	DT
195	3	2	DT
196	4	2	DT
197	5	2	DT
198	6	2	DT
199	1	2	SP
200	2	2	SP
201	3	2	SP
202	4	2	SP
203	5	2	SP
204	6	2	SP
205	1	2	HJ
206	2	2	HJ
207	3	2	HJ
208	4	2	HJ
209	5	2	HJ
210	6	2	HJ
211	1	2	PV
212	2	2	PV
213	3	2	PV
214	4	2	PV
215	5	2	PV
216	6	2	PV
217	1	3	100M
218	2	3	100M
219	3	3	100M
220	4	3	100M
221	5	3	100M
222	6	3	100M
223	1	3	200M
224	2	3	200M
225	3	3	200M
226	4	3	200M
227	5	3	200M
228	6	3	200M
229	1	3	400M
230	2	3	400M
231	3	3	400M
232	4	3	400M
233	5	3	400M
234	6	3	400M
235	1	3	800M
236	2	3	800M
237	3	3	800M
238	4	3	800M
239	5	3	800M
240	6	3	800M
241	1	3	1600M
242	2	3	1600M
243	3	3	1600M
244	4	3	1600M
245	5	3	1600M
246	6	3	1600M
247	1	3	3200M
248	2	3	3200M
249	3	3	3200M
250	4	3	3200M
251	5	3	3200M
252	6	3	3200M
253	1	3	4x100M
254	2	3	4x100M
255	3	3	4x100M
256	4	3	4x100M
257	5	3	4x100M
258	6	3	4x100M
259	1	3	4x400M
260	2	3	4x400M
261	3	3	4x400M
262	4	3	4x400M
263	5	3	4x400M
264	6	3	4x400M
265	1	3	65H
266	2	3	65H
267	3	3	65H
268	4	3	65H
269	5	3	65H
270	6	3	65H
271	1	3	100H
272	2	3	100H
273	3	3	100H
274	4	3	100H
275	5	3	100H
276	6	3	100H
277	1	3	110H
278	2	3	110H
279	3	3	110H
280	4	3	110H
281	5	3	110H
282	6	3	110H
283	1	3	300H
284	2	3	300H
285	3	3	300H
286	4	3	300H
287	5	3	300H
288	6	3	300H
289	1	3	LJ
290	2	3	LJ
291	3	3	LJ
292	4	3	LJ
293	5	3	LJ
294	6	3	LJ
295	1	3	TJ
296	2	3	TJ
297	3	3	TJ
298	4	3	TJ
299	5	3	TJ
300	6	3	TJ
301	1	3	DT
302	2	3	DT
303	3	3	DT
304	4	3	DT
305	5	3	DT
306	6	3	DT
307	1	3	SP
308	2	3	SP
309	3	3	SP
310	4	3	SP
311	5	3	SP
312	6	3	SP
313	1	3	HJ
314	2	3	HJ
315	3	3	HJ
316	4	3	HJ
317	5	3	HJ
318	6	3	HJ
319	1	3	PV
320	2	3	PV
321	3	3	PV
322	4	3	PV
323	5	3	PV
324	6	3	PV
325	1	4	100M
326	2	4	100M
327	3	4	100M
328	4	4	100M
329	5	4	100M
330	6	4	100M
331	1	4	200M
332	2	4	200M
333	3	4	200M
334	4	4	200M
335	5	4	200M
336	6	4	200M
337	1	4	400M
338	2	4	400M
339	3	4	400M
340	4	4	400M
341	5	4	400M
342	6	4	400M
343	1	4	800M
344	2	4	800M
345	3	4	800M
346	4	4	800M
347	5	4	800M
348	6	4	800M
349	1	4	1600M
350	2	4	1600M
351	3	4	1600M
352	4	4	1600M
353	5	4	1600M
354	6	4	1600M
355	1	4	3200M
356	2	4	3200M
357	3	4	3200M
358	4	4	3200M
359	5	4	3200M
360	6	4	3200M
361	1	4	4x100M
362	2	4	4x100M
363	3	4	4x100M
364	4	4	4x100M
365	5	4	4x100M
366	6	4	4x100M
367	1	4	4x400M
368	2	4	4x400M
369	3	4	4x400M
370	4	4	4x400M
371	5	4	4x400M
372	6	4	4x400M
373	1	4	65H
374	2	4	65H
375	3	4	65H
376	4	4	65H
377	5	4	65H
378	6	4	65H
379	1	4	100H
380	2	4	100H
381	3	4	100H
382	4	4	100H
383	5	4	100H
384	6	4	100H
385	1	4	110H
386	2	4	110H
387	3	4	110H
388	4	4	110H
389	5	4	110H
390	6	4	110H
391	1	4	300H
392	2	4	300H
393	3	4	300H
394	4	4	300H
395	5	4	300H
396	6	4	300H
397	1	4	LJ
398	2	4	LJ
399	3	4	LJ
400	4	4	LJ
401	5	4	LJ
402	6	4	LJ
403	1	4	TJ
404	2	4	TJ
405	3	4	TJ
406	4	4	TJ
407	5	4	TJ
408	6	4	TJ
409	1	4	DT
410	2	4	DT
411	3	4	DT
412	4	4	DT
413	5	4	DT
414	6	4	DT
415	1	4	SP
416	2	4	SP
417	3	4	SP
418	4	4	SP
419	5	4	SP
420	6	4	SP
421	1	4	HJ
422	2	4	HJ
423	3	4	HJ
424	4	4	HJ
425	5	4	HJ
426	6	4	HJ
427	1	4	PV
428	2	4	PV
429	3	4	PV
430	4	4	PV
431	5	4	PV
432	6	4	PV
433	1	5	100M
434	2	5	100M
435	3	5	100M
436	4	5	100M
437	5	5	100M
438	6	5	100M
439	1	5	200M
440	2	5	200M
441	3	5	200M
442	4	5	200M
443	5	5	200M
444	6	5	200M
445	1	5	400M
446	2	5	400M
447	3	5	400M
448	4	5	400M
449	5	5	400M
450	6	5	400M
451	1	5	800M
452	2	5	800M
453	3	5	800M
454	4	5	800M
455	5	5	800M
456	6	5	800M
457	1	5	1600M
458	2	5	1600M
459	3	5	1600M
460	4	5	1600M
461	5	5	1600M
462	6	5	1600M
463	1	5	3200M
464	2	5	3200M
465	3	5	3200M
466	4	5	3200M
467	5	5	3200M
468	6	5	3200M
469	1	5	4x100M
470	2	5	4x100M
471	3	5	4x100M
472	4	5	4x100M
473	5	5	4x100M
474	6	5	4x100M
475	1	5	4x400M
476	2	5	4x400M
477	3	5	4x400M
478	4	5	4x400M
479	5	5	4x400M
480	6	5	4x400M
481	1	5	65H
482	2	5	65H
483	3	5	65H
484	4	5	65H
485	5	5	65H
486	6	5	65H
487	1	5	100H
488	2	5	100H
489	3	5	100H
490	4	5	100H
491	5	5	100H
492	6	5	100H
493	1	5	110H
494	2	5	110H
495	3	5	110H
496	4	5	110H
497	5	5	110H
498	6	5	110H
499	1	5	300H
500	2	5	300H
501	3	5	300H
502	4	5	300H
503	5	5	300H
504	6	5	300H
505	1	5	LJ
506	2	5	LJ
507	3	5	LJ
508	4	5	LJ
509	5	5	LJ
510	6	5	LJ
511	1	5	TJ
512	2	5	TJ
513	3	5	TJ
514	4	5	TJ
515	5	5	TJ
516	6	5	TJ
517	1	5	DT
518	2	5	DT
519	3	5	DT
520	4	5	DT
521	5	5	DT
522	6	5	DT
523	1	5	SP
524	2	5	SP
525	3	5	SP
526	4	5	SP
527	5	5	SP
528	6	5	SP
529	1	5	HJ
530	2	5	HJ
531	3	5	HJ
532	4	5	HJ
533	5	5	HJ
534	6	5	HJ
535	1	5	PV
536	2	5	PV
537	3	5	PV
538	4	5	PV
539	5	5	PV
540	6	5	PV
541	1	6	100M
542	2	6	100M
543	3	6	100M
544	4	6	100M
545	5	6	100M
546	6	6	100M
547	1	6	200M
548	2	6	200M
549	3	6	200M
550	4	6	200M
551	5	6	200M
552	6	6	200M
553	1	6	400M
554	2	6	400M
555	3	6	400M
556	4	6	400M
557	5	6	400M
558	6	6	400M
559	1	6	800M
560	2	6	800M
561	3	6	800M
562	4	6	800M
563	5	6	800M
564	6	6	800M
565	1	6	1600M
566	2	6	1600M
567	3	6	1600M
568	4	6	1600M
569	5	6	1600M
570	6	6	1600M
571	1	6	3200M
572	2	6	3200M
573	3	6	3200M
574	4	6	3200M
575	5	6	3200M
576	6	6	3200M
577	1	6	4x100M
578	2	6	4x100M
579	3	6	4x100M
580	4	6	4x100M
581	5	6	4x100M
582	6	6	4x100M
583	1	6	4x400M
584	2	6	4x400M
585	3	6	4x400M
586	4	6	4x400M
587	5	6	4x400M
588	6	6	4x400M
589	1	6	65H
590	2	6	65H
591	3	6	65H
592	4	6	65H
593	5	6	65H
594	6	6	65H
595	1	6	100H
596	2	6	100H
597	3	6	100H
598	4	6	100H
599	5	6	100H
600	6	6	100H
601	1	6	110H
602	2	6	110H
603	3	6	110H
604	4	6	110H
605	5	6	110H
606	6	6	110H
607	1	6	300H
608	2	6	300H
609	3	6	300H
610	4	6	300H
611	5	6	300H
612	6	6	300H
613	1	6	LJ
614	2	6	LJ
615	3	6	LJ
616	4	6	LJ
617	5	6	LJ
618	6	6	LJ
619	1	6	TJ
620	2	6	TJ
621	3	6	TJ
622	4	6	TJ
623	5	6	TJ
624	6	6	TJ
625	1	6	DT
626	2	6	DT
627	3	6	DT
628	4	6	DT
629	5	6	DT
630	6	6	DT
631	1	6	SP
632	2	6	SP
633	3	6	SP
634	4	6	SP
635	5	6	SP
636	6	6	SP
637	1	6	HJ
638	2	6	HJ
639	3	6	HJ
640	4	6	HJ
641	5	6	HJ
642	6	6	HJ
643	1	6	PV
644	2	6	PV
645	3	6	PV
646	4	6	PV
647	5	6	PV
648	6	6	PV
649	1	7	100M
650	2	7	100M
651	3	7	100M
652	4	7	100M
653	5	7	100M
654	6	7	100M
655	1	7	200M
656	2	7	200M
657	3	7	200M
658	4	7	200M
659	5	7	200M
660	6	7	200M
661	1	7	400M
662	2	7	400M
663	3	7	400M
664	4	7	400M
665	5	7	400M
666	6	7	400M
667	1	7	800M
668	2	7	800M
669	3	7	800M
670	4	7	800M
671	5	7	800M
672	6	7	800M
673	1	7	1600M
674	2	7	1600M
675	3	7	1600M
676	4	7	1600M
677	5	7	1600M
678	6	7	1600M
679	1	7	3200M
680	2	7	3200M
681	3	7	3200M
682	4	7	3200M
683	5	7	3200M
684	6	7	3200M
685	1	7	4x100M
686	2	7	4x100M
687	3	7	4x100M
688	4	7	4x100M
689	5	7	4x100M
690	6	7	4x100M
691	1	7	4x400M
692	2	7	4x400M
693	3	7	4x400M
694	4	7	4x400M
695	5	7	4x400M
696	6	7	4x400M
697	1	7	65H
698	2	7	65H
699	3	7	65H
700	4	7	65H
701	5	7	65H
702	6	7	65H
703	1	7	100H
704	2	7	100H
705	3	7	100H
706	4	7	100H
707	5	7	100H
708	6	7	100H
709	1	7	110H
710	2	7	110H
711	3	7	110H
712	4	7	110H
713	5	7	110H
714	6	7	110H
715	1	7	300H
716	2	7	300H
717	3	7	300H
718	4	7	300H
719	5	7	300H
720	6	7	300H
721	1	7	LJ
722	2	7	LJ
723	3	7	LJ
724	4	7	LJ
725	5	7	LJ
726	6	7	LJ
727	1	7	TJ
728	2	7	TJ
729	3	7	TJ
730	4	7	TJ
731	5	7	TJ
732	6	7	TJ
733	1	7	DT
734	2	7	DT
735	3	7	DT
736	4	7	DT
737	5	7	DT
738	6	7	DT
739	1	7	SP
740	2	7	SP
741	3	7	SP
742	4	7	SP
743	5	7	SP
744	6	7	SP
745	1	7	HJ
746	2	7	HJ
747	3	7	HJ
748	4	7	HJ
749	5	7	HJ
750	6	7	HJ
751	1	7	PV
752	2	7	PV
753	3	7	PV
754	4	7	PV
755	5	7	PV
756	6	7	PV
757	1	8	100M
758	2	8	100M
759	3	8	100M
760	4	8	100M
761	5	8	100M
762	6	8	100M
763	1	8	200M
764	2	8	200M
765	3	8	200M
766	4	8	200M
767	5	8	200M
768	6	8	200M
769	1	8	400M
770	2	8	400M
771	3	8	400M
772	4	8	400M
773	5	8	400M
774	6	8	400M
775	1	8	800M
776	2	8	800M
777	3	8	800M
778	4	8	800M
779	5	8	800M
780	6	8	800M
781	1	8	1600M
782	2	8	1600M
783	3	8	1600M
784	4	8	1600M
785	5	8	1600M
786	6	8	1600M
787	1	8	3200M
788	2	8	3200M
789	3	8	3200M
790	4	8	3200M
791	5	8	3200M
792	6	8	3200M
793	1	8	4x100M
794	2	8	4x100M
795	3	8	4x100M
796	4	8	4x100M
797	5	8	4x100M
798	6	8	4x100M
799	1	8	4x400M
800	2	8	4x400M
801	3	8	4x400M
802	4	8	4x400M
803	5	8	4x400M
804	6	8	4x400M
805	1	8	65H
806	2	8	65H
807	3	8	65H
808	4	8	65H
809	5	8	65H
810	6	8	65H
811	1	8	100H
812	2	8	100H
813	3	8	100H
814	4	8	100H
815	5	8	100H
816	6	8	100H
817	1	8	110H
818	2	8	110H
819	3	8	110H
820	4	8	110H
821	5	8	110H
822	6	8	110H
823	1	8	300H
824	2	8	300H
825	3	8	300H
826	4	8	300H
827	5	8	300H
828	6	8	300H
829	1	8	LJ
830	2	8	LJ
831	3	8	LJ
832	4	8	LJ
833	5	8	LJ
834	6	8	LJ
835	1	8	TJ
836	2	8	TJ
837	3	8	TJ
838	4	8	TJ
839	5	8	TJ
840	6	8	TJ
841	1	8	DT
842	2	8	DT
843	3	8	DT
844	4	8	DT
845	5	8	DT
846	6	8	DT
847	1	8	SP
848	2	8	SP
849	3	8	SP
850	4	8	SP
851	5	8	SP
852	6	8	SP
853	1	8	HJ
854	2	8	HJ
855	3	8	HJ
856	4	8	HJ
857	5	8	HJ
858	6	8	HJ
859	1	8	PV
860	2	8	PV
861	3	8	PV
862	4	8	PV
863	5	8	PV
864	6	8	PV
865	1	9	100M
866	2	9	100M
867	3	9	100M
868	4	9	100M
869	5	9	100M
870	6	9	100M
871	1	9	200M
872	2	9	200M
873	3	9	200M
874	4	9	200M
875	5	9	200M
876	6	9	200M
877	1	9	400M
878	2	9	400M
879	3	9	400M
880	4	9	400M
881	5	9	400M
882	6	9	400M
883	1	9	800M
884	2	9	800M
885	3	9	800M
886	4	9	800M
887	5	9	800M
888	6	9	800M
889	1	9	1600M
890	2	9	1600M
891	3	9	1600M
892	4	9	1600M
893	5	9	1600M
894	6	9	1600M
895	1	9	3200M
896	2	9	3200M
897	3	9	3200M
898	4	9	3200M
899	5	9	3200M
900	6	9	3200M
901	1	9	4x100M
902	2	9	4x100M
903	3	9	4x100M
904	4	9	4x100M
905	5	9	4x100M
906	6	9	4x100M
907	1	9	4x400M
908	2	9	4x400M
909	3	9	4x400M
910	4	9	4x400M
911	5	9	4x400M
912	6	9	4x400M
913	1	9	65H
914	2	9	65H
915	3	9	65H
916	4	9	65H
917	5	9	65H
918	6	9	65H
919	1	9	100H
920	2	9	100H
921	3	9	100H
922	4	9	100H
923	5	9	100H
924	6	9	100H
925	1	9	110H
926	2	9	110H
927	3	9	110H
928	4	9	110H
929	5	9	110H
930	6	9	110H
931	1	9	300H
932	2	9	300H
933	3	9	300H
934	4	9	300H
935	5	9	300H
936	6	9	300H
937	1	9	LJ
938	2	9	LJ
939	3	9	LJ
940	4	9	LJ
941	5	9	LJ
942	6	9	LJ
943	1	9	TJ
944	2	9	TJ
945	3	9	TJ
946	4	9	TJ
947	5	9	TJ
948	6	9	TJ
949	1	9	DT
950	2	9	DT
951	3	9	DT
952	4	9	DT
953	5	9	DT
954	6	9	DT
955	1	9	SP
956	2	9	SP
957	3	9	SP
958	4	9	SP
959	5	9	SP
960	6	9	SP
961	1	9	HJ
962	2	9	HJ
963	3	9	HJ
964	4	9	HJ
965	5	9	HJ
966	6	9	HJ
967	1	9	PV
968	2	9	PV
969	3	9	PV
970	4	9	PV
971	5	9	PV
972	6	9	PV
973	1	10	100M
974	2	10	100M
975	3	10	100M
976	4	10	100M
977	5	10	100M
978	6	10	100M
979	1	10	200M
980	2	10	200M
981	3	10	200M
982	4	10	200M
983	5	10	200M
984	6	10	200M
985	1	10	400M
986	2	10	400M
987	3	10	400M
988	4	10	400M
989	5	10	400M
990	6	10	400M
991	1	10	800M
992	2	10	800M
993	3	10	800M
994	4	10	800M
995	5	10	800M
996	6	10	800M
997	1	10	1600M
998	2	10	1600M
999	3	10	1600M
1000	4	10	1600M
1001	5	10	1600M
1002	6	10	1600M
1003	1	10	3200M
1004	2	10	3200M
1005	3	10	3200M
1006	4	10	3200M
1007	5	10	3200M
1008	6	10	3200M
1009	1	10	4x100M
1010	2	10	4x100M
1011	3	10	4x100M
1012	4	10	4x100M
1013	5	10	4x100M
1014	6	10	4x100M
1015	1	10	4x400M
1016	2	10	4x400M
1017	3	10	4x400M
1018	4	10	4x400M
1019	5	10	4x400M
1020	6	10	4x400M
1021	1	10	65H
1022	2	10	65H
1023	3	10	65H
1024	4	10	65H
1025	5	10	65H
1026	6	10	65H
1027	1	10	100H
1028	2	10	100H
1029	3	10	100H
1030	4	10	100H
1031	5	10	100H
1032	6	10	100H
1033	1	10	110H
1034	2	10	110H
1035	3	10	110H
1036	4	10	110H
1037	5	10	110H
1038	6	10	110H
1039	1	10	300H
1040	2	10	300H
1041	3	10	300H
1042	4	10	300H
1043	5	10	300H
1044	6	10	300H
1045	1	10	LJ
1046	2	10	LJ
1047	3	10	LJ
1048	4	10	LJ
1049	5	10	LJ
1050	6	10	LJ
1051	1	10	TJ
1052	2	10	TJ
1053	3	10	TJ
1054	4	10	TJ
1055	5	10	TJ
1056	6	10	TJ
1057	1	10	DT
1058	2	10	DT
1059	3	10	DT
1060	4	10	DT
1061	5	10	DT
1062	6	10	DT
1063	1	10	SP
1064	2	10	SP
1065	3	10	SP
1066	4	10	SP
1067	5	10	SP
1068	6	10	SP
1069	1	10	HJ
1070	2	10	HJ
1071	3	10	HJ
1072	4	10	HJ
1073	5	10	HJ
1074	6	10	HJ
1075	1	10	PV
1076	2	10	PV
1077	3	10	PV
1078	4	10	PV
1079	5	10	PV
1080	6	10	PV
1081	1	11	100M
1082	2	11	100M
1083	3	11	100M
1084	4	11	100M
1085	5	11	100M
1086	6	11	100M
1087	1	11	200M
1088	2	11	200M
1089	3	11	200M
1090	4	11	200M
1091	5	11	200M
1092	6	11	200M
1093	1	11	400M
1094	2	11	400M
1095	3	11	400M
1096	4	11	400M
1097	5	11	400M
1098	6	11	400M
1099	1	11	800M
1100	2	11	800M
1101	3	11	800M
1102	4	11	800M
1103	5	11	800M
1104	6	11	800M
1105	1	11	1600M
1106	2	11	1600M
1107	3	11	1600M
1108	4	11	1600M
1109	5	11	1600M
1110	6	11	1600M
1111	1	11	3200M
1112	2	11	3200M
1113	3	11	3200M
1114	4	11	3200M
1115	5	11	3200M
1116	6	11	3200M
1117	1	11	4x100M
1118	2	11	4x100M
1119	3	11	4x100M
1120	4	11	4x100M
1121	5	11	4x100M
1122	6	11	4x100M
1123	1	11	4x400M
1124	2	11	4x400M
1125	3	11	4x400M
1126	4	11	4x400M
1127	5	11	4x400M
1128	6	11	4x400M
1129	1	11	65H
1130	2	11	65H
1131	3	11	65H
1132	4	11	65H
1133	5	11	65H
1134	6	11	65H
1135	1	11	100H
1136	2	11	100H
1137	3	11	100H
1138	4	11	100H
1139	5	11	100H
1140	6	11	100H
1141	1	11	110H
1142	2	11	110H
1143	3	11	110H
1144	4	11	110H
1145	5	11	110H
1146	6	11	110H
1147	1	11	300H
1148	2	11	300H
1149	3	11	300H
1150	4	11	300H
1151	5	11	300H
1152	6	11	300H
1153	1	11	LJ
1154	2	11	LJ
1155	3	11	LJ
1156	4	11	LJ
1157	5	11	LJ
1158	6	11	LJ
1159	1	11	TJ
1160	2	11	TJ
1161	3	11	TJ
1162	4	11	TJ
1163	5	11	TJ
1164	6	11	TJ
1165	1	11	DT
1166	2	11	DT
1167	3	11	DT
1168	4	11	DT
1169	5	11	DT
1170	6	11	DT
1171	1	11	SP
1172	2	11	SP
1173	3	11	SP
1174	4	11	SP
1175	5	11	SP
1176	6	11	SP
1177	1	11	HJ
1178	2	11	HJ
1179	3	11	HJ
1180	4	11	HJ
1181	5	11	HJ
1182	6	11	HJ
1183	1	11	PV
1184	2	11	PV
1185	3	11	PV
1186	4	11	PV
1187	5	11	PV
1188	6	11	PV
\.


--
-- Name: meet_division_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.meet_division_events_id_seq', 1188, true);


--
-- Data for Name: meets; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.meets (id, name, date, host_school_id, description, status, max_entries_per_athlete, max_team_entries_per_event) FROM stdin;
1	PCAL: San Benito (Hollister) vs. Everett Alvarez	2019-03-08 00:00:00	2	 San Benito at Everett Alvarez. Meet starts at 3pm.\n        Entries must be submitted by noon the day before.\n                       	Accepting Entries	\N	\N
2	PCAL: League Practice Meet #1	2019-03-10 00:00:00	5	 Meet starts at 3pm, at Los Gatos High School.\n            	Accepting Entries	\N	\N
3	PCAL League Practice Meet #2	2019-03-22 00:00:00	8	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
4	PCAL League Practice Meet #3	2019-03-22 00:00:00	9	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
5	PCAL League Practice Meet #4	2019-03-29 00:00:00	14	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
6	PCAL League Practice Meet #5	2019-04-05 00:00:00	25	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
7	PCAL League Practice Meet #6	2019-04-12 00:00:00	8	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
8	PCAL League Practice Meet #7	2019-04-17 00:00:00	5	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
9	PCAL League Practice Meet #8	2019-04-24 00:00:00	9	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
10	PCAL League Practice Meet #9	2019-05-01 00:00:00	14	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
11	PCAL League Championships	2019-05-08 00:00:00	\N	 Meet starts at 3pm.\n            	Accepting Entries	\N	\N
\.


--
-- Name: meets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.meets_id_seq', 11, true);


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.schools (id, abbrev, name, league, section, city, state) FROM stdin;
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
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.schools_id_seq', 32, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.users (id, email, password, school_id, role) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: athletes_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_pkey PRIMARY KEY (id);


--
-- Name: divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: event_defs_name_key; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.event_defs
    ADD CONSTRAINT event_defs_name_key UNIQUE (name);


--
-- Name: event_defs_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.event_defs
    ADD CONSTRAINT event_defs_pkey PRIMARY KEY (code);


--
-- Name: meet_division_events_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_pkey PRIMARY KEY (id);


--
-- Name: meets_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meets
    ADD CONSTRAINT meets_pkey PRIMARY KEY (id);


--
-- Name: schools_abbrev_key; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_abbrev_key UNIQUE (abbrev);


--
-- Name: schools_name_key; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_name_key UNIQUE (name);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: athletes_div_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_div_id_fkey FOREIGN KEY (div_id) REFERENCES public.divisions(id);


--
-- Name: athletes_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athletes_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id);


--
-- Name: entries_athlete_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_athlete_id_fkey FOREIGN KEY (athlete_id) REFERENCES public.athletes(id);


--
-- Name: entries_mde_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_mde_id_fkey FOREIGN KEY (mde_id) REFERENCES public.meet_division_events(id);


--
-- Name: meet_division_events_div_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_div_id_fkey FOREIGN KEY (div_id) REFERENCES public.divisions(id);


--
-- Name: meet_division_events_event_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_event_code_fkey FOREIGN KEY (event_code) REFERENCES public.event_defs(code);


--
-- Name: meet_division_events_meet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meet_division_events
    ADD CONSTRAINT meet_division_events_meet_id_fkey FOREIGN KEY (meet_id) REFERENCES public.meets(id);


--
-- Name: meets_host_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.meets
    ADD CONSTRAINT meets_host_school_id_fkey FOREIGN KEY (host_school_id) REFERENCES public.schools(id);


--
-- Name: users_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

