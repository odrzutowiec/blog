.POSIX:

SOURCE = $(wildcard src/*.md)
OBJECTS = $(SOURCE:.md=.html)
all: $(OBJECTS)
deploy: all
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

%.html: %.md
	mkdir -p build; awk -f awk/markdown.awk $< > build/$(<F:.md=.html)

