##
# Main Makefile for the Jarvis Lake library.

# make must forget all it knows about suffixes.
.SUFFIXES:

# Tools.
MAKE := make --no-print-directory -s -k -j8
RM := rm -f
MKDIR := mkdir -p
RMDIR := rmdir
ECHO := echo

ifeq ($O,)
# Local build.
.PHONY: all
all:
	+@$(MAKE) -f Makeconf

%: force
	+@$(MAKE) -f Makeconf $@

.PHONY: force
force:
else
# Remote build.
.PHONY: all
all: $O
	+@$(MAKE) -C $O -f $(CURDIR)/Makeconf ROOTDIR=$(CURDIR)

%: $O
	+@$(MAKE) -C $O -f $(CURDIR)/Makeconf ROOTDIR=$(CURDIR) $@

clean:
	@$(MAKE) -C $O -f $(CURDIR)/Makeconf ROOTDIR=$(CURDIR) clean
	@$(RMDIR) $O/src $O/util $O/tools $O/test $O

.PHONY: $O
$O:
	@$(MKDIR) $@/src $@/util $@/tools $@/test
endif

.PHONY: help
help:
	@$(ECHO) "make                            - Build everything"
	@$(ECHO) "make clean                      - Clean everything"
	@$(ECHO) "make <dir>                      - Build all in dir"
	@$(ECHO) "make <dir/target>               - Build specified target only"
	@$(ECHO) ""
	@$(ECHO) "make O=<dest> [<target>]        - Put all output files in dest"
	@$(ECHO) "make OPT=<opt level> [<target>] - Set optimization level (default -O3)"
	@$(ECHO) "make PM= [<target>]             - Build for a PM platform (default based on build platform)"
	@$(ECHO) "make PM=-DNOPM [<target>]       - Build for a legacy platform"
	@$(ECHO) "make WERROR= [<target>]         - Do not treat warnings as errors"
	@$(ECHO) "make WERROR=-Werror [<target>]  - Treat warnings as errors (default)"

# Don't attempt to rebuild this Makefile.
Makefile : ;
