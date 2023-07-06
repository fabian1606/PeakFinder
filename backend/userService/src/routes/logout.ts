import { Router, Request, Response } from 'express';


const router:Router = Router();

router.get("/",(_req:Request,res:Response):void=>{
    res.send("Welcome to the login service");
});


export default router;