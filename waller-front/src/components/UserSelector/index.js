import React from 'react';
import UserImage from '../UserImage';
import './style.scss';

const UserSelector = ({ user, setSelectedUser }) => (
  <div>
    <label>
      <input
        type="radio"
        name="user-vote"
        value={user.id}
        onChange={setSelectedUser}
      />
      <UserImage src={user.photo} />
    </label>
  </div>
);

export default UserSelector;
