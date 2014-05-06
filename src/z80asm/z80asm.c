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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.c,v 1.165 2014-05-06 22:17:38 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "deffile.h"
#include "errors.h"
#include "except.h"
#include "expr.h"
#include "fileutil.h"
#include "hist.h"
#include "legacy.h"
#include "listfile.h"
#include "mapfile.h"
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
void CreateLib( char *lib_filename );
void LinkModules( void );
void DeclModuleName( void );
void CreateBinFile( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );


/* local functions */
void ReleaseFile( struct sourcefile *srcfile );
void ReleaseLibraries( void );
void CloseFiles( void );
Symbol *createsym( Symbol *symptr );
struct libfile *NewLibrary( void );

FILE *objfile;

extern char Z80objhdr[];
extern char objhdrprefix[];

#ifdef __LEGACY_Z80ASM_SYNTAX
char Z80libhdr[] = "Z80LMF01";
#else
char Z80libhdr[] = "Z80LMF" OBJ_VERSION;
#endif

BYTE reloc_routine[] =
    "\x08\xD9\xFD\xE5\xE1\x01\x49\x00\x09\x5E\x23\x56\xD5\x23\x4E\x23"
    "\x46\x23\xE5\x09\x44\x4D\xE3\x7E\x23\xB7\x20\x06\x5E\x23\x56\x23"
    "\x18\x03\x16\x00\x5F\xE3\x19\x5E\x23\x56\xEB\x09\xEB\x72\x2B\x73"
    "\xD1\xE3\x2B\x7C\xB5\xE3\xD5\x20\xDD\xF1\xF1\xFD\x36\x00\xC3\xFD"
    "\x71\x01\xFD\x70\x02\xD9\x08\xFD\xE9";

UINT sizeof_relocroutine = 73;
UINT sizeof_reloctable   = 0;

char *reloctable = NULL, *relocptr = NULL;

UINT DEFVPC;          /* DEFVARS address counter */

struct liblist *libraryhdr;

/* local functions */
static BOOL load_module_object( char *filename );
static void query_assemble( char *src_filename, char *obj_filename );
static void do_assemble( char *src_filename, char *obj_filename );

/*-----------------------------------------------------------------------------
*   Assemble one source file
*	If filename starts with '@', reads the file as a list of filenames
*	and assembles each one in turn
*----------------------------------------------------------------------------*/
void assemble_file( char *filename )
{
    char *src_filename, *obj_filename;
	Module *module;

    /* normal case - assemble a asm source file */
    objfile = NULL;
    opts.cur_list = opts.list;		/* initial LSTON status */
    reset_codearea();           /* Pointer (PC) to store z80 instruction */

    src_filename = get_asm_filename( filename );      /* set '.asm' extension */
    obj_filename = get_obj_filename( filename );      /* set '.obj' extension */

    /* Create module data structures for new file */
	module = new_curr_module();
	module->filename = strpool_add( src_filename );

    query_assemble( src_filename, obj_filename );
    set_error_null();           /* no more module in error messages */
	opts.cur_list = FALSE;
}

/*-----------------------------------------------------------------------------
*	Assemble file or load object module size if datestamp option was given
*	and object file is up-to-date
*----------------------------------------------------------------------------*/
static void query_assemble( char *src_filename, char *obj_filename )
{
    struct stat src_stat, obj_stat;
    int src_stat_result, obj_stat_result;

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
            load_module_object( obj_filename )			/* object file valid and size loaded */
       )
    {
        /* OK - object file is up-to-date */
    }
    else
    {
        /* Assemble source file */
        do_assemble( src_filename, obj_filename );
    }
}

/*-----------------------------------------------------------------------------
*	Assemble one file
*----------------------------------------------------------------------------*/
static void do_assemble( char *src_filename, char *obj_filename )
{
    int start_errors = get_num_errors();     /* count errors in this source file */

    /* try-catch to delete incomplete files in case of fatal error */
    TRY
    {
        /* Create error file */
        open_error_file( get_err_filename( src_filename ) );

		/* create list file or symtable */
        if ( opts.list )
            list_open( get_lst_filename( src_filename ) );	/* set '.lst' extension */
        else if ( opts.symtable )
            list_open( get_sym_filename( src_filename ) );	/* set '.sym' extension */
        else
        {}													/* no list file */

        /* Create relocatable object file */
        objfile = xfopen( obj_filename, "w+b" );           /* CH_0012 */
        xfput_strz( objfile, Z80objhdr );
		xfput_strz( objfile, objhdrprefix );

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
        set_error_module( CURRENTMODULE->modname );

        if ( start_errors == get_num_errors() )
        {
            if ( opts.verbose )
                puts( "Pass2..." );

            Z80pass2();
        }
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

        if ( objfile != NULL )
        {
            xfclose( objfile );
            objfile = NULL;
        }

        if ( start_errors != get_num_errors() )
        {
            /* remove incomplete object file */
            remove( obj_filename );
        }

        close_error_file();

        remove_all_local_syms();
        remove_all_global_syms();

        if ( opts.verbose )
        {
            putchar( '\n' );    /* separate module texts */
        }
    }
    ETRY;
}

