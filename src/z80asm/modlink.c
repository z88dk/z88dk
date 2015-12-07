/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2015
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "listfile.h"
#include "modlink.h"
#include "options.h"
#include "scan.h"
#include "strpool.h"
#include "str.h"
#include "sym.h"
#include "symbol.h"
#include "z80asm.h"
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
struct libfile *NewLibrary( void );

/* local functions */
int LinkModule( char *filename, long fptr_base );
int LinkTracedModule( char *filename, long baseptr );
int LinkLibModules( char *objfilename, long fptr_base, long startnames, long endnames );
int LinkLibModule( struct libfile *library, long curmodule, char *modname );
int SearchLibfile( struct libfile *curlib, char *modname );
char *ReadName( FILE *file );
void SearchLibraries( char *modname );
void CreateBinFile(void);
void ReadNames(char *filename, FILE *file);
void ReleaseLinkInfo( void );
static char *CheckIfModuleWanted( FILE *file, long currentlibmodule, char *modname );

/* global variables */
extern char Z80objhdr[];
extern Byte reloc_routine[];
extern struct liblist *libraryhdr;
extern char *reloctable, *relocptr;

struct linklist *linkhdr;
struct libfile *CURRENTLIB;
int totaladdr, curroffset;

static void ReadNames_1(char *filename, FILE *file, Str *section_name, Str *name)
{
    int scope, symbol_char;
	sym_type_t type = TYPE_UNKNOWN;
    long value;

    while (TRUE)
    {
        scope = xfget_int8(  file );
		if ( scope == 0 )
			break;								/* terminator */

        symbol_char	= xfget_int8(  file );		/* type of name   */

		xfget_count_byte_Str( file, section_name );	/* read section name */

		value		= xfget_int32( file );		/* read symbol (long) integer */
		xfget_count_byte_Str( file, name );		/* read symbol name */

		new_section( str_data(section_name) );		/* define CURRENTSECTION */

        switch ( symbol_char )
        {
        case 'A': type = TYPE_ADDRESS;  break;
        case 'C': type = TYPE_CONSTANT; break;
        case '=': type = TYPE_COMPUTED; break;
        default:
            error_not_obj_file( filename );
        }

        switch ( scope )
        {
		case 'L': define_local_sym(str_data(name), value, type); break;
		case 'G': define_global_sym(str_data(name), value, type); break;
        default:
            error_not_obj_file( filename );
        }
    }
}

void ReadNames(char *filename, FILE *file)
{
	STR_DEFINE(section_name, STR_SIZE);
	STR_DEFINE(name, STR_SIZE);

	ReadNames_1(filename, file, section_name, name);

	STR_DELETE(section_name);
	STR_DELETE(name);
}


/* set environment to compute expression */
static void set_asmpc_env( Module *module, char *section_name,
						   char *filename, int line_nr,
						   int asmpc, 
						   Bool module_relative_addr )
{
	int base_addr, offset;

	/* point to current module */
	set_cur_module( module );

	/* source file and line number */
	set_error_file( filename );
	set_error_line( line_nr );

	/* assembler PC as absolute address */
	new_section( section_name );

	if ( module_relative_addr ) {
		set_PC( asmpc );
	}
	else {
		base_addr = CURRENTSECTION->addr;
		offset    = get_cur_module_start(); 
		set_PC( asmpc + base_addr + offset );
	}
}

/* set environment to compute expression */
static void set_expr_env( Expr *expr, Bool module_relative_addr )
{
	set_asmpc_env( expr->module, expr->section->name, 
				   expr->filename, expr->line_nr, 
				   expr->asmpc,
				   module_relative_addr );
}

