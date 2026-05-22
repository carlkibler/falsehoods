# Falsehoods about CSVs (Donat Studios)

> **Original:** <https://donatstudios.com/Falsehoods-Programmers-Believe-About-CSVs>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods Programmers Believe About CSVs — Donat Studios

Falsehoods Programmers Believe About CSVs

Comments:

37

Tags:

Falsehoods

Excel

Encoding

CSV

By Jesse Donat on

Dec. 27, 2016

Much of my professional work for the last 10+ years has revolved around handling, importing and exporting CSV files. CSV files are frustratingly misunderstood, abused, and most of all underspecified. While RFC4180 exists, it is far from definitive and goes largely ignored.

Partially as a companion piece to my recent post about how CSV is an encoding nightmare , and partially an expression of frustration, I’ve decided to make a list of falsehoods programmers believe about CSVs. I recommend my previous post for a more in-depth coverage on the pains of CSVs encodings and how the default tooling (Excel) will ruin your day.

Everything on this list is a false assumption that developers make.

All CSVs are ASCII

All CSVs are Win1252

All CSVs are in 8-bit encodings

All CSVs are UTF-8

All CSVs are UTF-16

All CSVs contains a single consistent encoding

All records contain a single consistent encoding

All fields contain a single consistent encoding

All CSVs contain records

All records contain fields

Fields never contain record separators

Fields never contain delimiters

Fields never contain control characters

Delimiters are escaped with a  

All fields are enclosed by double quotes

All records are a single line

All lines contain a single record

All records contain the same number of fields

All records contain the same number of fields as the header

All records contain the same number of fields or fewer than the header

All CSVs contain a header

All record separators are CRLF

All record separators are LF

All record separators are a single byte

All record separators are a single rune

All newlines are a single byte

All CSVs are delimited with a comma

All CSVs are delimited with a comma, tab or semicolon

TSV isn’t CSV

All delimiters are a single byte

All commas are a single byte

All CSVs are readable with Excel

Excel is a good tool for working with CSVs

Excel is an OK tool for working with CSVs

Excel can losslessly save CSVs it opens

Using =“{value}” is a good way to get around Excel auto-formatting

The first line will never be a poorly supported instruction header

Using sep={char} is a good way to get Excel to accept your delimiter

Prepending a BOM is a good way to get Excel to read your encoding

You can safely name your first column “ID”

All CSVs follow RFC4180

Most CSVs follow RFC4180

All CSVs follow the same defined standard

All CSVs follow a defined standard

All CSVs have a .csv extension

All CSV is human readable

Please take these into consideration next time you find yourself working with CSV. If you can think of anything I may have missed I’d be happy to add it.

As a suggested further reading, “The Art of Unix Programming” http://www.catb.org/esr/writings/taoup/html/ch05s02.html#id2901882 section on DSV style which notably says “CSV is a textbook example of how not to design a textual file format”

Updates:

Thanks to Max for pointing out the Excel supported sep={value} header I was strangely entirely unaware of.

Thanks to Don Hopkins for the note about not being able to start a header with ID

Comment by: chris on Dec. 27, 2016

Interesting points, but nothing to back them up. E.g. Using =“{value}” is an acceptable way to get around Excel auto-formatting. I’ve seen that done before – why isn’t it acceptable?

Comment by: Jesse G. Donat on Dec. 27, 2016

Chris, the biggest reason not to use =“{value}” is simply that your CSV will then *only* work in Excel and nowhere else. Equations are not supported by any spec anywhere and the fact that this works is just a really gross hack. I’ve done it, I’ve had to do it, but it’s really really gross.

Comment by: Andrew on Dec. 27, 2016

@chris It may be acceptable on a case by case basis, like if someone were using a version of Excel that had issues with CSVs without this code, and they were the main person who would be using the file. But what if: Someone with a different version of excel opens the file, and it fails to load because it uses a different parsing mechanism. I get the file (developer) and now I’ve got to parse out all this “={value}” junk that means nothing to me. Someone years later opens the file and gets the literal string instead of the function value, and is seriously confused. It’s a hack, and should be avoided. It’s not that it doesn’t work, but a CSV is NOT an Excel file, and shouldn’t be treated as such. Generate a real Excel file if the client needs it! There are libraries for that!

