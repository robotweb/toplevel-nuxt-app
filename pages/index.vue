<template>
    <div>
      
    </div>
</template>
<script setup lang="ts">
definePageMeta({
  layout: 'auth',
  middleware: [
    function (to, from) {
      // Custom inline middleware
    },
    'auth',
  ],
});
</script>