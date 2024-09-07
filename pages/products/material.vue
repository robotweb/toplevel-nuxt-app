<template>
    <div>
        <div>
          <div class="page-header">
            <h2>Material</h2>
            <button @click="openPopup">Add Material</button>
          </div>
            <Popup :showPopup="showPopup" @close="closePopup">
              <FormAddMaterial @form-submitted="closePopup"/>
            </Popup>
        </div>
    </div>
</template>
<script>
definePageMeta({
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