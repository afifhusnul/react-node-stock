import React from 'react';
import { Nav, Navbar,NavDropdown, Form, FormControl, Button} from 'react-bootstrap';
import {HashRouter } from 'react-router-dom';

// import Navbar from 'react-bootstrap/Navbar';
// import Nav from 'react-bootstrap/Nav';
// import NavDropdown from 'react-bootstrap/NavDropdown';
// import Form from 'react-bootstrap/Form';
// import FormControl from 'react-bootstrap/FormControl';
// import Button from 'react-bootstrap/Button';

export default class Header extends React.Component {
  render() {
    return (
      <HashRouter>
      <Navbar bg="light" expand="lg">
        <Navbar.Brand href="/">Info Stock</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="mr-auto">                        
            {/* <Nav.Link href="#master">Master Stock</Nav.Link> */}
            <NavDropdown title="Master Data" id="basic-nav-dropdown">
              <NavDropdown.Item href="#infodata">Info data</NavDropdown.Item>
              <NavDropdown.Item href="#master">Master Stock</NavDropdown.Item>
            </NavDropdown>
            <NavDropdown title="Info Stock" id="basic-nav-dropdown">
              <NavDropdown.Item href="#bull">Bull Stock</NavDropdown.Item>
              <NavDropdown.Item href="#bear">Bear Stock</NavDropdown.Item>
              <NavDropdown.Item href="#ranking">Ranking Stock</NavDropdown.Item>
              <NavDropdown.Divider />
              <NavDropdown.Item href="#reversal">Reversal</NavDropdown.Item>
            </NavDropdown>
          </Nav>
          <Form inline>
            <FormControl type="text" placeholder="Search" className="mr-sm-2" />
            <Button variant="outline-success">Search</Button>
          </Form>
        </Navbar.Collapse>
      </Navbar>
      </HashRouter>
    )
  }
}