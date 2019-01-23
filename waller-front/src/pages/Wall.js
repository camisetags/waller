import React from 'react';
import { Redirect } from 'react-router-dom';
import { Button, Modal, ModalHeader, ModalBody } from 'reactstrap';
import Recaptcha from 'react-recaptcha';

import wallService from '../services/wall';
import Header from '../components/Header';
import UserSelector from '../components/UserSelector';
import Divisor from '../components/Divisor';
import captchaService from '../services/captcha';

class WallPage extends React.Component {
  state = {
    name: 'test',
    users: [],
    selectedVoteID: -1,
    modalIsOpen: false,
    validUser: false,
    sitekey: '6Ldlm4UUAAAAAGLrxcMRgCl1X965NY0W2ikpZi5z'
  };

  componentDidMount() {
    wallService.getWall(this.props.match.params.wall_id).then(response => {
      this.setState({
        users: response.data.users
      });
    });
  }

  setSelectedUser = e => {
    this.setState({
      selectedVoteID: e.target.value
    });
  };

  openModal = () => {
    if (this.state.selectedVote !== -1) {
      this.setState(state => ({
        modalIsOpen: !state.modalIsOpen
      }));
    } else {
      alert('Selecione seu voto antes de enviar!');
    }
  };

  verifyCallback = response => {
    const { history, match } = this.props;

    captchaService
      .verifyToken(response)
      .then(response => {
        if (response.data.success) {
          return response.data.success;
        } else {
          throw new Error('Refaça o recaptcha novamente!');
        }
      })
      .then(() =>
        wallService.sendVote({
          wallID: match.params.wall_id,
          userID: this.state.selectedVoteID
        })
      )
      .then(() => history.push(`/results/${match.params.wall_id}`))
      .catch(error => console.log(error));
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
      <>
        <Header path="/">Quem deve ser eliminado?</Header>
        <Divisor />
        <div
          style={{
            display: 'flex',
            flexDirection: 'row',
            flexWrap: 'wrap',
            justifyContent: 'space-between'
          }}
        >
          {this.state.users.map((user, index) => (
            <div
              key={user.id}
              style={{
                height: '400px',
                width: '400px',
                display: 'flex',
                flexDirection: 'column',
                flexWrap: 'wrap',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}
            >
              <b>{user.name}</b>
              <UserSelector
                user={user}
                setSelectedUser={this.setSelectedUser}
              />
              <div>
                Para eliminar o participante {user.name} ligue para o telefone
                0800-123-00{index + 1} ou mande um SMS para 0800{index + 1}
              </div>
            </div>
          ))}
        </div>

        <hr />
        <div style={divStyle}>
          <Button style={buttonStyle} color="primary" onClick={this.openModal}>
            Envie seu voto agora
          </Button>
        </div>

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
      </>
    );
  }
}

export default WallPage;
