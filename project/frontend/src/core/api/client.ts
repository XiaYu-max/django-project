import axios, { type InternalAxiosRequestConfig, type AxiosResponse, type AxiosError } from 'axios'

const client = axios.create({
    baseURL: '/api',
    headers: { 'Content-Type': 'application/json' }
})

// 自動附加 JWT token
client.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    const token = localStorage.getItem('access_token')
    if (token) {
        config.headers.Authorization = `Bearer ${token}`
    }
    return config
})

// 自動 refresh token（401 時）
client.interceptors.response.use(
    (response: AxiosResponse) => response,
    async (error: AxiosError) => {
        if (error.response?.status === 401) {
            const refresh = localStorage.getItem('refresh_token')
            if (refresh) {
                try {
                    const res = await axios.post('/api/auth/token/refresh/', { refresh })
                    localStorage.setItem('access_token', res.data.access)
                    error.config.headers.Authorization = `Bearer ${res.data.access}`
                    return client(error.config)
                } catch {
                    localStorage.removeItem('access_token')
                    localStorage.removeItem('refresh_token')
                    window.location.href = '/login'
                }
            }
        }
        return Promise.reject(error)
    }
)

export default client
