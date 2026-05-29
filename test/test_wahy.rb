# frozen_string_literal: true

require "test_helper"

class TestWahy < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Wahy::VERSION
  end

  def test_it_does_something_useful
    assert false
  end

  def test_en_chapters_returns_114_chapters
    chapters = Wahy.en_chapters
    assert_equal 114, chapters.length
    assert_equal "The Opening", chapters.first
    assert_equal "The Men", chapters.last
  end

  def test_tur_chapters_returns_114_chapters
    chapters = Wahy.tur_chapters
    assert_equal 114, chapters.length
    assert_equal "Fatiha", chapters.first
    assert_equal "Nas", chapters.last
  end

  def test_en_chapters_returns_strings
    chapters = Wahy.en_chapters
    chapters.each do |chapter|
      assert_kind_of String, chapter
    end
  end

  def test_tur_chapters_returns_strings
    chapters = Wahy.tur_chapters
    chapters.each do |chapter|
      assert_kind_of String, chapter
    end
  end

  def test_ayah_count_by_id
    assert_equal 7, Wahy.ayah_count(1)
    assert_equal 286, Wahy.ayah_count(2)
  end

  def test_ayah_count_by_name
    assert_equal 7, Wahy.ayah_count("The Opening")
    assert_equal 286, Wahy.ayah_count("The Cow")
  end

  def test_ayah_count_returns_integer
    result = Wahy.ayah_count(1)
    assert_kind_of Integer, result
  end

  def test_ayah_count_for_unknown_chapter_returns_zero
    assert_equal 0, Wahy.ayah_count(999)
  end
end
