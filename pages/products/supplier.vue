<template>
        <div class="h-full w-full">
          <div class="flex items-center justify-end">
            <Button @click="addSupplier"><Icon name="lucide:plus" size="24" />Add Supplier</Button>
          </div>
          <FormAddSupplier @success="onSuccess" v-model:open="isDialogOpen" :data="selectedItem"/>
            <div class="h-full w-full mt-4 ">
              <DataTable :columns="columns" :data="items" :actions="menuItems" :loading="loading"/>
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
  ]
});
export default {
  data() {
    return {
      isDialogOpen: false,
      selectedItem: {
        id: null,
        itemCode: '',
        supplierName: ''
      },
      items: [],
      loading: true,
      columns: [
        { key: 'supplierCode', label: 'Code', class: 'w-24' },
        { key: 'supplierName', label: 'Name' },
      ],
      menuItems: [
          {
            icon: 'lucide:edit',
            label: 'Edit',
            action: (key) => {
              console.log(key)
              this.editItem(key);
            },
          },
          {
            icon: 'lucide:trash',
            label: 'Delete',
            action: (key) => {
              this.deleteItem(key);
            },
          },
      ]
    };
  },
  methods: {
    fetchData,
    deleteItem,
    editItem,
    openDialog,
    closeDialog,
    onSuccess,
    addSupplier
  },
  mounted(){
    this.fetchData();
  }
};

async function addSupplier(){
  console.log('addSupplier')
  this.selectedItem = {
    id: null,
    itemCode: '',
    supplierName: ''
  }
  this.openDialog();
}

async function onSuccess(){
  this.fetchData();
  this.closeDialog();
}

async function editItem(key){
  this.selectedItem = key;
  this.openDialog();
}

function openDialog(){
  this.isDialogOpen = true;
}

function closeDialog(){
  this.isDialogOpen = false;
}

async function fetchData(){
  const api = useApi();
  const response = await api.get('/api/supplier/getAllSuppliers');
  this.items = response;
  this.loading = false;

}

async function deleteItem(key){
  const id = key.id;
  const api = useApi();
  const response = await api._delete(`/api/supplier/deleteSupplier`, { params: { id: id } });
  this.fetchData();
}

</script>

