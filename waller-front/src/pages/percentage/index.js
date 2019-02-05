import React, { Fragment } from 'react';
import moment from 'moment';
import Header from '../../components/header';
import Divisor from '../../components/divisor';
import UserImage from '../../components/userImage';
import wallService from '../../services/wall';
import SemiPieChart from '../../components/semiPieChart';
import './style.scss';

class Percentage extends React.Component {
  state = {
    users: [],
    votedUser: {},
    wall: {
      result_date: null
    }
  };

  componentDidMount() {
    wallService
      .getWall(this.props.match.params.wall_id)
      .then(response => this.setUsersState(response.data));
  }

  setUsersState(data) {
    const { users, ...wall } = data;

    this.setState({
      wall: {
        result_date: wall.result_date
      },
      users,
      votedUser: users.find(
        user => user.id === parseInt(this.props.match.params.voted_user)
      ) || { name: 'undefined' }
    });
  }

  diffDate(result) {
    const resultDate = moment(new Date(result));
    const dateNow = moment(new Date());
    const diffDays = resultDate.diff(dateNow, 'days');

    return this.diffElement({ diffDays, dateNow, resultDate });
  }

  diffElement({ diffDays, dateNow, resultDate }) {
    const diffHours = diffDays === 1 ? resultDate.diff(dateNow, 'hours') : null;
    const diffUnity = diffDays <= 1 ? diffHours : diffDays;
    const diffUnityString = diffDays <= 1 ? 'horas' : 'dias';

    return (
      <div className="result-date">
        Restam
        <div className="result-day">
          <b>{diffUnity}</b>
        </div>
        {diffUnityString} para encerrar a votação
      </div>
    );
  }

  render() {
    const { users, votedUser } = this.state;
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
              <SemiPieChart users={users} />
            </div>

            {this.diffDate(this.state.wall.result_date)}
          </div>
        </div>
      </Fragment>
    );
  }
}

export default Percentage;
