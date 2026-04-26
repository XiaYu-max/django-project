import axios from 'axios'
import client from '@/core/api/client'

export const baseApi = {
    // 登入不需要帶 token，直接用原始 axios
    login: async (username: string, password: string) => {
        const res = await axios.post('/api/auth/token/', { username, password })
        return res.data
    },

    getRoles: () => client.get('/base/roles/'),
    getUsers: () => client.get('/base/users/')
}
