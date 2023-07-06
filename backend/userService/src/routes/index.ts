import { Router, Request, Response } from 'express';
import login from "./login";
import register from "./register";
import logout from "./logout";
import registerMail from "./registerMail";

const router:Router = Router();

router.get("/",(_req:Request,res:Response):void=>{
    res.send("Welcome to the user service");
});
router.use("/login",login);
router.use("/register",register);
router.use("/logout",logout);
router.use("/registerMail",registerMail);

export default router;