/* read the current modules' expressions to the given list */
static void read_cur_module_exprs_1(ExprList *exprs, FILE *file, char *filename,
	Str *expr_text, Str *last_filename, Str *source_filename, Str *section_name, Str *target_name)
{
	int line_nr;
	int type;
    Expr *expr;
    int asmpc, code_pos;

	while (1) 
	{
        type = xfget_int8( file );
		if ( type == 0 )
			break;			/* end marker */

		/* source file and line number */
		xfget_count_word_Str( file, source_filename );
		if ( str_len(source_filename) == 0 )
			str_set( source_filename, str_data(last_filename) );
		else
			str_set( last_filename, str_data(source_filename) );

		line_nr = xfget_int32( file );

		/* patch location */
		xfget_count_byte_Str( file, section_name );

		asmpc		= xfget_uint16( file );
        code_pos	= xfget_uint16( file );

		xfget_count_byte_Str( file, target_name );	/* get expression EQU target, if not empty */
		xfget_count_word_Str( file, expr_text );	/* get expression */

		/* read expression followed by newline */
		str_append_char( expr_text, '\n');
		SetTemporaryLine( str_data(expr_text) );			/* read expression */

        EOL = FALSE;                /* reset end of line parsing flag - a line is to be parsed... */

		scan_expect_operands();
        GetSym();

		/* parse and store expression in the list */
		set_asmpc_env( CURRENTMODULE, str_data(section_name), 
					   str_data(source_filename), line_nr, 
					   asmpc,
					   FALSE );
        if ( ( expr = expr_parse() ) != NULL )
        {
			expr->range = 0;
            switch ( type )
            {
            case 'U': expr->range = RANGE_BYTE_UNSIGNED; break;
            case 'S': expr->range = RANGE_BYTE_SIGNED;  break;
            case 'C': expr->range = RANGE_WORD;			break;
            case 'L': expr->range = RANGE_DWORD;		break;
			case '=': expr->range = RANGE_WORD;
					  assert( str_len(target_name) > 0 );
					  expr->target_name = strpool_add( str_data(target_name) );	/* define expression as EQU */
					  break;
			default:
				error_not_obj_file( filename );
            }

			expr->module	= CURRENTMODULE;
			expr->section	= CURRENTSECTION;
			expr->asmpc		= asmpc;
			expr->code_pos	= code_pos;
			expr->filename	= strpool_add( str_data(source_filename) );
			expr->line_nr	= line_nr;
			expr->listpos	= -1;

			ExprList_push( & exprs, expr );
		}
    }
}

static void read_cur_module_exprs(ExprList *exprs, FILE *file, char *filename)
{
	STR_DEFINE(expr_text, STR_SIZE);
	STR_DEFINE(last_filename, STR_SIZE);
	STR_DEFINE(source_filename, STR_SIZE);
	STR_DEFINE(section_name, STR_SIZE);
	STR_DEFINE(target_name, STR_SIZE);

	read_cur_module_exprs_1(exprs, file, filename, 
		expr_text, last_filename, source_filename, section_name, target_name);

	STR_DELETE(expr_text);
	STR_DELETE(last_filename);
	STR_DELETE(source_filename);
	STR_DELETE(section_name);
	STR_DELETE(target_name);

}

/* read all the modules' expressions to the given list */
static void read_module_exprs( ExprList *exprs )
{
    long fptr_exprdecl;
    long fptr_base;
    struct linkedmod *curlink;
	FILE *file;

    curlink = linkhdr->firstlink;

    do
    {
		set_cur_module( curlink->moduleinfo );

        fptr_base = curlink->modulestart;

        set_error_null();

        /* open relocatable file for reading */
        file = myfopen( curlink->objfilename, "rb" );	
		if (file)
		{
			fseek(file, fptr_base + 8, SEEK_SET);			/* point at module name  pointer   */
			/*fptr_modname*/  xfget_int32(file);			/* get file pointer to module name */
			fptr_exprdecl = xfget_int32(file);			/* get file pointer to expression declarations */
			/*fptr_namedecl*/ xfget_int32(file);			/* get file pointer to name declarations */
			/*fptr_libnmdecl*/xfget_int32(file);			/* get file pointer to library name declarations */

			if (fptr_exprdecl != -1)
			{
				fseek(file, fptr_base + fptr_exprdecl, SEEK_SET);
				read_cur_module_exprs(exprs, file, curlink->objfilename);
			}

			myfclose(file);
		}

        curlink = curlink->nextlink;
    }
    while ( curlink != NULL );

    set_error_null();
}

