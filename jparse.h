/*
 * jparse - JSON parser
 *
 * "Because specs w/o version numbers are forced to commit to their original design flaws." :-)
 *
 * This JSON parser was co-developed in 2022 by:
 *
 *	@xexyl
 *	https://xexyl.net		Cody Boone Ferguson
 *	https://ioccc.xexyl.net
 * and:
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * "Because sometimes even the IOCCC Judges need some help." :-)
 *
 * "Share and Enjoy!"
 *     --  Sirius Cybernetics Corporation Complaints Division, JSON spec department. :-)
 */


#if !defined(INCLUDE_JPARSE_H)
#    define  INCLUDE_JPARSE_H


#include <stdio.h>

/*
 * dbg - info, debug, warning, error, and usage message facility
 */
#if defined(INTERNAL_INCLUDE)
#include "../dbg/dbg.h"
#else
#include <dbg.h>
#endif

/*
 * util - common utility functions for the JSON parser
 */
#include "util.h"

/*
 * json_parse - JSON parser support code
 */
#include "json_parse.h"

/*
 * json_util - general JSON parser utility support functions
 */
#include "json_util.h"

/*
 * json_sem - JSON semantics support
 */
#include "json_sem.h"

/*
 * official jparse repo release
 */
#define JPARSE_REPO_VERSION "1.0.6 2024-09-12"		/* format: major.minor YYYY-MM-DD */


/*
 * official jparse version
 */
#define JPARSE_VERSION "1.1.6 2024-09-07"		/* format: major.minor YYYY-MM-DD */

/*
 * definitions
 */
#if !defined(MAX_NUL_BYTES_REPORTED)
#define MAX_NUL_BYTES_REPORTED (5)	/* do not report more than the first MAX_NUL_BYTES_REPORTED NUL bytes */
#endif
#if !defined(MAX_LOW_BYTES_REPORTED)
#define MAX_LOW_BYTES_REPORTED (5)	/* do not report more than the first MAX_LOW_BYTES_REPORTED bytes [\x01-\x08\x0e-\x1f] */
#endif

/*
 * jparse.tab.h - generated by bison
 */
#if !defined(YY_JPARSE_TAB_H_INCLUDED)
#define YYSTYPE JPARSE_STYPE
#define YYLTYPE JPARSE_LTYPE
#define YY_JPARSE_TAB_H_INCLUDED
#include "jparse.tab.h"
#endif

/*
 * official JSON parser version
 */
#define JSON_PARSER_VERSION "1.1.5 2024-09-04"		/* library version format: major.minor YYYY-MM-DD */


/*
 * globals
 */
extern const char *const json_parser_version;		/* library version format: major.minor YYYY-MM-DD */
extern const char *const jparse_version;		/* jparse version format: major.minor YYYY-MM-DD */
/* lexer and parser specific variables */
extern int jparse_debug;

struct json_extra
{
    char const *filename;	/* filename being parsed ("-" means stdin) */
};

/*
 * lexer specific
 */
extern int jparse_lex(JPARSE_STYPE *yylval_param, JPARSE_LTYPE *yylloc_param, yyscan_t scanner);

/*
 * function prototypes for jparse.y
 */
extern void jparse_error(JPARSE_LTYPE *yyltype, struct json **tree, yyscan_t scanner, char const *format, ...);

/*
 * function prototypes for jparse.l
 */
extern struct json *parse_json(char const *ptr, size_t len, char const *filename, bool *is_valid);
extern struct json *parse_json_stream(FILE *stream, char const *filename, bool *is_valid);
extern struct json *parse_json_file(char const *name, bool *is_valid);


#endif /* INCLUDE_JPARSE_H */
