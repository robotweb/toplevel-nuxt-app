<template>
  <Dialog v-model:open="isDialogOpen">
      <Button @click="openDialog">Add Labour</Button>
    <DialogContent>
      <DialogHeader>
        <DialogTitle></DialogTitle>
        <DialogDescription>
        </DialogDescription>
      </DialogHeader>
      <form  v-show="!isLoading" @submit.prevent="submitForm">
      <div class="row w-full flex flex-row gap-4 my-4">
          <div class="w-1/2">
            <Input type="string" placeholder="Code"  v-model="code" required/>
          </div>
          <div class="w-1/2">
            <Input type="string" placeholder="Name"  v-model="name" required/>
          </div>
        </div>
        <div class="row my-4">
          <div class="w-full">
            <Textarea type="string" placeholder="Description"  v-model="description" required/>
          </div>
        </div>
        <div class="row w-full flex flex-row gap-4 my-4">
            <div class="w-1/2">
              <Input type="number" placeholder="Cost" v-model="unitCost" required @keyup="keyUp()"/>
            </div>
            <div class="w-1/2">
              <Combobox :options="unitTypes" :placeholder="selectPlaceholder" @change="unitTypeChange"></Combobox>
            </div>
          </div>
      <DialogFooter>
      <Button type="submit">Save</Button>
    </DialogFooter>
    </form>
  <div v-if="isLoading" class="h-[200px]">
    <LoaderRipple />
  </div>  
    </DialogContent>
  </Dialog>

</template>
<script>
import axios from 'axios'
import Combobox from '../Combobox.vue';
export default{
  setup() {
    const { triggerToast } = useToast()
    return { triggerToast }
  },
    data(){
        return {
            name: "",
            code: "",
            description: "",
            unitCost: null,
            unitType: "",
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
      openDialog(){
        this.isDialogOpen = true;
      },
      closeDialog(){
        this.isDialogOpen = false;
      },
        async submitForm(){
            this.isLoading = true;
            try {
        const token = localStorage.getItem('auth');
        //console.log(token);

        const response = await axios.post(`/api/products/addLabour`,{
          name: this.name,
          code: this.code,
          description: this.description,
          unitType: this.unitType,
          unitCost: this.unitCost
        },{
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json' // Set content type if sending JSON data
            }
          }
        )

        console.log(response);
        if(response.data.statusCode != 200){
          throw new Error(response.data.details)
        }

        //const result = await response.json();
        //console.log('Data submitted successfully:', response.data.message);
        this.triggerToast("success","Success",response.data.message)
        this.closeDialog();
        this.$emit('success');

      // Redirect to a protected route after login
    } catch (error) {
        //console.error('Error submitting data:', error);
        this.triggerToast("error","Error",error.message);
    }
    this.isLoading = false;
        },
        keyUp(){
            this.calculatedPrice = this.unitCost;
        },
    }
}
</script>
<style>
.labour-container{
    width: 500px;
    max-width: 100%;
    min-height: 300px;
    position: relative;
}
</style>