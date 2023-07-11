import express  from 'express';
import type { Express } from 'express';
import mongoose from 'mongoose';
import routes from './routes';
import dotenv from 'dotenv';
import cors from 'cors';

dotenv.config();

// const mongoUrl = `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}?retryWrites=true&w=majority`;
// const Testuri = `mongodb+srv://victorblaga:${process.env.DB_PASSWORD}@cluster0.6b9fqsn.mongodb.net/?retryWrites=true&w=majority`;
const mongoUri:string = `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}${process.env.DB_DATABASE}?retryWrites=true&w=majority`;
console.log(mongoUri);
// const app = express();

mongoose
  .connect(mongoUri)
  .then((): void => {
    // eslint-disable-next-line no-console
    console.log('DATABASE CONNECTED');
  })
  .catch((error: Error): void => {
    // eslint-disable-next-line no-console
    console.error(`ERROR CONNECTING TO DATABASE AT`, error);
  });

  const port:number =  +process.env.USER_PORT! || 3001;
  const app:Express = express();
  
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(cors({
    origin: '*',
}))
  app.use("/",routes);

  app.listen(port, ():void => {
    console.log(`User service listening on port ${port}`);
})
