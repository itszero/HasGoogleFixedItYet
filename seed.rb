require 'json'
require 'date'
require 'http'
require './db'

WORDS = {
  "video": "影片",
  "computer mouse": "電腦滑鼠",
  "harddisk": "硬碟",
  "CD": "光碟",
  "HD": "高畫質",
  "software": "軟體",
  "computer memory": "電腦記憶體",
  "potato": "馬鈴薯",
  "instant noodles": "泡麵",
  "quality": "品質",
  "project": "專案",
  "mega": "百萬",
  "laser": "雷射",
  "internet": "網際網路",
  "compatibility": "相容性",
  "information": "資訊",
  "database": "資料庫",
  "digital": "數位",
  "server": "伺服器",
  "AI": "人工智慧",
  "rapper": "饒舌歌手",
  "butter": "奶油",
  "screen": "螢幕",
  "taxi": "計程車",
  "message": "訊息",
  "default": "預設",
  "printer": "印表機",
  "yogurt": "優格"
}

words = DB[:words]

WORDS.each do |english_word, correct_zhtw_word|
  english_word = english_word.to_s
  if words.where(:english_word => english_word).count == 0
    puts "adding #{english_word}..."
    words.insert({
      english_word: english_word,
      correct_zhtw_word: correct_zhtw_word
    })
  else
    puts "updating #{english_word}..."
    words.where({:english_word => english_word}).update({ correct_zhtw_word: correct_zhtw_word })
  end
end

