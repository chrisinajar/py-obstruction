
SHELL = /bin/sh

ROOT=$(shell pwd)
TESTENV=${ROOT}/.test-env
DIST=${ROOT}/dist/

clean:
	- rm .py3-env
	- rm .py2-env
	- rm -rf $(DIST)
	- rm -rf $(TESTENV)
	- rm -rf ./*.egg-info
	- rm -rf ./build/

.PHONY: two
two: .py2-env
.PHONY: three
three: .py3-env
.PHONY: test test-two test-three
test: test-two test-three
test-two: two
	pipenv run unit2 discover
test-three: three
	pipenv run unit2 discover

.PHONY: publish
publish: test test-package build
	- twine upload $(DIST)/*py3*
	- twine upload $(DIST)/*py2*

.PHONY: build build-two build-three
build: build-two build-three
build-two: two
	pipenv run python setup.py bdist_wheel
build-three: three
	pipenv run python setup.py bdist_wheel

.PHONY: package
package: build $(TESTENV)
	source '${TESTENV}'/bin/activate && python
.PHONY: test-package
test-package: build $(TESTENV)
	source '${TESTENV}'/bin/activate && unit2 discover -v

$(DIST):
	mkdir -p $(DIST)

$(TESTENV): build-three
	virtualenv $(TESTENV) --python=python3
	source '${TESTENV}'/bin/activate && pip install $(DIST)/*py3* unittest2

.py2-env: Pipfile Pipfile.lock
	- rm .py3-env
	pipenv --two install -d
	touch "$@"

.py3-env: Pipfile Pipfile.lock
	- rm .py2-env
	pipenv --three install -d
	touch "$@"
