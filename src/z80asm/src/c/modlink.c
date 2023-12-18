/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#include "alloc.h"
#include "codearea.h"
#include "expr1.h"
#include "fileutil.h"
#include "if.h"
#include "libfile.h"
#include "modlink.h"
#include "parse1.h"
#include "reloc_code.h"
#include "scan1.h"
#include "str.h"
#include "strpool.h"
#include "strutil.h"
#include "sym.h"
#include "symtab1.h"
#include "types.h"
#include "utstring.h"
#include "xassert.h"
#include "xmalloc.h"
#include "z80asm.h"
#include "z80asm_defs.h"
#include "zobjfile.h"
#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// list of objects/libraries to search during linking
typedef struct obj_file_t {
	struct obj_file_t* next, *prev;		// doubly linked list
	const char*		filename;			// library file name (strpool)
	int				size;				// size of library file
	byte_t*			data;				// contents of library file, loaded before linking
	int				i;					// point to next position to parse
	Module1*		module;				// weak pointer to main module information, if object file
    bool            is_library;         // library or object file
    strtable_t* st;
} obj_file_t;


/* local functions */
static void link_lib_module(const char* modname, obj_file_t* obj, StrHash* extern_syms);
static void merge_modules(StrHash* extern_syms);
static void object_module_append(obj_file_t* obj, Module1* module);
static void obj_files_free(obj_file_t** plist);
void CreateBinFile(void);

/* global variables */
extern char Z80objhdr[];
extern char* reloctable, * relocptr;

int totaladdr, curroffset;

static obj_file_t*	g_objects;				// list of objects to link
static obj_file_t*	g_libraries;			// list of libraries to link

static void dtor(void) {
	obj_files_free(&g_objects);
	obj_files_free(&g_libraries);
}

static void init(void) {
	static bool inited = false;
	if (!inited) {
		atexit(dtor);
        inited = true;
	}
}

static int parse_obj_file_int(obj_file_t* obj) {
	xassert(obj->i + sizeof(int32_t) <= obj->size);
    int value = parse_le_int32(&obj->data[obj->i]);
	obj->i += sizeof(int32_t);
	return value;
}

static bool goto_modname(obj_file_t* obj) {
	obj->i = SIGNATURE_SIZE + (2 + 0) * sizeof(int32_t);
	obj->i = parse_obj_file_int(obj);
	return obj->i >= 0;
}

static bool goto_exprs(obj_file_t* obj) {
	obj->i = SIGNATURE_SIZE + (2 + 1) * sizeof(int32_t);
	obj->i = parse_obj_file_int(obj);
	return obj->i >= 0;
}

static bool goto_defined_names(obj_file_t* obj) {
	obj->i = SIGNATURE_SIZE + (2 + 2) * sizeof(int32_t);
	obj->i = parse_obj_file_int(obj);
	return obj->i >= 0;
}

static bool goto_external_names(obj_file_t* obj) {
	obj->i = SIGNATURE_SIZE + (2 + 3) * sizeof(int32_t);
	obj->i = parse_obj_file_int(obj);
	return obj->i >= 0;
}

static bool goto_code(obj_file_t* obj) {
	obj->i = SIGNATURE_SIZE + (2 + 4) * sizeof(int32_t);
	obj->i = parse_obj_file_int(obj);
	return obj->i >= 0;
}

static bool goto_string_table(obj_file_t* obj) {
    if (obj->is_library)
        obj->i = SIGNATURE_SIZE;
    else
        obj->i = SIGNATURE_SIZE + (2 + 5) * sizeof(int32_t);
    obj->i = parse_obj_file_int(obj);
    return obj->i >= 0;
}

static void parse_string_table(obj_file_t* obj) {
    if (obj->st == NULL) {
        int save_pos = obj->i;
        xassert(goto_string_table(obj));
        obj->st = strtable_parse(obj->data + obj->i);
        obj->i = save_pos;
    }
}

static const char* parse_st_str(obj_file_t* obj) {
    if (obj->st == NULL)
        parse_string_table(obj);
    int id = parse_obj_file_int(obj);
    return strtable_lookup(obj->st, id);
}

static obj_file_t* obj_files_append(obj_file_t** plist, const char* filename, Module1* module) {
	init();

	// create a obj and append to list - file will be loaded when linking
	obj_file_t* obj = xnew(obj_file_t);
	DL_APPEND(*plist, obj);
	obj->filename = spool_add(filename);
	obj->module = module;

    return obj;
}

static bool obj_file_read_data(obj_file_t* obj) {
    if (obj->data == NULL) {
        obj->size = file_size(obj->filename);
        if (obj->size < 0) {
            error_file_open(obj->filename);
            return false;
        }

        obj->data = xmalloc(obj->size);
        FILE* fp = fopen(obj->filename, "rb");
        if (!fp) {
            error_file_open(obj->filename);
            return false;
        }
        xfread(obj->data, 1, obj->size, fp);
        fclose(fp);

        if (strncmp((char*)obj->data, objfile_header(), SIGNATURE_SIZE) == 0) {
            obj->is_library = false;
        }
        else if (strncmp((char*)obj->data, libfile_header(), SIGNATURE_SIZE) == 0) {
            obj->is_library = true;
            parse_string_table(obj);        // get list of defined symbols
        }
        else {
            error_not_obj_file(obj->filename);
            return false;
        }
    }

    return true;
}

