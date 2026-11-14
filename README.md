# Genshin Impact Characters and Talents Dataset

## Opis skupa podataka

Ovaj otvoreni skup podataka sadrži informacije o igrivim likovima iz videoigre Genshin Impact, njihovim talentima, oružjima, preporučenim setovima artefakata, domenama i materijalima za uzdizanje oružja.

Skup podataka obuhvaća 124 lika, uključujući Aethera i Lumine kao zasebne likove. Za svakog lika navedeni su osnovni podaci poput imena, elementa, regije, rijetkosti, vrste oružja, datuma rođenja, posebnog jela, statistike napredovanja i verzije igre u kojoj je lik objavljen.

Podaci su pohranjeni u relacijskoj bazi PostgreSQL. Baza sadrži osam međusobno povezanih tablica koje omogućuju prikaz odnosa između likova, talenata, oružja, artefakata i domena.

Skup podataka dostupan je u formatima CSV i JSON, a njegova struktura opisana je specifikacijom JSON Schema Draft-07.

Za povećanje pristupačnosti i vidljivosti podataka izrađena je web-aplikacija koja omogućuje pregled podataka u HTML tablici, filtriranje po atributima i preuzimanje filtriranih rezultata u CSV i JSON formatima.

## Metapodaci

| Metapodatak | Vrijednost |
|---|---|
| Naziv skupa podataka | Genshin Impact Characters+ Dataset |
| Autor | Marin Golubic |
| Verzija | 2.0 |
| Datum izrade | 14.11.2026. |
| Datum posljednje izmjene | 15.11.2026. |
| Jezik podataka | Engleski |
| Jezik dokumentacije | Hrvatski |
| Tema | Videoigre |
| Broj likova | 124 |
| Broj talenata | 45 |
| Broj atributa u CSV datoteci | 15 |
| Formati podataka | CSV, JSON |
| Format Metapodataka | JSON Schema Draft-07 |
| Backend | Node.js, Express |
| Frontend | HTML, SCC, JavaScript |
| Baza podataka | PostgreSQL |
| Licencija | CC BY-SA 3.0 |
| Izvor podataka | https://genshin-impact.fandom.com/wiki/Genshin_Impact_Wiki |
| Licencija izvora | CC BY-SA 3.0, za sadržaj zajednice gdje je primjenjivo |
| Način izvoza | Automatizirani SQL upiti korištenjem PostgreSQL naredbe COPY |

## Opis atributa

| Atribut | Tip podatka | Opis |
|---|---|---|
| `character_id` | Integer | Jedinstveni identifikator lika |
| `character_name` | String | Ime lika |
| `rarity` | Integer | Rijetkost lika izražena brojem zvjezdica |
| `character_element` | String | Element lika, npr. Pyro, Hydro, Cryo ili Geo |
| `weapon_type` | String | Vrsta oružja koju lik koristi |
| `region` | String | Regija kojoj lik pripada |
| `model_type` | String | Vrsta modela lika |
| `birthday` | String | Datum rođenja lika, izražen danom i mjesecom |
| `special_dish` | String | Naziv posebnog jela lika |
| `ascension_stat` | String | Dodatna statistika koja raste napredovanjem lika |
| `release_version` | String | Verzija igre u kojoj je lik objavljen |
| `release_date` | Date | Datum objave lika |
| `talent_id` | Integer | Jedinstveni identifikator talenta |
| `talent_name` | String | Naziv talenta |
| `talent_type` | String | Vrsta talenta: Normal Attack, Elemental Skill ili Elemental Burst |
| `weapons` | Array | Niz povezanih oružja |
| `artifacts` | Array | Niz preporučenih setova artefakata |

U JSON datoteci talenti su grupirani unutar polja `talents`, koje sadrži objekte s atributima `talent_id`, `talent_name` i `talent_type`.

Nepoznate vrijednosti prikazane su kao `null` u JSON datoteci, odnosno kao prazna polja u CSV datoteci.

## Model baze podataka

Baza podataka izrađena je korištenjem sustava PostgreSQL i sastoji se od osam međusobno povezanih tablica:

