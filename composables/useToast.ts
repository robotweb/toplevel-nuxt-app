import { useState } from "nuxt/app"

interface ToastState {
  title: string
  message: string
  type: 'success' | 'error' | 'info' | 'warning'
  show: boolean
  icon: string
}

export const useToast = () => {
  const toast = useState<ToastState>('toast', () => ({
    title: '',
    message: '',
    type: 'info',
    show: false,
    icon: ''
  }))

  const triggerToast = (type: ToastState['type'], title: string, message: string, icon: string) => {
    if(!icon){
        switch(type){
            case 'success':
                icon = 'check_circle'
                break;
            case 'error':
                icon = 'error'
                break;
            case 'info':
                icon = 'info'
                break;
            case 'warning':
                icon = 'warning'
                break;
        }
    }
    toast.value = { type, title, message, show: true, icon}
    setTimeout(() => {
      toast.value.show = false
    }, 3000)
  }

  return {
    toast,
    triggerToast
  }
}
