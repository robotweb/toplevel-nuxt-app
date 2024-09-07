<template>
    <div v-show="showPopup" class="modal-overlay" @click.self="closePopup" >
      <div class="modal-content">
        <slot></slot>
      </div>
    </div>
  </template>
  
  <script>
  export default {
  props: {
    showPopup: {
      type: Boolean,
      required: true
    }
  },
    methods: {
      closePopup() {
        console.log("closing");
        this.$emit('close');
      }
    }
  };
  </script>
  
  <style scoped>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .modal-content {
    background: white;
    padding: 20px;
    border-radius: 5px;
    min-width: 400px;
    height: fit-content;
    overflow-y: auto;
    max-height: 600px;
    width: fit-content;
    height: fit-content;
  }
  .close-button {
    position: absolute;
    top: 10px;
    right: 10px;
    background: none;
    border: none;
    font-size: 16px;
    cursor: pointer;
  }
  </style>