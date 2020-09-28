# Copyright (c) 2020, Louis P. Santillan <lpsantil@gmail.com>
# All rights reserved.
# See LICENSE for licensing details.

DESTDIR ?= /usr/local

######################################################################
# Core count
CORES ?= 1

# Basic feature detection
#OS = $(shell ( cat /etc/os-release | grep "rhel\|fedora\|centos" && echo "rhel" ) || cat /etc/os-release | grep "debian\|ubuntu" && echo "debian" || uname)
OS ?= $(shell uname)
ARCH ?= $(shell uname -m)

######################################################################
CFLAGS ?= -Os -Wall -std=gnu99 -pedantic
LDFLAGS ?= -s
#LDFLAGS ?= -s -nostdlib -Wl,--gc-sections

DDIR = docs
DSRC =
SRC = $(wildcard src/*.c)
OBJ = $(SRC:.c=.o)
SDEPS = $(SRC:.c=.d)
HDR = tap.h
IDIR = inc
INC = $(IDIR)/$(HDR)
EDIR = .
EXE = ptap.exe
LNK = ptap
LDIR = lib
LSRC = $(wildcard lib/*.c)
LOBJ = $(LSRC:.c=.o)
LSDEPS = $(LSRC:.c=.d)
LIB = $(LDIR)/lib$(LNK).a
TDIR = t
TSRC = $(wildcard t/*.c)
TOBJ = $(TSRC:.c=.o)
TSDEPS = $(TSRC:.c=.d)
TEXE = $(TOBJ:.o=.exe)
TAP ?= ./$(EXE)

#TMPCI = $(shell cat tmp.ci.pid 2>/dev/null)
#TMPCT = $(shell cat tmp.ct.pid 2>/dev/null)
#TMPCD = $(shell cat tmp.cd.pid 2>/dev/null)

#CILOG ?= tmp.ci.log

# DEPS
#DEPS =
#LIBDEP =

# TDEPS
#TDEPS =
#TAP =
#LIBTAP =

######################################################################
######################## DO NOT MODIFY BELOW #########################
######################################################################

.PHONY: all test runtest clean start_ci stop_ci start_ct stop_ct
.PHONY: start_cd stop_cd install uninstall showconfig gstat gpush
.PHONY: help p-* tarball

.c.o:
	$(CC) $(CFLAGS) -MMD -MP -I$(IDIR) -c $< -o $@

#%.o: %.c $(INC) Makefile
%.o: %.c $(INC) Makefile
	$(CC) $(CFLAGS) -MMD -MP -I$(IDIR) -c $< -o $@

t/%.exe: t/%.o $(LIB) Makefile
	$(LD) -L$(LDIR) -l$(LNK) $(LDFLAGS) $< -o $@

all: $(LIB) $(EXE)

$(LIB): $(LOBJ)
	$(AR) -rcs $@ $^

$(EXE): $(OBJ)
	$(LD) $^ $(LDFLAGS) -o $(EDIR)/$@

test: $(SYSINC) $(LIB) $(TEXE) Makefile

runtest: $(TEXE)
	for T in $^ ; do $(TAP) $$T ; done

#start_ci:
#	( watch time -p make clean all ) &> $(CILOG) & echo $$! > tmp.ci.pid

#stop_ci:
#	kill -9 $(TMPCI)

#start_ct:
#	watch time -p make test & echo $$! > tmp.ct.pid

#stop_ct:
#	kill -9 $(TMPCT)

#start_cd:
#	watch time -p make install & echo $$! > tmp.cd.pid

#stop_cd:
#	kill -9 $(TMPCD)

clean:
	rm -fv $(OBJ) $(EXE) $(LOBJ) $(LIB) $(TOBJ) $(TEXE) $(SYSINC) *.tmp $(SDEPS) $(LSDEPS) $(TSDEPS)

#install: $(INC) $(LIB)
install: $(INC) $(LIB) $(EXE)
#	mkdir -pv $(DESTDIR)/$(PREFIX)/{bin,include,lib}
#	rm -fv .footprint
#	echo $(DESTDIR)/$(PREFIX)/include >> .footprint;
#	cp -pv $(INC) $(LIB) $(EXE) $(DEST)/$(PREFIX)/

uninstall: .footprint
	@for T in `cat .footprint`; do rm -v $$T; done

-include $(SDEPS) $(LSDEPS) $(TSDEPS)

showconfig: p-OS p-ARCH p-DESTDIR p-PREFIX p-CC p-LD p-AR p-CFLAGS p-LDFLAGS p-DDIR p-DSRC p-SRC p-OBJ p-SDEPS p-HDR p-IDIR p-INC p-EDIR p-EXE p-LNK p-LDIR p-LSRC p-LOBJ p-LSDEPS p-LIB p-TDIR p-TSRC p-TOBJ p-TSDEPS p-TEXE p-TAP

gstat:
	git status

gpush:
	git commit
	git push

tarball:
	cd ../. && tar jcvf tokens.c.$(shell date +%Y%m%d%H%M%S).tar.bz2 tokens.c

define newline # a literal \n


endef
# Makefile debugging trick:
# call print-VARIABLE to see the runtime value of any variable
# (hardened a bit against some special characters appearing in the output)
p-%:
	@echo '$*=$(subst ','\'',$(subst $(newline),\n,$($*)))'
.PHONY: p-*

help: ## This help target
	@awk '/^[a-zA-Z0-9\-_+. ]*: #{2}/ { print; }' $(MAKEFILE_LIST)
