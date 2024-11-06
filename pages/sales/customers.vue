<template>
  <div class="h-full w-full">
      <div class="flex items-center justify-end">
        <Button @click="openAddPopup"><Icon name="lucide:plus" size="24" />Add Customer</Button>
        <FormAddCustomer @success="onSuccess" v-model:open="isDialogOpen" :data="selectedRow"/>
      </div>
      <div class="h-full w-full mt-4 ">
        <DataTable :data="customers" :columns="columns" :actions="menuItems" :loading="loading"/>
      </div>
  </div>
</template>
<script>
definePageMeta({
layout: 'auth',
middleware: [
  function (to, from) {
    // Custom inline middleware
  },
  'auth',
],
});

export default {
  data() {
    return {
      selectedRow: {
        id: null,
        name: '',
        billingAddress: '',
        clientMarkup: 0
      },
      isDialogOpen: false,
      loading: true,
      showPopup: false,
      customers: [],
      columns: [
        {key: 'name', label: 'Name'},
        {key: 'billingAddress', label: 'Billing Address'},
        {key: 'clientMarkup', label: 'Client Markup'}
      ],
      menuItems: [
          {
            icon: 'lucide:edit',
            label: `Edit`,
            action: (key) => {
              console.log(key)
              this.editItem(key);
            },
          },
          {
            icon: 'lucide:trash',
            label: `Delete`,
            action: (key) => {
              this.deleteItem(key);
            },
          },
      ],
    };
  },
  methods: {
    openPopup,
    closePopup,
    fetchData,
    editItem,
    deleteItem,
    onSuccess,
    resetSelectedRow,
    openAddPopup
  },
  mounted() {
    this.fetchData();
  }
};

function openAddPopup(){
  this.resetSelectedRow();
  this.isDialogOpen = true;
}

function openPopup(){
  this.isDialogOpen = true;
}
function closePopup() {
    this.isDialogOpen = false;
    this.resetSelectedRow();
}
async function fetchData() {
  this.loading = true;
  const api = useApi();
  const response = await api.get('/api/customer/getCustomers');
  console.log(response);
  this.customers = response;
  this.loading = false;
}

function onSuccess() {
  console.log('onSuccess');
  this.fetchData();
  this.closePopup();
}

function resetSelectedRow() {
  this.selectedRow = {
    id: null,
    name: '',
    billingAddress: '',
    clientMarkup: 0
  }
}

async function editItem(key) {
  console.log(key);
  this.selectedRow = {
    id: key.id,
    name: key.name,
    billingAddress: key.billingAddress,
    clientMarkup: key.clientMarkup
  }
  this.openPopup();
}

async function deleteItem(key) {
  const api = useApi();
  const response = await api._delete(`/api/customer/deleteCustomer`,{ params: { id: key.id } });
  console.log(response);
  this.fetchData()
}
</script>
