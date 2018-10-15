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
    'accepting_entries',
    'entries_closed',
    'athletes_assigned',
    'done'
);


ALTER TYPE public.meet_status OWNER TO vagrant;

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
\.


--
-- Name: athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.athletes_id_seq', 457, true);


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
\.


--
-- Name: entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.entries_id_seq', 1011, true);


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
\.


--
-- Name: meet_division_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.meet_division_events_id_seq', 108, true);


--
-- Data for Name: meets; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.meets (id, name, date, host_school_id, description, status, max_entries_per_athlete, max_team_entries_per_event) FROM stdin;
1	WVAL League Practice Meet #1	2019-04-15 00:00:00	\N	 Meet starts at 3pm, at Los Gatos High School.\n                        	accepting_entries	\N	\N
\.


--
-- Name: meets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.meets_id_seq', 1, true);


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.schools (id, abbrev, name, city, state) FROM stdin;
1	UNA	Unattached	\N	\N
2	ANZR	Anzar (Aromas-San Juan)	\N	\N
3	CARM	Carmel	\N	\N
4	GBK	GB Kirby	\N	\N
5	GONZ	Gonzales	\N	\N
6	GRNF	Greenfield	\N	\N
7	KICI	King City	\N	\N
8	MaHS	Marina	\N	\N
9	OAKW	Oakwood	\N	\N
10	PCS	Pacific Collegiate	\N	\N
11	PAGR	Pacific Grove	\N	\N
12	SCAT	Santa Catalina	\N	\N
13	SOLE	Soledad	\N	\N
14	STEV	Stevenson	\N	\N
15	YORK	The York School	\N	\N
\.


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.schools_id_seq', 15, true);


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
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

