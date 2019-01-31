import axiosInstance from './axios';

const userService = {
  async getUser(id) {
    const response = await axiosInstance.get(`/api/users/${id}`);
    return response.data;
  }
};

export default userService;
