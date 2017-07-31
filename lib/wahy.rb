# coding: utf-8
require_relative "wahy/version"
require 'nokogiri'
require 'optparse'
require 'colorize'

module Wahy

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
          else
            options[:scripture] = SURELER[options[:lang].to_sym].index(s.split(" ").map {|i| i = i.capitalize}.join(" "))
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

  SURELER = {
    :tur => ["Fatiha", "Bakara", "Ali İmran", "Nisa", "Maide", "Enam", "Araf", "Enfal", "Tevbe", "Yunus", "Hud", "Yusuf", "Rad", "İbrahim", "Hicr", "Nahl", "Isra", "Kehf", "Meryem", "Taha", "Enbiya", "Hac", "Muminun", "Nur", "Furkan", "Suara", "Neml", "Kasas", "Ankebut", "Rum", "Lukman", "Secde", "Ahzab", "Sebe", "Fatir", "Yasin", "Saffat", "Sad", "Zümer", "Mumin", "Fussilet", "Sura", "Zuhruf", "Duhan", "Casiye", "Ahkaf", "Muhammed", "Fetih", "Hucurat", "Kaf", "Zariyat", "Tur", "Necm", "Kamer", "Rahman", "Vakia", "Hadid", "Mücadele", "Hasr", "Mümtahine", "Saf", "Cuma", "Münafikun", "Tegabun", "Talak", "Tahrim", "Mülk", "Kalem", "Hakka", "Mearic", "Nuh", "Cin", "Müzzemmil", "Müddessir", "Kıyamet", "İnsan", "Murselat", "Nebe", "Naziat", "Abese", "Tekvir", "İnfitar", "Mutaffifin", "İnsikak", "Buruc", "Tarik", "Ala", "Gasiye", "Fecr", "Beled", "Şems", "Leyl", "Duha", "İnşirah", "Tin", "Alak", "Kadir", "Beyyine", "Zilzal", "Adiyat", "Karia", "Tekasür", "Asr", "Hümeze", "Fil", "Kureyş", "Maun", "Kevser", "Kafirun", "Nasr", "Leheb", "İhlas", "Felak", "Nas"],
    :eng => ["The Opening", "The Cow", "The Family Of Imran", "Women", "The Food", "The Cattle", "The Elevated Place", "The Spoils Of War", "Repentance", "Yunus", "Hud", "Yusuf", "The Thunder", "Ibrahim", "The Rock", "The Bee", "The Israelites", "The Cave", "Marium", "Ta Ha", "The Prophets", "The Pilgrimage", "The Believers", "The Light", "The Criterion", "The Poets", "The Ant", "The Narrative", "The Spider", "The Romans", "Luqman", "The Adoration", "The Allies", "Saba", "The Originator", "Ya Seen", "The Rangers", "Suad", "The Companies", "The Believer", "Ha Mim", "The Counsel", "The Embellishment", "The Evident Smoke", "The Kneeling", "The Sandhills", "Muhammad", "The Victory", "The Chambers", "Qaf", "The Scatterers", "The Mountain", "The Star", "The Moon", "The Beneficient", "The Great Event", "The Iron", "The Pleading One", "The Banishment", "The Examined One", "The Ranks", "Friday", "The Hypocrites", "Loss And Gain", "The Divorce", "The Prohibition", "The Kingdom", "The Pen", "The Sure Calamity", "The Ways Of Ascent", "Nuh", "The Jinn", "The Wrapped Up", "The Clothe Done", "The Resurrection", "The Man", "The Emissaries", "The Great Event", "Those Who Pull Out", "He Frowned", "The Covering Up", "The Cleaving Asund", "The Defrauders", "The Bursting Asund", "The Mansions Of The Stars", "The Night-Comer", "The Most High", "The Overwhelming", "The Daybreak", "The City", "The Sun", "The Night", "The Early Hours", "The Expansion", "The Fig", "The Clot", "The Majesty", "The Clear Evidence", "The Shaking", "The Assaulters", "The Terrible Calam", "The Multiplicatio", "Time", "The Slanderer", "The Elephant", "The Qureaish", "The Daily Necessar", "The Heavenly Fount", "The Unbelievers", "The Help", "The Flame", "The Unity", "The Dawn", "The Men"]
  }

  OPTIONS   = Opt_PARSER.opsiyonlar args
  LANG      = OPTIONS[:lang] || 'tur'
  SCRIPTURE = OPTIONS[:scripture] || 0
  SIGN      = OPTIONS[:sign] || 'all'

  Doc = Nokogiri::XML(File.open("../lib/data/#{LANG}.xml")) do |config|
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
end
