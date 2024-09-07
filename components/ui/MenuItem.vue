<template>
    <NuxtLink :to="link">
    <div class="menu-item" @click="onMenuToggle()">
        <div class="menu-icon">
            <span class="material-symbols-outlined">
                {{ icon }}
            </span>
        </div>
        {{ label }}
    </div>
    </NuxtLink>
</template>
<script>
export default{
    props: {
        label: String,
        icon: String,
        link: String,
        active: Boolean
    }
}
</script>
<style lang="scss">
.menu-item{
    padding: 10px 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
}

.menu-icon{
    display: inline-block;
    width: 20px;
    margin-right: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.menu-item a{
    text-decoration: none;
    color: $default-color;
}


</style>