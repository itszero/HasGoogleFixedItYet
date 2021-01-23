/** @type {import("snowpack").SnowpackUserConfig } */

const httpProxy = require('http-proxy');
const proxy = httpProxy.createServer({
  target: process.env.BACKEND_URL,
  secure: false,
  changeOrigin: true
});
proxy.on('error', (err) => { console.log('proxy error occured: ', err) })

module.exports = {
  mount: {
    public: { url: '/', static: true },
    src: { url: '/dist' },
  },
  plugins: [
    '@snowpack/plugin-svelte',
    '@snowpack/plugin-dotenv',
  ],
  optimize: {
    'bundle': true,
    'minify': true,
    'target': 'es2018'
  },
  routes: [
    {
      src: '/i/.*', dest: (req, res) => proxy.web(req, res)
    },
  ]
};
