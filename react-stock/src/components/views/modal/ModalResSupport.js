import React, { Component } from 'react';
import {Container, Row, Col, Button, Modal, ModalTitle, ModalBody, ModalFooter} from 'react-bootstrap';
import Api from '../../utils/Api';

export default class ModalResSupport extends Component {

  constructor(props, context){
      super(props, context);
      this.handleShow = this.handleShow.bind(this);
      this.handleClose = this.handleClose.bind(this);
      this.state = {
          show: false,          
          response: []
      }      
  }
  
  async handleShow() {    
    this.setState({ show: true })      
    try {
        const result = await Api.get("/stockinfo/wika")
        console.log(result.data)
          if(result && result.data && result.data.response){            
            this.setState({ response: result.data.response })
          }      

        } catch (e) {
        console.log(`😱 Axios request failed: ${e}`);
      }
  }
  

  handleClose(){
      this.setState({ show: false })
  }
  
  render() {    
    const { response } = this.state;
    const totalResponses = response.length;  
    if (totalResponses === 0) return null;    

    return (
      <Modal show={this.state.show} onHide={this.handleClose} 
        size="lg"
        aria-labelledby="contained-modal-title-vcenter"
        centered>
        <Modal.Header closeButton>
          <ModalTitle className="text-center">{response.id_ticker} | {response.nm_ticker} </ModalTitle>
        </Modal.Header>
        <ModalBody>
        <Container className="container-fluid">
          <Row>
            <Col className="border border-primary">Last Transcation (Rupiah) : </Col>
            <Col className="border border-primary">{new Intl.NumberFormat().format(response.last_trx_prc)}</Col>
          </Row>
          <Row>
            <Col className="border border-primary">Last Volume : </Col>
            <Col className="border border-primary">{new Intl.NumberFormat().format(response.last_trx_vol)}</Col>
          </Row>
          <Row>
            <Col className="border border-primary">Last price : </Col>
            <Col className="border border-primary">{new Intl.NumberFormat().format(response.ma1)}</Col>
          </Row>
          <Row>
            <Col className="text-center border border-primary"><h2>Pivot Entry : {new Intl.NumberFormat().format(response.pivot_entry)}</h2></Col>
          </Row>
          <Row>
            <Col className="text-center border border-primary"><h2>Resisten</h2></Col>
            <Col className="text-center border border-primary"><h2>Support</h2></Col>
          </Row>
          <Row>
            <Col className="text-center border border-primary" >{new Intl.NumberFormat().format(response.r1)} | {new Intl.NumberFormat().format(response.r2)} | {new Intl.NumberFormat().format(response.r3)}</Col>
            <Col className="text-center border border-primary">{new Intl.NumberFormat().format(response.s1)} | {new Intl.NumberFormat().format(response.s2)} | {new Intl.NumberFormat().format(response.s3)}</Col>
          </Row>
          </Container>
        </ModalBody>
        <ModalFooter>
          <Button color="primary" size="sm" onClick={this.handleClose}>Close</Button>
        </ModalFooter>
      </Modal>
      )
  }


  
}
