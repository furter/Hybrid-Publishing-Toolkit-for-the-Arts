# Makefile for Digital Publishing Toolkit
#

allmd = $(wildcard *.md docs/*.md images/*.md)
svg = $(wildcard images/_in_progress/*.svg)
svgpng = $(patsubst %.svg,%.png,$(svg))

derivedhtml = $(patsubst %.md,%.html,$(allmd))

all : toolkit.epub

toolkit.epub : title.txt $(allmd)
	cd docs && pandoc \
	--self-contained \
	--epub-metadata=../metadata.xml \
	--epub-stylesheet=../styles.css \
	--default-image-extension svg \
	--table-of-contents \
	-o ../toolkit.epub \
	../title.txt *.md

toolkit.pdf : $(svgpng) $(allmd)
	cd docs && pandoc \
	--self-contained \
	--epub-metadata=../metadata.xml \
	--default-image-extension png \
	--epub-stylesheet=../styles.css \
	--table-of-contents \
	-o ../toolkit.pdf \
	../title.txt -H ../patch.tex *.md

# Use pandoc to convert markdown to HTML
%.html: %.md
	pandoc --css=styles.css -s $< > $@

# Use ImageMagick to convert svg's to png
%.png : %.svg
	convert $< $@

clean:
	rm -f $(derivedhtml)
	rm toolkit.epub
	rm toolkit.pdf
