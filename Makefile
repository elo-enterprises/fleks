##
# Python project makefile.
##
.SHELL := bash
MAKEFLAGS += --warn-undefined-variables
# .SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := none

THIS_MAKEFILE := $(abspath $(firstword $(MAKEFILE_LIST)))
THIS_MAKEFILE := `python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' ${THIS_MAKEFILE}`
SRC_ROOT := $(shell dirname ${THIS_MAKEFILE})

NO_COLOR:=\033[0m
COLOR_GREEN=\033[92m

PYPI_PROJECT_NAME:=fleks

export CMK_BIN=.cmk/compose.mk
include ${CMK_BIN}
$(call mk.import.plugins, py.mk)
$(call mk.import.plugin.maybe, local.mk)
# $(call mk.import.files, .github/actions.mk docs/docs.mk)
py.pkg_name:=fleks 
py.pkg_extras:=dev,testing,publish

.PHONY: build docs test

init: py.stat py.init

build: clean
	export version=`python setup.py --version` \
	&& (git tag $$version \
	|| printf 'WARNING: Failed to git-tag with release-tag (this is normal if tag already exists).\n' > /dev/stderr) \
	&& printf "# WARNING: file is maintained by automation\n\n__version__ = \"$${version}\"\n\n" \
	| tee src/${PYPI_PROJECT_NAME}/_version.py \
	&& python -m build

version:
	@python setup.py --version

clean: flux.stage/cleaning py.clean

pypi-release:
	PYPI_RELEASE=1 make build \
	&& twine upload \
	--user $${PYPI_USER} \
	--password $${PYPI_TOKEN} \
	dist/*

release: clean normalize static-analysis test pypi-release

normalize: tox/normalize
lint: static-analysis
static-analysis: tox/static-analysis
test-units: utest
test-integrations: itest
smoke-test: stest
itest: tox/itest
utest: tox/utest
stest: tox/stest
test: test-units test-integrations smoke-test
# coverage:
# 	echo NotImplementedYet

plan: docs-plan
apply: docs-apply

dtest: tox/dtest
docs-test: dtest
test-docs: docs-test
docs-plan:
	tox -e docs-plan
docs: docs-apply
docs-apply:
	tox -e docs