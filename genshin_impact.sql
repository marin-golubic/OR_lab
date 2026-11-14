--
-- PostgreSQL database dump
--

\restrict ifgBbvcPP78jBpCIMyGpMgKKJqRVtQgb1H33E7N6AxEm2ujg4Q9ghQTiMbEVNYR

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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
-- Name: artifacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artifacts (
    artifact_id integer NOT NULL,
    artifact_name character varying(100) NOT NULL,
    domain_id integer
);


ALTER TABLE public.artifacts OWNER TO postgres;

--
-- Name: artifacts_artifact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artifacts_artifact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artifacts_artifact_id_seq OWNER TO postgres;

--
-- Name: artifacts_artifact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artifacts_artifact_id_seq OWNED BY public.artifacts.artifact_id;


--
-- Name: character_artifacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.character_artifacts (
    character_id integer NOT NULL,
    artifact_id integer NOT NULL
);


ALTER TABLE public.character_artifacts OWNER TO postgres;

--
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
-- Name: character_weapons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.character_weapons (
    character_id integer NOT NULL,
    weapon_id integer NOT NULL
);


ALTER TABLE public.character_weapons OWNER TO postgres;

--
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
-- Name: characters_character_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.characters_character_id_seq OWNED BY public.characters.character_id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domains (
    domain_id integer NOT NULL,
    domain_name character varying(100) NOT NULL,
    region character varying(50) NOT NULL,
    domain_type character varying(30) NOT NULL,
    CONSTRAINT domains_domain_type_check CHECK (((domain_type)::text = ANY ((ARRAY['Artifact'::character varying, 'Weapon Ascension'::character varying])::text[])))
);


ALTER TABLE public.domains OWNER TO postgres;

--
-- Name: domains_domain_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.domains_domain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.domains_domain_id_seq OWNER TO postgres;

--
-- Name: domains_domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.domains_domain_id_seq OWNED BY public.domains.domain_id;


--
-- Name: weapon_ascension_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weapon_ascension_materials (
    material_id integer NOT NULL,
    material_name character varying(100) NOT NULL,
    domain_id integer NOT NULL
);


ALTER TABLE public.weapon_ascension_materials OWNER TO postgres;

--
-- Name: weapons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weapons (
    weapon_id integer NOT NULL,
    weapon_name character varying(100) NOT NULL,
    weapon_type character varying(30) NOT NULL,
    rarity integer NOT NULL,
    base_attack integer,
    secondary_stat character varying(50),
    material_id integer,
    CONSTRAINT weapons_rarity_check CHECK (((rarity >= 1) AND (rarity <= 5)))
);


ALTER TABLE public.weapons OWNER TO postgres;

--
-- Name: genshin_dataset_export; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.genshin_dataset_export AS
 SELECT character_id,
    character_name,
    rarity,
    character_element,
    weapon_type,
    region,
    model_type,
    birthday,
    special_dish,
    ascension_stat,
    release_version,
    release_date,
    COALESCE(( SELECT jsonb_agg(jsonb_build_object('talent_id', t.talent_id, 'talent_name', t.talent_name, 'talent_type', t.talent_type) ORDER BY t.talent_id) AS jsonb_agg
           FROM public.talents t
          WHERE (t.character_id = c.character_id)), '[]'::jsonb) AS talents,
    COALESCE(( SELECT jsonb_agg(jsonb_build_object('artifact_id', a.artifact_id, 'artifact_name', a.artifact_name, 'domain_name', d.domain_name, 'domain_region', d.region) ORDER BY a.artifact_name) AS jsonb_agg
           FROM ((public.character_artifacts ca
             JOIN public.artifacts a ON ((a.artifact_id = ca.artifact_id)))
             LEFT JOIN public.domains d ON ((d.domain_id = a.domain_id)))
          WHERE (ca.character_id = c.character_id)), '[]'::jsonb) AS artifacts,
    COALESCE(( SELECT jsonb_agg(jsonb_build_object('weapon_id', w.weapon_id, 'weapon_name', w.weapon_name, 'weapon_type', w.weapon_type, 'rarity', w.rarity, 'base_attack', w.base_attack, 'secondary_stat', w.secondary_stat, 'material_name', m.material_name, 'material_domain', dm.domain_name, 'material_region', dm.region) ORDER BY w.weapon_name) AS jsonb_agg
           FROM (((public.character_weapons cw
             JOIN public.weapons w ON ((w.weapon_id = cw.weapon_id)))
             LEFT JOIN public.weapon_ascension_materials m ON ((m.material_id = w.material_id)))
             LEFT JOIN public.domains dm ON ((dm.domain_id = m.domain_id)))
          WHERE (cw.character_id = c.character_id)), '[]'::jsonb) AS weapons
   FROM public.characters c;


