import axiosInstance from './axios';

const wallService = {
  getDoublesWalls() {
    return axiosInstance
      .get('/api/walls?only_double=true')
      .then(response => response.data);
  },

  getWall(wallId) {
    return axiosInstance
      .get(`/api/walls/status/${wallId}`)
      .then(response => response.data);
  },

  sendVote({ wallID, userID }) {
    return axiosInstance
      .post(`/api/walls/vote/${wallID}/to/${userID}`)
      .then(response => response.data);
  }
};

export default wallService;
