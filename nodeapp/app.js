const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Service is up and running HELLO CI/CD");
});

app.listen(8080, () => {
  console.log("Server is up");
});
