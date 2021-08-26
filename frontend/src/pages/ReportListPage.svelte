<script>
  import { onMount, createEventDispatcher } from 'svelte'

  let data = undefined
  let copied = false

  onMount(async () => {
    const resp = await fetch('/i/data')
    const json = await resp.json()
    data = json
  })

  function getGoogleTranslateLink(englishWord) {
    return `https://translate.google.com/?sl=en&tl=zh-TW&hl=zh-TW&text=${englishWord}`
  }

  const dispatch = createEventDispatcher()

  function didClickGoBack() {
    dispatch('pageChange', '/')
  }

  function didClickCopyAll(e) {
    const words = data.map(
      (word) =>
        `${word['english_word']} ${
          word['correct_zhtw_word']
        } 》 ${getGoogleTranslateLink(word['english_word'])}`,
    )

    const toCopy =
      words.join('\n') + '\n\n 》最新清單可在 https://isgooglefixed.tw 找到'

    navigator.clipboard.writeText(toCopy)
    copied = true
    setTimeout(() => {
      copied = false
    }, 2000)

    e.preventDefault()
    e.stopPropagation()
  }
</script>

<!-- svelte-ignore a11y-invalid-attribute -->
<a href="#" on:click={didClickGoBack}>👈 回首頁</a>

<h2>我可以怎麼幫忙？</h2>
<div>
  <p>
    請點開下面每個字的連結。這會打開 Google Translate
    翻譯這個詞的頁面，接著點選翻譯結果的「編輯」按鈕，送出正確的翻譯。
    <br />
    <img
      src="/assets/edit.png"
      alt="點選翻譯結果的「編輯」按鈕，然後送出正確的翻譯"
    />
  </p>
</div>

<h2>單詞列表</h2>
<div>
  {#if data}
    <div class="copy-action">
      {#if copied}
        ✅ 已經複製到剪貼簿囉！
      {:else}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a href="#" on:click={didClickCopyAll}>🔗 複製所有連結</a>
      {/if}
    </div>
    <p>註：下表僅列出目前翻譯仍然錯誤的字詞。</p>
    <div class="data">
      {#each data as word}
        {#if !word.is_fixed}
          <div class="word">
            {word['english_word']}
            <a
              href={getGoogleTranslateLink(word['english_word'])}
              target="_blank">✏️ 開始編輯</a
            ><br />
            ❌ {word['zhtw_word']} ✅ {word['correct_zhtw_word']}
          </div>
        {/if}
      {/each}
    </div>
  {:else}
    載入中...
  {/if}
</div>

<style>
  img {
    width: 50%;
    margin: 10px;
    padding: 10px;
    border: 1px solid #ccc;
  }

  .data {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-gap: 10px;
  }

  .word {
    line-height: 1.5;
  }

  .copy-action {
    margin: 10px 0;
  }
</style>
