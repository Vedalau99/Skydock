const express = require('express');
const cors = require('cors'); 

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors()); // Allow all origins
app.use(express.json()); // To parse JSON body

// Health check route
app.get('/ping', (req, res) => {
  console.log('Received /ping request');
  res.json({ message: 'pong from SkyDock backend!' });
});

// New POST route for /submit
app.post('/submit', (req, res) => {
  const { name, message } = req.body;

  if (!name || !message) {
    console.warn('Invalid submission received');
    return res.status(400).json({ status: 'error', message: 'Name and message are required' });
  }

  console.log(`📨 Received message from ${name}: ${message}`);

  // Simulate storing or processing here if needed
  res.status(200).json({
    status: 'success',
    message: `Thanks ${name}, your message was received!`
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`SkyDock backend is running on port ${PORT}`);
});
