import { Router, Request, Response } from 'express';
import axios from 'axios';

import dotenv from 'dotenv';
import type { DocumentType } from '@typegoose/typegoose';

import bcrypt from 'bcrypt';

import PeakListItemModel from '../models/peakList';
import type { PeakList } from '../types/peakList';

import msg from '../types/msg';



// ist eigentlich unnötig, kann man am ende löschen

const router:Router = Router();

router.get("/", (req: Request, res: Response): void => {
    const Data = req.body;
    const newPeakName = Data.newPeakName;
    const peakId = Data.peakId;
    console.log(peakId);
    console.log(newPeakName);

    if(!peakId){
        res.status(400).send("peakId necessary");
    }

let Name = "";
    PeakListItemModel.findOne({ peakId: peakId })
        .then((peakListItem:DocumentType<PeakList> | null): void => {
            if (peakListItem) {
                Name = peakListItem.peakName;
                console.log(Name);
                res.send({"peakName":Name});
            }
            else {
                console.log("PeakListItem does not exist");
                if(!newPeakName){
                    res.status(400).send("newPeakName necessary");
                }
                const newPeakListItem = new PeakListItemModel({
                    peakId: peakId,
                    peakName: newPeakName,
                });
            
                newPeakListItem.save()
                    .then((peakListItem: DocumentType<PeakList>): void => {
                        console.log("PeakListItem created: " + peakListItem);
                    }
                    )
                    .catch((err: Error): void => {
                        console.log("Error creating PeakListItem: " + err);
                    }
                    );

            }
        }
        )
        .catch((err: Error): void => {
            console.log("Error getting PeakListItem from DB: " + err);
        }
        );
    
        res.send("PeakListItem created");
    });

export default router;