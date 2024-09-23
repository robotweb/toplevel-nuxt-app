import { useToast } from '~/composables/useToast'

export default defineNuxtPlugin((nuxtApp) => {
  const { triggerToast } = useToast()

  nuxtApp.provide('toast', {
    trigger: triggerToast
  })
})