<template>
<div class="flatskin-wrapped sidebar-container" :class="{active: isActive}">

  <div class="tab-controls" :class="{highlight: isHighlighted}">
    <sidebar-tab-button icon="fa-times" type="close" @click="hide" />
    <div class="controls">
      <template v-for="tab in tabs">
        <sidebar-tab-button :icon="tab.icon" :title="tab.tooltip" @click="tab.callback" />
      </template>
    </div>
  </div>

  <div class="tab-contents">
    <sidebar-marginal name="header" :data="header" v-if="header" />
    <div class="content" v-html="content"></div>
    <sidebar-marginal name="footer" :data="footer" v-if="footer" />
  </div>

  <transition name="fade">
    <sidebar-toast v-if="toast"
      :icon="toast.icon"
      :text="toast.text"
      :color="toast.color"
      :size="toast.size"
      :position="toast.position">
    </sidebar-toast>
  </transition>
</div>
</template>

<script>
var initialize = function(config) {
  config = Object.assign({}, config);
  if (!Object.keys(config).length) {
    throw 'Invalid configuration object!';
  }

  var tabs = [];
  if (config.tabs && Array.isArray(config.tabs)) {
    config.tabs.forEach(function(tab) {
      if (!tab.icon) {
        throw "Invalid tab configuration. Parameter 'icon' is mandatory!";
      }

      tabs.push({icon: tab.icon, tooltip: tab.tooltip, callback: tab.callback});
    });
  }

  initializeMarginals.call(this, config);
  this.tabs = tabs;
  this.isInitalized = true;
};

var hideSidebar = function() {
  this.isActive = this.isHighlighted = false;
  this.content = this.toast = undefined;

  // reset 'this.header' and 'this.footer' if they were set by 'showContent'
  if (!this.isInitalized) {
    this.footer = undefined;
    this.header = undefined;
  }
}

var showSidebar = function(config) {
  if (!this.isInitalized) {
    if (window.console && console.debug) {
      console.debug("You have to call 'sidebar.initialize' first!");
      return;
    }
  }

  var content = extractContent.call(this, config);
  if (content === false) {
    throw "Invalid content element. Needs to be one of: jQuery element, DOM element or plain (HTML) string";
  }

  this.isHighlighted = !!config.highlight;
  this.content = content;
  this.isActive = true;
};

var showContent = function(config) {
  var o = Object.assign({}, config);
  if (!o.content) {
    throw 'Missing content attribute!';
  }

  var content = extractContent.call(this, o);
  if (content === false) {
    throw "Invalid content element. Needs to be one of: jQuery element, DOM element or plain (HTML) string";
  }

  initializeMarginals.call(this, o);
  this.content = content;
  this.isHighlighted = !!o.highlight;
  this.isActive = true;
};

var extractContent = function(config) {
  if (config.content.jquery == jQuery.fn.jquery) {
    return config.content.toArray().map(function(item) {
      return item.outerHTML;
    }).join("\n");
  } else if (config.content instanceof HTMLElement) {
    return config.content.outerHTML;
  } else if (typeof config.content === 'function') {
    return config.content.call(this, config);
  } else if (typeof config.content === 'string') {
    return config.content;
  }

  return false;
};

var initializeMarginals = function(config) {
  var self = this;
  var tmp = {header: {}, footer: {}}
  Object.keys(tmp).forEach(key => {
    if (config[key]) {
      if (config[key].left && Array.isArray(config[key].left) && config[key].left.length) {
        tmp[key].left = config[key].left;
      }

      if (config[key].right && Array.isArray(config[key].right) && config[key].right.length) {
        tmp[key].right = config[key].right;
      }
    }

    if (Object.keys(tmp[key]).length) {
      self[key] = tmp[key];
    }
  });
};

var isOpened = function() {
  return this.isActive;
};

var makeToast = function(opts) {
  if (!this.isActive) return;
  opts = Object.assign({}, opts);
  if (!opts.text) return;

  this.toast = {
    icon: opts.icon || '',
    text: opts.text,
    color: opts.color,
    size: opts.size,
    position: opts.position
  };

  if (typeof opts.closetime !== 'number' || opts.closetime <= 0) {
    opts.closetime = 5000;
  }

  var self = this;
  setTimeout(() => (self.toast = undefined), opts.closetime);
};

export default {
  name: 'qwiki-sidebar',
  methods: {
    show: showSidebar,
    showContent: showContent,
    hide: hideSidebar,
    makeToast: makeToast,
    isOpened: isOpened,
    initialize: initialize
  },
  data: function() {
    return {
      isActive: false,
      isHighlighted: false,
      isInitalized: false,
      tabs: [],
      content: undefined,
      toast: undefined,
      header: undefined,
      footer: undefined
    };
  },
  created: function() {
    window.sidebar = Object.assign({}, window.sidebar, {
      $vm: this,
      show: this.show,
      showContent: this.showContent,
      hide: this.hide,
      initialize: this.initialize,
      isOpened: this.isOpened,
      makeToast: this.makeToast
    });
  }
}
</script>

<style lang="sass">
@import '../sass/settings';

.fade-enter-active,
.fade-leave-active {
  transition: opacity .5s
}
.fade-enter,
.fade-leave-to {
  opacity: 0
}

.sidebar-container {
  position: fixed;
  top: 0;
  bottom: 0;
  right: 0;
  width: $sidebar-width;
  z-index: $sidebar-z-index;

  transform: translate3d(100%, 0, 0);
  transition: transform .3s ease-in-out;

  &.active {
    transform: translate3d(0, 0, 0);
  }
}

.tab-controls {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;

  background-color: $gray;
  border-left: $sidebar-highlight-border-width solid $gray;
  width: calc(#{$sidebar-width} - #{$sidebar-content-width});

  &.highlight {
    border-left-color: $sidebar-highlight-border-color;
  }
}

.tab-contents {
  position: absolute;
  top: 0;
  bottom: 0;
  left: calc(#{$sidebar-width} - #{$sidebar-content-width});
  background-color: $white;
  width: $sidebar-content-width;

  > .content {
    padding: $sidebar-content-padding;
  }
}
</style>
