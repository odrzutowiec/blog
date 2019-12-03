SOURCE = $(wildcard src/*.md)
OBJECTS = $(SOURCE:.md=.html)

.POSIX:

.DEFAULT: build

build: $(OBJECTS)

deploy: build
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
		cp -r ../build/* .;\
		git add .;\
		git commit -m "$$(date)";\
		git push $$DEPLOY_GIT_REMOTE $$DEPLOT_GIT_BRANCH;
	@echo "Deployed";

test: build
	open build/index.html

build_dir:
	mkdir -p build

%.html: %.md build_dir
	@vars="$$(awk -f awk/lib.awk -f awk/vars.awk $< | awk -F '=' '{gsub("\"", "\\\"", $$2); print $$1 "=" "\"" $$2 "\"" }')";\
	awk -f awk/lib.awk -f awk/markdown.awk $< > build/$(<F:.md=.html);\
	# echo $$vars >> build/$(<F:.md=.html);


