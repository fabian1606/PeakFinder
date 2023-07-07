import React from "react";
import express from "express";

export default function Home() {
  const app = express();
  const port = 3003;

// Start the server
app.listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});

  const handleSubmit = () => {
    try {
      
      app.use(express.json()); // Parse JSON request bodies
      
      // POST request handler
      app.post('/api/data', (req, res) => {
        // Access the request body
        const data = req.body;
        
        // Process the data (example: log to console)
        console.log(data);
        
        // Send a response
        res.send('Data received successfully');
      });
      console.log("submitted");
    } catch (error) {
      console.log(error);
    }
  };


  return (
    <div style={{ margin: "40px", color: "black" }}>
      <h1>Peakfinder</h1>
      <input
        type="text"
        id="input"
        placeholder="Enter your email"
        // {...register("email")}
        // error={!!errors.email}
      />
      <br />
      <br />
      <input
        type="text"
        id="input"
        placeholder="Enter a new password"
        // {...register("password")}
        // error={!!errors.email}
      />
      <br />
      <br />
      <button style={{ color: "white" }} onClick={handleSubmit()}>
        submit
      </button>
      <div id="output"></div>
    </div>
  );
}
