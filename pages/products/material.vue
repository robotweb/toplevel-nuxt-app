<template>
    <div class="h-full w-full">
            <div class="flex items-center justify-end">
              <Button @click="openDialog"><Icon name="lucide:plus" size="24" />Add Material</Button>
            </div>
            <FormAddMaterial @success="onSuccess" :data="data" v-model:open="isDialogOpen"/>
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
      data: {
        id: null,
        code: '',
        name: '',
        description: ''
      },
      loading: true,
      isDialogOpen: false,
      items: [],
      columns: [
        { key: 'code', label: 'Code', class: 'w-24' },
        { key: 'name', label: 'Name' },
        { key: 'description', label: 'Description' },
      ],
      menuItems: [
          {
            label: 'Edit',
            icon: 'lucide:edit',
            action: (key) => {
              this.editItem(key);
            },
          },
          {
            label: 'Delete',
            icon: 'lucide:trash',
            action: (key) => {
              this.deleteItem(key);
            },
          },
      ]
    };
  },
  methods: {
    editItem,
    deleteItem,
    fetchData,
    openDialog,
    closeDialog,
    resetData,
  },
  mounted(){
    this.fetchData();
  }
};

async function onSuccess(){
  console.log('onSuccess')
  this.fetchData();
}

function openDialog(){
  console.log('openDialog')
  this.resetData();
  this.isDialogOpen = true;
}

function closeDialog(){
  this.isDialogOpen = false;
}

function resetData(){
  this.data = {
    id: null,
    code: '',
    name: '',
    description: '',
    supplierId: null,
    unitType: null
  }
}

async function editItem(key){
  console.log(key)
  this.data = {
    id: key.id,
    code: key.code,
    name: key.name,
    description: key.description
  }
  this.isDialogOpen = true;
}

async function fetchData(){
  this.loading = true;
  const api = useApi();
  const response = await api.get('/api/material/getMaterials');
  this.loading = false;
  this.items = response
}

async function deleteItem(key){
  let id = key.id
  const api = useApi();
  const response = await api._delete(`/api/material/deleteMaterial/`, { params: { id: key.id } });
  this.fetchData();
}

</script>

