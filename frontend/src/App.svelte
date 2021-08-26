<script>
  import Header from './Header.svelte'
  import MainPage from './pages/MainPage.svelte'
  import ReportListPage from './pages/ReportListPage.svelte'
  import { onMount } from 'svelte'

  let currentPage = 'main'

  function didPageChanged(e) {
    history.pushState(null, null, e.detail)
    updateCurrentPage()
  }

  function updateCurrentPage() {
    currentPage = location.pathname.substr(1) || 'main'
  }

  function didPopState() {
    updateCurrentPage()
  }

  onMount(() => {
    updateCurrentPage()
    window.addEventListener('popstate', didPopState)
  })
</script>

<div class="root">
  <Header />

  {#if currentPage === 'main'}
    <MainPage on:pageChange={didPageChanged} />
  {:else if currentPage === 'reportList'}
    <ReportListPage on:pageChange={didPageChanged} />
  {:else}
    <h1>404 Not Found</h1>
  {/if}

  <footer>
    這個網站由 <a
      href="https://twitter.com/itszero"
      target="_blank"
      rel="noopener">傑洛</a
    >
    製作 | 可以在 Github 找到<a
      href="https://github.com/itszero/hasgooglefixedityet"
      target="_blank"
      rel="noopener">原始碼</a
    > | 2021-
  </footer>
</div>

<style>
  @font-face {
    font-family: 'jf-openhuninn';
    src: url(https://cdn.isgooglefixed.tw/jf-openhuninn.woff2) format('woff2');
    font-display: swap;
  }

  :global(*) {
    box-sizing: border-box;
  }

  :global(body) {
    font-family: 'jf-openhuninn', -apple-system, BlinkMacSystemFont, 'Segoe UI',
      Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue',
      sans-serif;
  }

  .root {
    width: 100%;
    max-width: 960px;
    margin: 0 auto;
    padding: 20px;
    line-height: 1.3;
  }

  :global(h2) {
    font-weight: 900;
    border-bottom: 1px solid #aaa;
  }

  footer {
    margin-top: 20px;
    text-align: center;
    color: #aaa;
    font-size: 10pt;
  }

  :global(a),
  :global(a):visited {
    color: #1a67d2;
    text-decoration: none;
  }

  footer :global(a),
  footer :global(a):visited {
    color: #1a67d2;
  }

  :global(code) {
    color: red;
    margin-left: 5px;
    margin-right: 5px;
  }
</style>
