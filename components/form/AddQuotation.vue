<template>
  <div class="quote-container ml-5">
    <!-- Header Section -->
    <div class="flex items-center justify-between">
      <div class="flex items-center space-x-4">
        <h2 class="text-2xl font-bold">Estimate</h2>
      </div>
    </div>

    <form @submit.prevent="submitQuotation">
      <!-- Client Information Section -->
      <div class="flex mt-8 justify-between">
        <div class="grid grid-cols-1 gap-4 mt-4">
          <h3 class="font-bold">Bill to</h3>
          <input v-model="formData.businessName" type="text" placeholder="Client Business Name">
          <input v-model="formData.clientName" type="text" placeholder="Client Contact Person Name" style="width:250px">
          <input v-model="formData.clientEmail" type="text" placeholder="Client Email Address">
          <input v-model="formData.clientContact" type="text" placeholder="Client Contact Number">
          <Combobox :options="customerData.map(cus => ({ 'value': cus.id, 'label': cus.name }))"
            :placeholder="'Select customer'" @change="handleCustomEvent"></Combobox>
        </div>

        <!-- Quotation Details -->
        <div class="grid grid-cols-1 gap-4 mt-4">
          <input v-model="formData.quotationId" type="text" class="border border-gray-300 p-2 rounded-md"
            placeholder="Quotation Number" />
          <input v-model="formData.customerReference" type="text" class="border border-gray-300 p-2 rounded-md"
            placeholder="Customer Reference (PO)" />
          <input v-model="formData.dateIssued" type="date" class="border border-gray-300 p-2 rounded-md" placeholder="Date" />
          <input v-model="formData.validUntil" type="date" class="border border-gray-300 p-2 rounded-md"
            placeholder="Valid until" />
        </div>
      </div>

      <!-- Line Items Table -->
      <div class="mt-8">
        <table class="w-full border-collapse">
          <thead class="bg-gray-100">
            <tr>
              <th class="border p-2 text-left">Description</th>
              <th class="border p-2 text-right">Quantity</th>
              <th class="border p-2 text-right">Unit Price</th>
              <th class="border p-2 text-right">Percentage Complete</th>
              <th class="border p-2 text-right">Item Price</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in formData.quoteItems" :key="index">
              <td class="border p-2">
                <div class="flex items-start space-x-2">
                  <div>
                    <strong>Category</strong>
                    <p>Line Item Name</p>
                  </div>
                  <textarea v-model="item.description" class="text-sm border border-gray-300 p-2 rounded-md"></textarea>
                </div>
              </td>
              <td class="border p-2 text-right">
                <input v-model="item.quantity" type="number"
                  class="border border-gray-300 p-2 rounded-md w-full text-right" />
              </td>
              <td class="border p-2 text-right">
                <input v-model="item.unitPrice" type="number"
                  class="border border-gray-300 p-2 rounded-md w-full text-right" />
              </td>
              <td class="border p-2 text-right">
                <input v-model="item.percentageComplete" type="number"
                  class="border border-gray-300 p-2 rounded-md w-full text-right" />
              </td>
              <td class="border p-2 text-right">
                {{ calculateItemPrice(item.quantity, item.unitPrice) }}
              </td>
              <td class="border p-2 text-right">
                <a @click.prevent="deleteItem(index)" class="text-blue-500">Delete Line Item</a>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Add Item Button -->
        <div class="mt-4">
          <button @click.prevent="addItem" class="text-blue-500">+ Add Item</button>
        </div>
      </div>

      <!-- Footer Section (Totals) -->
      <div class="mt-8">
        <div class="grid grid-cols-2 gap-4">
          <div>
            <h3 class="font-bold">Footer Notes</h3>
<!--            <textarea v-model="formData.footerNotes" class="border border-gray-300 p-2 rounded-md w-full"></textarea>-->
          </div>
          <div class="space-y-2">
            <div class="flex justify-between">
              <span>Sub-Total:</span>
              <span>{{ calculateSubTotal() }}</span>
            </div>
            <div class="flex justify-between">
              <span>Invoiced - To - Date:</span>
              <span>{{ formData.invoicedToDateAmount }}</span>
            </div>
            <div class="flex justify-between">
              <span>Total (ex. VAT):</span>
              <span>{{ calculateTotalExVat() }}</span>
            </div>
            <div class="flex justify-between">
              <span>VAT @ {{formData.vatPercentage}}%:</span>
              <span>{{ calculateVat() }}</span>
            </div>
            <div class="flex justify-between font-bold">
              <span>Total Cost incl. VAT:</span>
              <span>{{ calculateTotalInclVat() }}</span>
            </div>
          </div>
        </div>

        <!-- Signature Section -->
        <div class="flex justify-between mt-8">
          <div>
            <p>Signed</p>
            <div class="border-b border-gray-500 w-40"></div>
          </div>
          <div>
            <p>Date</p>
            <div class="border-b border-gray-500 w-40"></div>
          </div>
        </div>
      </div>

      <!-- Submit Button -->
      <div class="mt-8">
        <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded-md" @click="fetchCustomerData">
          Submit Quotation
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { QuotationCreateRequest, QuotationType, QuoteItems } from '../../models/quotationModels';
import { useFetch, useRuntimeConfig } from 'nuxt/app';
import { CustomerResponse } from '../../models/customerModels';
import Combobox from '../Combobox.vue';
import {LineItemCostCalculationResponse} from "../../models/LineItemModels";

