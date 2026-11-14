
COPY (
    SELECT json_agg(
        json_build_object(
            'character_name', c.character_name,
            'character_element', c.character_element,
            'region', c.region,
            'rarity', c.rarity,
            'weapon_type', c.weapon_type,
            'birthday', c.birthday,
            'model_type', c.model_type,

            'talents', COALESCE(
                (
                    SELECT json_agg(
                        json_build_object(
                            'talent_name', t.talent_name,
                            'talent_type', t.talent_type,
                            'talent_id', t.talent_id
                        )
                        ORDER BY
                            CASE t.talent_type
                                WHEN 'Normal Attack' THEN 1
                                WHEN 'Elemental Skill' THEN 2
                                WHEN 'Elemental Burst' THEN 3
                                ELSE 4
                            END
                    )
                    FROM talents t
                    WHERE t.character_id = c.character_id
                ),
                '[]'::json
            ),

            'special_dish', c.special_dish,
            'ascension_stat', c.ascension_stat,
            'release_version', c.release_version,
            'release_date', c.release_date,
            'character_id', c.character_id
        )
        ORDER BY c.character_id
    )
    FROM characters c
)
TO 'D:/Marin disk/FER/OtvRac/OR_lab/genshin_impact.json'
WITH (
    FORMAT CSV,
    DELIMITER E'\x01',
    QUOTE E'\x02'
);
