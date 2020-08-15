.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

.PHONY: release
version=$(shell git rev-parse HEAD)
release:
	echo $(version) > VERSION
	mkdir -p dist/$(version)
	tar -czf dist/$(version)/ansible-portable.tar.gz --exclude-vcs --exclude-vcs-ignores {plugins,src,ansible*,VERSION}
	rm -f VERSION
