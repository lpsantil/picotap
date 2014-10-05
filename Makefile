DEST ?=
PREFIX ?= /usr/local

CFLAGS = -Os -Wall -ansi -pedantic
LDFLAGS = -s
DDIR = docs
DSRC =
SRC = $(shell ls src/*.c)
HDR = tap.h
IDIR = inc
INC = $(IDIR)/$(HDR)
OBJ = $(SRC:.c=.o)
LNK = ptap
EDIR = .
EXE = ptap
LDIR = .
LSRC = $(shell ls lib/*.c)
LOBJ = $(LSRC:.c=.o)
LIB = $(LDIR)/lib$(LNK).a
TDIR = t
TSRC = $(shell ls t/*.c)
TOBJ = $(TSRC:.c=.o)
TEXE = $(TOBJ:.o=.exe)

.c.o:
	$(CC) $(CFLAGS) -I$(IDIR) -c $< -o $@

all: $(LIB) $(EXE)
# all: $(LIB)
# all: $(EXE)

$(OBJ): Makefile $(INC)

$(LOBJ): Makefile $(INC)

$(LIB): $(LOBJ)
	$(AR) -rcs $@ $^

$(EXE): $(OBJ)
	$(CC) $^ -L$(LDIR) -l$(LNK) $(LDFLAGS) -o $(EDIR)/$@

t/%.exe: t/%.o
	$(CC) $< -L$(LDIR) -l$(LNK) $(LDFLAGS) -o $@

test: $(TEXE)

$(TOBJ): $(LIB)

$(TEXE): $(TOBJ)

runtest: $(TEXE)
	for T in $^ ; do ( $$T ; echo ) ; done

runtap: $(TEXE)
	for T in $^ ; do ( ./ptap $$T ; echo ) ; done

clean:
	rm -f $(OBJ) $(EXE) $(LOBJ) $(LIB) $(TOBJ) $(TEXE)

install:
	mkdir -p $(DEST)/$(PREFIX)/bin $(DEST)/$(PREFIX)/include $(DEST)/$(PREFIX)/lib
	cp $(INC) $(DEST)/$(PREFIX)/include/
	cp $(LIB) $(DEST)/$(PREFIX)/lib/
	cp $(EXE) $(DEST)/$(PREFIX)/bin

showconfig:
	@echo "DEST="$(DEST)
	@echo "PREFIX="$(PREFIX)
	@echo "CFLAGS="$(CFLAGS)
	@echo "LDFLAGS="$(LDFLAGS)
	@echo "DDIR="$(DDIR)
	@echo "DSRC="$(DSRC)
	@echo "SRC="$(SRC)
	@echo "HDR="$(HDR)
	@echo "IDIR="$(IDIR)
	@echo "INC="$(INC)
	@echo "OBJ="$(OBJ)
	@echo "LDIR="$(LDIR)
	@echo "LSRC="$(LSRC)
	@echo "LOBJ="$(LOBJ)
	@echo "LNK="$(LNK)
	@echo "LIB="$(LIB)
	@echo "EDIR="$(EDIR)
	@echo "EXE="$(EXE)
	@echo "TSRC="$(TSRC)
	@echo "TOBJ="$(TOBJ)
	@echo "TEXE="$(TEXE)

