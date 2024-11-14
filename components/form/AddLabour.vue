<template>
  <Dialog v-model:open="isDialogOpen">
    <DialogContent>
      <DialogHeader>
        <DialogTitle></DialogTitle>
        <DialogDescription>
        </DialogDescription>
      </DialogHeader>
      <div class="flex flex-col gap-2">
            <Input type="string" placeholder="Code"  v-model="data.code" required/>
            <Input type="string" placeholder="Name"  v-model="data.name" required/>
            <Textarea type="string" placeholder="Description"  v-model="data.description" required/>
            <Input type="number" placeholder="Cost" v-model="data.unitCost" required @keyup="keyUp()"/>
            <Popover>
              <PopoverTrigger>
                <Button variant="outline" role="combobox" class="w-full justify-between">{{ selectedUnitType || 'Select type...' }} <ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" /></Button>
              </PopoverTrigger>
              <PopoverContent class="w-full p-0">
                <Command>
                  <CommandInput class="border-0" placeholder="Search type..." />
                  <CommandEmpty>No type found.</CommandEmpty>
                  <CommandList>
                    <CommandItem v-for="unitType in unitTypes" :key="unitType.value" :value="unitType.value" @click="unitTypeChange(unitType)">
                      {{ unitType.label }}
                    </CommandItem>
                  </CommandList>
                </Command>
              </PopoverContent>
            </Popover>
      </div>
      <DialogFooter>
      <Button v-if="!data.id" @click="addLabour" type="submit">Save</Button>
      <Button v-if="data.id" @click="editLabour" type="submit">Edit</Button>
    </DialogFooter>
    </DialogContent>
  </Dialog>

</template>
<script>
export default{
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
    data(){
        return {
            calculatedPrice: 0,
            isLoading: false,
            isDialogOpen: false,
            selectPlaceholder: "Select type...",
            unitTypes: [
              {value: "hour", label:"hour"},
              {value : "day", label: "day"}
            ]
        }
    },
    methods: {
      openDialog,
      closeDialog,
      keyUp,
      addLabour,
      editLabour
    }
}

function unitTypeChange(unitType){
  this.selectedUnitType = unitType.label;
  this.data.unitType = unitType.value;
}

function keyUp(){
  this.calculatedPrice = this.unitCost;
}

function closeDialog(){
  this.isDialogOpen = false;
}

function openDialog(){
  this.isDialogOpen = true;
}

async function addLabour(){
  const api = useApi();
  const response = await api.post('/api/labour/addLabour', this.data);
  console.log(response);
  this.$emit('success');
}

async function editLabour(){
  const api = useApi();
  const response = await api.put('/api/labour/updateLabour', this.data);
  console.log(response);
  this.$emit('success');
}

</script>