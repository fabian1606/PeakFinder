import { Router, Request, Response } from 'express';
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();


const router:Router = Router();

router.post("/",(req:Request,res:Response):void=>{

    const email = req.body.email;
    const password = req.body.password;
    
    res.send("Welcome to the login service");
});


export default router;