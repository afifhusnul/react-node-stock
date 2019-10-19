import React, { Component } from 'react';
import {Tabs, Tab} from 'react-bootstrap';
import RevUp from './reversal/ReversalUp';
import RevDown from './reversal/ReversalDown';

export default class Reversal extends Component { 
 render() {
    return (
      <div>
        
        <h2>Reversal</h2>
        <Tabs defaultActiveKey="Up" id="uncontrolled-tab-example">
          <Tab eventKey="Up" title="Up">
            <RevUp />
          </Tab>
          <Tab eventKey="Down" title="Down">
          <RevDown />
          </Tab>
          
        </Tabs>
      </div>
    );
  }
}