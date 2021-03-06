include Makefile.inc

ifeq "ghc" "$(findstring ghc, ${HC})"
  ifeq "606" "${GHCSYM}"
HMAKEFLAGS = -I. -I$(INCDIR) -fglasgow-exts -package base -package readline \
		 -DUSE_READLINE=1 $(shell echo $(BUILDOPTS)) -prof -auto-all \
		 -fno-warn-missing-methods -fno-warn-missing-fields
  else
HMAKEFLAGS = -I. -I$(INCDIR) -fglasgow-exts -package base -package readline \
		 -package containers \
		 -DUSE_READLINE=1 $(shell echo $(BUILDOPTS)) -prof -auto-all \
		 -fno-warn-missing-methods -fno-warn-missing-fields
  endif
else
HMAKEFLAGS = -I. -I$(INCDIR) -package containers -package base \
		+CTS -H8M -CTS -K10M \
		$(shell echo $(BUILDOPTS))
endif

ifeq "glib" "$(GLIB)"
GLIB_CFLAGS = $(shell glib-config --cflags)
GLIB_LINK   = $(shell glib-config --libs)
else
GLIB_CFLAGS = 
GLIB_LINK   =
endif

OBJDIR	= ${BUILDDIR}/${OBJ}/tools
DEST	= $(LIBDIR)/$(MACHINE)

COMMONLIBS = pathutils.c artutils.c finitemap.c
OBSERVLIBS = hat-names.c observeutils.c
DETECTLIBS = parentset.c detectutils.c
NOTERMLIBS = nontermutils.c
#MALCLIBS = pathutils.c artutils.c hat-names.c observeutils.c parentset.c newdetect.c
THORLIBS = detect.c hashtable.c

COMMONOBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(COMMONLIBS))
OBSERVOBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(OBSERVLIBS))
DETECTOBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(DETECTLIBS))
NOTERMOBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(NOTERMLIBS))
ALLCOBJS   = $(COMMONOBJS) $(OBSERVOBJS) $(DETECTOBJS) $(NOTERMOBJS)
#MALCOBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(MALCLIBS))
THOROBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(THORLIBS))


PROGNAMES = hat-check hat-stack hat-view hat-trail hat-observe hat-detect \
	hat-anim hat-explore hat-cover black-hat hat-nonterm pretty-hat \
	hat-delta
PROGS     = $(patsubst %, $(DEST)/%, $(PROGNAMES))

all: $(OBJDIR) $(PROGS)
objdir: $(OBJDIR)
clean:
	rm -f $(ALLCOBJS)
	hmake -realclean -hc=$(HC) -d$(OBJDIR) \
		HatObserve HatTrail HatDetect HatStackText HatExplore HatCoverText \
		SrcRefViewer HatAnim BlackHat HatNonTerm PrettyHat
realclean: clean
	rm -f $(PROGS)
$(OBJDIR):
	mkdir -p $(OBJDIR)

VERSIONING = -DVERSION="\"$(HATVERSION)\"" -DFILEVERSION="\"$(HATFILEVERSION)\""


# libraries and tools
$(ALLCOBJS) : $(OBJDIR)/%.o : %.c
	$(CC) $(OPT) -I$(INCDIR) $(shell echo $(BUILDOPTS)) \
		$(VERSIONING) -c $< -o $@ $(GLIB_CFLAGS)
$(OBJDIR)/artutils.o: artutils.h pathutils.h
$(OBJDIR)/observeutils.o: artutils.h observeutils.h finitemap.h checkglib.h
$(OBJDIR)/finitemap.o: finitemap.h checkglib.h
$(OBJDIR)/hat-names.o: artutils.h finitemap.h checkglib.h
$(OBJDIR)/parentset.o: parentset.h
$(OBJDIR)/detectutils.o: artutils.h parentset.h
$(DEST)/hat-stack-c: hat-stack.c artutils.h $(COMMONOBJS)
	$(CC) $(OPT) -I$(INCDIR) hat-stack.c $(COMMONOBJS) -o $(DEST)/hat-stack\
		$(GLIB_LINK)
