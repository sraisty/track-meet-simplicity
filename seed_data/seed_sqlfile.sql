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
1	Alex	Avila		\N	2	1
2	Cesar	Avila		\N	2	2
3	Jacob	Avila		\N	2	3
4	Addam	Banuelos		\N	2	3
5	Arely	Campos		\N	2	5
6	Ella	De Amaral		\N	2	6
7	Angel	Garcia		\N	2	3
8	Martin	Guzman		\N	2	3
9	Gianna	Herbert		\N	2	4
10	Peyton	Masuen		\N	2	5
11	Daniel	Melendez		\N	2	2
12	Luis	Morales		\N	2	3
13	Jasmine	Rios		\N	2	5
14	Ethan	Woehrmann		\N	2	3
15	Travis	Wronksi		\N	2	3
16	Diego	Almaraz		\N	3	3
17	Ellie	Alto		\N	3	6
18	Sienna	Anderson		\N	3	4
19	Skye	Arle		\N	3	3
20	Sam	Boone		\N	3	3
21	Gabrielle	Borges		\N	3	4
22	Robert	Brown		\N	3	2
23	Savannah	Chappell		\N	3	4
24	Maxim	Clark		\N	3	3
25	Noah	Conklin		\N	3	1
26	Luke	Danzer		\N	3	2
27	Zach	DeZee		\N	3	2
28	Jessica	Dilullo		\N	3	6
29	Kiana	Dorantes		\N	3	4
30	Maggie	Ellison		\N	3	5
31	Peter	Ellison		\N	3	2
32	Svenn	Eyjolfsson		\N	3	1
33	Jamison	Farrington		\N	3	1
34	Alex	Faxon		\N	3	1
35	Tommaso	Feo		\N	3	3
36	Michelle	Foley		\N	3	4
37	Amaya	Gomez		\N	3	4
38	Jonathan	Hamilton		\N	3	2
39	Connor	Hatch		\N	3	3
40	Hunter	Heger		\N	3	1
41	Sebastian	Hendricks		\N	3	1
42	Gillian	Horak		\N	3	4
43	Connor	Houlihan		\N	3	2
44	Jessica	Hwang		\N	3	6
45	Tara	Jones		\N	3	6
46	Zachary	Keaton		\N	3	1
47	Noah	Kirsch		\N	3	3
48	Annalise	Krueger		\N	3	5
49	Nick	Krueger		\N	3	3
50	Ashley	Langley		\N	3	5
51	Soana	Laulotu		\N	3	5
52	Emily	Lazarus		\N	3	5
53	LiMei	Louis		\N	3	4
54	Andy	Ma		\N	3	3
55	Angel	Madrigal		\N	3	2
56	Orlandis	Mathes		\N	3	1
57	Natalie	Mazaud		\N	3	4
58	Scott	McMahon		\N	3	3
59	Michael	Meheen		\N	3	1
60	Muni	Mohamed		\N	3	1
61	Pascale	Montgomery		\N	3	4
62	Sarah	Morgan		\N	3	5
63	Robert	Mowry		\N	3	2
64	Nathan	Oros		\N	3	2
65	Cody	O'Rourke		\N	3	3
66	Miles	Prekoski		\N	3	1
67	Dalton	Quilty		\N	3	3
68	Adam	Ramlawi		\N	3	1
69	Vincent	Ravalin		\N	3	3
70	Julian	Resendiz		\N	3	3
71	Carlos	Robles		\N	3	3
72	Zach	Rossi		\N	3	3
73	Nathan	Schneiderman		\N	3	1
74	Katie	Short		\N	3	4
75	Nathan	Suess		\N	3	3
76	Elijah	Thompson		\N	3	3
77	Tio	Turrini-Smith		\N	3	3
78	Melanie	Verga		\N	3	5
79	Madison	Vernon		\N	3	4
80	Rashaan	Ward		\N	3	2
81	Rohan	Warner		\N	3	3
82	West	Whittaker		\N	3	3
83	Gracie	Antrim-Kerr		\N	4	6
84	Uirassu	de Almeida		\N	4	3
85	Connor	Hetzler		\N	4	3
86	Keinan	Mactins		\N	4	2
87	Chloe	Ortiz		\N	4	6
88	Jasmin	schulz		\N	4	4
89	Elijah	Stone		\N	4	2
90	Alexis	Aceves		\N	5	2
91	Melissa	Aceves		\N	5	6
92	Damian	Acosta		\N	5	3
93	Anissa	Aguilar		\N	5	4
94	Jesus	Alcantar		\N	5	3
95	Mireya	Alvarez		\N	5	4
96	Jacob	Amador		\N	5	2
97	Angel	Anguiano		\N	5	3
98	Miguel	Arreola		\N	5	2
99	Edgar	Arriola		\N	5	3
100	Jack	Banuelos		\N	5	2
101	Angel	Bautista		\N	5	1
102	Damian	Castaneda		\N	5	2
103	Ivan	Correa		\N	5	2
104	Matthew	Cortez		\N	5	2
105	Stephanie	Delgado		\N	5	6
106	Ismael	Duarte		\N	5	3
107	Cecilia	Espinoza		\N	5	5
108	Ulysses	Fierros		\N	5	3
109	Alex	Flores		\N	5	5
110	Nick	Flores		\N	5	3
111	Andrew	Funk		\N	5	1
112	Scott	Funk		\N	5	2
113	Miguel	Garcia		\N	5	3
114	Rodrigo	Garcia		\N	5	3
115	Anthony	Gonzalez		\N	5	1
116	Greg	Gudino		\N	5	2
117	Juan	Hernandez		\N	5	2
118	Leslie	Hernandez		\N	5	4
119	Octavio	Hernandez		\N	5	2
120	Kathleen	Humphries		\N	5	6
121	Danielle	Javier		\N	5	4
122	Xavier	Jimenez		\N	5	1
123	Helga	Klemezdottir		\N	5	6
124	Athena	Landeros		\N	5	5
125	Maria	Lopez		\N	5	4
126	Ray	Lopez		\N	5	3
127	Iris	Manriquez		\N	5	6
128	Jorge	Manriquez		\N	5	3
129	Sarah	Marmolejo		\N	5	5
130	Alyssa	Martinez		\N	5	6
131	Mario	Martinez		\N	5	3
132	Jairo	Medina		\N	5	3
133	Faustino	Mendez		\N	5	3
134	Martin	Mendez		\N	5	2
135	Isabel	Mendoza		\N	5	4
136	Pablo	Mendoza		\N	5	2
137	Hernan	Mojica		\N	5	3
138	Christian	Patino		\N	5	2
139	Andy	Perez		\N	5	3
140	Jaime	Perez		\N	5	3
141	Nathan	Perez		\N	5	1
142	Jackie	Ramirez		\N	5	5
143	Jorge	Ramirez		\N	5	2
144	Genaro	Renteria		\N	5	3
145	Patricia	Resendiz		\N	5	6
146	Elias	Rico		\N	5	3
147	Gil	Rodriguez		\N	5	3
148	Julian	Rodriguez		\N	5	1
149	Marilyn	Rodriguez		\N	5	6
150	Veronica	Rodriguez		\N	5	4
151	Felix	Romero		\N	5	3
152	Jerome	Russell		\N	5	1
153	Luis	Sainz		\N	5	2
154	Bianca	Sanchez		\N	5	6
155	Jose	Sanchez		\N	5	3
156	Madisyn	Schweitzer		\N	5	4
157	Jesus	Trujillo		\N	5	2
158	Jazmin	Useda		\N	5	4
159	Jade	Valdez		\N	5	4
160	Jose	Valdez		\N	5	3
161	Jossue	Valdez		\N	5	3
162	Nael	Vazquez		\N	5	2
163	Pablo	Villasenor		\N	5	2
164	Jasmin	Yadao		\N	5	6
165	Celeste	Castro		\N	6	6
166	Daniel	Cerna		\N	6	2
167	Marina Jane	Cerna		\N	6	4
168	Andrew	Dang		\N	6	1
169	Alejandro	De Jesus		\N	6	3
170	Abraham	Dominquez Perez		\N	6	2
171	Daniel	Dominquez Perez		\N	6	1
172	Gladis	Garcia		\N	6	4
173	Rodrigo	Garcia		\N	6	2
174	Daniel	Gonzales		\N	6	1
175	Martin	Hernandez Ramos		\N	6	1
176	Isaac	Lopez		\N	6	1
177	Maria	Malagon		\N	6	6
178	Kristian	Maldonado		\N	6	3
179	Adrian	Martinez		\N	6	1
180	Ericka	Martinez		\N	6	5
181	Kenny	Martinez		\N	6	2
182	Sebastian	Meza		\N	6	1
183	Jesus	Ortega		\N	6	2
184	Luis	Perez		\N	6	3
185	Hector	Ramirez		\N	6	3
186	Alexis	Sanchez		\N	6	2
187	Francisco	Sanchez		\N	6	1
188	Jonathon	Villegas		\N	6	3
189	Noemi	Amezcua		\N	7	6
190	Nancy	Andrade		\N	7	5
191	Rodrigo	Andrade		\N	7	2
192	Gisela	Aparicio		\N	7	6
193	Jesus	Avalos		\N	7	3
194	Jhames	Bautista		\N	7	2
195	Daniela	Bedolla		\N	7	5
196	Joe	Black		\N	7	3
197	Emmitt	Blacks		\N	7	3
198	Luis	Briseño		\N	7	2
199	Elizabeth	Bryant		\N	7	6
200	Isidro	Cabrera		\N	7	3
201	Delaney	Carroll		\N	7	5
202	Elizabeth	Cazares		\N	7	6
203	Daisy	Chavez		\N	7	5
204	Emily	Chavez		\N	7	6
205	Xabier	Espinoza		\N	7	2
206	Cassidy	Flores		\N	7	6
207	Federico	Flores		\N	7	2
208	Freddy	Garcia		\N	7	3
209	Esteban	Gonzales		\N	7	3
210	Isaias	Gonzales		\N	7	2
211	Israel	Gutierrez		\N	7	3
212	Michael	Hart		\N	7	3
213	Isaac	Huerta		\N	7	2
214	Luis	Luna		\N	7	3
215	Justin	Mantel		\N	7	3
216	Miguel	Martinez		\N	7	3
217	Fausto	Medina		\N	7	1
218	Jalen	Mendez		\N	7	4
219	Roman	Munoz		\N	7	3
220	Cali	Murillo		\N	7	6
221	Kyle	Near		\N	7	3
222	Dylan	Oliveros		\N	7	2
223	Christian	Olmos		\N	7	3
224	Milagros	Ortega		\N	7	6
225	Kevin	Pena		\N	7	3
226	Stephanie	Politron		\N	7	6
227	Bella	Rava		\N	7	5
228	Jackie	Rios		\N	7	6
229	Lauren	Rist		\N	7	6
230	Ismael	Rocha		\N	7	3
231	Kajar	Rodgers		\N	7	4
232	Edith	Rojas		\N	7	6
233	Christian	Rose		\N	7	3
234	Ricardo	Ruelas		\N	7	3
235	Cody	Scrivner		\N	7	3
236	Grace	Shepherd		\N	7	5
237	Drury	Tankersley		\N	7	3
238	Jose V.	Torres		\N	7	3
239	Jackelyn	Zavala		\N	7	6
240	Rosa Elena	Acevedo		\N	8	6
241	Ali	Alkhawldy		\N	8	2
242	Bryan	Arredondo		\N	8	2
243	Leanne	Bagood		\N	8	5
244	Smilepreet	Bal		\N	8	6
245	Sukhneet	Bal		\N	8	3
246	David	Brooks		\N	8	3
247	Christian	Derbonne-Sipal		\N	8	3
248	Michael	Dronet		\N	8	3
249	Andrea	Escobedo		\N	8	4
250	Fermin	Gabot		\N	8	3
251	Michael	Garcia-Reyes		\N	8	2
252	Isaias	Guizar		\N	8	2
253	Karla	Herrera		\N	8	4
254	Leo	Isidro		\N	8	1
255	Jefferson	Lagudas		\N	8	3
256	Will	Leander		\N	8	3
257	Olivia	Lehman		\N	8	5
258	Daniel	Lucas		\N	8	3
259	Christopher	Plascencia		\N	8	2
260	Sierra	Ravinski		\N	8	5
261	Jackie	Reyes		\N	8	5
262	Bruno	Salcido		\N	8	3
263	Amadeus	Soria		\N	8	2
264	Robert	Valencia		\N	8	3
265	Alberto (A.J.)	Gastelum		\N	9	1
266	Jeb	Goldman		\N	9	2
267	Nicholas	Kawwas		\N	9	2
268	Adam	Kim		\N	9	2
269	Jack (Yize)	Ma		\N	9	1
270	Maryam	Moghaddami		\N	9	5
271	Jashan	Pabla		\N	9	1
272	Gabe	Piper		\N	9	3
273	Hannah	Selby		\N	9	5
274	Nathan	Walker		\N	9	3
275	Eric	Aldrich		\N	10	1
276	Kevin	Antonino		\N	10	3
277	Elizabeth	Armstrong		\N	10	4
278	Chloe	Chipman		\N	10	4
279	Conor	Driscoll-Natale		\N	10	1
280	Liam	Failor-Wass		\N	10	2
281	Corey	Friedenbach		\N	10	6
282	Kathryn	Haney		\N	10	5
283	Jack	Isacson		\N	10	1
284	Cameron	Kies		\N	10	2
285	Roxana	Ortiz		\N	10	5
286	Tristan	Peterson		\N	10	3
287	Erika	Pistor		\N	10	6
288	Catharina	Rogaczewski		\N	10	5
289	Rina	Rossi		\N	10	4
290	Milo	Rudman		\N	10	2
291	Anna	Spangrud		\N	10	5
292	Alex	Stout		\N	10	6
293	Sachiko	Tate		\N	10	6
294	Miles	Voenell		\N	10	1
295	Max	Afifi		\N	11	2
296	Tiago	Agostini		\N	11	1
297	Jake	Alt		\N	11	2
298	Hannah	Bennett		\N	11	4
299	Noor	Benny		\N	11	4
300	Taylor	Biondi		\N	11	5
301	Ray	Birkett		\N	11	1
302	Nick	Coppla		\N	11	3
303	Andrew	Crannell		\N	11	1
304	Batuhan	Demir		\N	11	2
305	Zach	Goodwin		\N	11	3
306	Mary	Grebing		\N	11	6
307	Paul	Gurries		\N	11	3
308	Julius	Gutierrez		\N	11	1
309	Delson	Hays		\N	11	1
310	Rachel	House		\N	11	6
311	Gavin	James		\N	11	3
312	Thomas	Jameson		\N	11	1
313	Deaven	Keller		\N	11	3
314	Leo	Lauritzen		\N	11	1
315	Luca	Lauritzen		\N	11	3
316	Christine	Lee		\N	11	5
317	Henry	Loh		\N	11	3
318	India	Maaske		\N	11	6
319	Callie	McGraw		\N	11	5
320	Bryce	Montgomery		\N	11	1
321	Taylor	Rainey		\N	11	5
322	Cameron	Reeves		\N	11	3
323	Robertson	Rice		\N	11	1
324	Bella	Rohrer		\N	11	4
325	Rachel	Sands		\N	11	5
326	Tyler	Smithro		\N	11	1
327	Parker	Staples		\N	11	6
328	Anna	Stefanou		\N	11	6
329	Will	Stefanou		\N	11	1
330	Nami	Suzuki		\N	11	6
331	Kulaea	Tulua		\N	11	6
332	Jada	Ware		\N	11	6
333	Jacob	Wren		\N	11	3
334	Jacob	Zeidberg		\N	11	2
335	Rosa	Aguilar		\N	12	6
336	Barbara	Avalos		\N	12	6
337	Carolina	Bishop		\N	12	6
338	Avery	Blanco		\N	12	6
339	Yvett	Cardenas		\N	12	5
340	Lauren	Dean		\N	12	4
341	Caitlyn	Giannini		\N	12	5
342	Kacey	Konya		\N	12	5
343	Ana	Leon		\N	12	6
344	Annie	Luo		\N	12	5
345	Ana Sofia	Magana		\N	12	6
346	Daniela	Mastretta		\N	12	6
347	Orlinka	Mitoko-Kereere		\N	12	6
348	Maya	Pruthi		\N	12	5
349	Mikayla	Revera		\N	12	6
350	Emma	Roffler		\N	12	6
351	Laurel	Wong		\N	12	5
352	Luis	Alba		\N	13	1
353	Lyla	Alderete		\N	13	6
354	Preciosa	Almaraz		\N	13	5
355	Marlene	Alonza		\N	13	6
356	Axel	Amaro		\N	13	1
357	Edward	Bachtel		\N	13	2
358	Alyssa	Borbon		\N	13	4
359	Jacob	Burgoz		\N	13	1
360	Ulises	Camarena		\N	13	3
361	Destiny	Carrillo		\N	13	5
362	Tamara	Castillo		\N	13	4
363	Christian	Chan		\N	13	3
364	Theresa	Chavez		\N	13	4
365	Daniel	Contawe		\N	13	3
366	Anselmo	De Jesus		\N	13	3
367	Gyrallene	Degarcia		\N	13	4
368	Belen	Flores		\N	13	5
369	Josiah	Freeman		\N	13	1
370	Gabriella	Gasca		\N	13	6
371	Aliyah	Gonzalez		\N	13	6
372	Christopher	Gonzalez		\N	13	2
373	Miguel	Gonzalez		\N	13	3
374	Ramona	Granillo		\N	13	4
375	Julian	Hernandez		\N	13	3
376	Jessica	Herrera		\N	13	5
377	Christopher	Huerta		\N	13	2
378	Leslie	Jimenez		\N	13	4
379	Neidi	Jorge		\N	13	5
380	Danyelle	Landeros		\N	13	4
381	Andrea	Martinez		\N	13	5
382	Estefani	Martinez		\N	13	5
383	Talia	Medina		\N	13	5
384	Elise	Melchor		\N	13	5
385	Adrian	Mellin		\N	13	1
386	Salvador	Meza		\N	13	2
387	Estefania	Montel		\N	13	4
388	Jonathan	Morales		\N	13	1
389	Marcus	Morales		\N	13	1
390	Crystal	Moreno		\N	13	4
391	Angel	Olivas		\N	13	2
392	Lauryn	Orozco		\N	13	6
393	Emanual	Ortega		\N	13	3
394	Andrew	Palmerin		\N	13	2
395	Miguel	Paredes		\N	13	1
396	Odalys	Paredes		\N	13	6
397	Victor	Phillips		\N	13	1
398	Arilene	Rios		\N	13	6
399	Vivianna	Robledo		\N	13	4
400	Jesus	Rodriguez		\N	13	2
401	Iris	Ruis		\N	13	5
402	Francisco	Sanchez		\N	13	1
403	Juan	Sanchez		\N	13	2
404	Iziah	Stone		\N	13	2
405	Isabel	Suarez		\N	13	5
406	Emily	Tinajero		\N	13	5
407	Raul	Trujillo		\N	13	3
408	Jose	Velasco		\N	13	1
409	Jose	Villalobos		\N	13	3
410	Krystal	Villegas		\N	13	4
411	Daisy	Virgen		\N	13	5
412	Denise	Virgen		\N	13	5
413	Treyon	Walker		\N	13	3
414	Emily	Adomako		\N	14	4
415	Lillian	Agar		\N	14	5
416	Cyrus	Barringer		\N	14	3
417	Gabrielle	Butler		\N	14	5
418	Ray	Cai		\N	14	3
419	Harry	Cheung		\N	14	3
420	Clarence	Chou		\N	14	1
421	Kieren	Daste		\N	14	1
422	Guido	Davi		\N	14	1
423	Eliza	Foster		\N	14	6
424	Grace	Ingram		\N	14	4
425	Alexander	Jensen		\N	14	3
426	Hale	Jones		\N	14	3
427	Philo	Katzman		\N	14	2
428	Fauve	Koontz		\N	14	6
429	Cade	Laranang		\N	14	3
430	Nathan	Ma		\N	14	3
431	Colin	McEachen		\N	14	2
432	Alexander	Meredith		\N	14	3
433	Nicole	Naquin		\N	14	6
434	Helen	Nickerson		\N	14	6
435	Emilio	Orozco		\N	14	3
436	Tom	Phan		\N	14	3
437	Faith	Pinnow		\N	14	4
438	Annika	Roberts		\N	14	6
439	Erika	Roberts		\N	14	4
440	Charles	Shim		\N	14	3
441	Csilla	Smith		\N	14	6
442	Peter	Song		\N	14	3
443	Quynh	Stanoff		\N	14	6
444	Madison	Strickling		\N	14	6
445	Flora	Tamm		\N	14	5
446	Lucas	Tilly		\N	14	3
447	Jacob	Wang		\N	14	3
448	Lola	Wilcox		\N	14	4
449	Tony	Zhou		\N	14	3
450	Kaden	Agha		\N	15	3
451	Max	Burke		\N	15	2
452	Tristen	Laney		\N	15	2
453	Evan	Li		\N	15	3
454	Joseph	Rhee		\N	15	3
455	Adam	Shapiro		\N	15	2
456	Washakie	Tibbetts		\N	15	3
457	Jonathan	Zhao		\N	15	1
458	Destiny	Hansen		\N	2	6
459	Jasmin	Schulz		\N	4	4
460	Leo	Ruiz		\N	5	3
461	Angel	Vasquez		\N	5	3
462	Rodrigo	Frias		\N	6	3
463	Luis	Meza		\N	6	3
464	Edward	Villagomez		\N	6	2
465	Gage	Barmes		\N	7	1
466	David	Black		\N	7	1
467	Cesar	Chavez		\N	7	1
468	Dominic	Conricode		\N	7	1
469	Felipe	Cruz		\N	7	1
470	Ricardo	Diaz		\N	7	1
471	Ashton	Headley		\N	7	1
472	Kyras	Headley		\N	7	1
473	Bryce	McEwen		\N	7	1
474	Luis	Morales		\N	7	1
475	Angelyna	Ragsdale		\N	7	5
476	Robert	Reyes		\N	7	3
477	Allen	Rocha		\N	7	1
478	Carson	Roylance		\N	7	2
479	Xavier	Salone		\N	7	1
480	Jose	Santos		\N	7	1
481	Miguel	Zendejas		\N	7	2
482	Hannia	Zuniga		\N	7	5
483	Andrew	Perez		\N	8	3
484	Ashley	Bruning		\N	9	4
485	Taegan	Dunton		\N	10	1
486	Lauren	Hubbell		\N	10	5
487	Sahil	Patel		\N	10	1
488	Eric	Arias		\N	11	1
489	Thuy	Burshtein		\N	11	6
490	Rebecca	Raschulewski		\N	11	4
491	Tyler	Smithtro		\N	11	1
492	Alicia	Rector		\N	12	5
493	Iris	Ruiz		\N	13	5
494	Belle	Kreitler		\N	14	5
495	Francesco	Carriglio		\N	15	1
496	Jaryd	Mercer		\N	15	2
497	Genevieve	Roeder-Hensley		\N	15	6
498	Natalie	Sanford		\N	15	5
499	Jack	Whilden		\N	15	3
500	Henry	Xiang		\N	15	2
501	Zach	Davidson		\N	16	3
\.


