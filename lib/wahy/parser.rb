require "nokogiri"

module Wahy
  module Parser
    # Returns the parsed Nokogiri document for the specified language
    # @param lang [String] 'eng' or 'tur'
    def new_data(lang = "eng")
      filename = lang.to_s.downcase == "tur" ? "config_tr.xml" : "config_en.xml"
      filepath = File.join(__dir__, "data", filename)

      raise "Data file not found: #{filepath}" unless File.exist?(filepath)

      Nokogiri::XML(File.read(filepath))
    end

    # Returns the list of Chapter nodes
    # @param doc [Nokogiri::XML::Document]
    def chapters_data(doc)
      doc.xpath("//Chapter")
    end

    # Finds a specific chapter by ID or Name (case-insensitive)
    # @param chapters [Nokogiri::XML::NodeSet]
    # @param identifier [String, Integer]
    def scripture_data(chapters, identifier)
      # Eğer identifier bir sayı ise direkt ID ile eşleştir
      return chapters.find { |c| c["ChapterID"] == identifier.to_s } if identifier.to_s =~ /^\d+$/

      # Sayı değilse hem Türkçe hem İngilizce isimle eşleştirmeye çalış
      # Bunun için hem TR hem EN datasına ihtiyacımız olacak
      tr_doc = new_data("tur")
      en_doc = new_data("eng")

      tr_chapter = tr_doc.xpath("//Chapter").find { |c| c["ChapterName"].downcase == identifier.downcase }
      return chapters_data(tr_doc).find { |c| c["ChapterID"] == tr_chapter["ChapterID"] } if tr_chapter

      en_chapter = en_doc.xpath("//Chapter").find { |c| c["ChapterName"].downcase == identifier.downcase }
      return chapters_data(en_doc).find { |c| c["ChapterID"] == en_chapter["ChapterID"] } if en_chapter

      nil
    end

    # Returns an array of Verse nodes for a given chapter
    # @param chapter [Nokogiri::XML::Node]
    def sign_data(chapter)
      chapter.xpath("Verse").to_a
    end

    # Returns a specific verse from the signs array
    # @param signs [Array<Nokogiri::XML::Node>]
    # @param verse_number [String, Integer]
    def take_specific_sign(signs, verse_number)
      signs.find { |verse| verse["VerseID"] == verse_number.to_s }
    end
  end
end
