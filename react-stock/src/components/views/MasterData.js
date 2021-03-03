import React, { Component } from 'react';
import {Container, Button, Form, FormControl, Alert, Toast, ToastBody, ToastHeader,
  Modal, ModalTitle, ModalBody, ModalFooter,Table,Row, Col
} from 'react-bootstrap';
import Api from '../utils/Api';
import Pagination from "../utils/Pagination";

// import ModalKu from './modal/ModalKu';
// import Api from '../utils/Api';

// import Pagination from "../utils/Pagination";

export default class MasterData extends Component { 
    constructor(props) {
      super(props);

      this.state = {
        isOpen: false,        
        inputText: '',
        startDt: '',
        endDt: '',
        response: [],
        trimmedData: [],
        currentResponse: [],
        currentPage: 1,
        totalPages: 0,
        pageLimit: 10
      }     
    }


      //Retrieve what input
    async clicked() {
      
      if (this.refs.textBox.value.length == 0) {
        console.log('Empty string')
      } else {
        this.setState({
          isOpen: !this.state.isOpen, //Set as true to popup window/alert
          inputText: this.refs.textBox.value.toUpperCase() //get input value and set as Uppercase
        })        
        const { pageLimit } = this.state
        try {          
            const result = await Api.get("stocksingle/"+`${this.refs.textBox.value.toUpperCase()}`+"/2020-01-01/2020-01-31")            
            //console.log("stocksingle/"+`${this.refs.textBox.value.toUpperCase()}`+"/2020-01-01/2020-01-31")
            console.log('BullStock : ', result.data)            
              if(result && result.data && result.data.response){
                const trimmed = result.data.response.slice(0, pageLimit);
                this.setState({ response: result.data.response, trimmedData: trimmed })
              }      

            } catch (e) {
            console.log(`😱 Axios request failed: ${e}`);
          }
      }      
    }

    onPageChanged = data => {    
      const { response } = this.state;
      const { currentPage, pageLimit } = data;
      const trimmed = response.slice((currentPage - 1) * pageLimit, currentPage * pageLimit);    

      this.setState({ trimmedData: trimmed });
    };

    //hide the modal window/alert if applicable
    toggle = () =>{
      this.setState({
        isOpen: false
      })
    }

    // check pages
    onPageChanged = data => {    
      const { response } = this.state;
      const { currentPage, pageLimit } = data;
      const trimmed = response.slice((currentPage - 1) * pageLimit, currentPage * pageLimit);    

      this.setState({ trimmedData: trimmed });
    }

// <Form onSubmit={this.handleSubmit} inline>                 
// <Modal show={this.state.isOpen} onHide={this.toggle} 

    render() { 

      const { response, pageLimit, trimmedData } = this.state;
      const totalResponses = response.length;
      if (totalResponses === 0) return null;

      const rows = trimmedData.map((single) => (     
        <tr key={single.id_ticker}>          
          <td>{single.dt_trx.substring(0,10)}</td>
          <td>{new Intl.NumberFormat().format(single.open_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.high_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.low_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.close_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.volume_trx)}</td>
          <td>{new Intl.NumberFormat().format(single.value_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.freq_trx)}</td>
          <td>{new Intl.NumberFormat().format(single.nbsa_buy_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.nbsa_sell_prc)}</td>
          <td>{new Intl.NumberFormat().format(single.nbsa_prc)}</td>          
        </tr>
        )
      );

      return (       
        <div>
        <br/>

          <Alert variant="primary" onClose={this.toggle} dismissible>
            You type as <strong>{this.state.inputText}</strong>
          </Alert>

          <Form onSubmit={(e) => {this.clicked()}} inline>         
            <FormControl ref="textBox" type="text" value={this.state.tickerId} onChange={this.handleChange} placeholder="TickerID" className="mr-sm-2" />
            <Button variant="outline-primary" type="submit"  >Submit!</Button>
          </Form>

          {/*Modal window*/}
          {/*show={this.state.isOpen} onHide={this.toggle}*/}
          <Modal 
            size="lg"
            aria-labelledby="contained-modal-title-vcenter"
            centered>
            <Modal.Header closeButton>
              <ModalTitle className="text-center">Title </ModalTitle>
            </Modal.Header>
            <ModalBody>
              <Container className="container-fluid">
              {this.state.inputText}
              </Container>
            </ModalBody>
            <ModalFooter>
              <Button color="primary" size="sm" onClick={this.toggle}>Close</Button>
            </ModalFooter>
          </Modal>


          {/*Table*/}
        <br/>
        <Row>
            <Col xs={12} md={8}>
              <h2><strong className="text-secondary">{totalResponses}</strong> </h2>
            </Col>
            <Col xs={6} md={4}>
              <Pagination totalRecords={totalResponses} pageLimit={pageLimit} pageNeighbours={1} onPageChanged={this.onPageChanged} />
            </Col>
          </Row>
          <Table striped bordered hover size="sm">
            <thead>
              <tr>                  
                <th>Date</th>
                <th>Open</th>
                <th>High</th>
                <th>Low</th>
                <th>Close</th>
                <th>Volume</th>
                <th>Value</th>
                <th>Freq</th>
                <th>NBSA Buy</th>
                <th>NBSA Sell</th>
                <th>NBSA Total</th>
              </tr>
            </thead>
            <tbody>
              {rows}
            </tbody>
          </Table>

        </div>          
      );
  }
}