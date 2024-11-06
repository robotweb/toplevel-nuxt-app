<template>
  <Dialog v-bind:open="isDialogOpen">
    <DialogTrigger >
    </DialogTrigger>
    <DialogContent >
      <form @submit.prevent="submitForm">
      <div class="flex flex-col gap-2 p-4">
            <Input id="customer-name" v-model="data.name" required placeholder="Customer Name"/>
            <Textarea id="customer-address" v-model="data.billingAddress" required placeholder="Customer Address" />
            <Input id="customer-markup" v-model="data.clientMarkup" required placeholder="Markup (%)" />
            <Label class="text-sm font-medium w-full flex justify-end py-2">Markup (%)</Label>
      </div>
      <div class="flex items-center justify-end">
        <Button type="submit" @click="addCustomer" v-if="!data.id">Save</Button>
        <Button type="submit" @click="editCustomer" v-if="data.id">Edit</Button>
      </div>
  </form>
    </DialogContent>
  </Dialog>
</template>
<script>
export default {
  props: {
    isDialogOpen: {
      type: Boolean,
      required: true
    },
    data: {
      type: Object,
      required: false
    }
  },
  data() {
    return {
      contacts: [],
    };
  },
  methods: {
   addCustomer,
   editCustomer
  },
};



async function addCustomer() {
  const api = useApi();
  let payload = {
    name: this.data.name,
    billingAddress: this.data.billingAddress,
    clientMarkup: this.data.clientMarkup
  }
  const response = await api.post('/api/customer/addCustomer', payload);
  console.log(response);
  this.$emit('success');
}

async function editCustomer() {
  const api = useApi();
  let payload = {
    id: this.data.id,
    name: this.data.name,
    billingAddress: this.data.billingAddress,
    clientMarkup: this.data.clientMarkup
  }
  const response = await api.put('/api/customer/updateCustomer', payload);
  console.log(response);
  this.$emit('success');
}
</script>