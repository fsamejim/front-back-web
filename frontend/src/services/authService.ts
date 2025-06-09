import axios from 'axios';
import { LoginRequest, RegisterRequest, AuthResponse } from '../types/auth';

const API_URL = 'http://localhost:8080/api/auth';

export const authService = {
    login: async (credentials: LoginRequest): Promise<AuthResponse> => {
        const response = await axios.post(`${API_URL}/login`, credentials);
        return response.data;
    },

    register: async (data: RegisterRequest): Promise<AuthResponse> => {
        const response = await axios.post(`${API_URL}/register`, data);
        return response.data;
    },

    getCurrentUser: async (): Promise<AuthResponse> => {
        const token = localStorage.getItem('token');
        if (!token) {
            throw new Error('No token found');
        }

        const response = await axios.get(`${API_URL}/me`, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
        return response.data;
    }
};

// Axios interceptor for adding token to requests
axios.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
); 