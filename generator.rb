#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'prawn'

doc_settings = {
  :margin => 45,
  :page_size => 'A5',
  :info => {
    :Title => "あずにゃんとペアプロしてる気分になれる薄い本",
    :Author => "まさらっき",
    :Creator => "NP-complete"
  }
}

def parse(message)
  message.lines.map {|line|
    if line =~ /^\$/
     line
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
りっちゃんと一緒で思い出すのが大変でした

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
  image_size = 32
  image(image_file, :width => image_size)

  bounding_box [image_size + 8, cursor + image_size], :width => 332 - image_size do
    text message
  end
  move_down 4
end

def story(id)
  start_new_page
  title "第0話 ドッグフードを食べる"
  dialog "/home/masaki/Dropbox/picture/azusa_normal.png", parse(
    "律先輩、ドックフードを食べてください\n" +
    "$rails new hoge うんこ\n")
  dialog "/home/masaki/Dropbox/picture/ritsu_normal.png", "testtest\n" + "unkounko"
end

Prawn::Document.generate('test.pdf', doc_settings) do
  font "/usr/share/fonts/truetype/ipafont/ipag.ttf"

  maegaki
  story(1)

  atogaki
  okutuke
end
