import axiosInstance from './axios';

const userService = {
  async getUser(id) {
    const response = await axiosInstance.get(`/api/users/${id}`, {
      cache: true
    });
    return response.data;
  }
};

export default userService;
