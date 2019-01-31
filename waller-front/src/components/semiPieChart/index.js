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
          backgroundColor: ['#ff9400', '#c6c6c6']
        }
      ]
    }
  };

  static getDerivedStateFromProps(props, state) {
    if (props.users) {
      return {
        ...state,
        data: {
          labels: props.users.map(user => user.name),
          datasets: [
            {
              ...state.data.datasets[0],
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
