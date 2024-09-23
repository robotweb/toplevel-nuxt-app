<template>
  <div class="h-screen w-screen">
  <ResizablePanelGroup
    id="handle-demo-group-1"
    direction="horizontal"
    class="h-full items-stretch"
  >
    <ResizablePanel id="handle-demo-panel-1" 
    :default-size="25" 
    :min-size="15"
    :max-size="20"
    @expand="onExpand"
    @collapse="onCollapse"
    >
      <div class="flex flex-col justify-between h-full p-6">
        <div class="flex flex-col">
          <Nav :links="dashboard" />
          <Button @click="toggleSales" variant="ghost">
            <Icon name="lucide:credit-card" class="mr-2 size-6"/>
            Sales
            <span class="ml-auto"></span> 
          </Button>
          <Nav :links="salesLinks" v-if="salesCollapsed" />
          <Button @click="toggleProduct" variant="ghost">
            <Icon name="lucide:package" class="mr-2 size-6"/>
            Products
            <span class="ml-auto"></span> 
          </Button>
          <Nav :links="productLinks" v-if="productCollapsed" />
        </div>

        <Nav :links="footerLinks" />      
      </div>
    </ResizablePanel>
    <ResizableHandle id="handle-demo-handle-1" with-handle />
    <ResizablePanel id="handle-demo-panel-2" :default-size="75">
      <div class="flex h-full w-full p-6">
        <slot />
      </div>
    </ResizablePanel>
  </ResizablePanelGroup>
</div>
<Toast />
</template>

<script>

export default{
  data() {
    return{
      isCollapsed: false,
      salesCollapsed: false,
      productCollapsed: false,
      dashboard: [
      {
          title: 'Dashboard',
          icon: 'lucide:pie-chart',
          href: ''
        }
      ],
      salesLinks: [
        {
          title: 'Customers',
          label: '128',
          href: '/sales/customer'
        },
        {
          title: 'Estimates',
          label: '128',
          href: '#'
        },
        {
          title: 'Purchase Orders',
          label: '128',
          href: '#'
        },
        {
          title: 'Invoices',
          label: '128',
          href: '#'
        },
      ],
      productLinks: [
      {
          title: 'Product',
          label: '128',
          href: '/products'
        },
        {
          title: 'Material',
          label: '128',
          href: '/products/material'
        },
        {
          title: 'Labour',
          label: '128',
          href: '/products/labour'
        },
        {
          title: 'Supplier',
          label: '128',
          href: '/products/supplier'
        },
        {
          title: 'Category',
          label: '128',
          href: '/products/category'
        }
      ],
      footerLinks : [
      {
          title: 'Settings',
          label: '128',
          icon: 'lucide:settings',
          href: '#'
        },
        {
          title: 'Logout',
          label: '128',
          icon: 'lucide:log-out',
          action: this.logout
        },
      ]
    }
  },
  methods: {
    onCollapse(){
      this.isCollapsed = true
    },
    onExpand() {
      this.isCollapsed = false
    },
    toggleSales(){
      this.salesCollapsed = !this.salesCollapsed
    },
    toggleProduct(){
      this.productCollapsed = !this.productCollapsed
    },
    logout(){
      localStorage.removeItem('auth')
      navigateTo('/login')
    }
  },
}
</script>