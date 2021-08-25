<script>
  import { afterUpdate } from 'svelte'
  import { formatDistance, parseJSON as parseJSONDate } from 'date-fns'
  import { zhTW } from 'date-fns/locale'

  export let word
  let expanded = false
  let wordHistory

  function didClick(e) {
    expanded = !expanded
  }

  function didMousedown(e) {
    if (e.detail > 1) {
      e.preventDefault()
    }
  }

  afterUpdate(async () => {
    if (expanded && !wordHistory) {
      const resp = await fetch(`/i/word/${word.id}`)
      wordHistory = await resp.json()
    }
  })
</script>

<div
  class="root {expanded ? 'expanded' : ''}"
  on:click={didClick}
  on:mousedown={didMousedown}
>
  <div class="summary">
    <div class="main">
      {word.is_fixed ? '✅' : '🚫'}
      {word['english_word']} → {word['zhtw_word']}
      {#if !word.is_fixed}({word['correct_zhtw_word']}){/if}
    </div>
    <div class="expander {expanded ? 'expanded' : ''}">▼</div>
  </div>
  {#if expanded && wordHistory}
    <div class="history">
      <table>
        <thead>
          <tr>
            <th>Google 翻譯結果</th><th>第一次看到</th><th>最後一次看到</th>
          </tr>
        </thead>
        <tbody>
          {#each wordHistory as item}
            <tr>
              <td>
                {item['zhtw_word']}
              </td>
              <td>
                {formatDistance(
                  parseJSONDate(item['first_seen_at']),
                  new Date(),
                  {
                    addSuffix: true,
                    locale: zhTW,
                  },
                )}
              </td>
              <td>
                {formatDistance(
                  parseJSONDate(item['last_seen_at']),
                  new Date(),
                  {
                    addSuffix: true,
                    locale: zhTW,
                  },
                )}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  {:else if expanded}
    <div>載入中...</div>
  {/if}
</div>

<style>
  .root {
    display: flex;
    flex-direction: column;
    padding: 20px;
    border-radius: 20px;
    margin: 10px 0;
    cursor: pointer;
  }

  .root:hover,
  .root.expanded {
    padding: 19px;
    border: 1px solid #888;
    box-shadow: 0px 5px 5px #bbb;
  }

  .summary {
    display: flex;
  }

  .main {
    flex-grow: 1;
    flex-shrink: 1;
    margin-right: 10px;
  }

  .expander {
    flex-grow: 0;
    flex-shrink: 0;
    transition-duration: 0.3s;
    transition-property: transform;
    transform-origin: center center;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .expander.expanded {
    transform: rotate(180deg);
  }

  .history {
    margin-top: 20px;
  }

  .history table {
    width: 100%;
  }

  .history thead th {
    color: #1a67d2;
    border-bottom: 1px solid #1a67d2;
  }

  .history td,
  .history th {
    padding: 5px 10px;
  }

  .history tr td:first-of-type {
    padding-left: 0;
  }

  .history tr th,
  .history tr td {
    text-align: center;
  }

  .history tr th:first-of-type,
  .history tr td:first-of-type {
    text-align: left;
  }
</style>
