import { Router, Request, Response } from 'express';
import axios from 'axios';

import dotenv from 'dotenv';
import type { DocumentType } from '@typegoose/typegoose';

import bcrypt from 'bcrypt';

import MsgModel from '../models/msgs';
import type { Msg } from '../types/msg';

import UserModel from '../models/users';
import { User } from '../types/user';

import PeakModel from '../models/peaks';
import { Peak } from '../types/peak';

import PeakListModel from '../models/peakList';
import type { PeakList } from '../types/peakList';

import msg from '../types/msg';


const router:Router = Router();

router.post("/", (req: Request, res: Response): void => {
    const Data = req.body;
    const msgData = Data.msgs;
    const peakData = Data.avgVisitors;
    const peakId = Data.id;
    console.log(msgData);
    console.log(peakData);
    console.log(peakId);
    
let Name = "";
    PeakListModel.findOne({ peakId: peakId })
        .then((peakListItem:DocumentType<PeakList> | null): void => {
            if (peakListItem) {
                Name = peakListItem.peakName;
                console.log(Name);
            }
            else {
                console.log("PeakListItem does not exist");
            }
        })
        .catch((err: Error): void => {
            console.log("Error getting PeakListItem from DB: " + err);
        });

        //send request to userService registerMail
    msgData.forEach((e: any) => {
      UserModel.findOne({ email: e.email })
        .then((user:DocumentType<User> | null): void => {
            if(!user){
                axios.post('http://localhost:3003/registerMail', {
                    Headers: {
                        'Content-Type': 'application/json',
                    },
                    email: e.email,
                })
            }
    });
});

msgData.forEach((e: any) => {
    MsgModel.findOne({ email: e.email, peakId: peakId })
        .then((msg:DocumentType<Msg> | null): void => {
            if (!msg) {
                console.log(peakId);
                const newMsg = new MsgModel({
                    email: e.email,
                    peakId: peakId,
                    peakName: Name,
                    message: e.msg,
                });
                newMsg.save()
                    .then((msg:DocumentType<Msg>): void => {
                        console.log("Msg saved successfully");
                    })
                    .catch((err: Error): void => {
                        console.log("Error saving msg: " + err);
                    });
                console.log("Msg does not exist");
            }
            else {
                console.log("Msg already exists");
            }
        })
        .catch((err: Error): void => {
            console.log("Error getting msg from DB: " + err);
        });
});

peakData.forEach((e: any) => {
    PeakModel.findOne({ peakId: peakId, timestamp: e.timestamp })
        .then((peak:DocumentType<Peak> | null): void => {
            if (!peak) {
                const newPeak = new PeakModel({
                    peakId: peakId,
                    timestamp: e.timestamp,
                    averageVisitors: e.value,
                    name: Name,
                });
                newPeak.save()
                    .then((peak:DocumentType<Peak>): void => {
                        console.log("Peak saved successfully");
                    })
                    .catch((err: Error): void => {
                        console.log("Error saving peak: " + err);
                    });
                console.log("Peak post does not exist");
            }
            else {
                console.log("Peak post already exists");
            }
        })
        .catch((err: Error): void => {
            console.log("Error getting peak from DB: " + err);
        });
});

    res.send("successful");
});

export default router;