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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/modlink.c,v 1.129 2014-06-23 22:27:09 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "except.h"
#include "expr.h"
#include "fileutil.h"
#include "listfile.h"
#include "modlink.h"
#include "options.h"
#include "scan.h"
#include "strpool.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"
#include "z80asm.h"
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
struct libfile *NewLibrary( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );

/* local functions */
int LinkModule( char *filename, long fptr_base );
int LinkTracedModule( char *filename, long baseptr );
int LinkLibModules( char *objfilename, long fptr_base, long startnames, long endnames );
int LinkLibModule( struct libfile *library, long curmodule, char *modname );
int SearchLibfile( struct libfile *curlib, char *modname );
char *ReadName( FILE *file );
void redefinedmsg( void );
void SearchLibraries( char *modname );
void ModuleExpr( void );
void CreateBinFile( void );
void ReadNames( char *filename, FILE *file );
void ReadExpr( FILE *file );
void ReleaseLinkInfo( void );
static char *CheckIfModuleWanted( FILE *file, long currentlibmodule, char *modname );

/* global variables */
extern char Z80objhdr[];
extern Byte reloc_routine[];
extern struct liblist *libraryhdr;
extern char *reloctable, *relocptr;

struct linklist *linkhdr;
struct libfile *CURRENTLIB;
UInt totaladdr, curroffset;

void
ReadNames( char *filename, FILE *file )
{
    int scope, symbol_char;
    Byte symboltype = 0;
    long value;
	DEFINE_STR( section_name, MAXLINE );
	DEFINE_STR( name, MAXLINE );

    while (TRUE)
    {
        scope = xfget_int8(  file );
		if ( scope == 0 )
			break;								/* terminator */

        symbol_char	= xfget_int8(  file );		/* type of name   */

		xfget_count_byte_Str( file, section_name );	/* read section name */

		value		= xfget_int32( file );		/* read symbol (long) integer */
		xfget_count_byte_Str( file, name );		/* read symbol name */

		new_section( section_name->str );		/* define CURRENTSECTION */

        switch ( symbol_char )
        {
        case 'A': symboltype = SYM_ADDR; break;
        case 'C': symboltype = 0; break;
        default:
            error_not_obj_file( filename );
        }

        switch ( scope )
        {
        case 'L': define_local_sym( name->str, value, symboltype ); break;
        case 'G': define_global_sym( name->str, value, symboltype ); break;
        default:
            error_not_obj_file( filename );
        }
    }
}



void
ReadExpr( FILE *file )
{
	static Str *expr_text;
	static Str *source_filename;
	static Str *section_name;
	int line_nr;
	int type;
    long constant;
    Expr *expr;
    UInt asmpc, offsetptr;
	UInt base_addr, offset;

	INIT_OBJ( Str, &expr_text );
	INIT_OBJ( Str, &source_filename );
	INIT_OBJ( Str, &section_name );

	while (1) 
	{
        type = xfget_int8(   file );
		if ( type == 0 )
			break;			/* end marker */

		/* source file and line number */
		xfget_count_word_Str( file, source_filename );
		if ( source_filename->len > 0 )
			set_error_file( source_filename->str );
		
		line_nr = xfget_int32( file );
		if ( line_nr > 0 )
			set_error_line( line_nr );

		/* patch location */
		xfget_count_byte_Str( file, section_name );
		asmpc		= xfget_uint16( file );
        offsetptr	= xfget_uint16( file );

		/* assembler PC as absolute address */
		new_section( section_name->str );
		base_addr = CURRENTSECTION->addr;
		offset    = get_cur_module_start(); 
        set_PC( asmpc + base_addr + offset );

		xfget_count_word_Str( file, expr_text );	/* get expression */

		/* read expression followed by newline */
		Str_append_char( expr_text, '\n');
		SetTemporaryLine( expr_text->str );			/* read expression */

        EOL = FALSE;                /* reset end of line parsing flag - a line is to be parsed... */

        GetSym();

        if ( ( expr = expr_parse() ) != NULL )
        {
            /* parse numerical expression */
            if ( expr->expr_type & NOT_EVALUABLE )
            {
                error_not_defined();
            }
            else
            {
                constant = Expr_eval( expr );

                switch ( type )
                {
                case 'U':
                    if ( constant < -128 || constant > 255 )
                        warn_int_range( constant );

                    patch_byte( &offsetptr, (Byte) constant );
                    break;

                case 'S':
                    if ( constant < -128 || constant > 127 )
                        warn_int_range( constant );

                    patch_byte( &offsetptr, (Byte) constant );  /* opcode is stored, now store signed 8bit value */
                    break;

                case 'C':
                    if ( constant < -32768 || constant > 65535 )
                        warn_int_range( constant );

                    patch_word( &offsetptr, constant ); offsetptr -= 2;

                    if ( opts.relocatable )
                        if ( expr->expr_type & SYM_ADDR )
                        {
                            /* Expression contains relocatable address */
							UInt distance = offsetptr + offset - curroffset;

                            if ( distance >= 0 && distance <= 255 )
                            {
                                *relocptr++ = (Byte) distance;
                                sizeof_reloctable++;
                            }
                            else
                            {
                                *relocptr++ = 0;
                                *relocptr++ = distance & 0xFF;
                                *relocptr++ = distance >> 8;
                                sizeof_reloctable += 3;
                            }

                            totaladdr++;
                            curroffset = offsetptr + offset;
                        }

                    break;

                case 'L':
                    if ( constant < LONG_MIN || constant > LONG_MAX )
                        warn_int_range( constant );

                    patch_long( &offsetptr, constant );
                    break;
                }
            }

            OBJ_DELETE( expr );
        }
    }
}