- `characters` – osnovni podaci o igrivim likovima.
- `talents` – talenti likova povezani s tablicom `characters` odnosom 1:N.
- `weapons` – oružja, njihove karakteristike i pripadajući materijali za uzdizanje.
- `artifacts` – setovi artefakata povezani s domenama.
- `domains` – domene, njihove regije i vrste.
- `weapon_ascension_materials` – obitelji materijala za uzdizanje oružja i pripadajuće domene.
- `character_weapons` – povezna tablica koja ostvaruje M:N odnos između likova i oružja.
- `character_artifacts` – povezna tablica koja ostvaruje M:N odnos između likova i setova artefakata.

Podaci su normalizirani kako bi se smanjilo nepotrebno ponavljanje informacija i očuvao referencijalni integritet baze.

Povezne tablice omogućuju pridruživanje više oružja ili setova artefakata pojedinom liku, kao i korištenje istog oružja ili seta artefakata kod više likova.

### Tablica characters

Sadrži osnovne podatke o likovima. Primarni ključ tablice je `character_id`.

### Tablica talents

Sadrži podatke o talentima pojedinih likova. Primarni ključ tablice je `talent_id`, dok je `character_id` strani ključ koji referencira tablicu `characters`.

Između tablica postoji odnos **jedan-prema-više (1:N)**, što znači da jedan lik može imati više talenata, dok svaki talent pripada jednom liku.

## Struktura skupa podataka

### CSV format

CSV datoteka sadrži jedan redak za svakog lika i ukupno 15 atributa.

Budući da CSV ne podržava hijerarhijsku strukturu podataka, povezani podaci o oružjima, talentima i artefaktima zapisani su kao serijalizirani JSON nizovi unutar odgovarajućih stupaca.

### JSON format

JSON datoteka sadrži polje objekata, pri čemu svaki objekt predstavlja jednog lika.

Povezani podaci organizirani su u tri ugniježđena niza:

- `weapons` – oružja povezana s likom.
- `talents` – talenti lika.
- `artifacts` – preporučeni setovi artefakata.

Prazni nizovi označavaju da za određenog lika još nisu uneseni povezani podaci. Nepoznate vrijednosti prikazane su kao `null`.

### JSON Schema

Datoteka `schema.json` opisuje strukturu JSON skupa podataka korištenjem specifikacije JSON Schema Draft-07.

Za svaki atribut definirani su naziv, opis, tip podatka i nužnost postojanja. Za pojedine atribute dodatno su definirana ograničenja poput dopuštenog raspona vrijednosti i formata.

## Web-aplikacija

Za potrebe druge laboratorijske vježbe izrađena je web-aplikacija korištenjem tehnologija **Node.js, Express, HTML, CSS i JavaScript**.

Web-aplikacija omogućuje pristup podacima u ljudima čitljivom obliku, dok se CSV i JSON datoteke koriste za strojno čitljiv prikaz podataka.

### Početna stranica

Datoteka `index.html` sadrži opis skupa podataka, metapodatke, poveznice za preuzimanje cjelokupnog skupa podataka u CSV i JSON formatima te poveznicu na stranicu s podatkovnom tablicom.

### Podatkovna tablica

Datoteka `datatable.html` prikazuje podatke o likovima i njihovim povezanim entitetima u HTML tablici.

Podaci se dohvaćaju asinkrono pomoću JavaScript funkcije `fetch()` i HTTP zahtjeva prema Express poslužitelju, bez ponovnog učitavanja stranice.

Poslužiteljska aplikacija dohvaća podatke izravno iz PostgreSQL baze.

### Filtriranje podataka

Korisnik može pretraživati podatke unosom teksta te odabrati atribut po kojem želi pretraživati.

Zadano je omogućeno pretraživanje po svim atributima (*wildcard*). Poništavanjem filtra ponovno se prikazuju svi dostupni zapisi.

### Preuzimanje podataka

Web-aplikacija omogućuje preuzimanje cjelokupnog skupa podataka u CSV i JSON formatima.

Na stranici s podatkovnom tablicom omogućeno je i preuzimanje trenutačno filtriranih rezultata u istim formatima.

## Pokretanje web-aplikacije

Za pokretanje aplikacije potrebno je imati instalirane Node.js i PostgreSQL.

Nakon preuzimanja repozitorija potrebno je instalirati ovisnosti:

```bash
npm install
```

Potrebno je konfigurirati datoteku `.env` s podacima za povezivanje na PostgreSQL bazu:

```dotenv
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=genshin_impact
PORT=3000
```

Nakon konfiguracije aplikacija se pokreće naredbom:

```bash
node web_gui/backend/server.js
```

Početna stranica dostupna je na adresi:

