import axios from "axios";
import { defineEventHandler } from "h3";
import { readBody, getHeader } from "h3";
import { useRuntimeConfig } from "nuxt/app";
import { QuotationCreateRequest } from "../../../models/quotationModels";

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig();
  const body: QuotationCreateRequest =
    await readBody<QuotationCreateRequest>(event);
  const authorizationHeader = getHeader(event, "authorization");

  //console.log(body)
  try {
    console.log(authorizationHeader);
    console.log(body);
    const response = await axios.post(
      `${config.public.apiUrl}/api/quotation/createQuotation`,
      body,
      {
        headers: {
          Authorization: `${authorizationHeader}`,
          "Content-Type": "application/json",
        },
      }
    );
    console.log(response.data);
    if (response.status != 200) {
      throw new Error(response.data.message);
    }
    // Return the response data to the client
    return {
      statusCode: response.status,
      message: response.data.message,
      details: response.data.data,
    };
  } catch (error) {
    console.error("Error making request:", error.message);
    return {
      statusCode: error.response?.status || 500,
      message: "An error occurred while processing the request.",
      details: error.response?.data || error.message,
    };
  }
});
