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
  const PeakId = Data.peakId;
  const email = Data.email;
  const password = Data.password;

  if(!PeakId){
    res.send("No PeakId given");
  }

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
        
        MsgModel.find({peakId: PeakId})
          .then((msgs: DocumentType<Msg>[] | null): void => {
            if (msgs) {
              // Handle the found msgs
              console.log(msgs);
              PeakModel.find({peakId: PeakId})
              .sort({timestamp: -1})
              .limit(1)
              .then((peak: DocumentType<Peak>[] | null): void => {
                  if (peak) {
                      // Handle the found msgs
                      console.log(peak);
                      res.send({"msgs":msgs, "peak":peak});
                  } else {
                      console.log("No peak found for this peak");
                  }
                  }
              )
              .catch((err: Error): void => {
                  console.log("Error finding peak: " + err);
              }
              );
            } else {
              console.log("No msgs found for this peak");
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