ALTER VIEW public.genshin_dataset_export OWNER TO postgres;

--
-- Name: genshin_dataset_export_ordered; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.genshin_dataset_export_ordered AS
 SELECT character_name,
    character_element,
    region,
    rarity,
    weapon_type,
    birthday,
    model_type,
    COALESCE(( SELECT json_agg(json_build_object('weapon_name', w.weapon_name, 'weapon_type', w.weapon_type, 'rarity', w.rarity, 'base_attack', w.base_attack, 'secondary_stat', w.secondary_stat, 'material_name', m.material_name, 'material_domain', dm.domain_name, 'material_region', dm.region, 'weapon_id', w.weapon_id) ORDER BY w.weapon_name) AS json_agg
           FROM (((public.character_weapons cw
             JOIN public.weapons w ON ((w.weapon_id = cw.weapon_id)))
             LEFT JOIN public.weapon_ascension_materials m ON ((m.material_id = w.material_id)))
             LEFT JOIN public.domains dm ON ((dm.domain_id = m.domain_id)))
          WHERE (cw.character_id = c.character_id)), '[]'::json) AS weapons,
    COALESCE(( SELECT json_agg(json_build_object('talent_name', t.talent_name, 'talent_type', t.talent_type, 'talent_id', t.talent_id) ORDER BY t.talent_id) AS json_agg
           FROM public.talents t
          WHERE (t.character_id = c.character_id)), '[]'::json) AS talents,
    COALESCE(( SELECT json_agg(json_build_object('artifact_name', a.artifact_name, 'domain_name', d.domain_name, 'domain_region', d.region, 'artifact_id', a.artifact_id) ORDER BY a.artifact_name) AS json_agg
           FROM ((public.character_artifacts ca
             JOIN public.artifacts a ON ((a.artifact_id = ca.artifact_id)))
             LEFT JOIN public.domains d ON ((d.domain_id = a.domain_id)))
          WHERE (ca.character_id = c.character_id)), '[]'::json) AS artifacts,
    special_dish,
    ascension_stat,
    release_version,
    release_date,
    character_id
   FROM public.characters c;


ALTER VIEW public.genshin_dataset_export_ordered OWNER TO postgres;

--
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
-- Name: talents_talent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.talents_talent_id_seq OWNED BY public.talents.talent_id;


--
-- Name: weapon_ascension_materials_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weapon_ascension_materials_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weapon_ascension_materials_material_id_seq OWNER TO postgres;

--
-- Name: weapon_ascension_materials_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weapon_ascension_materials_material_id_seq OWNED BY public.weapon_ascension_materials.material_id;


--
-- Name: weapons_weapon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weapons_weapon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weapons_weapon_id_seq OWNER TO postgres;

--
-- Name: weapons_weapon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weapons_weapon_id_seq OWNED BY public.weapons.weapon_id;


--
-- Name: artifacts artifact_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artifacts ALTER COLUMN artifact_id SET DEFAULT nextval('public.artifacts_artifact_id_seq'::regclass);


--
-- Name: characters character_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters ALTER COLUMN character_id SET DEFAULT nextval('public.characters_character_id_seq'::regclass);


--
-- Name: domains domain_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains ALTER COLUMN domain_id SET DEFAULT nextval('public.domains_domain_id_seq'::regclass);


--
-- Name: talents talent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.talents ALTER COLUMN talent_id SET DEFAULT nextval('public.talents_talent_id_seq'::regclass);


--
-- Name: weapon_ascension_materials material_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapon_ascension_materials ALTER COLUMN material_id SET DEFAULT nextval('public.weapon_ascension_materials_material_id_seq'::regclass);


--
-- Name: weapons weapon_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapons ALTER COLUMN weapon_id SET DEFAULT nextval('public.weapons_weapon_id_seq'::regclass);


