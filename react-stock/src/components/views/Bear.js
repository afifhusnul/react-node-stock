import React, { Component } from 'react';
import {Tabs, Tab} from 'react-bootstrap';
import SuperBear from './bear/Bear';
import Bear1 from './bear/Bear1';
import Bear2 from './bear/Bear2';
import Bear3 from './bear/Bear3';

export default class Bear extends Component { 
 render() {
    return (
      <div>
        <h2>Bear</h2>
        <Tabs defaultActiveKey="bear" id="uncontrolled-tab-example">
          <Tab eventKey="bear" title="Super Bear">
            <SuperBear />
          </Tab>
          <Tab eventKey="bear-1" title="Bear-1">
            <Bear1 />
          </Tab>
          <Tab eventKey="bear-2" title="Bear-2">
            <Bear2 />
          </Tab>
          <Tab eventKey="bear-3" title="Bear-3">
            <Bear3 />
          </Tab>
        </Tabs>
      </div>
    );
  }
}