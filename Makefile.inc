### Configurable variables:

OPT = -O3

# CC = actually sourced from LIBDIR/MACHINE/config
INSTALL = cp
AR = ar
LD = ld
STRIP = strip


HATVERSION = 2.06
# HATVERSION is the version number for hat.
#   (odd minor number = darcs version;  even minor number = release version)

HATFILEVERSION = 2.04
# HATFILEVERSION is now a separate number for the hat file format

### End of configurable variables

ifeq "" "${MKDIR}"
MKDIR:=$(shell pwd)
#MKDIR:=$(PWD)
endif

TOPDIR := $(MKDIR)
MACHINE = $(shell $(TOPDIR)/script/harch)
export MACHINE

CYG = $(findstring CYGWIN, $(MACHINE))
ifeq "CYGWIN" "${CYG}"
  TOPDIR := $(shell cygpath -w $(TOPDIR) | tr '\\\\' '/' )
endif


OBJ=obj$(CFG)
INCDIR=$(TOPDIR)/include
SRCDIR=$(TOPDIR)/src
LIBDIR=$(TOPDIR)/lib
LOCAL=$(TOPDIR)/script/
DST=$(LIBDIR)/$(MACHINE)
export LOCAL

### This is a very important step: get the local configuration
include $(DST)/config
###

ifeq "" "${BUILDBASEDIR}"
BUILDBASEDIR:=/tmp
endif
# ifeq "CYGWIN" "${CYG}"
#   BUILDDIR = $(shell echo `cygpath -w $(BUILDBASEDIR)/$(MACHINE)` | tr '\\' '/')
# else
BUILDDIR = $(BUILDBASEDIR)/$(MACHINE)
# endif

HC = $(BUILDWITH)
export HC

BUILDCOMP := $(shell basename $(BUILDWITH) | cut -c1-3 )
CPP = $(CC) -E -x c

