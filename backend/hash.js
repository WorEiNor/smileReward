const bcrypt = require('bcrypt');

async function hashPasswords() {
  const adminHash = await bcrypt.hash('11111111', 10);
  console.log('Admin hash:', adminHash);
}

hashPasswords();