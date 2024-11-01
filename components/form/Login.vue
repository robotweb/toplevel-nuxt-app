<template>
  <Card class="w-[350px] min-h-[300px]" v-if="!isLoading">
    <form v-if="!isLoading" @submit="login">
        <CardHeader>
            <CardTitle>Login</CardTitle>
            <CardDescription>
                Enter your email and password to login
            </CardDescription>
        </CardHeader>
        <CardContent>
        <div class="row my-2">
          <div class="w-full">
            <Input v-model="email" type="email" id="email" required placeholder="Email"/>
          </div>
        </div>
        <div class="row my-2">
          <div class="w-full">
            <Input v-model="password" type="password" id="password" required placeholder="Password"/>
          </div>
        </div>
        </CardContent>
        <CardFooter>
          <Button type="submit">
            Login
          </Button>
        </CardFooter>
      </form>
    </Card>
    
    <Card class="w-[350px] min-h-[300px]" style="position: relative;" v-if="isLoading">
      <LoaderRipple />
    </Card>
    
  </template>
  
<script>
import axios from 'axios';
  export default {
  setup() {
    const { triggerToast } = useToast()
    return { triggerToast }
  },
  data() {
    return {
      isLoading: false,
      email: null, 
      password: null,
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
        let errorMessage = this.request.data.message;
        this.triggerToast('error','Error',errorMessage)
        throw new Error(this.request.data.message)
      }
      console.log(this.request.data.token)
      localStorage.setItem("auth",this.request.data.token);
      navigateTo('/');
      }catch(error){
        console.log(error)
        this.isLoading = false;
      }
    },
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