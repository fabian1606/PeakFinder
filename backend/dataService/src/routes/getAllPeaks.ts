import { Router, Request, Response } from 'express';
import axios from 'axios';

import dotenv from 'dotenv';
import type { DocumentType } from '@typegoose/typegoose';

import bcrypt from 'bcrypt';

import PeakListItemModel from '../models/peakList';
import type { PeakList } from '../types/peakList';

import msg from '../types/msg';
import { Peak } from '../types/peak';



// ist eigentlich unnötig, kann man am ende löschen

const router:Router = Router();

router.get("/", (req: Request, res: Response): void => {

    let arrOfPeaks: { peakId: string; peakName: string; }[] = [];
    
    PeakListItemModel.find()
        .then((peakListItems:DocumentType<PeakList>[] | null): void => {
            if (peakListItems) {
                console.log(peakListItems);
                peakListItems.forEach((peakListItem) => {
                    const peakId = peakListItem.peakId;
                    const peakName = peakListItem.peakName;
                    const peak = {peakId: peakId, peakName: peakName};
                    arrOfPeaks.push(peak);
                })
                res.send({"arrOfPeaks":arrOfPeaks});
            }
            else {
                console.log("PeakListItem does not exist");
                res.status(400).send("PeakListItem does not exist");
            }
        })
    });

export default router;