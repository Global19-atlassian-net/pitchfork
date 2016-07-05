# This file must not include bootstrap.mk,
# else inifinite loop.
override SELF_DIR:=$(dir $(lastword $(MAKEFILE_LIST)))
override PFHOME:=$(CURDIR)
-include $(SELF_DIR)/../settings.mk
include $(SELF_DIR)/config.mk

init: sanity
	mkdir -p "$(WORKDIR)"
	mkdir -p "$(DISTFILES)"
	mkdir -p "$(STAGING)"
	mkdir -p "$(PREFIX)/bin"
	mkdir -p "$(PREFIX)/etc"
	mkdir -p "$(PREFIX)/include"
	mkdir -p "$(PREFIX)/lib"
	mkdir -p "$(PREFIX)/lib/pkgconfig"
	mkdir -p "$(PREFIX)/share"
	mkdir -p "$(PREFIX)/var/pkg"
ifeq ($(OPSYS),Darwin)
	echo "export DYLD_LIBRARY_PATH=$(PREFIX)/lib:\$$DYLD_LIBRARY_PATH"|sed -e 's/::*/:/g' > "$(PREFIX)/setup-env.sh"
else
	echo "export   LD_LIBRARY_PATH=$(PREFIX)/lib:\$$LD_LIBRARY_PATH"  |sed -e 's/::*/:/g' > "$(PREFIX)/setup-env.sh"
endif
	echo "export PATH=$(PREFIX)/bin:\$$PATH"|sed -e 's/::*/:/g' >> "$(PREFIX)/setup-env.sh"
	echo "unset PYTHONPATH"


ifeq ($(OPSYS),Darwin)
_tmpvar:=$(if $(shell which $(MD5SUM)),exists,$(error "unable to run md5sum, consider doing brew install md5sha1sum"))
#else ifeq ($(OPSYS),FreeBSD)
#_tmpvar:=$(if $(shell which $(MD5SUM)),exists,$(error "unable to run md5sum, consider doing pkg install coreutils"))
else
_tmpvar:=$(if $(shell which $(MD5SUM)),exists,$(error "unable to run md5sum, consider doing yum install coreutils"))
endif

sanity:
	$(PFHOME)/bin/checkSystem
	$(PFHOME)/bin/checkCC $(CC)

# utils
_startover::
	@echo "This will erase everything in $(PREFIX)/, staging/ and "$(WORKDIR)/" directories."
	@read -p "Are you sure? " -n 1 -r; \
        echo; \
        if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
           set -x; \
           rm -rf $(PREFIX)/* $(PREFIX)/.Python staging/* "$(WORKDIR)"/* ports/*/*/*.log; \
           test -d "$(WORKDIR)/.git/pip/wheels" && \
	   find "$(WORKDIR)/.git/pip/wheels" -type f ! -name '*none-any.whl' -print -delete || true; \
        fi

.PHONY: init sanity
