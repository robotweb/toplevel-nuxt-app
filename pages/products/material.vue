<template>
    <div class="h-full w-full">
            <div class="row">
              <FormAddMaterial @success="fetchData"/>
            </div>
        <div class="h-full w-full mt-4 ">
          <DataTable :columns="columns" :data="items" :actions="menuItems"/>
        </div>
        <Dialog v-model:open="isOpen" :close="isClose">
            <DialogContent>
                <div class="material-container">
                  <form v-show="!isLoading" @submit.prevent="submitEdit">
                    <div class="row">
                      <div class="col-6">
                        <div class="col-12">
                          <Input type="string" placeholder="Code"  v-model="editable.code" value="editable.code"/>
                        </div>
                      </div>
                      <div class="col-6">
                        <div class="col-12">
                          <Input type="string" placeholder="Name"  v-model="editable.name" required/>
                        </div>
                      </div>

                    </div>
                    <div class="row">
                      <div class="col-12">
                        <Textarea required  placeholder="Description" v-model="editable.description"/>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-12">
                          <Combobox :options="suppliers" :placeholder="supplierPlaceholder" v-model="editable.supplier"></Combobox>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-6">
                        <div class="col-12">
                          <Input type="number" placeholder="Price" required @keyup="keyUp()" v-model="editable.unitCost"/>
                        </div>
                      </div>
                      <div class="col-6">
                        <div class="col-12">
                          <Input type="number" placeholder="Discount (%)"  v-model="editable.discount" required @keyup="keyUp()"/>
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <label class="col-12"><p><strong>Price {{ calculatedPrice }}</strong></p></label>
                        <Button type="submit">Save</Button>
                    </div>
              </form>
              </div>
            </DialogContent>
        </Dialog>
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
      isOpen: false,
      editable: null,
      items: [],
      columns: [
        { key: 'code', label: 'Code', class: 'w-24' },
        { key: 'name', label: 'Name' },
      ],
      menuItems: [
          {
            label: 'Edit',
            action: (key) => {
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
    async deleteItem(item){
      try{
        let id = item.id
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
    },
    editItem(key){
      console.log(key)
      this.editable = key;
      this.editCode = key.code
      this.isOpen = true;
    }
  },
  mounted(){
    this.fetchData();
  }
};

</script>

