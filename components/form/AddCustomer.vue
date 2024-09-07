<template>
  <div class="customer-container">
    <form v-show="!isLoading" @submit.prevent="submitForm">
      <div class="row">
          <div class="col-12">
            <label for="customer-name">Name</label>
            <input id="customer-name" v-model="name" required />
          </div>
      </div>
      <div class="row">
          <div class="col-12">
            <label for="customer-address">Address</label>
            <textarea id="customer-address" v-model="billingAddress" required></textarea>
          </div>
      </div>
      <div class="row">
          <div class="col-12">
            <label for="customer-markup">Markup (%)</label>
            <input id="customer-markup" v-model="clientMarkup" required />
          </div>
      </div>
      <div class="row">
        <button type="submit">Add Customer</button>
      </div>
    <!-- Add other form fields as needed -->
  </form>
  </div>
</template>
<script>
import axios from 'axios'
export default {
  data() {
    return {
      name: '',
      billingAddress: '',
      clientMarkup: 0,
      contacts: []
    };
  },
  methods: {
    async submitForm() {
      try {
        const token = localStorage.getItem('auth');
        console.log(token);

        const response = await axios.post(`/api/sales/addCustomer`, 
        {
          name: this.customerName,
        }, 
        {
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json' // Set content type if sending JSON data
            }
        })

        if (!response.ok) {
          throw new Error('Failed to submit data');
        }

        const result = await response.json();
        console.log('Data submitted successfully:', result);
        this.$emit('submit');
  
      // Redirect to a protected route after login
    } catch (error) {
        console.error('Error submitting data:', error);
    }
  },
}
};
</script>
<style>
.customer-container{
  width: 500px;
  max-width: 100%;
  min-height: 300px;
  position: relative;
}
</style>