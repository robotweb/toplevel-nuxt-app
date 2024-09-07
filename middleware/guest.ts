// middleware/guest.js
export default defineNuxtRouteMiddleware((to, from) => {
    // Ensure this only runs on the client side
    if (process.client) {
      const token = localStorage.getItem('auth');
  
      // List of routes where redirection should happen if logged in
      const guestRoutes = ['/login', '/register', '/reset-password'];
  
      // Check if the user is logged in and on a guest page
      if (token && guestRoutes.includes(to.path)) {
        return navigateTo('/');
      }
    }
  });