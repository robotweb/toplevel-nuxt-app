<script setup  lang="ts">

import {MaterialResponse} from "../../models/materialModels";
import {ref} from "vue";
import {LabourResponse} from "../../models/labourModels";
import {
  LineItemCostCalculationCreateRequest,
  LineItemCostCalculationResponse,
  Tag
} from "../../models/lineItemCostCalculationModels";
import {CategoryResponseModel} from "../../models/categoryModels";

const lineItemCostCalculationData = ref<LineItemCostCalculationResponse[] | null>([{
  id:'',
  name: '',
  description: '',
  code: '',
  category: {
    id: "",
    name: "",
    rank: 0,
  },
  markupPercentage: 0,
  subTotal: 0,
  total: 0,
  markupCost: 0,
  items: [
    {
      id: "",
      name: "",
      itemDescription: "",
      code: "",
      unitOfMeasure: "",
      listDiscountPercentage: 0,
      quantityPerItem: 0,
      listPrice: 0,
      quantityRequired: 0,
      discountPrice: 0,
      wasteAllowedPrice: 0,
      wasteAllowedPercentage: 0,
      listQuantity: 0,
      totalCost: 0,
      tag: Tag.Material
    },
  ]
}
]);
const materialData = ref<MaterialResponse[] | null>([{
    id: '',
    name: '',
    code: '',
    description: '',
    discount: 0,
    supplierCode: '',
    quantity: 0,
    unitOfMeasure: '',
    unitCost: 0
}]);

const labourData = ref<LabourResponse[] |null>([{
  id: '',
  name: '',
  code: '',
  description: '',
  unitCost: 0,
  unit:''
}]);

const categoryData = ref<CategoryResponseModel[] | null>([{
  id:'',
  name:'',
  rank:0
}]);

const fetchCategoryData = async () => {
  const api = useApi();

  const response = await api.get<CategoryResponseModel[]>('/api/category/getCategories');
  categoryData.value = response.data;
};

const fetchMaterialData = async () => {
  const api = useApi();

  const response = await api.get<MaterialResponse[]>('/api/material/getMaterials');
  materialData.value = response.data;
};

const fetchLabourData = async () => {
  const api = useApi();

  const response = await api.get<MaterialResponse[]>('/api/labour/getLabours');
  labourData.value = response.data;
};

const postLineItemCalculation = async (data : LineItemCostCalculationCreateRequest) => {
  const api = useApi();

  const response = await api.post<LineItemCostCalculationResponse>('/api/lineitem/addLineItem',data)
}
</script>

