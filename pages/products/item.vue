<template>
    <div class="page-header">
      <h2>Product / Service</h2>
      <button>Add Product</button>
    </div>
</template>
<script setup lang="ts">
definePageMeta({
  middleware: [
    function (to, from) {
      // Custom inline middleware
    },
    'auth',
  ],
});
</script>