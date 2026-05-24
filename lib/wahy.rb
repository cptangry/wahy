#!/usr/bin/env ruby
# coding: utf-8
require_relative "wahy/version"
require 'nokogiri'
require 'optparse'
require 'colorize'

xml_data = Wahy::Parser.load_xml
module Wahy
    class Parser
        def self.load_xml
        # İşletim sistemine uygun mutlak yolu güvenli şekilde oluşturuyoruz
        en_xml_yolu = File.expand_path('data/config_en.xml', __dir__)
        tr_xml_yolu = File.expand_path('data/config_tr.xml', __dir__)

        # Dosyaları okuyoruz (Karakter sorunu yaşamamak için UTF-8 belirterek)
        en_xml_verisi = File.read(en_xml_yolu, encoding: 'UTF-8')
        tr_xml_verisi = File.read(tr_xml_yolu, encoding: 'UTF-8')

        # wahy.rb betiğinde verileri kolayca çağırabilmek için Hash döndürüyoruz
        {
            en: en_xml_verisi,
            tr: tr_xml_verisi
        }
        end
    end
  ENGLISH  = XML_DATA[:en]
  TUR      = XML_DATA[:tr]

  SURELER = {
	:tur => ["Fatiha", "Bakara", "Ali İmran", "Nisa", "Maide", "Enam", "Araf", "Enfal", "Tevbe", "Yunus", "Hud", "Yusuf", "Rad", "İbrahim", "Hicr", "Nahl", "Isra", "Kehf", "Meryem", "Taha", "Enbiya", "Hac", "Muminun", "Nur", "Furkan", "Suara", "Neml", "Kasas", "Ankebut", "Rum", "Lukman", "Secde", "Ahzab", "Sebe", "Fatir", "Yasin", "Saffat", "Sad", "Zümer", "Mumin", "Fussilet", "Sura", "Zuhruf", "Duhan", "Casiye", "Ahkaf", "Muhammed", "Fetih", "Hucurat", "Kaf", "Zariyat", "Tur", "Necm", "Kamer", "Rahman", "Vakia", "Hadid", "Mücadele", "Hasr", "Mümtahine", "Saf", "Cuma", "Münafikun", "Tegabun", "Talak", "Tahrim", "Mülk", "Kalem", "Hakka", "Mearic", "Nuh", "Cin", "Müzzemmil", "Müddessir", "Kıyamet", "İnsan", "Murselat", "Nebe", "Naziat", "Abese", "Tekvir", "İnfitar", "Mutaffifin", "İnsikak", "Buruc", "Tarik", "Ala", "Gasiye", "Fecr", "Beled", "Şems", "Leyl", "Duha", "İnşirah", "Tin", "Alak", "Kadir", "Beyyine", "Zilzal", "Adiyat", "Karia", "Tekasür", "Asr", "Hümeze", "Fil", "Kureyş", "Maun", "Kevser", "Kafirun", "Nasr", "Leheb", "İhlas", "Felak", "Nas"],
	:eng => ["The Opening", "The Cow", "The Family Of Imran", "Women", "The Food", "The Cattle", "The Elevated Place", "The Spoils Of War", "Repentance", "Yunus", "Hud", "Yusuf", "The Thunder", "Ibrahim", "The Rock", "The Bee", "The Israelites", "The Cave", "Marium", "Ta Ha", "The Prophets", "The Pilgrimage", "The Believers", "The Light", "The Criterion", "The Poets", "The Ant", "The Narrative", "The Spider", "The Romans", "Luqman", "The Adoration", "The Allies", "Saba", "The Originator", "Ya Seen", "The Rangers", "Suad", "The Companies", "The Believer", "Ha Mim", "The Counsel", "The Embellishment", "The Evident Smoke", "The Kneeling", "The Sandhills", "Muhammad", "The Victory", "The Chambers", "Qaf", "The Scatterers", "The Mountain", "The Star", "The Moon", "The Beneficient", "The Great Event", "The Iron", "The Pleading One", "The Banishment", "The Examined One", "The Ranks", "Friday", "The Hypocrites", "Loss And Gain", "The Divorce", "The Prohibition", "The Kingdom", "The Pen", "The Sure Calamity", "The Ways Of Ascent", "Nuh", "The Jinn", "The Wrapped Up", "The Clothe Done", "The Resurrection", "The Man", "The Emissaries", "The Great Event", "Those Who Pull Out", "He Frowned", "The Covering Up", "The Cleaving Asund", "The Defrauders", "The Bursting Asund", "The Mansions Of The Stars", "The Night-Comer", "The Most High", "The Overwhelming", "The Daybreak", "The City", "The Sun", "The Night", "The Early Hours", "The Expansion", "The Fig", "The Clot", "The Majesty", "The Clear Evidence", "The Shaking", "The Assaulters", "The Terrible Calam", "The Multiplicatio", "Time", "The Slanderer", "The Elephant", "The Qureaish", "The Daily Necessar", "The Heavenly Fount", "The Unbelievers", "The Help", "The Flame", "The Unity", "The Dawn", "The Men"]
  }

  module Opt_PARSER



    def self.opsiyonlar opts
      options = {}
      parser = OptionParser.new do |o|
        o.banner = "Usage: wahy [options]"


        o.on("-lLANG", "--lang=LANGUAGE", "Which language that you want to read signs?") do |l|
          options[:lang] = l
        end

        o.on("-sSCRIPTURE", "--scripture=SCRIPTURE", "Scripture name or number") do |s|
          if s =~ /[[:digit:]]/
            options[:scripture] = s.to_i - 1
          elsif s == 'all'
            options[:scripture] = s
          else
            scr = s.include?(" ") ? s.split(" ").map {|i| i = i.capitalize}.join(" ") : s.capitalize
            SURELER.values.each do |v|
              options[:scripture] = v.index(scr) if v.include? scr
            end
          end
        end

        o.on("-asign", "--ayah=SIGN", "Sign number") do |a|
          a = a.to_i - 1 unless a == 'all'
          options[:sign] = a
        end

        o.on("-h", "--help", "Prints this help") do
          puts o
          exit
        end
      end

      parser.parse!(opts)
      options
    end
  end

  args = ARGV

  OPTIONS   = Opt_PARSER.opsiyonlar args
  LANG      = OPTIONS[:lang]
  SCRIPTURE = OPTIONS[:scripture] || 0
  SIGN      = OPTIONS[:sign] || 'all'

  Doc = Nokogiri::XML(LANG == 'tur' ? TUR : ENGLISH) do |config|
    config.strict.noblanks
  end

  Elements = Doc.xpath("//*[@ChapterName]")

  def self.show_wahy
    var = Elements[SCRIPTURE]
    puts var.attr('ChapterName').upcase.center(40, "*")

    if SIGN == 'all'
      var.css('Verse').each_with_index do |v, i|
        print "[#{i + 1}]: ".red, "#{v.text}".green, "\n"
      end
    else
      print "[#{SIGN + 1}]: ".red, "#{var.css('Verse')[SIGN].text}".green, "\n"
    end
  end

  def self.new_data lang
	if lang == 'tur'
		doc = Nokogiri::XML(TUR)
	elsif lang == 'eng'
		doc = Nokogiri::XML(ENGLISH)
	else
		print 'Please, eelect a correct option ("tur" or "eng"): '
		selection = gets.chomp
		new_data selection
	end
	doc
  end

  def self.chapters_data parsed_xml_data
	elements = parsed_xml_data.xpath("//*[@ChapterName]")
	elements
  end

  def self.scripture_data parsed_chapter_data, scripture_name
	s_data = nil
	if scripture_name =~ /[[:digit:]]/
		s_data = parsed_chapter_data[scripture_name]
	else
		sc = scripture_name.include?(" ") ? scripture_name.split(" ").map {|i| i = i.capitalize}.join(" ") : scripture_name.capitalize
		SURELER.values.each do |v|
			s_data = v.index(sc) if v.include? sc
		end
	end
	scripture = parsed_chapter_data[(s_data || 0)]
	scripture
  end

  def self.sign_data scripture_data
	sign = []
	scripture_data.css('Verse').each do |v|
		sign << v.text
	end
	sign
  end

  def self.sign_data_object scripture_data
	scripture_data.css('Verse')
  end

  def self.take_specific_sign sign_data, sign_number
	sign = sign_data[sign_number]
	sign
  end

  def self.specific_sign_object scripture_data, sign_number
	sign = scripture_data.css('Verse')[sign_number]
  end
end
