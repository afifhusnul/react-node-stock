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
          <Tab eventKey="Up" title="By Amount">
            <ByAmount />
          </Tab>
          <Tab eventKey="Down" title="By Volume">
          <ByVolume />
          </Tab>
          
        </Tabs>
      </div>
    );
  }
}