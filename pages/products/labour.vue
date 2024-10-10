<template>
  <div  class="h-full w-full">
    <div class="row">
      <FormAddLabour @success="fetchData"/>
    </div>
    <div class="h-full w-full mt-4 ">
      <DataTable :columns="columns" :data="items" :actions="menuItems"/>
    </div>
  </div>
</template>
<script>
definePageMeta({
  layout: 'auth',
  middleware: [
  function (to, from) {
    // Custom inline middleware
  },
  'auth',
],
});
import axios from 'axios'
export default {
  setup() {
    const { triggerToast } = useToast()
    return { triggerToast }
  },
  data() {
    return {
      items: [],
      columns: [
        {key : "name", label : "Name"},
        {key : "description", label : "Description"}
      ],
      menuItems: [
          {
            label: 'Edit',
            action: (key) => {
              console.log(key)
              this.editItem(key);
            },
          },
          {
            label: 'Delete',
            action: (key) => {
              this.deleteItem(key);
            },
          },
      ]
    }
  },
  methods : {
    async fetchData(){
      const token = localStorage.getItem('auth');
      console.log("check fetching")
      try {
        const response = await axios.get("/api/products/getLabour",{
          headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json' // Set content type if sending JSON data
              }
        }
        );
        //console.log(response)
        this.loading = false;
        this.items = response.data.message;
        console.log(this.items)
      } catch (error) {
        console.error("Error fetching data:", error);
        this.items = [];
        this.loading = false;
      }
    },
    async deleteItem(id){
      try{
        const token = localStorage.getItem('auth');
        const response = await axios.delete('/api/products/deleteLabour',{
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
        console.log(this.items)

      }catch(error){
        console.error("Error fetching data:", error);
        this.triggerToast("error","Error",error.message)
      }
    },
  },
  mounted(){
    this.fetchData();
  }
};
</script>