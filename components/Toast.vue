<template>
  <transition name="fade" mode="out-in">
    <div v-if="isVisible" class="toast" :class="type">
      <div class="toast-content">
        <div class="icon">
          <span class="material-symbols-outlined">
              {{ icon }}
          </span>
        </div>
        <div class="text-content">
          <h3>{{ title }}</h3>
          <p>{{ message }}</p>
        </div>
      </div>
    </div>
  </transition>
</template>
  
  <script>
  export default {
    data() {
      return {
        isVisible: false,
        message: '',
        title: 'Success',
        type: 'success', // info, success, error, etc.
        timeout: null,
        icon: 'check_box'
      };
    },
    methods: {
      showToast(title, message, type = 'success', icon="", duration = 3000) {
        if(icon == ""){
          switch(type){
            case 'success':
              icon = "check_circle";
              break;
            case 'error':
              icon = "error";
              break;
            case 'warning':
              icon = "";
              break;
          }
        }
        this.title = title;
        this.message = message;
        this.type = type;
        this.isVisible = true;
        this.icon = icon
  
        // Automatically hide the toast after the duration
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
          this.isVisible = false;
        }, duration);
      },
    },
  };
  </script>
  
  <style scoped>
  .toast {
    position: fixed;
    top: 20px;
    left: calc(50% - 150px);
    width: 300px;
    padding: 10px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    z-index: 9999;
  }
  
  .toast-content {
    display: flex;
    align-items: center;
  }
  
  .icon {
    padding: 8px;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 15px;
  }

  .icon span{
    font-size: 30px;
  }
  
  .text-content h3 {
    margin: 0;
    font-size: 18px;
    line-height: 1.2;
  }
  
  .text-content p {
    margin: 0;
    font-size: 14px;
    line-height: 1.2;
  }
  
  .fade-enter-active, .fade-leave-active {
    transition: opacity 0.5s;
  }
  
  .fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
    opacity: 0;
  }

 
  .success{
    background-color: #d1fae5 !important;
    color: #027745;
  }

  .success .icon span{
    color: #027745;
  }

  /* Error toast */
.error {
  background-color: #f8d7da;
  color: #dc3545;
}

.error .icon span{
  color: #dc3545;
}

/* Warning toast */
.warning {
  background-color: #fff3cd;
  color: #ffc107;
}

.warning .icon span{
  color: #ffc107;
}


  </style>