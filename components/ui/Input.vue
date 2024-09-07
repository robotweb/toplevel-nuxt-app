<template>
    <div>
        <div style="margin-bottom: 10px; color: #A3A3A3; font-size: 14px;" v-if="label">{{ label }}</div>
        <div>
            <input 
                :required="required"
                :type="inputType"
                class="input-text"
                :placeholder="placeholder"
                v-on:keyup.enter="onEnter($event.target.value)"
                ref="input"
            />
        </div>
        <div style="margin-bottom: 20px; color: #A3A3A3; font-size: 14px;"></div>
    </div>
</template>
<script>
export default{
    props : {
        label: String,
        inputType: String,
        required: String,
        placeholder: String
    }
}
</script>
<style lang="scss" scoped>
.input-text {
    padding: 10px;
    border: 2px solid #E8E8E8;
    width: 100%;
    border-radius: $radius;
    transition: outline 400ms, border 40ms;
    outline: 3px solid transparent;
    font-family: inherit;
    font-size: 15px;
    &:focus {
        border: 2px solid $primary;
        outline-color: rgba(5,150,228,0.2);
    }
    &.error {
        border: 2px solid $red;
        outline-color: rgba($red,0.2);
        animation: shake 0.1s ease-in-out 0s 2;
    }
    .left-padding & {
        padding-left: 50px;
    }
    .right-padding & {
        padding-right: 50px;
    }
    .left-block & {
        padding-left: 60px;
    }
    &::placeholder {
        color: #aaa;
        opacity: 1;
    }
    &::-ms-input-placeholder {
        color: #aaa;
    }
}
</style>