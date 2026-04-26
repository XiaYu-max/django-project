import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { baseApi } from '@/modules/base/api'

export const useAuthStore = defineStore('auth', () => {
    const accessToken = ref<string | null>(localStorage.getItem('access_token'))
    const refreshToken = ref<string | null>(localStorage.getItem('refresh_token'))
    const username = ref<string | null>(localStorage.getItem('username'))

    const isLoggedIn = computed(() => !!accessToken.value)

    async function login(user: string, password: string) {
        const data = await baseApi.login(user, password)
        accessToken.value = data.access
        refreshToken.value = data.refresh
        username.value = user
        localStorage.setItem('access_token', data.access)
        localStorage.setItem('refresh_token', data.refresh)
        localStorage.setItem('username', user)
    }

    function logout() {
        accessToken.value = null
        refreshToken.value = null
        username.value = null
        localStorage.removeItem('access_token')
        localStorage.removeItem('refresh_token')
        localStorage.removeItem('username')
    }

    return { accessToken, refreshToken, username, isLoggedIn, login, logout }
})
