/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#include "die.h"
#include "directives.h"
#include "fileutil.h"
#include "if.h"
#include "libfile.h"
#include "modlink.h"
#include "module.h"
#include "parse.h"
#include "strutil.h"
#include "symbol.h"
#include "types.h"
#include "utstring.h"
#include "zobjfile.h"
#include <sys/stat.h>

/* external functions */
void Z80pass2( void );
void CreateBinFile( void );

extern char Z80objhdr[];

size_t sizeof_reloctable = 0;

char *reloctable = NULL, *relocptr = NULL;

/* local functions */
static void query_assemble(const char *src_filename );
static void do_assemble(const char *src_filename );

/*-----------------------------------------------------------------------------
*   Assemble one source file
*	- if a .o file is given, and it exists, it is used without trying to assemble first
*	- if the given file exists, whatever the extension, try to assembly it
*	- if all above fail, try to replace/append the .asm extension and assemble
*	- if all above fail, try to replace/append the .o extension and link
*----------------------------------------------------------------------------*/
void assemble_file( const char *filename )
{
	// must canonize input file name so that comparison to .o below works
	filename = path_canon(filename);

	const char *src_filename;
	const char *obj_filename;
	bool load_obj_only;
	Module *module;

	/* create output directory*/
	obj_filename = path_canon(get_obj_filename(filename));
	path_mkdir(path_dir(obj_filename));

	set_error_location(obj_filename, 0);

	/* try to load object file */
	if (strcmp(filename, obj_filename) == 0 &&			/* input is object file */
		file_exists(filename)							/* .o file exists */
		) {
		load_obj_only = true;
		src_filename = filename;
	}
	else {
		load_obj_only = false;

		/* use input file if it exists */
		if (file_exists(filename)) {
			src_filename = filename;						/* use whatever extension was given */
		}
		else {
			const char *asm_filename = get_asm_filename(filename);
			if (file_exists(asm_filename)) {				/* file with .asm extension exists */
				src_filename = asm_filename;
			}
			else if (file_exists(obj_filename)) {
				load_obj_only = true;
				src_filename = obj_filename;
			}
			else {				
				error_file_open(filename);
				return;
			}
		}
	}
	
	/* append the directoy of the file being assembled to the include path 
	   and remove it at function end */
	argv_push(opts.inc_path, path_dir(src_filename));

    /* normal case - assemble a asm source file */
    opts.cur_list = opts.list;		/* initial LSTON status */

	/* when building libraries need to reset codearea to allow total library size > 64K
	   when building binary cannot reset codearea so that each module is linked
	   after the previous one, allocating addresses */
	if (!(opts.make_bin || opts.bin_file))
		reset_codearea();

    /* Create module data structures for new file */
	module = set_cur_module( new_module() );
	module->filename = spool_add( src_filename );

	if (load_obj_only)
		object_file_append(obj_filename, CURRENTMODULE, true, false);
	else
		query_assemble(src_filename);			/* try to assemble, check -d */

    clear_error_location();							/* no more module in error messages */
	opts.cur_list = false;

	/* finished assembly, remove dirname from include path */
	argv_pop(opts.inc_path);

	clear_error_location();
}

/*-----------------------------------------------------------------------------
*	Assemble file or load object module size if datestamp option was given
*	and object file is up-to-date
*----------------------------------------------------------------------------*/
static void query_assemble(const char *src_filename )
{
    struct stat src_stat, obj_stat;
    int src_stat_result, obj_stat_result;
	const char *obj_filename = get_obj_filename( src_filename );

    /* get time stamp of files, error if source not found */
    src_stat_result = stat( src_filename, &src_stat );		/* BUG_0033 */
    obj_stat_result = stat( obj_filename, &obj_stat );

    if ( opts.date_stamp &&									/* -d option */
            obj_stat_result >= 0 &&							/* object file exists */
            ( src_stat_result >= 0 ?						/* if source file exists, ... */
              src_stat.st_mtime <= obj_stat.st_mtime		/* ... source older than object */
              : true										/* ... else source does not exist, but object exists
															   --> consider up-to-date (e.g. test.c -> test.o) */
            ) &&
			object_file_append(obj_filename, CURRENTMODULE, true, true)	/* object file valid and size loaded */
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
static void do_assemble(const char *src_filename )
{
    int start_errors = get_num_errors();     /* count errors in this source file */
	const char *obj_filename = get_obj_filename(src_filename);

	/* initialize local symtab with copy of static one (-D defines) */
	copy_static_syms();

	/* Init ASMPC */
	set_PC(0);

	if (opts.verbose)
		printf("Assembling '%s' to '%s'\n", path_canon(src_filename), path_canon(obj_filename));

	list_open(get_list_filename(src_filename));
	parse_file(src_filename);
	asm_MODULE_default();			/* Module name must be defined */
	clear_error_location();
	Z80pass2();						/* call pass 2 even if errors found, to issue pass2 errors */
	clear_error_location();
	list_close();

	/* remove incomplete object file */
	if (start_errors != get_num_errors())
		remove(get_obj_filename(src_filename));

	remove_all_local_syms();
	remove_all_global_syms();
	ExprList_remove_all(CURRENTMODULE->exprs);

	if (opts.verbose)
		putchar('\n');    /* separate module texts */
}

/***************************************************************************************************
 * Main entry of Z80asm
 ***************************************************************************************************/
int z80asm_main(int argc, char* argv[]) {
	/* parse command line and call-back via assemble_file() */
	/* If filename starts with '@', reads the file as a list of filenames
	*	and assembles each one in turn */
	parse_argv(argc, argv);
	if (!get_num_errors()) {
		for (char** pfile = argv_front(opts.files); *pfile; pfile++)
			assemble_file(*pfile);
	}

	/* Create output file */
	if (!get_num_errors()) {
		if (opts.lib_file) {
			make_library(opts.lib_file, opts.files);
		}
		else if (opts.make_bin) {
			xassert(opts.consol_obj_file == NULL);
			link_modules();

			if (!get_num_errors())
				CreateBinFile();

			if (!get_num_errors())
				checkrun_appmake();		/* call appmake if requested in the options */
		}
		else if (opts.bin_file) {	// -o consolidated obj
			opts.consol_obj_file = opts.bin_file;
			opts.bin_file = NULL;

			xassert(opts.consol_obj_file != NULL);
			link_modules();

			set_cur_module(get_first_module(NULL));

			CURRENTMODULE->filename = get_asm_filename(opts.consol_obj_file);
			CURRENTMODULE->modname = path_remove_ext(path_file(CURRENTMODULE->filename));

			if (!get_num_errors())
				write_obj_file(opts.consol_obj_file);

			if (!get_num_errors() && opts.symtable)
				write_sym_file(CURRENTMODULE);
		}
	}

	clear_error_location();
	delete_modules();		/* Release module information (symbols, etc.) */

	if (opts.relocatable) {
		if (reloctable != NULL)
			m_free(reloctable);
	}

	if (get_num_errors())
		return EXIT_FAILURE;
	else
		return EXIT_SUCCESS;
}
