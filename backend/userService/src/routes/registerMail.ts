import { Router, Request, Response } from 'express';
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();


const router:Router = Router();

router.post("/",(req:Request,res:Response):void=>{

    const email = req.body.email;
    const password = req.body.password;
    console.log(email);
    console.log(password);
    
    try{
        sendEmail(email);
    }catch(err){
        console.log(err);
    }
    res.send("Email was sent successfully");
});

async function sendEmail( email:string) {
  try {
    // Erstelle einen Nodemailer-Transporter
    const transporter = nodemailer.createTransport({
        host: process.env.MAIL_HOST,
        port: Number(process.env.MAIL_PORT),
        secure: Boolean(process.env.MAIL_SECURE),
        tls: {
          rejectUnauthorized: Boolean(process.env.MAIL_TLS)
        },
        auth: {
          user: process.env.MAIL_USER,
          pass: process.env.MAIL_PWD
        }
      });

    // E-Mail-Optionen
    const mailOptions = {
      from: process.env.MAIL_FROM,
      to: email,
      subject: "Gipfelstürmer, herzlichen Glückwunsch!",
      html: `
      <p>Hallo liebe/r Gipfelstürmer/in,</p>
      
      <p>Wow, du hast es geschafft! Wir gratulieren dir von ganzem Herzen zu deinem ersten Gipfelbucheintrag. 🎉🏔️</p>
      
      <p>Du bist jetzt offiziell Teil der exklusiven Gemeinschaft der Bergbezwinger, die unsere App nutzen. Wir hoffen, du hattest eine fantastische Zeit auf dem Gipfel und dass du den Ausblick in vollen Zügen genießen konntest.</p>
      
      <p>Als Belohnung für deinen Mut und deine Hartnäckigkeit erhältst du von uns einen virtuellen Orden für deinen Gipfelsturm. Zeig ihn ruhig stolz herum, du hast ihn dir verdient!</p>
      
      <p>Wir hoffen, dass du weiterhin zahlreiche Gipfel erklimmst und neue Abenteuer erlebst.</p>
      
      <p>Bleib am Ball und halte deine Gipfelstürmer-Abenteuer fest!</p>
      
      <p><a href="${process.env.MAIL_LINK}">Klicke hier, um die app zu nutzen und weitere Gipfel festzuhalten</a></p>

      <p>Mit bergsteigerischen Grüßen,</p>
      <p>Das Gipfelbuch-Team</p>`
      
    };
    // Sende die E-Mail
    const info = await transporter.sendMail(mailOptions);
    console.log("E-Mail wurde gesendet:", info.response);
  } catch (error) {
    console.error("Fehler beim Senden der E-Mail:", error);
  }
}


export default router;