--
-- Data for Name: artifacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artifacts (artifact_id, artifact_name, domain_id) FROM stdin;
43	Gladiator's Finale	\N
44	Wanderer's Troupe	\N
40	Silken Moon's Serenade	1
39	Night of the Sky's Unveiling	1
36	Scroll of the Hero of Cinder City	2
35	Obsidian Codex	2
8	Disenchantment in Deep Shadow	3
7	Celestial Gift	3
2	Thundersoother	4
1	Thundering Fury	4
38	Finale of the Deep Galleries	5
37	Long Night's Oath	5
24	Gilded Dreams	6
23	Deepwood Memories	6
12	Lavawalker	7
11	Crimson Witch of Flames	7
4	Maiden Beloved	8
3	Viridescent Venerer	8
42	A Day Carved From Rising Winds	9
41	Aubade of Morningstar and Moon	9
6	Heart of Depth	10
5	Blizzard Strayer	10
30	Golden Troupe	11
29	Marechaussee Hunter	11
26	Flower of Paradise Lost	12
25	Desert Pavilion Chronicle	12
18	Echoes of an Offering	13
17	Vermillion Hereafter	13
28	Vourukasha's Glow	14
27	Nymph's Dream	14
32	Nighttime Whispers in the Echoing Woods	15
31	Song of Days Past	15
34	Unfinished Reverie	16
33	Fragment of Harmonic Whimsy	16
22	Ocean-Hued Clam	17
21	Husk of Opulent Dreams	17
14	Noblesse Oblige	18
13	Bloodstained Chivalry	18
20	Shimenawa's Reminiscence	19
19	Emblem of Severed Fate	19
10	Retracing Bolide	20
9	Archaic Petra	20
16	Pale Flame	21
15	Tenacity of the Millelith	21
45	Scarlet Proof	22
46	Heart of the Furnace	22
\.


--
-- Data for Name: character_artifacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.character_artifacts (character_id, artifact_id) FROM stdin;
1	20
1	11
4	30
7	15
7	22
10	11
15	29
20	3
23	19
32	3
33	19
34	19
36	15
45	3
49	24
49	19
58	19
67	24
67	23
3	41
3	40
2	21
2	39
9	45
9	3
\.


--
-- Data for Name: character_weapons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.character_weapons (character_id, weapon_id) FROM stdin;
1	1
49	2
67	3
4	4
15	5
7	6
45	7
58	8
20	9
36	10
10	11
2	12
9	13
3	14
\.


