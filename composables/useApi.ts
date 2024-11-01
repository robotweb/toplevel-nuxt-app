// composables/useApi.ts
import { useFetch, useRuntimeConfig } from "nuxt/app";

interface ApiResponse<T> {
  data: T | null;
  error: Error | null;
}

// Define a type for allowed HTTP methods
type HttpMethod = "GET" | "POST" | "PUT" | "DELETE";

interface ApiOptions {
  headers?: Record<string, string>;
  method?: HttpMethod;
  body?: any;
}

// Generic function to handle API fetch with proper typing
export function useApiFetch<T>(url: string, options?: ApiOptions) {
  const config = useRuntimeConfig();
  return useFetch<T>(`${config.public.apiUrl}${url}`, {
    method: (options?.method?.toLowerCase() as any) || "get",
    headers: options?.headers || {
      "Content-Type": "application/json",
      //Authorization: `Bearer ${localStorage.getItem("auth")}`,
    },
    body: options?.body,
  });
}