--
-- Name: athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.athletes_id_seq', 501, true);


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
1	349	6	12.15	seconds
2	351	5	13.50	seconds
3	336	6	14.00	seconds
4	293	6	14.50	seconds
5	288	5	14.59	seconds
6	156	4	14.88	seconds
7	282	5	14.97	seconds
8	130	6	14.98	seconds
9	154	6	15.15	seconds
10	192	6	15.84	seconds
11	291	5	16.15	seconds
12	23	4	\N	\N
13	44	6	\N	\N
14	52	5	\N	\N
15	88	4	\N	\N
16	129	5	\N	\N
17	109	5	\N	\N
18	118	4	\N	\N
19	121	4	\N	\N
20	124	5	\N	\N
21	125	4	\N	\N
22	159	4	\N	\N
23	149	6	\N	\N
24	95	4	\N	\N
25	135	4	\N	\N
26	167	4	\N	\N
27	180	5	\N	\N
28	261	5	\N	\N
29	240	6	\N	\N
30	299	4	\N	\N
31	325	5	\N	\N
32	319	5	\N	\N
33	324	4	\N	\N
34	281	6	\N	\N
35	289	4	\N	\N
36	278	4	\N	\N
37	277	4	\N	\N
38	335	6	\N	\N
39	345	6	\N	\N
40	339	5	\N	\N
41	344	5	\N	\N
42	348	5	\N	\N
43	406	5	\N	\N
44	405	5	\N	\N
45	358	4	\N	\N
46	410	4	\N	\N
47	378	4	\N	\N
48	362	4	\N	\N
49	364	4	\N	\N
50	390	4	\N	\N
51	383	5	\N	\N
52	353	6	\N	\N
53	399	4	\N	\N
54	438	6	\N	\N
55	423	6	\N	\N
56	445	5	\N	\N
57	414	4	\N	\N
58	417	5	\N	\N
59	424	4	\N	\N
60	439	4	\N	\N
61	441	6	\N	\N
62	444	6	\N	\N
63	448	4	\N	\N
64	349	12	24.88	seconds
65	273	11	32.77	seconds
66	291	11	34.60	seconds
67	78	11	\N	\N
68	23	10	\N	\N
69	37	10	\N	\N
70	53	10	\N	\N
71	79	10	\N	\N
72	42	10	\N	\N
73	83	12	\N	\N
74	88	10	\N	\N
75	154	12	\N	\N
76	129	11	\N	\N
77	109	11	\N	\N
78	118	10	\N	\N
79	121	10	\N	\N
80	125	10	\N	\N
81	156	10	\N	\N
82	159	10	\N	\N
83	149	12	\N	\N
84	95	10	\N	\N
85	135	10	\N	\N
86	167	10	\N	\N
87	180	11	\N	\N
88	261	11	\N	\N
89	240	12	\N	\N
90	331	12	\N	\N
91	327	12	\N	\N
92	316	11	\N	\N
93	299	10	\N	\N
94	332	12	\N	\N
95	324	10	\N	\N
96	287	12	\N	\N
97	285	11	\N	\N
98	282	11	\N	\N
99	293	12	\N	\N
100	289	10	\N	\N
101	278	10	\N	\N
102	277	10	\N	\N
103	341	11	\N	\N
104	347	12	\N	\N
105	348	11	\N	\N
106	412	11	\N	\N
107	406	11	\N	\N
108	405	11	\N	\N
109	358	10	\N	\N
110	410	10	\N	\N
111	364	10	\N	\N
112	367	10	\N	\N
113	353	12	\N	\N
114	399	10	\N	\N
115	434	12	\N	\N
116	438	12	\N	\N
117	423	12	\N	\N
118	428	12	\N	\N
119	414	10	\N	\N
120	433	12	\N	\N
121	439	10	\N	\N
122	448	10	\N	\N
123	349	18	57.50	seconds
124	273	17	74.11	seconds
125	232	18	75.35	seconds
126	30	17	\N	\N
127	62	17	\N	\N
128	37	16	\N	\N
129	48	17	\N	\N
130	53	16	\N	\N
131	79	16	\N	\N
132	42	16	\N	\N
133	74	16	\N	\N
134	83	18	\N	\N
135	109	17	\N	\N
136	121	16	\N	\N
137	125	16	\N	\N
138	95	16	\N	\N
139	165	18	\N	\N
140	172	16	\N	\N
141	192	18	\N	\N
142	327	18	\N	\N
143	316	17	\N	\N
144	285	17	\N	\N
145	288	17	\N	\N
146	341	17	\N	\N
147	412	17	\N	\N
148	406	17	\N	\N
149	358	16	\N	\N
150	380	16	\N	\N
151	364	16	\N	\N
152	443	18	\N	\N
153	292	24	147.00	seconds
154	253	22	176.00	seconds
155	257	23	178.00	seconds
156	224	24	178.18	seconds
157	260	23	179.82	seconds
158	9	22	182.70	seconds
159	6	24	183.23	seconds
160	244	24	200.00	seconds
161	13	23	\N	\N
162	5	23	\N	\N
163	30	23	\N	\N
164	62	23	\N	\N
165	18	22	\N	\N
166	36	22	\N	\N
167	57	22	\N	\N
168	61	22	\N	\N
169	48	23	\N	\N
170	87	24	\N	\N
171	120	24	\N	\N
172	93	22	\N	\N
173	123	24	\N	\N
174	158	22	\N	\N
175	165	24	\N	\N
176	177	24	\N	\N
177	172	22	\N	\N
178	202	24	\N	\N
179	195	23	\N	\N
180	310	24	\N	\N
181	300	23	\N	\N
182	328	24	\N	\N
183	287	24	\N	\N
184	285	23	\N	\N
185	343	24	\N	\N
186	346	24	\N	\N
187	392	24	\N	\N
188	398	24	\N	\N
189	355	24	\N	\N
190	376	23	\N	\N
191	401	23	\N	\N
192	411	23	\N	\N
193	382	23	\N	\N
194	387	22	\N	\N
195	380	22	\N	\N
196	415	23	\N	\N
197	292	30	298.53	seconds
198	253	28	371.68	seconds
199	195	29	380.60	seconds
200	224	30	384.25	seconds
201	257	29	387.50	seconds
202	260	29	390.00	seconds
203	189	30	390.43	seconds
204	202	30	390.76	seconds
205	243	29	408.42	seconds
206	6	30	411.96	seconds
207	249	28	421.00	seconds
208	244	30	440.33	seconds
209	13	29	\N	\N
210	9	28	\N	\N
211	5	29	\N	\N
212	18	28	\N	\N
213	36	28	\N	\N
214	57	28	\N	\N
215	61	28	\N	\N
216	87	30	\N	\N
217	120	30	\N	\N
218	93	28	\N	\N
219	123	30	\N	\N
220	158	28	\N	\N
221	177	30	\N	\N
222	172	28	\N	\N
223	310	30	\N	\N
224	300	29	\N	\N
225	328	30	\N	\N
226	343	30	\N	\N
227	346	30	\N	\N
228	392	30	\N	\N
229	398	30	\N	\N
230	355	30	\N	\N
231	376	29	\N	\N
232	401	29	\N	\N
233	411	29	\N	\N
234	382	29	\N	\N
235	387	28	\N	\N
236	437	28	\N	\N
237	392	36	\N	\N
238	398	36	\N	\N
239	376	35	\N	\N
240	401	35	\N	\N
241	411	35	\N	\N
242	382	35	\N	\N
243	387	34	\N	\N
244	337	60	17.25	seconds
245	270	59	17.97	seconds
246	340	58	19.49	seconds
247	220	60	20.17	seconds
248	199	60	21.01	seconds
249	204	60	24.12	seconds
250	50	59	\N	\N
251	332	60	\N	\N
252	378	58	\N	\N
253	362	58	\N	\N
254	368	59	\N	\N
255	361	59	\N	\N
256	383	59	\N	\N
257	337	72	53.11	seconds
258	270	71	53.64	seconds
259	340	70	55.73	seconds
260	220	72	55.80	seconds
261	199	72	57.45	seconds
262	204	72	62.30	seconds
263	50	71	\N	\N
264	74	70	\N	\N
265	321	71	\N	\N
266	342	71	\N	\N
267	368	71	\N	\N
268	361	71	\N	\N
269	383	71	\N	\N
270	142	95	338.50	inches
271	150	94	330.50	inches
272	206	96	323.00	inches
273	164	96	302.00	inches
274	226	96	282.00	inches
275	229	96	266.00	inches
276	203	95	245.00	inches
277	10	95	\N	\N
278	51	95	\N	\N
279	21	94	\N	\N
280	29	94	\N	\N
281	52	95	\N	\N
282	88	94	\N	\N
283	105	96	\N	\N
284	91	96	\N	\N
285	127	96	\N	\N
286	145	96	\N	\N
287	107	95	\N	\N
288	306	96	\N	\N
289	350	96	\N	\N
290	381	95	\N	\N
291	370	96	\N	\N
292	374	94	\N	\N
293	390	94	\N	\N
294	384	95	\N	\N
295	379	95	\N	\N
296	354	95	\N	\N
297	371	96	\N	\N
298	396	96	\N	\N
299	434	96	\N	\N
300	414	94	\N	\N
301	441	96	\N	\N
302	206	90	1032.00	inches
303	226	90	871.00	inches
304	228	90	865.00	inches
305	229	90	858.00	inches
306	142	89	816.00	inches
307	164	90	779.00	inches
308	150	88	644.00	inches
309	203	89	582.00	inches
310	51	89	\N	\N
311	21	88	\N	\N
312	29	88	\N	\N
313	52	89	\N	\N
314	105	90	\N	\N
315	91	90	\N	\N
316	127	90	\N	\N
317	145	90	\N	\N
318	107	89	\N	\N
319	236	89	\N	\N
320	306	90	\N	\N
321	350	90	\N	\N
322	381	89	\N	\N
323	370	90	\N	\N
324	374	88	\N	\N
325	390	88	\N	\N
326	384	89	\N	\N
327	379	89	\N	\N
328	354	89	\N	\N
329	371	90	\N	\N
330	396	90	\N	\N
331	428	90	\N	\N
332	337	102	54.00	inches
333	190	101	52.00	inches
334	201	101	\N	\N
335	28	102	\N	\N
336	45	102	\N	\N
337	74	100	\N	\N
338	318	102	\N	\N
339	330	102	\N	\N
340	327	102	\N	\N
341	298	100	\N	\N
342	338	102	\N	\N
343	348	101	\N	\N
344	368	101	\N	\N
345	371	102	\N	\N
346	351	107	154.25	inches
347	281	108	138.00	inches
348	338	108	114.00	inches
349	204	108	78.00	inches
350	192	108	66.00	inches
351	78	107	\N	\N
352	37	106	\N	\N
353	318	108	\N	\N
354	306	108	\N	\N
355	368	107	\N	\N
356	351	77	198.50	inches
357	270	77	174.00	inches
358	190	77	163.00	inches
359	239	78	123.50	inches
360	227	77	118.00	inches
361	201	77	\N	\N
362	236	77	\N	\N
363	28	78	\N	\N
364	17	78	\N	\N
365	23	76	\N	\N
366	44	78	\N	\N
367	42	76	\N	\N
368	83	78	\N	\N
369	88	76	\N	\N
370	130	78	\N	\N
371	154	78	\N	\N
372	118	76	\N	\N
373	125	76	\N	\N
374	273	77	\N	\N
375	318	78	\N	\N
376	298	76	\N	\N
377	324	76	\N	\N
378	281	78	\N	\N
379	278	76	\N	\N
380	336	78	\N	\N
381	342	77	\N	\N
382	355	78	\N	\N
383	405	77	\N	\N
384	367	76	\N	\N
385	353	78	\N	\N
386	445	77	\N	\N
387	417	77	\N	\N
388	433	78	\N	\N
389	338	84	430.50	inches
390	337	84	385.00	inches
391	236	83	359.50	inches
392	340	82	329.00	inches
393	239	84	299.00	inches
394	227	83	249.50	inches
395	201	83	\N	\N
396	17	84	\N	\N
397	83	84	\N	\N
398	130	84	\N	\N
399	109	83	\N	\N
400	330	84	\N	\N
401	336	84	\N	\N
402	342	83	\N	\N
403	302	3	11.60	seconds
404	223	3	11.88	seconds
405	92	3	12.54	seconds
406	137	3	12.60	seconds
407	140	3	12.72	seconds
408	233	3	12.72	seconds
409	268	2	13.36	seconds
410	279	1	13.64	seconds
411	96	2	13.97	seconds
412	205	2	14.07	seconds
413	4	3	\N	\N
414	75	3	\N	\N
415	49	3	\N	\N
416	77	3	\N	\N
417	22	2	\N	\N
418	43	2	\N	\N
419	80	2	\N	\N
420	26	2	\N	\N
421	35	3	\N	\N
422	38	2	\N	\N
423	40	1	\N	\N
424	63	2	\N	\N
425	76	3	\N	\N
426	19	3	\N	\N
427	25	1	\N	\N
428	27	2	\N	\N
429	33	1	\N	\N
430	59	1	\N	\N
431	64	2	\N	\N
432	85	3	\N	\N
433	86	2	\N	\N
434	103	2	\N	\N
435	99	3	\N	\N
436	108	3	\N	\N
437	122	1	\N	\N
438	139	3	\N	\N
439	141	1	\N	\N
440	148	1	\N	\N
441	160	3	\N	\N
442	128	3	\N	\N
443	115	1	\N	\N
444	146	3	\N	\N
445	185	3	\N	\N
446	178	3	\N	\N
447	188	3	\N	\N
448	181	2	\N	\N
449	166	2	\N	\N
450	183	2	\N	\N
451	170	2	\N	\N
452	168	1	\N	\N
453	179	1	\N	\N
454	174	1	\N	\N
455	176	1	\N	\N
456	182	1	\N	\N
457	187	1	\N	\N
458	255	3	\N	\N
459	262	3	\N	\N
460	252	2	\N	\N
461	256	3	\N	\N
462	250	3	\N	\N
463	267	2	\N	\N
464	269	1	\N	\N
465	304	2	\N	\N
466	301	1	\N	\N
467	309	1	\N	\N
468	296	1	\N	\N
469	308	1	\N	\N
470	286	3	\N	\N
471	284	2	\N	\N
472	373	3	\N	\N
473	403	2	\N	\N
474	386	2	\N	\N
475	356	1	\N	\N
476	359	1	\N	\N
477	397	1	\N	\N
478	385	1	\N	\N
479	389	1	\N	\N
480	363	3	\N	\N
481	413	3	\N	\N
482	369	1	\N	\N
483	393	3	\N	\N
484	408	1	\N	\N
485	431	2	\N	\N
486	419	3	\N	\N
487	427	2	\N	\N
488	432	3	\N	\N
489	429	3	\N	\N
490	420	1	\N	\N
491	422	1	\N	\N
492	425	3	\N	\N
493	302	9	23.00	seconds
494	223	9	24.39	seconds
495	284	8	26.72	seconds
496	279	7	27.24	seconds
497	214	9	\N	\N
498	4	9	\N	\N
499	49	9	\N	\N
500	77	9	\N	\N
501	43	8	\N	\N
502	80	8	\N	\N
503	26	8	\N	\N
504	35	9	\N	\N
505	41	7	\N	\N
506	63	8	\N	\N
507	65	9	\N	\N
508	76	9	\N	\N
509	25	7	\N	\N
510	27	8	\N	\N
511	33	7	\N	\N
512	64	8	\N	\N
513	82	9	\N	\N
514	85	9	\N	\N
515	86	8	\N	\N
516	113	9	\N	\N
517	137	9	\N	\N
518	131	9	\N	\N
519	103	8	\N	\N
520	126	9	\N	\N
521	96	8	\N	\N
522	99	9	\N	\N
523	108	9	\N	\N
524	122	7	\N	\N
525	140	9	\N	\N
526	148	7	\N	\N
527	153	8	\N	\N
528	160	9	\N	\N
529	162	8	\N	\N
530	115	7	\N	\N
531	146	9	\N	\N
532	185	9	\N	\N
533	188	9	\N	\N
534	166	8	\N	\N
535	183	8	\N	\N
536	168	7	\N	\N
537	179	7	\N	\N
538	174	7	\N	\N
539	176	7	\N	\N
540	187	7	\N	\N
541	205	8	\N	\N
542	255	9	\N	\N
543	262	9	\N	\N
544	248	9	\N	\N
545	252	8	\N	\N
546	256	9	\N	\N
547	250	9	\N	\N
548	269	7	\N	\N
549	304	8	\N	\N
550	313	9	\N	\N
551	301	7	\N	\N
552	307	9	\N	\N
553	309	7	\N	\N
554	276	9	\N	\N
555	275	7	\N	\N
556	286	9	\N	\N
557	283	7	\N	\N
558	373	9	\N	\N
559	403	8	\N	\N
560	386	8	\N	\N
561	356	7	\N	\N
562	359	7	\N	\N
563	397	7	\N	\N
564	389	7	\N	\N
565	391	8	\N	\N
566	372	8	\N	\N
567	363	9	\N	\N
568	375	9	\N	\N
569	413	9	\N	\N
570	393	9	\N	\N
571	408	7	\N	\N
572	419	9	\N	\N
573	427	8	\N	\N
574	429	9	\N	\N
575	420	7	\N	\N
576	422	7	\N	\N
577	452	8	\N	\N
578	451	8	\N	\N
579	7	15	55.66	seconds
580	452	14	56.66	seconds
581	198	14	57.54	seconds
582	234	15	57.59	seconds
583	451	14	58.51	seconds
584	247	15	60.00	seconds
585	248	15	61.00	seconds
586	275	13	61.76	seconds
587	283	13	62.00	seconds
588	245	15	63.00	seconds
589	14	15	66.42	seconds
590	11	14	\N	\N
591	20	15	\N	\N
592	47	15	\N	\N
593	58	15	\N	\N
594	69	15	\N	\N
595	41	13	\N	\N
596	55	14	\N	\N
597	65	15	\N	\N
598	59	13	\N	\N
599	84	15	\N	\N
600	86	14	\N	\N
601	113	15	\N	\N
602	131	15	\N	\N
603	126	15	\N	\N
604	99	15	\N	\N
605	108	15	\N	\N
606	162	14	\N	\N
607	175	13	\N	\N
608	274	15	\N	\N
609	267	14	\N	\N
610	271	13	\N	\N
611	265	13	\N	\N
612	313	15	\N	\N
613	326	13	\N	\N
614	307	15	\N	\N
615	296	13	\N	\N
616	280	14	\N	\N
617	356	13	\N	\N
618	385	13	\N	\N
619	389	13	\N	\N
620	391	14	\N	\N
621	372	14	\N	\N
622	375	15	\N	\N
623	393	15	\N	\N
624	408	13	\N	\N
625	416	15	\N	\N
626	430	15	\N	\N
627	426	15	\N	\N
628	219	21	119.70	seconds
629	7	21	131.96	seconds
630	196	21	134.70	seconds
631	259	20	135.00	seconds
632	217	19	136.62	seconds
633	264	21	143.00	seconds
634	251	20	143.00	seconds
635	246	21	144.00	seconds
636	234	21	144.02	seconds
637	276	21	145.30	seconds
638	286	21	145.75	seconds
639	254	19	148.00	seconds
640	263	20	152.00	seconds
641	12	21	158.82	seconds
642	207	20	158.96	seconds
643	241	20	168.00	seconds
644	14	21	173.13	seconds
645	271	19	191.45	seconds
646	242	20	240.00	seconds
647	3	21	\N	\N
648	2	20	\N	\N
649	1	19	\N	\N
650	11	20	\N	\N
651	47	21	\N	\N
652	58	21	\N	\N
653	69	21	\N	\N
654	75	21	\N	\N
655	31	20	\N	\N
656	81	21	\N	\N
657	66	19	\N	\N
658	32	19	\N	\N
659	34	19	\N	\N
660	46	19	\N	\N
661	60	19	\N	\N
662	84	21	\N	\N
663	89	20	\N	\N
664	110	21	\N	\N
665	112	20	\N	\N
666	138	20	\N	\N
667	151	21	\N	\N
668	161	21	\N	\N
669	133	21	\N	\N
670	114	21	\N	\N
671	90	20	\N	\N
672	100	20	\N	\N
673	111	19	\N	\N
674	101	19	\N	\N
675	106	21	\N	\N
676	152	19	\N	\N
677	94	21	\N	\N
678	144	21	\N	\N
679	119	20	\N	\N
680	157	20	\N	\N
681	184	21	\N	\N
682	173	20	\N	\N
683	169	21	\N	\N
684	175	19	\N	\N
685	193	21	\N	\N
686	213	20	\N	\N
687	266	20	\N	\N
688	272	21	\N	\N
689	305	21	\N	\N
690	317	21	\N	\N
691	315	21	\N	\N
692	297	20	\N	\N
693	323	19	\N	\N
694	329	19	\N	\N
695	314	19	\N	\N
696	320	19	\N	\N
697	312	19	\N	\N
698	280	20	\N	\N
699	409	21	\N	\N
700	400	20	\N	\N
701	377	20	\N	\N
702	402	19	\N	\N
703	352	19	\N	\N
704	395	19	\N	\N
705	366	21	\N	\N
706	447	21	\N	\N
707	449	21	\N	\N
708	442	21	\N	\N
709	446	21	\N	\N
710	421	19	\N	\N
711	456	21	\N	\N
712	455	20	\N	\N
713	217	25	253.86	seconds
714	219	27	265.88	seconds
715	297	26	272.96	seconds
716	456	27	276.92	seconds
717	450	27	283.75	seconds
718	455	26	283.75	seconds
719	259	26	287.21	seconds
720	317	27	290.00	seconds
721	329	25	290.58	seconds
722	196	27	294.65	seconds
723	193	27	295.99	seconds
724	3	27	305.37	seconds
725	251	26	306.96	seconds
726	264	27	307.48	seconds
727	246	27	307.76	seconds
728	254	25	319.22	seconds
729	263	26	329.61	seconds
730	12	27	345.08	seconds
731	241	26	358.51	seconds
732	207	26	362.44	seconds
733	238	27	370.08	seconds
734	258	27	390.00	seconds
735	272	27	396.33	seconds
736	2	26	\N	\N
737	1	25	\N	\N
738	11	26	\N	\N
739	31	26	\N	\N
740	81	27	\N	\N
741	66	25	\N	\N
742	32	25	\N	\N
743	34	25	\N	\N
744	46	25	\N	\N
745	60	25	\N	\N
746	84	27	\N	\N
747	89	26	\N	\N
748	110	27	\N	\N
749	112	26	\N	\N
750	138	26	\N	\N
751	151	27	\N	\N
752	161	27	\N	\N
753	133	27	\N	\N
754	114	27	\N	\N
755	90	26	\N	\N
756	100	26	\N	\N
757	111	25	\N	\N
758	101	25	\N	\N
759	136	26	\N	\N
760	106	27	\N	\N
761	152	25	\N	\N
762	94	27	\N	\N
763	144	27	\N	\N
764	119	26	\N	\N
765	157	26	\N	\N
766	184	27	\N	\N
767	173	26	\N	\N
768	170	26	\N	\N
769	169	27	\N	\N
770	175	25	\N	\N
771	186	26	\N	\N
772	271	25	\N	\N
773	265	25	\N	\N
774	305	27	\N	\N
775	315	27	\N	\N
776	323	25	\N	\N
777	314	25	\N	\N
778	320	25	\N	\N
779	312	25	\N	\N
780	294	25	\N	\N
781	400	26	\N	\N
782	377	26	\N	\N
783	402	25	\N	\N
784	352	25	\N	\N
785	395	25	\N	\N
786	366	27	\N	\N
787	447	27	\N	\N
788	449	27	\N	\N
789	442	27	\N	\N
790	421	25	\N	\N
791	454	27	\N	\N
792	453	27	\N	\N
793	457	25	\N	\N
794	377	32	\N	\N
795	352	31	\N	\N
796	366	33	\N	\N
797	230	63	18.94	seconds
798	197	63	21.21	seconds
799	216	63	23.20	seconds
800	72	63	\N	\N
801	70	63	\N	\N
802	35	63	\N	\N
803	38	62	\N	\N
804	33	61	\N	\N
805	92	63	\N	\N
806	97	63	\N	\N
807	181	62	\N	\N
808	194	62	\N	\N
809	311	63	\N	\N
810	308	61	\N	\N
811	394	62	\N	\N
812	360	63	\N	\N
813	430	63	\N	\N
814	230	69	48.60	seconds
815	194	68	48.99	seconds
816	274	69	49.98	seconds
817	197	69	51.49	seconds
818	72	69	\N	\N
819	68	67	\N	\N
820	19	69	\N	\N
821	92	69	\N	\N
822	97	69	\N	\N
823	136	68	\N	\N
824	184	69	\N	\N
825	181	68	\N	\N
826	198	68	\N	\N
827	311	69	\N	\N
828	430	69	\N	\N
829	426	69	\N	\N
830	200	93	475.50	inches
831	221	93	467.00	inches
832	215	93	407.00	inches
833	235	93	388.00	inches
834	191	92	335.50	inches
835	209	93	331.50	inches
836	8	93	\N	\N
837	39	93	\N	\N
838	24	93	\N	\N
839	69	93	\N	\N
840	67	93	\N	\N
841	16	93	\N	\N
842	22	92	\N	\N
843	56	91	\N	\N
844	71	93	\N	\N
845	85	93	\N	\N
846	155	93	\N	\N
847	117	92	\N	\N
848	163	92	\N	\N
849	116	92	\N	\N
850	98	92	\N	\N
851	147	93	\N	\N
852	132	93	\N	\N
853	143	92	\N	\N
854	171	91	\N	\N
855	258	93	\N	\N
856	267	92	\N	\N
857	322	93	\N	\N
858	303	91	\N	\N
859	290	92	\N	\N
860	365	93	\N	\N
861	407	93	\N	\N
862	388	91	\N	\N
863	357	92	\N	\N
864	404	92	\N	\N
865	440	93	\N	\N
866	432	93	\N	\N
867	200	87	1441.00	inches
868	163	86	1315.00	inches
869	221	87	1224.00	inches
870	235	87	1146.00	inches
871	215	87	1087.00	inches
872	209	87	1018.00	inches
873	191	86	903.00	inches
874	268	86	883.00	inches
875	98	86	810.00	inches
876	8	87	\N	\N
877	15	87	\N	\N
878	39	87	\N	\N
879	24	87	\N	\N
880	67	87	\N	\N
881	16	87	\N	\N
882	22	86	\N	\N
883	56	85	\N	\N
884	71	87	\N	\N
885	73	85	\N	\N
886	155	87	\N	\N
887	117	86	\N	\N
888	116	86	\N	\N
889	147	87	\N	\N
890	132	87	\N	\N
891	143	86	\N	\N
892	171	85	\N	\N
893	245	87	\N	\N
894	258	87	\N	\N
895	322	87	\N	\N
896	303	85	\N	\N
897	290	86	\N	\N
898	365	87	\N	\N
899	407	87	\N	\N
900	388	85	\N	\N
901	357	86	\N	\N
902	404	86	\N	\N
903	440	87	\N	\N
904	446	87	\N	\N
905	432	87	\N	\N
906	212	99	62.00	inches
907	225	99	62.00	inches
908	210	98	60.00	inches
909	268	98	\N	\N
910	15	99	\N	\N
911	39	99	\N	\N
912	72	99	\N	\N
913	40	97	\N	\N
914	82	99	\N	\N
915	102	98	\N	\N
916	104	98	\N	\N
917	134	98	\N	\N
918	146	99	\N	\N
919	274	99	\N	\N
920	334	98	\N	\N
921	394	98	\N	\N
922	385	97	\N	\N
923	369	97	\N	\N
924	418	99	\N	\N
925	436	99	\N	\N
926	230	105	114.00	inches
927	208	105	102.00	inches
928	196	105	102.00	inches
929	20	105	\N	\N
930	70	105	\N	\N
931	25	103	\N	\N
932	59	103	\N	\N
933	82	105	\N	\N
934	333	105	\N	\N
935	295	104	\N	\N
936	334	104	\N	\N
937	326	103	\N	\N
938	409	105	\N	\N
939	394	104	\N	\N
940	385	103	\N	\N
941	212	75	210.00	inches
942	233	75	203.00	inches
943	194	74	198.50	inches
944	283	73	174.00	inches
945	225	75	171.00	inches
946	210	74	166.00	inches
947	279	73	166.00	inches
948	284	74	158.00	inches
949	211	75	148.00	inches
950	222	74	\N	\N
951	24	75	\N	\N
952	69	75	\N	\N
953	38	74	\N	\N
954	40	73	\N	\N
955	55	74	\N	\N
956	68	73	\N	\N
957	27	74	\N	\N
958	64	74	\N	\N
959	85	75	\N	\N
960	86	74	\N	\N
961	113	75	\N	\N
962	131	75	\N	\N
963	102	74	\N	\N
964	104	74	\N	\N
965	103	74	\N	\N
966	134	74	\N	\N
967	153	74	\N	\N
968	162	74	\N	\N
969	178	75	\N	\N
970	181	74	\N	\N
971	170	74	\N	\N
972	182	73	\N	\N
973	237	75	\N	\N
974	247	75	\N	\N
975	258	75	\N	\N
976	333	75	\N	\N
977	311	75	\N	\N
978	409	75	\N	\N
979	391	74	\N	\N
980	363	75	\N	\N
981	408	73	\N	\N
982	418	75	\N	\N
983	431	74	\N	\N
984	435	75	\N	\N
985	427	74	\N	\N
986	436	75	\N	\N
987	421	73	\N	\N
988	425	75	\N	\N
989	222	80	501.00	inches
990	212	81	467.00	inches
991	15	81	426.50	inches
992	233	81	420.50	inches
993	225	81	380.00	inches
994	214	81	379.00	inches
995	210	80	377.75	inches
996	211	81	347.00	inches
997	80	80	\N	\N
998	54	81	\N	\N
999	68	79	\N	\N
1000	113	81	\N	\N
1001	102	80	\N	\N
1002	104	80	\N	\N
1003	134	80	\N	\N
1004	153	80	\N	\N
1005	333	81	\N	\N
1006	311	81	\N	\N
1007	394	80	\N	\N
1008	418	81	\N	\N
1009	431	80	\N	\N
1010	435	81	\N	\N
1011	436	81	\N	\N
1012	349	114	12.15	seconds
1013	351	113	13.21	seconds
1014	231	112	13.61	seconds
1015	336	114	13.79	seconds
1016	270	113	13.82	seconds
1017	423	114	13.87	seconds
1018	364	112	13.92	seconds
1019	321	113	13.98	seconds
1020	293	114	14.06	seconds
1021	490	112	14.30	seconds
1022	367	112	14.34	seconds
1023	154	114	14.35	seconds
1024	156	112	14.35	seconds
1025	124	113	14.42	seconds
1026	438	114	14.51	seconds
1027	83	114	14.52	seconds
1028	130	114	14.53	seconds
1029	118	112	14.66	seconds
1030	50	113	14.70	seconds
1031	410	112	14.71	seconds
1032	489	114	14.80	seconds
1033	484	112	14.82	seconds
1034	494	113	14.85	seconds
1035	125	112	14.89	seconds
1036	406	113	14.89	seconds
1037	439	112	14.89	seconds
1038	282	113	14.95	seconds
1039	399	112	15.00	seconds
1040	459	112	15.48	seconds
1041	277	112	15.51	seconds
1042	291	113	15.54	seconds
1043	348	113	15.92	seconds
1044	345	114	16.12	seconds
1045	339	113	16.44	seconds
1046	335	114	17.58	seconds
1047	349	120	24.76	seconds
1048	331	120	26.90	seconds
1049	412	119	27.96	seconds
1050	62	119	28.02	seconds
1051	423	120	28.10	seconds
1052	338	120	28.34	seconds
1053	231	118	28.69	seconds
1054	293	120	29.61	seconds
1055	364	118	29.71	seconds
1056	156	118	30.38	seconds
1057	367	118	30.73	seconds
1058	494	119	30.80	seconds
1059	410	118	30.84	seconds
1060	489	120	30.90	seconds
1061	118	118	30.93	seconds
1062	399	118	31.08	seconds
1063	299	118	31.10	seconds
1064	448	118	31.20	seconds
1065	135	118	31.23	seconds
1066	406	119	31.50	seconds
1067	484	118	31.79	seconds
1068	83	120	32.08	seconds
1069	277	118	32.13	seconds
1070	291	119	32.29	seconds
1071	125	118	33.01	seconds
1072	458	120	33.13	seconds
1073	159	118	33.28	seconds
1074	348	119	34.12	seconds
1075	109	119	34.58	seconds
1076	459	118	35.30	seconds
1077	339	119	35.42	seconds
1078	345	120	35.61	seconds
1079	335	120	36.99	seconds
1080	349	126	56.00	seconds
1081	62	125	60.62	seconds
1082	412	125	63.60	seconds
1083	331	126	66.29	seconds
1084	288	125	67.92	seconds
1085	124	125	70.40	seconds
1086	135	124	70.48	seconds
1087	316	125	70.57	seconds
1088	74	124	71.07	seconds
1089	327	126	71.14	seconds
1090	443	126	71.26	seconds
1091	78	125	71.34	seconds
1092	57	124	72.24	seconds
1093	428	126	72.54	seconds
1094	204	126	73.67	seconds
1095	192	126	74.68	seconds
1096	232	126	75.35	seconds
1097	159	124	76.24	seconds
1098	95	124	78.47	seconds
1099	125	124	78.79	seconds
1100	475	125	79.84	seconds
1101	328	132	148.04	seconds
1102	300	131	151.40	seconds
1103	292	132	153.47	seconds
1104	61	130	154.98	seconds
1105	285	131	159.76	seconds
1106	158	130	160.68	seconds
1107	392	132	160.73	seconds
1108	253	130	161.27	seconds
1109	57	130	162.53	seconds
1110	493	131	166.07	seconds
1111	260	131	169.40	seconds
1112	497	132	170.98	seconds
1113	437	130	172.15	seconds
1114	224	132	173.57	seconds
1115	30	131	173.75	seconds
1116	458	132	174.03	seconds
1117	202	132	178.01	seconds
1118	443	132	180.20	seconds
1119	123	132	183.93	seconds
1120	87	132	184.15	seconds
1121	498	131	189.81	seconds
1122	120	132	191.97	seconds
1123	93	130	191.99	seconds
1124	346	132	196.33	seconds
1125	343	132	204.03	seconds
1126	292	138	298.53	seconds
1127	328	138	327.78	seconds
1128	287	138	336.32	seconds
1129	300	137	336.97	seconds
1130	61	136	338.73	seconds
1131	392	138	345.20	seconds
1132	57	136	354.72	seconds
1133	158	136	356.26	seconds
1134	493	137	361.02	seconds
1135	497	138	363.73	seconds
1136	224	138	365.12	seconds
1137	243	137	368.40	seconds
1138	253	136	370.35	seconds
1139	202	138	371.88	seconds
1140	411	137	373.11	seconds
1141	195	137	375.22	seconds
1142	387	136	378.64	seconds
1143	189	138	381.00	seconds
1144	249	136	383.01	seconds
1145	18	136	384.84	seconds
1146	36	136	388.06	seconds
1147	9	136	394.01	seconds
1148	87	138	394.17	seconds
1149	123	138	395.87	seconds
1150	6	138	398.87	seconds
1151	120	138	410.75	seconds
1152	244	138	418.03	seconds
1153	498	137	422.39	seconds
1154	93	136	426.26	seconds
1155	346	138	431.98	seconds
1156	343	138	451.33	seconds
1157	292	144	661.55	seconds
1158	392	144	728.29	seconds
1159	195	143	743.93	seconds
1160	328	144	750.44	seconds
1161	287	144	750.85	seconds
1162	61	142	752.55	seconds
1163	224	144	787.16	seconds
1164	411	143	788.37	seconds
1165	493	143	790.99	seconds
1166	257	143	810.62	seconds
1167	260	143	822.42	seconds
1168	243	143	826.51	seconds
1169	158	142	834.83	seconds
1170	387	142	837.28	seconds
1171	9	142	840.62	seconds
1172	189	144	853.10	seconds
1173	18	142	859.04	seconds
1174	36	142	859.35	seconds
1175	123	144	875.03	seconds
1176	120	144	914.13	seconds
1177	337	168	16.81	seconds
1178	270	167	17.29	seconds
1179	332	168	17.46	seconds
1180	340	166	17.97	seconds
1181	342	167	19.00	seconds
1182	199	168	19.36	seconds
1183	220	168	19.44	seconds
1184	484	166	19.45	seconds
1185	368	167	20.48	seconds
1186	415	167	21.12	seconds
1187	383	167	21.75	seconds
1188	361	167	21.89	seconds
1189	321	179	48.10	seconds
1190	270	179	51.12	seconds
1191	337	180	51.36	seconds
1192	332	180	51.95	seconds
1193	340	178	52.49	seconds
1194	50	179	53.06	seconds
1195	368	179	53.07	seconds
1196	220	180	53.25	seconds
1197	342	179	53.66	seconds
1198	199	180	55.75	seconds
1199	74	178	57.78	seconds
1200	415	179	58.71	seconds
1201	383	179	60.04	seconds
1202	341	179	60.38	seconds
1203	361	179	63.71	seconds
1204	51	203	418.50	inches
1205	142	203	357.00	inches
1206	206	204	338.00	inches
1207	226	204	333.00	inches
1208	164	204	331.00	inches
1209	150	202	330.50	inches
1210	203	203	326.00	inches
1211	354	203	316.00	inches
1212	381	203	313.25	inches
1213	490	202	309.50	inches
1214	229	204	290.75	inches
1215	306	204	289.00	inches
1216	350	204	283.00	inches
1217	492	203	274.00	inches
1218	107	203	273.50	inches
1219	414	202	267.75	inches
1220	396	204	265.50	inches
1221	29	202	262.50	inches
1222	371	204	261.00	inches
1223	91	204	257.00	inches
1224	482	203	252.00	inches
1225	52	203	248.00	inches
1226	145	204	240.25	inches
1227	434	204	201.25	inches
1228	206	198	1136.00	inches
1229	236	197	1136.00	inches
1230	164	198	1063.00	inches
1231	490	196	1053.00	inches
1232	226	198	1045.00	inches
1233	51	197	1018.00	inches
1234	381	197	963.00	inches
1235	142	197	926.00	inches
1236	306	198	922.00	inches
1237	229	198	912.00	inches
1238	44	198	874.00	inches
1239	228	198	865.00	inches
1240	492	197	835.50	inches
1241	428	198	802.00	inches
1242	414	196	789.00	inches
1243	396	198	776.00	inches
1244	203	197	744.00	inches
1245	150	196	730.00	inches
1246	350	198	724.00	inches
1247	107	197	713.00	inches
1248	374	196	701.00	inches
1249	354	197	694.00	inches
1250	371	198	642.50	inches
1251	29	196	633.50	inches
1252	484	196	630.00	inches
1253	417	197	567.00	inches
1254	145	198	566.00	inches
1255	91	198	520.00	inches
1256	28	210	62.00	inches
1257	45	210	58.00	inches
1258	190	209	56.00	inches
1259	218	208	54.00	inches
1260	330	210	54.00	inches
1261	337	210	54.00	inches
1262	201	209	50.00	inches
1263	437	208	50.00	inches
1264	415	209	50.00	inches
1265	444	210	50.00	inches
1266	348	209	48.00	inches
1267	368	209	48.00	inches
1268	351	215	158.00	inches
1269	281	216	146.00	inches
1270	338	216	123.00	inches
1271	306	216	108.00	inches
1272	486	215	102.00	inches
1273	204	216	90.00	inches
1274	78	215	84.00	inches
1275	37	214	78.00	inches
1276	351	185	203.25	inches
1277	331	186	194.00	inches
1278	190	185	180.75	inches
1279	218	184	178.00	inches
1280	336	186	178.00	inches
1281	42	184	176.00	inches
1282	270	185	174.00	inches
1283	83	186	172.00	inches
1284	154	186	172.00	inches
1285	201	185	169.00	inches
1286	130	186	166.50	inches
1287	17	186	164.00	inches
1288	367	184	158.50	inches
1289	125	184	158.00	inches
1290	444	186	156.50	inches
1291	424	184	155.00	inches
1292	44	186	154.75	inches
1293	494	185	151.00	inches
1294	118	184	149.50	inches
1295	239	186	148.00	inches
1296	459	184	146.00	inches
1297	434	186	141.50	inches
1298	109	185	136.50	inches
1299	338	192	434.50	inches
1300	337	192	394.00	inches
1301	336	192	385.75	inches
1302	218	190	381.00	inches
1303	330	192	370.00	inches
1304	306	192	367.50	inches
1305	236	191	359.50	inches
1306	17	192	356.00	inches
1307	83	192	353.00	inches
1308	412	191	345.50	inches
1309	130	192	343.00	inches
1310	444	192	334.75	inches
1311	239	192	332.50	inches
1312	154	192	329.00	inches
1313	367	190	322.00	inches
1314	109	191	301.00	inches
1315	414	190	297.00	inches
1316	448	190	291.00	inches
1317	424	190	290.75	inches
1318	302	111	11.40	seconds
1319	223	111	11.55	seconds
1320	92	111	11.59	seconds
1321	185	111	11.78	seconds
1322	80	110	11.93	seconds
1323	222	110	12.01	seconds
1324	473	109	12.06	seconds
1325	419	111	12.09	seconds
1326	429	111	12.10	seconds
1327	77	111	12.14	seconds
1328	373	111	12.14	seconds
1329	137	111	12.15	seconds
1330	400	110	12.19	seconds
1331	309	109	12.21	seconds
1332	476	111	12.22	seconds
1333	255	111	12.25	seconds
1334	393	111	12.30	seconds
1335	108	111	12.34	seconds
1336	233	111	12.35	seconds
1337	256	111	12.37	seconds
1338	397	109	12.40	seconds
1339	64	110	12.41	seconds
1340	140	111	12.46	seconds
1341	286	111	12.49	seconds
1342	431	110	12.50	seconds
1343	128	111	12.55	seconds
1344	372	110	12.59	seconds
1345	99	111	12.65	seconds
1346	4	111	12.68	seconds
1347	478	110	12.70	seconds
1348	451	110	12.71	seconds
1349	85	111	12.78	seconds
1350	86	110	12.91	seconds
1351	284	110	13.24	seconds
1352	487	109	13.30	seconds
1353	279	109	13.32	seconds
1354	268	110	13.36	seconds
1355	271	109	14.79	seconds
1356	302	117	22.80	seconds
1357	92	117	23.02	seconds
1358	185	117	23.75	seconds
1359	360	117	24.15	seconds
1360	223	117	24.19	seconds
1361	393	117	24.37	seconds
1362	479	115	24.50	seconds
1363	419	117	24.57	seconds
1364	429	117	24.59	seconds
1365	286	117	24.65	seconds
1366	80	116	24.69	seconds
1367	473	115	24.77	seconds
1368	416	117	24.80	seconds
1369	309	115	24.97	seconds
1370	140	117	24.98	seconds
1371	77	117	25.26	seconds
1372	462	117	25.26	seconds
1373	397	115	25.28	seconds
1374	64	116	25.31	seconds
1375	35	117	25.35	seconds
1376	137	117	25.41	seconds
1377	301	115	25.55	seconds
1378	452	116	25.57	seconds
1379	451	116	25.63	seconds
1380	375	117	25.85	seconds
1381	141	115	25.86	seconds
1382	478	116	26.00	seconds
1383	198	116	26.00	seconds
1384	465	115	26.00	seconds
1385	146	117	26.24	seconds
1386	86	116	26.30	seconds
1387	99	117	26.31	seconds
1388	372	116	26.43	seconds
1389	85	117	26.52	seconds
1390	284	116	26.72	seconds
1391	386	116	26.73	seconds
1392	4	117	26.99	seconds
1393	279	115	27.22	seconds
1394	267	116	27.31	seconds
1395	499	117	27.40	seconds
1396	487	115	27.85	seconds
1397	275	115	27.87	seconds
1398	268	116	27.91	seconds
1399	271	115	30.95	seconds
1400	302	123	52.00	seconds
1401	456	123	52.80	seconds
1402	479	121	53.31	seconds
1403	312	121	54.50	seconds
1404	108	123	54.59	seconds
1405	68	121	54.91	seconds
1406	286	123	54.97	seconds
1407	422	121	55.20	seconds
1408	322	123	56.30	seconds
1409	466	121	56.42	seconds
1410	430	123	56.43	seconds
1411	452	122	56.56	seconds
1412	416	123	56.59	seconds
1413	198	122	56.69	seconds
1414	75	123	57.00	seconds
1415	35	123	57.14	seconds
1416	313	123	57.40	seconds
1417	469	121	58.46	seconds
1418	451	122	58.51	seconds
1419	280	122	58.54	seconds
1420	146	123	58.68	seconds
1421	375	123	58.68	seconds
1422	386	122	59.77	seconds
1423	126	123	59.85	seconds
1424	86	122	59.95	seconds
1425	267	122	60.19	seconds
1426	99	123	61.64	seconds
1427	275	121	61.76	seconds
1428	131	123	61.86	seconds
1429	283	121	62.00	seconds
1430	113	123	62.02	seconds
1431	499	123	62.17	seconds
1432	89	122	63.56	seconds
1433	84	123	63.98	seconds
1434	271	121	66.95	seconds
1435	219	129	117.76	seconds
1436	456	129	120.11	seconds
1437	329	127	120.44	seconds
1438	297	128	123.17	seconds
1439	400	128	124.50	seconds
1440	481	128	126.70	seconds
1441	455	128	127.97	seconds
1442	454	129	132.15	seconds
1443	452	128	132.42	seconds
1444	217	127	132.92	seconds
1445	320	127	133.64	seconds
1446	58	129	133.68	seconds
1447	496	128	136.07	seconds
1448	457	127	137.30	seconds
1449	110	129	137.77	seconds
1450	276	129	137.90	seconds
1451	161	129	138.82	seconds
1452	245	129	143.50	seconds
1453	151	129	145.48	seconds
1454	366	129	147.39	seconds
1455	114	129	147.52	seconds
1456	89	128	150.34	seconds
1457	133	129	150.93	seconds
1458	267	128	157.11	seconds
1459	449	129	159.30	seconds
1460	138	128	161.05	seconds
1461	84	129	\N	\N
1462	219	135	258.40	seconds
1463	297	134	263.39	seconds
1464	400	134	273.00	seconds
1465	463	135	273.02	seconds
1466	455	134	273.19	seconds
1467	456	135	276.92	seconds
1468	193	135	277.73	seconds
1469	481	134	280.40	seconds
1470	259	134	280.96	seconds
1471	173	134	284.23	seconds
1472	496	134	286.03	seconds
1473	217	133	292.58	seconds
1474	46	133	294.91	seconds
1475	3	135	298.01	seconds
1476	264	135	298.45	seconds
1477	246	135	304.59	seconds
1478	442	135	305.59	seconds
1479	421	133	305.81	seconds
1480	447	135	305.90	seconds
1481	485	133	306.66	seconds
1482	251	134	306.68	seconds
1483	161	135	309.69	seconds
1484	110	135	311.85	seconds
1485	245	135	313.20	seconds
1486	366	135	317.37	seconds
1487	454	135	319.67	seconds
1488	114	135	323.22	seconds
1489	274	135	323.32	seconds
1490	453	135	323.74	seconds
1491	112	134	324.00	seconds
1492	133	135	326.17	seconds
1493	11	134	326.72	seconds
1494	457	133	327.61	seconds
1495	89	134	329.40	seconds
1496	294	133	329.89	seconds
1497	157	134	332.80	seconds
1498	84	135	349.50	seconds
1499	265	133	387.56	seconds
1500	317	141	592.00	seconds
1501	193	141	596.81	seconds
1502	219	141	604.07	seconds
1503	173	140	604.50	seconds
1504	463	141	619.53	seconds
1505	496	140	636.80	seconds
1506	315	141	637.30	seconds
1507	470	139	641.38	seconds
1508	264	141	642.34	seconds
1509	323	139	653.90	seconds
1510	254	139	655.50	seconds
1511	263	140	655.60	seconds
1512	251	140	657.90	seconds
1513	485	139	667.89	seconds
1514	442	141	673.79	seconds
1515	46	139	675.32	seconds
1516	3	141	675.48	seconds
1517	314	139	678.80	seconds
1518	421	139	688.19	seconds
1519	246	141	689.93	seconds
1520	112	140	691.80	seconds
1521	110	141	695.42	seconds
1522	12	141	696.55	seconds
1523	11	140	697.60	seconds
1524	366	141	703.06	seconds
1525	32	139	704.68	seconds
1526	114	141	705.69	seconds
1527	474	139	706.01	seconds
1528	161	141	713.48	seconds
1529	1	139	725.74	seconds
1530	136	140	728.81	seconds
1531	111	139	765.27	seconds
1532	207	140	767.08	seconds
1533	265	139	865.06	seconds
1534	72	171	16.68	seconds
1535	194	170	17.34	seconds
1536	360	171	17.36	seconds
1537	311	171	17.54	seconds
1538	230	171	17.60	seconds
1539	483	171	18.64	seconds
1540	468	169	19.19	seconds
1541	181	170	19.37	seconds
1542	97	171	19.73	seconds
1543	430	171	19.76	seconds
1544	477	169	21.17	seconds
1545	96	170	22.94	seconds
1546	152	169	25.39	seconds
1547	122	169	\N	\N
1548	360	177	43.52	seconds
1549	194	176	44.20	seconds
1550	72	177	44.65	seconds
1551	479	175	45.07	seconds
1552	75	177	45.80	seconds
1553	311	177	45.82	seconds
1554	430	177	45.88	seconds
1555	230	177	46.00	seconds
1556	274	177	46.96	seconds
1557	468	175	47.80	seconds
1558	97	177	48.08	seconds
1559	181	176	48.72	seconds
1560	122	175	50.14	seconds
1561	477	175	51.31	seconds
1562	483	177	51.50	seconds
1563	255	177	52.85	seconds
1564	96	176	57.19	seconds
1565	426	177	59.59	seconds
1566	152	175	60.50	seconds
1567	365	201	609.00	inches
1568	163	200	557.00	inches
1569	200	201	497.00	inches
1570	432	201	481.25	inches
1571	407	201	471.50	inches
1572	373	201	471.00	inches
1573	39	201	463.50	inches
1574	440	201	461.50	inches
1575	501	201	449.50	inches
1576	215	201	449.00	inches
1577	132	201	440.00	inches
1578	16	201	432.75	inches
1579	472	199	428.50	inches
1580	471	199	425.50	inches
1581	256	201	422.00	inches
1582	22	200	421.00	inches
1583	235	201	420.00	inches
1584	209	201	393.50	inches
1585	98	200	390.75	inches
1586	322	201	390.00	inches
1587	290	200	359.25	inches
1588	86	200	312.50	inches
1589	495	199	311.00	inches
1590	85	201	290.00	inches
1591	500	200	259.75	inches
1592	365	195	1782.00	inches
1593	163	194	1580.50	inches
1594	200	195	1509.00	inches
1595	235	195	1425.50	inches
1596	440	195	1413.00	inches
1597	39	195	1363.00	inches
1598	472	193	1191.00	inches
1599	407	195	1133.00	inches
1600	215	195	1130.00	inches
1601	322	195	1121.50	inches
1602	132	195	1118.00	inches
1603	252	194	1106.50	inches
1604	98	194	1092.00	inches
1605	22	194	1090.00	inches
1606	209	195	1082.00	inches
1607	191	194	1080.00	inches
1608	471	193	1061.75	inches
1609	432	195	1028.50	inches
1610	404	194	1000.00	inches
1611	290	194	991.50	inches
1612	268	194	883.00	inches
1613	72	207	72.00	inches
1614	467	205	70.00	inches
1615	436	207	70.00	inches
1616	418	207	68.00	inches
1617	82	207	67.00	inches
1618	212	207	64.00	inches
1619	334	206	64.00	inches
1620	27	206	63.00	inches
1621	40	205	62.00	inches
1622	210	206	60.00	inches
1623	153	206	58.00	inches
1624	461	207	58.00	inches
1625	274	207	58.00	inches
1626	394	206	58.00	inches
1627	397	205	56.00	inches
1628	131	207	52.00	inches
1629	70	213	138.00	inches
1630	333	213	138.00	inches
1631	230	213	126.00	inches
1632	334	212	126.00	inches
1633	82	213	120.00	inches
1634	208	213	120.00	inches
1635	59	211	108.00	inches
1636	480	211	108.00	inches
1637	295	212	108.00	inches
1638	422	211	108.00	inches
1639	394	212	102.00	inches
1640	468	211	97.00	inches
1641	491	211	96.00	inches
1642	20	213	84.00	inches
1643	436	183	236.00	inches
1644	419	183	235.50	inches
1645	72	183	232.00	inches
1646	222	182	230.00	inches
1647	194	182	227.75	inches
1648	104	182	224.00	inches
1649	393	183	223.50	inches
1650	311	183	221.50	inches
1651	418	183	218.00	inches
1652	435	183	218.00	inches
1653	223	183	216.00	inches
1654	212	183	216.00	inches
1655	77	183	213.50	inches
1656	80	182	213.00	inches
1657	27	182	212.00	inches
1658	233	183	211.75	inches
1659	181	182	210.50	inches
1660	365	183	207.75	inches
1661	467	181	207.00	inches
1662	488	181	206.00	inches
1663	464	182	205.25	inches
1664	210	182	204.00	inches
1665	425	183	201.00	inches
1666	153	182	198.75	inches
1667	131	183	194.25	inches
1668	394	182	191.00	inches
1669	113	183	188.75	inches
1670	279	181	185.00	inches
1671	460	183	182.50	inches
1672	283	181	179.00	inches
1673	134	182	178.00	inches
1674	265	181	157.00	inches
1675	222	188	501.00	inches
1676	436	189	478.75	inches
1677	104	188	475.75	inches
1678	212	189	467.00	inches
1679	435	189	467.00	inches
1680	311	189	466.00	inches
1681	70	189	463.00	inches
1682	233	189	453.50	inches
1683	467	187	442.00	inches
1684	27	188	440.00	inches
1685	418	189	433.00	inches
1686	210	188	430.00	inches
1687	131	189	424.00	inches
1688	394	188	421.50	inches
1689	431	188	412.00	inches
1690	464	188	406.50	inches
1691	153	188	395.25	inches
1692	113	189	388.25	inches
1693	460	189	377.00	inches
1694	134	188	370.00	inches
\.


