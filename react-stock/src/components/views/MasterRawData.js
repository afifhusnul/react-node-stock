import React, { Component } from 'react';
import {Tabs, Tab} from 'react-bootstrap';
import RawDataByTicker from './raws/RawData';
// import ByVolume from './ranking/RankingVolume';

export default class MasterRawData extends Component { 
 render() {
    return (
      <div>
        
        <h2>Ranking</h2>
        <Tabs defaultActiveKey="Up" id="uncontrolled-tab-example">
          <Tab eventKey="Raw" title="Raw Data">
            <RawDataByTicker />
          </Tab>
          <Tab eventKey="Graph" title="Graph">
          {/* <ByVolume /> */}
          </Tab>
          
        </Tabs>
      </div>
    );
  }
}