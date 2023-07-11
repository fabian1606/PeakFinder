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
    const email = Data.email;
    const password = Data.password;
    const msgData = Data.msg;
    const peakId = Data.id;


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
        const msg = new MsgModel({
            email: email,
            message: msgData,
            peakId: peakId,
        });
        msg.save()
        .then((msg: DocumentType<Msg>): void => {
            console.log("Msg saved to DB");
            res.send("Msg saved to DB");
        })
        .catch((err: Error): void => {
            console.log("Error saving msg to DB: " + err);
            res.send("Error saving msg to DB: " + err);
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