# Global overrides
SHELL      = /bin/bash -e
CC         = gcc
CXX        = g++
FC         = gfortran
AR         = ar
GIT        = git
SED        = sed
CURL       = curl
CMAKE      = cmake
UNAME      = uname
MD5SUM     = md5sum
SHA1SUM    = sha1sum
PERL       = perl
SYSPYTHON ?= /usr/bin/python

PFHOME    := $(realpath ../../..)

-include $(PFHOME)/settings.mk

WORKDIR    ?= $(PFHOME)/workspace
PREFIX     ?= $(PFHOME)/deployment
STAGING    ?= $(PFHOME)/staging
CCACHE_DIR ?= $(PFHOME)/.git/ccache
PIP_CACHE  ?= $(PFHOME)/.git/pip
DISTFILES  ?= $(PFHOME)/distfiles

PIP         = $(PREFIX)/bin/pip --cache-dir $(PIP_CACHE)


ifneq ($(origin DEBUG),undefined)
    DEBUG=1
    VERBOSE=1
    export DEBUG
    export VERBOSE
endif

ARCH      := $(shell $(UNAME) -m)
OPSYS     := $(shell $(UNAME) -s)

CFLAGS    ?= -fPIC -I$(PREFIX)/include
CXXFLAGS  ?= $(CFLAGS)
LDFLAGS   ?= -L$(PREFIX)/lib

BOOST_ROOT = $(PREFIX)
HDF5_ROOT  = $(PREFIX)
ZLIB_ROOT  = $(PREFIX)

export CC
export CXX
export FC
export CFLAGS
export LDFLAGS
export CXXFLAGS
export CCACHE_DIR
export PATH              := $(PREFIX)/bin:$(PFHOME)/bin:${PATH}
export PKG_CONFIG_PATH   := $(PREFIX)/lib/pkgconfig

ifeq ($(OPSYS),Darwin)
    HAVE_PYTHON ?= /usr/bin/python
    HAVE_ZLIB ?= /usr
    DYLIB  = dylib
    export DYLD_LIBRARY_PATH := $(PREFIX)/lib:${DYLD_LIBRARY_PATH}
else
    DYLIB  = so
    export LD_LIBRARY_PATH   := $(PREFIX)/lib:${LD_LIBRARY_PATH}
endif

unexport PYTHONPATH
