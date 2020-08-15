.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

.PHONY: release
commit=$(shell git rev-parse HEAD)
release:
	echo "$(RELEASE_VERSION)" > RELEASE
	echo "$(shell git rev-parse HEAD)" >> RELEASE
	mkdir -p dist/$(RELEASE_VERSION)
	tar -czf dist/$(RELEASE_VERSION)/ansible-portable.tar.gz --exclude-vcs --exclude-vcs-ignores {plugins,src,ansible*,RELEASE}
	rm -f RELEASE
