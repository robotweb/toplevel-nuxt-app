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
      <Input type="string" placeholder="Code"  v-model="data.code" required/>
      <Input type="string" placeholder="Name"  v-model="data.name" required/>
      <Textarea v-model="data.description" required  placeholder="Description" />
      <Input type="number" placeholder="Price"  v-model="data.unitCost" required @keyup="keyUp()"/>
      <Input type="number" placeholder="Discount (%)"  v-model="data.discount" required @keyup="keyUp()"/>
      <Popover v-model:open="isPopoverOpen">
        <PopoverTrigger>
          <Button variant="outline" role="combobox" class="w-full justify-between">
            {{ selectedSupplier?.supplierName || 'Select supplier...' }}
            <ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
          </Button>
        </PopoverTrigger>
        <PopoverContent class="w-full p-0">
          <Command>
            <CommandInput class="border-0" placeholder="Search supplier..." />
            <CommandEmpty>No supplier found.</CommandEmpty>
            <CommandList>
              <CommandItem 
                v-for="supplier in suppliers" 
                :key="supplier.id"
                @click="supplierChange(supplier)"
              >
                {{ supplier.supplierName }}
              </CommandItem>
            </CommandList>
          </Command>
        </PopoverContent>
      </Popover>
      <label class="text-sm font-medium w-full flex justify-end py-2"><p><strong>Price {{ calculatedPrice }}</strong></p></label>
      <div class="flex justify-end">
        <Button v-if="!data.id" @click="addMaterial" type="submit">Save</Button>
        <Button v-if="data.id" @click="editMaterial" type="submit">Edit</Button>
      </div>
  </div>
</DialogContent>
</Dialog>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      required: false
    },
    isDialogOpen: {
      type: Boolean,
      required: false
    }
  },
  data() {
    return {
      calculatedPrice: '0.00',
      isLoading: false,
      isDialogOpen: false,
      suppliers: [],
      supplierPlaceholder : "Select supplier...",
      isPopoverOpen: false,
      selectedSuppier: null
    };
  },
  methods: {
    getSuppliers,
    supplierChange,
    addMaterial,
    editMaterial,
    keyUp
  },
  mounted(){
    this.getSuppliers();
  }
};

async function getSuppliers(){
  const api = useApi();
  const response = await api.get('/api/supplier/getAllSuppliers');
  this.suppliers = response;        
}

function supplierChange(supplier) {
  this.selectedSupplier = supplier;
  this.data.supplierId = supplier.id;
  this.isPopoverOpen = false;
}

async function addMaterial(){
  const api = useApi();
  const response = await api.post('/api/material/addMaterial', this.data);
  this.$emit('success');
  this.isDialogOpen = false;
}

async function editMaterial(){
  const api = useApi();
  const response = await api.put('/api/material/updateMaterial', this.data);
  this.$emit('success');
  this.isDialogOpen = false;
}

function keyUp(){
  this.calculatedPrice = this.unitCost - (this.unitCost * this.discount/100);
}
</script>
