import React from 'react';
import { Jumbotron, Col, Row } from 'reactstrap'
import axios from 'axios';

const service = {
  async getWall() {
    return axios.get('http://localhost:4000/api/walls/status/1')
      .then(response => response.data);
  }
};

class WallPage extends React.Component {
  state = {
    users: [],
  };

  componentDidMount() {
    service.getWall()
      .then((response) => {
        this.setState({
          users: response.users
        })
      });
  }

  render() {
    return (
      <div>
        <Jumbotron>
          <Row>
            {this.state.users.slice(0, 2).map(user => (
              <Col>
                {user.name}
              </Col>
            ))}
          </Row>
        </Jumbotron>        
      </div>
    );
  }
}

export default WallPage;
