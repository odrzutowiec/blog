SOURCE_DIR=src
PUBLIC_DIR=pub

build:
	for f in $(SOURCE_DIR)/*.md; do awk -f markdown.awk $$f > ${PUBLIC_DIR}/$$(basename $$f .md).html; done

clean:
	rm -rf pub/*

