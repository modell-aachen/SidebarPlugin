<template>
<span class="label" :class="labelColor" :style="display">{{text}}</span>
</template>

<script>
export default {
  name: 'sidebar-label',
  props: ['text', 'color'],
  computed: {
    labelColor: function() {
      var o = {
        primary: this.color === 'primary',
        secondary: this.color === 'secondary',
        success: this.color === 'success',
        alert: this.color === 'alert',
        warning: this.color === 'warning'
      };

      // default to 'secondary' style
      if (!o.secondary) {
        o.secondary = !o.primary && !o.success && !o.alert && !o.warning;
      }

      return o;
    },
    display: function() {
      return {
        display: !this.text || /^\s*$/.test(this.text) ? 'none' : 'inline-block'
      };
    }
  }
}
</script>