/*-----------------------------------------------------------------------------
*	Updates current module name and size, if given object file is valid
*	If not returns FALSE
*----------------------------------------------------------------------------*/
BOOL load_module_object( char *filename )
{
    ObjFile *obj_file;

    obj_file = ObjFile_open_read( filename, TRUE );	/* test-mode => no errors */

    if ( obj_file != NULL )
    {
        inc_codesize( obj_file->code_size );		/* BUG_0015, BUG_0050 */

        CURRENTMODULE->modname = obj_file->modname;
        
		OBJ_DELETE( obj_file );						/* BUG_0049 */

        return TRUE;
    }
    else
        return FALSE;
}




void
CloseFiles( void )
{
    if ( objfile != NULL )
    {
        xfclose( objfile );
        objfile = NULL;
    }

    close_error_file();
}


/* define name of library file to create, return name in strpool */
char *CreateLibfile( char *filename )
{
    UINT len;
    char *found_libfilename;

    len = strlen( filename );

    if ( len )
    {
        found_libfilename = get_lib_filename( filename );     /* add '.lib' extension */
    }
    else
    {
        if ( ( filename = getenv( "Z80_STDLIB" ) ) != NULL )
        {
            found_libfilename = strpool_add( filename );
        }
        else
        {
            error_env_not_defined( "Z80_STDLIB" );
            return NULL;
        }
    }

    return found_libfilename;
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
	model_init();						/* init global data */

    /* start try..catch with finally to cleanup any allocated memory */
    TRY
    {
        libraryhdr = NULL;              /* initialise to no library files */

        /* define OS_ID */
        define_static_def_sym( OS_ID, 1 );

        /* parse command line and call-back via assemble_file() */
        parse_argv( argc, argv, assemble_file );

        /* Link */
        CloseFiles();

        /* Create library */
        if ( opts.lib_file && ! get_num_errors() )
            CreateLib( opts.lib_file );

        if ( ! get_num_errors() && opts.make_bin )
            LinkModules();

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

        CloseFiles();

#ifndef QDOS

        delete_modules();		/* Release module information (symbols, etc.) */

        if ( libraryhdr != NULL )
            ReleaseLibraries();    /* Release library information */

        if ( opts.relocatable )
        {
            if ( reloctable != NULL )
                xfree( reloctable );
        }

#endif
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

/*
* $Log: z80asm.c,v $
* Revision 1.165  2014-05-06 22:17:38  pauloscustodio
* Made types BYTE, UINT and ULONG all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.164  2014/05/04 18:05:56  pauloscustodio
* comment
*
* Revision 1.163  2014/05/02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to BYTE, UINT and ULONG
*
* Revision 1.162  2014/05/02 21:00:50  pauloscustodio
* Hide module list, expose only iterators on CURRENTMODULE
*
* Revision 1.161  2014/05/02 20:24:39  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.160  2014/04/26 09:25:32  pauloscustodio
* BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
* When a library is built with -d, and the total size of the loaded
* modules is more than 64K, z80asm fails with "max. code size reached".
*
* Revision 1.159  2014/04/26 08:12:04  pauloscustodio
* BUG_0049: Making a library with -d and 512 object files fails - Too many open files
* Error caused by z80asm not closing the intermediate object files, when
* assembling with -d.
*
* Revision 1.158  2014/04/23 22:07:12  pauloscustodio
* Too many open files was caused by all modules loaded during assembly keeping the FILE* open.
*
* Revision 1.157  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.156  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.155  2014/04/06 23:29:26  pauloscustodio
* Removed lookup functions in token.c, no longer needed with the ragel based scanner.
* Moved the token definitions from token_def.h to scan_def.h.
*
* Revision 1.154  2014/04/05 23:36:11  pauloscustodio
* CH_0024: Case-preserving, case-insensitive symbols
* Symbols no longer converted to upper-case, but still case-insensitive
* searched. Warning when a symbol is used with different case than
* defined. Intermidiate stage before making z80asm case-sensitive, to
* be more C-code friendly.
*
* Revision 1.153  2014/03/29 00:30:11  pauloscustodio
* TK_EOF renamed TK_END
*
* Revision 1.152  2014/03/18 22:44:03  pauloscustodio
* Scanner decodes a number into tok_number.
* GetConstant(), TK_HEX_CONST, TK_BIN_CONST and TK_DEC_CONST removed.
* ident[] replaced by tok_name.
*
* Revision 1.151  2014/03/17 00:07:53  pauloscustodio
* Remove global stringconst[]
*
* Revision 1.150  2014/03/16 23:57:06  pauloscustodio
* Removed global line[]
*
* Revision 1.149  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.148  2014/03/15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.147  2014/03/11 23:34:00  pauloscustodio
* Remove check for feof(z80asmfile), add token TK_END to return on EOF.
* Allows decoupling of input file used in scanner from callers.
* Removed TOTALLINES.
* GetChar() made static to scanner, not called by other modules.
*
* Revision 1.146  2014/03/11 22:59:20  pauloscustodio
* Move EOL flag to scanner
*
* Revision 1.145  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.144  2014/03/04 11:49:47  pauloscustodio
* Expression parser and expression evaluator use a look-up table of all
* supported unary, binary and ternary oprators, instead of a big switch
* statement to select the operation.
* Expression operations are stored in a contiguous array instead of
* a liked list to reduce administrative overhead of adding / iterating.
*
* Revision 1.143  2014/03/03 14:09:20  pauloscustodio
* Renamed symbol type attribute
*
* Revision 1.142  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.141  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.140  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.139  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.138  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UINT and ULONG, use UINT instead of size_t.
*
* Revision 1.137  2014/02/11 15:27:19  pauloscustodio
* Removed Bison parser files (which where a very incomplete work in progress).
*
* Bison grammar not practical due to dual nature of z80asm keywords, i.e.
* DEFC NOP = 3 ; define a constant called NOP
* NOP ; assemble a NOP instruction
* LD A,NOP ; loads A with 3
*
* A Bison grammar requires the NOP to be a terminal token, which complicates
* the lexer to be able to return a NAME or a NOP depending on context.
*
* Revision 1.136  2014/02/08 18:30:49  pauloscustodio
* lib/srcfile.c to read source files and handle recursive includes,
* used to read @lists, removed opts.files;
* model.c to hold global data model
*
* Revision 1.135  2014/02/03 21:48:52  pauloscustodio
* ws
*
* Revision 1.134  2014/01/23 22:30:55  pauloscustodio
* Use xfclose() instead of fclose() to detect file write errors during buffer flush called
* at fclose()
*
* Revision 1.133  2014/01/21 23:12:30  pauloscustodio
* path_... functions return filename instrpool, no need to pass an array to store result.
*
* Revision 1.132  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.131  2014/01/15 00:01:40  pauloscustodio
* Decouple file.c from errors.c by adding a call-back mechanism in file for
* fatal errors, setup by errors_init()
*
* Revision 1.130  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.129  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.128  2014/01/10 00:15:27  pauloscustodio
* Use Str instead of glib, List instead of GSList.
* Use init.h mechanism, no need for main() calling init_scan.
* glib dependency removed from code and Makefile
*
* Revision 1.127  2014/01/09 23:26:24  pauloscustodio
* Use init.h mechanism, no need for main() calling init_codearea
*
* Revision 1.126  2014/01/09 23:13:04  pauloscustodio
* Use init.h mechanism, no need for main() calling init_options.
* Use Str instead of glib.
*
* Revision 1.125  2014/01/06 00:33:36  pauloscustodio
* Use init.h mechanism, no need for main() calling init_errors
* and atexit(fini_errors); use Str and StrHash instead of glib.
*
* Revision 1.124  2014/01/05 23:20:39  pauloscustodio
* List, StrHash classlist and classhash receive the address of the container
* object in all functions that add items to the container, and create the
* container on first use. This allows a container to be staticaly
* initialized with NULL and instantiated on first push/unshift/set.
* Add count attribute to StrHash, classhash to count elements in container.
* Add free_data attribute in StrHash to register a free fucntion to delete
* the data container when the hash is removed or a key is overwritten.
*
* Revision 1.123  2014/01/02 17:18:16  pauloscustodio
* StrList removed, replaced by List
*
* Revision 1.122  2014/01/02 02:31:42  pauloscustodio
* parse_argv() collects all files from command line in opts.files, expanding @lists;
* main() iterates through opts.files, eliminating the call-back.
*
* Revision 1.121  2014/01/01 21:23:48  pauloscustodio
* Move generic file utility functions to lib/fileutil.c
*
* Revision 1.120  2013/12/30 02:05:32  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
*
* Revision 1.119  2013/12/18 01:46:22  pauloscustodio
* Move strpool.c to the z80asm/lib directory
*
* Revision 1.118  2013/12/15 23:05:54  pauloscustodio
* Remove code-generation for init() functions, do a plain call from main().
* Complicates maintenance, as all the modules with init() functions
* are coupled together, and it may not be clear how the init() module
* appears.
*
* Revision 1.117  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.116  2013/12/15 12:10:06  pauloscustodio
* Fix memory leak on recursive file include fatal error
*
* Revision 1.115  2013/10/05 13:43:05  pauloscustodio
* Parse command line options via look-up tables:
* -i, --use-lib
* -x, --make-lib
*
* Revision 1.114  2013/10/05 10:54:36  pauloscustodio
* Parse command line options via look-up tables:
* -I, --inc-path
* -L, --lib-path
*
* Revision 1.113  2013/10/04 23:09:25  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
*
* Revision 1.112  2013/10/03 23:48:31  pauloscustodio
* Parse command line options via look-up tables:
* -r, --origin=ORG_HEX
*
* Revision 1.111  2013/10/03 22:35:21  pauloscustodio
* Parse command line options via look-up tables:
* -d, --date-stamp
* -nd, --no-date-stamp
*
* Revision 1.110  2013/10/03 21:58:41  pauloscustodio
* Parse command line options via look-up tables:
* -b, --make-bin
* -nb, --no-make-bin
*
* Revision 1.109  2013/10/02 23:20:44  pauloscustodio
* Parse command line options via look-up tables:
* -g, --globaldef
* -ng, --no-globaldef
*
* Revision 1.108  2013/10/01 23:46:28  pauloscustodio
* Parse command line options via look-up tables:
* -m, --map
* -nm, --no-map
*
* Revision 1.107  2013/10/01 23:23:53  pauloscustodio
* Parse command line options via look-up tables:
* -l, --list
* -nl, --no-list
*
* Revision 1.106  2013/10/01 22:50:27  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
*
* Revision 1.105  2013/09/30 00:24:25  pauloscustodio
* Parse command line options via look-up tables:
* -e, --asm-ext
* -M, --obj-ext
* Move filename extension functions to options.c
*
* Revision 1.104  2013/09/29 21:43:48  pauloscustodio
* Parse command line options via look-up tables:
* move @file handling to options.c
*
* Revision 1.103  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
*
* Revision 1.102  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.101  2013/09/12 00:10:02  pauloscustodio
* Create xfree() macro that NULLs the pointer after free, required
* by z80asm to find out if a pointer was already freed.
*
* Revision 1.100  2013/09/09 00:15:11  pauloscustodio
* Integrate codearea in init() mechanism.
*
* Revision 1.99  2013/09/08 08:29:21  pauloscustodio
* Replaced xmalloc et al with glib functions
*
* Revision 1.98  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.97  2013/09/01 12:00:07  pauloscustodio
* Cleanup compilation warnings
*
* Revision 1.96  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.95  2013/08/30 21:50:43  pauloscustodio
* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
* as an identifier reserved by the C standard for implementation-defined behaviour
* starting with two underscores.
*
* Revision 1.94  2013/08/30 01:11:54  pauloscustodio
* Symbols in symbol.h enum definition and in z80asm.c ssyms[] must be in the exact
* same order. Moreover need to define some different symbols for the legacy
* version.
*
* Move all defintions to token_def.h, included in both other files.
*
* Revision 1.93  2013/06/16 22:25:39  pauloscustodio
* New remove_all_{local,static,global}_syms( void ) functions
* to encapsulate calls to get_global_tab().
*
* Revision 1.92  2013/06/16 20:14:39  pauloscustodio
* Move deffile writing to deffile.c, remove global variable deffile
*
* Revision 1.91  2013/06/15 00:26:23  pauloscustodio
* Move mapfile writing to mapfile.c.
*
* Revision 1.90  2013/06/10 23:11:33  pauloscustodio
* CH_0023 : Remove notdecl_tab
*
* Revision 1.89  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMSIZE, ASMTAIL
*
* Revision 1.88  2013/06/08 23:07:53  pauloscustodio
* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
*  and define_global_def_sym().
*
* Revision 1.87  2013/06/01 01:24:22  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
*
* Revision 1.86  2013/05/23 22:22:23  pauloscustodio
* Move symbol to sym.c, rename to Symbol
*
* Revision 1.85  2013/05/16 22:45:21  pauloscustodio
* Add ObjFile to struct module
* Use ObjFile to check for valid object file
*
* Revision 1.84  2013/05/12 19:46:35  pauloscustodio
* New module for object file handling
*
* Revision 1.83  2013/05/06 23:02:12  pauloscustodio
* BUG_0034 : If assembly process fails with fatal error, invalid library is kept
* Option -x creates an empty library file (just the header). If the
* assembly process fails with a fatal errror afterwards, the library file
* is not deleted.
*
* Revision 1.82  2013/05/06 22:06:22  pauloscustodio
* BUG_0033 : -d option fails if .asm does not exist
* When building test.o from test.c, the test.asm file is removed by zcc.
* If the .o is then linked into a library with the -d option to skip
* assembling, z80asm fails with error
* "Cannot open file 'test.asm' for reading".
* Bug introduced when replaced TestAsmFile() by query_assemble() in
* z80asm.c 1.78.
*
* Revision 1.81  2013/05/06 13:24:57  stefano
* *** empty log message ***
*
* Revision 1.80  2013/05/06 12:13:32  stefano
* Excluded the check to see if we have a source file in case it is asked to build
* only the updated files (it could be a C compiled program).
*
* Revision 1.79  2013/05/02 21:24:50  pauloscustodio
* Cleanup assemble login
* Removed global vars srcfilename, objfilename
*
* Revision 1.78  2013/05/02 00:04:18  pauloscustodio
* Cleanup assemble decision logic
*
* Revision 1.77  2013/04/07 22:10:52  pauloscustodio
* Usage did not take -e into account
*
* Revision 1.76  2013/04/06 13:15:04  pauloscustodio
* Move default asm and obj extension handling to file.c.
* srcfilename and objfilename are now pointers to static variables in file.c
*
* Revision 1.75  2013/04/04 23:24:18  pauloscustodio
* Remove global variable errfilename
*
* Revision 1.74  2013/04/03 22:52:56  pauloscustodio
* Move libfilename to options.c, keep it in strpool
*
* Revision 1.73  2013/03/31 12:28:10  pauloscustodio
* GetLibfile() was using global z80asmfile instead of a local FILE* variable - fixed
*
* Revision 1.72  2013/03/31 11:59:57  pauloscustodio
* Decouple module name creation from parsing, define CURRENTMODULE->mname
* direcly instead of calling DeclModuleName()
*
* Revision 1.71  2013/03/04 23:37:09  pauloscustodio
* Removed pass1 that was used to skip creating page references of created
* symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
* modified list_get_page_nr() to return -1 after the whole source is
* processed.
*
* Revision 1.70  2013/02/27 20:47:53  pauloscustodio
* comments
*
* Revision 1.69  2013/02/22 17:26:33  pauloscustodio
* Decouple assembler from listfile handling
*
* Revision 1.68  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
* Revision 1.67  2013/02/12 00:55:00  pauloscustodio
* CH_0017 : Align with spaces, deprecate -t option
*
* Revision 1.66  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (BYTE)
* Replaced (unisigned int) by (UINT)
* Replaced (short) by (int)
*
* Revision 1.65  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.64  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.63  2012/06/07 11:54:13  pauloscustodio
* - Make mapfile static to module modlink.
* - Remove modsrcfile, not used.
* - GetModuleSize(): use local variable for file handle instead of objfile
*
* Revision 1.62  2012/05/29 21:00:35  pauloscustodio
* BUG_0019 : z80asm closes a closed file handle, crash in Linux
*
* Revision 1.61  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.60  2012/05/26 17:46:00  pauloscustodio
* Put back strtoupper, strupr does not exist in all systems, was causing nightly build to fail
*
* Revision 1.59  2012/05/24 21:48:24  pauloscustodio
* Remove the global variables include_dir, lib_dir, and respective
* counts, create instead the paths in the options module and
* create new search_include_file() and search_lib_file()
* functions to replace SearchFile().
*
* Revision 1.58  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.57  2012/05/24 17:00:43  pauloscustodio
* astyle
*
* Revision 1.56  2012/05/24 15:07:43  pauloscustodio
* whitespace
*
* Revision 1.55  2012/05/24 13:43:52  pauloscustodio
* Remove ERRORS, redundant with TOTALERRORS
*
* Revision 1.54  2012/05/24 11:27:10  pauloscustodio
* astyle
*
* Revision 1.53  2012/05/24 10:58:39  pauloscustodio
* BUG_0018 : stack overflow in '@' includes - wrong range check
*
* Revision 1.52  2012/05/23 20:45:42  pauloscustodio
* Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
* Add tests.
*
* Revision 1.51  2012/05/22 20:30:15  pauloscustodio
* Use strupr (POSIX)  instead of strtoupper (removed from strutil)
*
* Revision 1.50  2012/05/20 06:39:27  pauloscustodio
* astyle
*
* Revision 1.49  2012/05/20 06:02:09  pauloscustodio
* Garbage collector
* Added automatic garbage collection on exit and simple fence mechanism
* to detect buffer underflow and overflow, to xmalloc functions.
* No longer needed to call init_malloc().
* No longer need to try/catch during creation of memory structures to
* free partially created data - all not freed data is freed atexit().
* Renamed xfree0() to xfree().
*
* Revision 1.48  2012/05/18 00:23:14  pauloscustodio
* define_symbol() defined as void, a fatal error is always raised on error.
*
* Revision 1.47  2012/05/17 21:36:06  pauloscustodio
* Remove global ASMERROR, redundant with TOTALERRORS.
* Remove IllegalArgumentException, replace by FatalErrorException.
*
* Revision 1.46  2012/05/17 17:49:20  pauloscustodio
* astyle
*
* Revision 1.45  2012/05/17 17:42:14  pauloscustodio
* define_symbol() defined as void, a fatal error is
* always raised on error.
*
* Revision 1.44  2012/05/17 14:56:23  pauloscustodio
* New init_except() to be called at start of main(), auto cleanup atexit(), no need to call e4c_context_end()
*
* Revision 1.43  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.42  2011/10/14 15:00:22  pauloscustodio
* - Move cpu_type to options.c.
* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
* - Factor strtoupper() to new module strutil.c.
*
* Revision 1.41  2011/10/07 17:53:04  pauloscustodio
* BUG_0015 : Relocation issue - dubious addresses come out of linking
* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
* The effect was that all address calculations at link phase were considering
*  a start offset of zero for all modules.
* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
* - Consequence of these two issues were all linked addresses wrong.
*
* Revision 1.40  2011/08/21 20:37:20  pauloscustodio
* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
* - Factor all pathname manipulation into module file.c.
* - Make default extensions constants.
* - Move asm_ext[] and obj_ext[] to the options.c module.
*
* Revision 1.39  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); 
*	if only one byte is available in codearea, and a 2 byte instruction is assembled, 
*	the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
* Revision 1.38  2011/08/19 10:20:32  pauloscustodio
* - Factored code to read/write word from file into xfget_u16/xfput_u16.
* - Renamed ReadLong/WriteLong to xfget_i32/xfput_u32 for symetry.
*
* Revision 1.37  2011/08/18 23:27:54  pauloscustodio
* BUG_0009 : file read/write not tested for errors
* - In case of disk full file write fails, but assembler does not detect the error
*   and leaves back corruped object/binary files
* - Created new exception FileIOException and ERR_FILE_IO error.
* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
*
* Revision 1.36  2011/08/18 21:47:48  pauloscustodio
* BUG_0008 : code block of 64K is read as zero
*
* Revision 1.35  2011/08/15 17:12:31  pauloscustodio
* Upgrade to Exceptions4c 2.8.9 to solve memory leak.
*
* Revision 1.34  2011/08/14 19:36:02  pauloscustodio
* - AssembleSourceFile(): error return is never used; changed to void
* - AssembleSourceFile(): added try-catch to delete incomplete files in case of fatal error, throw FatalErrorException instead of early return
* - main(): added try-catch to delete incomplete library file in case of fatal error
* - source_file_open not needed; z80asmfile can be used for the same purpose
*
* Revision 1.33  2011/08/05 20:07:49  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
* removing all the test code after each memory allocation.
* Replaced all functions that allocated memory structures by the new xcalloc_struct().
* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
* Created try/catch sequences to clean-up partially created memory structures and rethrow the
* exception, to cleanup memory leaks.
* Replaced all exit(1) by an exception.
* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
*
* Revision 1.32  2011/07/18 00:53:26  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
* BUG_0007 : memory leaks - Cleaned memory leaks in main(), ReleaseModules()
*
* Revision 1.31  2011/07/14 01:32:08  pauloscustodio
*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
*
* Revision 1.30  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.29  2011/07/11 16:16:44  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c,
* replaced all extern declarations of these variables by include options.h.
* Created declarations in z80asm.h of objects defined in z80asm.c.
*
* Revision 1.28  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.27  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
*
* Revision 1.26  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.25  2011/07/09 01:27:34  pauloscustodio
* Moved snprintf macro to z80asm.h
* Moved copyright info to hist.c
* Added casts to remove warnings
* BUG_0001 : Error in expression during link, expression garbled - memory corruption?
*      Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
*      compile with "z80asm -t4 -b test.asm"
*      fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
*                   Error in expression +¦+²+-;¾?.¹Ò¦Ò²Ù+vÝFÝVÝ^Ýx¦ Ý@ÝHÝPÝ".
*      Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
*      When the expression is read from the OBJ file at the link phase, the '\0'
*      at the end of the expression field is interpreted as a random separator
*      because ssym[] contains fewer elements (27) than the separators string (28);
*      hence in some cases the expression is parsed correctly, e.g. without -t4
*      the program assembles correctly.
*      If the random separator is a semicolon, GetSym() calls Skipline() to go past
*      the comment, and reads past the end of the expression in the OBJ file,
*      causing the parse of the next expression to fail.
* BUG_0002 : CreateLibFile and GetLibFile: buffer overrun
*      When the Z80_STDLIB variable is defined, libfilename is allocated with one byte
*      too short (strlen(filename) instead of strlen(filename)+1).
* BUG_0003 : Illegal options are ignored, although ReportError 9 (Illegal Option) exists
*      set_asm_flag(): Some options were missing the 'return' statement, following through
*      to the next tests; inserted 'return' in options 'M', 'I', 'L' and 'D'.
*      Added ReportError 9 (Illegal Option) if the option is not recognized.
* CH_0001 : Assembly error messages should appear on stderr
*      It's cumbersome to have to open .err files to see assembly errors.
*      Changed ReportError() to Write error messages to stderr in addition to the .err file.
*
* Revision 1.24  2010/09/19 00:06:20  dom
* Tweaks for compiling code generated by sdcc - it generates XREF rather than
* LIB so treat XREF as a LIB (this possibly should be the default)
*
* Do some _ mapping magic when in sdcc so standard z88dk libs can be used
* (wrong _ convention chosen a long time ago...)
*
* Have -forcexlib flag which treats MODULE as XLIB.
*
* Revision 1.23  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
*
* Revision 1.22  2009/07/18 23:23:15  dom
* clean up the code a bit more (Formatting and a fewer magic numbers)
*
* Revision 1.21  2009/06/22 22:12:53  dom
* Fix some win32 compiler issues
*
* Revision 1.20  2009/06/13 17:36:24  dom
* Add -I and -L to specify search paths for libraries and includes
*
* Revision 1.19  2007/07/21 22:43:35  dom
* bump the version to a random made up version, bump the date
*
* Revision 1.18  2007/07/21 22:41:00  dom
* some emacs foo to make my life easier.
*
* Support the concept of including from @lst files, simply list the include
* file will an @ at the start and it will be parsed for files. This should
* make library management a bit easier in that we don't have to add a new
* routine to about 25 .lst files!
*
* Revision 1.17  2007/02/28 11:23:24  stefano
* New platform !
* Rabbit Control Module 2000/3000.
*
* Revision 1.16  2003/12/01 22:04:25  denniz
* Fix for DOS/Win32 directory names with dots.
*
* Revision 1.15  2003/10/11 15:41:04  dom
* changes from garry
*
* - support for defp -> defp addr,bank
* - square brackets can be used in expressions
* - comma can be used in defm
*
* Revision 1.14  2002/12/09 19:55:24  dom
* version bump
*
* Revision 1.13  2002/12/01 15:47:17  dom
* local install on unix resolved
*
* Revision 1.12  2002/05/11 20:35:47  dom
* ahem
*
* Revision 1.11  2002/05/11 20:09:38  dom
* A patch around the appalling IF ELSE ENDIF handling of z80asm where it
* tries to evaluate FALSE clauses and gets completely in a twist.
*
* These patches turn off the output to the two errors that I've seen pop
* up in this state: Syntax error and unknown identifier. Please test this
* one quite hard if you get a change... - it was done to allow even more
* complicated logic in the z88 app startup to actually work - as soon as I'm
* happy with that I'll commit it as well
*
* Revision 1.10  2002/04/22 14:45:51  stefano
* Removed the SLL L undocumented instructions from the Graph library.
* NEW startup=2 mode for the ZX81 (SLOW mode... hoping we'll make it work in the future).
* MS Visual C compiler related fixes
* -IXIY option on Z80ASM to swap the IX and IY registers
*
* Revision 1.9  2002/02/20 21:37:57  dom
* merged in changes from rc1.4 branch to handle empty lines in list files
*
* Revision 1.8  2002/01/20 23:21:14  dom
* branches:  1.8.2;
* bumped version number and added prototype (from Dennis)
*
* Revision 1.7  2002/01/16 22:46:15  dom
* removing my debugging printfs..
*
* Revision 1.6  2002/01/16 22:45:34  dom
* if no module name is defined it now takes it from the filename after
* stripping off the path and any extensions
*
* Revision 1.5  2001/04/24 08:54:34  dom
* Added -h flag to print up usage, z80asm by itself just prints the
* copyright message
*
* Revision 1.4  2001/03/21 16:34:01  dom
* Added changes to allow labels to end in ':' and the prefix '.' isn't
* necessarily needed..this isn't guaranteed to be perfect so let me know
* of any problems and drop back to 1.0.18
*
* Revision 1.3  2001/02/28 17:59:22  dom
* Added UNDEFINE for undefining symbols, bumped version to 1.0.18
*
* Revision 1.2  2001/01/23 10:00:09  dom
* Changes by x1cygnus:
*
* just added a harcoded macro Invoke, similar to callpkg except that the
* instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
* the parameter -plus is specified on the command line.
*
* Changes by dom:
* Added in a rudimentary default directory set up (Defined at compile time)
* a bit kludgy and not very nice!
*
* Revision 1.1  2000/07/04 15:33:29  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:29  dom
* First import of z88dk into the sourceforge system <gulp>
*
* Revision 1.8.2.1  2002/02/20 21:35:19  dom
* changes from dennis to handle blank lines in file list files
*
*/

/* $History: Z80ASM.C $ */
/*  */
/* *****************  Version 22  ***************** */
/* User: Gbs          Date: 30-01-00   Time: 12:49 */
/* Updated in $/Z80asm */
/* New option -M implemented, which defines arbitrary object file name */
/* extension. */
/*  */
/* *****************  Version 21  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:12 */
/* Updated in $/Z80asm */
/* "V1.0.14" version text changes. */
/*  */
/* *****************  Version 20  ***************** */
/* User: Gbs          Date: 30-09-99   Time: 22:39 */
/* Updated in $/Z80asm */
/* CALL_PKG hard coded macro implemented for Garry Lancaster's Package */
/* System. */
/*  */
/* *****************  Version 18  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 16  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/* '#' changed to '@' in default help page. */
/* ReportError() changed to display the platform specific MAXCODESIZE */
/* value when the maximum code generation size has been reached. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:04 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Explicitly specified file source file extension automaticlly removed. */
/* Slight changes to default help page. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:12 */
/* Updated in $/Z80asm */
/* New function, ReportIOError().  */
/* ReportError() improved to display to <stderr> when no error filename is */
/* available and to display the name of the module in which the error */
/* occurred (this is especially useful during linking errors). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:14 */
/* Updated in $/Z80asm */
/* Program terminates with 1 if error occurs, otherwise 0 if all went OK. */
/* (Dominic Morris - djm@jb.man.ac.uk) */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 6-09-98    Time: 12:53 */
/* Updated in $/Z80asm */
/* -o logic replaced with -e<ext> option. This makes Z80asm completely */
/* configurable on which filename extension to use for source files. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:11 */
/* Updated in $/Z80asm */
/* ".opt" source files now parsed in stead of ".asm" files using new -o */
/* option. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:00 */
/* Updated in $/Z80asm */
/* SourceSafe Version  History comment block added. */
/* program version strings updated, "V1.0.3". */

/* All exit(-1) changed to exit(0) - djm 26/6/98 */
/* Cleaned up info so doesn't linewrap on Amiga */

/* Oops, screw up! exit(0) (was exit(-1))  should be exit(1) - djm 29/2/99 */
