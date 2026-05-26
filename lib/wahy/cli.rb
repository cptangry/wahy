require 'optparse'
require 'io/console'

module Wahy
    # CLI class that handles command-line interfaces and arguments
    class CLI
        def self.run
            options = { lang: 'eng', scripture: '1', ayah: 'all' }

            parser = OptionParser.new do |opts|
                opts.banner = "Usage: wahy [options]"

                opts.on("-l", "--lang LANG", "Select language for reading (tur or eng)") do |v|
                    options[:lang] = v
                end

                opts.on("-s", "--scripture SCRIPT", "Chapter name or chapter number (1-114)") do |v|
                    options[:scripture] = v
                end

                opts.on("-a", "--ayah AYAH", "Verse number to fetch or 'all' for the whole chapter") do |v|
                    options[:ayah] = v
                end

                opts.on("-h", "--help", "Prints this help menu") do
                    puts opts
                    exit
                end
            end

            begin
                parser.parse!
            rescue OptionParser::InvalidOption => e
                puts "\e[31m#{e.message}\e[0m"
                puts parser
                exit 1
            end

            display(options)
        end

        def self.display(options)
            parser = Wahy::Parser.new(options[:lang])
            chapter = parser.chapter_info(options[:scripture])

            if chapter.nil?
                puts "\e[31mChapter not found: #{options[:scripture]}\e[0m"
                exit 1
            end

            verses = parser.verses_data(options[:scripture], options[:ayah])

            if verses.empty?
                puts "\e[31mVerse not found: #{options[:ayah]}\e[0m"
                exit 1
            end

            # Get terminal width to dynamically center the header title
            terminal_width = IO.console ? IO.console.winsize[1] : 80
            title = " Chapter: #{chapter[:name]} (No: #{chapter[:id]}) "

            puts "\n"
            puts "\e[1;36m#{title.center(terminal_width, '=')}\e[0m\n\n"

            # Print formatting
            verses.each do |verse|
                puts "\e[32m[#{verse[:id]}]\e[0m #{verse[:text]}"
            end
            puts "\n"
        end
    end
end
