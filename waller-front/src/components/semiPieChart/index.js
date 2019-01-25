// Need to install chartjs
import React from 'react';
import { Doughnut } from 'react-chartjs-2';

class Chart extends React.Component {
  state = {
    options: {
      circumference: Math.PI * 1.2,
      cutoutPercentage: 80,
      rotation: -1.1 * Math.PI
    },

    data: {
      labels: ['', ''],
      datasets: [
        {
          data: [12, 19],
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)'
          ]
        }
      ]
    }
  };

  static getDerivedStateFromProps(props, state) {
    if (props.user) {
      return {
        ...state,
        data: {
          labels: props.users.map(user => user.name),
          datasets: [
            {
              data: props.users.map(user => user.votes)
            }
          ]
        }
      };
    }
    return {
      ...state
    };
  }

  render() {
    return (
      <Doughnut
        data={this.state.data}
        options={this.state.options}
        width={50}
        height={20}
      />
    );
  }
}

export default Chart;
