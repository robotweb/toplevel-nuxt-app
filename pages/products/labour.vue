<template>
  <div  class="h-full w-full">
    <div class="flex items-center justify-end">
      <Button @click="addLabour"><Icon name="lucide:plus" size="24" />Add Labour</Button>
    </div>
    <FormAddLabour @success="onSuccess" v-model:open="isDialogOpen" :data="selectedItem"/>
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
],
});
export default {
  data() {
    return {
      loading: true,
      isDialogOpen: false,
      selectedItem: null,
      items: [],
      columns: [
        {key : "name", label : "Name"},
        {key : "description", label : "Description"}
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
    }
  },
  methods : {
    openDialog,
    closeDialog,
    deleteItem,
    fetchData,
    onSuccess,
    editItem,
    addLabour,
    resetData
  },
  mounted(){
    this.fetchData();
  }
};

async function resetData(){
  this.selectedItem = {
    name: "",
    code: "",
    description: "",
    unitCost: null,
    unitType: "",
  };
}

function addLabour(){
  this.resetData();
  this.isDialogOpen = true;
}

async function openDialog(){
  this.isDialogOpen = true;
}

async function closeDialog(){
  this.isDialogOpen = false;
}

async function deleteItem(key){
  const id = key.id;
  const api = useApi();
  const response = await api._delete(`/api/labour/deleteLabour/`, { params: { id: id } });
  this.fetchData();
}

async function editItem(key){
  this.selectedItem = key;
  this.isDialogOpen = true;
}

async function onSuccess(){
  this.fetchData();
  this.isDialogOpen = false;
}

async function fetchData(){
  this.loading = true;
  const api = useApi();
  const response = await api.get('/api/labour/getLabours');
  this.loading = false;
  this.items = response;
}
</script>
