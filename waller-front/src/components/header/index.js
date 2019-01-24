import React from 'react';
import { Link } from 'react-router-dom';
import './style.scss';

const Header = ({ children, path }) => (
  <div className="header-wrapper">
    <div className="text-container header-content">
      <div className="logo" />
      <div className="text-content">{children}</div>
    </div>

    <Link className="header-content" to={path}>
      Voltar
    </Link>
  </div>
);

export default Header;