/* compute equ expressions and remove them from the list 
   return >0: number of computed expressions
   return 0 : nothing done, all EQU expression computed and removed from list
   return <0: -(number of expressions with unresolved symbols)
*/
static int compute_equ_exprs_once( ExprList *exprs, Bool show_error, Bool module_relative_addr )
{
	ExprListElem *iter;
    Expr *expr, *expr2;
	long value;
	int  num_computed   = 0;
	int  num_unresolved = 0;
	Bool computed;

	iter = ExprList_first( exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;
		computed = FALSE;

		if ( expr->target_name )
		{
			/* touch symbol so that it ends in object file */
			Symbol *sym = get_used_symbol(expr->target_name);
			sym->is_touched = TRUE;

			/* expressions with symbols from other sections need to be passed to the link phase */
			if (!module_relative_addr || /* link phase */
				Expr_is_local_in_section(expr, CURRENTMODULE, CURRENTSECTION) /* or symbols from other sections */
				)
			{
				set_expr_env(expr, module_relative_addr);
				value = Expr_eval(expr, show_error);
				if (expr->result.not_evaluable)		/* unresolved */
				{
					num_unresolved++;
				}
				else if (!expr->is_computed)
				{
					/* expression depends on other variables not yet computed */
				}
				else
				{
					num_computed++;
					computed = TRUE;
					update_symbol(expr->target_name, value, expr->type);
				}
			}
		}

		/* continue loop - delete expression if computed */
		if ( computed )
		{
			/* remove current expression, advance iterator */
			expr2 = ExprList_remove( exprs, &iter );
			assert( expr == expr2 );

			OBJ_DELETE( expr );	
		}
		else
			iter = ExprList_next( iter );
	}

	if ( num_computed > 0 )
		return num_computed;
	else if ( num_unresolved > 0 )
		return - num_unresolved;
	else 
		return 0;
}

/* compute all equ expressions, removing them from the list */
void compute_equ_exprs( ExprList *exprs, Bool show_error, Bool module_relative_addr )
{
	int  compute_result;

	/* loop to solve dependencies while some are solved */
	do {
		compute_result = compute_equ_exprs_once( exprs, FALSE, module_relative_addr );
	} while ( compute_result > 0 );

	/* if some unresolved, give up and show error */
	if ( show_error && compute_result < 0 )
		compute_equ_exprs_once( exprs, TRUE, module_relative_addr );
}

/* compute and patch expressions */
static void patch_exprs( ExprList *exprs )
{
	ExprListElem *iter;
    Expr *expr, *expr2;
	long value;

	iter = ExprList_first( exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;
		assert( expr->target_name == NULL );		/* EQU expressions are already computed */

		set_expr_env( expr, FALSE );
		value = Expr_eval(expr, TRUE);

		if (!expr->result.not_evaluable)			/* not unresolved */
		{
            switch ( expr->range )
            {
            case RANGE_BYTE_UNSIGNED:
                if ( value < -128 || value > 255 )
                    warn_int_range( value );

				patch_byte(expr->code_pos, (Byte)value);
                break;

            case RANGE_BYTE_SIGNED:
                if ( value < -128 || value > 127 )
                    warn_int_range( value );

				patch_byte(expr->code_pos, (Byte)value);
                break;

            case RANGE_WORD:
                if ( value < -32768 || value > 65535 )
                    warn_int_range( value );

				patch_word(expr->code_pos, value); 

				/* Expression contains relocatable address */
				if (expr->type == TYPE_ADDRESS) {

					/* save section reloc data */
					*(intArray_push(expr->section->reloc)) = expr->code_pos + get_cur_module_start();
				
					/* relocate code */
					if (opts.relocatable)
					{
						int offset = get_cur_module_start() + expr->section->addr;
						int distance = expr->code_pos + offset - curroffset;

						if (distance > 0 && distance < 256)	// Bugfix: when zero, need to use 3 bytes
						{
							*relocptr++ = (Byte)distance;
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
						curroffset = expr->code_pos + offset;
					}
				}                
                break;

            case RANGE_DWORD:
                if ( value < LONG_MIN || value > LONG_MAX )
                    warn_int_range( value );

				patch_long(expr->code_pos, value);
                break;

			default: assert(0);
            }

		}

		/* remove current expression, advance iterator */
		expr2 = ExprList_remove( exprs, &iter );
		assert( expr == expr2 );

		OBJ_DELETE( expr );	
	}
}

/*-----------------------------------------------------------------------------
*   relocate all SYM_ADDR symbols based on address from start of sections
*----------------------------------------------------------------------------*/
static void relocate_symbols_symtab( SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;
	int			base_addr;
	int			offset;

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = (Symbol *) iter->value;
		if ( sym->type == TYPE_ADDRESS ) 
		{
			assert( sym->module );				/* owner should exist except for -D defines */
			
			/* set base address for symbol */
			set_cur_module(  sym->module );
			set_cur_section( sym->section );

			base_addr = sym->section->addr;
			offset    = get_cur_module_start();

            sym->value += base_addr + offset;	/* Absolute address */
			sym->is_computed = TRUE;
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
	STR_DEFINE( name, STR_SIZE );
	int start_addr, end_addr;

	/* global code size */
	start_addr = get_first_section(NULL)->addr;
	section    = get_last_section();
	end_addr   = section->addr + get_section_size( section );
	
    if ( opts.verbose )
        printf("Code size of linked modules is %d bytes ($%04X to $%04X)\n",
		       (int)(get_sections_size()), (int)start_addr, (int)end_addr-1 );

	str_sprintf( name, ASMHEAD_KW, "", "" ); 
	define_global_def_sym( str_data(name), start_addr );
	
	str_sprintf( name, ASMTAIL_KW, "", "" ); 
	define_global_def_sym( str_data(name), end_addr );
	
	str_sprintf( name, ASMSIZE_KW, "", "" ); 
	define_global_def_sym( str_data(name), end_addr - start_addr );

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
					   (unsigned int)start_addr, (unsigned int)end_addr-1 );

			str_sprintf( name, ASMHEAD_KW, "_", section->name ); 
			define_global_def_sym( str_data(name), start_addr );

			str_sprintf( name, ASMTAIL_KW, "_", section->name ); 
			define_global_def_sym( str_data(name), end_addr );

			str_sprintf( name, ASMSIZE_KW, "_", section->name ); 
			define_global_def_sym( str_data(name), end_addr - start_addr );
		}
	}

	STR_DELETE(name);
}

