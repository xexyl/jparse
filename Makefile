#!/usr/bin/env make
#
# jparse - a JSON parser written in C
#
#  This JSON parser was co-developed in 2022 by:
#
#	@xexyl
#	https://xexyl.net		Cody Boone Ferguson
#	https://ioccc.xexyl.net
#  and:
#	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
#  "Because sometimes even the IOCCC Judges need some help." :-)
#
#  "Share and Enjoy!"
#      --  Sirius Cybernetics Corporation Complaints Division, JSON spec department. :-)

# XXX - This Makefile is incomplete until the jparse code is actually  - XXX
# XXX - populated. It is here only for the purpose of workflows and to - XXX
# XXX - test things as much as possible. - XXX
#
# XXX - It is hoped that this will be populated within the next few    - XXX
# XXX - months; at the time of writing this it is 09 July 2024         - XXX

#############
# utilities #
#############

# suggestion: List utility filenames, not paths.
#	      Do not list shell builtin (echo, cd, ...) tools.
#	      Keep the list in alphabetical order.
#
AR= ar
CC= cc
CHECKNR= checknr
CMP= cmp
CP= cp
CTAGS= ctags
GREP= grep
INDEPEND= independ
INSTALL= install
PICKY= picky
RANLIB= ranlib
RM= rm
SED= sed
SEQCEXIT= seqcexit
SHELL= bash
SHELLCHECK= shellcheck
SORT= sort


####################
# Makefile control #
####################

# The name of this directory
#
# This value is used to print the generic name of this directory
# so that various echo statements below can use this name
# to help distinguish themselves from echo statements used
# by Makefiles in other directories.
#
OUR_NAME= jparse

# echo-only action commands

# V= @:					do not echo debug statements (quiet mode)
# V= @					echo debug statements (debug / verbose mode)
#
V= @:
#V= @

# S= @:					do not echo start or end of a make rule (quiet mode)
# S= @					echo start or end of a make rule (debug / verbose mode)
#
#S= @:
S= @

# action commands that are NOT echo

# Q= @					do not echo internal Makefile actions (quiet mode)
# Q=					echo internal Makefile actions (debug / verbose mode)
#
#Q=
Q= @

# E= @					do not echo calling make in another directory (quiet mode)
# E=					echo calling make in another directory (debug / verbose mode)
#
E=
#E= @

# I= @					do not echo install commands (quiet mode)
# I=					echo install commands (debug / verbose mode
#
I=
#I= @

# other Makefile control related actions

# Q= implies -v 0
# else -v 1
#
ifeq ($(strip ${Q}),@)
Q_V_OPTION="0"
else
Q_V_OPTION="1"
endif

# INSTALL_V=				install w/o -v flag (quiet mode)
# INSTALL_V= -v				install with -v (debug / verbose mode
#
#INSTALL_V=
INSTALL_V= -v

# MAKE_CD_Q= --no-print-directory	silence make cd messages (quiet mode)
# MAKE_CD_Q=				silence make cd messages (quiet mode)
#
MAKE_CD_Q= --no-print-directory
#MAKE_CD_Q=

# Disable parallel Makefile execution
#
# We do not support parallel make.  We have found most
# parallel make systems do not get the rule dependency order
# correct, resulting in a failed attempt to compile.
#
.NOTPARALLEL:

######################################
# all - default rule - must be first #
######################################
# compile do-nothing jparse.c for now
all: jparse.c Makefile
	${CC} jparse.c -o jparse

#################################################
# .PHONY list of rules that do not create files #
#################################################
.PHONY: all \
	extern_include extern_objs extern_liba extern_man extern_prog extern_everything man/man1/jparse.1 man/man8/jparse_test.8 \
	parser parser-o use_json_ref rebuild_jnum_test bison flex test tags local_dir_tags all_tags check_man \
	legacy_clean legacy_clobber load_json_ref install_man \
	configure clean clobber install depend


# XXX - update this when jparse code populated - XXX
clean:
	@rm -vf jparse

# XXX - update this when jparse code populated - XXX
clobber: clean
	@:

# XXX - update this when jparse code populated - XXX
slow_prep:
	@echo "Nothing to do yet."

# XXX - update this when jparse code populated - XXX
prep:
	@echo "Nothing to do yet."

# XXX - update this when jparse code populated - XXX
install:
	@echo "Nothing to install."

# XXX - update this when jparse code populated - XXX
test:
	@echo "Nothing to test yet."
