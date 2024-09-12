import Toast from '~/components/Toast.vue';

export default defineNuxtPlugin((nuxtApp) => {
  // Register the Toast component globally
  nuxtApp.vueApp.component('Toast', Toast);

  // Use a reactive variable to hold the toast instance
  let toastInstance = null;

  // Function to set the toast instance
  nuxtApp.provide('setToastInstance', (instance) => {
    toastInstance = instance;
  });

  // Event listener for 'show-toast'
  nuxtApp.provide('triggerToast', ({ title, message, type, icon }) => {
    if (toastInstance) {
      toastInstance.showToast(title, message, type, icon);
    }
  });
});