/*-----------------------------------------------------------------------------
*   relocate all SYM_ADDR symbols based on address from start of sections
*----------------------------------------------------------------------------*/
static void relocate_symbols_symtab( SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;
	UInt			base_addr;
	UInt			offset;

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = (Symbol *) iter->value;
		if ( sym->sym_type & SYM_ADDR ) 
		{
			assert( sym->owner );				/* owner should exist except for -D defines */
			
			/* set base address for symbol */
			set_cur_module(  sym->owner );
			set_cur_section( sym->section );

			base_addr = sym->section->addr;
			offset    = get_cur_module_start();

            sym->value += base_addr + offset;	/* Absolute address */
		}
	}
}

static void relocate_symbols( void )
{
    Module		   *module;
	ModuleListElem *iter;

	for ( module = get_first_module( &iter ) ; module != NULL  ;
		  module = get_next_module( &iter ) )  
    {
		relocate_symbols_symtab( module->local_symtab );
	}
	relocate_symbols_symtab( global_symtab );
}

/*-----------------------------------------------------------------------------
*   Define symbols with sections and code start, end and size
*----------------------------------------------------------------------------*/
static void define_location_symbols( void )
{
	Section *section;
	SectionHashElem *iter;
	DEFINE_STR( name, MAXLINE );
	UInt start_addr, end_addr;

	/* global code size */
	start_addr = get_first_section(NULL)->addr;
	section    = get_last_section();
	end_addr   = section->addr + get_section_size( section );
	
    if ( opts.verbose )
        printf("Code size of linked modules is %d bytes ($%04X to $%04X)\n",
		       (int)(end_addr - start_addr), (int)start_addr, (int)end_addr );

	Str_sprintf( name, ASMHEAD_KW, "", "" ); 
	define_global_def_sym( name->str, start_addr );
	
	Str_sprintf( name, ASMTAIL_KW, "", "" ); 
	define_global_def_sym( name->str, end_addr );
	
	Str_sprintf( name, ASMSIZE_KW, "", "" ); 
	define_global_def_sym( name->str, end_addr - start_addr );

	/* size of each named section - skip "" section */
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		if ( *(section->name) != '\0' )
		{
			start_addr = section->addr;
			end_addr   = start_addr + get_section_size( section );

			if ( opts.verbose )
				printf("Section '%s' is %d bytes ($%04X to $%04X)\n",
					   section->name, (int)(end_addr - start_addr), 
					   (unsigned int)start_addr, (unsigned int)end_addr );

			Str_sprintf( name, ASMHEAD_KW, "_", section->name ); 
			define_global_def_sym( name->str, start_addr );

			Str_sprintf( name, ASMTAIL_KW, "_", section->name ); 
			define_global_def_sym( name->str, end_addr );

			Str_sprintf( name, ASMSIZE_KW, "_", section->name ); 
			define_global_def_sym( name->str, end_addr - start_addr );
		}
	}
}