Comment by: Tom on Dec. 27, 2016

What do you mean “All CSV is human readable”? Can you give me an example?

Comment by: Max on Dec. 27, 2016

You should add: - All CSVs have column headers - All CSVs start with a line of data - The first line of a CSV file is either a header or a row of data - The first line will indicate the line separator via the Excel friendly sep= pragma - The first line will never include the Excel friendly sep= pragma - All CSVs from the same source will have a consistent first line of either headers or data http://superuser.com/questions/773644/what-is-the-sep-metadata-you-can-add-to-csvs For what it’s worth, I think Excel is fine for CSV manipulation so long as you turn off the magic it does. For really large files I’ve found its column oriented engine makes global editing/find and replace faster than vim and other text oriented tools while being more user friendly (for non-devs/command line experts) than head, sed, find, grep, and sort.

Comment by: dan on Dec. 27, 2016

all rows have the same number of delimiters as the rest of the rows. this is a fun one :)

Comment by: Don Hopkins on Dec. 27, 2016

Falsehood: You can safely name your first column “ID”. https://support.microsoft.com/en-us/kb/323626 https://news.ycombinator.com/item?id=12041210

Comment by: Lyndsy Simon on Dec. 28, 2016

I’d add: - CSV files contain data An empty file is valid CSV :)

Comment by: Alex on Dec. 28, 2016

I don’t know about programmers, but I’ve heard many a designer and product manager assume that Excel could export UTF-8 CSV, or some other ASCII-superset encoding that would be readable by a Unicode-aware program. Nope, Excel is the only CSV-exporting program I’ve ever seen that doesn’t export UTF-8 at all. And other programs generally export only UTF-8. There’s no solution that works the same in both Excel and other programs.

Comment by: jhi on Dec. 28, 2016

- UTF-8 CSV must have a BOM \* UTF-8 CSV must not have a BOM

Comment by: Alex on Dec. 28, 2016

Oh, here’s another set of problems (false assumptions) I’ve run into: - If there is a CSV header, then it’s one record in length. - If there is a header and it’s one record in length, then it’s the first line of the file. - OK, it’s at least the first non-empty line of the file. - OK, well surely it’s the first CSV record with non-empty fields… Nope, figuring out the “header” of a CSV file is a black art. The only way to be sure is to ask the user. The CSV RFC doesn’t define even any such thing as a “header”. - So we asked the user which line is the header. At least now we know that all the values in it will be unique (so we can use them as dictionary keys). - Well, at least none of them are the empty string, right? - OK, they can be anything at all. At least when I load them into this CSV-processing program, and save them again, they’ll all be in the same order as before, so I can use column position as a key…

Comment by: Eze on Dec. 28, 2016

Most of this over my head…but some of it sinks in. Thx!

Comment by: David McKee on Dec. 28, 2016

