import axios from "axios";

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig();
  const body = await readBody(event);

  console.log('Request body:', body);

  try {
    // Make the request to the external API
    const response = await axios.post(
      `${config.public.apiUrl}/api/admin/customLogin`,
      body,
      {
        headers: {
          "Content-Type": "application/json",
        },
      }
    );
    response.data = {
      token: response.data.token,
      statusCode: 200
    }
    //console.log('API response:', response.data);

    // Log and return the response data to the client
    // console.log('API response:', response.data);
    return response.data; // Return only the data part of the response
  } catch (error) {
    // Handle errors appropriately
    console.error('Error making request:', error.message);
    
    // Optionally, return an error message to the client
    return {
      statusCode: error.response?.status || 500,
      message: 'An error occurred while processing the request.',
      details: error.response?.data || error.message,
    };
  }
});