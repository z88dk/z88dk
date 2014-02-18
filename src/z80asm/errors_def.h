/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Define error messages

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/errors_def.h,v 1.25 2014-02-18 22:59:06 pauloscustodio Exp $
*/

#ifndef _C_
#define _C_ ,		/* trick to pass comma-separated values as macro argument */
#endif

/* information */
ERR( ErrInfo,	info_total_errors( void ),				"%d errors occurred during assembly" _C_ get_num_errors() )

/* fatal errors */
ERR( ErrFatal,	fatal_read_file( char *filename ),		"cannot read file '%s'" _C_ filename )
ERR( ErrFatal,	fatal_write_file( char *filename ),		"cannot write file '%s'" _C_ filename )
ERR( ErrFatal,	fatal_include_recursion( char *filename ), "cannot include file '%s' recursively" _C_ filename )
ERR( ErrFatal,	fatal_divide_by_zero( void ),			"division by zero" )

/* command line parsing errors */
ERR( ErrWarn,	warn_option_deprecated( char *option ),	"option '%s' is deprecated" _C_ option )
ERR( ErrError,	error_no_src_file( void ),				"source filename missing" )
ERR( ErrError,	error_illegal_option( char *option ),		"illegal option '%s'" _C_ option )
ERR( ErrError,	error_illegal_src_filename( char *filename ),
     "illegal source filename '%s'" _C_ filename )

/* assembly errors */
ERR( ErrError,	error_syntax( void ),						"syntax error" )
ERR( ErrError,	error_syntax_expr( void ),				"syntax error in expression" )
ERR( ErrError,	error_expr( char *expr ),					"error in expression '%s'" _C_ expr )
ERR( ErrError,	error_invalid_squoted_string( void ),		"invalid single quoted character" )
ERR( ErrError,	error_unclosed_string( void ),			"unclosed quoted string" )
ERR( ErrError,	error_unbanlanced_paren( void ),			"unbalanced parenthesis" )

ERR( ErrError,	error_not_defined( void ),				"symbol not defined" )
ERR( ErrError,	error_not_defined_expr( char *expr ),		"symbol not defined in expression '%s'" _C_ expr )

ERR( ErrError,	error_unknown_ident( void ),		        "unknown identifier" )
ERR( ErrError,	error_illegal_ident( void ),				"illegal identifier" )
ERR( ErrError,	error_jr_not_local( void ),				"relative jump address must be local" )

/* symbol errors */
ERR( ErrError,	error_symbol_redefined( char *symbol ),	"symbol '%s' already defined" _C_ symbol )
ERR( ErrError,	error_symbol_redefined_module( char *symbol, char *module ),
     "symbol '%s' already defined in module '%s'" _C_ symbol _C_ module )
ERR( ErrError,	error_symbol_decl_local( char *symbol ),	"symbol '%s' already declared local" _C_ symbol )
ERR( ErrError,	error_symbol_redecl( char *symbol ),		"re-declaration of '%s' not allowed" _C_ symbol )

/* link errors */
ERR( ErrFatal,	fatal_max_codesize( long size ),			"max. code size of %ld bytes reached" _C_ size )
ERR( ErrError,	error_module_redefined( void ),			"module name already defined" )
ERR( ErrError,	error_org_not_defined( void ),			"ORG not defined" )
ERR( ErrError,	error_env_not_defined( char *var ),		"environment variable '%s' not defined" _C_ var )

ERR( ErrError,	error_not_obj_file( char *filename ),		"file '%s' not an object file" _C_ filename )
ERR( ErrError,	error_not_lib_file( char *filename ),		"file '%s' not a library file" _C_ filename )


/* range error or warning */
ERR( ErrWarn,	warn_int_range( long value ),				"integer '%ld' out of range" _C_ value )
ERR( ErrError,	error_int_range( long value ),			"integer '%ld' out of range" _C_ value )
ERR( ErrWarn,	warn_int_range_expr( long value, char *expr ),
     "integer '%ld' out of range in expression '%s'" _C_ value _C_ expr )

#undef _C_


/*
* $Log: errors_def.h,v $
* Revision 1.25  2014-02-18 22:59:06  pauloscustodio
* BUG_0040: Detect and report division by zero instead of crashing
* BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
*
* Revision 1.24  2014/01/15 00:01:40  pauloscustodio
* Decouple file.c from errors.c by adding a call-back mechanism in file for
* fatal errors, setup by errors_init()
*
* Revision 1.23  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.22  2014/01/11 00:10:38  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.21  2014/01/02 19:42:48  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
* warning: type defaults to 'int' in declaration of '...' [-Wimplicit-int]
*
* Revision 1.20  2013/12/23 18:27:11  pauloscustodio
* Protect _C_ definition by ifndef
*
* Revision 1.19  2013/10/07 00:12:33  pauloscustodio
* New error message for single-quoted character
*
* Revision 1.18  2013/10/05 13:43:05  pauloscustodio
* Parse command line options via look-up tables:
* -i, --use-lib
* -x, --make-lib
*
* Revision 1.17  2013/10/05 09:24:12  pauloscustodio
* Parse command line options via look-up tables:
* -t (deprecated)
*
* Revision 1.16  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
*
* Revision 1.15  2013/09/08 00:43:58  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.14  2013/06/11 23:16:06  pauloscustodio
* Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
* Add error message for invalid symbol and scope chars in object file.
*
* Revision 1.13  2013/06/01 01:24:21  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
*
* Revision 1.12  2013/05/11 00:29:26  pauloscustodio
* CH_0021 : Exceptions on file IO show file name
* Keep a hash table of all opened file names, so that the file name
* is shown on a fatal error.
* Rename file IO funtions: f..._err to xf...
*
* Revision 1.11  2013/05/01 19:03:45  pauloscustodio
* Simplified scanner and adapted to be used with a BISON generated parser.
* Removed balanced struct checking and token ring.
* Removed start condition to list assembly lines, as it was difficult to keep in sync across included
* files; inserted an RS char in the input before each line to trigger listing.
* Allow ".NAME" and "NAME:" to return a NAME token, so that ".LD" is recognized as a label and not the LD assembly statement.
* Added Integer out of range warning to number scanning routine.
* Allow input lines to be any size, as long as memory can be allocated.
* Created a skeleton BISON parser.
*
* Revision 1.10  2013/04/07 23:34:19  pauloscustodio
* CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given
* z80asm no longer asks for an ORG address from the standard input
* if one is not given either by an ORG statement or a -r option;
* it exists with an error message instead.
* The old behaviour was causing wrong build scripts to hang waiting
* for input.
*
* Revision 1.9  2013/03/29 23:53:08  pauloscustodio
* Added GNU Flex-based scanner. Not yet integrated into assembler.
*
* Revision 1.8  2013/02/12 00:48:54  pauloscustodio
* CH_0017 : Align with spaces, deprecate -t option
*
* Revision 1.7  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.6  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.5  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.4  2012/05/24 16:20:52  pauloscustodio
* ERR_EXPR_SYNTAX renamed ERR_SYNTAX_EXPR (consistency)
*
* Revision 1.3  2012/05/23 20:45:42  pauloscustodio
* Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
* Add tests.
*
* Revision 1.2  2012/05/20 05:38:19  pauloscustodio
* ERR_SYMBOL_DECL_GLOBAL seams to be impossible to get. Added comment on this,
* changed test error-18.t
*
* Revision 1.1  2012/05/17 20:31:45  pauloscustodio
* New errors_def.h with error name and string together, for easier maintenance
*
*/