--
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
16	Diluc	5	Pyro	Claymore	Mondstadt	Tall Male	30.4.	Once Upon a Time in Mondstadt	Crit Rate	1.0	2020-09-28
17	Jean	5	Anemo	Sword	Mondstadt	Tall Female	14.3.	Invigorating Pizza	Healing Bonus	1.0	2020-09-28
18	Keqing	5	Electro	Sword	Liyue	Medium Female	20.11.	Survival Grilled Fish	Crit DMG	1.0	2020-09-28
19	Mona	5	Hydro	Catalyst	Mondstadt	Medium Female	31.8.	Der Weisheit Letzter Schluss	Energy Recharge	1.0	2020-09-28
20	Venti	5	Anemo	Bow	Mondstadt	Medium Male	16.6.	A Buoyant Breeze	Energy Recharge	1.0	2020-09-28
21	Amber	4	Pyro	Bow	Mondstadt	Medium Female	10.8.	Outrider's Champion Steak!	ATK	1.0	2020-09-28
22	Barbara	4	Hydro	Catalyst	Mondstadt	Medium Female	5.7.	Spicy Stew	HP	1.0	2020-09-28
23	Beidou	4	Electro	Claymore	Liyue	Tall Female	14.2.	Flash-Fried Filet	Electro DMG Bonus	1.0	2020-09-28
24	Bennett	4	Pyro	Sword	Mondstadt	Medium Male	29.2.	Teyvat Charred Egg	Energy Recharge	1.0	2020-09-28
25	Chongyun	4	Cryo	Claymore	Liyue	Medium Male	7.9.	Cold Noodles with Mountain Delicacies	ATK	1.0	2020-09-28
26	Fischl	4	Electro	Bow	Mondstadt	Medium Female	27.5.	Die Heilige Sinfonie	ATK	1.0	2020-09-28
27	Kaeya	4	Cryo	Sword	Mondstadt	Tall Male	30.11.	Fruity Skewers	Energy Recharge	1.0	2020-09-28
28	Lisa	4	Electro	Catalyst	Mondstadt	Tall Female	9.6.	Mysterious Bolognese	Elemental Mastery	1.0	2020-09-28
29	Ningguang	4	Geo	Catalyst	Liyue	Tall Female	26.8.	Qiankun Mora Meat	Geo DMG Bonus	1.0	2020-09-28
30	Noelle	4	Geo	Claymore	Mondstadt	Medium Female	21.3.	Lighter-Than-Air Pancake	DEF	1.0	2020-09-28
31	Razor	4	Electro	Claymore	Mondstadt	Medium Male	9.9.	Puppy-Paw Hash Brown	Physical DMG Bonus	1.0	2020-09-28
32	Sucrose	4	Anemo	Catalyst	Mondstadt	Medium Female	26.11.	Nutritious Meal (V. 593)	Anemo DMG Bonus	1.0	2020-09-28
33	Xiangling	4	Pyro	Polearm	Liyue	Medium Female	2.11.	Wanmin Restaurant's Boiled Fish	Elemental Mastery	1.0	2020-09-28
34	Xingqiu	4	Hydro	Sword	Liyue	Medium Male	9.10.	All-Delicacy Parcels	ATK	1.0	2020-09-28
35	Tartaglia	5	Hydro	Bow	Snezhnaya	Tall Male	20.7.	A Prize Catch	Hydro DMG Bonus	1.1	2020-11-11
36	Zhongli	5	Geo	Polearm	Liyue	Tall Male	31.12.	Slow-Cooked Bamboo Shoot Soup	Geo DMG Bonus	1.1	2020-11-11
37	Diona	4	Cryo	Bow	Mondstadt	Short Female	18.1.	Definitely Not Bar Food!	Cryo DMG Bonus	1.1	2020-11-11
38	Xinyan	4	Pyro	Claymore	Liyue	Medium Female	16.10.	Rockin' Riffin' Chicken!	ATK	1.1	2020-11-11
39	Albedo	5	Geo	Sword	Mondstadt	Tall Male	13.9.	Woodland Dream	Geo DMG Bonus	1.2	2020-12-23
40	Ganyu	5	Cryo	Bow	Liyue	Medium Female	2.12.	Prosperous Peace	Crit DMG	1.2	2020-12-23
41	Xiao	5	Anemo	Polearm	Liyue	Medium Male	17.4.	Sweet Dream	Crit Rate	1.3	2021-02-03
42	Rosaria	4	Cryo	Polearm	Mondstadt	Tall Female	24.1.	Dinner of Judgment	ATK	1.4	2021-03-17
43	Eula	5	Cryo	Claymore	Mondstadt	Tall Female	25.10.	Stormcrest Pie	Crit DMG	1.5	2021-04-28
44	Yanfei	4	Pyro	Catalyst	Liyue	Medium Female	28.7.	My Way	Pyro DMG Bonus	1.5	2021-04-28
45	Kaedehara Kazuha	5	Anemo	Sword	Inazuma	Medium Male	29.10.	All-Weather Beauty	Elemental Mastery	1.6	2021-06-09
46	Kamisato Ayaka	5	Cryo	Sword	Inazuma	Medium Female	28.9.	Snow on the Hearth	Crit DMG	2.0	2021-07-21
47	Sayu	4	Anemo	Claymore	Inazuma	Short Female	19.10.	Dizziness-Be-Gone no Jutsu Version 2.0	Elemental Mastery	2.0	2021-07-21
48	Aloy	5	Cryo	Bow	\N	Tall Female	\N	\N	\N	2.1	2021-09-01
49	Raiden Shogun	5	Electro	Polearm	Inazuma	Tall Female	26.6.	\N	Energy Recharge	2.1	2021-09-01
50	Kujou Sara	4	Electro	Bow	Inazuma	Tall Female	14.7.	Faith Eternal	ATK	2.1	2021-09-01
51	Thoma	4	Pyro	Polearm	Inazuma	Tall Male	9.1.	Warmth	ATK	2.2	2021-10-13
52	Arataki Itto	5	Geo	Claymore	Inazuma	Tall Male	1.6.	Way of the Strong	Crit Rate	2.3	2021-11-24
53	Gorou	4	Geo	Bow	Inazuma	Medium Male	18.5.	Victorious Legend	Geo DMG Bonus	2.3	2021-11-24
54	Shenhe	5	Cryo	Polearm	Liyue	Tall Female	10.3.	Heartstring Noodles	ATK	2.4	2022-01-05
55	Yun Jin	4	Geo	Polearm	Liyue	Medium Female	21.5.	Cloud-Shrouded Jade	Energy Recharge	2.4	2022-01-05
56	Yae Miko	5	Electro	Catalyst	Inazuma	Tall Female	27.6.	Fukuuchi Udon	Crit Rate	2.5	2022-02-16
57	Kamisato Ayato	5	Hydro	Sword	Inazuma	Tall Male	26.3.	Quiet Elegance	Crit DMG	2.6	2022-03-30
58	Yelan	5	Hydro	Bow	Liyue	Tall Female	20.4.	Dew-Dipped Shrimp	Crit Rate	2.7	2022-05-31
59	Kuki Shinobu	4	Electro	Sword	Inazuma	Medium Female	27.7.	Omurice Waltz	HP	2.7	2022-05-31
60	Shikanoin Heizou	4	Anemo	Catalyst	Inazuma	Medium Male	24.7.	The Only Truth	Anemo DMG Bonus	2.8	2022-07-13
61	Tighnari	5	Dendro	Bow	Sumeru	Medium Male	29.12.	Forest Watcher's Choice	Dendro DMG Bonus	3.0	2022-08-24
62	Collei	4	Dendro	Bow	Sumeru	Medium Female	8.5.	Yearning	ATK	3.0	2022-08-24
63	Dori	4	Electro	Claymore	Sumeru	Short Female	21.12.	Show Me the Mora	HP	3.0	2022-08-24
64	Cyno	5	Electro	Polearm	Sumeru	Medium Male	23.6.	Duel Soul	Crit DMG	3.1	2022-09-28
65	Nilou	5	Hydro	Sword	Sumeru	Medium Female	3.12.	Swirling Steps	HP	3.1	2022-09-28
66	Candace	4	Hydro	Polearm	Sumeru	Tall Female	3.5.	Utmost Care	HP	3.1	2022-09-28
67	Nahida	5	Dendro	Catalyst	Sumeru	Short Female	27.10.	Halvamazd	Elemental Mastery	3.2	2022-11-02
68	Layla	4	Cryo	Sword	Sumeru	Medium Female	19.12.	Extravagant Slumber	HP	3.2	2022-11-02
69	Wanderer	5	Anemo	Catalyst	Sumeru	Medium Male	3.1.	Shimi Chazuke	Crit Rate	3.3	2022-12-07
70	Faruzan	4	Anemo	Bow	Sumeru	Medium Female	20.8.	Traditionally-Made Charcoal-Baked Ajilenakh Cake	ATK	3.3	2022-12-07
71	Alhaitham	5	Dendro	Sword	Sumeru	Tall Male	11.2.	Ideal Circumstance	Dendro DMG Bonus	3.4	2023-01-18
72	Yaoyao	4	Dendro	Polearm	Liyue	Short Female	6.3.	Qingce Household Dish	HP	3.4	2023-01-18
73	Dehya	5	Pyro	Claymore	Sumeru	Tall Female	7.4.	Goldflame Tajine	HP	3.5	2023-03-01
74	Mika	4	Cryo	Polearm	Mondstadt	Short Male	11.8.	Surveyor's Breakfast Sandwich	HP	3.5	2023-03-01
75	Baizhu	5	Dendro	Catalyst	Liyue	Tall Male	25.4.	Heat-Quelling Soup	HP	3.6	2023-04-12
76	Kaveh	4	Dendro	Claymore	Sumeru	Medium Male	9.7.	The Endeavor	Elemental Mastery	3.6	2023-04-12
77	Kirara	4	Dendro	Sword	Inazuma	Medium Female	22.1.	Energizing Bento	HP	3.7	2023-05-24
78	Lyney	5	Pyro	Bow	Fontaine	Medium Male	2.2.	Cubic Tricks	Crit Rate	4.0	2023-08-16
79	Freminet	4	Cryo	Claymore	Fontaine	Medium Male	24.9.	Seabird's Sojourn	ATK	4.0	2023-08-16
80	Lynette	4	Anemo	Sword	Fontaine	Medium Female	2.2.	A Leisurely Sip	Anemo DMG Bonus	4.0	2023-08-16
81	Wriothesley	5	Cryo	Catalyst	Fontaine	Tall Male	23.11.	Secret Sauce BBQ Ribs	Crit DMG	4.1	2023-09-27
82	Charlotte	4	Cryo	Catalyst	Fontaine	Medium Female	10.4.	Exclusive Scoop: Gourmet Column	ATK	4.2	2023-11-08
83	Navia	5	Geo	Claymore	Fontaine	Tall Female	16.8.	Pick What You Like!	Crit DMG	4.3	2023-12-20
84	Chevreuse	4	Pyro	Polearm	Fontaine	Medium Female	10.1.	Sin: The Kind That Doesn't Need to Be Dealt With	HP	4.3	2023-12-20
85	Xianyun	5	Anemo	Catalyst	Liyue	Tall Female	11.4.	Encompassing Gladness	ATK	4.4	2024-01-31
86	Gaming	4	Pyro	Claymore	Liyue	Medium Male	22.12.	Yummy Yum Cha	ATK	4.4	2024-01-31
87	Arlecchino	5	Pyro	Polearm	Snezhnaya	Tall Female	22.8.	Hearthfire's Trail	Crit DMG	4.6	2024-04-24
88	Clorinde	5	Electro	Sword	Fontaine	Tall Female	20.9.	Tagged and Bagged	Crit Rate	4.7	2024-06-05
89	Sigewinne	5	Hydro	Bow	Fontaine	Short Female	30.3.	Well-Balanced Meal	HP	4.7	2024-06-05
90	Sethos	4	Electro	Bow	Sumeru	Medium Male	31.5.	Super-Dee-Duper Delicious Meat Roll	Elemental Mastery	4.7	2024-06-05
91	Emilie	5	Dendro	Polearm	Fontaine	Tall Female	22.9.	A Fragrant Feast	Crit DMG	4.8	2024-07-17
92	Kinich	5	Dendro	Claymore	Natlan	Tall Male	11.11.	Saurian Hunter's Reward	Crit DMG	5.0	2024-08-28
93	Mualani	5	Hydro	Catalyst	Natlan	Medium Female	12.8.	Pass the Luck	Crit Rate	5.0	2024-08-28
94	Kachina	4	Geo	Polearm	Natlan	Short Female	22.4.	Impeccably Organized	Geo DMG Bonus	5.0	2024-08-28
95	Xilonen	5	Geo	Sword	Natlan	Tall Female	13.3.	Fruit-Flavored Milk Candies	DEF	5.1	2024-10-09
96	Chasca	5	Anemo	Bow	Natlan	Tall Female	10.12.	Moment of Respite	Crit Rate	5.2	2024-11-20
97	Ororon	4	Electro	Bow	Natlan	Tall Male	14.10.	Honey-Glazed Ceviche	ATK	5.2	2024-11-20
98	Citlali	5	Cryo	Catalyst	Natlan	Tall Female	20.1.	Secret Art	Elemental Mastery	5.3	2025-01-01
99	Mavuika	5	Pyro	Claymore	Natlan	Tall Female	28.8.	Grilled in Glaze	Crit DMG	5.3	2025-01-01
100	Lan Yan	4	Anemo	Catalyst	Liyue	Medium Female	6.1.	Jade Veiled Chicken	ATK	5.3	2025-01-01
101	Yumemizuki Mizuki	5	Anemo	Catalyst	Inazuma	Medium Female	16.3.	Dreams of Healing	Elemental Mastery	5.4	2025-02-12
102	Varesa	5	Electro	Catalyst	Natlan	Tall Female	10.1.	Gold-Standard Healthy Meal	Crit Rate	5.5	2025-03-26
103	Iansan	4	Electro	Polearm	Natlan	Short Female	8.8.	Power Shake	ATK	5.5	2025-03-26
104	Escoffier	5	Cryo	Polearm	Fontaine	Tall Female	8.6.	Lullaby of the Sea	Crit Rate	5.6	2025-05-07
105	Ifa	4	Anemo	Catalyst	Natlan	Tall Male	23.3.	Emotion Support	Elemental Mastery	5.6	2025-05-07
106	Skirk	5	Cryo	Sword	Other	Tall Female	5.11.	Abyssal Bounty	Crit DMG	5.7	2025-06-18
107	Dahlia	4	Hydro	Sword	Mondstadt	Medium Male	25.5.	Sombre Silver	HP	5.7	2025-06-18
108	Ineffa	5	Electro	Polearm	Nod-Krai	Medium Female	2.4.	Thunderclap Blitz	Crit Rate	5.8	2025-07-30
109	Flins	5	Electro	Polearm	Nod-Krai	Tall Male	31.10.	Long Night Alight	Crit DMG	Luna I	2025-09-10
110	Lauma	5	Dendro	Catalyst	Nod-Krai	Tall Female	1.3.	Whisper in the Woods	Elemental Mastery	Luna I	2025-09-10
111	Aino	4	Hydro	Claymore	Nod-Krai	Medium Female	21.9.	Clink-Clank Confectionary Cup	Elemental Mastery	Luna I	2025-09-10
112	Nefer	5	Dendro	Catalyst	Nod-Krai	Medium Female	9.5.	Secrets Exchanged	Crit DMG	Luna II	2025-10-22
113	Jahoda	4	Anemo	Bow	Nod-Krai	Medium Female	5.1.	After-Class Practice	Healing Bonus	Luna III	2025-12-03
114	Illuga	4	Geo	Polearm	Nod-Krai	Medium Male	23.12.	Nightwatch Soup	Elemental Mastery	Luna IV	2026-01-14
115	Varka	5	Anemo	Claymore	Mondstadt	Tall Male	17.2.	Hearty Indulgence	Crit DMG	Luna V	2026-02-25
116	Lohen	5	Cryo	Polearm	Mondstadt	Medium Male	3.4.	Boredom-Busting Bubblegum	Crit DMG	Luna VII	2026-05-20
117	Prune	4	Anemo	Catalyst	Mondstadt	Short Female	20.11.	Spinning Special	ATK	Luna VII	2026-05-20
118	Odette	5	Cryo	Sword	Snezhnaya	Medium Female	20.2.	Lakeside Snow Swan	Crit DMG	7.0	2026-08-12
119	Alyosha	4	Electro	Polearm	Snezhnaya	Medium Male	9.2.	The Bullseye Roast	Energy Recharge	7.0	2026-08-12
120	Vodyanitsa	5	Hydro	Catalyst	Snezhnaya	Medium Female	29.3.	Iridescent Aria	HP	7.1	2026-09-23
121	Mitya	5	Electro	Catalyst	Snezhnaya	Medium Male	8.2.	Energy-Replenishing Meal	Crit DMG	7.2	2026-11-04
122	Valeriy	4	Electro	Sword	Snezhnaya	Tall Male	24.3.	Emergency Barricade	ATK	7.2	2026-11-04
123	Aether	5	\N	Sword	\N	Medium Male	\N	\N	\N	1.0	2020-09-28
124	Lumine	5	\N	Sword	\N	Medium Female	\N	\N	\N	1.0	2020-09-28
\.


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domains (domain_id, domain_name, region, domain_type) FROM stdin;
1	Frostladen Machinery	Nod-Krai	Artifact
2	Sanctum of Rainbow Spirits	Natlan	Artifact
3	Thorny Crown of the Mountain Wind	Mondstadt	Artifact
4	Midsummer Courtyard	Mondstadt	Artifact
5	Derelict Masonry Dock	Natlan	Artifact
6	Spire of Solitary Enlightenment	Sumeru	Artifact
7	Hidden Palace of Zhou Formula	Liyue	Artifact
8	Valley of Remembrance	Mondstadt	Artifact
9	Moonchild's Treasures	Nod-Krai	Artifact
10	Peak of Vindagnyr	Mondstadt	Artifact
11	Denouement of Sin	Fontaine	Artifact
12	City of Gold	Sumeru	Artifact
13	The Lost Valley	Liyue	Artifact
14	Molten Iron Fortress	Sumeru	Artifact
15	Waterfall Wen	Fontaine	Artifact
16	Faded Theater	Fontaine	Artifact
17	Slumbering Court	Inazuma	Artifact
18	Clear Pool and Mountain Cavern	Liyue	Artifact
19	Momiji-Dyed Court	Inazuma	Artifact
20	Domain of Guyun	Liyue	Artifact
21	Ridge Watch	Liyue	Artifact
22	Inverted Glacier	Snezhnaya	Artifact
23	Cecilia Garden	Mondstadt	Weapon Ascension
24	Hidden Palace of Lianshan Formula	Liyue	Weapon Ascension
25	Court of Flowing Sand	Inazuma	Weapon Ascension
26	Tower of Abject Pride	Sumeru	Weapon Ascension
27	Echoes of the Deep Tides	Fontaine	Weapon Ascension
28	Ancient Watchtower	Natlan	Weapon Ascension
29	Lost Mooncourt	Nod-Krai	Weapon Ascension
30	Scars of Cursed Obsession	Snezhnaya	Weapon Ascension
\.


