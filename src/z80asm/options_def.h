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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/options_def.h,v 1.13 2013-10-03 22:20:10 pauloscustodio Exp $
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
OPT_VAR(	BOOL,	make_bin,	FALSE	)

OPT_VAR(	char *,	asm_ext,	(FILEEXT_ASM)+1 )	/* skip "." */
OPT_VAR(	char *,	obj_ext,	(FILEEXT_OBJ)+1 )	/* skip "." */
OPT_VAR(	char *,	bin_file,	NULL 			)	/* set by -o */

/*-----------------------------------------------------------------------------
*   define options
*----------------------------------------------------------------------------*/
OPT_TITLE(	"Help Options:"	)
OPT( OptCall,	exit_help,		"-h", 	"--help",		"Show help options", "" )
OPT( OptSet,	&opts.verbose,	"-v", 	"--verbose", 	"Be verbose", "" )
OPT( OptClear,	&opts.verbose,	"-nv", 	"--not-verbose","Be silent", "" )

OPT_TITLE(	"Input / Output File Options:"	)
OPT( OptString,	&opts.asm_ext,	"-e", 	"--asm-ext", 	"ASM file extension, excluding '.'", "EXT" )
OPT( OptString,	&opts.obj_ext,	"-M", 	"--obj-ext", 	"OBJ file extension, excluding '.'", "EXT" )
OPT( OptString,	&opts.bin_file,	"-o", 	"--output", 	"Output binary file", "FILE.BIN" )

OPT_TITLE(	"Code Generation Options:" )
OPT( OptSet,	&opts.sdcc,		"-sdcc","--sdcc",		"Assemble for Small Device C Compiler", "" )

OPT_TITLE(	"Output Options:" )

OPT( OptSet,	&opts.make_bin,	"-b", 	"--make-bin", 	"Link and relocate object files to file" FILEEXT_BIN, "" )
OPT( OptClear,	&opts.make_bin,	"-nb", 	"--no-make-bin","No binary file", "" )

OPT_TITLE(	"Other Output File Options:" )

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
* $Log: options_def.h,v $
* Revision 1.13  2013-10-03 22:20:10  pauloscustodio
* Parse command line options via look-up tables:
* -o, --output
*
* Revision 1.12  2013/10/03 21:58:41  pauloscustodio
* Parse command line options via look-up tables:
* -b, --make-bin
* -nb, --no-make-bin
*
* Revision 1.10  2013/10/02 23:43:57  pauloscustodio
* add log
* 
* Revision 1.9  2013/10/02 23:42:09  pauloscustodio
* Parse command line options via look-up tables:
* add --sdcc in addition to -sdcc, for consistency
* 
* Revision 1.8  2013/10/02 23:20:44  pauloscustodio
* Parse command line options via look-up tables:
* -g, --globaldef
* -ng, --no-globaldef
* 
* Revision 1.7  2013/10/01 23:46:28  pauloscustodio
* Parse command line options via look-up tables:
* -m, --map
* -nm, --no-map
* 
* Revision 1.6  2013/10/01 23:23:53  pauloscustodio
* Parse command line options via look-up tables:
* -l, --list
* -nl, --no-list
* 
* Revision 1.5  2013/10/01 22:50:26  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
* 
* Revision 1.4  2013/10/01 22:09:33  pauloscustodio
* Parse command line options via look-up tables:
* -sdcc
* 
* Revision 1.3  2013/09/30 00:33:11  pauloscustodio
* help text
* 
* Revision 1.2  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
* 
* Revision 1.1  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
*/

