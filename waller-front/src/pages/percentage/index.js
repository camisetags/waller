import React, { Fragment } from 'react';
import Header from '../../components/header';
import Divisor from '../../components/divisor';
import UserImage from '../../components/userImage';
import wallService from '../../services/wall';
import SemiPieChart from '../../components/semiPieChart';

import { calcDiffDate } from '../../utils';

import './style.scss';

class Percentage extends React.Component {
  state = {
    users: [],
    votedUser: {},
    totalVotes: null,

    diffDateUnity: 'dias',
    diffDate: 0
  };

  componentDidMount() {
    wallService.getWall(this.props.match.params.wall_id).then(response => {
      this.setUsersState(response.data);
      this.diffDate(response.data.result_date);
    });
  }

  setUsersState(data) {
    const { users, total_votes } = data;

    this.setState({
      totalVotes: total_votes,
      users,
      votedUser: users.find(
        user => user.id === parseInt(this.props.match.params.voted_user)
      ) || { name: 'undefined' }
    });
  }

  diffDate(result) {
    const resultDate = new Date(result);
    const dateNow = new Date();

    const { diffDateUnity, diffDate } = calcDiffDate({ dateNow, resultDate });

    this.setState({
      diffDate,
      diffDateUnity
    });
  }

  render() {
    const { users, votedUser, totalVotes } = this.state;
    const { wall_id: wallID } = this.props.match.params;

    return (
      <Fragment>
        <div className="percentage-page">
          <Header path={`/big-wall/${wallID}`}>Quem deve ser eliminado?</Header>
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
              <SemiPieChart users={users} totalVotes={totalVotes} />
            </div>

            <div className="result-date">
              Restam
              <div className="result-day">
                <b>{this.state.diffDate}</b>
              </div>
              {this.state.diffDateUnity} para encerrar a votação
            </div>
          </div>
        </div>
      </Fragment>
    );
  }
}

export default Percentage;
