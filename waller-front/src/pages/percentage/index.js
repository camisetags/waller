import React from 'react';
import { Col, Row } from 'reactstrap';
import Header from '../../components/header';
import Divisor from '../../components/divisor';
import UserSelector from '../../components/userSelector';
import wallService from '../../services/wall';

class Percentage extends React.Component {
  state = {
    users: []
  };

  compoenentDidMount() {
    wallService.getWall(this.props.match.params.wall_id).then(response => {
      this.setState({
        users: response.data.users
      });
    });
  }

  render() {
    const { users } = this.state;
    return (
      <>
        <Header path="/big-wall">Quem deve ser eliminado?</Header>
        <Divisor />
        <Row>
          {users.map(user => (
            <Col key={user.id}>
              <b>{user.name}</b>
              <UserSelector
                user={user}
                setSelectedUser={this.setSelectedUser}
              />
            </Col>
          ))}
        </Row>
      </>
    );
  }
}

export default Percentage;
