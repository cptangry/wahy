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
        list_chapters: false
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

        opts.on("--list-chapters", "List all chapters in a table format for the selected language") do
          options[:list_chapters] = true
        end

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

      if options[:list_chapters]
        display_chapter_list(quran, options[:lang])
        exit
      end

      scripture_input = options[:scripture].to_s

      # Sayısal giriş için 1-114 aralığı kontrolü
      if scripture_input =~ /^\d+$/
        chapter_num = scripture_input.to_i
        if chapter_num < 1 || chapter_num > 114
          puts "Error: Chapter number must be between 1 and 114. Got #{chapter_num}.".red
          exit 1
        end
      end

      chapter_node = Wahy.scripture_data(quran, options[:scripture])

      unless chapter_node
        puts "Error: Scripture '#{options[:scripture']}' could not be found.".red
        exit 1
      end

      chapter_id = chapter_node['ChapterID']
      chapter_name = chapter_node['ChapterName']
      verses = chapter_node.xpath('Verse')
      total_verses = verses.length

      selected_verses = []
      if options[:ayah].to_s.downcase == 'all'
        selected_verses = verses
      else
        target_ayah = options[:ayah].to_i
        match = verses.find { |v| v['VerseID'] == target_ayah.to_s }
        if match
          selected_verses = [match]
        else
          puts "Error: Ayah ##{target_ayah} not found in Chapter #{chapter_id} (#{chapter_name}).".red
          puts "This chapter has #{total_verses} ayah(s). Valid range: 1–#{total_verses}.".red
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

    def self.display_chapter_list(chapters, lang)
      lang_display = lang.to_s.downcase.start_with?('t') ? "TURKISH" : "ENGLISH"

      puts "=" * 50
      puts " QURAN CHAPTERS (#{lang_display}) ".center(50).cyan.bold
      puts "=" * 50

      puts sprintf("%-10s | %-35s", "ID", "CHAPTER NAME").yellow.bold
      puts "-" * 50

      chapters.each do |c|
        id = c['ChapterID']
        name = c['ChapterName']
        puts sprintf("%-10s | %-35s", id, name)
      end

      puts "=" * 50
    end
  end
end