static bool obj_files_read_data(obj_file_t** plist) {
	init();

	for (obj_file_t* obj = *plist; obj; obj = obj->next) {
        if (!obj_file_read_data(obj))
            return false;
	}

	return true;
}

static void obj_files_free(obj_file_t** plist) {
	while (*plist) {
		obj_file_t* elem = *plist;
		DL_DELETE(*plist, elem);
		xfree(elem->data);
        if (elem->st)
            strtable_free(elem->st);
		xfree(elem);
	}
}

void library_file_append(const char * filename) {
	init();

	// check for empty file name
	if (!*filename) {
		error_not_lib_file(filename);
	}
	else {
		// search library path
		filename = search_libraries(get_lib_filename(filename));

		// check if file exists and version is correct
		if (check_library_file(filename)) {

			// create a new library and append to list - file will be loaded when linking
			obj_files_append(&g_libraries, filename, NULL);

			if (option_verbose())
				printf("Reading library '%s'\n", path_canon(filename));
		}
	}
}

// reserve space for the module's sections
static void object_file_reserve_space(obj_file_t* obj, Module1* module) {
    if (!obj_file_read_data(obj))
        return;

    xassert(goto_modname(obj));
    const char* modname = spool_add(parse_st_str(obj));     // st from obj from lib will be deleted, save modname
    CURRENTMODULE->modname = modname;

    if (goto_code(obj)) {
        while (true) {
            int code_size = parse_obj_file_int(obj);
            if (code_size < 0)
                break;

            // reserve space in section
            const char* section_name = parse_st_str(obj);
            Section1* section = new_section(section_name);
            int origin = parse_obj_file_int(obj);
            set_origin(origin, section);
            section->align = parse_obj_file_int(obj);

            append_reserve(code_size);

            // align to dword size
            unsigned aligned_size = ((code_size + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1));

            obj->i += aligned_size;
        }
    }
}

bool object_file_check_append(const char* filename, Module1* module, bool reserve_space, bool no_errors) {
	init();

	// check for empty file name
	if (!*filename) {
		error_not_obj_file(filename);
		return false;
	}

	// check if file exists and version is correct
	if (no_errors) {
		if (!check_object_file_no_errors(filename))
			return false;
	}
	else {
		if (!check_object_file(filename))
			return false;
	}

    if (option_verbose())
        printf("Appending object file '%s'\n", filename);

    obj_file_t* obj = obj_files_append(&g_objects, filename, module);

    // reserve space for the module's sections
    if (reserve_space)
        object_file_reserve_space(obj, module);

    return true;
}

void object_file_append(const char* filename, Module1* module) {
    init();

    // append to the list of objects to be linked
    obj_files_append(&g_objects, filename, module);
}

void object_module_append(obj_file_t* obj, Module1* module) {
	init();

    object_file_reserve_space(obj, module);

	// append a copy to the list of objects to be linked
	obj_file_t* new_obj = xnew(obj_file_t);
	DL_APPEND(g_objects, new_obj);
	new_obj->filename = obj->filename;
	new_obj->size = obj->size;
	new_obj->data = xmalloc(obj->size);
	memcpy(new_obj->data, obj->data, obj->size);
	new_obj->i = 0;
	new_obj->module = module;
}

/* set environment to compute expression */
static void set_asmpc_env(Module1* module, const char* section_name,
	const char* expr_text, const char* filename, int line_num, 
	int asmpc, bool module_relative_addr) {
	int base_addr, offset;

	/* point to current module */
	set_cur_module(module);

	/* source file and line number */
	set_error_location(filename, line_num);
	set_error_source_line(expr_text);		// to show expression in case of error

	/* assembler PC as absolute address */
	new_section(section_name);

	if (module_relative_addr) {
		set_PC(asmpc);
	}
	else {
		base_addr = CURRENTSECTION->addr;
		offset = get_cur_module_start();
		set_PC(asmpc + base_addr + offset);
	}
}

/* set environment to compute expression */
static void set_expr_env(Expr1* expr, bool module_relative_addr)
{
	set_asmpc_env(expr->module, expr->section->name,
		expr->text->data, expr->filename, expr->line_num,
		expr->asmpc,
		module_relative_addr);
}

static void read_cur_module_exprs(Expr1List* exprs, obj_file_t* obj) {
	while (true) {
        range_t range = parse_obj_file_int(obj);
		if (range == RANGE_UNDEFINED)         // end marker
			break;			

		// source file name and line number
		const char* source_filename = parse_st_str(obj);
		int line_num = parse_obj_file_int(obj);

		// patch location
		const char* section_name = parse_st_str(obj);
		int asmpc = parse_obj_file_int(obj);
		int code_pos = parse_obj_file_int(obj);
		int opcode_size = parse_obj_file_int(obj);

		const char* target_name = parse_st_str(obj);
		const char* expr_text = parse_st_str(obj);

		// call parser to interpret expression
		set_asmpc_env(CURRENTMODULE, section_name, expr_text, source_filename, line_num,
			asmpc, false);
		Expr1* expr = parse_expr(expr_text);
        if (expr) {
            expr->range = range;
            if (expr->range == RANGE_ASSIGNMENT) {
                xassert(strlen(target_name) > 0);
                expr->target_name = spool_add(target_name);	// define expression as EQU
            }

			expr->module = CURRENTMODULE;
			expr->section = CURRENTSECTION;
			expr->asmpc = asmpc;
			expr->code_pos = code_pos;
			expr->opcode_size = opcode_size;
			expr->filename = spool_add(source_filename);
			expr->line_num = line_num;
			expr->listpos = -1;

			Expr1List_push(&exprs, expr);
		}
	}
}

