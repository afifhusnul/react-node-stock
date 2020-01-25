import React, { Component } from 'react';
import {Container, Button, Modal, ModalTitle, ModalBody, ModalFooter} from 'react-bootstrap';
//import Api from '../../utils/Api';

export default class ModalKu extends Component {

  constructor(props) {
      super(props)
      this.state = {
        modal: false
      }
    }
  
    toggle = () => {
      this.setState(prevState => ({
        modal: !prevState.modal
      }))
    }

    render() {
      return(
        <Modal isOpen={this.state.modal} toggle={this.toggle} className={this.props.className}
          size="lg"
          aria-labelledby="contained-modal-title-vcenter"
          centered >
            <Modal.Header toggle={this.toggle} closeButton>
              <ModalTitle className="text-center">Apis</ModalTitle>
            </Modal.Header>
            <ModalBody>
              <Container className="container-fluid">
                
              </Container>
            </ModalBody>
            <ModalFooter>
            <Button color="primary" size="sm" toggle={this.toggle}>Close</Button>
          </ModalFooter>
        </Modal>
      )
    }
}