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
  "hardware": "硬體",
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
  "yogurt": "優格",
  "plastic": "塑膠",
  "guinea pig": "天竺鼠",
  "college major": "大學主修",
  "convenience store": "便利商店",
  "rubik's cube": "魔術方塊",
  "uninstall": "解除安裝",
  "icon": "圖示",
  "program": "程式",
  "motherboard": "主機板",
  "laptop": "筆記型電腦",
  "pineapple": "鳳梨",
  "text": "文字",
  "billiards": "撞球",
  "protocol": "協定",
  "roller coaster": "雲霄飛車",
  "through": "透過",
  "frames per second": "每秒影格數",
  "cybercafe": "網咖",
  "good morning": "早安",
  "transistor": "電晶體",
  "instant coffee": "即溶咖啡",
  "Fed": "聯準會",
  "P/E ratio": "本益比",
  "earthquake magnitude": "地震規模",
  "earthquake intensity": "地震震度",
  "mantle": "地函",
  "RAM": "記憶體",
  "virtual memory": "虛擬記憶體",
  "virtual server": "虛擬伺服器",
  "shared server": "共享伺服器",
  "regular file": "普通檔案",
  "file system": "檔案系統",
  "filename": "檔案名稱",
  "file size" "檔案大小",
  "strings": "字串",
  "memory management": "記憶體管理",
  "macro": "巨集",
  "operations": "營運",
  "optimization": "最佳化"
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