/*-----------------------------------------------------------------------------
*   link
*----------------------------------------------------------------------------*/
void link_modules( void )
{
    char fheader[9];
    Int origin = -1;
    Module *module, *first_obj_module, *last_obj_module;
	ModuleListElem *iter;
	Bool saw_last_obj_module;
    char *obj_filename;
	FILE *file;

    opts.symtable = opts.cur_list = FALSE;
    linkhdr = NULL;

    if ( opts.verbose )
        puts( "linking module(s)...\nPass1..." );

    if ( opts.relocatable )
    {
        reloctable = xnew_n( char, 32768U );
        relocptr = reloctable;
        relocptr += 4;  /* point at first offset to store */
        totaladdr = 0;
        sizeof_reloctable = 0;  /* relocation table, still 0 elements .. */
        curroffset = 0;
    }
    else
    {
        reloctable = NULL;
    }

    TRY
    {
		/* remember current first and last modules, i.e. before adding library modules */
		first_obj_module = get_first_module( &iter );
		last_obj_module  = get_last_module( NULL );

		/* link machine code & read symbols in all modules */
		for ( module = first_obj_module, saw_last_obj_module = FALSE ;
			  module != NULL && ! saw_last_obj_module ;
			  module = get_next_module( &iter ) )  
        {
			set_cur_module( module );

	        /* open error file on first module */
			if ( CURRENTMODULE == first_obj_module )
		        open_error_file( CURRENTMODULE->filename );

            set_error_null();
            set_error_module( CURRENTMODULE->modname );

            if ( opts.library )
            {
                CURRENTLIB = libraryhdr->firstlib;      /* begin library search  from first library for each
                                                        * module */
                CURRENTLIB->nextobjfile = 8;            /* point at first library module (past header) */
            }

            /* overwrite '.asm' extension with * '.obj' */
            obj_filename = get_obj_filename( CURRENTMODULE->filename );

            /* open relocatable file for reading */
            file = xfopen( obj_filename, "rb" );           /* CH_0012 */
			/* read first 8 chars from file into array */
            xfget_chars( file, fheader, 8 );
            fheader[8] = '\0';

            /* compare header of file */
            if ( strcmp( fheader, Z80objhdr ) != 0 )
            {
                error_not_obj_file( obj_filename );  /* not a object     file */
                xfclose( file );
                break;
            }

			/* compute origin on first module */
            if ( CURRENTMODULE == first_obj_module )
            {
				origin = xfget_int32( file );	/* origin of first module */

                if ( opts.relocatable )
                    origin = 0;					/* ORG 0 on auto relocation */
                else if ( opts.origin >= 0 )
                    origin = opts.origin;		/* use origin from command line */
				else if ( origin < 0 )
                {
                    error_org_not_defined();  /* no ORG */
                    xfclose( file );
                    break;
                }
				else
				{
                }

                if ( opts.verbose )
                    printf( "ORG address for code is $%04X\n", origin );
            }

            xfclose( file );

            LinkModule( obj_filename, 0 );       /* link code & read name definitions */

	        /* parse only object modules, not added library modules */
			if ( CURRENTMODULE == last_obj_module )
				saw_last_obj_module = TRUE;

		}

        set_error_null();

		/* allocate segment addresses and compute absolute addresses of symbols */
		if ( ! get_num_errors() )
			sections_alloc_addr( origin );

		if ( ! get_num_errors() )
			relocate_symbols();

		/* define assembly size */
		if ( ! get_num_errors() )
			define_location_symbols();

		if ( ! get_num_errors() )
            ModuleExpr();               /*  Evaluate expressions in  all modules */
    }
    FINALLY
    {
        set_error_null();

        ReleaseLinkInfo();              /* Release module link information */

        close_error_file();
    }
    ETRY;
}




