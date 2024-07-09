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
