<template>
    <div class="container">
        <div class="side-bar">
          <div>
            <div class="logo-container">
              <img src="/public/tl_logo.svg"/>
            </div>
            <UiMenuItem label="Dashboard" link="/" icon="pie_chart"/>
            <div @click="toggleSales">
              <UiMenuItem label="Sales" icon="credit_card"/>
            </div>
            <div v-if="showSales" class="sub-menu">
                <UiMenuItem label="Customers" link="/sales/customer"/>
                <UiMenuItem label="Estimates" link="/"/>
                <UiMenuItem label="Purchase Orders" link="/"/>
                <UiMenuItem label="Invoices" link="/"/>
            </div>
            <div @click="toggleProducts">
              <UiMenuItem label="Products" icon="inventory_2"/>
            </div>
            <div v-if="showProducts" class="sub-menu">
                <UiMenuItem label="Product" link="/products/item"/>
                <UiMenuItem label="Material" link="/products/material"/>
                <UiMenuItem label="Labour" link="/products/labour"/>
            </div>
          </div>
          <div class="side-bar-footer">
            <UiMenuItem label="Settings" icon="settings"/>
            <UiMenuItem @click="logout" label="Logout" icon="logout"></UiMenuItem>
          </div>
        </div>
        <div class="slot-content">
            <slot />
        </div>
    </div>
</template>
<script>
export default {
  data() {
    return {
      showSales: false, // Initially, children are hidden
      showProducts: false
    };
  },
  methods: {
    toggleSales() {
      this.showSales = !this.showSales; // Toggle visibility
    },
    toggleProducts(){
      this.showProducts = !this.showProducts
    },
    logout(){
      localStorage.removeItem('auth')
      navigateTo('/login')
    }
  },
};
</script>
<style lang="scss">
.top-menu{
    width: 100vw;
    height: $menu-top-size;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    padding: 0px;
    box-shadow: $box-shadow;
}

.container{
    width: 100vw;
    display: flex;
}

.side-bar{
    width: $menu-left-size;
    height: calc(100vh - $menu-top-size);
    background: $menu-color;
    justify-content: space-between;
    display: flex;
    flex-direction: column;
}

.slot-content{
    width: calc(100vw - $menu-left-size);
    height: calc(100vh - $menu-top-size);
    background: $body-background;
    box-shadow: inset 10px 0px 15px -5px rgba(0, 0, 0, 0.1);
    padding: 20px;

}

</style>