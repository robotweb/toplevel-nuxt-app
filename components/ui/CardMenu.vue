<template>
    <div  @click.stop style="background: transparent; top: 0px; left: 0px; width: 100vw;height: 100vh; z-index: 9; position: fixed;" v-if="menuOpen" @click="menuOpen = false"></div>
    <OnClickOutside @trigger="menuOpen = false">        
        <div class="card-menu" @click.stop="">
            <div class="card-icon"
                @click="toggleMenu"
                v-wave="{
                    color: 'rgba(0,0,0,0.4)',
                    initialOpacity: 0.1,
                    easing: 'ease-out'
                }">
                <span class="material-symbols-outlined">
                    more_vert
                </span>
            </div>
            <div class="dropdown right" @click.stop :class="{'active':menuOpen}" @click="menuOpen = false">
                <slot />
            </div>
        </div>
    </OnClickOutside>
</template>
<script>
import { OnClickOutside } from '@vueuse/components'
export default {
    name: "Page Body",
    components: {
    OnClickOutside
    },
    props:{
    },
    data(){ 
        return {
            menuOpen: false,
        }
    },
    mounted() {
    },
    methods: {
        toggleMenu() {
            this.menuOpen = !this.menuOpen
        },
    },
    computed: {
    },
    watch: {
        
    }
};
</script>

<style lang="scss">
.card-menu {
    position: absolute;
    right: 12px;
    top: 12px;
}
.card-icon {
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 8px;
    background: transparent;
    height: 40px;
    width: 40px;
    transition: 280ms;
    color: #929292;
    z-index: 99;
    cursor: pointer;
    &:hover {
        background: #FCFCFC;
    }
}

.dropdown {
    position: absolute;
    z-index: 999;
    left: 0px;
    min-width: 200px;
    font-size: 14px;
    background: #fff;
    visibility: hidden;
    box-shadow: $box-shadow;
    
    box-shadow: rgba(17, 17, 26, 0.03) 0px 8px 24px, rgba(17, 17, 26, 0.01) 0px 16px 56px, rgba(17, 17, 26, 0.01) 0px 4px 80px;
    border-radius: $radius;
    transition: all 260ms $easing; /* easeInOutBack */
    transition-timing-function: $easing; /* easeInOutBack */
    top: 80%;
    opacity: 0;
    &.right {
        left: auto;
        right: 0px;
    }
    &.active {
        opacity: 1;
        top: 100%;
        visibility: visible;
    }
}
</style>