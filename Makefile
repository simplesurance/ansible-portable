.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

.PHONY: release
version=$(shell git rev-parse HEAD)
release:
	echo $(version) > VERSION
	tar -czf dist/ansible-portable-$(version).tar.gz --exclude-vcs --exclude-vcs-ignores {plugins,src,ansible*,VERSION}
	rm -f VERSION
