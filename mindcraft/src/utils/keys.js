import { readFileSync } from 'fs';
import { loadEnvFile } from './load-env.js';

loadEnvFile();

let keys = {};
try {
    const data = readFileSync('./keys.json', 'utf8');
    keys = JSON.parse(data);
} catch (err) {
    // keys.json optional; prefer project-root .env (see .env.example)
}

const KEY_ALIASES = {
    QWEN_API_KEY: ['EMBEDDING_API_KEY'],
    EMBEDDING_API_KEY: ['QWEN_API_KEY'],
};

export function getKey(name) {
    let key = keys[name];
    if (!key) {
        key = process.env[name];
    }
    if (!key && KEY_ALIASES[name]) {
        for (const alt of KEY_ALIASES[name]) {
            key = keys[alt] || process.env[alt];
            if (key) break;
        }
    }
    if (!key) {
        throw new Error(`API key "${name}" not found. Set it in project-root .env (see .env.example) or keys.json.`);
    }
    return key;
}

export function hasKey(name) {
    if (keys[name] || process.env[name]) return true;
    if (KEY_ALIASES[name]) {
        return KEY_ALIASES[name].some((alt) => keys[alt] || process.env[alt]);
    }
    return false;
}
