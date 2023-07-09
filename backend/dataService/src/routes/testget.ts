import { Router, Request, Response } from "express";
import axios from "axios";

import dotenv from "dotenv";
import type { DocumentType } from "@typegoose/typegoose";

// this is a test api for the esp website, delete later

const router: Router = Router();

router.get("/", (req: Request, res: Response): void => {
res.send({"arr": [{msg:"Hello World1"},{msg:"Hello World2"},{msg:"Hello World3"},{msg:"Hello World4"},{msg:"Hello World5"}]});

});

export default router;