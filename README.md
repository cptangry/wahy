# Wahy

Wahy is a powerful Ruby-based tool designed to query, read, and display Quran chapters and verses directly from your terminal. It offers a clean, colorized CLI interface for quick lookup and a modular structure that allows you to use it as a library (API) in your own Ruby projects.

Whether you want to browse a specific chapter, search for a verse by name or number, or programmatically access Quranic text in English (Yusuf Ali) or Turkish (Elmalılı Hamdi Yazır) translations, Wahy provides a fast and intuitive way to interact with the full 114-chapter Quran.

## Features

- **Dual Language Support:** Easily query and read verses in Turkish (`tur`) or English (`eng`).
- **Flexible Queries:** Search chapters by their number (e.g., `2`) or their names (e.g., `"Bakara"` or `"The Cow"`).
- **Chapter Count Validation:** CLI now validates that chapter numbers are within the valid range (1–114) and shows an error for out-of-range inputs.
- **Ayah Count Warnings:** When an invalid verse number is provided, the error message now includes the total verse count and valid range for that chapter (e.g., `"This chapter has 7 ayah(s). Valid range: 1–7."`).
- **Verse Filtering:** Retrieve an entire chapter or a specific verse (e.g., `-a 5`) with ease.
- **Colorized Terminal UI:** Optimized reading experience with automatic text centering and highlighted verse indicators.
- **Modular Library:** Easily integrate the data parsing logic into other Ruby applications.
- **Chapter Name Lists:** Query all chapter names as arrays via `Wahy.en_chapters` and `Wahy.tur_chapters`.
- **Ayah Count API:** Look up the number of verses in any chapter via `Wahy.ayah_count`.

## Prerequisites

- Ruby 4.0.2 or higher
- The project expects XML data files to be located in the `lib/wahy/data/` directory:
    - `config_en.xml`
    - `config_tr.xml`

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'wahy'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install wahy
```

Or install it directly via terminal:

```bash
gem install wahy
```

## CLI Usage

You can use the wahy command directly in your terminal. By default, it displays the 1st chapter in English.

| Option | Long Option | Description | Default |
| :--- | :--- | :--- | :--- |
| `-l` | `--lang` | Language selection (`tur` or `eng`) | `eng` |
| `-s` | `--scripture` | Chapter name or number (1-114) | `1` |
| `-a` | `--ayah` | Specific verse number or 'all' | `all` |
| - | `--list-chapters` | List all chapters in a clean table format | - |
| `-v` | `--version` | Show version | - |
| `-h` | `--help` | Show help menu | - |

Examples

View the entire chapter in English:

```bash
wahy
```

View a specific chapter in Turkish:

```bash
wahy -l tur -s <chapter_number>  # If you know name of Chapter, you don't need to use -l --lang parameter.
# With -l (`tur` or `eng`)  always use -s <Chapter number>
```

View a specific verse:

```bash
wahy -l tur -s <chapter_number> -a <verse_number>

wahy -s <chapter_mame_or_number> -a <verse_number>
```

List all chapters in Turkish:

```bash
# List all chapters in English (default)
wahy --list-chapters

# List all chapters in Turkish
wahy --list-chapters -l tur
```

### CLI Validation

The CLI provides helpful error messages for invalid inputs:

**Out-of-range chapter numbers:**

```bash
$ wahy -s 0
Error: Chapter number must be between 1 and 114. Got 0.

$ wahy -s 200
Error: Chapter number must be between 1 and 114. Got 200.
```

**Invalid verse numbers:**

```bash
$ wahy -s 1 -a 10
Error: Ayah #10 not found in Chapter 1 (The Opening).
This chapter has 7 ayah(s). Valid range: 1–7.
```

## Listing Chapters (`--list-chapters`)

The `--list-chapters` feature acts as an interactive built-in index for the Quranic data files. It provides users with a clean, well-aligned terminal table showing the exact `ID` and `Chapter Name` mappings for the selected language.

### Example Output:
```text
==================================================
            QURAN CHAPTERS (TURKISH)             
==================================================
ID         | CHAPTER NAME                       
--------------------------------------------------
1          | Fatiha                             
2          | Bakara                             
3          | Âl-i İmrân                         
...
114        | Nas                                
==================================================
```

## Save output to a file:

```bash
wahy -s <chapter_name_or_number> -a <verse_number> > output.txt
```

## Library (API) Usage

You can require wahy in your own Ruby projects to parse and manipulate Quranic data programmatically:

```ruby
require 'wahy'

# 1. Load data for a specific language
data = Wahy.new_data 'tur' 

# 2. Extract chapters
quran = Wahy.chapters_data data

# 3. Get a specific chapter node
the_opening = Wahy.scripture_data quran, 'the opening' 

# 4. Extract verses as an array of strings
signs = Wahy.sign_data the_opening 

# 5. Get a specific sign
sign_two = Wahy.take_specific_sign signs, 1

# 6. Get all chapter names as arrays
en_chapters = Wahy.en_chapters   # → ["The Opening", "The Cow", ...]
tur_chapters = Wahy.tur_chapters # → ["Fatiha", "Bakara", ...]

# 7. Get the number of ayahs in a chapter
ayah_count = Wahy.ayah_count(1)        # → 7
ayah_count = Wahy.ayah_count("Fatiha") # → 7
ayah_count = Wahy.ayah_count(999)      # → 0 (unknown chapter)
```
## License

This project is licensed under the MIT License.

```text
**Gem includes two XML data**
English Quran Tranlation(/lib/data/config_en.xml): Written by Yusuf Ali
Turkish Quran Tranlation(/lib/data/config_tr.xml): Written by Elmalılı Hamdi Yazır
Special Thanks to: http://www.qurandatabase.org/Database.aspx
```
