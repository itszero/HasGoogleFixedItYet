<script>
  import Word from './Word.svelte'
  export let words
</script>

<div>
  <p>
    本站會定期更新以下詞彙由 Google 翻譯從英文到台灣中文 (en -&gt; zh-TW)
    的結果。
  </p>
  {#if words}
    <div class="data">
      {#each words as word}
        <Word {word} />
      {/each}
    </div>
  {:else}
    載入中...
  {/if}
</div>

<style>
  .data {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-gap: 10px;
  }

  @media (max-width: 600px) {
    .data {
      grid-template-columns: auto;
    }
  }
</style>
