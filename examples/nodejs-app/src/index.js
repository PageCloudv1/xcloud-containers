// Example Node.js application for xCloud containers
const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', service: 'nodejs-app' });
});

// Example API endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'xCloud Node.js Example App',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
