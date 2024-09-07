<template>
    <div>
      <form v-if="!isLoading" @submit="login">
        <div class="login-box-header">
          <img src="/public/tl_logo.svg" width="150px">
        </div>
        <div>
          <div class="form-label-container">
            <label for="email">Email:</label>
          </div>
          <div class="form-input-container">
            <input v-model="email" type="email" id="email" required />
          </div>
        </div>
        <div>
          <div class="form-label-container">
            <label for="password">Password:</label>
          </div>
          <div class="form-input-container">
            <input v-model="password" type="password" id="password" required />
          </div>
        </div>
        <button type="submit">
          Login
        </button>
        <p v-if="errorMessage">{{ errorMessage }}</p>
      </form>
      <LoaderRipple v-if="isLoading" />
    </div>
  </template>
  
  <script>
import axios from 'axios';

  export default {
  data() {
    return {
      isLoading: false,
      email: null, 
      password: null,
      errorMessage: null,
      request: null
    };
  },
  methods: {
    async login(){
      this.isLoading = true;
      try{
        this.request = await axios.post("/api/login",{
          email: this.email,
          password: this.password
      },{
        timeout: 5000
      });
      console.log(this.request.data.statusCode)
      if(this.request.data.statusCode != 200){
        this.errorMessage = this.request.data.message;
        throw new Error(this.request.data.message)
      }
      console.log(this.request.data.token)
      localStorage.setItem("auth",this.request.data.token);
      return navigateTo('/');
      }catch(error){
        console.log(error)
        this.isLoading = false;
      }
    }
  }
  }
</script>
<style lang="scss">
.form-input-container input{
  width: 100%;
  border-radius: 10px;
  padding: 10px;
  border: 1px solid lightgrey;
  margin-bottom: 10px;
}

.login-box-header{
  text-align: center;
}

</style>