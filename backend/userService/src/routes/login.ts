import { Router, Request, Response } from 'express';
import dotenv from 'dotenv';
import UserModel from '../models/users';
import type { DocumentType } from '@typegoose/typegoose';
import type { User } from '../types/user';
import bcrypt from 'bcrypt';



const router:Router = Router();

// router.post("/",(req:Request,res:Response):void=>{

//     const username = req.body.username;
//     const password = req.body.password;
//     console.log(username);
//     console.log(password);
    
//     res.send("Welcome to the login service");
// });


router.post("/", (req: Request, res: Response): void => {
    const userData = req.body;
    UserModel.findOne({ email: userData.email })
        .then((user:DocumentType<User> | null): void => {
            if (user) {
                bcrypt.compare(userData.password + process.env.PASSWORD_PEPPER, user.password)
                .then((result: boolean): void => {
                    if (result) {
                        res.send(user.email + " logged in successfully");
                    }
                    else {
                        console.log("Invalid password");
                        res.status(401).send("Invalid password");
                        
                    }
                })
                .catch((err: Error): void => {
                    console.log("Server Error comparing passwords: " + err);
                    res.status(500).send("Server Error comparing passwords");
                });
            }
            else {
                res.status(404).send("User does not exist");
                console.log("User does not exist");
            }
        })
        .catch((err: Error): void => {
            res.status(500).send("Error: " + err);
        });
});

export default router;
