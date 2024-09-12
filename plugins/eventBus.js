import { createApp } from 'vue';

export default defineNuxtPlugin((nuxtApp) => {
  // Create a new Vue instance to act as an event bus
  const eventBus = createApp({});

  // Provide the event bus globally
  nuxtApp.provide('eventBus', eventBus);
});