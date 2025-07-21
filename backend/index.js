const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/ping', (req, res) => {
  console.log('Received /ping request');
  res.json({ message: 'pong from SkyDock backend!' });
});

app.listen(PORT, () => {
  console.log(`SkyDock backend is running on port ${PORT}`);
});