const open = ref(false)
const value = ref('')
const customerData = ref<CustomerResponse[] | null>([{
  id: 'yyuu',
  name: 'faieez Tech',
  billingAddress: '02 witfontein',
  clientMarkup: 25,
  contacts: [{
    email: 'f@gmail.com',
    name: 'faz',
    phoneNumber: '000000',
    mobileNumber: '1111111',
    surName: 'white',
  }]
}]);
const allLineItems = ref<LineItemCostCalculationResponse[]>([]);
const error = ref<string | null>(null);
const isLoading = ref(false);

const fetchCustomerData = async () => {
  const token = localStorage.getItem('authToken');
  const config = useRuntimeConfig();

  const { data, error: fetchError } = await useFetch<CustomerResponse[]>(`${config.public.apiUrl}/api/customer/getCustomers`, {
    headers: {
      Authorization: token ? `Bearer ${token}` : ''
    },
    immediate: true, // Fetch immediately
  });

  if (fetchError.value) {
    error.value = fetchError.value.message;
  } else {
    customerData.value = [...customerData.value,...data.value];
  }
};

const fetchItemsData = async () => {
  const token = localStorage.getItem('authToken');
  const config = useRuntimeConfig();

  const { data , error: fetchError } = await useFetch<LineItemCostCalculationResponse[]>(`${config.public.apiUrl}/api/lineitem/getAllLineItems`, {
    headers: {
      Authorization: token ? `Bearer ${token}` : ''
    },
    immediate: true, // Fetch immediately
  });

  if (fetchError.value) {
    error.value = fetchError.value.message;
  } else {
    allLineItems.value = data.value.data;
  }
};

onMounted(async () => {
  isLoading.value = true; // Set loading state to true
  await Promise.all([fetchCustomerData(), fetchItemsData()]);
  isLoading.value = false; // Set loading state to false
});


const formData = ref<QuotationCreateRequest>({
  quotationId: "",
  clientContact: "",
  clientEmail: "",
  clientName: "",
  businessName:"",
  dateIssued: "",
  quotationType: QuotationType.Estimate,
  subTotal: 0,
  tag: QuotationType.Estimate,
  totalCost: 0,
  totalCostVat: 0,
  customerReference: '',
  invoicedToDateAmount: 0,
  validUntil: '',
  quoteItems: [
    {
      quoteItemId: "",
      code: "",
      category: { id: "", name: "", rank: 1 },
      subCategory: { id: "", name: "", rank: 1 },
      description: '',
      quantity: 10,
      unitPrice: 100,
      percentageComplete: 25,
      itemCost: 0,
      name: ""
    }
  ],
  vatPercentage: 15,
});

const handleCustomEvent = (data: string) => {
  console.log('Received event with data:', data);
  var selectedCustomer = customerData.value.find(c => c.id == data);
  formData.value.clientName = selectedCustomer.contacts[0].name;
  formData.value.clientEmail = selectedCustomer.contacts[0].email;
  formData.value.clientContact = selectedCustomer.contacts[0].mobileNumber;
  formData.value.businessName = selectedCustomer.name;
};

const calculateSubTotal = () => {
  return formData.value.quoteItems.reduce((total, item) => {
    return total + (item.quantity * item.unitPrice * (item.percentageComplete / 100));
  }, 0);
}

const calculateTotalExVat = () => {
  return calculateSubTotal();
}

const calculateVat = () => {
  return (calculateSubTotal() * formData.value.vatPercentage) / 100;
}

const calculateTotalInclVat = () => {
  return calculateSubTotal() + calculateVat();
}

const submitQuotation = () => {
  console.log('Quotation submitted', formData.value);
}

const calculateItemPrice = (quantity: number, unitPrice: number) => {
  return quantity * unitPrice;
}

const addItem = () => {
  formData.value.quoteItems.push({
    quoteItemId: "",
    code: "",
    category: { id: "", name: "", rank: 1 },
    subCategory: { id: "", name: "", rank: 1 },
    description: '',
    quantity: 10,
    unitPrice: 100,
    percentageComplete: 25,
    itemCost: 0,
    name: ""
  });
}


const deleteItem = (index: number) => {
  formData.value.quoteItems.splice(index, 1);
}
</script>

<style scoped>
.quote-container {
  margin-top: 20px;
  align-self: center;
  min-width: 50%;
  max-width: 70%;
  min-height: 700px;
  position: relative;
}
</style>
