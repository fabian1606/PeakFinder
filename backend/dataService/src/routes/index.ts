import { Router, Request, Response } from 'express';
import addData from "./addData";
import getPeakName from "./getPeakName";
import getUserData from "./getUserData";
import getPeakData from "./getPeakData";

const router:Router = Router();

router.get("/",(_req:Request,res:Response):void=>{
    res.send("Welcome to the user service");
});

router.use("/addData",addData);
router.use("/getPeakName", getPeakName);
router.use("/getUserData", getUserData);
router.use("/getPeakData", getPeakData);

export default router;