<script>
  export let words

  $: fixedCount = (words || []).filter((word) => word.is_fixed).length
  $: totalCount = (words || []).length
</script>

<div class="header_bg" />

<div class="header">
  <table class="hero">
    <tr class="title_row_zhtw">
      <td align="right">台灣中文<br />zh-TW</td>
      <td class="title_zhtw">Google 翻譯修好了沒？</td>
    </tr>
    <tr>
      <td align="right">英文<br />en</td>
      <td class="title_en">Has Google Translate been fixed yet?</td>
    </tr>
  </table>

  <div class="icon_to">↓</div>

  <div class="answer">
    {#if words}
      {#if fixedCount < totalCount}
        還沒。😥 <span class="answer_note">({fixedCount} / {totalCount})</span>
      {:else}
        全部修好了！🎉🎉🎉
      {/if}
    {/if}
  </div>
</div>

<style>
  .header {
    position: relative;
  }

  .header_bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 110px;
    background-color: #1a67d2;
  }

  .title_row_zhtw {
    background-color: #1a67d2;
    color: white;
    position: relative;
  }

  .title_zhtw {
    font-size: 24pt;
  }

  .title_en {
    font-size: 15pt;
  }

  .answer {
    padding: 20px 0;
    font-size: 4em;
    font-weight: 900;
  }

  .answer_note {
    font-size: 0.5em;
  }

  table {
    border-collapse: collapse;
    width: 100%;
  }

  table td {
    padding: 20px;
  }

  .icon_to {
    border: 3px solid #1a67d2;
    background-color: white;
    border-radius: 99999px;
    width: 35px;
    height: 35px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 900;
    position: absolute;
    top: 63px;
    left: 140px;
    color: #1a67d2;
  }

  @media (max-width: 600px) {
    .header_bg {
      height: 132px;
    }

    .hero {
      border: 1px solid #000;
      box-shadow: 0 10px 10px #555;
      margin-bottom: 10px;
    }

    .icon_to {
      display: none;
    }

    .hero td:first-of-type {
      width: 100px;
    }

    .title_zhtw {
      font-size: 18pt;
    }

    .title_en {
      font-size: 12pt;
    }

    .answer_note {
      display: block;
    }
  }
</style>
