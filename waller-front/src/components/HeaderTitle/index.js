import React from 'react';
import './style.scss';

const HeaderTitle = ({ children }) => (
  <div className="text-container">
    <div className="logo" />
    <div className="text-content">{children}</div>
  </div>
);

export default HeaderTitle;
