import React from 'react';
import { Link } from 'react-router-dom';
import { Button } from 'reactstrap';

const WelcomePage = () => (
  <>
    <h1>Bem vindo ao paredão do big brother Brasil!</h1>
    <hr />
    <Link to="/big-wall">
      <Button color="primary">Ir para o paredão</Button>
    </Link>
  </>
);

export default WelcomePage;