int
LinkModule( char *filename, long fptr_base )
{
	static Str *section_name;
    long fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
    Int code_size;
    int flag = 0;
	FILE *file;
	UInt addr;

	INIT_OBJ( Str, &section_name );

    /* open object file for reading */
    file = xfopen( filename, "rb" );           /* CH_0012 */
    fseek( file, fptr_base + 12, SEEK_SET );

    fptr_modname	= xfget_int32( file );	/* get file pointer to module name */
					  xfget_int32( file );	/* get file pointer to expression declarations */
    fptr_namedecl	= xfget_int32( file );	/* get file pointer to name declarations */
    fptr_libnmdecl	= xfget_int32( file );	/* get file pointer to library name declarations */
    fptr_modcode	= xfget_int32( file );	/* get file pointer to module code */

    if ( fptr_modcode != -1 )
    {
        fseek( file, fptr_base + fptr_modcode, SEEK_SET );  /* set file pointer to module code */

		while (TRUE)	/* read sections until end marker */
		{
			code_size = xfget_int32( file );
			if ( code_size < 0 )
				break;

			xfget_count_byte_Str( file, section_name );

			/* load bytes to section */
			/* BUG_0015: was reading at current position in code area, swaping order of modules */
			new_section( section_name->str );
			addr = 0;
			patch_file_contents( file, &addr, code_size );
		}
    }

    if ( fptr_namedecl != -1 )
    {
        fseek( file, fptr_base + fptr_namedecl, SEEK_SET );  /* set file pointer to point at name
                                                                 * declarations */
		ReadNames( filename, file );
    }

    xfclose( file );

    if ( fptr_libnmdecl != -1 )
    {
        if ( opts.library )
        {
            /* search in libraries, if present */
            flag = LinkLibModules( filename, fptr_base, fptr_libnmdecl, fptr_modname );   /* link library modules */

            if ( !flag )
                return 0;
        }
    }

    return LinkTracedModule( filename, fptr_base );       /* Remember module for pass2 */
}




int
LinkLibModules( char *filename, long fptr_base, long nextname, long endnames )
{
    FILE *file;
	DEFINE_STR( name, MAXLINE );

    do
    {
        /* open object file for reading */
        file = xfopen( filename, "rb" );           /* CH_0012 */
        fseek( file, fptr_base + nextname, SEEK_SET );	/* set file pointer to point at 
														 * library name declarations */
        xfget_count_byte_Str( file, name );				/* read library reference name */
        xfclose( file );

        nextname += 1 + name->len;	/* remember module pointer to next name in this object module */

        if ( find_global_symbol( name->str ) == NULL )
            SearchLibraries( name->str );       /* search name in libraries */
    }
    while ( nextname < endnames );

    return 1;
}




void
SearchLibraries( char *modname )
{
    int i;

    for ( i = 0; i < 2; i++ )
    {
        /* Libraries searched in max. 2 passes */
        while ( CURRENTLIB != NULL )
        {
            if ( SearchLibfile( CURRENTLIB, modname ) )
            {
                return;
            }

            CURRENTLIB = CURRENTLIB->nextlib;

            if ( CURRENTLIB != NULL )
                if ( CURRENTLIB->nextobjfile != 8 )
                {
                    CURRENTLIB->nextobjfile = 8;    /* search at start of next lib */
                }
        }

        /* last library read ... */
        CURRENTLIB = libraryhdr->firstlib;        /* start at the beginning of the first module */
        CURRENTLIB->nextobjfile = 8;              /* in the first library */
    }
}



int
SearchLibfile( struct libfile *curlib, char *modname )
{
    long currentlibmodule, modulesize;
    char *mname;
    FILE *file;

    file = xfopen( curlib->libfilename, "rb" );           /* CH_0012 */

    while ( curlib->nextobjfile != -1 )
    {
        /* search name in all available library modules */
        do
        {
            /* point at first available module in library */
            fseek( file, curlib->nextobjfile, SEEK_SET );	/* point at beginning of a module */
            currentlibmodule	= curlib->nextobjfile;
            curlib->nextobjfile	= xfget_int32( file );		/* get file pointer to next module in library */
            modulesize			= xfget_int32( file );		/* get size of current module */
        }
        while ( modulesize == 0 && curlib->nextobjfile != -1 );

        if ( modulesize != 0 )
        {
            if ( ( mname = CheckIfModuleWanted( file, currentlibmodule, modname ) ) != NULL )
            {
                xfclose( file );
                return LinkLibModule( curlib, currentlibmodule + 4 + 4, mname );
            }
            else if ( opts.sdcc &&
                      modname[0] == '_' &&
                      ( mname = CheckIfModuleWanted( file, currentlibmodule, modname + 1 ) ) != NULL )
            {
                xfclose( file );
                return LinkLibModule( curlib, currentlibmodule + 4 + 4, mname );
            }
        }
    }

    xfclose( file );
    return 0;
}


