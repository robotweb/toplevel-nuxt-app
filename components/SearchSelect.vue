<template>
    <Input type="string" placeholder="Supplier"  v-model="search" required  @focus="optionsIsOpen = true" />
    <Select>
      <SelectContent>
        <SelectItem v-for="option in options" :value="option.value">
          {{ option.label }}
          </SelectItem>
      </SelectContent>
    </Select>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue'

export default defineComponent({
  data() {
    return {
      search: '',
      optionsIsOpen: false
    }
  },
  name: 'Select',
  props: {
    options: {
      type: Array as PropType<{ value: string; label: string }[]>,
      required: true
    },
    selectedOption: {
      type: String,
      required: true
    }
  },
  methods: {
    handleChange(event) {
      this.$emit('change', event.target.value)
    }
  }
})
</script>


