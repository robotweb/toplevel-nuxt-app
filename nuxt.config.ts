// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  plugins: [
    '~/plugins/toast.js'
  ],

  compatibilityDate: '2024-04-03',
  devtools: { enabled: false },

  css: [
    "@/assets/styles/layout.scss"
  ],

  vite: {
    server: {
      hmr: {
        protocol: 'ws',
        host: 'localhost'
      }
    },
    define: {
      API_URL: JSON.stringify(process.env.API_URL),
      APP_NAME: JSON.stringify(process.env.APP_NAME),
      API_BASE_URL: JSON.stringify(process.env.API_BASE_URL)
    },
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: '@import "@/assets/styles/_variables.scss";',
        },
      },
    },
  },

  runtimeConfig: {
    public: {
      apiUrl: process.env.API_URL,
    },
  },

  modules: ['@nuxtjs/tailwindcss', 'shadcn-nuxt', "@nuxt/icon"],
})
