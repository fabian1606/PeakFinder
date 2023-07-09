import { Router, Request, Response } from "express";
import axios from "axios";

import dotenv from "dotenv";
import type { DocumentType } from "@typegoose/typegoose";

// this is a test api for the esp website, delete later

const router: Router = Router();

router.post("/", (req: Request, res: Response): void => {
const data = req.body;
const email = data.email;
const msg = data.msg;

console.log(data);

res.send("Message saved successfully");
});

export default router;