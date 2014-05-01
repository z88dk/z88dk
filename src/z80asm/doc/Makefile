.SUFFIXES: .txt .html

.txt.html:
	perl -MText::MultiMarkdown=markdown -e "local $$/; print markdown(<>)" $< > $@

all: 	object_file_format_v01.html \
		object_file_format_v02.html \
		object_file_format_v03.html
