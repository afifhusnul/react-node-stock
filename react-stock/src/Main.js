import React, { Component } from "react";
import Header from './components/Header';
import { Container } from "react-bootstrap";
import {HashRouter, Route} from 'react-router-dom';
import InfoData from './components/views/MasterData';
import Master from './components/views/MasterStock';
import Bull from './components/views/Bull';
import Bear from './components/views/Bear';
import Ranking from './components/views/Ranking';
import Reversal from './components/views/Reversal';
import Signup from './components/views/Signup';

import './Main.css';

export default class Main extends Component {
  render() {
    return (
      <div>
        <Header />
          <Container className="container-fluid">
            <div>              

              <div className="content">
                <HashRouter>
                  <Route path="/infodata" component={InfoData}/>
                  <Route path="/master" component={Master}/>
                  <Route path="/bull" component={Bull}/>
                  <Route path="/bear" component={Bear}/>
                  <Route path="/ranking" component={Ranking}/>
                  <Route path="/reversal" component={Reversal}/>
                  <Route path="/signup" component={Signup}/>
                </HashRouter>
              </div>
              
            </div>  
        </Container>
    </div>        
    )
  }
}
