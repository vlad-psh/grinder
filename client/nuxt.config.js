export default {
  // Global page headers (https://go.nuxtjs.dev/config-head)
  head: {
    title: null,
    titleTemplate(title) {
      return title ? `${title} - jisho` : 'jisho'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  // Global CSS (https://go.nuxtjs.dev/config-css)
  css: ['~/assets/main.scss'],

  // Plugins to run before rendering page (https://go.nuxtjs.dev/config-plugins)
  plugins: [
    '@/plugins/axios.client.js', // Order matters (should be before auth)
    '@/plugins/auth.js',
    '@/plugins/search.js',
    '@/plugins/activity.client.js',
    '@/plugins/vue-shortkey.client.js',
  ],

  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,

  // Modules for dev and build (recommended) (https://go.nuxtjs.dev/config-modules)
  buildModules: [
    '@nuxtjs/eslint-module', // https://go.nuxtjs.dev/eslint
    '@nuxtjs/color-mode', // ~3 kB
    '@nuxtjs/svg', // ~10 kB
  ],

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: [
    '@nuxtjs/axios', // https://go.nuxtjs.dev/axios
  ],

  // Axios module configuration (https://go.nuxtjs.dev/config-axios)
  axios: {},

  // Build Configuration (https://go.nuxtjs.dev/config-build)
  build: {},

  colorMode: {
    preference: 'light', // disable system
  },

  router: {
    extendRoutes(routes, resolve) {
      routes.push(
        {
          name: 'index',
          path: '/',
          component: 'pages/search.vue',
          children: [
            {
              name: 'sub-search',
              path: '/search/:query/:seq?',
              component: 'pages/search.vue',
            },
            {
              name: 'jiten',
              path: '/jiten/:mode/:query',
              component: 'pages/search.vue',
            },
          ],
        },
        {
          name: 'sub-quiz',
          path: '/quiz/:drill_id/:type',
          component: 'pages/quiz.vue',
        }
      )
    },
    middleware: ['activity_group'],
  },

  // Customizing progress bar
  loading: {
    color: '#008ace',
  },
}
