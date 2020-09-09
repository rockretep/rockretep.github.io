# Makefile to generate website

###########
# VARIABLES
###########
__VERSION           := 1.1
BASEURL             := https://www.rockretep.net

#############
# DIRECTORIES
#############
SOURCE		:= source
ASSET		:= assets
SITE		:= site
CSS			:= css
INCLUDE		:= includes
IN_TM		:= includes/templated
TEMPLATE	:= templates
TM_IN		:= templates/included
DIRS		:= $(subst $(SOURCE),$(SITE),$(shell find $(SOURCE) -type d))

#############
# INPUT FILES
#############
MD_FILES		:= $(shell find $(SOURCE) -type f -name "*.md")
SCSS_FILES		:= $(shell find $(SOURCE) -type f -name "*.scss")
TEMPLATE_FILES	:= $(shell find $(TEMPLATE) -type f -name "*.template")
TM_IN_FILES		:= $(shell find $(TM_IN) -type f -name "*.template")
INCLUDE_FILES	:= $(wildcard $(INCLUDE)/*.html)
META_FILE		:= $(SOURCE)/meta.yaml

##############
# OUTPUT FILES
##############
HTML_FILES	:= $(subst $(SOURCE),$(SITE),$(patsubst %.md,%.html,$(MD_FILES)))
CSS_FILES	:= $(subst $(SOURCE),$(SITE),$(patsubst %.scss,%.css,$(SCSS_FILES)))
IN_TM_FILES	:= $(subst $(TM_IN),$(IN_TM),$(patsubst %.template,%.html,$(TM_IN_FILES)))

##############
# SCRIPT FILES
##############
META_SCRIPT	:= script/genyaml
PRE_SCRIPT	:= script/preprocess

#############
# OTHER FILES
#############
ASSET_FILES	:= $(subst $(ASSET),$(SITE),$(wildcard $(ASSET)/*))
POSTS		:= $(wildcard $(SOURCE)/posts/*.md)
SITEMAP		:= $(SITE)/sitemap.txt
TREE		:= $(SITE)/sitemap.html

##############
# FILE DEPENDS
##############
BASE_DEPENDS	:= \
				$(ASSET_FILES) \
				$(PRE_SCRIPT) \
				$(META_SCRIPT) \
				$(META_FILE) \

DEFAULT_DEPENDS := \
				$(BASE_DEPENDS) \
				$(INCLUDE_FILES) \
				$(TEMPLATE)/default.template

POST_DEPENDS	:= \
				$(BASE_DEPENDS) \
				$(INCLUDE_FILES) \
				$(TEMPLATE)/post.template

##############
# BIN & SCRIPT
##############
PANDOC		:= pandoc
METAGEN		:= $(META_SCRIPT)
PREPROCESS	:= $(PRE_SCRIPT)

################
# PARSER OPTIONS
################
BASE_FLAGS := \
			--from markdown+yaml_metadata_block \
			--to html \
			--standalone

###############
# INCLUDE FLAGS
###############
DEFAULT_INCLUDE_FLAGS := \
			--include-in-header=$(INCLUDE)/head.html \
			--include-before-body=$(INCLUDE)/header.html \
			--include-after-body=$(INCLUDE)/footer.html

###########
# FLAG SETS
###########
DEFAULT_FLAGS := \
			$(BASE_FLAGS) \
			--template $(TEMPLATE)/default.template \
			$(DEFAULT_INCLUDE_FLAGS) \
			--strip-comments

POST_FLAGS  := \
			$(BASE_FLAGS) \
			--template $(TEMPLATE)/post.template \
			$(DEFAULT_INCLUDE_FLAGS) \
			--strip-comments

###############
# SPECIAL FLAGS
###############
META_FLAG := --metadata-file=$(META_FILE)

PORTFOLIO_IN_FLAGS = \
				--from html \
				--to html \
				--template $< \
				$(META_FLAG) \
				--strip-comments

# Default target
all: $(DIRS) $(META_FILE) $(IN_TM_FILES) $(HTML_FILES) $(CSS_FILES) $(ASSET_FILES) $(TREE) $(SITEMAP)

#############
# DIRECTORIES
#############
$(DIRS):
	mkdir -p $@

$(META_FILE): $(POSTS)
	$(METAGEN)

####################
# TEMPLATED INCLUDES
####################
in_tm: $(IN_TM_FILES) $(META_FILE)
$(IN_TM)/%.html: $(TM_IN_FILES)
	$(PANDOC) $(PORTFOLIO_IN_FLAGS) --output $@ $<

############
# HTML FILES
############
$(SITE)/index.html: $(SOURCE)/index.md $(DEFAULT_DEPENDS)
	$(PREPROCESS) $< | $(PANDOC) $(DEFAULT_FLAGS) --output $@

$(SITE)/about.html: $(SOURCE)/about.md $(DEFAULT_DEPENDS)
	$(PANDOC) $(DEFAULT_FLAGS) --output $@ $<

$(SITE)/posts/%.html: $(SOURCE)/posts/%.md $(POST_DEPENDS)
	$(PANDOC) $(POST_FLAGS) --output $@ $<

###########
# CSS FILES
###########
$(SITE)/css/main.css: $(SOURCE)/css/main.scss
	sassc $< $@

##############
# STATIC FILES
##############
$(ASSET_FILES): $(wildcard $(ASSET)/*)
	cp -r $(ASSET)/* $(SITE)

#########
# SITEMAP
#########
$(SITEMAP): $(HTML_FILES)
	find $(SITE)/ \
		-name "*.html" \
		! -name "404.html" \
		-type f \
		-printf "$(BASEURL)/%P\n" > $@
# Tree
$(TREE): $(HTML_FILES)
	touch $@ && \
	tree \
		$(SITE) \
		-P '*.html|*.css|*.txt|*.png|*.png|*.svg' \
		--dirsfirst \
		-H $(BASEURL) \
		-T "Sitemap" \
		-o $@

#######
# CLEAN
#######
clean:
	echo $(CSS_FILES)
	rm -rf $(SITE)/*
	rm -f $(IN_TM)/*

########
# SERVER
########
server:
	python -m http.server -d site/

rebuild: clean all

# PHONY targets
.PHONY: all clean server rebuild
