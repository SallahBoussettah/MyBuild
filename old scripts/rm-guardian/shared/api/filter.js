/**
 * RedM Guardian Profanity Filter
 * A simple system for detecting and filtering inappropriate content
 */

const Filter = {};

// Base list of potentially problematic terms
Filter.baseTerms = [
    // Common profanities - kept minimal for demonstration
    'hack',
    'cheat',
    'exploit',
    'mod menu',
    'injector',
    'executor',
    'lua executor',
    'eulen',
    'lynx',
    'brutan',
    'absolute',
    'aimbot',
    'wallhack',
    'godmode',
    'noclip'
];

// Words that should be allowed even if they contain filtered substrings
Filter.whitelist = [
    'association',
    'assault',
    'classic',
    'grape',
    'grasshopper',
    'peacock',
    'sheath'
];

/**
 * Checks if a string contains profanity
 * @param {string} text - The text to check
 * @returns {boolean} - True if profanity found, false otherwise
 */
Filter.check = function(text) {
    if (!text || typeof text !== 'string') {
        return false;
    }

    // Normalize text for checking
    const normalized = text.toLowerCase()
        .replace(/[^\w\s]/g, '')  // Remove special characters
        .replace(/\s+/g, ' ')     // Normalize whitespace
        .trim();

    // Check whitelist first
    for (const word of Filter.whitelist) {
        if (normalized === word.toLowerCase()) {
            return false;
        }
    }

    // Check against base terms
    for (const term of Filter.baseTerms) {
        if (normalized.includes(term.toLowerCase())) {
            return true;
        }
    }

    return false;
};

/**
 * Sanitizes a string by replacing profanity with asterisks
 * @param {string} text - The text to sanitize
 * @returns {string} - Sanitized text
 */
Filter.sanitize = function(text) {
    if (!text || typeof text !== 'string') {
        return text;
    }

    let sanitized = text;
    
    // Replace profanity with asterisks
    for (const term of Filter.baseTerms) {
        const regex = new RegExp('\\b' + term + '\\b', 'gi');
        sanitized = sanitized.replace(regex, '*'.repeat(term.length));
    }
    
    return sanitized;
};

/**
 * Adds custom terms to the filter
 * @param {string[]} terms - Array of terms to add
 */
Filter.addTerms = function(terms) {
    if (!terms || !Array.isArray(terms)) {
        return;
    }
    
    for (const term of terms) {
        if (typeof term === 'string' && term.trim() !== '' && !Filter.baseTerms.includes(term.toLowerCase())) {
            Filter.baseTerms.push(term.toLowerCase());
        }
    }
};

// Export for Lua interop
exports('filterText', (text) => {
    return Filter.check(text);
});

exports('sanitizeText', (text) => {
    return Filter.sanitize(text);
});

exports('addFilterTerms', (terms) => {
    Filter.addTerms(terms);
    return true;
}); 