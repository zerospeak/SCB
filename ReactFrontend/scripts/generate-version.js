const fs = require('fs');
const path = require('path');
const version = Date.now().toString();
const outPath = path.join(__dirname, '../public/version.txt');
fs.writeFileSync(outPath, version);
console.log('Generated version.txt:', version);
