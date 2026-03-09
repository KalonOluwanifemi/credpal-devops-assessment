const express = require("express");
const redis = require("redis");

const app = express();
app.use(express.json());

const client = redis.createClient({
  url: process.env.REDIS_URL || "redis://redis:6379"
});

// Retry until Redis is ready
async function connectRedis() {
  while (true) {
    try {
      await client.connect();
      console.log("Connected to Redis");
      break;
    } catch (err) {
      console.log("Redis not ready, retrying...");
      await new Promise(res => setTimeout(res, 1000));
    }
  }
}

connectRedis();

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

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});
