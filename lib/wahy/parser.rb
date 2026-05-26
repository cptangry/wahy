require 'nokogiri'

module Wahy
  module Parser
    # Returns the parsed Nokogiri document for the specified language
    # @param lang [String] 'eng' or 'tur'
    def new_data(lang = 'eng')
      filename = lang.to_s.downcase == 'tur' ? 'config_tr.xml' : 'config_en.xml'
      filepath = File.join(__dir__, 'data', filename)

      raise "Data file not found: #{filepath}" unless File.exist?(filepath)

      Nokogiri::XML(File.read(filepath))
    end

    # Returns the list of Chapter nodes
    # @param doc [Nokogiri::XML::Document]
    def chapters_data(doc)
      doc.xpath('//Chapter')
    end

    # Finds a specific chapter by ID or Name (case-insensitive)
    # @param chapters [Nokogiri::XML::NodeSet]
    # @param identifier [String, Integer]
    def scripture_data(chapters, identifier)
      chapters.find do |chapter|
        chapter['ChapterID'] == identifier.to_s ||
        chapter['ChapterName'].downcase == identifier.to_s.downcase
      end
    end

    # Returns an array of Verse nodes for a given chapter
    # @param chapter [Nokogiri::XML::Node]
    def sign_data(chapter)
      chapter.xpath('Verse').to_a
    end

    # Returns a specific verse from the signs array
    # @param signs [Array<Nokogiri::XML::Node>]
    # @param verse_number [String, Integer]
    def take_specific_sign(signs, verse_number)
      signs.find { |verse| verse['VerseID'] == verse_number.to_s }
    end
  end
end
