<template>
    <div>
        <button>{{ label }}</button>
    </div>
</template>
<script>
export default{
    props :{
        label: String
    }
}
</script>
<style lang="scss">
button {
  position: relative;
  padding: 10px 20px;
  height: $element-height;
  background: $primary;
  border: 0px;
  min-width: 100px;
  border-radius: 5px;
  color: #fff;
  font-family: inherit;
  margin-right: 10px;
  margin-bottom: 10px;
  font-size: 16px;
  cursor: pointer;
  outline: 2px solid transparent;
}
</style>