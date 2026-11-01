--
-- PostgreSQL database dump
--

\restrict 5GhoQh7KBZk81stl7Eb3reQHydLKUuZcD1v0BUiFFXQAmfnh8yo8W6pf9vjqfc9

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-11-01 04:03:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16901)
-- Name: characters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.characters (
    character_id integer NOT NULL,
    character_name character varying(100) NOT NULL,
    rarity integer,
    character_element character varying(20),
    weapon_type character varying(50),
    region character varying(50),
    model_type character varying(50),
    birthday character varying(50),
    special_dish character varying(50),
    ascension_stat character varying(50),
    release_version character varying(10),
    release_date date
);


ALTER TABLE public.characters OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16910)
-- Name: talents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.talents (
    talent_id integer NOT NULL,
    character_id integer NOT NULL,
    talent_name character varying(100) NOT NULL,
    talent_type character varying(30)
);


ALTER TABLE public.talents OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16924)
-- Name: character_talents; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.character_talents AS
 SELECT c.character_name,
    t.talent_name,
    t.talent_type
   FROM (public.talents t
     JOIN public.characters c ON ((t.character_id = c.character_id)));


ALTER VIEW public.character_talents OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16900)
-- Name: characters_character_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.characters_character_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.characters_character_id_seq OWNER TO postgres;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 219
-- Name: characters_character_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.characters_character_id_seq OWNED BY public.characters.character_id;


--
-- TOC entry 221 (class 1259 OID 16909)
-- Name: talents_talent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.talents_talent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.talents_talent_id_seq OWNER TO postgres;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 221
-- Name: talents_talent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.talents_talent_id_seq OWNED BY public.talents.talent_id;


