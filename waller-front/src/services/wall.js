import axiosInstance from './axios';

const wallService = {
  async getDoublesWalls() {
    const response = await axiosInstance.get('/api/walls?only_doubles=true', {
      cache: true
    });
    return response.data;
  },

  async getWall(wallId) {
    const response = await axiosInstance.get(`/api/walls/status/${wallId}`);
    return response.data;
  },

  async sendVote({ wallID, userID }) {
    const response = await axiosInstance.post(
      `/api/walls/vote/${wallID}/to/${userID}`
    );
    return response.data;
  }
};

export default wallService;
