import React, { Component } from 'react';
import {Tabs, Tab} from 'react-bootstrap';
import SuperBull from './bull/Bull';
import Bull1 from './bull/Bull1';
import Bull2 from './bull/Bull2';
import Bull3 from './bull/Bull3';

export default class Bull extends Component { 
 render() {
    return (
      <div>
        
        <h2>Bull</h2>
        <Tabs defaultActiveKey="bull" id="uncontrolled-tab-example">
          <Tab eventKey="bull" title="Super Bull">
            <SuperBull />            
          </Tab>
          <Tab eventKey="bull1" title="Bull 1">
            <Bull1 />
          </Tab>

          <Tab eventKey="bull2" title="Bull 2">
            <Bull2 />            
          </Tab>

          <Tab eventKey="bull3" title="Bull 3">
            <Bull3 />
          </Tab>
        </Tabs>
      </div>
    );
  }
}