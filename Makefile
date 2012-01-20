# Default definitions filled in by config script, included from Makefile.inc
include Makefile.inc
.SUFFIXES: 		# To remove default rules like .cpp -> C++

BASIC = Makefile.inc Makefile README INSTALL COPYRIGHT configure

HATSCRIPT = script/harch script/hat-trans.inst script/hat-template.inst \
		script/echo.c script/confhat script/confhc-hat script/fixghc \
		script/hat-graph.inst script/pkgdirlist \
		src/Makefile.inc include/*.h
HATLIB  = src/lib/Makefile* src/lib/*.[ch] \
	  src/lib/*.hs      src/lib/*.hx     src/lib/hat.cabal \
	  src/lib/Hat/*.hs  src/lib/hat-package.conf
#          src/lib/Data/*.h[sx]        src/lib/Hat/Data/*.hs \
#          src/lib/Control/*.hs        src/lib/Control/Monad/*.hs \
#          src/lib/System/*.hs         src/lib/System/IO/*.hs \
#          src/lib/System/Console/*.hs src/lib/Debug/*.hs \
#          src/lib/Text/*.hs           src/lib/Text/PrettyPrint/*.hs \
#          src/lib/Text/ParserCombinators/*.hs \
#          src/lib/Text/ParserCombinators/Parsec/*.hs \
#	  src/lib/Test/*.hs \
#          src/lib/Foreign/*.h[sx]     src/lib/Hat/Foreign/*.hs \
#          src/lib/Foreign/Marshal/*.hs #src/hat/lib/Foreign/C/*.hs
HATUI	= src/tools/Makefile* src/tools/*.[ch] src/tools/*.hs
HATTRANS= src/trans/Makefile* \
	$(shell hmake -package base -package packedstring -M HatTrans.hs \
		-Isrc/trans -Isrc/compiler98 \
		| cut -d':' -f1 | sed -e 's/\.o$$/.hs/' | sed -e '/^. /d' )
DOC = docs/*
MAN = man/*.1.in man/*.1
HATTOOLSET= hat-stack hat-check hat-detect hat-delta hat-anim hat-observe \
		hat-trail hat-view 
HATTOOLS= $(patsubst %, lib/$(MACHINE)/%, $(HATTOOLSET))

TARGDIR= targets
TARGETS= hat-trans-ghc hat-trans-nhc \
	 hat-lib-nhc hat-lib-ghc \
	 hat-tools-ghc hat-tools-nhc

.PHONY: default all hat help config install hat-trans hat-lib hat-tools


##### build + install scripts

default: hat
hat:     hat-$(BUILDCOMP)
all:     hat-$(BUILDCOMP) hat-lib-ghc hat-lib-nhc
hat-$(BUILDCOMP): hat-trans-$(BUILDCOMP) hat-tools-$(BUILDCOMP) \
			hat-lib-$(BUILDCOMP)
hat-trans: hat-trans-${BUILDCOMP}
hat-lib:   hat-lib-${BUILDCOMP}
hat-tools: hat-tools-${BUILDCOMP}
help:
	@echo "Default target is:     hat"
	@echo "Main targets include:  hat hat-trans hat-lib hat-tools "
	@echo "                       all (= for ghc + nhc98)"
	@echo "                       config install clean realclean"
	@echo "For a specific build-compiler: hat-ghc hat-nhc"

config:
	./configure --config
install:
	./configure --install



$(TARGETS): % : $(TARGDIR)/$(MACHINE)/%

$(TARGDIR)/$(MACHINE)/hat-trans-nhc: $(HATTRANS)
	cd src/trans;     $(MAKE) HC=$(BUILDWITH) all
	touch $(TARGDIR)/$(MACHINE)/hat-trans-nhc
$(TARGDIR)/$(MACHINE)/hat-trans-ghc: $(HATTRANS)
	cd src/trans;     $(MAKE) HC=$(BUILDWITH) all
	touch $(TARGDIR)/$(MACHINE)/hat-trans-ghc

$(TARGDIR)/$(MACHINE)/hat-lib-nhc: $(HATLIB)
	cd src/lib;	       $(MAKE) HC=$(BUILDWITH) all
	touch $(TARGDIR)/$(MACHINE)/hat-lib-nhc
$(TARGDIR)/$(MACHINE)/hat-lib-ghc: $(HATLIB)
	cd src/lib;	       $(MAKE) HC=$(BUILDWITH) all
	touch $(TARGDIR)/$(MACHINE)/hat-lib-ghc

$(TARGDIR)/$(MACHINE)/hat-tools-nhc: $(HATUI)
	cd src/tools;      $(MAKE) HC=$(BUILDWITH) all
	touch $(TARGDIR)/$(MACHINE)/hat-tools-nhc
$(TARGDIR)/$(MACHINE)/hat-tools-ghc: $(HATUI)
	cd src/tools;      $(MAKE) HC=$(BUILDWITH) all
	touch $(TARGDIR)/$(MACHINE)/hat-tools-ghc



##### scripts for packaging various distribution formats

binDist:


srcDist:
	rm -f hat-$(HATVERSION).tar hat-$(HATVERSION).tar.gz
	tar cf hat-$(HATVERSION).tar $(BASIC)
	tar rf hat-$(HATVERSION).tar $(HATSCRIPT)
	tar rf hat-$(HATVERSION).tar $(HATTRANS)
	tar rf hat-$(HATVERSION).tar $(HATLIB)
	tar rf hat-$(HATVERSION).tar $(HATUI)
	tar rf hat-$(HATVERSION).tar $(MAN)
	tar rf hat-$(HATVERSION).tar $(DOC)
	mkdir hat-$(HATVERSION)
	cd hat-$(HATVERSION); tar xf ../hat-$(HATVERSION).tar
	tar cf hat-$(HATVERSION).tar hat-$(HATVERSION)
	rm -r hat-$(HATVERSION)
	gzip hat-$(HATVERSION).tar


##### cleanup

clean:
	cd src/trans;       $(MAKE) clean
	cd src/lib;         $(MAKE) clean
	cd src/tools;       $(MAKE) clean
	rm -rf $(BUILDDIR)/obj*			# all object files

realclean: clean
	cd src/trans;          $(MAKE) realclean
	cd $(TARGDIR)/$(MACHINE);  rm -f $(TARGETS)
	cd $(TARGDIR)/$(MACHINE);  rm -f config.cache
	rm -rf $(LIBDIR)/$(MACHINE)
