PROJECT = papt
VERSION = 0.1.0

PROGRAMS = papt-get
MAN1PAGES = $(PROGRAMS:=.1)

TARGETS = $(PROGRAMS) $(MAN1PAGES)

bindir = /usr/bin
mandir = $(datadir)/man
man1dir = $(mandir)/man1
man7dir = $(mandir)/man7
DESTDIR =

CP = cp -a
HELP2MAN1 = env "PATH=.:$$PATH" help2man -N -s1 -S '$(PROJECT) $(VERSION)'
INSTALL = install
MKDIR_P = mkdir -p
TOUCH_R = touch -r

.PHONY:	all install clean

all: $(TARGETS)

install: all
	$(MKDIR_P) -m755 $(DESTDIR)$(bindir)
	$(INSTALL) -pm755 $(PROGRAMS) $(DESTDIR)$(bindir)/

	$(MKDIR_P) -m755 $(DESTDIR)$(man1dir)
	$(INSTALL) -pm644 $(MAN1PAGES) $(DESTDIR)$(man1dir)/

clean:
	$(RM) $(TARGETS) *~

%: %.in
	sed \
		-e 's,@VERSION@,$(VERSION),g' \
		< $< > $@
	$(TOUCH_R) $< $@
	chmod --reference=$< $@

%.1: % %.1.inc
	$(HELP2MAN1) -i $@.inc $< > $@
