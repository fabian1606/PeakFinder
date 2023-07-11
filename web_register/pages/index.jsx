import React, { useState } from 'react';
import axios from 'axios';
import Image from 'next/image';
import Link from 'next/link';
import styles from '../styles/Home.module.css';


export default function Index() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleEmailChange = (event) => {
    setEmail(event.target.value);
  };

  const handlePasswordChange = (event) => {
    setPassword(event.target.value);
  };

  const handleRegister = () => {
    axios
    axios.post('http://xps-15:3003/register', { email, password })
    .then(res => {
    if(res.status != 200){
      alert('Registration successful!');
    } else {
      alert('Registration failed.');
    }
  })
    .catch(err => alert(err+" Registration failed. Possibly wrong email or Password, or User already exists."));
  };

  return (
    <div id='canvas' style={{margin:"15%"}}>
      <div style={{display:"flex", justifyContent:"space-between", flexFlow:"column", alignItems:"center", height:"400px"}}>
      <h2>Register for Peakfinder</h2>
      <div style={{display:"flex", flexFlow:"column", justifyContent:"space-between", width:"25%"}}>
      <p>Email</p>
      <input type="text" value={email} onChange={handleEmailChange} style={{borderRadius: "15px"}} />
      <p>Password</p>
      <input type="password" value={password} onChange={handlePasswordChange} style={{borderRadius: "15px"}}/>
      <button onClick={handleRegister} style={{marginTop:"20px", border:"none", borderRadius:"7px", backgroundColor:"#242227", color:"white"}}>Register</button>
      </div>
      <h4>Download our app here</h4>
      <div>
      <Link href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">
<Image src="/download.png" alt="appstore" width={350} height={50}/>
      </Link>
      </div>
      </div>
    </div>
  );
}

// probably works but cors error