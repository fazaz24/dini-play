const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

let nasheeds = [
  { id: 1, title: 'Nasheed 1', url: '/nasheeds/1.mp3' },
  { id: 2, title: 'Nasheed 2', url: '/nasheeds/2.mp3' }
];

app.get('/', (req, res) => {
  res.send('Nasheed SaaS API');
});

app.get('/nasheeds', (req, res) => {
  res.json(nasheeds);
});

app.post('/nasheeds', (req, res) => {
  const { title, url } = req.body;
  const id = nasheeds.length + 1;
  nasheeds.push({ id, title, url });
  res.status(201).json({ id, title, url });
});

app.listen(PORT, () => {
  console.log(`Nasheed SaaS running on port ${PORT}`);
});