<template>
  <div class="bg-white shadow-lg rounded-lg">
    <!-- Title Section -->
    <h1 class="text-2xl font-semibold mb-6">Create Line Item - Cost Calculation</h1>

    <form action="#" method="POST">
      <!-- Name, Category, and Code Section -->
      <div class="grid grid-cols-3 gap-4 mb-6">
        <div>
          <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
          <input
              type="text"
              id="name"
              name="name"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="Enter name"
          />
        </div>
        <div>
          <label for="category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
          <input
              type="text"
              id="category"
              name="category"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="Enter category"
          />
        </div>
        <div>
          <label for="code" class="block text-sm font-medium text-gray-700 mb-1">Code</label>
          <input
              type="text"
              id="code"
              name="code"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="Enter code"
          />
        </div>
      </div>

      <!-- Description Section -->
      <div class="mb-6">
        <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
        <textarea
            id="description"
            name="description"
            rows="3"
            class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
            placeholder="Enter description"
        ></textarea>
      </div>

      <!-- Markup Percentage and Info -->
      <div class="flex items-center justify-between mb-6">
        <div class="w-1/3">
          <label for="markup" class="block text-sm font-medium text-gray-700 mb-1">Markup %</label>
          <input
              type="number"
              id="markup"
              name="markup"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="25"
          />
        </div>
        <button type="button" class="text-blue-500 text-sm underline hover:text-blue-700">
          Info: Show calculation
        </button>
      </div>

      <!-- Items Required Section -->
      <div class="headers" >
        <h2 class="text-lg font-semibold mb-4" style="width:400px">Item Required</h2>
        <label class="mini-items text-sm font-medium text-gray-700">QTY per Item</label>
        <label class="mini-items text-sm font-medium text-gray-700">Unit of Measure</label>
        <label class="mini-items text-sm font-medium text-gray-700">QTY Required</label>
        <label class="mini-items text-sm font-medium text-gray-700">Unit of Measure</label>
        <label class="mini-items text-sm font-medium text-gray-700">Price   (ex. VAT)</label>
        <label class="mini-items text-sm font-medium text-gray-700">Waste Allow</label>
        <label class="mini-items text-sm font-medium text-gray-700">Incl Waste Allow (ex. VAT)</label>
        <label class="mini-items text-sm font-medium text-gray-700">Total Cost</label>
      </div>

      <div class="header-items">
        <div class="max-w-" style="width:400px">
          <input
              type="text"
              name="material"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="Material"
          />
        </div>
        <div class="mini-items">
          <input
              type="number"
              name="qtyPerItem"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="3.6"
          />
        </div>
        <div class="mini-items">
          <select
              name="unitOfMeasure"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
          >
            <option value="m">m</option>
            <option value="kg">kg</option>
          </select>
        </div>
        <div class="mini-items">
          <input
              type="number"
              name="qtyPerItem"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="3.6"
          />
        </div>
        <div class="mini-items">
          <select
              name="unitOfMeasure"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
          >
            <option value="m">m</option>
            <option value="kg">kg</option>
          </select>
        </div>
        <div class="mini-items">
          <input
              type="number"
              name="priceExVat"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="35.00"
          />
        </div>
        <div class="mini-items">
          <input
              type="number"
              name="wasteAllow"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="5%"
          />
        </div>
        <div class="mini-items">
          <input
              type="text"
              name="totalCost"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm bg-gray-100"
              readonly
              value="R 36.75"
          />
        </div>
        <div class="mini-items">
          <input
              type="text"
              name="totalCost"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm bg-gray-100"
              readonly
              value="R 36.75"
          />
        </div>
      </div>

      <!-- Additional Items -->
      <button type="button" class="text-blue-500 text-sm underline hover:text-blue-700 mb-4">
        + Additional Item
      </button>

      <!-- Misc Section -->
      <div class="flex items-center justify-between mb-6">
        <div class="flex-grow">
          <label class="block text-sm font-medium text-gray-700 mb-1">Misc</label>
          <input
              type="text"
              name="misc"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="Enter misc cost"
          />
        </div>
        <div class="ml-4 w-1/4">
          <label class="block text-sm font-medium text-gray-700 mb-1">%</label>
          <input
              type="number"
              name="miscPercentage"
              class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-blue-300 focus:border-blue-500"
              placeholder="10"
          />
        </div>
      </div>

      <!-- Cost Summary Section -->
      <div class="flex justify-end items-center space-x-8">
        <div>
          <p class="text-gray-700 text-sm">Sub-Total</p>
          <p class="font-semibold">R 1100.00</p>
        </div>
        <div>
          <p class="text-gray-700 text-sm">Markup</p>
          <p class="font-semibold">R 270.00</p>
        </div>
        <div>
          <p class="text-gray-700 text-sm">Total Cost (ex. VAT)</p>
          <p class="font-semibold text-lg text-blue-600">R 1375.00</p>
        </div>
      </div>

      <!-- Save Button -->
      <div class="mt-6 text-right">
        <button
            type="submit"
            class="bg-blue-500 text-white px-6 py-2 rounded hover:bg-blue-600 focus:ring focus:ring-blue-300"
        >
          Save all changes
        </button>
      </div>
    </form>
  </div>
</template>



<style scoped lang="scss">
.mini-items{
 width:75px;
}

.headers{
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.header-items{
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}
</style>