<script>
export default{
  props:{
    isCollapsed: Boolean,
    links: {
      type: Array,
      default: () => []
    }
  }
}
</script>

<template>
  <div class="w-full">
    <nav class="grid gap-1 group-[[data-collapsed=true]]:justify-center group-[[data-collapsed=true]]:px-2">
      <template v-for="(link, index) of links">

        <NuxtLink v-if="link.href" :to="link.href" >
          <Button variant="ghost" class="w-full">
            <Icon :name="link.icon" class="mr-2 size-6" v-if="link.icon"/>
            <div v-else class="ml-8"></div>
            {{ link.title }}
            <span class="ml-auto"></span> 
            </Button>
        </NuxtLink>
        <Button v-else variant="ghost" class="w-full" @click="link.action">
          <Icon :name="link.icon" class="mr-2 size-6" v-if="link.icon"/>
          <div v-else class="ml-8"></div>
          {{ link.title }}
          <span class="ml-auto"></span> 
        </Button>
      </template>
    </nav>
  </div>
</template>