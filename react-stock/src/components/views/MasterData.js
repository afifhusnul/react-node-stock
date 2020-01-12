import React, { Component } from 'react';
// import {Table, Row, Col } from 'react-bootstrap';
import Api from '../utils/Api';
// import Pagination from "../utils/Pagination";

export default class MasterData extends Component { 
    constructor(props) {
      super(props);
  
      this.state = {
        response: [],
        // trimmedData: [],
        currentResponse: [],
        currentPage: 1,
        totalPages: 0,
        // pageLimit: 15
      };
      
    }

    async componentDidMount() {
        const { pageLimit } = this.state
        try {
            const result = await Api.get("/stockdata")
            console.log(result.data)
              if(result && result.data && result.data.response){
                const trimmed = result.data.response.slice(0, pageLimit);
                this.setState({ response: result.data.response, trimmedData: trimmed })
              }      
    
            } catch (e) {
            console.log(`😱 Axios request failed: ${e}`);
          }
      }
    
      // onPageChanged = data => {    
      //   const { response } = this.state;
      //   const { currentPage, pageLimit } = data;
      //   const trimmed = response.slice((currentPage - 1) * pageLimit, currentPage * pageLimit);    
    
      //   this.setState({ trimmedData: trimmed });
      // };

      render() {
        // const { response, pageLimit, trimmedData } = this.state;
        // const totalResponses = response.length;  
        // if (totalResponses === 0) return null;
      
          return (      
            <div>      
              <br/>
              
            </div>
          );
      }
}