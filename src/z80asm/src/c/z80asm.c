/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#include "die.h"
#include "directives.h"
#include "expr1.h"
#include "fileutil.h"
#include "if.h"
#include "libfile.h"
#include "modlink.h"
#include "module1.h"
#include "parse1.h"
#include "scan1.h"
#include "strpool.h"
#include "strutil.h"
#include "symtab1.h"
#include "types.h"
#include "utstring.h"
#include "zobjfile.h"
#include <sys/stat.h>

/* external functions */
void Z80pass2(int start_errors, const char* obj_filename);
void CreateBinFile( void );

extern char Z80objhdr[];

size_t sizeof_reloctable = 0;

char *reloctable = NULL, *relocptr = NULL;

/* local functions */
static void do_assemble(const char *src_filename, const char* obj_filename);

/*-----------------------------------------------------------------------------
*   Assemble one source file or link one object file
*----------------------------------------------------------------------------*/
void assemble_file( const char *filename ) {
	const char* src_filename;
	const char* obj_filename;

	set_error_location(filename, 0);

	// check if we got a source or object file
	bool got_obj = strcmp(filename + strlen(filename) - strlen(EXT_O), EXT_O) == 0;
	if (got_obj) {
		src_filename = get_asm_filename(filename);
		obj_filename = spool_add(filename);
	}
	else {
		src_filename = spool_add(filename);
		obj_filename = get_o_filename(filename);
	}

	// when building libraries need to reset codearea to allow total library size > 64K
	// when building binary cannot reset codearea so that each module is linked
	// after the previous one, allocating addresses
	if (!(option_make_bin() || option_bin_file() || option_consol_obj_file()))
		reset_codearea();

	// Create module data structures for new file
	Module1* module = set_cur_module(new_module());
	module->filename = spool_add(src_filename);

	if (got_obj) {
		object_file_check_append(obj_filename, CURRENTMODULE, true, false);
	}
	else {
        // check -o file as output of a single assembly file
        if (option_consol_obj_file() && option_files_size() == 1) {
            obj_filename = option_consol_obj_file_name();
        }

        // create output directory
        path_mkdir(path_parent_dir(obj_filename));

        // append the directoy of the file being assembled to the include path 
		// and remove it at function end 
		push_includes(path_parent_dir(src_filename));
		{
			// normal case - assemble a asm source file 
			list_set(option_list_file());		// initial LSTON status
			do_assemble(src_filename, obj_filename);
			list_set(false);
		}
		// finished assembly, remove dirname from include path
		pop_includes();
	}

	clear_error_location();
}

/*-----------------------------------------------------------------------------
*	Assemble one file
*----------------------------------------------------------------------------*/
static void do_assemble(const char *src_filename, const char* obj_filename)
{
    int start_errors = get_num_errors();     /* count errors in this source file */

	/* initialize local symtab with copy of static one (-D defines) */
	copy_static_syms();

	/* Init ASMPC */
	set_PC(0);

	if (option_verbose())
		printf("Assembling '%s'\n", path_canon(src_filename));

	list_open(get_lis_filename(src_filename));
	parse_file(src_filename);
	asm_MODULE_default();			/* Module1 name must be defined */
	clear_error_location();
	Z80pass2(start_errors, obj_filename);	/* call pass 2 even if errors found, to issue pass2 errors */
	clear_error_location();
	list_close();

	/* remove incomplete object file */
	if (start_errors != get_num_errors())
		remove(obj_filename);

	remove_all_local_syms();
	remove_all_global_syms();
	Expr1List_remove_all(CURRENTMODULE->exprs);

	if (option_verbose())
		putchar('\n');    /* separate module texts */
}

/***************************************************************************************************
 * Main entry of Z80asm
 ***************************************************************************************************/
int z80asm_main() {
	if (!get_num_errors()) {		/* if no errors in command line parsing */
        if (!option_lib_for_all_cpus()) {
            for (size_t i = 0; i < option_files_size(); i++)
                assemble_file(option_file(i));
        }
	}

	/* Create output file */
	if (!get_num_errors()) {
		if (option_lib_file()) {
			make_library(option_lib_file());
		}
		else if (option_make_bin()) {
			link_modules();

			if (!get_num_errors())
				CreateBinFile();

			if (!get_num_errors())
				checkrun_appmake();		/* call appmake if requested in the options */
		}
        else if (option_consol_obj_file() && option_files_size() > 1) {	// -o consolidated obj
            link_modules();

            set_cur_module(get_first_module(NULL));

            CURRENTMODULE->filename = get_asm_filename(option_consol_obj_file_name());
            CURRENTMODULE->modname = remove_extension(path_file(CURRENTMODULE->filename));

            if (!get_num_errors())
                write_obj_file(option_consol_obj_file_name());

            if (!get_num_errors() && option_symtable())
                write_sym_file(CURRENTMODULE);
        }
	}

	clear_error_location();
	delete_modules();		/* Release module information (symbols, etc.) */

	if (option_relocatable()) {
		if (reloctable != NULL)
			m_free(reloctable);
	}

	if (get_num_errors())
		return EXIT_FAILURE;
	else
		return EXIT_SUCCESS;
}
