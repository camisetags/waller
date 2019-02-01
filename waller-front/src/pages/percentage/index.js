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
      result_date: ''
    }
  };

  componentDidMount() {
    wallService
      .getWall(this.props.match.params.wall_id)
      .then(response => this.setUsersState(response.data));
  }

  setUsersState(data) {
    const { users, ...wall } = data;
    const diffDate = this.diffDate(wall.result_date);

    this.setState({
      wall: {
        result_date: diffDate
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
    const dateDiff = moment.duration(resultDate.diff(dateNow));

    // const timeDiff = Math.abs(resultDate - dateNow) / 36e5;
    // const dateDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
    return dateDiff.asHours();
  }

  render() {
    const { users, votedUser } = this.state;
    const { wall_id: wallID } = this.props.match.params;

    console.log(this.state.wall);

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

            <div className="result-date">{this.state.wall.result_date}</div>
          </div>
        </div>
      </Fragment>
    );
  }
}

export default Percentage;
