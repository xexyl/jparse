# compile do-nothing jparse.c - hopefully placate the GitHub workflow for now
all: jparse.c
	${CC} jparse.c -o jparse
