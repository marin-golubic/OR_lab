const form = document.querySelector('#filter-form');
const searchInput = document.querySelector('#search');
const attributeInput = document.querySelector('#attribute');
const tableBody = document.querySelector('#characters-body');
const statusLabel = document.querySelector('#status');
const downloadJson = document.querySelector('#download-json');
const downloadCsv = document.querySelector('#download-csv');

const columns = [
    'character_name', 'character_element', 'region', 'rarity',
    'weapon_type', 'birthday', 'model_type', 'weapons', 'talents',
    'artifacts', 'special_dish', 'ascension_stat', 'release_version',
    'release_date', 'character_id'
];

let currentRows = [];
let latestRequest = 0;

function displayValue(value, column) {
    if (value == null) return '-';
    if (Array.isArray(value)) {
        if (!value.length) return '-';
        const key = { weapons: 'weapon_name', talents: 'talent_name', artifacts: 'artifact_name' }[column];
        return value.map(item => item[key]).join(', ');
    }
    // node-postgres može parsirati DATE u Date (ovisno o SQL upitu / tipu stupca).
    if (value instanceof Date) return value.toISOString().slice(0, 10);
    return String(value);
}

function renderTable(rows) {
    tableBody.replaceChildren();
    for (const row of rows) {
        const tr = document.createElement('tr');
        for (const column of columns) {
            const td = document.createElement('td');
            td.textContent = displayValue(row[column], column);
            tr.appendChild(td);
        }
        tableBody.appendChild(tr);
    }
}

async function loadCharacters() {
    const requestId = ++latestRequest;
    const params = new URLSearchParams({
        search: searchInput.value,
        attribute: attributeInput.value
    });
    statusLabel.textContent = 'Loading...';
    downloadJson.disabled = true;
    downloadCsv.disabled = true;

    try {
        const response = await fetch(`/api/characters?${params.toString()}`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const rows = await response.json();
        if (requestId !== latestRequest) return;
        currentRows = rows;
        renderTable(rows);
        statusLabel.textContent = `${rows.length} character(s) found`;
        downloadJson.disabled = false;
        downloadCsv.disabled = false;
    } catch (error) {
        if (requestId !== latestRequest) return;
        currentRows = [];
        renderTable([]);
        statusLabel.textContent = `Could not load data: ${error.message}`;
    }
}

form.addEventListener('submit', event => {
    event.preventDefault();
    loadCharacters();
});

document.querySelector('#reset').addEventListener('click', () => {
    searchInput.value = '';
    attributeInput.value = 'all';
    loadCharacters();
});

// Izvozi se baš trenutačno prikazani rezultat filtriranja.
function downloadFile(content, fileName, mimeType) {
    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = fileName;
    document.body.appendChild(link);
    link.click();
    link.remove();
    URL.revokeObjectURL(url);
}

function csvCell(value) {
    const text = value == null ? '' :
        typeof value === 'object' ? JSON.stringify(value) : String(value);
    return `"${text.replaceAll('"', '""')}"`;
}

downloadJson.addEventListener('click', () => {
    downloadFile(JSON.stringify(currentRows, null, 2),
        'genshin_impact_filtered.json', 'application/json;charset=utf-8');
});

downloadCsv.addEventListener('click', () => {
    const lines = [columns.map(csvCell).join(',')];
    for (const row of currentRows) {
        lines.push(columns.map(column => csvCell(row[column])).join(','));
    }
    downloadFile('\uFEFF' + lines.join('\r\n'),
        'genshin_impact_filtered.csv', 'text/csv;charset=utf-8');
});

loadCharacters();
