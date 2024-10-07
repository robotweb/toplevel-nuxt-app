<template>
    <!--<Input type="string" placeholder="Supplier"  v-model="search" required  @focus="optionsIsOpen = true" />-->
    <Select v-model="selectedOption">
      <SelectTrigger>
        <SelectValue :placeholder="placeholder ? placeholder : ''" />
      </SelectTrigger>
      <SelectContent>
        <SelectItem v-for="option in options" :value="option.value" :key="option.value" >
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
      optionsIsOpen: false,
      selectedOption: '',
    }
  },
  name: 'Select',
  props: {
    options: {
      type: Array as PropType<{ value: string; label: string }[]>,
      required: true
    },
    placeholder: {
      type: String
    }
  },
  methods: {
    handleSelectChange(value) {
      console.log(value)
      this.$emit('change', value); // Emit the selected value to parent
    }
  },
  watch: {
    selectedOption(newVal) {
      this.handleSelectChange(newVal); // Watch for changes and trigger the emit
    }
  }
})
</script>


