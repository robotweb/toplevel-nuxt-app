<template>
    <div class="labour-container">
        <form  v-show="!isLoading" @submit.prevent="submitForm">
        <div class="row">
        <div class="col-6">
          <div class="col-12">
            <label  for="labour-name">Name</label>
          </div>
          <div class="col-12">
            <input  id="labour-name" v-model="name" required />
          </div>
        </div>
        <div class="col-6">
          <div class="col-12">
            <label for="labour-code">Code</label>
          </div>
          <div class="col-12">
            <input id="labour-code" v-model="code" required />
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
            <label for="labour-description">Description</label>
            <textarea id="labour-description" v-model="description" required></textarea>
        </div>
      </div>
      <div class="row">
        <div class="col-6">
          <div class="col-12">
            <label  for="labour-unitCost">Cost</label>
          </div>
          <div class="col-12">
            <input  id="labour-unitCost" v-model="unitCost" required @keyup="keyUp()"/>
          </div>
        </div>
        <div class="col-6">
          <div class="col-12">
            <label for="labour-unitType">Unit Type (hour, day, etc.)</label>
          </div>
          <div class="col-12">
            <input id="labour-unitType" v-model="unitType" required />
          </div>
        </div>
      </div>
      <div class="row">
        <label class="col-12"><p><strong>Price R {{ calculatedPrice }}</strong></p></label>
        <button class="button" type="submit">Add Labour</button>
      </div>
      </form>
      <LoaderRipple v-if="isLoading"/>
    </div>
</template>
<script>
import axios from 'axios'
export default{
    data(){
        return {
            name: "",
            code: "",
            description: "",
            unitCost: 0,
            unitType: "",
            calculatedPrice: 0,
            isLoading: false
        }
    },
    methods: {
        async submitForm(){
            this.isLoading = true;
            try {
        const token = localStorage.getItem('auth');
        //console.log(token);

        const response = await axios.post(`/api/products/addLabour`,{
          name: this.name,
          code: this.code,
          description: this.description,
          unitType: this.unitType,
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
          throw new Error(response.data.details)
        }

        //const result = await response.json();
        //console.log('Data submitted successfully:', response.data.message);
        this.triggerToast("success","Success",response.data.message)
        this.$emit('form-submitted');

      // Redirect to a protected route after login
    } catch (error) {
        //console.error('Error submitting data:', error);
        this.triggerToast("error","Error",error.message);
    }
    this.isLoading = false;
        },
        keyUp(){
            this.calculatedPrice = this.unitCost;
        },
        triggerToast(type, title, message) {
    const { $triggerToast } = useNuxtApp();

    $triggerToast({
      title: title,
      message: message,
      type: type, // e.g., success, error, etc.
    });
  },
    }
}
</script>
<style>
.labour-container{
    width: 500px;
    max-width: 100%;
    min-height: 300px;
    position: relative;
}
</style>