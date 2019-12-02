.POSIX:

SRC = $(wildcard src/*.md)
TRG = $(SRC:.md=.html)
all: $(TRG)
%.html: %.md
	mkdir -p pub; awk -f awk/markdown.awk $< > pub/$(<F:.md=.html)
