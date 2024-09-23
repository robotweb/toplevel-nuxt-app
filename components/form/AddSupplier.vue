<template>
<div class="dialog-container">
  <Dialog v-model:open="isDialogOpen">
    <div class="row">
      <Button @click="openDialog">Add Supplier</Button>
    </div>
    <DialogContent>
    <DialogHeader>
          <DialogTitle></DialogTitle>
          <DialogDescription>
          </DialogDescription>
    </DialogHeader>
    <form v-show="!isLoading" @submit.prevent="submitForm">
      <div class="row">
        <div class="col-12">
          <Input type="string" placeholder="Code"  v-model="code" required/>
        </div>
      </div>

      <div class="row">
          <div class="col-12">
            <Input type="string" placeholder="Name"  v-model="name" required/>
          </div>
      </div>
        
      <div class="row flex justify-end">
          <Button type="submit">Save</Button>
      </div>

    <!-- Add other form fields as needed -->
  </form>
  <LoaderRipple v-if="isLoading"/>
</DialogContent>
</Dialog>
</div>
</template>
<script>
import axios from 'axios'
export default {
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
    };
  },
  methods: {
    openDialog(){
      this.isDialogOpen = true;
    },
    closeDialog(){
      this.isDialogOpen = false;
    },
    async submitForm() {
      this.isLoading = true;
      try {
        const token = localStorage.getItem('auth');
        //console.log(token);

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
        this.triggerToast("success","Success",response.data.message)
        //console.log('Data submitted successfully:', response.data.details);
        this.$emit('form-submitted');

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
  triggerToast(type, title, message) {
    const { $triggerToast } = useNuxtApp();

    $triggerToast({
      title: title,
      message: message,
      type: type, // e.g., success, error, etc.
    });
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

.dialog-container{
  max-width: 100%;
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