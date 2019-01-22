import React from 'react';
import { Col, Row } from 'reactstrap';
import Header from '../components/Header';
import Divisor from '../components/Divisor';

class Percentage extends React.Component {
  render() {
    return (
      <>
        <Header path="/big-wall">Quem deve ser eliminado?</Header>
        <Divisor />
        <Row>
          {this.state.users.slice(0, 2).map((user, index) => (
            <Col key={user.id}>
              <b>{user.name}</b>
              <UserSelector user={user} setSelectedUser={this.setSelectedUser} />
            </Col>
          ))}
        </Row>
      </>
    );
  }
}


export default Percentage;