/*-----------------------------------------------------------------------------
*   link
*----------------------------------------------------------------------------*/
void link_modules( void )
{
    char fheader[9];
    Module *module, *first_obj_module, *last_obj_module;
	ModuleListElem *iter;
	Bool saw_last_obj_module;
    char *obj_filename;
	ExprList *exprs = NULL;
	FILE *file;

    opts.symtable = opts.cur_list = FALSE;
    linkhdr = NULL;

    if ( opts.verbose )
        puts( "linking module(s)...\nPass1..." );

    if ( opts.relocatable )
    {
        reloctable = m_new_n( char, 32768U );
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

	/* remember current first and last modules, i.e. before adding library modules */
	first_obj_module = get_first_module(&iter);
	last_obj_module = get_last_module(NULL);

	/* link machine code & read symbols in all modules */
	for (module = first_obj_module, saw_last_obj_module = FALSE;
		module != NULL && !saw_last_obj_module;
		module = get_next_module(&iter))
	{
		set_cur_module(module);

		/* open error file on first module */
		if (CURRENTMODULE == first_obj_module)
			open_error_file(CURRENTMODULE->filename);

		set_error_null();
		set_error_module(CURRENTMODULE->modname);

		if (opts.library)
		{
			CURRENTLIB = libraryhdr->firstlib;      /* begin library search  from first library for each
													* module */
			CURRENTLIB->nextobjfile = 8;            /* point at first library module (past header) */
		}

		/* overwrite '.asm' extension with * '.obj' */
		obj_filename = get_obj_filename(CURRENTMODULE->filename);

		/* open relocatable file for reading */
		file = myfopen(obj_filename, "rb");           
		if (file)
		{
			/* read first 8 chars from file into array */
			xfget_chars(file, fheader, 8);
			fheader[8] = '\0';

			/* compare header of file */
			if (strcmp(fheader, Z80objhdr) != 0)
			{
				error_not_obj_file(obj_filename);  /* not a object     file */
				myfclose(file);
				break;
			}

			myfclose(file);

			LinkModule(obj_filename, 0);       /* link code & read name definitions */
		}

		/* parse only object modules, not added library modules */
		if (CURRENTMODULE == last_obj_module)
			saw_last_obj_module = TRUE;

	}

	set_error_null();

	/* allocate segment addresses and compute absolute addresses of symbols */
	if (!get_num_errors())
		sections_alloc_addr();

	if (!get_num_errors())
		relocate_symbols();

	/* define assembly size */
	if (!get_num_errors())
		define_location_symbols();

	if (opts.verbose)
		puts("Pass2...");

	/* collect expressions from all modules; first compute all EQU expressions,
	then patch all other expressions
	exprs keeps the current pending list */
	exprs = OBJ_NEW(ExprList);
	if (!get_num_errors())
		read_module_exprs(exprs);
	if (!get_num_errors())
		compute_equ_exprs(exprs, TRUE, FALSE);
	if (!get_num_errors())
		patch_exprs(exprs);
	
	OBJ_DELETE(exprs);

	set_error_null();

	ReleaseLinkInfo();              /* Release module link information */

	close_error_file();
}




static int LinkModule_1(char *filename, long fptr_base, Str *section_name)
{
    long fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
    int code_size;
    int origin = -1;
    int flag = 0;
	FILE *file;
	Section *section;

    /* open object file for reading */
    file = myfopen( filename, "rb" );           
	if (file)
	{
		fseek(file, fptr_base + 8, SEEK_SET);

		fptr_modname = xfget_int32(file);	/* get file pointer to module name */
		xfget_int32(file);	/* get file pointer to expression declarations */
		fptr_namedecl = xfget_int32(file);	/* get file pointer to name declarations */
		fptr_libnmdecl = xfget_int32(file);	/* get file pointer to library name declarations */
		fptr_modcode = xfget_int32(file);	/* get file pointer to module code */

		if (fptr_modcode != -1)
		{
			fseek(file, fptr_base + fptr_modcode, SEEK_SET);  /* set file pointer to module code */

			while (TRUE)	/* read sections until end marker */
			{
				code_size = xfget_int32(file);
				if (code_size < 0)
					break;

				xfget_count_byte_Str(file, section_name);
				origin = xfget_int32(file);
				
				/* load bytes to section */
				/* BUG_0015: was reading at current position in code area, swaping order of modules */
				section = new_section(str_data(section_name));
				if (origin >= 0)
					section->origin = origin;

				/* if creating relocatable code, ignore origin */
				if (opts.relocatable && origin >= 0) {
					warn_org_ignored(filename, str_data(section_name));
					section->origin = -1;
					section->section_split = FALSE;
				}

				patch_file_contents(file, 0, code_size);
			}
		}

		if (fptr_namedecl != -1)
		{
			fseek(file, fptr_base + fptr_namedecl, SEEK_SET);  /* set file pointer to point at name
															   * declarations */
			ReadNames(filename, file);
		}

		myfclose(file);
	}

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

int LinkModule(char *filename, long fptr_base)
{
	STR_DEFINE(section_name, STR_SIZE);
	int ret = LinkModule_1(filename, fptr_base, section_name);
	STR_DELETE(section_name);
	return ret;
}



static int LinkLibModules_1(char *filename, long fptr_base, long nextname, long endnames, Str *name)
{
    FILE *file;

    do
    {
        /* open object file for reading */
        file = myfopen( filename, "rb" );           
		if (!file)
			return 0;

		fseek( file, fptr_base + nextname, SEEK_SET );	/* set file pointer to point at 
														 * library name declarations */
        xfget_count_byte_Str( file, name );				/* read library reference name */
        myfclose( file );

        nextname += 1 + str_len(name);	/* remember module pointer to next name in this object module */

        if ( find_global_symbol( str_data(name) ) == NULL )
            SearchLibraries( str_data(name) );       /* search name in libraries */
    }
    while ( nextname < endnames );

    return 1;
}

int LinkLibModules(char *filename, long fptr_base, long nextname, long endnames)
{
	STR_DEFINE(name, STR_SIZE);
	int ret = LinkLibModules_1(filename, fptr_base, nextname, endnames, name);
	STR_DELETE(name);
	return ret;
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

    file = myfopen( curlib->libfilename, "rb" );           
	if (!file)
		return 0;

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
                myfclose( file );
                return LinkLibModule( curlib, currentlibmodule + 4 + 4, mname );
            }
            else if ( opts.sdcc &&
                      modname[0] == '_' &&
                      ( mname = CheckIfModuleWanted( file, currentlibmodule, modname + 1 ) ) != NULL )
            {
                myfclose( file );
                return LinkLibModule( curlib, currentlibmodule + 4 + 4, mname );
            }
        }
    }

    myfclose( file );
    return 0;
}


