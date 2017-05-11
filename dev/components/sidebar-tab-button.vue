<template>
<button class="sidebar-tab-button" :class="type" :title="tooltip" @click="click">
  <i class="fa fa-2x" :class="icon"></i>
</button>
</template>

<script>
export default {
  name: 'sidebar-tab-button',
  props: ['icon', 'tooltip', 'type'],
  methods: {
    click: function() {
      this.$emit('click');
    }
  }
}
</script>

<style lang="sass">
@import '../sass/settings';

.sidebar-tab-button {
  background-color: transparent;
  border-width: 0;
  color: $dark-gray;
  padding-right: $sidebar-tab-button-right-padding;
  cursor: pointer;
  height: calc(#{$sidebar-width} - #{$sidebar-content-width} - #{$sidebar-highlight-border-width});
  width: calc(#{$sidebar-width} - #{$sidebar-content-width} - #{$sidebar-highlight-border-width});

  &.close {
    border-bottom: 2px solid $light-gray;
    height: $sidebar-header-height;
  }
}
</style>
