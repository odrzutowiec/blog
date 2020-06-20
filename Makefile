MD_SOURCES = $(wildcard src/*.md)
MD_OBJECTS = $(MD_SOURCES:.md=.html)
AWK_SOURCES = $(wildcard src/*.awk)
AWK_OBJECTS = $(AWK_SOURCES:.awk=.html)

.DEFAULT: build

build: $(MD_OBJECTS) ${AWK_OBJECTS}

deploy-github: $(MD_OBJECTS:src=deploy) $(AWK_OBJECTS:src=deploy)
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

deploy-home: $(MD_OBJECTS:src=deploy) $(AWK_OBJECTS:src=deploy)
	@scp build/index.html root@home:/var/www/michalradecki.com/blog.html
	@echo "Deployed";

test: build
	open build/index.html || xdg-open build/index.html

build_dir:
	mkdir -p build
	rm -rf build/*

# Compile html files from markdownfiles.
# First parse all markdown files for meta variables with format // name: val by using vars.awk
# TODO: then pass those meta variables to the makrdown.awk

%.md: %.awk build_dir
	awk -f awk/lib.awk -f $< > src/$(<F:.awk=.md);

%.html: %.md build_dir 
	+vars="$$(awk -f awk/lib.awk -f awk/vars.awk $< | sed "s/^/-v /" | paste -sd ' ' -)"; \
		eval awk $$vars -f awk/lib.awk -f awk/markdown.awk $< > build/$(<F:.md=.html);

clean:
	rm -rf build;
	rm -rf deploy;

