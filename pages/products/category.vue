<template>
    <div>
        <div class="page-content">
            <FormAddCategory />
        </div>
    </div>
</template>
<script>
import axios from 'axios'
definePageMeta({
  layout: 'auth',
  middleware: [
    function (to, from) {
      // Custom inline middleware
    },
    'auth',
  ]
});
export default {
  data() {
    return {
      items: [],
      loading: true
    };
  },
  methods: {
    triggerToast(type, title, message) {
    const { $triggerToast } = useNuxtApp();

    $triggerToast({
      title: title,
      message: message,
      type: type, // e.g., success, error, etc.
    });
    },
    async deleteItem(id){
      try{
        const token = localStorage.getItem('auth');
        const response = await axios.delete('/api/products/deleteMaterial',{
        params: {
          id: id
        },
        headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json' // Set content type if sending JSON data
            }
      })
        console.log(response)
        if(response.data.statusCode != 200){
          throw new Error(response.data.message)
        }
        this.triggerToast("success","Success",response.data.message)
        this.items = this.items.filter(item => item.id !== id);

      }catch(error){
        console.error("Error fetching data:", error);
        this.triggerToast("error","Error",error.message)
      }
    },
    async fetchData(){
      const token = localStorage.getItem('auth');
      console.log("check fetching")
      try {
        const response = await axios.get("/api/products/getMaterial",{
          headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json' // Set content type if sending JSON data
              }
        }
        );
        //console.log(response)
        this.loading = false;
        this.items = response.data.message;
      } catch (error) {
        console.error("Error fetching data:", error);
        this.items = [];
        this.loading = false;
      }
      //console.log(items);
    }
  },
  mounted(){
    this.fetchData();
  }
};

</script>

