import React, { Fragment } from 'react';
import Header from '../../components/header';
import Divisor from '../../components/divisor';
import UserImage from '../../components/userImage';
import wallService from '../../services/wall';
import SemiPieChart from '../../components/semiPieChart';
import './style.scss';

class Percentage extends React.Component {
  state = {
    users: [],
    votedUser: {}
  };

  componentDidMount() {
    wallService
      .getWall(this.props.match.params.wall_id)
      .then(response => this.setUsersState(response.data.users));
  }

  setUsersState(users) {
    this.setState({
      users: users,
      votedUser: users.find(
        user => user.id === parseInt(this.props.match.params.voted_user)
      ) || { name: 'undefined' }
    });
  }

  render() {
    const { users, votedUser } = this.state;
    return (
      <Fragment>
        <Header path="/big-wall">Quem deve ser eliminado?</Header>
        <Divisor />
        <div className="main-container">
          <div className="vote-success-message">
            <b>Parabéns!</b> Seu voto para <b>{votedUser.name}</b> foi enviado
            com sucesso.
          </div>

          <div className="users-container">
            {users.map(user => (
              <div key={user.id}>
                <UserImage key={user.id} src={user.photo} />
              </div>
            ))}
          </div>

          <div className="chart">
            <SemiPieChart users={users} />
          </div>
        </div>
      </Fragment>
    );
  }
}

export default Percentage;
