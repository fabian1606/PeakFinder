import { Router, Request, Response } from 'express';
import addData from "./addData";
import getPeakName from "./getPeakName";
import getUserData from "./getUserData";
import getPeakData from "./getPeakData";
import testget from "./testget";
import testpost from "./testpost";


const router:Router = Router();

router.get("/",(_req:Request,res:Response):void=>{
    res.send("Welcome to the user service");
});

router.use("/addData",addData);
router.use("/getPeakName", getPeakName);
router.use("/getUserData", getUserData);
router.use("/getPeakData", getPeakData);
router.use("/testget", testget);
router.use("/testpost", testpost);

export default router;