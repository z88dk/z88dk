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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options_def.h,v 1.10 2013-10-02 23:43:57 pauloscustodio Exp $
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
OPT_VAR(	BOOL,	verbose,	FALSE	)
OPT_VAR(	BOOL,	symtable,	TRUE 	)
OPT_VAR(	BOOL,	list,		FALSE 	)			/* -l flag */
OPT_VAR(	BOOL,	cur_list,	FALSE 	)			/* current LSTON/LSTOFF status */
OPT_VAR(	BOOL,	map,		TRUE 	)
OPT_VAR(	BOOL,	sdcc,		FALSE	)
OPT_VAR(	BOOL,	globaldef,	FALSE	)

OPT_VAR(	char *,	asm_ext,	(FILEEXT_ASM)+1 )	/* skip "." */
OPT_VAR(	char *,	obj_ext,	(FILEEXT_OBJ)+1 )	/* skip "." */

/*-----------------------------------------------------------------------------
*   define options
*----------------------------------------------------------------------------*/
OPT_TITLE(	"Help Options:"	)
OPT( OptCall,	exit_help,		"-h", 	"--help",		"Show help options", "" )
OPT( OptSet,	&opts.verbose,	"-v", 	"--verbose", 	"Be verbose", "" )
OPT( OptClear,	&opts.verbose,	"-nv", 	"--not-verbose","Be silent", "" )

OPT_TITLE(	"Input Options:"	)
OPT( OptString,	&opts.asm_ext,	"-e", 	"--asm-ext", 	"ASM file extension, excluding '.'", "EXT" )
OPT( OptString,	&opts.obj_ext,	"-M", 	"--obj-ext", 	"OBJ file extension, excluding '.'", "EXT" )

OPT_TITLE(	"Code Generation Options:" )
OPT( OptSet,	&opts.sdcc,		"-sdcc","--sdcc",		"Assemble for Small Device C Compiler", "" )

OPT_TITLE(	"Output Options:" )
OPT( OptSet,	&opts.symtable,	"-s", 	"--symtable", 	"Generate symbol table file" FILEEXT_SYM, "" )
OPT( OptClear,	&opts.symtable,	"-ns", 	"--no-symtable","No symbol table file", "" )
OPT( OptSet,	&opts.list,		"-l", 	"--list", 		"Generate list file" FILEEXT_LST, "" )
OPT( OptClear,	&opts.list,		"-nl", 	"--no-list",	"No list file", "" )
OPT( OptSet,	&opts.map,		"-m", 	"--map", 		"Generate address map file" FILEEXT_MAP, "" )
OPT( OptClear,	&opts.map,		"-nm", 	"--no-map",		"No address map file", "" )
OPT( OptSet,	&opts.globaldef,"-g", 	"--globaldef", 	"Generate global address definition file" FILEEXT_DEF, "" )
OPT( OptClear,	&opts.globaldef,"-ng", 	"--no-globaldef","No global address definition file", "" )

/*-----------------------------------------------------------------------------
*   clear macros
*----------------------------------------------------------------------------*/
#undef OPT_VAR
#undef OPT_TITLE
#undef OPT


/*
$Log: options_def.h,v $
Revision 1.10  2013-10-02 23:43:57  pauloscustodio
add log

*/

