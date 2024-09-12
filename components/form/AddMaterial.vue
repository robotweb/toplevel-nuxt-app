<template>
  <div class="material-container">
    <form v-show="!isLoading" @submit.prevent="submitForm">
      <div class="row">
        <div class="col-6">
          <div class="col-12">
            <label  for="material-name">Name</label>
          </div>
          <div class="col-12">
            <input  id="material-name" v-model="name" required />
          </div>
        </div>
        <div class="col-6">
          <div class="col-12">
            <label for="material-code">Code</label>
          </div>
          <div class="col-12">
            <input id="material-code" v-model="code" required />
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
            <label for="material-description">Description</label>
            <textarea id="material-description" v-model="description" required></textarea>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
            <label for="material-supplier">Supplier</label>
            <input id="material-supplier" v-model="supplier" required>
        </div>
      </div>
      <div class="row">
        <div class="col-6">
          <div class="col-12">
            <label for="material-unitCost">Cost Price</label>
          </div>
          <div class="col-12">
            <input id="material-unitCost" v-model="unitCost" @keyup="keyUp()" required>
          </div>
        </div>
        <div class="col-6">
          <div class="col-12">
            <label for="material-discount">Discount (%)</label>
          </div>
          <div class="col-12">
            <input id="material-discount" v-model="discount" @keyup="keyUp()" required>
          </div>
        </div>
      </div>
      <div class="row">
        <label class="col-12"><p><strong>Price R {{ calculatedPrice }}</strong></p></label>
        <button class="button" type="submit">Add Material</button>
      </div>

    <!-- Add other form fields as needed -->
  </form>
  <LoaderRipple v-if="isLoading"/>

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
      discount: 0,
      supplier: '',
      unitCost: 0,
      calculatedPrice: '0.00',
      isLoading: false,
    };
  },
  methods: {
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

.material-container{
  width: 500px;
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