<template>
  <div>
    <div class="row">
      <FormAddLabour/>
    </div>
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

export default {

};
</script>