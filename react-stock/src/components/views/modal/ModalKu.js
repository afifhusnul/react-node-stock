import React, { Component } from 'react';
import {Container, Button, Modal, ModalTitle, ModalBody, ModalFooter} from 'react-bootstrap';
import Api from '../../utils/Api';

export default class ModalKu extends Component {

constructor(props) {
    super(props)
  }


  render() {
    return(        
      <Modal show={this.props.show} onHide={() => this.props.onHide({ msg: 'Just click' })}
        size="lg"
        aria-labelledby="contained-modal-title-vcenter"
        centered >
          <Modal.Header onHide={() => this.props.onHide({})} closeButton>
            <ModalTitle >Apis</ModalTitle>
          </Modal.Header>
          <ModalBody>
            <Container className="container-fluid">
            Isi : {this.props.tickerId}
            </Container>
          </ModalBody>
          <ModalFooter>
          <Button color="primary" size="sm" onClick={() => this.props.onHide({})}>Close</Button>
        </ModalFooter>
      </Modal>
    )
  }
}