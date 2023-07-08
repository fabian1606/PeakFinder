import React, { useState } from 'react';
import axios from 'axios';

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
    axios.post('http://localhost:3003/register', { email, password })
    .then(res => console.log(res))
    .catch(err => console.log(err));
  };

  return (
    <div>
      <p>This is a page</p>
      <input type="text" value={email} onChange={handleEmailChange} />
      <input type="password" value={password} onChange={handlePasswordChange} />
      <button onClick={handleRegister}>Register</button>
    </div>
  );
}

// probably works but cors error