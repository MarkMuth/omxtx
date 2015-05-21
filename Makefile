CC=gcc
LD=gcc

CFLAGS=-Wall -Wno-format -g -I/opt/vc/include/IL -I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux -DSTANDALONE -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS -DTARGET_POSIX -D_LINUX -D_REENTRANT -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -DHAVE_LIBOPENMAX=2 -DOMX -DOMX_SKIP64BIT -ftree-vectorize -pipe -DUSE_EXTERNAL_OMX -DHAVE_LIBBCM_HOST -DUSE_EXTERNAL_LIBBCM_HOST -DUSE_VCHIQ_ARM -L/usr/local/lib -I/usr/local/include
LDFLAGS=-Xlinker -L/opt/vc/lib/ -Xlinker -L/usr/local/lib -Xlinker -R/usr/local/lib # -Xlinker --verbose
LIBS=-lavformat -lavcodec -lavutil -lopenmaxil -lbcm_host -lvcos -lpthread
OFILES=$(BUILDDIR)/omxtx.o

BUILDDIR := build

.PHONY: all clean install dist

all: $(BUILDDIR)/omxtx | $(BUILDDIR)

$(BUILDDIR)/omxtx.o: | $(BUILDDIR)
	$(CC) $(CFLAGS) -c omxtx.c -o $(BUILDDIR)/omxtx.o

$(BUILDDIR)/omxtx: $(BUILDDIR)/omxtx.o | $(BUILDDIR)
	$(CC) $(LDFLAGS) $(LIBS) -o $(BUILDDIR)/omxtx $(OFILES)

$(BUILDDIR):
	mkdir $@
clean:
	rm -f $(BUILDDIR)/omxtx.o $(BUILDDIR)/omxtx
	rm -rf $(BUILDDIR)
	rm -rf dist

dist: clean
	mkdir dist
	cp omxtx.c Makefile dist
	FILE=omxtx-`date +%Y%m%dT%H%M%S`.tar.bz2 && tar cvf - --exclude='.*.sw[ponml]' dist | bzip2 > $$FILE && echo && echo $$FILE
