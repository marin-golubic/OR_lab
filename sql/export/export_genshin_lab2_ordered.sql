-- Pokreni koristeci psql iz direktorija projekta.
-- Redoslijed: osnovni podaci, weapons, talents, artifacts, ostali podaci, character_id.

CREATE OR REPLACE VIEW public.genshin_dataset_export_ordered AS
SELECT
    c.character_name,
    c.character_element,
    c.region,
    c.rarity,
    c.weapon_type,
    c.birthday,
    c.model_type,
    COALESCE((
        SELECT json_agg(
            json_build_object(
                'weapon_name', w.weapon_name,
                'weapon_type', w.weapon_type,
                'rarity', w.rarity,
                'base_attack', w.base_attack,
                'secondary_stat', w.secondary_stat,
                'material_name', m.material_name,
                'material_domain', dm.domain_name,
                'material_region', dm.region,
                'weapon_id', w.weapon_id
            ) ORDER BY w.weapon_name
        )
        FROM public.character_weapons cw
        JOIN public.weapons w ON w.weapon_id = cw.weapon_id
        LEFT JOIN public.weapon_ascension_materials m ON m.material_id = w.material_id
        LEFT JOIN public.domains dm ON dm.domain_id = m.domain_id
        WHERE cw.character_id = c.character_id
    ), '[]'::json) AS weapons,
    COALESCE((
        SELECT json_agg(
            json_build_object(
                'talent_name', t.talent_name,
                'talent_type', t.talent_type,
                'talent_id', t.talent_id
            ) ORDER BY t.talent_id
        )
        FROM public.talents t
        WHERE t.character_id = c.character_id
    ), '[]'::json) AS talents,
    COALESCE((
        SELECT json_agg(
            json_build_object(
                'artifact_name', a.artifact_name,
                'domain_name', d.domain_name,
                'domain_region', d.region,
                'artifact_id', a.artifact_id
            ) ORDER BY a.artifact_name
        )
        FROM public.character_artifacts ca
        JOIN public.artifacts a ON a.artifact_id = ca.artifact_id
        LEFT JOIN public.domains d ON d.domain_id = a.domain_id
        WHERE ca.character_id = c.character_id
    ), '[]'::json) AS artifacts,
    c.special_dish,
    c.ascension_stat,
    c.release_version,
    c.release_date,
    c.character_id
FROM public.characters c;

-- CSV: iste kolone istim redoslijedom.
\copy (SELECT * FROM public.genshin_dataset_export_ordered ORDER BY character_id) TO 'genshin_impact.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- JSON: json_build_object (ne jsonb!) cuva zadani redoslijed kljuceva.
\pset format unaligned
\pset tuples_only on
\o genshin_impact.json
SELECT COALESCE(json_agg(json_build_object(
    'character_name', x.character_name,
    'character_element', x.character_element,
    'region', x.region,
    'rarity', x.rarity,
    'weapon_type', x.weapon_type,
    'birthday', x.birthday,
    'model_type', x.model_type,
    'weapons', x.weapons,
    'talents', x.talents,
    'artifacts', x.artifacts,
    'special_dish', x.special_dish,
    'ascension_stat', x.ascension_stat,
    'release_version', x.release_version,
    'release_date', x.release_date,
    'character_id', x.character_id
) ORDER BY x.character_id), '[]'::json)
FROM public.genshin_dataset_export_ordered x;
\o
\pset tuples_only off
\pset format aligned
