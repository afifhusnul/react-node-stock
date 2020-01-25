import React, { Component } from 'react';
import {Table,Row, Col} from 'react-bootstrap';
import Api from '../../utils/Api';
import Pagination from "../../utils/Pagination";


export default class RankingVolume extends Component {

 constructor(props) {
    super(props);

    this.state = {
      response: [],
      trimmedData: [],
      currentResponse: [],
      currentPage: 1,
      totalPages: 0,
      pageLimit: 10
    };
    
  }
  async componentDidMount() {
    const { pageLimit } = this.state
    try {
        const result = await Api.get("/ranking/volume")
        console.log('Rangking Volume : ', result.data)
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
      <td>{single.id_ticker}</td>
      <td>{single.dt_trx.substring(0,10)}</td>
      <td>{new Intl.NumberFormat().format(single.ma1)}</td>
      <td>{new Intl.NumberFormat().format(single.ma2)}</td>
      <td>{new Intl.NumberFormat().format(single.vol_prc)}</td>
      <td>{new Intl.NumberFormat().format(single.vol2)}</td>
      <td>{new Intl.NumberFormat().format(single.vol3)}</td>
      <td>{new Intl.NumberFormat().format(single.vol4)}</td>
      <td>{new Intl.NumberFormat().format(single.vol5)}</td>      
      <td>{new Intl.NumberFormat().format(single.avg_vol_5day)}</td>                    
      <td>{single.up_p}</td>
    </tr>
    )
  );

    return (      
      <div>
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
                  <th>Ticker ID</th>
                  <th>Date</th>
                  <th>Ma1</th>
                  <th>Ma2</th>
                  <th>Ttl Volume</th>
                  <th>Vol 2</th>
                  <th>Vol 3</th>
                  <th>Vol 4</th>
                  <th>Vol 5</th>                  
                  <th>Avg Vol (5D)</th>                  
                  <th>%</th>
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
