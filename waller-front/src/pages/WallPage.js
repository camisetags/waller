import React, { Fragment } from 'react';
import { Link, Redirect } from 'react-router-dom';
import { Col, Row, Button, Modal, ModalHeader, ModalBody } from 'reactstrap';
import Recaptcha from 'react-recaptcha';

import wallService from '../services/wall';

import Layout from '../components/Main';
import HeaderTitle from '../components/HeaderTitle';
import UserSelector from '../components/UserSelector';
import Divisor from '../components/Divisor';

class WallPage extends React.Component {
  state = {
    name: 'test',
    users: [],
    selectedVote: -1,
    modalIsOpen: false,
    validUser: false,
    sitekey: '6Ldlm4UUAAAAAGLrxcMRgCl1X965NY0W2ikpZi5z'
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

  openModal = e => {
    if (this.state.selectedVote !== -1) {
      this.setState(state => ({
        modalIsOpen: !state.modalIsOpen
      }));
    } else {
      alert('Selecione seu voto antes de enviar!');
    }
  };

  verifyCallback = response => {
    console.log(response);
  };

  render() {
    const { modalIsOpen, validUser, sitekey } = this.state;

    if (validUser) {
      return <Redirect to="/vote-computed" />;
    }

    const divStyle = {
      display: 'grid'
    };

    const buttonStyle = {
      alignSelf: 'center',
      justifySelf: 'center'
    };

    return (
      <Fragment>
        <Layout>
          <Link to={'/'}>Voltar</Link>
          <HeaderTitle>Quem deve ser eliminado?</HeaderTitle>

          <Divisor />
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
            <Button
              style={buttonStyle}
              color="primary"
              onClick={this.openModal}
            >
              Envie seu voto agora
            </Button>
          </div>
        </Layout>

        <Modal isOpen={modalIsOpen} toggle={this.openModal}>
          <ModalHeader toggle={this.openModal}>
            Antes vamos verificar se você não é um robô!
          </ModalHeader>
          <ModalBody style={{ padding: '20%' }}>
            <Recaptcha
              sitekey={sitekey}
              onloadCallback={this.onLoadRecaptchaCallback}
              verifyCallback={this.verifyCallback}
            />
          </ModalBody>
        </Modal>
      </Fragment>
    );
  }
}

export default WallPage;
