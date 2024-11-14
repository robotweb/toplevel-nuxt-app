<template>
    <draggable class="dragArea" :list="tasks" v-if="tasks && tasks.length" :group="{ name: 'items' }" :animation="200"">
        <template #item="{ element }"">
            <li>
                <p>{{ element.name }}</p>
                <DraggableNested :tasks="element.tasks" />
            </li>
        </template>
    </draggable>
  </template>
  <script>
  
  export default {
    props: {
      tasks: {
        required: true,
        type: Array
      }
    },
    name: "DraggableNested"
  };
  </script>
  <style scoped>
  .dragArea {
    min-height: 50px;
    outline: 1px dashed;
  }
  </style>