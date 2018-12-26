import axiosInstance from './axios';

const wallService = {
  getWall(wallId) {
    return axiosInstance
      .get(`/api/walls/status/${wallId}`)
      .then(response => response.data);
  }
};

export default wallService;
