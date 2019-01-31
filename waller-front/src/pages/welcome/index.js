import React from 'react';
import { Link } from 'react-router-dom';
import wallService from '../../services/wall';

class WelcomePage extends React.Component {
  state = {
    walls: []
  };

  componentDidMount() {
    wallService.getDoublesWalls().then(response => {
      this.setState({
        walls: response.data.entries
      });
    });
  }

  render() {
    const { walls } = this.state;

    return (
      <>
        <h1>Bem vindo ao paredão do big brother Brasil!</h1>
        <hr />
        Selecione algum paredão:
        <ul>
          {walls.map(wall => (
            <li key={wall.id}>
              <Link to={`/big-wall/${wall.id}`}>Paredão número {wall.id}</Link>
            </li>
          ))}
        </ul>
      </>
    );
  }
}

export default WelcomePage;
