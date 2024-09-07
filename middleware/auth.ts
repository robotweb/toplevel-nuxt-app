export default defineNuxtRouteMiddleware((to, from) => {
  // Ensure this only runs on the client side
  if (process.client) {
    const token = localStorage.getItem('auth');

    if(!token){
      return navigateTo('/login');
    }
  }
});