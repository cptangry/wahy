require 'optparse'
require 'colorize'

module Wahy
  class CLI
    def self.start(args)
      # Set default options
      options = { lang: 'eng', scripture: '1', ayah: 'all' }

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: wahy [options]"

        opts.on("-l", "--lang LANGUAGE", "Language selection ('tur' or 'eng') - Default: eng") do |l|
          options[:lang] = l
        end

        opts.on("-s", "--scripture SCRIPTURE", "Chapter name or ID (1-114) - Default: 1") do |s|
          options[:scripture] = s
        end

        opts.on("-a", "--ayah AYAH", "Sign/Verse number or 'all' - Default: all") do |a|
          options[:ayah] = a
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end

      opt_parser.parse!(args)

      begin
        # Fetch Data
        doc = Wahy.new_data(options[:lang])
        chapters = Wahy.chapters_data(doc)
        chapter = Wahy.scripture_data(chapters, options[:scripture])

        if chapter.nil?
          puts "Error: Scripture '#{options[:scripture]}' not found.".colorize(:red)
          exit 1
        end

        # Header preparation
        chapter_id = chapter['ChapterID']
        chapter_name = chapter['ChapterName']
        title = "#{chapter_id}. #{chapter_name}"

        # Get terminal width for centering (fallback to 80 if it fails)
        term_width = `tput cols`.to_i rescue 80
        term_width = 80 if term_width == 0

        # Print centered and colored header
        puts "\n"
        puts title.center(term_width).colorize(:green).bold
        puts ("=" * title.length).center(term_width).colorize(:green)
        puts "\n"

        signs = Wahy.sign_data(chapter)

        # Print verses
        if options[:ayah].to_s.downcase == 'all'
          signs.each { |sign| print_sign(sign) }
        else
          sign = Wahy.take_specific_sign(signs, options[:ayah])
          if sign.nil?
            puts "Error: Ayah '#{options[:ayah]}' not found in this scripture.".colorize(:red)
          else
            print_sign(sign)
          end
        end
        puts "\n"
      rescue => e
        puts "An error occurred: #{e.message}".colorize(:red)
        exit 1
      end
    end

    private

    # Helper method to print a single verse
    def self.print_sign(sign)
      verse_id = sign['VerseID']
      # CDATA text parsing and whitespace stripping
      text = sign.text.strip
      puts "[#{verse_id}] ".colorize(:cyan).bold + text
    end
  end
end
