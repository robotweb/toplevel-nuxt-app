export const useApi = () => {
  const config = useRuntimeConfig();
  const baseUrl = config.public.apiUrl

  const get = async <T>(endpoint: string) => {
    return await $fetch<T>(`${baseUrl}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('auth')}`
      }
    })
  }

  const post = async <T>(endpoint: string, payload: any) => {
    try {
      console.log('Request URL:', `${baseUrl}${endpoint}`)
      console.log('Request Payload:', payload)

      return await $fetch<T>(`${baseUrl}${endpoint}`, {
        method: 'POST',
        body: payload,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('auth')}`
        },
      })
    } catch (err) {
      console.error('API Error:', err)
      throw err
    }
  }

  const _delete = async <T>(endpoint: string, options = {}) => {
    const queryString = options.params ? `?${new URLSearchParams(options.params)}` : '';
    return await $fetch<T>(`${baseUrl}${endpoint}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth')}`
      },
      ...options
    })
  }

  const put = async <T>(endpoint: string, payload: any) => {
    return await $fetch<T>(`${baseUrl}${endpoint}`, {
      method: 'PUT',
      body: payload,
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth')}`
      }
    })
  }

  return {
    get,
    post,
    _delete,
    put
  }
}
