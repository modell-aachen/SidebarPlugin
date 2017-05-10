<template>
<div :class="name">
  <div :class="name + '-left'">
    <template v-for="item in data.left">
      <sidebar-label v-if="item.type == 'label'"
        :color="item.color"
        :text="item.text" />
      <sidebar-button v-if="item.type == 'button'"
        :color="item.color"
        :icon="item.icon"
        :text="item.text"
        @click="item.callback" />
        <sidebar-dropdown v-if="item.type == 'dropdown'"
        :color="item.color"
        :text="item.text"
        @click="item.callback" />
    </template>
  </div>
  <div :class="name + '-right'">
    <template v-for="item in data.right">
      <sidebar-label v-if="item.type == 'label'"
        :color="item.color"
        :text="item.text" />
      <sidebar-button v-if="item.type == 'button'"
        :color="item.color"
        :icon="item.icon"
        :text="item.text"
        @click="item.callback" />
      <sidebar-dropdown v-if="item.type == 'dropdown'"
        :color="item.color"
        :text="item.text"
        @click="item.callback" />
    </template>
  </div>
</div>
</template>

<script>
export default {
  name: 'sidebar-marginal',
  props: ['name', 'data'],
  methods: {
    click: function() {
      this.$emit('click');
    }
  }
}
</script>

<style lang="sass">
@import '../sass/settings';

.tab-contents {
  > .header,
  > .footer {
    padding: $sidebar-content-padding;
  }

  > .header,
  > .footer {
    display: flex;
    flex-wrap: nowrap;
    justify-content: space-between;
    align-items: center;

    max-height: $sidebar-header-height;
    min-height: $sidebar-header-height;
    width: 100%;
  }

  > .header {
    border-bottom: 2px solid $light-gray;
  }

  > .footer {
    position: absolute;
    bottom: 0;
    border-top: 2px solid $light-gray;
  }

  .header-left,
  .header-right,
  .footer-left,
  .footer-right {
    display: flex;
    flex-wrap: nowrap;

    > * {
      margin-bottom: 0;
      &:not(:last-child) {
        margin-right: 4px;
      }
    }
  }

  .header-right,
  .footer-right {
    align-items: flex-end;
  }
}
</style>
