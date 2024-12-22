const express = require('express');
const { exec } = require('child_process');
const app = express();
const port = 3001;

app.get('/api/show-addresses', (req, res) => {
  exec('make show-addresses', (error, stdout, stderr) => {
    if (error) {
      res.status(500).send(error.message);
      return;
    }
    res.send(stdout);
  });
});

app.get('/api/show-channels', (req, res) => {
  exec('make show-channels', (error, stdout, stderr) => {
    if (error) {
      res.status(500).send(error.message);
      return;
    }
    res.send(stdout);
  });
});

app.get('/api/start-relayer', (req, res) => {
  exec('make all', (error, stdout, stderr) => {
    if (error) {
      res.status(500).send(error.message);
      return;
    }
    res.send(stdout);
  });
});

app.get('/api/reset-relayer', (req, res) => {
  exec('make clean', (error, stdout, stderr) => {
    if (error) {
      res.status(500).send(error.message);
      return;
    }
    res.send(stdout);
  });
});

app.get('/api/transfer/:from/:to/:funds/:addr/:channel', (req, res) => {
  const { from, to, funds, addr, channel } = req.params;
  const command = `make transfer FROM=${from} TO=${to} FUNDS=${funds} ADDR=${addr} CHANNEL=${channel}`;
  
  exec(command, (error, stdout, stderr) => {
    if (error) {
      res.status(500).send(error.message);
      return;
    }
    res.send(stdout);
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
