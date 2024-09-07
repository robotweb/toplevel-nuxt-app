<template>
    <div class="login-grid">
        <div class="login-content">            
            <Login />
        </div>
    </div>
  </template>
<script setup>
definePageMeta({
    layout: 'noauth',
    middleware: 'guest'
})
</script>
<style lang="scss" scoped>
.login-grid {
    background: linear-gradient(90deg, #448ae6, #103ea0);;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    width: 100vw;
    min-width: 400px;
    @include for-tablet-down() {
        display: flex;
    }
}
.login-content {
    height: 100%;
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}
.login-box {
    position: relative;
    box-shadow: 0px 4px 7px 0px rgba(0, 0, 0, 0.03);
    background: #fff;
    width: 500px;
    min-height: 500px;
    max-width: 90%;
    border-radius: 12px;
    @include for-tablet-down() {
        width: 100%;
        max-width: 100%;
        height: 100vh;
        border-radius: 0;
    }
}
</style>
  