--
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
-- Data for Name: weapon_ascension_materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weapon_ascension_materials (material_id, material_name, domain_id) FROM stdin;
1	Ancient Chord	27
2	Narukami	25
3	Night-Wind	28
4	Blazing Sacrificial Heart	28
5	Far-North Scions	29
6	Goblet of the Pristine Sea	27
7	Dandelion Gladiator	23
8	Boreal Wolf	23
9	Sacred Lord	28
10	Oasis Garden	26
11	Guyun	24
12	Decarabian	23
13	Pale Star Army	30
14	Artful Device	29
15	Scorching Might	26
16	Distant Sea	25
17	Pure Sacred Dewdrop	27
18	Long Night Flint	29
19	Mist Veiled Elixir	24
20	Mask of the Kijin	25
21	The Frost Emperor	30
22	Cellared Spiritual Nectar	30
23	Talisman of the Forest Dew	26
24	Aerosiderite	24
\.


--
-- Data for Name: weapons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weapons (weapon_id, weapon_name, weapon_type, rarity, base_attack, secondary_stat, material_id) FROM stdin;
1	Staff of Homa	Polearm	5	608	CRIT DMG 66.2%	24
2	Engulfing Lightning	Polearm	5	608	Energy Recharge 55.1%	20
3	A Thousand Floating Dreams	Catalyst	5	542	Elemental Mastery 265	10
4	Splendor of Tranquil Waters	Sword	5	542	CRIT DMG 88.2%	17
5	Tome of the Eternal Flow	Catalyst	5	542	CRIT DMG 88.2%	17
6	Everlasting Moonglow	Catalyst	5	608	HP 49.6%	16
7	Freedom-Sworn	Sword	5	608	Elemental Mastery 198	7
8	Aqua Simulacra	Bow	5	542	CRIT DMG 88.2%	11
9	Elegy for the End	Bow	5	608	Energy Recharge 55.1%	8
10	Vortex Vanquisher	Polearm	5	608	ATK 49.6%	24
11	Dodoco Tales	Catalyst	4	454	ATK 55.1%	8
12	Lightbearing Moonshard	Sword	5	542	CRIT DMG 88.2%	24
13	Beyond the Chrysalis	Sword	5	674	CRIT DMG 44.1%	13
14	Nocturne's Curtain Call	Catalyst	5	542	CRIT DMG 88.2%	5
15	Favonius Sword	Sword	4	454	Energy Recharge 61.3%	12
16	Favonius Greatsword	Claymore	4	454	Energy Recharge 61.3%	7
17	Favonius Lance	Polearm	4	565	Energy Recharge 30.6%	7
18	Favonius Warbow	Bow	4	454	Energy Recharge 61.3%	7
19	Favonius Codex	Catalyst	4	510	Energy Recharge 45.9%	12
\.


