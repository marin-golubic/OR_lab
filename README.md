# Genshin Impact Characters and Talents Dataset

## Opis skupa podataka

Ovaj otvoreni skup podataka sadrži informacije o likovima iz videoigre **Genshin Impact** i njihovim talentima.

Skup podataka obuhvaća 15 likova i 45 talenata. Za svakog lika navedeni su osnovni podaci poput imena, elementa, regije, rijetkosti, vrste oružja, datuma rođenja, posebnog jela, statistike napredovanja i verzije igre u kojoj je lik objavljen.

Podaci su pohranjeni u relacijskoj bazi podataka PostgreSQL, u dvije međusobno povezane tablice: `characters` i `talents`.

Skup podataka dostupan je u formatima **CSV** i **JSON** kako bi se omogućilo jednostavno čitanje, obrada i ponovno korištenje podataka.

## Metapodaci

| Metapodatak | Vrijednost |
|---|---|
| Naziv skupa podataka | Genshin Impact Characters and Talents Dataset |
| Autor | Marin Golubic |
| Verzija | 1.0 |
| Datum izrade | 30.10.2026. |
| Datum posljednje izmjene | 1.11.2026. |
| Jezik podataka | Engleski |
| Jezik dokumentacije | Hrvatski |
| Tema | Videoigre |
| Broj likova | 15 |
| Broj talenata | 45 |
| Broj atributa u CSV datoteci | 15 |
| Formati podataka | CSV, JSON |
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

U JSON datoteci talenti su grupirani unutar polja `talents`, koje sadrži objekte s atributima `talent_id`, `talent_name` i `talent_type`.

Nepoznate vrijednosti prikazane su kao `null` u JSON datoteci, odnosno kao prazna polja u CSV datoteci.

## Model baze podataka

Baza podataka sastoji se od dvije tablice.

### Tablica characters

Sadrži osnovne podatke o likovima. Primarni ključ tablice je `character_id`.

### Tablica talents

Sadrži podatke o talentima pojedinih likova. Primarni ključ tablice je `talent_id`, dok je `character_id` strani ključ koji referencira tablicu `characters`.

Između tablica postoji odnos **jedan-prema-više (1:N)**, što znači da jedan lik može imati više talenata, dok svaki talent pripada jednom liku.

## Struktura skupa podataka

### CSV format

CSV datoteka sadrži podatke iz obje tablice spojene SQL naredbom `JOIN`.

Budući da CSV format ne podržava hijerarhijsku strukturu, podaci o pojedinom liku ponavljaju se u svakom retku za njegov talent.

### JSON format

JSON datoteka sadrži polje objekata, pri čemu svaki objekt predstavlja jednog lika.

Podaci o talentima nalaze se unutar polja `talents`, čime je očuvana hijerarhijska struktura i prikazan odnos između roditeljskog i povezanog entiteta.

## Datoteke

| Datoteka | Opis |
|---|---|
| `genshin_impact.csv` | Podaci o likovima i talentima u CSV formatu |
| `genshin_impact.json` | Podaci o likovima i pripadajućim talentima u JSON formatu |
| `genshin_impact.sql` | Dump PostgreSQL baze podataka, uključujući strukturu i podatke |
| `README.md` | Dokumentacija skupa podataka |
| `LICENSE` | Uvjeti korištenja skupa podataka |
| `sql mapa` | Primjeri naredbi za unos u tablice |

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