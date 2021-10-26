+RTS -K512m -RTS ex.md
 --to html4
 --from markdown-hard_line_breaks+smart+auto_identifiers+autolink_bare_uris+emoji+footnotes+inline_notes+tex_math_dollars+tex_math_single_backslash+markdown_in_html_blocks+yaml_metadata_block+header_attributes+native_divs
 --indented-code-classes=sh
 --section-divs
 --mathjax
 --lua-filter filter.lua
