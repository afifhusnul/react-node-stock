import React, { Component } from 'react';
import {Table, Row, Col} from 'react-bootstrap';
import Api from '../utils/Api';
import Pagination from "../utils/Pagination";
import ModalInfoResSup from './modal/ModalResSupport';
//import ModalKu from './modal/ModalKu';

export default class MasterStock extends Component { 
  constructor(props) {
    super(props);

    this.state = {
      response: [],
      trimmedData: [],
      currentResponse: [],
      currentPage: 1,
      totalPages: 0,
      pageLimit: 15,
      show: false,
      tickerNew: undefined
    }
    this.onModalClick = this.onModalClick.bind(this)
  }

  refModalInfo = ({handleShow}) => {
    this.showModal = handleShow;
    //console.log("Ticker Master: ", this.state.tickerNew)    
  }
 
  onModalClick = (tickerId) => {
    this.setState({showModal: true, tickerNew : tickerId }, () => { console.log("Ticker Master: ", this.state.tickerNew)});    
    this.showModal();
  }
  

  

  async componentDidMount() {
    const { pageLimit } = this.state
    try {
        const result = await Api.get("/stockmaster")
        //console.log(result.data)
          if(result && result.data && result.data.response){
            const trimmed = result.data.response.slice(0, pageLimit);
            this.setState({ response: result.data.response, trimmedData: trimmed })
          }      

        } catch (e) {
        console.log(`😱 Axios request failed: ${e}`);
      }
  }

  onPageChanged = data => {    
    const { response } = this.state;
    const { currentPage, pageLimit } = data;
    const trimmed = response.slice((currentPage - 1) * pageLimit, currentPage * pageLimit);    

    this.setState({ trimmedData: trimmed });
  };

 render() {
  const { response, pageLimit, trimmedData } = this.state;
  const totalResponses = response.length;  
  if (totalResponses === 0) return null;

  const rows = trimmedData.map((single) => (     
    <tr key={single.id_ticker}>
      <td onClick={this.onModalClick.bind(this, single.id_ticker)} ><a href="/#master">{single.id_ticker}</a></td>      
      <td>{single.nm_ticker}</td>      
    </tr>
    )
  );

    return (      
      <div>
        <br/>
        <Row>
          <Col xs={12} md={8}>
            <h2>Master Stock <strong className="text-secondary">{totalResponses}</strong> </h2>
          </Col>
          <Col xs={6} md={4}>
            <Pagination totalRecords={totalResponses} pageLimit={pageLimit} pageNeighbours={1} onPageChanged={this.onPageChanged} />
          </Col>
        </Row>
        <ModalInfoResSup ref={this.refModalInfo}/> 
        
        
        
        <Table striped bordered hover size="sm">          
          <thead>
            <tr>                
              <th>Ticker ID</th>
              <th>Ticker name</th>                
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
