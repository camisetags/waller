import React from 'react';
import { Link } from 'react-router-dom';
import Layout from '../components/Main';
import { Button } from 'reactstrap';

const WelcomePage = () => (
  <Layout>
    <h1>Bem vindo ao paredão do big brother Brasil!</h1>
    <hr />
    <Link to="/big-wall">
      <Button color="primary">Ir para o paredão</Button>
    </Link>
  </Layout>
);

export default WelcomePage;
