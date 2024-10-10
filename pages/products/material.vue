<template>
    <div class="h-full w-full">
            <div class="row">
              <FormAddMaterial @success="fetchData" />
            </div>
        <div class="h-full w-full mt-4 ">
          <DataTable :columns="columns" :data="items" :actions="menuItems"/>
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
  setup() {
    const { triggerToast } = useToast()
    return { triggerToast }
  },
  data() {
    return {
      items: [],
      columns: [
        { key: 'code', label: 'Code', class: 'w-24' },
        { key: 'name', label: 'Name' },
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
    };
  },
  methods: {
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
        console.log(this.items)

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