- Field N has the same meaning in all records of this CSV file. If it’s a CSV file that’s been exported from Excel, there’s nothing stopping a CSV file from having multiple independent sub-spreadsheets in one file… (If you find yourself having to deal with this sort of stuff and you know python, https://sensiblecodeio.github.io/quickcode-ons-docs/ and the xypath library might help. Disclaimer – I wrote them.)

Comment by: David McKee on Dec. 28, 2016

Discovered that SQLite didn’t output RFC-compliant CSV files on Linux (it was using system line endings, not CRLF). That was a surprise. I believe that behaviour has been patched.

Comment by: Gwen Patton on Dec. 28, 2016

I used to do “meatball programming” for a company that sent out junk mail. Yeah, yeah, it paid the bills, don’t judge me. We had to take in data in CSV all the time. (Among other formats) It was a complete and utter pain in the rump, because none of these files had ANY consistency whatsoever. Over 50% of my job was analyzing these friggerty files to see just how bad bad could get, to slap together some code to read the garbage data we got from our clients. Another 25% of my job was cleaning up the complete mess of slop data we managed to coax out of the mishmash of characters they charitably called “data” so it could be used for something useful, such as addressing a post card. The rest of the time was spent laboriously and sometimes repeatedly trying to get their data to work with our expensive and complex USPS-specified software to put their gawd-awful, nearly sense-free data into a consistent enough form that the US Snail Postal Disservice would interpret it well enough to grant us a full Zip+4 zip code and a correctly-formatted address and barcode suitable for presorted mail. A nearly insignificant amount of time was spent running print jobs and making certain the data actually printed in legible form on the various envelopes, cards, letters, and labels. Sometimes we’d find that required data was only partially present after all, and that the error-checking routines in the Expensive USPS Software had missed the fact that required fields were missing, resulting in completely nonsensical information being printed in the wrong place on the material. Certainly the barcoding was complete gibberish, and the whole mess had to be done all over again. But sure, send us your “data” in CSV from your Excel spreadsheet. Why don’t you beat me with a crowbar while you’re at it? You certainly couldn’t cause me any MORE pain. What I wouldn’t give for someone with half the sense God gave a spastic gerbil who might possibly send me an actual file designed to hold data, along with an accurate data specification for the file, in a format compatible with an actual database. Of course, as soon as someone like that came along, the US Snail would come out with an update to their software, requiring that all presorted mail be printed using Sanskrit or some such.

Comment by: Text munging monkey on Dec. 28, 2016

- 35a. Excel can correctly open CSVs which were saved in Excel (not if you’ve got a line break within a field, iirc - probably some other circumstances too) \* you can write a VBA macro to load a CSV file setting specific columns to Text format to force leading zeroes, things which look like dates or are dates in a different locale, numbers in parentheses to load losslessly in Excel (You can, but not if the file extension is “.csv”; for some reason using a known file extension silently overrides all the parameters you’ve carefully provided to the OpenText loading function. That was a painful morning of debugging…)

Comment by: Nigel Heffernan on Dec. 28, 2016

The worst thing that excel does is read save your csv \*without the encapsulating quotes you had around the text fields”. If any field contains a comma, you’re hosed. Lets not talk about Excel reading (and then saving down) any field that looks like it can be converted to a date. After that, try the falsehood “OLEDB database drivers will read your csv file as a table for your SQL”: not if there’s a BOM, they won’t!

Comment by: Patrick O’Beirne on Jan. 3, 2017

Also, don’t assume that text fields never begin with a dash, which Excel will interpret as a minus sign and treat as a formula. +1 to the header bytes comment, I have to swap two header bytes on one survey website download to get real UTF-8. +1 to the date comment, see the recent articles on gene name corruption in published papers. Yes, there is a Text File Import, as described in https://sysmod.wordpress.com/2016/08/28/excel-gene-mutation-and-curation/

Comment by: SteveBETL on Mar. 28, 2017

One that caught me: Numbers you’ve written won’t contain commas. I wrote out a config matrix to a csv file, then read it in later. It worked on my machine, but failed on the client machine. Turns out that my Italian client was using “decimal commas” instead of “decimal points”. It’s easy to fix but, because I never even knew that different cultures might do something like this, hard to debug.

Comment by: Thomas on Aug. 2, 2017

“What do you mean”All CSV is human readable”? Can you give me an example?” A CSV full of Base64 encoded data. Never seen one, but it’s possible.

Comment by: HD on Sep. 15, 2017

A very common misconception is that .csv file is smaller in size than the .xlsx file that it produced it. My experience shows that the .xlsx file can be up to 5 times smaller than the csv, because of the data type handling algorythms in Excel.

Comment by: Adam Retter on Apr. 11, 2018

In UK Government we needed to ingest data provided by other governmental departments. We settled on CSV as the lowest common denominator for the data transfer. However, we needed highly structured data, to ensure that people were creating the CSV files according to our requirements we developed a CSV Schema language and validator tool. You might find these interesting/useful: 1. http://digital-preservation.github.io/csv-schema/csv-schema-1.1.html 2. http://digital-preservation.github.io/csv-validator/

Comment by: Empire on Apr. 11, 2018

There are always complete records, that are never truncated in the middle of a line/somewhere in the file

Comment by: David H on Apr. 11, 2018

@HD one reason an xlsx file is larger is that an xslx file is a ZIP file. Change the extension from xslx to zip and you can extract it

Comment by: Calvin on Apr. 11, 2018

re: All CSV is human readable CSVs can use control characters or non printable characters as deliminator or that can include fields with binary data

Comment by: MichaelW on Apr. 11, 2018

I’ve had to support cases where “Excel for Mac” exports with CR delimiters. I forget what happens with “Excel for Windows” but no programmers writing software this century expect that.

Comment by: Osvaldo on Apr. 11, 2018

All CSVs starts with text and does not add UTF-16 BOM

Comment by: Werner on Apr. 13, 2018

CSV fields can contain CR/LF/CRLF characters. The raw file looks like: “Row1-Field1”;“Row1-Field2a2b”;“Row1-Field3”“Row2-… . Don’t use foreach (file(\$csvFile) as \$csvRows) {…} (PHP) or f=open(csvFile,”r”);rows=f.read().split(“”);… (Python) to isolate the CSV rows. Use a appropriate CSV parser class.

Comment by: Kris on Apr. 16, 2018

Excel Falsehoods: Excel will preserve leading zeros Excel won’t change datatype for data that looks like a date Excel won’t make assumptions based on only the first few rows of data I hate data-in-Excel. Users do it all the time “to tidy things up” and then expect me to wave some magic wand to get the missing data back :(

Comment by: jezza101 on Apr. 16, 2018

I don’t know how prevalent these falsehoods are but anyone who has worked with CSVs for long will quickly learn the hard way that anything can and frequently does happen in a CSV file!

Comment by: Brian on Apr. 16, 2018

I am vindicated!! After 30 years in the business, I am trying to explain this to the new folks. And I hear, “But the data is coming from the same source every time; why do you need validation and cleansing before ingesting every file? I’m not going to do all that in the new system.” It’s not long until I hear, “Why is this data so messed up?” Hmm… Thank you all .

Comment by: Steven K. Mariner on Apr. 16, 2018

TSV is tab-separated values. CSV is comma-separated values. But since nobody pays attention to rules, TSV now includes all these and other delimiters, including the widespread use of semi-colons in Europe, which, if everyone were following rules, would have been referred to has SCSV. But when someone says “CSV”, for all you know it’s emoji-cat-separated values, so ask all the stupid questions.

Comment by: Chad Estes on Apr. 16, 2018

Any time I hear someone start a sentence with “All”, “Every”, “None”, or “To be honest” my first instinct is to point at the speaker and yell, “LIAR!!!”

Comment by: SomeCallMeTim on Apr. 16, 2018

We have a feature in our products that allows for creation of CSV files that supplies the gory data behind reports being generated. My preference is to force the extract file names to .txt rather than .csv, as Excel will allow you to manipulate how each column of data is imported, whereas Excel will make some gross generalizations about data in CSVs (as noted by Text munging monkey). Some of our clients opt for .csv and let Excel determine how the data is treated. Other clients (wisely) opt for .txt.

Comment by: Kris on Apr. 17, 2018

We were asked to provide data to a Client’s Email campaign “supplier” as PIPE separated. I protested … to no avail. I had a look at the data and sure enough more than one person had an email address of: \|\|\|NOSPAM\|\|\|@example.com which presumably royally hosed their import …

Comment by: JFoushee on Apr. 17, 2018

Falsehood: All rows terminate at the same position Falsehood: CSVs cannot support arrays because they are also delimited

Comment by: Oleksandr on Sep. 4, 2019

All of these I’ve met personally: - CSV file has exactly one header - Column names are unique - Column names don’t contain special characters - or newlines? or quotes? really? - CSV file does not contain null bytes - Null bytes can be skipped or treated as whitespace - There is only a single type of quote used in file (also: opening and closing quotes are the same/different) - There is a single type of decimal separator per file - Leading zeros in numbers can be ignored
