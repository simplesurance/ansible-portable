.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

release:
	tar -czf dist/ansible-portable-$(shell git rev-parse HEAD).tar.gz {plugins,src,ansible*}
