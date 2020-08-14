.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

release:
	echo $(shell git rev-parse HEAD) > VERSION
	tar -czf dist/ansible-portable-$(shell git rev-parse HEAD).tar.gz --exclude-vcs --exclude-vcs-ignores {plugins,src,ansible*,VERSION}
	rm -f VERSION
