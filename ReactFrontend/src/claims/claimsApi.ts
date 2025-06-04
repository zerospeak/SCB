import axios from 'axios';
import { Claim } from './types';

function getApiUrl() {
  if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    return 'http://localhost:5000/api/claims';
  }
  return 'http://webapi/api/claims';
}
const API_URL = getApiUrl();

// Attach JWT to all requests
axios.interceptors.request.use(config => {
  const token = localStorage.getItem('jwt_token');
  if (token) {
    config.headers = config.headers || {};
    config.headers['Authorization'] = `Bearer ${token}`;
  }
  return config;
});

export const getClaims = async (): Promise<Claim[]> => {
  const res = await axios.get<Claim[]>(API_URL);
  return res.data;
};

export const getClaim = async (id: number): Promise<Claim> => {
  const res = await axios.get<Claim>(`${API_URL}/${id}`);
  return res.data;
};

export const createClaim = async (claim: Claim): Promise<Claim> => {
  const res = await axios.post<Claim>(API_URL, claim);
  return res.data;
};

export const updateClaim = async (id: number, claim: Claim): Promise<Claim> => {
  const res = await axios.put<Claim>(`${API_URL}/${id}`, claim);
  return res.data;
};

export const deleteClaim = async (id: number): Promise<void> => {
  await axios.delete(`${API_URL}/${id}`);
};