// read all the modules' expressions to the given list, or to the module's if NULL
static void read_module_exprs(Expr1List* exprs) {
	for (obj_file_t* obj = g_objects; obj; obj = obj->next) {
		xassert(obj->module);
		set_cur_module(obj->module);
		clear_error_location();

		if (goto_exprs(obj)) {
			if (exprs != NULL)
				read_cur_module_exprs(exprs, obj);
			else
				read_cur_module_exprs(obj->module->exprs, obj);
		}
	}
	clear_error_location();
}

/* compute equ expressions and remove them from the list
   return >0: number of computed expressions
   return 0 : nothing done, all EQU expression computed and removed from list
   return <0: -(number of expressions with unresolved symbols)
*/
static int compute_equ_exprs_once(Expr1List* exprs, bool show_error, bool module_relative_addr)
{
	Expr1ListElem* iter;
	Expr1* expr, * expr2;
	long value;
	int  num_computed = 0;
	int  num_unresolved = 0;
	bool computed;

	iter = Expr1List_first(exprs);
	while (iter != NULL)
	{
		expr = iter->obj;
		computed = false;

		if (expr->target_name)
		{
			/* touch symbol so that it ends in object file */
			Symbol1* sym = get_used_symbol(expr->target_name);
			sym->is_touched = true;

			/* expressions with symbols from other sections need to be passed to the link phase */
			if (!module_relative_addr || /* link phase */
				(Expr_is_local_in_section(expr, CURRENTMODULE, CURRENTSECTION) &&	/* or symbols from other sections */
					Expr_without_addresses(expr))		/* expression addressees - needs to be computed at link time */
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
					computed = true;
					update_symbol(expr->target_name, value, expr->type);
				}
			}
		}

		/* continue loop - delete expression if computed */
		if (computed)
		{
			/* remove current expression, advance iterator */
			expr2 = Expr1List_remove(exprs, &iter);
			xassert(expr == expr2);

			OBJ_DELETE(expr);
		}
		else
			iter = Expr1List_next(iter);
	}

	if (num_computed > 0)
		return num_computed;
	else if (num_unresolved > 0)
		return -num_unresolved;
	else
		return 0;
}

/* check if we have expressions still with target, i.e. circular definitions (see #1869) */
static void check_equ_exprs_solved(Expr1List* exprs, bool module_relative_addr) {
	if (module_relative_addr)			/* not linking */
		return;

	Expr1ListElem* iter = Expr1List_first(exprs);
	while (iter != NULL) {
		Expr1* expr = iter->obj;
		if (expr->target_name) {
			set_expr_env(expr, module_relative_addr);
			error_undefined_symbol(expr->target_name);
		}
		iter = Expr1List_next(iter);
	}
}

/* compute all equ expressions, removing them from the list */
void compute_equ_exprs(Expr1List* exprs, bool show_error, bool module_relative_addr)
{
	int  compute_result;

	/* loop to solve dependencies while some are solved */
	do {
		compute_result = compute_equ_exprs_once(exprs, false, module_relative_addr);
	} while (compute_result > 0);

	/* if some unresolved, give up and show error */
	if (show_error && compute_result < 0)
		compute_equ_exprs_once(exprs, true, module_relative_addr);

	/* if linking, check that we solved all EQU expressions */
	check_equ_exprs_solved(exprs, module_relative_addr);
}

