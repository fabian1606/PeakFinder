import { Router, Request, Response } from "express";
import axios from "axios";

import dotenv from "dotenv";
import type { DocumentType } from "@typegoose/typegoose";

import bcrypt from "bcrypt";

import MsgModel from "../models/msgs";
import { Msg } from "../types/msg";

import UserModel from "../models/users";
import { User } from "../types/user";

import PeakModel from "../models/peaks";
import { Peak } from "../types/peak";

import PeakListModel from "../models/peakList";
import type { PeakList } from "../types/peakList";

import msg from "../types/msg";

const router: Router = Router();

router.get("/", (req: Request, res: Response): void => {
  const Data = req.body;
  const email = Data.email;
  const password = Data.password;

  axios
    .post("http://localhost:3003/login", {
      Headers: {
        "Content-Type": "application/json",
      },
      email: email,
      password: password,
    })
    .then((response: any): void => {
      if (response.status == 200) {
        
        MsgModel.find({ email: email })
          .then((msgs: DocumentType<Msg>[] | null): void => {
            if (msgs) {
              // Handle the found msgs
              console.log(msgs);
const msgsVar = msgs.map((msg) => {
                    return {
                        msg: msg.message,
                        peakId: msg.peakId,
                        peakName: msg.peakName,
                    }
                })
const data = {"email": email, "msgs": msgsVar};

              res.send(data);
            } else {
              console.log("No msgs found for the user");
              res.send("No msgs found for the user");
            }
          })
          .catch((err: Error): void => {
            console.log("Error finding msgs: " + err);
          });

      } else {
        throw new Error("wrong input");
      }
    })
    .catch((err: Error): void => {
      console.log("Error sending request to userService: " + err);
      res.send("Error sending request to userService: " + err);
    });
});

export default router;
