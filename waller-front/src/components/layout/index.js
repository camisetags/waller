import React from 'react';
import { Jumbotron, Container } from 'reactstrap';
import './style.scss';

const Layout = ({ children }) => (
  <>
    <Container className="content">
      <div className="close-button" />

      <Jumbotron className="container-box">{children}</Jumbotron>
    </Container>
  </>
);

export default Layout;
