import { Router, Request, Response } from 'express';


const router:Router = Router();

router.post("/",(req:Request,res:Response):void=>{

    const username = req.body.username;
    const password = req.body.password;
    console.log(username);
    console.log(password);
    
    res.send("Welcome to the login service");
});


export default router;