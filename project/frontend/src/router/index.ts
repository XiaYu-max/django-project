import { createRouter, createWebHistory, type RouteLocationNormalized } from 'vue-router'
import HomeView from '@/core/views/HomeView.vue'
import { useAuthStore } from '@/stores/auth'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        // ── 系統層級（core） ─────────────────────────────────────
        {
            path: '/',
            name: 'home',
            component: HomeView
        },
        {
            path: '/dashboard',
            name: 'dashboard',
            component: HomeView,
            meta: { requiresAuth: true }
        },

        // ── base 模組 ────────────────────────────────────────────
        {
            path: '/login',
            name: 'login',
            component: () => import('@/modules/base/views/LoginView.vue')
        },

        // ── pos_menu 模組 ────────────────────────────────────────
        {
            path: '/order',
            name: 'order',
            component: () => import('@/modules/pos_menu/views/OrderView.vue')
        },

        // ── 其他模組（開發後陸續加入） ───────────────────────────
        // { path: '/menu',    component: () => import('@/modules/pos_menu/views/MenuList.vue') },
        // { path: '/kitchen', component: () => import('@/modules/pos_kitchen/views/KitchenView.vue') },
        // { path: '/payment', component: () => import('@/modules/pos_payment/views/PaymentView.vue') },
        // { path: '/report',  component: () => import('@/modules/pos_report/views/ReportView.vue') },
    ]
})

router.beforeEach((to: RouteLocationNormalized) => {
    const auth = useAuthStore()
    if (to.meta.requiresAuth && !auth.isLoggedIn) {
        return { name: 'login' }
    }
})

export default router
