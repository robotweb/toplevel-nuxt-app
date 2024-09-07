<template>
    <div class="login-box">
        <FormLogin />
    </div>
</template>
<script setup lang="ts">
</script>
<style lang="scss">
.login-box {
    position: relative;
    box-shadow: $box-shadow;
    background: #fff;
    padding: 80px 50px;
    width: 500px;
    max-width: 90%;
    border-radius: 12px;
    @include for-tablet-down() {
        width: 100%;
        max-width: 100%;
        height: 100vh;
    }
}
</style>