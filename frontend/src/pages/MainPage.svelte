<script>
  import Words from '../Words.svelte'
  import { onMount, createEventDispatcher } from 'svelte'

  let data = undefined

  $: fixedCount = (data || []).filter((word) => word.is_fixed).length
  $: totalCount = (data || []).length

  onMount(async () => {
    const resp = await fetch('/i/data')
    const json = await resp.json()
    data = json
  })

  const dispatch = createEventDispatcher()

  function handleReportListClick(e) {
    dispatch('pageChange', 'reportList')
    e.preventDefault()
    e.stopPropagation()
    return false
  }

  let fixedPercentage
  $: fixedPercentage = fixedCount / totalCount
</script>

<div class="answer">
  {#if data}
    {#if fixedPercentage < 0.5}
      還沒。😥 <span class="answer_note">({fixedCount} / {totalCount})</span>
    {:else if fixedPercentage < 1.0}
      修了很多！ 😄 <span class="answer_note">({fixedCount} / {totalCount})</span>
    {:else}
      全部修好了！ 🥰
    {/if}
  {/if}
</div>

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
    Chinese (as used in Taiwan) for a while now. A lot of times the translation
    would sound like how Chinese is used in China instead. Google even claims
    some of those translations are "verified by community". However, a quick
    check through Google Trends would show that these translations would indeed
    rank pretty low among Taiwanese websites. Therefore, I made this websites to
    track some examples and hopefully nudge Google into fixing the translation
    for Traditional Chinese (Taiwan).
  </p>
  <p>
    NOTE: The Google Translate menu only says "Chinese (Traditional)". However,
    if you pick the option, you will see the language code reflected in the URL
    is <code>zh-TW</code>, which means "Traditional Chinese as being used in
    Taiwan". The alternative option for Google to fix this problem is to
    officially drop <code>zh-TW</code> support and switch to an appropriate
    language code instead, such as <code>zh-Hant</code>.
  </p>
</div>

<h2>我可以怎麼幫忙？</h2>
<div>
  <p>
    <!-- svelte-ignore a11y-invalid-attribute -->
    如果您有時間，請幫我們向 Google 翻譯回報翻譯問題。<a
      href="#"
      on:click={handleReportListClick}>🙏 點這裡</a
    >了解詳情！
  </p>
</div>

<h2>單詞詳情</h2>
<Words words={data} />

<style>
  .language-pill {
    padding: 5px 10px;
    background-color: #1a67d2;
    color: #fff;
    border-radius: 20px;
    display: inline-block;
    font-size: 12px;
  }

  .answer {
    padding: 20px 0;
    font-size: 4em;
    font-weight: 900;
  }

  .answer_note {
    font-size: 0.5em;
  }

  @media (max-width: 600px) {
    .answer_note {
      display: block;
    }
  }
</style>
