// Need to install chartjs
import React from 'react';
import { Doughnut } from 'react-chartjs-2';

class Chart extends React.Component {
  state = {
    options: {
      circumference: Math.PI * 1.2,
      cutoutPercentage: 80,
      rotation: -1.1 * Math.PI,
      legend: {
        display: false
      },
      tooltips: {
        callbacks: {
          label: this.tooltipLabelCallback
        }
      }
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
    if (props.users && props.totalVotes) {
      const userVotesPercentage = props.users.map(user => {
        return Math.round((user.votes / props.totalVotes) * 100);
      });

      return {
        ...state,
        data: {
          labels: props.users.map(user => user.name),
          datasets: [
            {
              ...state.data.datasets[0],
              data: userVotesPercentage
            }
          ]
        }
      };
    }
    return {
      ...state
    };
  }

  tooltipLabelCallback(tooltipItem, data) {
    const dataIndex = tooltipItem.index;
    const userPercentage = data.datasets[0].data[dataIndex];

    return `${data.labels[dataIndex]}: ${userPercentage}%`;
  }

  render() {
    return (
      <Doughnut
        data={this.state.data}
        options={this.state.options}
        width={40}
        height={15}
      />
    );
  }
}

export default Chart;
