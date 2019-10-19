import React, { Component } from 'react';
import {Tabs, Tab} from 'react-bootstrap';
import ByAmount from './ranking/RankingAmount';
import ByVolume from './ranking/RankingVolume';

export default class Reversal extends Component { 
 render() {
    return (
      <div>
        
        <h2>Ranking</h2>
        <Tabs defaultActiveKey="Up" id="uncontrolled-tab-example">
          <Tab eventKey="Up" title="Up">
            <ByAmount />
          </Tab>
          <Tab eventKey="Down" title="Down">
          <ByVolume />
          </Tab>
          
        </Tabs>
      </div>
    );
  }
}