/** \brief Check to see if a library module is required
 *
 *  \param z80asmfile - File to read from
 *  \param currentlibmodule - Current offset in file
 *  \param modname - Module/symbol to search for

 */
static char *
CheckIfModuleWanted( FILE *file, long currentlibmodule, char *modname )
{
    long fptr_mname, fptr_name, fptr_libname;
    enum flag found = OFF;
	DEFINE_STR( got_modname, MAXLINE );
	DEFINE_STR( symbol_name, MAXLINE );
	DEFINE_STR( section_name, MAXLINE );

    /* found module name? */
    fseek( file, currentlibmodule + 4 + 4 + 8 + 4, SEEK_SET );     
													/* point at module name  file pointer */
    fptr_mname		= xfget_int32( file );			/* get module name file  pointer   */
					  xfget_int32( file );			/* fptr_expr */
    fptr_name		= xfget_int32( file );
    fptr_libname	= xfget_int32( file );
    fseek( file, currentlibmodule + 4 + 4 + fptr_mname, SEEK_SET );       
													/* point at module name  */
	xfget_count_byte_Str( file, got_modname );		/* read module name */

    if ( strcmp( got_modname->str, modname ) == 0 )
    {
        found = ON;
    }
    else
    {
        /* We didn't find the module name, lets have a look through the exported symbol list */
        if ( fptr_name != 0 )
        {
            /* Move to the name section */
            fseek( file, currentlibmodule + 4 + 4 + fptr_name, SEEK_SET );

            while ( ! found )
            {
                int scope;

                scope = xfget_int8(  file );
				if ( scope == 0 )
					break;

                xfget_int8(  file );			/* type */
				xfget_count_byte_Str( file, section_name );
				xfget_int32( file );			/* value */
				xfget_count_byte_Str( file, symbol_name );

                if ( ( scope == 'G' ) && 
					 strcmp( symbol_name->str, modname ) == 0 )
                {
                    found = ON;
                }
            }
        }
    }

    return found ? strpool_add( got_modname->str ) : NULL;
}

int
LinkLibModule( struct libfile *library, long curmodule, char *modname )
{
    Module *tmpmodule, *lib_module;
    int flag;

    tmpmodule = get_cur_module();					/* remember current module */

	/* create new module to link library */
	lib_module = set_cur_module( new_module() );
	lib_module->modname = strpool_add( modname );

    if ( opts.verbose )
    {
        printf( "Linking library module <%s>\n", modname );
    }

    flag = LinkModule( library->libfilename, curmodule );       /* link module & read names */

    set_cur_module( tmpmodule );		/* restore previous current module */
    return flag;
}


void
ModuleExpr( void )
{
    long fptr_namedecl, fptr_modname, fptr_exprdecl, fptr_libnmdecl;
    long fptr_base;
    struct linkedmod *curlink;
	FILE *file;

    if ( opts.verbose )
        puts( "Pass2..." );

    curlink = linkhdr->firstlink;

    do
    {
		set_cur_module( curlink->moduleinfo );

        fptr_base = curlink->modulestart;

        set_error_null();
        //set_error_module( CURRENTMODULE->modname );
        //set_error_file(   CURRENTMODULE->filename );

        /* open relocatable file for reading */
        file = xfopen( curlink->objfilename, "rb" );	/* CH_0012 */
        fseek( file, fptr_base + 12, SEEK_SET );		/* point at module name  pointer   */
        fptr_modname	= xfget_int32( file );			/* get file pointer to module name */
        fptr_exprdecl	= xfget_int32( file );			/* get file pointer to expression declarations */
        fptr_namedecl	= xfget_int32( file );			/* get file pointer to name declarations */
        fptr_libnmdecl	= xfget_int32( file );			/* get file pointer to library name declarations */

        if ( fptr_exprdecl != -1 )
        {
        	fseek( file, fptr_base + fptr_exprdecl, SEEK_SET );
			ReadExpr( file );
        }

        xfclose( file );

        curlink = curlink->nextlink;
    }
    while ( curlink != NULL );

    set_error_null();
}



