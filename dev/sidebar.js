import sidebar from './components/sidebar.vue';
import sidebar_button from './components/sidebar-button.vue';
import sidebar_dropdown from './components/sidebar-dropdown.vue';
import sidebar_label from './components/sidebar-label.vue';
import sidebar_marginal from './components/sidebar-marginal.vue';
import sidebar_modal from './components/sidebar-modal.vue';
import sidebar_tab_button from './components/sidebar-tab-button.vue';
import sidebar_toast from './components/sidebar-toast.vue';

(function ($, document, window, undefined) {
  $(document).ready(function() {
    Vue.component(sidebar.name, sidebar);
    Vue.component(sidebar_button.name, sidebar_button);
    Vue.component(sidebar_dropdown.name, sidebar_dropdown);
    Vue.component(sidebar_label.name, sidebar_label);
    Vue.component(sidebar_marginal.name, sidebar_marginal);
    Vue.component(sidebar_modal.name, sidebar_modal);
    Vue.component(sidebar_tab_button.name, sidebar_tab_button);
    Vue.component(sidebar_toast.name, sidebar_toast);

    var sb = document.createElement(sidebar.name);
    document.body.appendChild(sb);
    new Vue({el: sb});
  });
}(jQuery, document, window, undefined));
