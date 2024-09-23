<template>
    <div class="card" v-bind="$attrs">
        <slot />
    </div>
</template>
<script>
export default {
    name: "Tabs",
    components: {
    },
};
</script>

<style lang="scss">
.card {
    position: relative;
    display: flex;
    padding: 15px;
    min-height: 55px;
    border-radius: $radius;
    justify-content: center;
    align-items: center;
    background: rgba(#fff, 0.7);
    transition: 220ms;
    box-shadow: none;
    margin-bottom: 8px;
    &:hover {
        background: #fff;
        transition: 120ms;
        box-shadow: $box-shadow;
    }
    &.nohover {
        &:hover {
            background: rgba(#fff, 0.7);;
            transition: 120ms;
            box-shadow: none;
        }
    }
}
</style>