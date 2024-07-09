# Disable parallel Makefile execution
#
# We do not support parallel make.  We have found most
# parallel make systems do not get the rule dependency order
# correct, resulting in a failed attempt to compile.
#
.NOTPARALLEL:


# compile do-nothing jparse.c - hopefully placate the GitHub workflow for now
all: jparse.c
	${CC} jparse.c -o jparse

clean:
	@rm -vf jparse

clobber: clean

slow_prep:
	@exit 0

test:
	@exit 0
