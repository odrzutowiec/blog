SOURCE = $(wildcard src/*.md)
OBJECTS = $(SOURCE:.md=.html)

.POSIX:

.DEFAULT: build

build: $(OBJECTS)

deploy: $(OBJECTS:src=deploy)
	@rm -rf deploy;\
		DEPLOT_GIT_BRANCH=gh-pages;\
		DEPLOY_GIT_REMOTE=$$(git remote);\
		DEPLOY_GIT_URL=$$(git remote get-url $$(git remote));\
		mkdir -p deploy;\
		git init deploy;\
		cd deploy;\
		git remote add $$DEPLOY_GIT_REMOTE $$DEPLOY_GIT_URL;\
		git checkout -b $$DEPLOT_GIT_BRANCH;\
		git pull $$DEPLOY_GIT_REMOTE $$DEPLOT_GIT_BRANCH;\
		rm -rf *;\
		cp -r ../build/* .;\
		git add .;\
		git commit -m "$$(date)";\
		git push $$DEPLOY_GIT_REMOTE $$DEPLOT_GIT_BRANCH;
	@echo "Deployed";

test: build
	open build/index.html

build_dir:
	mkdir -p build
	rm -rf build/*

# Compile html files from markdownfiles.
# First parse all markdown files for meta variables with format // name: val by using vars.awk
# TODO: then pass those meta variables to the makrdown.awk

%.html: %.md build_dir
	@vars="$$(awk -f awk/lib.awk -f awk/vars.awk $<)"; \
		echo "$$vars" | sed 's/"/"/g;s/^/-v /'  | xargs -t -I vars awk vars -f awk/lib.awk -f awk/markdown.awk $< > build/$(<F:.md=.html);


