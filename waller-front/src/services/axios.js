import axios from 'axios';
import { cacheAdapterEnhancer } from 'axios-extensions';

const axiosInstance = axios.create({
  baseURL: process.env.API_URL,
  mode: 'no-cors',
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json'
  },
  adapter: cacheAdapterEnhancer(axios.defaults.adapter)
});

window.axios = axiosInstance;

export default axiosInstance;
