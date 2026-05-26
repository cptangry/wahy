# Wahy

Wahy is a powerful Ruby-based tool designed to query, read, and display Quran chapters and verses directly from your terminal. It offers a clean, colorized CLI interface for quick lookup and a modular structure that allows you to use it as a library (API) in your own Ruby projects.

## Features

- **Dual Language Support:** Easily query and read verses in Turkish (`tur`) or English (`eng`).
- **Flexible Queries:** Search chapters by their number (e.g., `2`) or their names (e.g., `"Bakara"` or `"The Cow"`).
- **Verse Filtering:** Retrieve an entire chapter or a specific verse (e.g., `-a 5`) with ease.
- **Colorized Terminal UI:** Optimized reading experience with automatic text centering and highlighted verse indicators.
- **Modular Library:** Easily integrate the data parsing logic into other Ruby applications.

## Prerequisites

- Ruby 2.5 or higher
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
| `-h` | `--help` | Show help menu | - |

Examples

View the entire chapter in English:

```bash
wahy
```

View a specific chapter in Turkish:

```bash
wahy -l tur -s <chapter_number>  # If you know name of Chapter, you don't need to use -l --lang parameter.
With -l (`tur` or `eng`)  always use -s <Chapter number>
```

View a specific verse:

```bash
wahy -l tur -s <chapter_name_or_number> -a <verse_number>
```

Save output to a file:

```bash
wahy -l tur -s <chapter_name_or_number> -a <verse_number> > output.txt
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
```
## License

This project is licensed under the MIT License.
