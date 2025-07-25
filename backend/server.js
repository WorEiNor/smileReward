const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());

mongoose.connect('mongodb://mongo:27017/myapp', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const Reward = mongoose.model('Reward', {
  name: String,
  points: Number,
});

app.get('/rewards', async (req, res) => {
  const rewards = await Reward.find();
  res.json(rewards);
});

app.listen(3000, () => console.log('Server running on port 3000'));
