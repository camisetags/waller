import React from 'react';
import './style.scss';

const UserImage = props => (
  <img src={props.src} className="user-image" alt="wall user" />
);

export default UserImage;