--
-- Name: entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.entries_id_seq', 1694, true);


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
\.


--
-- Name: meet_division_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.meet_division_events_id_seq', 216, true);


--
-- Data for Name: meets; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.meets (id, name, date, host_school_id, description, status, max_entries_per_athlete, max_team_entries_per_event) FROM stdin;
1	WVAL League Practice Meet #1	2019-04-15 00:00:00	\N	 Meet starts at 3pm, at Los Gatos High School.\n                        	Accepting Entries	\N	\N
2	WVAL League Practice Meet #2	2019-04-25 00:00:00	\N		Accepting Entries	\N	\N
\.


--
-- Name: meets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.meets_id_seq', 2, true);


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.schools (id, abbrev, name, league, section, city, state) FROM stdin;
1	UNA	Unattached	\N	\N	\N	\N
2	ANZR	Anzar (Aromas-San Juan)	\N	\N	\N	\N
3	CARM	Carmel	\N	\N	\N	\N
4	GBK	GB Kirby	\N	\N	\N	\N
5	GONZ	Gonzales	\N	\N	\N	\N
6	GRNF	Greenfield	\N	\N	\N	\N
7	KICI	King City	\N	\N	\N	\N
8	MaHS	Marina	\N	\N	\N	\N
9	OAKW	Oakwood	\N	\N	\N	\N
10	PCS	Pacific Collegiate	\N	\N	\N	\N
11	PAGR	Pacific Grove	\N	\N	\N	\N
12	SCAT	Santa Catalina	\N	\N	\N	\N
13	SOLE	Soledad	\N	\N	\N	\N
14	STEV	Stevenson	\N	\N	\N	\N
15	YORK	The York School	\N	\N	\N	\N
16	TCHS	Trinity Christian	\N	\N	\N	\N
\.


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.schools_id_seq', 16, true);


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

