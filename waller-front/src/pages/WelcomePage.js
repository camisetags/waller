import React from 'react';
import { Link } from 'react-router-dom';
import { Jumbotron, Container, Button } from 'reactstrap';

const style = {
  boxShadow: "0px 0px 2px",
  backgroundColor: "white"
};

const containerStyle = {
  padding: "10%",
};

const WelcomePage = () => (
  <div>
    <Container style={containerStyle}>
      <Jumbotron style={style}>
        <h1>Bem vindo ao paredão do big brother Brasil!</h1>
        <hr />
        <Link to="/wall/1">
          <Button color="primary">Ir para o paredão</Button>
        </Link>
      </Jumbotron>
    </Container>
  </div>
);

export default WelcomePage;
