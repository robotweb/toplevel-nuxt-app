<template>

  <div class="border rounded-md">
  <Table class="min-w-full divide-y divide-gray-200 w-auto h-auto overflow-hidden">
    <TableHeader class="bg-gray-50">
      <TableRow>
        <TableHead 
          v-for="column in columns" 
          :key="column.key" 
          class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
          :class="column.class ? column.class : ''"
        >
          {{ column.label }}
        </TableHead>
        <TableHead 
          v-if="actions && actions.length > 0"
          class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
        >
          
        </TableHead>
      </TableRow>
    </TableHeader>
    <TableBody class="bg-white divide-y divide-gray-200">
      <TableRow v-for="(item, index) in data" :key="index" v-if="data.length > 0">
        <TableCell 
          v-for="column in columns" 
          :key="column.key" 
          class="px-6 py-4 whitespace-nowrap"
        >
          {{ item[column.key] }}
        </TableCell>
        <TableCell v-if="actions && actions.length > 0" class="w-1/8 text-right">
          <DropdownMenu>
            <DropdownMenuTrigger>
              <Button variant="ghost" class="w-full">
                <Icon name='lucide:ellipsis' class="size-6" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent class="mx-2">
              <DropdownMenuItem v-for="action in actions" :key="action.label" @click="action.action(item['id'])">
                {{ action.label }}
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </TableCell>
      </TableRow>
      <TableEmpty v-else>
        <div class="flex justify-center items-center">
          <LoaderRipple />
        </div>
      </TableEmpty>
    </TableBody>
  </Table>
</div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue'

export default defineComponent({
  name: 'DataTable',
  props: {
    columns: {
      type: Array as PropType<{ key: string; label: string; class?: string }[]>,
      required: true
    },
    data: {
      type: Array as PropType<Record<string, any>[]>,
      required: true
    },
    actions: {
      type: Array as PropType<{ action: (key: string) => void; label: string }[]>,
      required: false
    }
  },
  methods: {
    executeAction(action, item) {
      if (typeof action.handler === 'function') {
        console.log(item)
        action.handler(item);
      }
    }
  }
})
</script>
<style>
.w-auto {
  width: auto;
}
</style>