/** \brief Check to see if a library module is required
 *
 *  \param z80asmfile - File to read from
 *  \param currentlibmodule - Current offset in file
 *  \param modname - Module/symbol to search for

 */
static char *CheckIfModuleWanted_1(FILE *file, long currentlibmodule, char *modname,
	Str *got_modname, Str *symbol_name, Str *section_name)
{
    long fptr_mname, fptr_name;
    enum flag found = OFF;

    /* found module name? */
    fseek( file, currentlibmodule + 4 + 4 + 8, SEEK_SET );     
													/* point at module name  file pointer */
    fptr_mname		= xfget_int32( file );			/* get module name file  pointer   */
					  xfget_int32( file );			/* fptr_expr */
    fptr_name		= xfget_int32( file );
    /*fptr_libname*/  xfget_int32( file );
    fseek( file, currentlibmodule + 4 + 4 + fptr_mname, SEEK_SET );       
													/* point at module name  */
	xfget_count_byte_Str( file, got_modname );		/* read module name */

    if ( strcmp( str_data(got_modname), modname ) == 0 )
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
					 strcmp( str_data(symbol_name), modname ) == 0 )
                {
                    found = ON;
                }
            }
        }
    }

    return found ? strpool_add( str_data(got_modname) ) : NULL;
}

