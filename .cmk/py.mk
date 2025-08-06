## 
# py.mk: Automation helpers for python, pip, and tox.
# Vars: py.pkg_name
###############################################################################

pip.install=pip install --quiet -e

pip.install.build:
	$(call log.target, .[${*}])
	set -x; pip install build

pip.install/%: mk.require.tool/pip
	$(call log.target, .[${*}])
	set -x; ${pip.install} .[${*}]

pip.release pypi.release: mk.require.tool/twine mk.assert/PYPI_USER,PYPI_TOKEN
	PYPI_RELEASE=1 ${make} py.build \
	&& twine upload \
		--user $${PYPI_USER} \
		--password $${PYPI_TOKEN} \
		dist/*

###############################################################################
py.pkg_extras?=dev,testing,publish
py.init: pip.install.build flux.map/pip.install,${py.pkg_extras}
	@# Runs pip.install.build and install dev/testing/publish for this package

py.stat:
	@# Show details about the python version / platform
	_version=`python --version | awk -F' ' '{print $$2}'` \
	&& _bin=`which python` \
	&& $(call log.target, $${_version} ${sep} $${_bin}) 
# && ${jb} version=$${_version} bin=$${_bin}

py.build py.pkg.build: py.clean
	@# Build python package in working directory
	$(call log.target, py.pkg_name=${py.pkg_name})
	export version=`python setup.py --version` \
	&& (git tag $$version \
	|| ( $(call log.target, ${yellow}WARNING: Failed to git-tag with release-tag; normal if tag already exists )) \
	&& printf "# WARNING: file is maintained by automation\n\n__version__ = \"$${version}\"\n\n" \
	| tee src/${py.pkg_name}/_version.py \
	&& pip install build && python -m build

py.clean: tox.clean
	@# Clean working directory
	$(call log.target, cleaning eggs and cache)
	rm -rf tmp.pypi* dist/* build/* 
	rm -rf src/*.egg-info/
	find . -name '*.tmp.*' -delete
	find . -name '*.pyc' -delete
	find . -name  __pycache__ -delete
	rmdir build 2>/dev/null || true

py.version py.pkg.version:; python setup.py --version
	@# Answer version info for the current project.
	@# Relies on (python setup.py --version)

###############################################################################

tox.clean:; rm -rf .tox
	@# Clean working directory
# find . -type d -name .tox | xargs -I% bash -x -c "rm -rf %"
	
tox/%: mk.require.tool/tox
	@# Runs the named tox environment.
	@#
	@# USAGE: tox/<tox_env_name>
	$(call log.target, ${dim}entering env=${no_ansi}${ital}${bold}${*} ${sep} args=$${tox_args:-})
	tox -e ${*} $${tox_args:-} 
tox.dispatch/%:
	@# Dispatches the given make target in the given tox-environment
	@#
	@# USAGE: tox.dispatch/<tox_env_name>,<target_name>
	export target=$(strip $(shell echo ${*} | cut -d, -f2-)) \
	&& set -x \
	&& tox -e $(strip $(shell echo ${*} | cut -d, -f1))

# MACRO: tox.import
#   Import several tox environments to targets
# USAGE: 
#   $(call tox.import,env1 env2) =>
#     env1: tox/env1
#     env2: tox/env1
#     env2.dispatch/%: tox.dispatch/env2,%
tox.import=$(eval $(call _tox.import,${1}))
define _tox.import
$(eval __code_blocks__:=$(shell echo "${1}"))
$(foreach codeblock, ${__code_blocks__},\
	$(call _tox.import.env, ${codeblock}))
endef
define _tox.import.env
${nl}
$(call mk.unpack.kwargs, ${1}, tox_env, ${1})
${kwargs_tox_env}: tox/${kwargs_tox_env}
tox.${kwargs_tox_env}.dispatch/%:  
	${make} tox.dispatch/${kwargs_tox_env},$${*}
endef
