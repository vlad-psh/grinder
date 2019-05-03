//import Vue from 'vue/dist/vue.js';

import helpers from './helpers.js';

Vue.component('radical', {
  props: {
    radical: {type: Object, required: true}
  },
  methods: {
    ...helpers
  },
  template: `
<div class="vue-radical">
  <span class="radical-title" :class="radical.progress.html_class">{{radical.title}}</span>
  <span>{{radical.meaning}}</span>
  <div class="radical-meaning">
    <span style="font-weight: bold">Meaning: </span>
    <span v-html="stripBB(radical.nmne)"></span>
  </div>
  <div v-if="radical.progress.details" class="radical-meaning">
    <span style="font-weight: bold">Comment: </span>
    <span v-if="radical.progress.details.t">【{{radical.progress.details.t}}】</span>
    <span v-if="radical.progress.details.m" v-html="stripBB(radical.progress.details.m)"></span>
  </div>
</div>
`
});
