import React, { useEffect, useState } from 'react'
import './App.css';
import API_URL from './config'

function App() {
  const [successMessage, setSuccessMessage] = useState() 
  const [failureMessage, setFailureMessage] = useState() 

 useEffect(() => {

  const getId = async () => {

    try {

      const resp = await fetch(API_URL)

      console.log('resp:', resp)

      if (!resp.ok) {

        throw new Error(`HTTP error ${resp.status}`)

      }

      const data = await resp.json()

      console.log('data:', data)

      setSuccessMessage(data.id)

    } catch (e) {

      console.error('Fetch failed:', e)

      setFailureMessage(String(e))

    }

  }

  getId()

}, [])

  return (
    <div className="App">
      {!failureMessage && !successMessage ? 'Fetching...' : null}
      {failureMessage ? failureMessage : null}
      {successMessage ? successMessage : null}
    </div>
  );
}

export default App;
