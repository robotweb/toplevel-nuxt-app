<template>
   <Dialog v-bind:open="isDialogOpen">
    <DialogTrigger></DialogTrigger>
    <DialogContent>
  <DialogHeader>
        <DialogTitle></DialogTitle>
        <DialogDescription>
        </DialogDescription>
  </DialogHeader>
  <div class="flex flex-col gap-2">
      <Input type="string" placeholder="Code"  v-model="data.supplierCode" required/>
      <Input type="string" placeholder="Name"  v-model="data.supplierName" required/>     
      <div class="flex justify-end">
        <Button v-if="!data.id" @click="addSupplier" type="submit">Save</Button>
        <Button v-if="data.id" @click="editSupplier" type="submit">Edit</Button>
      </div>
  </div>
</DialogContent>
</Dialog>
</template>
<script>
export default {
  props: {
    isDialogOpen: {
      type: Boolean,
      default: false
    },
    data: {
      type: Object,
      required: true
    }
  },
  methods: {
    keyUp,
    addSupplier,
    editSupplier
  },
};

function keyUp(){
  this.calculatedPrice = this.unitCost - (this.unitCost * this.discount/100);
}

async function addSupplier(){
  const api = useApi();
  const response = await api.post('/api/supplier/createSupplier', this.data);
  this.$emit('success');
}

async function editSupplier(){
  const api = useApi();
  const response = await api.put('/api/supplier/updateSupplier', this.data);
  this.$emit('success');
}
</script>
