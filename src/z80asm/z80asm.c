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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.c,v 1.180 2014-06-21 02:15:43 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "deffile.h"
#include "errors.h"
#include "except.h"
#include "expr.h"
#include "fileutil.h"
#include "hist.h"
#include "legacy.h"
#include "libfile.h"
#include "listfile.h"
#include "mapfile.h"
#include "modlink.h"
#include "objfile.h"
#include "options.h"
#include "scan.h"
#include "strpool.h"
#include "strutil.h"
#include "symbol.h"
#include "z80asm.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>

/* external functions */
void Z80pass2( void );
void DeclModuleName( void );
void CreateBinFile( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );


/* local functions */
void ReleaseFile( struct sourcefile *srcfile );
void ReleaseLibraries( void );
Symbol *createsym( Symbol *symptr );
struct libfile *NewLibrary( void );

extern char Z80objhdr[];

Byte reloc_routine[] =
    "\x08\xD9\xFD\xE5\xE1\x01\x49\x00\x09\x5E\x23\x56\xD5\x23\x4E\x23"
    "\x46\x23\xE5\x09\x44\x4D\xE3\x7E\x23\xB7\x20\x06\x5E\x23\x56\x23"
    "\x18\x03\x16\x00\x5F\xE3\x19\x5E\x23\x56\xEB\x09\xEB\x72\x2B\x73"
    "\xD1\xE3\x2B\x7C\xB5\xE3\xD5\x20\xDD\xF1\xF1\xFD\x36\x00\xC3\xFD"
    "\x71\x01\xFD\x70\x02\xD9\x08\xFD\xE9";

size_t sizeof_relocroutine = 73;
size_t sizeof_reloctable   = 0;

char *reloctable = NULL, *relocptr = NULL;

UInt DEFVPC;          /* DEFVARS address counter */

struct liblist *libraryhdr;

/* local functions */
static void query_assemble( char *src_filename );
static void do_assemble( char *src_filename );

/*-----------------------------------------------------------------------------
*   Assemble one source file
*	If filename starts with '@', reads the file as a list of filenames
*	and assembles each one in turn
*----------------------------------------------------------------------------*/
void assemble_file( char *filename )
{
    char *src_filename;
	Module *module;

    /* normal case - assemble a asm source file */
    opts.cur_list = opts.list;		/* initial LSTON status */

	/* when building libraries need to reset codearea to allow total library size > 64K
	   when building binary cannot reset codearea so that each module is linked
	   after the previous one, allocating addresses */
	if ( ! opts.make_bin )
		reset_codearea();

    src_filename = get_asm_filename( filename );      /* set '.asm' extension */

    /* Create module data structures for new file */
	module = set_cur_module( new_module() );
	module->filename = strpool_add( src_filename );

    query_assemble( src_filename );
    set_error_null();           /* no more module in error messages */
	opts.cur_list = FALSE;
}

/*-----------------------------------------------------------------------------
*	Assemble file or load object module size if datestamp option was given
*	and object file is up-to-date
*----------------------------------------------------------------------------*/
static void query_assemble( char *src_filename )
{
    struct stat src_stat, obj_stat;
    int src_stat_result, obj_stat_result;
	char *obj_filename = get_obj_filename( src_filename );

    /* get time stamp of files, error if source not found */
    src_stat_result = stat( src_filename, &src_stat );	/* BUG_0033 */
    obj_stat_result = stat( obj_filename, &obj_stat );

    if ( opts.date_stamp &&								/* -d option */
            obj_stat_result >= 0 &&					/* object file exists */
            ( src_stat_result >= 0 ?						/* if source file exists, ... */
              src_stat.st_mtime <= obj_stat.st_mtime		/* ... source older than object */
              : TRUE										/* ... else source does not exist, but object exists
															   --> consider up-to-date (e.g. test.c -> test.o) */
            ) &&
            objmodule_loaded( src_filename )	/* object file valid and size loaded */
       )
    {
        /* OK - object file is up-to-date */
    }
    else
    {
        /* Assemble source file */
        do_assemble( src_filename );
    }
}

/*-----------------------------------------------------------------------------
*	Assemble one file
*----------------------------------------------------------------------------*/
static void do_assemble( char *src_filename )
{
    int start_errors = get_num_errors();     /* count errors in this source file */

    /* try-catch to delete incomplete files in case of fatal error */
    TRY
    {
        /* Create error file */
        open_error_file( src_filename );

		/* create list file or symtable */
        if ( opts.list )
            list_open( get_lst_filename( src_filename ) );	/* set '.lst' extension */
        else if ( opts.symtable )
            list_open( get_sym_filename( src_filename ) );	/* set '.sym' extension */
        else
        {}													/* no list file */

        /* initialize local symtab with copy of static one (-D defines) */
        copy_static_syms();

        /* Init ASMPC */
        set_PC( 0 );

        if ( opts.verbose )
            printf( "Assembling '%s'...\nPass1...\n", src_filename );

        Z80pass1( src_filename );

        list_end();                    /* get_used_symbol will only generate page references until list_end() */

        if ( CURRENTMODULE->modname == NULL )     /* Module name must be defined */
			CURRENTMODULE->modname = path_remove_ext(path_basename(src_filename));

        set_error_null();
        //set_error_module( CURRENTMODULE->modname );

        if ( opts.verbose )
            puts( "Pass2..." );

        Z80pass2();
    }
    FINALLY
    {
        /*
         * Source file no longer needed (file could already have been closed, if fatal error occurred during INCLUDE
         * processing).
         */

        set_error_null();

        /* remove list file if more errors now than before */
        list_close( start_errors == get_num_errors() );

        /* remove incomplete object file */
        if ( start_errors != get_num_errors() )
            remove( get_obj_filename( src_filename ) );

        close_error_file();

        remove_all_local_syms();
        remove_all_global_syms();

        if ( opts.verbose )
            putchar( '\n' );    /* separate module texts */
    }
    ETRY;
}


