.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

release:
	echo $(shell git rev-parse HEAD) > VERSION
	tar -czf dist/ansible-portable-$(shell git rev-parse HEAD).tar.gz {plugins,src,ansible*,VERSION}
	rm -f VERSION
