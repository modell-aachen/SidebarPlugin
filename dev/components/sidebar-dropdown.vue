<template>
<button class="button tiny" :class="color" @click="click">
  <span v-if="text">{{text}}&nbsp;</span>
  <i class="fa fa-chevron-down"></i>
</button>
</template>

<script>
export default {
  name: 'sidebar-dropdown',
  props: ['color', 'text'],
  methods: {
    click: function() {
      this.$emit('click');
    }
  }
}
</script>
