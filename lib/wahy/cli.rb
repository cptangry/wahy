# lib/wahy/cli.rb
require 'optparse'
require 'colorize'

module Wahy
  class CLI


    def self.start(args)
      options = {
        lang: 'eng',
        scripture: '1',
        ayah: 'all',
        list_chapters: false # Yeni: Listeleme seçeneği varsayılan olarak kapalı
      }

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: wahy [options]"

        opts.on("-l", "--lang LANG", "Pick language ('eng'|'tur' or 'en'|'tr') [Default: eng]") do |l|
          options[:lang] = l
        end

        opts.on("-s", "--scripture SCRIPTURE", "Pick scripture name or number (1-114) [Default: 1]") do |s|
          options[:scripture] = s
        end

        opts.on("-a", "--ayah AYAH", "Pick sign/ayah number or 'all' [Default: all]") do |a|
          options[:ayah] = a
        end

        # Yeni: Sadece sureleri listelemek için argüman
        opts.on("--list-chapters", "List all chapters in a table format for the selected language") do
          options[:list_chapters] = true
        end

        # Yeni: Versiyon numarasını gösterir
        opts.on("-v", "--version", "Prints the current version") do
          puts "wahy version #{Wahy::VERSION}"
          exit
        end

        opts.on("-h", "--help", "Prints this help menu") do
          puts opts
          exit
        end
      end

      begin
        opt_parser.parse!(args)
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts "CLI Error: #{e.message}".red
        puts opt_parser
        exit 1
      end

      run(options)
    end

    def self.run(options)
      begin
        data = Wahy.new_data(options[:lang])
      rescue => e
        puts "Error: #{e.message}".red
        exit 1
      end

      quran = Wahy.chapters_data(data)

      # Eğer list-chapters bayrağı tetiklendiyse, tabloyu çiz ve programı sonlandır
      if options[:list_chapters]
        display_chapter_list(quran, options[:lang])
        exit
      end

      # Listeleme istenmediyse normal okuma akışına devam et
      chapter_node = Wahy.scripture_data(quran, options[:scripture])

      unless chapter_node
        puts "Error: Scripture '#{options[:scripture]}' could not be found.".red
        exit 1
      end

      chapter_id = chapter_node['ChapterID']
      chapter_name = chapter_node['ChapterName']
      verses = chapter_node.xpath('Verse')

      selected_verses = []
      if options[:ayah].to_s.downcase == 'all'
        selected_verses = verses
      else
        target_ayah = options[:ayah].to_s
        match = verses.find { |v| v['VerseID'] == target_ayah }
        if match
          selected_verses = [match]
        else
          puts "Error: Ayah ##{target_ayah} not found in Chapter #{chapter_id} (#{chapter_name}).".red
          exit 1
        end
      end

      terminal_width = 75
      puts "=" * terminal_width
      header_title = "Chapter #{chapter_id}: #{chapter_name}"
      puts header_title.center(terminal_width).upcase.cyan.bold
      puts "=" * terminal_width
      puts ""

      selected_verses.each do |v|
        verse_id = v['VerseID']
        verse_text = v.text.strip

        print "[#{verse_id}] ".green.bold
        puts verse_text.white
        puts ""
      end
      puts "=" * terminal_width
    end

    # Yeni: Sureleri tablo halinde terminale basan yardımcı metod
    def self.display_chapter_list(chapters, lang)
      lang_display = lang.to_s.downcase.start_with?('t') ? "TURKISH" : "ENGLISH"

      puts "=" * 50
      puts " QURAN CHAPTERS (#{lang_display}) ".center(50).cyan.bold
      puts "=" * 50

      # Sütun başlıkları: Sola dayalı 10 karakter ID, sola dayalı 35 karakter İsim
      puts sprintf("%-10s | %-35s", "ID", "CHAPTER NAME").yellow.bold
      puts "-" * 50

      chapters.each do |c|
        id = c['ChapterID']
        name = c['ChapterName']
        # Sütun verilerini hizalayarak yazdır
        puts sprintf("%-10s | %-35s", id, name)
      end

      puts "=" * 50
    end
  end
end
