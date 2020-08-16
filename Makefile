.PHONY: all
all: install

.PHONY: install
install:
	./install.sh

.PHONY: clean
clean:
	rm -rf src/ansible/*
	rm -rf plugins/{filters,lookup}
	rm -rf dist/*

.PHONY: release
release:
ifeq ($(RELEASE_VERSION),)
	$(error "You must define RELEASE_VERSION")
endif
ifeq (,$(wildcard src/ansible/__main__.py))
	$(MAKE) install
endif
	mkdir -p dist/$(RELEASE_VERSION)
	cp -rf {plugins,src,ansible*} dist/$(RELEASE_VERSION)
	echo -e "$(RELEASE_VERSION)\n$(shell git rev-parse HEAD)" > dist/$(RELEASE_VERSION)/RELEASE
	tar -czf dist/ansible-portable-$(RELEASE_VERSION).tar.gz --exclude-vcs --exclude-vcs-ignores -C dist/$(RELEASE_VERSION) .
	sha1sum dist/ansible-portable-$(RELEASE_VERSION).tar.gz | awk '{print $$1}' > dist/ansible-portable-$(RELEASE_VERSION).checksum