/* search library file name, return found name in strpool */
char *GetLibfile( char *filename )
{
    struct libfile *newlib;
    char           *found_libfilename;
    char fheader[9];
    int len;
    FILE *file;

    newlib = NewLibrary();

    len = strlen( filename );

    if ( len )
    {
        found_libfilename = search_file( get_lib_filename( filename ), opts.lib_path );
    }
    else
    {
        filename = getenv( "Z80_STDLIB" );

        if ( filename != NULL )
        {
            found_libfilename = strpool_add( filename );
        }
        else
        {
            error_env_not_defined( "Z80_STDLIB" );
            return NULL;
        }
    }

    newlib->libfilename = xstrdup( found_libfilename );		/* freed when newlib is freed */

    file = xfopen( found_libfilename, "rb" );           /* CH_0012 */
	/* read first 8 chars from file into array */
    xfget_chars( file, fheader, 8 );
    fheader[8] = '\0';

    if ( strcmp( fheader, Z80libhdr ) != 0 )            /* compare header of file */
    {
        error_not_lib_file( found_libfilename );    /* not a library file */
    }
    else
    {
        opts.library = TRUE;
    }

    xfclose( file );

    return found_libfilename;
}


/* CH_0004 : always returns non-NULL, ERR_NO_MEMORY is signalled by exception */
struct libfile *
NewLibrary( void )
{
    struct libfile *newl;

    if ( libraryhdr == NULL )
    {
        libraryhdr = xnew( struct liblist );
        libraryhdr->firstlib = NULL;
        libraryhdr->currlib = NULL;     /* Library header initialised */
    }

    newl = xnew( struct libfile );
    newl->nextlib = NULL;
    newl->libfilename = NULL;
    newl->nextobjfile = -1;

    if ( libraryhdr->firstlib == NULL )
    {
        libraryhdr->firstlib = newl;
        libraryhdr->currlib = newl;     /* First library in list */
    }
    else
    {
        libraryhdr->currlib->nextlib = newl;    /* current/last library points now at new current */
        libraryhdr->currlib = newl;     /* pointer to current module updated */
    }

    return newl;
}



void
ReleaseLibraries( void )
{
    struct libfile *curptr, *tmpptr;

    curptr = libraryhdr->firstlib;

    while ( curptr != NULL )    /* while there are libraries */
    {
        if ( curptr->libfilename != NULL )
        {
            xfree( curptr->libfilename );
        }

        tmpptr = curptr;
        curptr = curptr->nextlib;
        xfree( tmpptr );       /* release library */
    }

    xfree( libraryhdr );       /* Release library header */
}


/***************************************************************************************************
 * Main entry of Z80asm
 ***************************************************************************************************/
int main( int argc, char *argv[] )
{
	ListElem *iter;

	model_init();						/* init global data */

    /* start try..catch with finally to cleanup any allocated memory */
    TRY
    {
        libraryhdr = NULL;              /* initialise to no library files */

        /* parse command line and call-back via assemble_file() */
		parse_argv(argc, argv);
		for ( iter = List_first( opts.files ); iter != NULL; iter = List_next( iter ) )
			assemble_file( iter->data );

        /* Create library */
        if ( ! get_num_errors() && opts.lib_file )
            make_library( opts.lib_file, opts.files );

        if ( ! get_num_errors() && opts.make_bin )
            link_modules();

        if ( ! get_num_errors() && opts.make_bin )
        {
            if ( opts.map )
                write_map_file();

            if ( opts.globaldef )
                write_def_file();

            CreateBinFile();
        }


    }
    /* cleanup all allocated memory */
    FINALLY
    {
        set_error_null();
        close_error_file();

        delete_modules();		/* Release module information (symbols, etc.) */

        if ( libraryhdr != NULL )
            ReleaseLibraries();    /* Release library information */

        if ( opts.relocatable )
        {
            if ( reloctable != NULL )
                xfree( reloctable );
        }
    }
    ETRY;

    if ( get_num_errors() )
    {
        info_total_errors();
        return 1;	/* signal error */
    }
    else
    {
        return 0;    /* assembler successfully ended */
    }
}


Symbol *
createsym( Symbol *symptr )
{
    return Symbol_create( symptr->name, symptr->value, symptr->sym_type, symptr->owner );
}
