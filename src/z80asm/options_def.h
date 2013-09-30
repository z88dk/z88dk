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

Copyright (C) Paulo Custodio, 2011-2013

Define command line options

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options_def.h,v 1.3 2013-09-30 00:33:11 pauloscustodio Exp $
*/

/*-----------------------------------------------------------------------------
*   define default macros
*----------------------------------------------------------------------------*/
#ifndef OPT_VAR
#define OPT_VAR(type, name, default)
#endif

#ifndef OPT_TITLE
#define OPT_TITLE(text)
#endif

#ifndef OPT
#define OPT(type, arg, short_opt, long_opt, help_text, help_arg)
#endif

/*-----------------------------------------------------------------------------
*   define option variables
*----------------------------------------------------------------------------*/
OPT_VAR(	BOOL,	verbose,	FALSE )
OPT_VAR(	char *,	asm_ext,	(FILEEXT_ASM)+1 )	/* skip "." */
OPT_VAR(	char *,	obj_ext,	(FILEEXT_OBJ)+1 )	/* skip "." */

/*-----------------------------------------------------------------------------
*   define options
*----------------------------------------------------------------------------*/
OPT_TITLE(	"Help Options:"	)
OPT( OptCall,	exit_help,		"-h", 	"--help",			"Show help options", "" )
OPT( OptSet,	&opts.verbose,	"-v", 	"--verbose", 		"Be verbose", "" )
OPT( OptClear,	&opts.verbose,	"-nv", 	"--not-verbose", 	"Be silent", "" )

OPT_TITLE(	"Input Options:"	)
OPT( OptString,	&opts.asm_ext,	"-e", 	"--asm-ext", 		"ASM file extension, excluding '.'", "EXT" )
OPT( OptString,	&opts.obj_ext,	"-M", 	"--obj-ext", 		"OBJ file extension, excluding '.'", "EXT" )

/*-----------------------------------------------------------------------------
*   clear macros
*----------------------------------------------------------------------------*/
#undef OPT_VAR
#undef OPT_TITLE
#undef OPT
