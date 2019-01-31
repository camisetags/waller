import axiosInstance from './axios';

const captchaService = {
  verifyToken(token) {
    return axiosInstance
      .post(`/verify-captcha/`, { response: token })
      .then(response => response.data);
  }
};

export default captchaService;
