import { existsSync, readFileSync } from 'fs';
import { dirname, resolve } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * Load KEY=VALUE lines from .env into process.env (only if not already set).
 * Searches project root (AIMC/) then mindcraft/ for compatibility.
 */
export function loadEnvFile() {
    const candidates = [
        resolve(process.cwd(), '..', '.env'),
        resolve(process.cwd(), '.env'),
        resolve(__dirname, '..', '..', '..', '.env'),
        resolve(__dirname, '..', '..', '.env'),
    ];
    const seen = new Set();
    for (const envPath of candidates) {
        if (seen.has(envPath) || !existsSync(envPath)) continue;
        seen.add(envPath);
        parseEnvFile(envPath);
    }
}

function parseEnvFile(envPath) {
    const content = readFileSync(envPath, 'utf8');
    for (const rawLine of content.split(/\r?\n/)) {
        const line = rawLine.trim();
        if (!line || line.startsWith('#')) continue;
        const eq = line.indexOf('=');
        if (eq <= 0) continue;
        const key = line.slice(0, eq).trim();
        let value = line.slice(eq + 1).trim();
        if (
            (value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))
        ) {
            value = value.slice(1, -1);
        }
        if (!process.env[key]) {
            process.env[key] = value;
        }
    }
}
