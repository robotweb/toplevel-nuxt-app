<template>
   <Dialog v-model:open="isDialogOpen">
    <Button @click="openDialog">Add Material</Button>
    <DialogContent>
  <DialogHeader>
        <DialogTitle></DialogTitle>
        <DialogDescription>
        </DialogDescription>
  </DialogHeader>
  <div class="material-container">
    <form v-show="!isLoading" @submit.prevent="submitForm">
      <div class="row">
        <div class="col-6">
          <div class="col-12">
            <Input type="string" placeholder="Code"  v-model="code" required/>
          </div>
        </div>
        <div class="col-6">
          <div class="col-12">
            <Input type="string" placeholder="Name"  v-model="name" required/>
          </div>
        </div>

      </div>
      <div class="row">
        <div class="col-12">
          <Textarea v-model="description" required  placeholder="Description" />
        </div>
      </div>
      <div class="row">
        <div class="col-12">
            <Combobox :options="suppliers" :placeholder="supplierPlaceholder"></Combobox>
        </div>
      </div>
      <div class="row">
        <div class="col-6">
          <div class="col-12">
            <Input type="number" placeholder="Price"  v-model="unitCost" required @keyup="keyUp()"/>
          </div>
        </div>
        <div class="col-6">
          <div class="col-12">
            <Input type="number" placeholder="Discount (%)"  v-model="discount" required @keyup="keyUp()"/>
          </div>
        </div>
      </div>
      <div class="row">
        <label class="col-12"><p><strong>Price {{ calculatedPrice }}</strong></p></label>
          <Button type="submit">Save</Button>
    </div>
  </form>
  <div v-if="isLoading" class="h-[200px]">
    <LoaderRipple />
  </div>  

  </div>
</DialogContent>
</Dialog>
</template>

<script>
import axios from 'axios'
import { inject } from 'vue'

export default {
  setup() {
    const { triggerToast } = useToast()
    return { triggerToast }
  },
  data() {
    return {
      name: '',
      code: '',
      description: '',
      discount: null,
      supplier: '',
      unitCost: null,
      calculatedPrice: '0.00',
      isLoading: false,
      isDialogOpen: false,
      toast: inject('toast'),
      suppliers: [],
      supplierPlaceholder : "Select supplier..."
    };
  },
  methods: {
    resetForm(){
      this.name = '';
      this.code = '';
      this.description = '';
      this.discount = null;
      this.supplier = '';
      this.unitCost = null;
      this.calculatedPrice = '0.00';
    },
    openDialog(){
      this.isDialogOpen = true;
      this.suppliers = this.getSuppliers();
    },
    closeDialog(){
      this.isDialogOpen = false;
    },
    supplierChange(value){
      this.supplier = value;
    },
    async getSuppliers(){
      const token = localStorage.getItem('auth');
      let response = await axios.get('/api/products/getSupplier',  {
          headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json' // Set content type if sending JSON data
              }
        })
        .then((response)=>{
          let data = response.data.message
          let suppliers = []
          data.forEach(element => {
            suppliers.push({"value" : element.supplierCode, "label": element.supplierName})
          });
          this.suppliers = suppliers;
        })        
    },
    async submitForm() {
      this.isLoading = true;
      try {
        const token = localStorage.getItem('auth');
        const response = await axios.post(`/api/products/addMaterial`,{
          name: this.name,
          code: this.code,
          description: this.description,
          discount: this.discount,
          supplier: this.supplier,
          unitCost: this.unitCost
        },{
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json' // Set content type if sending JSON data
            }
          }
        )

        console.log(response);
        if(response.data.statusCode != 200){
          throw new Error(response.data.details.detail)
        }

        //const result = await response.json();
        this.triggerToast('success', 'Success', 'Product added successfully.')
        this.closeDialog();
        this.resetForm();
        this.$emit('success');
        //console.log('Data submitted successfully:', response.data.details);

      // Redirect to a protected route after login
    } catch (error) {
      this.triggerToast("error","Error",error.message);
      //console.error('Error submitting data:', error);
    }

    this.isLoading = false;

  },
  keyUp(){
    this.calculatedPrice = this.unitCost - (this.unitCost * this.discount/100);
  },
},
};
</script>
<style>
.flexForm{
  display: flex;
  flex-direction: column;
  align-items: space-between;
}

.material-container{
  max-width: 100%;
  min-height: 300px;
  position: relative;
}

.button{
  margin: 10px 0;
}

.row{
  display: flex;
  width: 100%;
  padding: 5px;
  align-items: center;
}

.col-6{
  width: 50%;
}

.col-12{
  width: 100%;
  padding: 0 15px;
}

input{
  padding: 10px;
  border-radius: 5px;
  border: 1px solid lightgray;
  width: 100%;
}

label{
  display: block;
  margin-bottom: 5px;
  color: #a9a9a9;
  font-weight: 300;
  font-size: small;
}
textarea{
  padding: 10px;
  width: 100%;
  border: 1px solid lightgray;
}

</style>