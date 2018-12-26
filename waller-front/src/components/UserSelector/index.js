import React from 'react';
import UserImage from '../UserImage';
import './style.scss';

const UserSelector = ({ user, setSelectedUser }) => (
  <label>
    <input
      type="radio"
      name="user-vote"
      value={user.id}
      onChange={setSelectedUser}
    />
    <UserImage src={user.photo} />
  </label>
);

export default UserSelector;
