MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -euc
.DEFAULT_GOAL := build

# Variables
PROJECT = building-openapis

# Windows environment?
CYG_CHECK := $(shell hash cygpath 2>/dev/null && echo 1)
ifeq ($(CYG_CHECK),1)
	VBOX_CHECK := $(shell hash VBoxManage 2>/dev/null && echo 1)

	# Docker Toolbox (pre-Windows 10)
	ifeq ($(VBOX_CHECK),1)
		ROOT := /${PROJECT}
	else
		# Docker Windows
		ROOT := $(shell cygpath -m -a "$(shell pwd)")
	endif
else
	# all non-windows environments
	ROOT := $(shell pwd)
endif

DEV_IMAGE := ${PROJECT}_dev

DOCKRUN := docker run --rm \
	-v ${ROOT}:/local \
	-w /local \
	${DEV_IMAGE}


.PHONY: clean
clean:
	@:

.PHONY: veryclean
veryclean: clean
	rm -rf tmp

## prefix before other make targets to run in your local dev environment
local: | quiet
	@$(eval DOCKRUN= )
	@mkdir -p tmp
	@touch tmp/dev_image_id
quiet: # this is silly but shuts up 'Nothing to be done for `local`'
	@:

.PHONY: prepare
prepare: tmp/dev_image_id
tmp/dev_image_id: Dockerfile.dev
	@mkdir -p tmp
	@docker rmi -f ${DEV_IMAGE} > /dev/null 2>&1 || true
	@docker build -t ${DEV_IMAGE} -f Dockerfile.dev .
	@docker inspect -f "{{ .ID }}" ${DEV_IMAGE} > tmp/dev_image_id

# ----------------------------------------------
# build
.PHONY: build
build: prepare mkdocs.yml content/*
	${DOCKRUN} mkdocs build
	@find docs -type d -exec chmod 755 {} \; || :
	@find docs -type f -exec chmod 644 {} \; || :