http://localhost:3000/

Podatkovna tablica dostupna je na adresi:

http://localhost:3000/datatable.html

Datoteka `.env` nije uključena u repozitorij zbog zaštite pristupnih podataka.

## Datoteke

| Datoteka | Opis |
|---|---|
| `genshin_impact.csv` | Podaci o likovima, talentima, oružjima i artefaktima u CSV formatu |
| `genshin_impact.json` | Podaci o likovima i povezanim entitetima u hijerarhijskom JSON formatu |
| `schema.json` | JSON Schema koja opisuje strukturu i tipove podataka u JSON datoteci |
| `genshin_impact.sql` | Dump PostgreSQL baze podataka, uključujući strukturu, podatke i relacije |
| `README.md` | Dokumentacija skupa podataka i upute za korištenje web-aplikacije |
| `LICENSE` | Uvjeti korištenja skupa podataka |
| `sql/` | SQL skripte za izradu, popunjavanje i izvoz podataka iz baze |
| `web_gui/frontend/index.html` | Početna web-stranica s opisom skupa podataka, metapodacima i poveznicama za preuzimanje |
| `web_gui/frontend/datatable.html` | Web-stranica s tabličnim prikazom, pretraživanjem i filtriranjem podataka |
| `web_gui/frontend/styles/style.css` | CSS stilovi početne web-stranice |
| `web_gui/frontend/styles/datatable.css` | CSS stilovi podatkovne tablice |
| `web_gui/frontend/js/datatable.js` | JavaScript za asinkrono dohvaćanje, filtriranje i preuzimanje podataka |
| `web_gui/backend/server.js` | Express poslužitelj koji omogućuje pristup web-stranicama i dohvaćanje podataka iz baze |
| `web_gui/backend/db.js` | Konfiguracija povezivanja s PostgreSQL bazom podataka |
| `package.json` | Konfiguracija Node.js projekta i popis potrebnih ovisnosti |
| `package-lock.json` | Podaci o instaliranim verzijama ovisnosti Node.js projekta |
| `.gitignore` | Popis datoteka i mapa koje Git ne uključuje u repozitorij |

## Postupak izvoza podataka

Podaci su iz PostgreSQL baze izvezeni u CSV i JSON format pomoću SQL naredbe `COPY`.

Za CSV format korišten je SQL upit koji povezuje tablice characters i talents.

Za JSON format korištene su PostgreSQL funkcije json_build_object i json_agg, koje omogućuju prikaz likova i njihovih talenata u hijerarhijskoj strukturi.

## Licencija

Skup podataka **Genshin Impact Characters and Talents Dataset** objavljuje se pod licencijom **Creative Commons Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)**, u opsegu u kojem autor ima pravo licencirati sadržaj.

Izvor podataka je [Genshin Impact Wiki](https://genshin-impact.fandom.com/wiki/Genshin_Impact_Wiki), čiji je sadržaj zajednice, osim ako nije drukčije navedeno, dostupan pod licencijom CC BY-SA 3.0.

Podaci su prikupljeni, odabrani i strukturirani u relacijsku bazu podataka PostgreSQL te izvezeni u CSV i JSON formate.

Prilikom ponovnog korištenja sadržaja obuhvaćenog licencijom potrebno je navesti izvor i odgovarajuće autorstvo, naznačiti izmjene te poštovati uvjet dijeljenja prilagodbi pod kompatibilnom licencijom.

Nazivi likova, igre i drugi elementi povezani s Genshin Impactom pripadaju njihovim odgovarajućim nositeljima prava. Ova licencija ne daje dodatna prava nad sadržajem koji nije obuhvaćen njome.

**Poveznice:**
- [Genshin Impact Wiki](https://genshin-impact.fandom.com/wiki/Genshin_Impact_Wiki)
- [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)
- [Uvjeti autorskih prava na Genshin Impact Wikiju](https://genshin-impact.fandom.com/wiki/Genshin_Impact_Wiki:Copyrights)

## Napomene

Genshin Impact je videoigra tvrtke HoYoverse. Nazivi likova, talenata i ostali elementi igre povezani su s pravima njihovih nositelja.

Podaci su prikupljeni i strukturirani u obrazovne svrhe u sklopu prve laboratorijske vježbe iz kolegija Otvoreno računarstvo.

Skup podataka može sadržavati nepotpune vrijednosti te je podložan budućim izmjenama i ažuriranjima.