--
-- TOC entry 4865 (class 2604 OID 16904)
-- Name: characters character_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters ALTER COLUMN character_id SET DEFAULT nextval('public.characters_character_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 16913)
-- Name: talents talent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.talents ALTER COLUMN talent_id SET DEFAULT nextval('public.talents_talent_id_seq'::regclass);


--
-- TOC entry 5021 (class 0 OID 16901)
-- Dependencies: 220
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.characters (character_id, character_name, rarity, character_element, weapon_type, region, model_type, birthday, special_dish, ascension_stat, release_version, release_date) FROM stdin;
1	Hu Tao	5	Pyro	Polearm	Liyue	Medium Female	15.7.	Ghostly March	Crit DMG	1.3	2021-03-02
3	Columbina	5	Hydro	Catalyst	Nod-Krai	Medium Female	14.1.	Moonlit Mirage	Crit Rate	Luna IV	2026-01-14
4	Furina	5	Hydro	Sword	Fontaine	Medium Female	13.10.	Pour la Justice	Crit Rate	4.2	2023-11-08
6	Yoimiya	5	Pyro	Bow	Inazuma	Medium Female	21.6.	Summer Festival Fish	Crit Rate	2.0	2021-08-10
7	Sangonomiya Kokomi	5	Hydro	Catalyst	Inazuma	Medium Female	22.2.	A Stunning Stratagem	Hydro DMG Bonus	2.1	2021-09-21
10	Klee	5	Pyro	Catalyst	Mondstadt	Short Female	27.7.	Fish-Flavored Toast	Pyro DMG Bonus	1.0	2020-10-20
13	Qiqi	5	Cryo	Sword	Liyue	Short Female	3.3.	No Tomorrow	Healing Bonus	1.0	2020-09-28
14	Chiori	5	Geo	Sword	Inazuma	Medium Female	17.8.	Fashion Show	Crit Rate	4.5	2024-03-13
15	Neuvillette	5	Hydro	Catalyst	Fontaine	Tall Male	18.12.	Consomme Purete	Crit DMG	4.1	2023-09-27
5	Sandrone	5	Cryo	Claymore	Snezhnaya	Medium Female	13.1.	Tea Party Polyphony	Crit Rate	Luna VIII	2026-07-01
2	Zibai	5	Geo	Sword	Liyue	Tall Female	15.5.	Flavor of Spring	Crit DMG	Luna IV	2026-02-03
9	Vesna	5	Anemo	Sword	Snezhnaya	\N	4.2.	Hoarfrost Soup	Crit DMG	7.1	2026-09-23
8	Linnea	5	Geo	Bow	Nod-Krai	Medium Female	23.5.	Iridescence Under the Tree's Shade	Crit Rate	Luna VI	2026-04-08
11	Nicole	5	Pyro	Catalyst	\N	Tall Female	29.9.	Gilded Chest	ATK%	Luna VII	2026-05-20
12	Durin	5	Pyro	Sword	Mondstadt	Medium Male	14.3.	Apple Stew (Trial Version)	Crit DMG	Luna III	2025-12-03
\.


--
-- TOC entry 5023 (class 0 OID 16910)
-- Dependencies: 222
-- Data for Name: talents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.talents (talent_id, character_id, talent_name, talent_type) FROM stdin;
1	1	Secret Spear of Wangsheng	Normal Attack
2	1	Guide to Afterlife	Elemental Skill
3	1	Spirit Soother	Elemental Burst
4	3	Moonlit Melancholy	Elemental Burst
5	3	Eternal Tides	Elemental Skill
6	3	Moondew Cascade	Normal Attack
7	4	Let the People Rejoice	Elemental Burst
8	4	Salon Solitaire	Elemental Skill
9	4	Soloist's Solicitation	Normal Attack
10	6	Ryuukin Saxifrage	Elemental Burst
11	6	Niwabi Fire-Dance	Elemental Skill
12	6	Firework Flare-Up	Normal Attack
13	7	Nereid's Ascension	Elemental Burst
14	7	Kurage's Oath	Elemental Skill
15	7	The Shape of Water	Normal Attack
16	10	Sparks 'n' Splash	Elemental Burst
17	10	Jumpy Dumpty	Elemental Skill
18	10	Kaboom!	Normal Attack
19	13	Adeptus Art: Preserver of Fortune	Elemental Burst
20	13	Adeptus Art: Herald of Frost	Elemental Skill
21	13	Ancient Sword Art	Normal Attack
22	14	Hiyoku: Twin Blades	Elemental Burst
23	14	Fluttering Hasode	Elemental Skill
24	14	Weaving Blade	Normal Attack
25	15	O Tides, I Have Returned	Elemental Burst
26	15	O Tears, I Shall Repay	Elemental Skill
27	15	As Water Seeks Equilibrium	Normal Attack
28	5	Formule Phenomenale: Q.E.D.	Elemental Burst
29	5	Formule Phenomenale: Differential Analysis	Elemental Skill
30	5	Formule Phenomenale: Self-Evident Proposition	Normal Attack
31	2	Tri-Sphere Eminence	Elemental Burst
32	2	Heaven and Earth Made Manifest	Elemental Skill
33	2	Golden Blade's Petaled Touch	Normal Attack
34	9	For the Tsaritsa!	Elemental Burst
35	9	The Art of Victory	Elemental Skill
36	9	Vila Blade Dance	Normal Attack
37	8	Memo: Survival Guide in Extreme Conditions	Elemental Burst
38	8	Countermeasure: Lumi's Battle Cry!	Elemental Skill
39	8	Capture Protocol	Normal Attack
40	11	Revelation: Ladder of Divine Ascent	Elemental Burst
41	11	Revelation: Uncreated Light	Elemental Skill
42	11	Allegoria	Normal Attack
43	12	Principle of Purity: As the Light Shifts	Elemental Burst
44	12	Binary Form: Convergence and Division	Elemental Skill
45	12	Radiant Wingslash	Normal Attack
\.


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 219
-- Name: characters_character_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.characters_character_id_seq', 15, true);


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 221
-- Name: talents_talent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.talents_talent_id_seq', 45, true);


--
-- TOC entry 4868 (class 2606 OID 16908)
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (character_id);


--
-- TOC entry 4870 (class 2606 OID 16918)
-- Name: talents talents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.talents
    ADD CONSTRAINT talents_pkey PRIMARY KEY (talent_id);


--
-- TOC entry 4871 (class 2606 OID 16919)
-- Name: talents talents_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.talents
    ADD CONSTRAINT talents_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id);


-- Completed on 2026-11-01 04:03:43

--
-- PostgreSQL database dump complete
--

\unrestrict 5GhoQh7KBZk81stl7Eb3reQHydLKUuZcD1v0BUiFFXQAmfnh8yo8W6pf9vjqfc9

