import axios from "axios";

export default defineEventHandler(async (event) => {
    const config = useRuntimeConfig();
    const body = await readBody(event);
    const authorizationHeader = getHeader(event, 'authorization');
    
    console.log(body)
    try{

        const response = await axios.post(`${config.public.apiUrl}/api/category/addCategory`,
            {
                "name" : body.name,
                "rank" : body.rank,
            },{
                headers: {
                    'Authorization': `${authorizationHeader}`,
                    'Content-Type': 'application/json'
                }
            });
        console.log(response)
        if(response.status != 200){
            throw new Error(response.data.message);
        }
        // Return the response data to the client
        return {
            statusCode: response.status, 
            message: response.data.message,
            details: response.data.message
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