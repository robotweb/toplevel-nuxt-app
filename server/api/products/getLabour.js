import axios from "axios";

export default defineEventHandler(async (event) => {
    const config = useRuntimeConfig();
    const authorizationHeader = getHeader(event, 'authorization');
    
    //console.log(body)
    try{
        //console.log(authorizationHeader);
        const response = await axios.get(`${config.public.apiUrl}/api/labour/getLabours`,{
                headers: {
                    'Authorization': `${authorizationHeader}`,
                    'Content-Type': 'application/json'
                }
            });
        //console.log(response.data)
        if(response.status != 200){
            throw new Error(response.data.message);
        }
        // Return the response data to the client
        return {
            statusCode: response.status, 
            message: response.data,
        };
    }catch(error){
        console.error('Error making request:', error.message);
        return {
            statusCode: error.response?.status || 500,
            message: 'An error occurred while processing the request.',
            details: error.response?.data || error.message,
        };
    }
    
  });