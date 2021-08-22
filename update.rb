require 'json'
require 'date'
require 'http'
require './db'

def get_translation(word)
  resp = HTTP.post(
    'https://translation.googleapis.com/language/translate/v2',
    json: {
      q: word,
      source: 'en',
      target: 'zh-tw',
      format: 'text'
    },
    params: {
      key: ENV["TRANSLATE_API_KEY"]
    }
  )
  data = JSON.parse(resp.to_s)

  begin
    data["data"]["translations"].first["translatedText"]
  rescue => e
    puts e
    puts data
  end
end

translations = DB[:translations]
words = DB[:words]
words.all.each do |word|
  zhtw_word = get_translation(word[:english_word])

  last_entry = translations
    .where(english_word: word[:english_word])
    .reverse_order(:last_seen_at)
    .first

  if last_entry.nil? or (last_entry[:zhtw_word] != zhtw_word)
    puts "inserting new entry for #{word[:english_word]} -> #{zhtw_word}"
    translations.insert(
      english_word: word[:english_word],
      zhtw_word: zhtw_word,
      first_seen_at: DateTime.now,
      last_seen_at: DateTime.now
    )
  else
    puts "updating last seen for #{word[:english_word]} -> #{zhtw_word}"
    translations.where(id: last_entry[:id]).update({
      last_seen_at: DateTime.now
    })
  end
end