$(DEST)/hat-trail: HatTrail.hs LowLevel.hs SExp.hs PrettyLibHighlight.hs \
			HighlightStyle.hs Run.hs FFIExtensions.hs Ident.hs \
			CommonUI.hs SrcRef.hs $(COMMONOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatTrail $(COMMONOBJS) \
		-d$(OBJDIR) $(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatTrail$(EXE) $(DEST)/hat-trail$(EXE)
$(DEST)/hat-stack: HatStackText.hs HatStack.hs LowLevel.hs SExp.hs PrettyLibHighlight.hs \
			HighlightStyle.hs FFIExtensions.hs Ident.hs SrcRef.hs \
			$(COMMONOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatStackText $(COMMONOBJS) \
		-d$(OBJDIR) $(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatStackText$(EXE) $(DEST)/hat-stack$(EXE)
$(DEST)/hat-cover: HatCover.hs HatCoverText.hs LowLevel.hs FFIExtensions.hs SrcRef.hs \
			HighlightStyle.hs $(COMMONOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatCoverText $(COMMONOBJS) \
		-d$(OBJDIR) $(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatCoverText$(EXE) $(DEST)/hat-cover$(EXE)

$(DEST)/hat-view: SrcRefViewer.hs HighlightStyle.hs Run.hs
	hmake -hc=$(HC) $(HMAKEFLAGS) SrcRefViewer \
		-d$(OBJDIR) $(shell echo $(LIBCOMPAT))
	mv $(OBJDIR)/SrcRefViewer$(EXE) $(DEST)/hat-view$(EXE)
$(DEST)/hat-observe: HatObserve.hs Observe.hs LowLevel.hs SExp.hs Ident.hs \
			PrettyLibHighlight.hs HighlightStyle.hs Run.hs \
			FFIExtensions.hs Pattern.hs ParseLib.hs Idents.hs \
			CmdLine.hs CommonUI.hs SrcRef.hs \
			$(COMMONOBJS) $(OBSERVOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatObserve \
		$(COMMONOBJS) $(OBSERVOBJS) -d$(OBJDIR) \
		$(shell echo $(LIBCOMPAT)) $(GLIB_CFLAGS) $(GLIB_LINK)
	mv $(OBJDIR)/HatObserve$(EXE) $(DEST)/hat-observe$(EXE)
$(DEST)/hat-detect: HatDetect.hs Detect.hs LowLevel.hs SExp.hs Ident.hs \
			PrettyLibHighlight.hs HighlightStyle.hs Run.hs \
			FFIExtensions.hs CmdLine.hs CommonUI.hs SrcRef.hs \
			NodeExp.hs EDT.hs \
			$(COMMONOBJS) $(DETECTOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatDetect \
		$(COMMONOBJS) $(DETECTOBJS) -d$(OBJDIR) \
		$(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatDetect$(EXE) $(DEST)/hat-detect$(EXE)


# Olaf's experimental tool
$(DEST)/hat-explore: HatExplore.hs HighlightStyle.hs Run.hs LowLevel.hs\
			HighlightStyle.hs FFIExtensions.hs Ident.hs SrcRef.hs \
			$(COMMONOBJS) $(DETECTOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatExplore \
		$(COMMONOBJS) $(DETECTOBJS) -d$(OBJDIR) \
		$(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatExplore$(EXE) $(DEST)/hat-explore$(EXE)


# Colin's tools
$(DEST)/hat-check: hat-check.c
	$(CC) hat-check.c -o $(DEST)/hat-check -I$(INCDIR) $(VERSIONING) \
		$(shell echo $(BUILDOPTS)) $(shell echo $(LIBCOMPAT))


# Thorsten's libraries and tools
$(THOROBJS) : $(OBJDIR)/%.o : %.c
	$(CC) -c -o $@ $<

$(OBJDIR)/hashtable.o: hashtable.h
#$(OBJDIR)/detect.o : detect.h FunTable.h hatinterface.h Expressions.h nodelist.h hashtable.h

# Tom Davie's tools
$(DEST)/hat-anim: HatAnim.hs NodeExp.hs $(COMMONOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatAnim \
		$(COMMONOBJS) $(DETECTOBJS) -d$(OBJDIR) \
		$(shell echo $(LIBCOMPAT))
	mv $(OBJDIR)/HatAnim$(EXE) $(DEST)/hat-anim$(EXE)
$(DEST)/pretty-hat: PrettyHat.hs Pretty.hs NodeExp.hs EDT.hs $(COMMONOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) PrettyHat \
		$(COMMONOBJS) $(DETECTOBJS) -d$(OBJDIR) \
		$(shell echo $(LIBCOMPAT))
	mv $(OBJDIR)/PrettyHat$(EXE) $(DEST)/pretty-hat$(EXE)
$(DEST)/hat-delta: HatDelta.hs Detect.hs LowLevel.hs SExp.hs Ident.hs \
			PrettyLibHighlight.hs HighlightStyle.hs Run.hs \
			FFIExtensions.hs CmdLine.hs CommonUI.hs SrcRef.hs \
			NodeExp.hs ADT.hs EDT.hs FDT.hs Slice.hs \
			$(COMMONOBJS) $(DETECTOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatDelta \
		$(COMMONOBJS) $(DETECTOBJS) -d$(OBJDIR) \
		$(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatDelta$(EXE) $(DEST)/hat-delta$(EXE)

# Mike Dodds tools
$(DEST)/black-hat: BlackHat.hs LowLevel.hs SExp.hs PrettyLibHighlight.hs \
		HighlightStyle.hs Run.hs FFIExtensions.hs NonTermLib.hs \
		$(COMMONOBJS) $(NOTERMOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) BlackHat $(COMMONOBJS) $(NOTERMOBJS) \
		-d$(OBJDIR) $(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/BlackHat$(EXE) $(DEST)/black-hat$(EXE)
$(DEST)/hat-nonterm: HatNonTerm.hs LowLevel.hs SExp.hs PrettyLibHighlight.hs \
		HighlightStyle.hs Run.hs FFIExtensions.hs NonTermLib.hs \
		$(COMMONOBJS) $(NOTERMOBJS)
	hmake -hc=$(HC) $(HMAKEFLAGS) HatNonTerm $(COMMONOBJS) $(NOTERMOBJS) \
		-d$(OBJDIR) $(shell echo $(LIBCOMPAT)) $(GLIB_LINK)
	mv $(OBJDIR)/HatNonTerm$(EXE) $(DEST)/hat-nonterm$(EXE)
