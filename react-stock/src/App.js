import React, {useState} from 'react';
import {BrowserRouter, Route} from 'react-router-dom';
import Header from './components/Header';
import { Jumbotron, Toast, Container, Button} from "react-bootstrap";
// import Jumbotron from "react-bootstrap/Jumbotron";
// import Toast from "react-bootstrap/Toast";
// import Container from "react-bootstrap/Container";
// import Button from "react-bootstrap/Button";

import './App.css';

const ExampleToast = ({ children }) => {
  const [show, toggleShow] = useState(true);

  return (
    <>
      {!show && <Button onClick={() => toggleShow(true)}>Show Toast</Button>}
      <Toast show={show} onClose={() => toggleShow(false)}>
        <Toast.Header>
          <strong className="mr-auto">React-Bootstrap</strong>
        </Toast.Header>
        <Toast.Body>{children}</Toast.Body>
      </Toast>
    </>
  )
}


function App() {
  return (
    <div className="App">
    <Header />      
       <Container className="container-fluid">
       <div>
        <Jumbotron>
          <h1 className="header">Welcome To React-Bootstrap</h1>
          <ExampleToast className="toast">
            We now have Toasts
            <span role="img" aria-label="tada">
              🎉
            </span>
          </ExampleToast>
        </Jumbotron>
        </div>
      </Container>      
      
    </div>   

  )
}

export default App;

