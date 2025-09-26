const express = require("express");
const app = express();
const PORT = process.env.PORT || 80;

// Simple interactive endpoint
app.get("/", (req, res) => {
  res.send(`
    <h1>🚀 Production-Ready ECS App</h1>
    <p>This containerized Node.js app is running on ECS Fargate.</p>
    <p>Try visiting <a href="/hello?name=LinkedIn">/hello?name=LinkedIn</a></p>
  `);
});

app.get("/hello", (req, res) => {
  const name = req.query.name || "world";
  res.send({ message: `Hello, ${name}! This is running on ECS 🚀` });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});