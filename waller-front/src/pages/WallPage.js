import React from 'react';

class WallPage extends React.Component {
  state = {
    users: [],
  };

  componentDidMount() {
    fetch('http://localhost:4000/api/walls/status/1', {
      mode: 'no-cors', 
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
      .then(response => response.text())
      .then(body => {
        console.log(body);
      });
  }

  render() {
    return <div />;
  }
}

export default WallPage;
