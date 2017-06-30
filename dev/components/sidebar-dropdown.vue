<template>
<div class="sidebar-dropdown">
  <button class="button tiny" type="button" :class="cls" :title="tooltip" :data-toggle="id" @click="click">
    <span v-if="text">{{text}}&nbsp;</span>
    <i class="fa fa-chevron-down"></i>
  </button>
  <div class="dropdown-pane" :id="id" :class="anchor" data-dropdown data-hover="true" data-hover-pane="true">
    <ul class="dropdown" v-if="entries">
      <template v-for="entry in entries">
        <li @click="entry.callback"><span>{{entry.text}}</span></li>
      </template>
    </ul>
  </div>
</div>
</template>

<script>

var makeGUID = function() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
    return v.toString(16);
  });
};

export default {
  name: 'sidebar-dropdown',
  props: ['anchor', 'color', 'direction', 'entries', 'text', 'tooltip'],
  computed: {
    cls: function() {
      var cls = {};
      cls[this.color || 'primary'] = true;
      cls['float-' + (this.direction || left)] = true;
      return cls;
    }
  },
  data: function() {
    var id = makeGUID();
    return {id: id};
  },
  mounted: function() {
    var $el = $(this.$el);
    $el.foundation();

    var $p = $el.prev();
    if ($p.is('.button')) {
      $p.css('border-top-right-radius', 0);
      $p.css('border-bottom-right-radius', 0);
    }
  },
  methods: {
    click: function() {
      this.show = !this.show;
      this.$emit('click');
    }
  }
}
</script>

<style lang="sass">
@import '../sass/settings';

.sidebar-dropdown {
  display: inline-block;

  > .button {
    margin-bottom: 0;
  }

  .dropdown-pane {
    border-radius: 4px;
    background-color: $white;
    border: 1px solid $dropdown-border-color;
    box-shadow: 1px 1px 5px $dropdown-border-color;
    padding: 0;
  }

  .dropdown {
    list-style: none;
    padding: .5rem 0;
    margin: 0;

    li {
      background-color: transparent;
      border-radius: 3px;
      cursor: pointer;
      font-size: .8rem;
      padding: .25rem .75rem;
      transition: background-color .2s ease-in;

      &:hover {
        background-color: $light-gray;
      }
    }
  }
}

.button + .sidebar-dropdown {
  margin-left: 1px !important;

  > .button {
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
  }
}
</style>
