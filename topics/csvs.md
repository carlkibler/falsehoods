# Falsehoods About CSVs

> CSV has a spec, and almost nothing in the wild obeys it.

**[Sources & credits ↓](#sources)**

CSV looks like the simplest file format imaginable: values, separated by commas, one row per line. That mental model is wrong in roughly every way it can be. RFC 4180 exists, but it is far from definitive and is largely ignored. Eric Raymond went so far as to call CSV "a textbook example of how not to design a textual file format." Here is the list of comfortable assumptions that the real world will happily destroy.

## The Big Surprises

- **A field can contain newlines.** A single record can sprawl across many physical lines when a quoted field holds a `CR`, `LF`, or `CRLF`. So `file().split("\n")` (or PHP's `foreach(file($csv) as $row)`) will shred your data mid-record. One row is *not* one line.
- **An empty file is valid CSV.** "CSV files contain data" is false. Zero bytes is a perfectly legal CSV.
- **The delimiter isn't always a comma.** Tabs, semicolons (common across Europe), pipes, and — if someone's feeling spicy — even control characters or emoji can separate fields. TSV *is* CSV with a different delimiter, despite the name.
- **Excel cannot reliably round-trip its own CSVs.** Open a CSV in Excel and save it: it may strip the quotes around your text fields, so the moment a field contains a comma you're hosed. It also "helpfully" mangles leading zeros, anything that looks like a date (see: corrupted gene names in published papers), and numbers in different locales.
- **Excel doesn't export UTF-8.** It's reportedly the only common CSV-exporting program that won't, while most other programs export *only* UTF-8. There is no single approach that produces files readable in both Excel and everything else.
- **Naming your first column `ID` can break the file.** If a CSV (well, a text file Excel treats as one) begins with the literal characters `ID`, Excel decides it's a SYLK file and refuses to open it. Microsoft has a KB article about this.
- **Rows can have different field counts — including more than the header.** Records aren't guaranteed to match each other, match the header, or even stay *under* the header's column count. Records can also be truncated mid-line anywhere in the file.
- **A decimal number can contain a comma.** Italian (and other) locales write `3,14` instead of `3.14`. Your config matrix works on your machine and explodes on the client's, for reasons you never knew existed.
- **"Human readable" is optional.** A CSV can be full of Base64, binary blobs, or null bytes, and use non-printing control characters as its delimiter. Nothing requires it to be eyeball-friendly.
- **The header is a black art.** RFC 4180 doesn't even define a "header." It might not be line one; it might not be the first non-empty line; its names might not be unique, might be empty strings, might contain newlines or quotes. The only reliable way to identify the header is to ask the user.

## Where It Gets Complicated

### Delimiters

The comma in "comma-separated values" is aspirational. CSVs in the wild are delimited with tabs, semicolons (the European default — by the rules it would have been "SCSV"), pipes, and worse. Don't assume the delimiter is one byte, or even that a comma is one byte across encodings. And remember the data fights back: a pipe-separated export met real users whose email addresses were literally `|||NOSPAM|||@example.com`, royally hosing the import. Fields contain delimiters; that's why quoting exists.

### Quoting and Escaping

Not all fields are wrapped in double quotes — quoting is usually optional and applied only when needed. When it *is* used, don't assume there's a single quote character per file, or that opening and closing quotes match. Don't assume delimiters are escaped with a backslash (RFC 4180 escapes a `"` inside a quoted field by doubling it: `""`). Fields can legitimately contain delimiters, record separators, and control characters, so escaping is the whole ballgame — and everyone implements it slightly differently.

Excel-specific hacks deserve their own warning. `="{value}"` to dodge auto-formatting only works in Excel and nowhere else — equations aren't in any spec; it's a gross hack that leaves the next reader staring at `="..."` junk or getting the literal string years later. A leading `-` (or `+`) gets read as a formula. If you need a real spreadsheet, generate a real `.xlsx` with a library instead of abusing CSV.

### Line Endings and Embedded Newlines

Record separators are not reliably `CRLF`, not reliably `LF`, and "Excel for Mac" has shipped bare `CR`. They aren't guaranteed to be a single byte or a single rune, and not all newlines are one byte. Worst of all, a record separator inside a quoted field is *part of the data*, not the end of the row — so a quoted field can contain `CR`, `LF`, or `CRLF` and the record continues. Even SQLite once emitted non-RFC-compliant CSV on Linux by using the system line ending instead of `CRLF`. The takeaway: never split on newlines to find records. Use a real parser.

### Encoding

Pick an encoding assumption and the universe has a counterexample. CSVs are *not* all ASCII, not all Windows-1252, not all 8-bit, not all UTF-8, not all UTF-16. Worse, a single file may not hold one consistent encoding — and neither, in pathological cases, does a single record or a single field. UTF-8 CSVs sometimes carry a BOM and sometimes must not; OLEDB drivers won't read a file with a BOM as a SQL table. One survey site even ships its UTF-8 with two header bytes swapped, requiring a manual fix. Files can contain null bytes that you can't safely skip or treat as whitespace. Prepending a BOM is *not* a dependable way to make Excel read your encoding, just as `sep={char}` is an unreliable way to declare your delimiter.

### Headers, Columns, and Records

"All CSVs contain records," "all records contain fields," "all records have the same field count" — all false. Records can have fewer or more fields than the header. A CSV may have no header at all, or (when exported from Excel) multiple independent sub-spreadsheets stacked in one file, so field *N* doesn't even mean the same thing in every row. Column names may be non-unique, empty, or contain special characters, quotes, and newlines. Decimal separators and leading zeros vary, and leading zeros can't be safely ignored (think ZIP codes and IDs). And the file extension lies too — not every CSV ends in `.csv`, and forcing `.txt` is a known trick to make Excel offer its import wizard instead of silently guessing types.

## If You Build This

- **Use a real CSV parser, never `split(",")` or `split("\n")`.** Line-splitting breaks on embedded newlines; comma-splitting breaks on quoted delimiters. Reach for your language's CSV library every time.
- **Specify the dialect and encoding explicitly.** Pin down delimiter, quote character, and encoding rather than guessing — and don't trust in-band hints like `sep=` or a BOM to carry that information reliably.
- **Never assume one record per line.** Treat record parsing and line parsing as separate problems; a quoted field can hold any number of newlines.
- **Don't trust the shape of the data.** Handle variable field counts, missing or duplicated headers, empty files, null bytes, and locale-specific decimals defensively. Validate and cleanse on every ingest, even from a "trusted" source.
- **Treat Excel as a hostile round-trip.** If users will open files in Excel, expect stripped quotes, reformatted dates, dropped leading zeros, and lossy saves. When you actually need a spreadsheet, generate `.xlsx` with a library instead of abusing CSV.
- **When in doubt, ask.** The header row, the delimiter, and the encoding are frequently undiscoverable from the bytes alone. For structured pipelines, consider a CSV schema and validator rather than hoping every producer agrees with you.


## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about CSVs (Donat Studios)](https://donatstudios.com/Falsehoods-Programmers-Believe-About-CSVs) · [archived copy](../archive/csvs/01-falsehoods-about-csvs-donat-studios.md)
