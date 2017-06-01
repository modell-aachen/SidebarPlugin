<template>
    <div>
        <div v-show="isActive" class="overlay" @click="hide" />
        <div class="flatskin-wrapped sidebar-container" :class="{active: isActive}" v-on:click.stop>

            <div class="tab-controls" :class="{highlight: isHighlighted}">
                <sidebar-tab-button icon="fa-times" type="close" @click="hide" />
                    <div class="controls">
                        <template v-for="tab in tabs">
                            <sidebar-tab-button ref="sidebar-tab-buttons" :icon="tab.icon" :title="tab.tooltip" @click="tab.callback" />
                        </template>
                    </div>
            </div>

            <div class="tab-contents">
                <sidebar-marginal name="header" :data="header" v-if="header" />
                    <div class="content" v-if="contentComponent"><component v-bind:is="contentComponent.name" :propsData="contentComponent.propsData"></component></div>
                    <div class="content" v-else v-html="content"></div>
                    <sidebar-marginal name="footer" :data="footer" v-if="footer" />
            </div>

            <transition name="fade">
            <sidebar-toast v-if="toast" :config="toast" />
            </transition>

            <transition name="fade">
            <sidebar-modal v-if="modal"
                           :config="modal"
                           @modal-canceled="hideModal"
                           @modal-confirmed="hideModal" />
            </transition>
        </div>
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
  this.content = this.contentComponent = this.toast = undefined;

  // reset 'this.header' and 'this.footer' if they were set by 'showContent'
  if (!this.isInitalized) {
    this.footer = undefined;
    this.header = undefined;
  }
}

// TBD.
// Maybe it makes more sense to implement a kind of tab.isDefault and switch
// back to that tab instead of assuming the first tab to be the default one.
var resetActiveTab = function() {
  if (Array.isArray(this.$refs['sidebar-tab-buttons'])) {
    var tabs = this.$refs['sidebar-tab-buttons'];
    if (tabs.length) {
      tabs.forEach((tab) => tab.unset());
      tabs[0].set();
    }
  }
};

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
  this.contentComponent = config.contentComponent;

  this.isActive = true;
  resetActiveTab.call(this);
};

var showContent = function(config) {
  var o = Object.assign({}, config);
  if (!o.content && !o.contentComponent) {
    throw 'Missing content attribute!';
  }

  if(!o.content){
    o.content = "";
  }

  var content = extractContent.call(this, o);
  if (content === false) {
    throw "Invalid content element. Needs to be one of: jQuery element, DOM element or plain (HTML) string";
  }

  initializeMarginals.call(this, o);
  this.content = content;
  this.contentComponent = config.contentComponent;
  this.isHighlighted = !!o.highlight;

  this.isActive = true;
  resetActiveTab.call(this);
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

var makeModal = function(opts) {
  if (!this.isActive) return;
  opts = Object.assign({}, opts);

  var content;
  if (opts.content) {
    content = extractContent.call(this, opts);
    if (content === false) {
      throw "Invalid content element. Needs to be one of: jQuery element, DOM element or plain (HTML) string";
    }
  }

  var modal = {
    color: opts.color,
    content: content,
    icon: opts.icon,
    title: opts.title,
    type: opts.type,
    buttons: opts.buttons
  };

  this.modal = modal;

  if (opts.autoclose === true) {
    if (typeof opts.closetime !== 'number' || opts.closetime <= 0) {
      opts.closetime = 5000;
    }

    var self = this;
    setTimeout(() => (self.modal = undefined), opts.closetime);
  }
};

var hideModal = function() {
  this.modal = undefined;
};

export default {
  name: 'qwiki-sidebar',
  methods: {
    show: showSidebar,
    showContent: showContent,
    hide: hideSidebar,
    hideModal: hideModal,
    makeModal: makeModal,
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
      contentComponent: undefined,
      modal: undefined,
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
      hideModal: this.hideModal,
      makeModal: this.makeModal,
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
.overlay {
    top: 0px;
    left: 0px;
    height: 100%;
    width: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    position: fixed;
    z-index: 5;
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

  *:focus {
    outline:none;
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
    height: calc(100% - 60px);
    overflow-y: auto;
    white-space: -moz-pre-wrap !important;
    white-space: -pre-wrap;
    white-space: -o-pre-wrap;
    white-space: pre-wrap;
    white-space: -webkit-pre-wrap;
    white-space: normal;

    .section-title {
      display: block;
      margin: $sidebar-content-padding-horizontal #{-$sidebar-content-padding-horizontal} $sidebar-content-padding-vertical;
      padding: 0 $sidebar-content-padding-horizontal;
      border-bottom: 2px solid $light-gray;

      color: $primary-color;
      font-size: 1.25rem;

      .sub {
        color: $black;
        font-size: .75rem;
      }

      &:first-child {
        margin-top: 0;
      }
    }
  }
}
</style>
