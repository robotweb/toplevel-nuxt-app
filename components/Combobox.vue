<template>
    <Popover class="w-full"  v-model:open="open">
        <PopoverTrigger as-child>
            <Button
                variant="outline"
                role="combobox"
                :aria-expanded="open"
                class="w-full justify-between">
                {{ value
          ? options.find((option) => option.value === value)?.label
          :  placeholder }}
            </Button>
        </PopoverTrigger>
        <PopoverContent class="w-[200px] p-0" side="bottom" align="start">
            <Command>
                <CommandInput class="h-9 border-0" />
                <CommandEmpty>No options found.</CommandEmpty>
                <CommandList>
                    <CommandItem
                    v-for="option in options"
                    :key="option.value"
                    :value="option.value"
                    @select="(ev) => {
                        if (typeof ev.detail.value === 'string') {
                            value = ev.detail.value
                        }
                        handleSelectChange(value)
                        open = false
                    }"
                    >
                    {{ option.label }}
                    </CommandItem>
                </CommandList>
            </Command>
        </PopoverContent>
    </Popover>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue'

export default defineComponent({
    data(){
        return {
            open: false,
            value: ''
        }   
    },
    props : {
        options: {
            type: Array as PropType<{ value: string; label: string }[]>,
            required: true
        },
        placeholder: {
            type: String,
            default: 'Search supplier'
        }

    },
    methods: {
        handleSelectChange(value) {
        console.log(value)
        this.$emit('change', value); // Emit the selected value to parent
    }
  },

})
</script>