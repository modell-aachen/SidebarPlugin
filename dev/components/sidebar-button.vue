<template>
<button class="button tiny" :class="color" @click="click">
  <span v-if="icon"><i class="fa" :class="icon"></i></span>
  <span v-if="icon && text">&nbsp;</span>
  <span v-if="text">{{text}}</span>
</button>
</template>

<script>
export default {
  name: 'sidebar-button',
  props: ['color', 'icon', 'text'],
  methods: {
    click: function() {
      this.$emit('click');
    }
  }
}
</script>
