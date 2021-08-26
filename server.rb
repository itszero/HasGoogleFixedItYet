require 'sinatra'
require 'json'
require './db'

class HasGoogleFixedItYet < Sinatra::Base
  configure do
    set :db, DB
  end

  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  get '/reportList' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  get '/i/data' do
    settings.db["""
SELECT
  c.id,
  a.english_word,
  a.correct_zhtw_word,
  c.zhtw_word,
  c.first_seen_at,
  c.last_seen_at,
  CASE
  WHEN a.correct_zhtw_word = c.zhtw_word THEN 1
  ELSE 0
  END AS is_fixed
FROM words a
INNER JOIN translations c ON a.english_word = c.english_word
INNER JOIN (
  SELECT english_word, MAX(last_seen_at) AS last_seen_at
  FROM translations
  GROUP BY english_word
) b ON c.english_word = b.english_word AND c.last_seen_at = b.last_seen_at
ORDER BY is_fixed ASC, lower(a.english_word) ASC
                """.strip].all.to_json
  end

  get '/i/word/:id' do
    item = settings.db[:translations].where(:id => params[:id]).first
    settings.db[:translations].where(:english_word => item[:english_word]).order_by(:first_seen_at).all.to_json
  end
end
