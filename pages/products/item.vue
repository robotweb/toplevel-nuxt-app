<template>
    <div class="page-header">
      <h2>Product / Service</h2>
      <button @click="successToast">Add Product</button>
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
  layout: 'auth',
});
export default{
  setup() {
    const { $eventBus } = useNuxtApp()

    const successToast = () => {
      $eventBus.emit('show-toast', {
        title: "Success",
        message: '',
        type: 'success',
      })
    }

    return {
      successToast
    }
  }
}
</script>