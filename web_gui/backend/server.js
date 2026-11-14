const express = require('express');
const pool = require('./db');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

const webDirectory = path.join(__dirname, '../frontend');
const projectDirectory = path.join(__dirname, '../..');

app.use(express.json());

// Dopušteni atributi koje korisnik može odabrati u obrascu.
const searchableColumns = new Set([
    'character_name', 'character_element', 'region', 'rarity',
    'weapon_type', 'birthday', 'model_type', 'special_dish',
    'ascension_stat', 'release_version', 'release_date', 'character_id',
    'weapons', 'talents', 'artifacts'
]);

// Podaci uvijek dolaze iz PostgreSQL-a, ne iz izvezene JSON datoteke.
app.get('/api/characters', async (req, res) => {
    const search = String(req.query.search ?? '').trim();
    const attribute = String(req.query.attribute ?? 'all');

    if (attribute !== 'all' && !searchableColumns.has(attribute)) {
        return res.status(400).json({ error: 'Unknown search attribute.' });
    }

    const fields = [...searchableColumns].map(column => `v.${column}::text`);
    // 'All attributes' znači pretraživanje vrijednosti svih polja,
    // uključujući JSON nizove weapons, talents i artifacts.
    const allText = `concat_ws(' ', ${fields.join(', ')})`;
    const searchableExpression = attribute === 'all'
        ? allText
        : `v.${attribute}::text`;

    const sql = `
        SELECT v.*
        FROM public.genshin_dataset_export_ordered v
        WHERE ($1 = '' OR COALESCE(${searchableExpression}, '') ILIKE '%' || $1 || '%')
        ORDER BY v.character_id
    `;

    try {
        const result = await pool.query(sql, [search]);
        res.json(result.rows);
    } catch (error) {
        console.error('Error fetching characters:', error);
        res.status(500).json({ error: 'Failed to fetch characters from the database.' });
    }
});

// Statičke HTML/CSS/JS datoteke iz mape frontend.
app.use(express.static(webDirectory));

// Cjelokupni skup podataka preuzima se s datotečnog sustava.
app.get('/genshin_impact.csv', (req, res) => {
    res.download(path.join(projectDirectory, 'genshin_impact.csv'));
});
app.get('/genshin_impact.json', (req, res) => {
    res.download(path.join(projectDirectory, 'genshin_impact.json'));
});

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
