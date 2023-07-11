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
  let arrOfPeaks: { peakId: string; peakName: string }[] = [];

  if (!PeakId) {
    res.send("No PeakId given");
  } else {
    MsgModel.find({ peakId: PeakId })
      .then((msgs: DocumentType<Msg>[] | null): void => {
        if (msgs) {
          // Handle the found msgs
          console.log(msgs);

          PeakModel.find({ peakId: PeakId })
            .then((peak: DocumentType<Peak>[] | null): void => {
              if (peak) {
                peak.forEach((peakListItem) => {
                  const newPeakData = {
                    peakId: peakListItem.peakId,
                    peakName: peakListItem.name,
                    avgVisitors: peakListItem.averageVisitors,
                    timestamp: peakListItem.timestamp,
                  };
                  arrOfPeaks.push(newPeakData);
                });
                // Handle the found msgs
                const msgsVar = msgs.map((msg) => {
                  return {
                    msg: msg.message,
                  };
                });
                // const PeakVar = {"name": peak[0].name,"id": peak[0].peakId,"avgVisitors": peak[0].averageVisitors}
                const data = { peak: arrOfPeaks, msgs: msgsVar };
                res.send(data);
              } else {
                console.log("No peak found for this peak");
              }
            })
            .catch((err: Error): void => {
              console.log("Error finding peak: " + err);
            });
        } else {
          console.log("No msgs found for this peak");
        }
      })
      .catch((err: Error): void => {
        console.log("Error finding msgs: " + err);
      });
  }
});

export default router;
