include Makefile.inc


OBJDIR = ${BUILDDIR}/obj/trans
TARGET = ${DST}/hat-trans${EXE}

SRCS = \
	TraceDerive.hs TraceTrans.hs AuxLabelAST.hs AuxFixity.hs AuxFile.hs \
	AuxTypes.hs TraceId.hs Flags.hs PrettyTraceId.hs HatTrans.hs Wrapper.hs
COMPILERSRCS = \
	AssocTree.hs Error.hs Extra.hs HbcOnly.hs Id.hs IdKind.hs \
	Info.hs IntState.hs \
	Lex.hs LexLow.hs LexPre.hs LexStr.hs Lexical.hs \
	MergeSort.hs MkSyntax.hs NT.hs Nice.hs OsOnly.hs \
	Parse.hs Parse2.hs ParseCore.hs ParseLex.hs ParseLib.hs \
	PrettyLib.hs PrettySyntax.hs Reduce.hs \
	Syntax.hs SyntaxPos.hs SyntaxUtil.hs SysDeps.hs \
	TokenId.hs Tree234.hs Unlit.hs
COMPSRCS = $(patsubst %, ../compiler98/%, ${COMPILERSRCS})
OBJS = $(patsubst %.hs, $(OBJDIR)/%.$O, ${SRCS})


HC = nhc98	# can be overridden by caller with 'make HC=...'

ifeq "nhc98" "$(findstring nhc98, ${HC})"
HMAKEFLAGS := -H16M -K2M +CTS -H16M -CTS
endif
ifeq "ghc" "$(findstring ghc, ${HC})"
IMPROVE     = #-O
  ifeq "606" "${GHCSYM}"
HMAKEFLAGS := -package base $(IMPROVE) -fno-warn-deprecations -fno-warn-missing-fields -fno-warn-missing-methods
  else
HMAKEFLAGS := $(shell $(LOCAL)fixghc $(GHCSYM) -package lang -package base -package packedstring) $(IMPROVE) -fno-warn-deprecations -fno-warn-missing-fields -fno-warn-missing-methods
  endif
endif

HMAKEFLAGS += $(shell echo $(BUILDOPTS))


all: ${TARGET}
hat-trans: ${TARGET}
objdir: ${OBJDIR}
clean:
	rm -f $(OBJDIR)/*.$O *.$O *.hi *.hc
realclean: clean
	rm -f *.hc *.c $(TARGET)

$(TARGET): ${OBJDIR} $(OBJDIR)/$(HC) $(SRCS) $(COMPSRCS)
	hmake -hc=$(HC) $(HMAKEFLAGS) -d $(OBJDIR) -I. -I../compiler98 HatTrans
	mv $(OBJDIR)/HatTrans$(EXE) $(TARGET)
	$(STRIP) $(TARGET)
${OBJDIR}:
	mkdir -p ${OBJDIR}
$(OBJDIR)/$(HC):
	rm -f $(OBJDIR)/nhc98 $(OBJDIR)/hbc $(OBJDIR)/ghc*
	$(MAKE) clean
	touch "$(OBJDIR)/$(HC)"
 
.SUFFIXES: .hs .o .c

