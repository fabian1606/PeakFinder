import { Router, Request, Response } from 'express';
import dotenv from 'dotenv';
import UserModel from '../models/users';
import type { DocumentType } from '@typegoose/typegoose';
import type { User } from '../types/user';
import bcrypt from 'bcrypt';

dotenv.config();


const router:Router = Router();

// router.post("/",(req:Request,res:Response):void=>{

//     const email = req.body.email;
//     const password = req.body.password;
    
//     res.send("Welcome to the login service");
// });

// Email anstatt username?
// password pepper in .env hinzufügen?

router.post("/", (req: Request, res: Response): void => {
    const userData = req.body;
    const dbUser = new UserModel({ email: userData.email });
    bcrypt.hash(userData.password + process.env.PASSWORD_PEPPER, 10)
        .then((hash: string): void => {
            dbUser.password = hash;
            console.log(hash);
        })
        .catch((err: Error): void => {
            console.log("Failed to hash password: " + err);
            res.status(500).send("Failed to hash password");
            return;
        })
    UserModel.findOne({ email: userData.email })
        .then((user: DocumentType<User> | null): void => {
            if (user) {
                console.log("User already exists");
                res.status(409).send("User already exists");
            } else {
                dbUser.save()
                    .then((user: any): void => {
                        console.log("User created");
                        res.status(201).send(user);
                    })
                    .catch((err: Error): void => {
                        console.log("Failed to create user: " + err);
                        res.status(500).send("Failed to create user");
                    }
                    );
            }
        })
        .catch((err: Error): void => {
            console.log("Failed to get users from DB: " + err);
            res.status(500).send("Error: " + err);
        });
});

export default router;