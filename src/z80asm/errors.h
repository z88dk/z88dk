/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Error handling.
*/

#pragma once

#include "error_func.h"
#include <stdio.h>

enum ErrType { ErrInfo, ErrWarn, ErrError };

/*-----------------------------------------------------------------------------
*	initialize error module
*----------------------------------------------------------------------------*/
extern void errors_init( void );

/*-----------------------------------------------------------------------------
*	define the next FILE, LINENO, MODULE to use in error messages
*	error_xxx(), warn_xxx()
*----------------------------------------------------------------------------*/
extern void set_error_null( void );             /* clear all locations */
extern void set_error_file( char *filename );
extern void set_error_module( char *modulename );
extern void set_error_line( int lineno );

extern char *get_error_file(void);
extern int   get_error_line(void);

/*-----------------------------------------------------------------------------
*	reset count of errors and return current count
*----------------------------------------------------------------------------*/
extern void reset_error_count( void );
extern int  get_num_errors( void );

/*-----------------------------------------------------------------------------
*	Open file to receive all errors / warnings from now on
*	File is created on first call and appended on second, to allow assemble
*	and link errors to be joined in the same file.
*----------------------------------------------------------------------------*/
extern void open_error_file( char *src_filename );
extern void close_error_file( void );   /* deletes the file if no errors */

/*-----------------------------------------------------------------------------
*   Execute an error
*----------------------------------------------------------------------------*/
extern void do_error( enum ErrType err_type, char *message );
