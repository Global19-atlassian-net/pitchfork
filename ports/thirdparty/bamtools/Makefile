include ../../../mk/pitchfork.mk

# Local variables
_NAME   = bamtools-2.5.1
_URL    = https://github.com/pezmaster31/bamtools/archive
_WRKSRC = $(WORKDIR)/$(_NAME)
_FILE   = v2.5.1.tar.gz

# Local works
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-build: $(_WRKSRC)/bin/bamtools
$(_WRKSRC)/bin/bamtools: | do-extract
	mkdir -p $(_WRKSRC)/build
	(cd $(_WRKSRC)/build && \
        $(CMAKE) \
            -DCMAKE_C_FLAGS_RELEASE="$(CFLAGS)" \
            -DCMAKE_CXX_FLAGS_RELEASE="$(CXXFLAGS)" \
            -DCMAKE_SHARED_LINKER_FLAGS="$(LDFLAGS)" \
            -DCMAKE_EXE_LINKER_FLAGS="$(LDFLAGS)" \
            -DCMAKE_INSTALL_PREFIX=$(STAGING)/$(_NAME) \
        .. )
	$(MAKE) -C $(_WRKSRC)/build >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME) && mkdir -p $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC)/build install >& install.log || $(PFHOME)/bin/diewith install.log
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
do-clean: do-flush
do-distclean: do-flush
do-flush:
	rm -rf $(_WRKSRC)
	rm -f build.log install.log
