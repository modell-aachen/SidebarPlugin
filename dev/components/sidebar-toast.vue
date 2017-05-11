<template>
<div class="sidebar-toast" :class="toastColor" :style="dimension">
  <p><i class="fa" :class="icon"></i>&nbsp;{{text}}</p>
</div>
</template>

<script>
export default {
  name: 'sidebar-toast',
  props: ['color', 'icon', 'position', 'size', 'text',],
  computed: {
    dimension: function() {
      var self = this;
      var dim = {};

      if (this.size) {
        ['height', 'width'].forEach((prop) => {
          if (self.size[prop]) {
            dim[prop] = self.size[prop];
          }
        });
      }

      if (this.position) {
        ['top', 'right', 'bottom', 'left'].forEach((prop) => {
          if (self.position[prop]) {
            dim[prop] = self.position[prop];
          }
        });
      }

      console.log(dim);
      return dim;
    },
    toastColor: function() {
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
    }
  }
}
</script>

<style lang="sass">
@import '../sass/settings';

@mixin bg-opacity($color, $opacity: $sidebar-toast-opacity) {
  background: $color;
  background: rgba($color, $opacity);
}

.sidebar-toast {
  position: absolute;
  top: 0;
  left: calc(#{$sidebar-width} - #{$sidebar-content-width});
  right: 0;
  height: calc(#{$sidebar-header-height} - 2px);
  z-index: 1 + $sidebar-z-index;

  p {
    color: $white;
    font-size: 16px;
    text-align: center;
  }

  &.primary {
    @include bg-opacity($primary-color);
  }

  &.secondary {
    @include bg-opacity($secondary-color);
  }

  &.success {
    @include bg-opacity($success-color);
  }

  &.alert {
    @include bg-opacity($alert-color);
  }

  &.warning {
    @include bg-opacity($warning-color);
  }
}
</style>
