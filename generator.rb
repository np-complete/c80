#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'prawn'
require 'nokogiri'
require 'open-uri'

doc_settings = {
  :margin => 30,
  :page_size => 'B5',
  :info => {
    :Title => "あずにゃんとペアプロしてる気分になれる薄い本",
    :Author => "まさらっき",
    :Creator => "NP-complete",
    :CreationDate => Time.parse("2011/8/13 10:00")
  }
}

def parse(message)
  message.lines.map {|line|
    if line =~ /^(\$[\w -_:\/]+)(.*)/
      #      line = "<font name=\"Courier\">#{$1}</font>#{$2}"
      line = "#{$1}#{$2}"
    end
    line
  }.join
end

def title(str, options = nil)
  text str, {:align => :center, :character_spacing => 4, :size => 20}.merge(options || {})
  move_down 40
end

def maegaki
  move_down 200
  options = {:align => :center, :size => 14, :character_spacing => 2}
  text "この物語は、Railsプログラマの", options
  move_down 10
  text "平凡な開発風景を淡々と描くものです。", options
  move_down 15
  text "過度に技術的な期待はしないでください。" , options
end

def atogaki
  start_new_page
  title "あとがき"
  font_size 11
text <<TXT
Rails本だと思った? 残念、アジャイル本でした!!

このサークルでは初参加です。初めてエロ漫画じゃない真面目な本を作りました。
もともとけいおんメンバーがWebサービスを開発して、その開発風景をまとめて本にするという設定で始めました。
最初の案が「楽譜共有サイト」だったんですが、途中まで開発して、さて楽譜のテーブルを作るぞといったところで、自分が全然楽譜が読めないことに気づき断念しました。
楽譜共有サイトだったらキャラ設定とかストーリーとか違和感がなかったのに・・・

そこでネタを変更してSSを作るサービスの開発にとりかかりました。
なぜSSにしたのかというと、SSサイトなら使いながら原稿を書けると思ったから。
0話を見て気づいた人もいると思いますが、まさに自分が作ったサービスを自分でテストとして使って書いた0話です。
サーバにデプロイした次の瞬間から今までのことを思い出して原稿を書き始めました。
りっちゃんと一緒で思い出すのが大変でした。

本当はもっとコードを示してRailsプログラミングの解説をしたかったんですが、いかんせんSSとコードがとても相性が悪く、
見返してみるとRails本ではなく、アジャイル開発の雰囲気を伝える本になってしまいました。
コードは全てgithubに置いてあるのでそちらを見てください。
http://github.com/np-complete/ss_editor
まあ中途半端にコードの解説をするより、読み物としてアジャイル開発が表現できてればいいかなと。
次の本はきちんとコードを書くような本にしたいですね。
今回はhtmlとpdfだったので次回はきちんとTeXで・・・

当サークルは普段、ニコ生でプログラミング風景を生放送するという形で活動しています。
サービスの開発、原稿、アイコンお絵かきの全ての時間をニコ生で放送していました。
今後も開発風景をダダ流ししていくので興味があれば覗いてみてください。
http://com.nicovideo.jp/community/co600306
TXT
end

def okutuke
  start_new_page
  options = {:align => :center, :character_spacing => 1}

  title "奥付"
  text "「あずにゃんとペアプロしてる気分になれる薄い本」", options.merge(:size => 12)
  move_down 40
  text "発行", options.merge(:size => 16)
  move_down 20
  text "NP-complete", options
  move_down 10
  text "http://np-complete-doj.in/", options
  move_down 60

  text "著者", options.merge(:size => 16)
  move_down 20
  text "まさらっき", options
  move_down 10
  text "http://twitter.com/masarakki", options
  move_down 60

  text "発行日", options.merge(:size => 16)
  move_down 20
  text "2011/08/13", options
end

def dialog(image_file, message)
  image_size = 28
  c_before = cursor
  c_image = cursor - image_size
  if c_before < image_size
   # p "new page #{message}"
    start_new_page
    dialog(image_file, message)
  else
    image image_file, :width => image_size, :at => [0, c_before]
    text parse(message), :inline_format => true, :margin_left => image_size + 4
    c_text = cursor
   # p "message = #{message}, c_before = #{c_before}, c_text = #{c_text}, c_image = #{c_image}"
    down_weight = [c_text, c_image].min - image_size / 3
    move_down cursor - down_weight if down_weight > 0
  end
end

def story(id)
#  start_new_page

  document = Nokogiri::HTML(open("http://ss-park.net/stories/#{id}").read)
  title  document.css("#main h1").first.text

  dialogs = document.css("#main .dialog")
  dialogs.each do |dialog|
    image_file =  dialog.css("img").first[:src]
    message = dialog.css("p").first.text
    dialog "/home/masaki/Pictures/ruby.png", message
  end

  if File.exists?("#{id}.txt")
    move_down 8
    text "解説", :styles => [:bold], :size => 16
    move_down 4
    text File.open("#{id}.txt").read
  end
  move_down 24
end

Prawn::Document.generate('test.pdf', doc_settings) do
  font "/usr/share/fonts/truetype/ipafont/ipag.ttf"
  maegaki
  start_new_page
  1.upto(18) do |id|
    story(id)
  end

  atogaki
  okutuke
end
