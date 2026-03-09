const request = require("supertest");
const express = require("express");

const app = express();

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

describe("Health Endpoint", () => {

  it("should return 200", async () => {

    const res = await request(app).get("/health");

    expect(res.statusCode).toEqual(200);

  });

});