static char *CheckIfModuleWanted(FILE *file, long currentlibmodule, char *modname)
{
	STR_DEFINE(got_modname, STR_SIZE);
	STR_DEFINE(symbol_name, STR_SIZE);
	STR_DEFINE(section_name, STR_SIZE);

	char *ret = CheckIfModuleWanted_1(file, currentlibmodule, modname, got_modname, symbol_name, section_name);

	STR_DELETE(got_modname);
	STR_DELETE(symbol_name);
	STR_DELETE(section_name);

	return ret;
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
CreateBinFile( void )
{
	FILE *binaryfile;
	FILE *relocfile;
	char *filename;
	Bool is_relocatable = ( opts.relocatable && totaladdr != 0 );

    if ( opts.bin_file )        /* use predined output filename from command line */
        filename = opts.bin_file;
    else						/* create output filename, based on project filename */
        filename = get_bin_filename( get_first_module(NULL)->filename );		/* add '.bin' extension */

    /* binary output to filename.bin */
    binaryfile = myfopen( filename, "wb" );
	relocfile = opts.relocatable ? NULL : myfopen(get_reloc_filename(filename), "wb");
	if (binaryfile)
	{
		if (is_relocatable)
		{
			/* relocate routine */
			xfput_chars(binaryfile, (char *)reloc_routine, sizeof_relocroutine);

			*(reloctable + 0) = (Byte)totaladdr % 256U;
			*(reloctable + 1) = (Byte)totaladdr / 256U;  /* total of relocation elements */
			*(reloctable + 2) = (Byte)sizeof_reloctable % 256U;
			*(reloctable + 3) = (Byte)sizeof_reloctable / 256U; /* total size of relocation table elements */

			/* write relocation table, inclusive 4 byte header */
			xfput_chars(binaryfile, reloctable, sizeof_reloctable + 4);

			printf("Relocation header is %d bytes.\n", (int)(sizeof_relocroutine + sizeof_reloctable + 4));
		}

		fwrite_codearea(filename, &binaryfile, &relocfile);		/* write code as one big chunk */
		myfclose(binaryfile);
		if (relocfile != NULL)
			myfclose(relocfile);
	}

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
        linkhdr = m_new( struct linklist );
        linkhdr->firstlink = NULL;
        linkhdr->lastlink = NULL;       /* Library header initialised */
    }

    fname = m_strdup( filename );        /* get a copy module file name */

    newm = m_new( struct linkedmod );
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
            m_free( m->objfilename );
        }

        n = m->nextlink;
        m_free( m );
        m = n;
    }

    m_free( linkhdr );

    linkhdr = NULL;
}
