<script>
  import Header from './Header.svelte'
  import Words from './Words.svelte'
  import { onMount } from 'svelte'

  let data = undefined

  onMount(async () => {
    const resp = await fetch('/i/data')
    const json = await resp.json()
    data = json
  })
</script>

<div class="root">
  <Header words={data} />

  <h2>為什麼要製作這個網站？</h2>
  <div>
    <div class="language-pill">台灣中文 zh-TW</div>
    <p>
      Google 翻譯已經好一陣子將台灣（語言代碼為 <code>zh-TW</code
      >）的翻譯改成各種中國常見的用法。Google
      甚至聲稱部分翻譯是經過「社群認證」。但是，如果你將這些詞彙丟入「Google
      趨勢」就會發現，這些詞彙並不常在台灣被使用。因此，我希望 Google
      能夠修改台灣中文的翻譯使其合乎現狀。
    </p>
    <p>
      注：雖然選單上只有說「中文（繁體）」，如果你選擇該選項後，你會發現該選項是使用<code
        >zh-TW</code
      >的代碼，意指「台灣中文」。Google
      若不想持續支援台灣中文的翻譯也可正式宣佈不再繼續支援台灣中文並將語言代碼換成適當的選項，例如：<code
        >zh-Hant</code
      >。
    </p>
    <div class="language-pill">美式英文 en-US</div>
    <p>
      Google Translate has not been accurately translating into Traditional
      Chinese (as used in Taiwan) for a while now. A lot of times the
      translation would sound like how Chinese is used in China instead. Google
      even claims some of those translations are "verified by community".
      However, a quick check through Google Trends would show that these
      translations would indeed rank pretty low among Taiwanese websites.
      Therefore, I made this websites to track some examples and hopefully nudge
      Google into fixing the translation for Traditional Chinese (Taiwan).
    </p>
    <p>
      NOTE: The Google Translate menu only says "Chinese (Traditional)".
      However, if you pick the option, you will see the language code reflected
      in the URL is <code>zh-TW</code>, which means "Traditional Chinese as
      being used in Taiwan". The alternative option for Google to fix this
      problem is to officially drop <code>zh-TW</code> support and switch to an
      appropriate language code instead, such as <code>zh-Hant</code>.
    </p>
  </div>

  <h2>單詞詳情</h2>
  <Words words={data} />

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

  h2 {
    font-weight: 900;
    border-bottom: 1px solid #aaa;
  }

  footer {
    margin-top: 20px;
    text-align: center;
    color: #aaa;
    font-size: 10pt;
  }

  a,
  a:visited {
    color: blue;
  }

  footer a,
  footer a:visited {
    color: #88f;
  }

  code {
    color: red;
    margin-left: 5px;
    margin-right: 5px;
  }

  .language-pill {
    padding: 5px 10px;
    background-color: #1a67d2;
    color: #fff;
    border-radius: 20px;
    display: inline-block;
    font-size: 12px;
  }
</style>
