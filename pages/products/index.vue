<template>
    <div class="page-header">
      <h2>Product / Service</h2>
      <button @click="handleClick">Add Product</button>
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
export default{
  methods:{
    handleClick() {
      /* Show toast notification
      this.$nuxt.$triggerToast({
        title: 'Success',
        message: 'Product added successfully!',
        type: 'success',
      }); */

      // Navigate to a different page
      this.$router.push('/products/item');  // Replace with your target path
    },
  }
}
</script>