void
CreateBinFile( void )
{
    FILE *binaryfile;
    UInt codeblock, offset;
    int segment;
    char *filename;
	UInt codesize = get_sections_size();
	Bool is_relocatable = ( opts.relocatable && totaladdr != 0 );
	Bool is_segmented   = ( opts.code_seg && codesize > 16384 );

    if ( opts.bin_file )        /* use predined output filename from command line */
        filename = opts.bin_file;
    else
    {
        /* create output filename, based on project filename */
        /* get source filename from first module */
        if ( ! is_relocatable && is_segmented )
            filename = get_segbin_filename( get_first_module(NULL)->filename, 0 );	/* add '.bn0' extension */
        else
            filename = get_bin_filename( get_first_module(NULL)->filename );		/* add '.bin' extension */
    }

    /* binary output to filename.bin */
    binaryfile = xfopen( filename, "wb" );         /* CH_0012 */

    if ( is_relocatable )
    {
		/* relocate routine */
        xfput_chars( binaryfile, (char *) reloc_routine, sizeof_relocroutine );

        *( reloctable + 0 ) = (UInt) totaladdr % 256U;
        *( reloctable + 1 ) = (UInt) totaladdr / 256U;  /* total of relocation elements */
        *( reloctable + 2 ) = (UInt) sizeof_reloctable % 256U;
        *( reloctable + 3 ) = (UInt) sizeof_reloctable / 256U; /* total size of relocation table elements */

		/* write relocation table, inclusive 4 byte header */
        xfput_chars( binaryfile, reloctable, sizeof_reloctable + 4 );

		printf( "Relocation header is %d bytes.\n", ( int )( sizeof_relocroutine + sizeof_reloctable + 4 ) );
        fwrite_codearea( binaryfile );                                /* write code as one big chunk */
    }
    else if ( is_segmented )
    {
        offset = 0;
        segment = 0;
        while (TRUE)
        {
            codeblock = ( codesize > 16384 ) ? 16384 : codesize;
            codesize -= codeblock;
         
            fwrite_codearea_chunk( binaryfile, offset, codeblock ); /* code in 16K chunks */
            xfclose( binaryfile );

			if ( codesize == 0 )
				break;

            offset += codeblock;
            segment++;

            filename = get_segbin_filename( filename, segment );	/* path code file with number */
			binaryfile = xfopen( filename, "wb" );         /* CH_0012 */
        }
    }
    else
    {
        fwrite_codearea( binaryfile );                                /* write code as one big chunk */
    }

	xfclose( binaryfile );

    if ( opts.verbose )
        puts( "Code generation completed." );
}



int
LinkTracedModule( char *filename, long baseptr )
{
    struct linkedmod *newm;
    char *fname;

    if ( linkhdr == NULL )
    {
        linkhdr = xnew( struct linklist );
        linkhdr->firstlink = NULL;
        linkhdr->lastlink = NULL;       /* Library header initialised */
    }

    fname = xstrdup( filename );        /* get a copy module file name */

    newm = xnew( struct linkedmod );
    newm->nextlink = NULL;
    newm->objfilename = fname;
    newm->modulestart = baseptr;
    newm->moduleinfo = CURRENTMODULE;   /* pointer to current (active) module structure   */

    if ( linkhdr->firstlink == NULL )
    {
        linkhdr->firstlink = newm;
        linkhdr->lastlink = newm;       /* First module trace information */
    }
    else
    {
        linkhdr->lastlink->nextlink = newm;     /* current/last linked module points now at new current */
        linkhdr->lastlink = newm;               /* pointer to current linked module updated */
    }

    return 1;
}


void
ReleaseLinkInfo( void )
{
    struct linkedmod *m, *n;

    if ( linkhdr == NULL )
    {
        return;
    }

    m = linkhdr->firstlink;

    while ( m != NULL )               /* move test to start in case list is empty */
    {
        if ( m->objfilename != NULL )
        {
            xfree( m->objfilename );
        }

        n = m->nextlink;
        xfree( m );
        m = n;
    }

    xfree( linkhdr );

    linkhdr = NULL;
}