/* compute and patch expressions */
static void patch_exprs(Expr1List* exprs)
{
	Expr1ListElem* iter;
	Expr1* expr, * expr2;
	long value, asmpc;

	iter = Expr1List_first(exprs);
	while (iter != NULL)
	{
		expr = iter->obj;
		xassert(expr->target_name == NULL);		/* EQU expressions are already computed */

		set_expr_env(expr, false);
		value = Expr_eval(expr, true);

		if (!expr->result.not_evaluable)			/* not unresolved */
		{
			switch (expr->range)
			{
			case RANGE_BYTE_UNSIGNED:
				if (value < -128 || value > 255)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				break;

			case RANGE_BYTE_SIGNED:
				if (value < -128 || value > 127)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				break;

			case RANGE_HIGH_OFFSET:
				if ((value & 0xff00) != 0) {
					if ((value & 0xff00) != 0xff00)
						warn_int_range(value);
				}

				patch_byte(expr->code_pos, (byte_t)(value & 0xff));
				break;

			case RANGE_BYTE_TO_WORD_UNSIGNED:
				if (value < 0 || value > 255)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				patch_byte(expr->code_pos + 1, 0);
				break;

			case RANGE_BYTE_TO_WORD_SIGNED:
				if (value < -128 || value > 127)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				patch_byte(expr->code_pos + 1, value < 0 || value > 127 ? 0xff : 0);
				break;

			case RANGE_PTR24:
				patch_byte(expr->code_pos + 0, (byte_t)((value >> 0) & 0xff));
				patch_byte(expr->code_pos + 1, (byte_t)((value >> 8) & 0xff));
				patch_byte(expr->code_pos + 2, (byte_t)((value >> 16) & 0xff));
				break;

			case RANGE_WORD:
				patch_word(expr->code_pos, value);

				/* Expression contains relocatable address */
				if (expr->type == TYPE_ADDRESS) {

					/* save section reloc data */
					*(intArray_push(expr->section->reloc)) = expr->code_pos + get_cur_module_start();

					/* relocate code */
					if (option_relocatable())
					{
						int offset = get_cur_module_start() + expr->section->addr;
						int distance = expr->code_pos + offset - curroffset;

						if (distance > 0 && distance < 256)	// Bugfix: when zero, need to use 3 bytes
						{
							*relocptr++ = (byte_t)distance;
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

			case RANGE_WORD_BE:
				patch_word_be(expr->code_pos, value);
				break;

			case RANGE_DWORD:
				patch_long(expr->code_pos, value);
				break;

			case RANGE_JR_OFFSET:
				asmpc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();
				value -= asmpc + expr->opcode_size;		/* get module PC at JR instruction */

                if (value < -128 || value > 127)
                    error_int_range(value);
                else
                    patch_byte(expr->code_pos, (byte_t)value);
				break;

            case RANGE_JRE_OFFSET:
                asmpc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();
                value -= asmpc + expr->opcode_size;		/* get module PC at JR instruction */

                if (value < -0x8000 || value > 0x7FFF)
                    error_int_range(value);
                else
                    patch_word(expr->code_pos, value);
                break;

            default: xassert(0);
			}

		}

		/* remove current expression, advance iterator */
		expr2 = Expr1List_remove(exprs, &iter);
		xassert(expr == expr2);

		OBJ_DELETE(expr);
	}
}

/*-----------------------------------------------------------------------------
*   relocate all SYM_ADDR symbols based on address from start of sections
*----------------------------------------------------------------------------*/
static void relocate_symbols_symtab(Symbol1Hash* symtab)
{
	Symbol1HashElem* iter;
	Symbol1* sym;
	int			base_addr;
	int			offset;

	for (iter = Symbol1Hash_first(symtab); iter; iter = Symbol1Hash_next(iter))
	{
		sym = (Symbol1*)iter->value;
		if (sym->type == TYPE_ADDRESS)
		{
			xassert(sym->module);				/* owner should exist except for -D defines */

			/* set base address for symbol */
			set_cur_module(sym->module);
			set_cur_section(sym->section);

			base_addr = sym->section->addr;
			offset = get_cur_module_start();

			sym->value += base_addr + offset;	/* Absolute address */
			sym->is_computed = true;
		}
	}
}

static void relocate_symbols(void)
{
	Module1* module;
	Module1ListElem* iter;

	for (module = get_first_module(&iter); module != NULL;
		module = get_next_module(&iter))
	{
		relocate_symbols_symtab(module->local_symtab);
	}
	relocate_symbols_symtab(global_symtab);
}

/*-----------------------------------------------------------------------------
*   Define symbols with sections and code start, end and size
*----------------------------------------------------------------------------*/
static void define_location_symbols(void)
{
	Section1* section;
	Section1HashElem* iter;
	STR_DEFINE(name, STR_SIZE);
	int start_addr, end_addr;

	/* global code size */
	start_addr = get_first_section(NULL)->addr;
	section = get_last_section();
	end_addr = section->addr + get_section_size(section);

	if (option_verbose())
		printf("Code size: %d bytes ($%04X to $%04X)\n",
		(int)(get_sections_size()), (int)start_addr, (int)end_addr - 1);

	Str_sprintf(name, ASMHEAD_KW, "", "");
	define_global_def_sym(Str_data(name), start_addr);

	Str_sprintf(name, ASMTAIL_KW, "", "");
	define_global_def_sym(Str_data(name), end_addr);

	Str_sprintf(name, ASMSIZE_KW, "", "");
	define_global_def_sym(Str_data(name), end_addr - start_addr);

	/* size of each named section - skip "" section */
	for (section = get_first_section(&iter); section != NULL;
		section = get_next_section(&iter))
	{
		if (*(section->name) != '\0')
		{
			start_addr = section->addr;
			end_addr = start_addr + get_section_size(section);

			if (option_verbose())
				printf("Section '%s' size: %d bytes ($%04X to $%04X)\n",
					section->name, (int)(end_addr - start_addr),
					(unsigned int)start_addr, (unsigned int)end_addr - 1);

			Str_sprintf(name, ASMHEAD_KW, section->name, "_");
			define_global_def_sym(Str_data(name), start_addr);

			Str_sprintf(name, ASMTAIL_KW, section->name, "_");
			define_global_def_sym(Str_data(name), end_addr);

			Str_sprintf(name, ASMSIZE_KW, section->name, "_");
			define_global_def_sym(Str_data(name), end_addr - start_addr);
		}
	}

	STR_DELETE(name);
}

/*-----------------------------------------------------------------------------
*   link used libraries
*----------------------------------------------------------------------------*/

// check if there are symbols not yet linked
static bool pending_syms(StrHash* extern_syms) {
	// delete defined symbols
	StrHashElem* elem, * next;
	for (elem = StrHash_first(extern_syms); elem != NULL; elem = next) {
		next = StrHash_next(elem);
		if (find_global_symbol(elem->key) != NULL) {		// symbol defined
			StrHash_remove_elem(extern_syms, elem);
		}
	}

	if (StrHash_empty(extern_syms))
		return false;
	else
		return true;
}

// check if library module is for same CPU
static bool module_same_cpu(obj_file_t* obj, int fpos) {
    int fpos0 = obj->i;
    obj->i = fpos;
    cpu_t cpu_id = parse_obj_file_int(obj);
    if (!cpu_compatible(option_cpu(), cpu_id)) {
        obj->i = fpos0;
        return false;
    }

    swap_ixiy_t swap_ixiy = parse_obj_file_int(obj);
    if (!ixiy_compatible(option_swap_ixiy(), swap_ixiy)) {
        obj->i = fpos0;
        return false;
    }

    obj->i = fpos0;
    return true;
}

// search one module for unresolved symbols and link if needed
static bool linked_module(obj_file_t* obj, StrHash* extern_syms) {
	bool linked = false;

	// get module name
	xassert(goto_modname(obj));
    const char* modname = parse_st_str(obj);

	// get defined names
	if (goto_defined_names(obj)) {
		while (!linked) {
            sym_scope_t scope = parse_obj_file_int(obj);
			if (scope == SCOPE_NONE)
				break;					// end of list
            obj->i += sizeof(int32_t);  // skip type
            obj->i += sizeof(int32_t);  // skip section name
            obj->i += sizeof(int32_t);  // skip value
			const char* symbol_name = parse_st_str(obj);
            obj->i += sizeof(int32_t);  // skip defined file name
            obj->i += sizeof(int32_t);  // skip line number

			// link module if one defined symbol matches pending externals
			if (scope == SCOPE_PUBLIC && StrHash_exists(extern_syms, symbol_name)) {
				link_lib_module(modname, obj, extern_syms);
				linked = true;
			}
		}
	}
	return linked;
}

// check if library string table contains any of the pending symbols
static bool lib_defines_pending_sym(obj_file_t* lib, StrHash* extern_syms) {
    StrHashElem* elem, * next;
    for (elem = StrHash_first(extern_syms); elem != NULL; elem = next) {
        next = StrHash_next(elem);

        if (strtable_find(lib->st, elem->key))
            return true;
    }
    return false;
}

// search chain of libraries for modules that resolve any of the pending symbols
// break search after first found module, so that first all dependencies of this module
// are linked in, before going to the next library module
static bool linked_libraries(StrHash* extern_syms) {
	// search library chain
	bool linked = false;
	// search all libraries
	for (obj_file_t* lib = g_libraries; !linked && lib != NULL; lib = lib->next) {
        if (!lib_defines_pending_sym(lib, extern_syms))     // lookup string table
            continue;
        
		// search all object modules inside each library
		int next_pos = -1;
        int pos = SIGNATURE_SIZE + sizeof(int32_t);         // skip string table
		for (; !linked && pos > 0 && pos < lib->size; pos = next_pos) {
			lib->i = pos;
			next_pos = parse_obj_file_int(lib);
			int module_size = parse_obj_file_int(lib);

			if (module_size == 0)
				continue;					// deleted module

            if (!module_same_cpu(lib, lib->i + SIGNATURE_SIZE))
                continue;                   // different CPU

			// define an obj_file_t to link
			obj_file_t obj;
            memset(&obj, 0, sizeof(obj_file_t));
			obj.filename = lib->filename;
			obj.data = lib->data + lib->i;
			obj.size = module_size;
			obj.i = 0;
			if (linked_module(&obj, extern_syms))
				linked = true;
            if (obj.st)
                strtable_free(obj.st);
		}
	}
	return linked;
}

// link libraries in the order given in the command line
static void link_libraries(StrHash* extern_syms) {
	// while symbols to resolve and new module pulled in
	while (!get_num_errors() &&
		pending_syms(extern_syms) &&
		linked_libraries(extern_syms)) {
		// loop
	}
}

/*-----------------------------------------------------------------------------
*   link
*----------------------------------------------------------------------------*/


static void link_module(obj_file_t* obj, StrHash* extern_syms) {
	// load code sections
	if (goto_code(obj)) {
		bool first_section = true;
		while (true) {				// read sections until end marker
			int code_size = parse_obj_file_int(obj);
			if (code_size < 0)		// end marker
				break;

			// next section
			const char* section_name = parse_st_str(obj);
			Section1* section = new_section(section_name);
			int origin = parse_obj_file_int(obj);
			set_origin(origin, section);
			section->align = parse_obj_file_int(obj);

			// if creating relocatable code, ignore origin 
			if (option_relocatable() && section->origin >= 0) {
				warn_org_ignored(obj->filename, section->name);

				section->origin = ORG_NOT_DEFINED;
				section->section_split = false;
			}
			// if running appmake, ignore origin except for first module
			else if (option_appmake() && section->origin >= 0 && !first_section) {
				warn_org_ignored(obj->filename, section->name);

				section->origin = ORG_NOT_DEFINED;
				section->section_split = false;
			}

			// load bytes to section
			patch_from_memory(obj->data + obj->i, 0, code_size);

            // align to dword size
            unsigned aligned_size = ((code_size + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1));

			obj->i += aligned_size;

			first_section = false;
		}
	}

	// load defined names
	if (goto_defined_names(obj)) {
		while (true) {
            sym_scope_t scope = parse_obj_file_int(obj);			// scope of symbol
			if (scope == SCOPE_NONE)								// end marker
				break;

            sym_type_t type = parse_obj_file_int(obj);				// type of symbol
			const char* section_name = parse_st_str(obj);		    // section
			int value = parse_obj_file_int(obj);					// value
			const char* name = parse_st_str(obj);				    // symbol name
			const char* def_filename = parse_st_str(obj);		    // where defined
			int line_num = parse_obj_file_int(obj);					// where defined

			new_section(section_name);								// define CURRENTSECTION

			Symbol1* sym = NULL;
			switch (scope)
			{
			case SCOPE_LOCAL: sym = define_local_sym(name, value, type); break;
			case SCOPE_PUBLIC: sym = define_global_sym(name, value, type); break;
			default:
				error_not_obj_file(obj->filename);
				return;
			}

			// set definition location
			if (sym) {
				sym->filename = spool_add(def_filename);
				sym->line_num = line_num;
			}
		}
	}

	// collect external symbols
	if (goto_external_names(obj)) {
		while (true) {
			const char* name = parse_st_str(obj);
            if (strlen(name) == 0)      // end marker
                break;
			StrHash_set(&extern_syms, name, (void*)name);	// remember all extern references
		}
	}
}

static void link_lib_module(const char* modname, obj_file_t* obj, StrHash* extern_syms) {
	Module1* old_module = get_cur_module();			// remember current module

	Module1* lib_module = set_cur_module(new_module());	// new module to link library
	lib_module->modname = spool_add(modname);
	object_module_append(obj, lib_module);

	if (option_verbose())
		printf("Linking library module '%s'\n", modname);

	link_module(obj, extern_syms);

	set_cur_module(old_module);						// restore previous current module
}

void link_modules(void) {
	Expr1List* exprs = NULL;
	StrHash* extern_syms = OBJ_NEW(StrHash);

	// load all objects and libraries to memory, to speed-up linking
	if (!obj_files_read_data(&g_objects) || !obj_files_read_data(&g_libraries))
		return;
	
	list_set(false);

	if (option_relocatable()) {
		reloctable = m_new_n(char, 32768U);		// TODO: make this a dymanic array
		relocptr = reloctable;
		relocptr += 4;  /* point at first offset to store */
		totaladdr = 0;
		sizeof_reloctable = 0;  /* relocation table, still 0 elements .. */
		curroffset = 0;
	}
	else {
		reloctable = NULL;
	}

	// <TODO>: merge Module1 and obj_file_t; for now check they are in sync
	Module1ListElem* iter;
	Module1* mod = get_first_module(&iter);
	obj_file_t* obj = g_objects;
	while (mod) {
		xassert(obj);
		xassert(mod == obj->module);

		mod = get_next_module(&iter);
		obj = obj->next;
	}
	xassert(!obj);
	// </TODO>

	// link all .o modules
	for (obj_file_t* obj = g_objects; !get_num_errors() && obj != NULL; obj = obj->next) {
		set_cur_module(obj->module);

		set_error_location(CURRENTMODULE->filename, 0);

		// link code and read definitions
		link_module(obj, extern_syms);
	}

	// link libraries, unless building a consol_obj_file 
	if (!get_num_errors() && !option_consol_obj_file() && g_libraries != NULL)
		link_libraries(extern_syms);

	clear_error_location();

	/* allocate segment addresses and compute absolute addresses of symbols */
	/* in consol_obj_file sections are zero-based */
	if (!get_num_errors() && !option_consol_obj_file())
		sections_alloc_addr();

	/* relocate address symbols */
	if (!get_num_errors())
		relocate_symbols();

	/* define assembly size */
	if (!get_num_errors() && !option_consol_obj_file())
		define_location_symbols();

	if (option_consol_obj_file()) {
		if (!get_num_errors())
			merge_modules(extern_syms);
	}
	else {
		/* collect expressions from all modules */
		exprs = OBJ_NEW(Expr1List);
		if (!get_num_errors())
			read_module_exprs(exprs);

		/* compute all EQU expressions */
		if (!get_num_errors())
			compute_equ_exprs(exprs, true, false);

		/* patch all other expressions */
		if (!get_num_errors())
			patch_exprs(exprs);

		OBJ_DELETE(exprs);
	}

	clear_error_location();

	if (!get_num_errors()) {
		if (option_map())
			write_map_file();

		if (option_globaldef())
			write_def_file();
	}

	OBJ_DELETE(extern_syms);
}

void CreateBinFile(void) {
	CodeareaFile binfile = { 0 }, relocfile = { 0 };
	bool need_reloc_routine = (option_relocatable() && totaladdr != 0);

	binfile.initial_filename
		= binfile.filename
		= get_bin_filename(get_first_module(NULL)->filename, "");

	/* binary output to filename.bin */
	if (option_verbose())
		printf("Creating binary '%s'\n", binfile.filename);

	binfile.fp = xfopen(binfile.filename, "wb");

	// no reloc-info with -R
	if (option_reloc_info() && !option_relocatable()) {
		relocfile.initial_filename
			= relocfile.filename
			= get_reloc_filename(binfile.filename);

		if (option_verbose())
			printf("Creating reloc '%s'\n", relocfile.filename);

		relocfile.fp = xfopen(relocfile.filename, "wb");
	}
	else {
		relocfile.fp = NULL;
	}

	if (binfile.fp)
	{
		if (need_reloc_routine)
		{
			/* relocate routine */
			xfwrite_bytes((char*)reloc_routine, sizeof_relocroutine, binfile.fp);

			*(reloctable + 0) = (byte_t)totaladdr % 256U;
			*(reloctable + 1) = (byte_t)totaladdr / 256U;  /* total of relocation elements */
			*(reloctable + 2) = (byte_t)sizeof_reloctable % 256U;
			*(reloctable + 3) = (byte_t)sizeof_reloctable / 256U; /* total size of relocation table elements */

			/* write relocation table, inclusive 4 byte header */
			xfwrite_bytes(reloctable, sizeof_reloctable + 4, binfile.fp);

			if (option_verbose())
				printf("Relocation header is %d bytes.\n",
					(int)(sizeof_relocroutine + sizeof_reloctable + 4));
		}

		fwrite_codearea(&binfile, &relocfile);		/* write code as one big chunk */

		// close old files, remove if empty and not initial files
		codearea_close_remove(&binfile, &relocfile);
	}
}

/* Consolidate object file */
static int sym_first(int c) { return c == '_' || isalpha(c); }
static int sym_next(int c) { return c == '_' || isalnum(c); }

static void replace_names(Str* result, const char* input, StrHash* map)
{
	STR_DEFINE(key, STR_SIZE);
	const char* elem;
	const char* p0;
	const char* p1;
	Str_clear(result);

	p0 = input;
	while (*p0) {
		if (sym_first(*p0)) {
			p1 = p0 + 1;
			while (*p1 && sym_next(*p1))
				p1++;
			Str_set_n(key, p0, p1 - p0);
			elem = (const char*)StrHash_get(map, Str_data(key));
			if (elem)
				Str_append(result, (char*)elem);
			else
				Str_append(result, Str_data(key));
			p0 = p1;
		}
		else {				/* /\W+/ */
			p1 = p0 + 1;
			while (*p1 && !sym_first(*p1))
				p1++;
			Str_append_n(result, p0, p1 - p0);
			p0 = p1;
		}
	}
}

static void rename_module_local_symbols(Module1* module)
{
	Symbol1* sym;
	Symbol1HashElem* sym_it;
	StrHash* old_syms = OBJ_NEW(StrHash);
	StrHashElem* name_it;
	Expr1* expr;
	Expr1ListElem* expr_it;
	const char* old_name;
	const char* value;
	STR_DEFINE(new_name, STR_SIZE);
	STR_DEFINE(new_text, STR_SIZE);

	/* collect list of symbol names to change - cannot iterate through symbols hash while changing it */
	for (sym_it = Symbol1Hash_first(module->local_symtab); sym_it != NULL; sym_it = Symbol1Hash_next(sym_it)) {
		sym = (Symbol1*)sym_it->value;

		old_name = spool_add(sym->name);
		Str_sprintf(new_name, "%s_%s", module->modname, old_name);
		StrHash_set(&old_syms, old_name, (void*)spool_add(Str_data(new_name)));
	}

	/* change symbol names */
	for (name_it = StrHash_first(old_syms); name_it != NULL; name_it = StrHash_next(name_it)) {
		value = spool_add(name_it->value);

		sym = Symbol1Hash_extract(module->local_symtab, name_it->key);
		sym->name = value;
		Symbol1Hash_set(&module->local_symtab, value, sym);
	}

	/* rename symbols in expressions */
	for (expr_it = Expr1List_first(module->exprs); expr_it != NULL; expr_it = Expr1List_next(expr_it)) {
		expr = expr_it->obj;

		/* rpn_ops already point to symbol table, no rename needed - change only text and target_name */
		replace_names(new_text, Str_data(expr->text), old_syms);
		Str_set(expr->text, Str_data(new_text));

		if (expr->target_name) {
			replace_names(new_text, expr->target_name, old_syms);
			expr->target_name = spool_add(Str_data(new_text));
		}
	}

	OBJ_DELETE(old_syms);
}

static void merge_local_symbols(StrHash* extern_syms)
{
	Module1* module;
	Module1* first_module;
	Module1ListElem* it;
	Symbol1* sym;
	Symbol1HashElem* sym_it, * next_sym;
	Expr1* expr;
	StrHashElem* elem, * next;
	int start;

	first_module = get_first_module(NULL); xassert(first_module != NULL);

	for (module = get_first_module(&it); module != NULL; module = get_next_module(&it)) {
		/* remove local symbols that are not defined */
		for (sym_it = Symbol1Hash_first(module->local_symtab); sym_it != NULL; sym_it = next_sym) {
			next_sym = Symbol1Hash_next(sym_it);
			sym = (Symbol1*)sym_it->value;
			if (!sym->is_defined)
				Symbol1Hash_remove_elem(module->local_symtab, sym_it);
		}

		/* remove extern_syms defined in this module */
		for (elem = StrHash_first(extern_syms); elem != NULL; elem = next) {
			next = StrHash_next(elem);

			sym = find_local_symbol(elem->key);
			if (sym == NULL)
				sym = find_global_symbol(elem->key);
			if (sym != NULL && sym->is_defined) {		/* symbol defined */
				StrHash_remove_elem(extern_syms, elem);
			}
		}

		/* prepend module name to all local symbols */
		rename_module_local_symbols(module);

		if (module != first_module) {
			/* move local symbols */
			while ((sym_it = Symbol1Hash_first(module->local_symtab)) != NULL) {
				sym = Symbol1Hash_extract(module->local_symtab, sym_it->key);
				Symbol1Hash_set(&first_module->local_symtab, sym->name, sym);
			}

			/* move local expressions */
			while ((expr = Expr1List_pop(module->exprs)) != NULL) {
				Expr1List_push(&first_module->exprs, expr);

				/* relocate expression address */
				set_cur_module(expr->module);
				set_cur_section(expr->section);
				start = get_cur_module_start();
				expr->asmpc += start;
				expr->code_pos += start;

				set_cur_module(first_module);
			}
		}
	}
}

static void merge_codearea()
{
	Section1* section;
	Section1HashElem* iter;

	for (section = get_first_section(&iter); section != NULL; section = get_next_section(&iter)) {
		intArray_set_size(section->module_start, 1);		/* delete all module boundaries */
	}
}

static void touch_symtab_symbols(Symbol1Hash* symtab)
{
	Symbol1HashElem* iter;
	Symbol1* sym;

	for (iter = Symbol1Hash_first(symtab); iter; iter = Symbol1Hash_next(iter)) {
		sym = (Symbol1*)iter->value;
		sym->is_touched = true;
	}
}

static void touch_symbols()
{
	Module1* module;
	Module1ListElem* it;

	for (module = get_first_module(&it); module != NULL; module = get_next_module(&it)) {
		touch_symtab_symbols(module->local_symtab);
	}
	touch_symtab_symbols(global_symtab);
}

static void create_extern_symbols(StrHash* extern_syms)
{
	StrHashElem* elem;

	for (elem = StrHash_first(extern_syms); elem != NULL; elem = StrHash_next(elem)) {
		const char* name = elem->key;
		if (!find_local_symbol(name) && !find_global_symbol(name))
			declare_extern_symbol(name);
	}
}

static void merge_modules(StrHash* extern_syms)
{
	Module1* first_module;
	first_module = get_first_module(NULL); xassert(first_module != NULL);

	/* read each module's expression list */
	set_cur_module(first_module);
	read_module_exprs(NULL);

	/* merge local symbols to avoid name clashes in merged module */
	set_cur_module(first_module);
	merge_local_symbols(extern_syms);

	/* merge code areas */
	set_cur_module(first_module);
	merge_codearea();

	/* create extern symbols */
	set_cur_module(first_module);
	create_extern_symbols(extern_syms);

	/* touch symbols so that they are copied to the output object file */
	set_cur_module(first_module);
	touch_symbols();
}

/*-----------------------------------------------------------------------------
*   Appmake options
*	+zx without ORG - sets org at 25760, in a REM statement
*	+zx with ORG - uses that org
*----------------------------------------------------------------------------*/
static void run_appmake(const char* appmake_opts, const char* out_ext,
	int origin_min, int origin_max) {

	Section1* first_section = get_first_section(NULL);

	int origin = first_section->origin;
	if (origin < origin_min || origin > origin_max) {
		error_invalid_org(origin);
	}
	else {
		const char* bin_filename = get_bin_filename(get_first_module(NULL)->filename, "");
		const char* out_filename = replace_extension(bin_filename, out_ext);

		UT_string* cmd;
		utstring_new(cmd);
		utstring_printf(cmd, "z88dk-appmake %s -b \"%s\" -o \"%s\" --org %d",
			appmake_opts,
			bin_filename,
			out_filename,
			origin);

		if (option_verbose())
			puts(utstring_body(cmd));

		int rv = system(utstring_body(cmd));
		if (rv != 0)
			error_cmd_failed(utstring_body(cmd));

		utstring_free(cmd);
	}
}

void checkrun_appmake(void) {
	switch (option_appmake()) {
	case APPMAKE_NONE:
		break;
	case APPMAKE_ZX:
		run_appmake("+zx", ZX_APP_EXT, ZX_ORIGIN_MIN, ZX_ORIGIN_MAX);
		break;
	case APPMAKE_ZX81:
		run_appmake("+zx81", ZX81_APP_EXT, ZX81_ORIGIN_MIN, ZX81_ORIGIN_MAX);
		break;
	default:
		xassert(0);
	}
}
