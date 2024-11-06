<template>
  <Sidebar defaultOpen="true">
    <SidebarHeader> </SidebarHeader>
    <SidebarContent>
      <Collapsable>
        <SidebarGroup>
          <SidebarGroupLabel>Sales</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton asChild>
                  <a href="/sales/customers">
                    <Icon name="lucide:circle-user-round" size="24" />
                    <span>Customers</span>
                  </a>
                </SidebarMenuButton>
              </SidebarMenuItem>
              <SidebarMenuItem>
                <SidebarMenuButton asChild>
                  <a href="/sales/quotation">
                    <Icon name="lucide:calculator" size="24" />
                    <span>Quotations</span>
                  </a>
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </Collapsable>
      <SidebarGroup>
        <SidebarGroupLabel>Products</SidebarGroupLabel>
        <SidebarGroupContent>
          <SidebarMenu>
            <SidebarMenuButton asChild>
              <a href="/products/items">
                <Icon name="lucide:boxes" size="24" />
                <span>Products</span>
              </a>
            </SidebarMenuButton>
            <SidebarMenuButton asChild>
              <a href="/products/material">
                <Icon name="lucide:paint-bucket" size="24" />
                <span>Material</span>
              </a>
            </SidebarMenuButton>
            <SidebarMenuButton asChild>
              <a href="/products/labour">
                <Icon name="lucide:biceps-flexed" size="24" />
                <span>Labour</span>
              </a>
            </SidebarMenuButton>
            <SidebarMenuButton asChild>
              <a href="/products/supplier">
                <Icon name="lucide:store" size="24" />
                <span>Suppliers</span>
              </a>
            </SidebarMenuButton>
            <SidebarMenuButton asChild>
              <a href="/products/category">
                <Icon name="lucide:group" size="24" />
                <span>Category</span>
              </a>
            </SidebarMenuButton>
          </SidebarMenu>
        </SidebarGroupContent>
      </SidebarGroup>
    </SidebarContent>
    <SidebarFooter>
      <SidebarMenu>
        <SidebarMenuItem>
          <DropdownMenu class="w-full">
            <DropdownMenuTrigger class="w-full">
              <SidebarMenuButton class="flex items-center justify-between w-full">
                <span>Username</span>
                <Icon name="i-heroicons-chevron-up" />
              </SidebarMenuButton>
            </DropdownMenuTrigger>
            <DropdownMenuContent class="w-[--radix-popper-anchor-width]">
              <DropdownMenuLabel>My Account</DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem>Profile</DropdownMenuItem>
              <DropdownMenuItem>Team</DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem @click="logout">Log out</DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </SidebarMenuItem>
      </SidebarMenu>
    </SidebarFooter>
  </Sidebar>
</template>
<script>
export default {
  data() {
    return {
      items: []
    }
  },
  methods: {
    logout
  }
}

function logout() {
  navigateTo('/')
}
</script>
