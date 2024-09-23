<template>
    <div class="page-header">
      <h2>&nbsp;</h2>
      <button @click="successToast">Save</button>
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

export default {
  methods: {
    
  },
};
</script>