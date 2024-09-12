<template>
    <div>
      <slot />
      <Toast ref="toast" />
    </div>
</template>
<script>
export default {
  mounted() {
    const { $setToastInstance } = useNuxtApp();
    $setToastInstance(this.$refs.toast); // Set the toast instance
  }
}
</script>
  