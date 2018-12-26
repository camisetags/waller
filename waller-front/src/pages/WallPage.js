import React from 'react';
import { Link } from 'react-router-dom';
import { Col, Row, Button } from 'reactstrap';
import wallService from '../services/wall';

import Layout from '../components/Main';
import HeaderTitle from '../components/HeaderTitle';
import UserSelector from '../components/UserSelector';

class WallPage extends React.Component {
  state = {
    name: 'test',
    users: [],
    selectedVote: -1
  };

  componentDidMount() {
    wallService.getWall(1).then(data => {
      this.setState({
        users: data.data.users
      });
    });
  }

  setSelectedUser = e => {
    this.setState({
      selectedVote: e.target.value
    });
  };

  sendVote = e => {};

  render() {
    const divStyle = {
      display: 'grid'
    };

    const buttonStyle = {
      alignSelf: 'center',
      justifySelf: 'center'
    };
    return (
      <Layout>
        <Link to={'/'}>Voltar</Link>
        <HeaderTitle>Quem deve ser eliminado?</HeaderTitle>

        <hr />
        <Row>
          {this.state.users.slice(0, 2).map((user, index) => (
            <Col key={user.id}>
              <b>{user.name}</b>
              <UserSelector
                user={user}
                setSelectedUser={this.setSelectedUser}
              />
              <div>
                Para eliminar o participante {user.name} ligue para o telefone
                0800-123-00{index + 1} ou mande um SMS para 0800{index + 1}
              </div>
            </Col>
          ))}
        </Row>
        <hr />
        <div style={divStyle}>
          <Button style={buttonStyle} color="primary">
            Envie seu voto agora
          </Button>
        </div>
      </Layout>
    );
  }
}

export default WallPage;
