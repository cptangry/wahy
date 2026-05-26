require 'rexml/document'

module Wahy
    # Modular Parser class that handles XML data parsing
    # Provides clean Ruby structures (Hash/Array) for external API usage
    class Parser
        def initialize(lang)
            filename = lang == 'tur' ? 'config_tr.xml' : 'config_en.xml'
            # Data directory relocated inside the lib/wahy folder for gem packaging
            @file_path = File.join(__dir__, 'data', filename)
            load_data
        end

        def load_data
            unless File.exist?(@file_path)
                puts "\e[31mError: Data file not found -> #{@file_path}\e[0m"
                exit 1
            end
            file = File.read(@file_path)
            @doc = REXML::Document.new(file)
        end

        # Helper to find raw XML element by ID or Name
        def find_chapter_element(query)
            if query.match?(/^\d+$/)
                REXML::XPath.first(@doc, "//Chapter[@ChapterID='#{query}']")
            else
                chapter = nil
                REXML::XPath.each(@doc, "//Chapter") do |c|
                    if c.attributes['ChapterName'].to_s.downcase == query.downcase
                        chapter = c
                        break
                    end
                end
                chapter
            end
        end

        # API Method: Returns basic chapter info as a Hash: { id: "1", name: "Fatiha" }
        def chapter_info(query)
            element = find_chapter_element(query)
            return nil unless element

            {
                id: element.attributes['ChapterID'],
                name: element.attributes['ChapterName']
            }
        end

        # API Method: Returns verses as an Array of Hashes: [{ id: "1", text: "..." }]
        def verses_data(chapter_query, verse_query = 'all')
            chapter_el = find_chapter_element(chapter_query)
            return [] unless chapter_el

            elements = if verse_query.to_s.downcase == 'all'
            chapter_el.elements.to_a("Verse")
        else
            [REXML::XPath.first(chapter_el, "Verse[@VerseID='#{verse_query}']")].compact
        end

        elements.map do |v|
            {
                id: v.attributes['VerseID'],
                text: v.text.to_s.strip
            }
        end
    end
end
end
