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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/errors_def.h,v 1.32 2014-09-28 17:37:14 pauloscustodio Exp $
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

/* command line parsing errors */
ERR( ErrWarn,	warn_option_deprecated( char *option ),	"option '%s' is deprecated" _C_ option )
ERR( ErrError,	error_no_src_file( void ),				"source filename missing" )
ERR( ErrError,	error_illegal_option( char *option ),	"illegal option '%s'" _C_ option )
ERR( ErrError,	error_illegal_src_filename( char *filename ),
     "illegal source filename '%s'" _C_ filename )

/* warnings */
ERR( ErrWarn,	warn_symbol_diff_case( char *name, char *used ),
											"symbol '%s' used as '%s'" _C_ name _C_ used )
ERR( ErrWarn,	warn_deprecated( char *old_stmt, char *new_stmt ),
											"'%s' is deprecated, use '%s' instead" 
											_C_ old_stmt _C_ new_stmt )

/* assembly errors */
ERR( ErrError,	error_syntax( void ),					"syntax error" )
ERR( ErrError,	error_syntax_expr( void ),				"syntax error in expression" )
ERR( ErrError,	error_invalid_squoted_string( void ),	"invalid single quoted character" )
ERR( ErrError,	error_unclosed_string( void ),			"unclosed quoted string" )
ERR( ErrError,	error_divide_by_zero( void ),			"division by zero" )

ERR( ErrError,	error_not_defined( void ),				"symbol not defined" )

ERR( ErrError,	error_unknown_ident( void ),		    "unknown identifier" )
ERR( ErrError,	error_illegal_ident( void ),			"illegal identifier" )
ERR( ErrError,	error_jr_not_local( void ),				"relative jump address must be local" )

/* symbol errors */
ERR( ErrError,	error_symbol_redefined( char *symbol ),	"symbol '%s' already defined" _C_ symbol )
ERR( ErrError,	error_symbol_redefined_module( char *symbol, char *module ),
														"symbol '%s' already defined in module '%s'" _C_ symbol _C_ module )
ERR( ErrError,	error_symbol_decl_local( char *symbol ),"symbol '%s' already declared local" _C_ symbol )
ERR( ErrError,	error_symbol_redecl( char *symbol ),	"re-declaration of '%s' not allowed" _C_ symbol )

/* link errors */
ERR( ErrFatal,	fatal_max_codesize( long size ),		"max. code size of %ld bytes reached" _C_ size )
ERR( ErrError,	error_module_redefined( void ),			"module name already defined" )
ERR( ErrError,	error_org_redefined( void ),			"ORG redefined" )
ERR( ErrError,	error_env_not_defined( char *var ),		"environment variable '%s' not defined" _C_ var )

ERR( ErrError,	error_not_obj_file( char *filename ),	"file '%s' not an object file" _C_ filename )
ERR( ErrError,	error_not_lib_file( char *filename ),	"file '%s' not a library file" _C_ filename )


/* range error or warning */
ERR( ErrWarn,	warn_int_range( long value ),			"integer '%ld' out of range" _C_ value )
ERR( ErrError,	error_int_range( long value ),			"integer '%ld' out of range" _C_ value )

#undef _C_