--
-- Name: artifacts_artifact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artifacts_artifact_id_seq', 46, true);


--
-- Name: characters_character_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.characters_character_id_seq', 124, true);


--
-- Name: domains_domain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domains_domain_id_seq', 30, true);


--
-- Name: talents_talent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.talents_talent_id_seq', 45, true);


--
-- Name: weapon_ascension_materials_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weapon_ascension_materials_material_id_seq', 24, true);


--
-- Name: weapons_weapon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weapons_weapon_id_seq', 19, true);


--
-- Name: artifacts artifacts_artifact_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_artifact_name_key UNIQUE (artifact_name);


--
-- Name: artifacts artifacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_pkey PRIMARY KEY (artifact_id);


--
-- Name: character_artifacts character_artifacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_artifacts
    ADD CONSTRAINT character_artifacts_pkey PRIMARY KEY (character_id, artifact_id);


--
-- Name: character_weapons character_weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_weapons
    ADD CONSTRAINT character_weapons_pkey PRIMARY KEY (character_id, weapon_id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (character_id);


--
-- Name: domains domains_domain_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_domain_name_key UNIQUE (domain_name);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (domain_id);


--
-- Name: talents talents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.talents
    ADD CONSTRAINT talents_pkey PRIMARY KEY (talent_id);


--
-- Name: weapon_ascension_materials weapon_ascension_materials_material_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapon_ascension_materials
    ADD CONSTRAINT weapon_ascension_materials_material_name_key UNIQUE (material_name);


--
-- Name: weapon_ascension_materials weapon_ascension_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapon_ascension_materials
    ADD CONSTRAINT weapon_ascension_materials_pkey PRIMARY KEY (material_id);


--
-- Name: weapons weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (weapon_id);


--
-- Name: weapons weapons_weapon_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_weapon_name_key UNIQUE (weapon_name);


--
-- Name: character_artifacts character_artifacts_artifact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_artifacts
    ADD CONSTRAINT character_artifacts_artifact_id_fkey FOREIGN KEY (artifact_id) REFERENCES public.artifacts(artifact_id) ON DELETE CASCADE;


--
-- Name: character_artifacts character_artifacts_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_artifacts
    ADD CONSTRAINT character_artifacts_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id) ON DELETE CASCADE;


--
-- Name: character_weapons character_weapons_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_weapons
    ADD CONSTRAINT character_weapons_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id) ON DELETE CASCADE;


--
-- Name: character_weapons character_weapons_weapon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_weapons
    ADD CONSTRAINT character_weapons_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES public.weapons(weapon_id) ON DELETE CASCADE;


--
-- Name: artifacts fk_artifacts_domain; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT fk_artifacts_domain FOREIGN KEY (domain_id) REFERENCES public.domains(domain_id);


--
-- Name: talents talents_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.talents
    ADD CONSTRAINT talents_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id);


--
-- Name: weapon_ascension_materials weapon_ascension_materials_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapon_ascension_materials
    ADD CONSTRAINT weapon_ascension_materials_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(domain_id);


--
-- Name: weapons weapons_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.weapon_ascension_materials(material_id);


--
-- PostgreSQL database dump complete
--

\unrestrict ifgBbvcPP78jBpCIMyGpMgKKJqRVtQgb1H33E7N6AxEm2ujg4Q9ghQTiMbEVNYR

