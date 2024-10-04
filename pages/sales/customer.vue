<template>
  <div>
      <div class=row>
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
data() {
  return {
    showPopup: false
  };
},
methods: {
  openPopup(){
    this.showPopup = true;
    console.log(this.showPopup);
  },
  closePopup() {
    this.showPopup = false;
    console.log(this.showPopup);
  }
},
};
</script>