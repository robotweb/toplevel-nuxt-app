import axios from "axios";

export default defineEventHandler(async (event) => {
    const config = useRuntimeConfig();
    const body = await readBody(event);
    const authorizationHeader = getHeader(event, 'authorization');
    
    //console.log(body)
    try{
        console.log(authorizationHeader);
        console.log(body);
        const response = await axios.post(`${config.public.apiUrl}/api/material/addMaterial`,
            {
                "name" : body.name,
                "code" : body.code,
                "description" : body.description,
                "discount" : body.discount,
                "supplier" : body.supplier,
                "quantity" : body.quantity,
                'unitOfMeasure' : body.unitOfMeasure,
                "unitCost" : body.unitCost
            },{
                headers: {
                    'Authorization': `${authorizationHeader}`,
                    'Content-Type': 'application/json'
                }
            });
        console.log(response.data)
        if(response.status != 200){
            throw new Error(response.data.message);
        }
        // Return the response data to the client
        return {
            statusCode: response.status, 
            message: response.data.message,
            details: response.data.data
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