<template>
  <div  class="h-full w-full mt-4 ">
    <div class="row">
      <FormAddLabour @form-submiited="fetchData"/>
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
    }
  },
  mounted(){
    this.fetchData();
  }
};
</script>