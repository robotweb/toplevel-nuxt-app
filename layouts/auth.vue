<template>
  <div class="h-screen w-screen">
  <SidebarProvider>
      <AppSidebar />
      <main class="p-4 flex w-full h-full">
        <SidebarTrigger />
        <slot />
      </main>
    </SidebarProvider>
</div>
<Toast />
</template>

<script>

</script>