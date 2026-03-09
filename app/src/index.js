const express = require("express");
const redis = require("redis");

const app = express();
app.use(express.json());

const client = redis.createClient({
  url: process.env.REDIS_URL || "redis://redis:6379"
});

client.connect();

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.get("/status", (req, res) => {
  res.json({
    uptime: process.uptime(),
    message: "Application running"
  });
});

app.post("/process", async (req, res) => {

  const data = req.body;

  await client.set("last_payload", JSON.stringify(data));

  res.json({
    message: "Payload processed",
    data
  });
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
