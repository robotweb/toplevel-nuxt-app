// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  plugins: [
    '~/plugins/eventBus.js',
    '~/plugins/toast.js'
  ],
  compatibilityDate: '2024-04-03',
  devtools: { enabled: true },
  css: [
    "@/assets/styles/layout.scss"
  ],
  vite: {
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
})
