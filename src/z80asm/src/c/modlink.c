/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#include "alloc.h"
#include "codearea.h"
#include "expr.h"
#include "fileutil.h"
#include "if.h"
#include "libfile.h"
#include "modlink.h"
#include "options.h"
#include "parse.h"
#include "reloc_code.h"
#include "scan.h"
#include "str.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"
#include "utstring.h"
#include "z80asm.h"
#include "zutils.h"
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
	Module*			module;				// weak pointer to main module information, if object file
} obj_file_t;


/* local functions */
static void link_lib_module(const char* modname, obj_file_t* obj, StrHash* extern_syms);
static void merge_modules(StrHash* extern_syms);
static void object_module_append(obj_file_t* obj, Module* module);
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
	}
}

static int parse_byte(obj_file_t* obj) {
	xassert(obj->i + 1 <= obj->size);
	return obj->data[(obj->i)++];
}

static int parse_word(obj_file_t* obj) {
	xassert(obj->i + 2 <= obj->size);
	int value =
		((obj->data[obj->i + 0] << 0) & 0x00FF) |
		((obj->data[obj->i + 1] << 8) & 0xFF00);
	obj->i += 2;
	return value;
}

static int parse_int(obj_file_t* obj) {
	xassert(obj->i + 4 <= obj->size);
	int value =
		((obj->data[obj->i + 0] << 0) & 0x000000FFL) |
		((obj->data[obj->i + 1] << 8) & 0x0000FF00L) |
		((obj->data[obj->i + 2] << 16) & 0x00FF0000L) |
		((obj->data[obj->i + 3] << 24) & 0xFF000000L);
	obj->i += 4;
	if (value & 0x80000000L)
		value |= ~0xFFFFFFFFL;		// sign-extend above bit 31
	return value;
}

static const char* parse_str(obj_file_t* obj, int len) {
	xassert(obj->i + len <= obj->size);
	const char* ret = spool_add_n((char*)obj->data + obj->i, len);
	obj->i += len;
	return ret;
}

static const char* parse_wcount_str(obj_file_t* obj) {
	int len = parse_word(obj);
	return parse_str(obj, len);
}

static bool goto_modname(obj_file_t* obj) {
	obj->i = 8 + 0 * 4;
	obj->i = parse_int(obj);
	return obj->i >= 0;
}

static bool goto_exprs(obj_file_t* obj) {
	obj->i = 8 + 1 * 4;
	obj->i = parse_int(obj);
	return obj->i >= 0;
}

static bool goto_defined_names(obj_file_t* obj) {
	obj->i = 8 + 2 * 4;
	obj->i = parse_int(obj);
	return obj->i >= 0;
}

static bool goto_external_names(obj_file_t* obj) {
	obj->i = 8 + 3 * 4;
	obj->i = parse_int(obj);
	return obj->i >= 0;
}

static bool goto_code(obj_file_t* obj) {
	obj->i = 8 + 4 * 4;
	obj->i = parse_int(obj);
	return obj->i >= 0;
}

static void obj_files_append(obj_file_t** plist, const char* filename, Module* module) {
	init();

	// create a obj and append to list - file will be loaded when linking
	obj_file_t* obj = xnew(obj_file_t);
	DL_APPEND(*plist, obj);
	obj->filename = spool_add(filename);
	obj->module = module;
}

static bool obj_files_read_data(obj_file_t** plist) {
	init();

	for (obj_file_t* obj = *plist; obj; obj = obj->next) {
		obj->size = file_size(obj->filename);
		if (obj->size < 0) {
			error_file_open(obj->filename);
			return false;
		}

		obj->data = xmalloc(obj->size);
		FILE* fp = fopen(obj->filename, "rb");
		if (!fp){
			error_file_open(obj->filename);
			return false;
		}
		xfread(obj->data, 1, obj->size, fp);
		fclose(fp);
	}

	return true;
}

static void obj_files_free(obj_file_t** plist) {
	while (*plist) {
		obj_file_t* elem = *plist;
		DL_DELETE(*plist, elem);
		xfree(elem->data);
		xfree(elem);
	}
}

bool library_file_append(const char * filename) {
	init();

	// check for empty file name
	if (!*filename) {
		error_not_lib_file(filename);
		return false;
	}

	// search library path
	filename = path_search(get_lib_filename(filename), opts.lib_path);

	// check if file exists and version is correct
	if (!check_library_file(filename))
		return false;

	// create a new library and append to list - file will be loaded when linking
	obj_files_append(&g_libraries, filename, NULL);

	if (opts.verbose)
		printf("Reading library '%s'\n", path_canon(filename));

	return true;
}

bool object_file_append(const char* filename, Module* module, bool reserve_space, bool no_errors) {
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

	// reserve space for the module's sections
	if (reserve_space) {
		if (!objmodule_loaded(filename)) {
			error_not_obj_file(filename);
			return false;
		}
	}

	// append to the list of objects to be linked
	obj_files_append(&g_objects, filename, module);

	return true;
}

void object_module_append(obj_file_t* obj, Module* module) {
	init();

	// reserve space for the module's sections
	xassert(goto_modname(obj));
	const char* modname = parse_wcount_str(obj);
	CURRENTMODULE->modname = modname;

	if (goto_code(obj)) {
		while (true) {
			int code_size = parse_int(obj);
			if (code_size < 0)
				break;

			// reserve space in section
			const char* section_name = parse_wcount_str(obj);
			Section* section = new_section(section_name);
			int origin = parse_int(obj);
			set_origin(origin, section);
			section->align = parse_int(obj);

			append_reserve(code_size);

			obj->i += code_size;
		}
	}

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
static void set_asmpc_env(Module* module, const char* section_name,
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
static void set_expr_env(Expr* expr, bool module_relative_addr)
{
	set_asmpc_env(expr->module, expr->section->name,
		expr->text->data, expr->filename, expr->line_num,
		expr->asmpc,
		module_relative_addr);
}

static void read_cur_module_exprs(ExprList* exprs, obj_file_t* obj) {
	const char* last_filename = spool_add(obj->filename);

	while (true) {
		int type = parse_byte(obj);
		if (type == 0)
			break;			// end marker

		// source file name and line number
		const char* source_filename = parse_wcount_str(obj);
		if (*source_filename)
			last_filename = source_filename;
		else
			source_filename = last_filename;
		int line_num = parse_int(obj);

		// patch location
		const char* section_name = parse_wcount_str(obj);
		int asmpc = parse_word(obj);
		int code_pos = parse_word(obj);

		const char* target_name = parse_wcount_str(obj);
		const char* expr_text = parse_wcount_str(obj);

		// call parser to interpret expression
		set_asmpc_env(CURRENTMODULE, section_name, expr_text, source_filename, line_num,
			asmpc, false);
		Expr* expr = parse_expr(expr_text);
		if (expr) {
			expr->range = 0;
			switch (type) {
			case 'U': expr->range = RANGE_BYTE_UNSIGNED; break;
			case 'S': expr->range = RANGE_BYTE_SIGNED;  break;
			case 'u': expr->range = RANGE_BYTE_TO_WORD_UNSIGNED; break;
			case 's': expr->range = RANGE_BYTE_TO_WORD_SIGNED; break;
			case 'C': expr->range = RANGE_WORD;			break;
			case 'B': expr->range = RANGE_WORD_BE;		break;
			case 'L': expr->range = RANGE_DWORD;		break;
			case 'J': expr->range = RANGE_JR_OFFSET;	break;
			case 'P': expr->range = RANGE_PTR24;		break;
			case 'H': expr->range = RANGE_HIGH_OFFSET;  break;
			case '=': expr->range = RANGE_WORD;
				xassert(strlen(target_name) > 0);
				expr->target_name = spool_add(target_name);	// define expression as EQU
				break;
			default:
				error_not_obj_file(obj->filename);
			}

			expr->module = CURRENTMODULE;
			expr->section = CURRENTSECTION;
			expr->asmpc = asmpc;
			expr->code_pos = code_pos;
			expr->filename = spool_add(source_filename);
			expr->line_num = line_num;
			expr->listpos = -1;

			ExprList_push(&exprs, expr);
		}
	}
}

// read all the modules' expressions to the given list, or to the module's if NULL
static void read_module_exprs(ExprList* exprs) {
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
static int compute_equ_exprs_once(ExprList* exprs, bool show_error, bool module_relative_addr)
{
	ExprListElem* iter;
	Expr* expr, * expr2;
	long value;
	int  num_computed = 0;
	int  num_unresolved = 0;
	bool computed;

	iter = ExprList_first(exprs);
	while (iter != NULL)
	{
		expr = iter->obj;
		computed = false;

		if (expr->target_name)
		{
			/* touch symbol so that it ends in object file */
			Symbol* sym = get_used_symbol(expr->target_name);
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
			expr2 = ExprList_remove(exprs, &iter);
			xassert(expr == expr2);

			OBJ_DELETE(expr);
		}
		else
			iter = ExprList_next(iter);
	}

	if (num_computed > 0)
		return num_computed;
	else if (num_unresolved > 0)
		return -num_unresolved;
	else
		return 0;
}

/* check if we have expressions still with target, i.e. circular definitions (see #1869) */
static void check_equ_exprs_solved(ExprList* exprs, bool module_relative_addr) {
	if (module_relative_addr)			/* not linking */
		return;

	ExprListElem* iter = ExprList_first(exprs);
	while (iter != NULL) {
		Expr* expr = iter->obj;
		if (expr->target_name) {
			set_expr_env(expr, module_relative_addr);
			error_undefined_symbol(expr->target_name);
		}
		iter = ExprList_next(iter);
	}
}

/* compute all equ expressions, removing them from the list */
void compute_equ_exprs(ExprList* exprs, bool show_error, bool module_relative_addr)
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
static void patch_exprs(ExprList* exprs)
{
	ExprListElem* iter;
	Expr* expr, * expr2;
	long value, asmpc;

	iter = ExprList_first(exprs);
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
					if (opts.relocatable)
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
				value -= asmpc + 2;		/* get module PC at JR instruction */

				if (value < -128 || value > 127)
					error_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				break;

			default: xassert(0);
			}

		}

		/* remove current expression, advance iterator */
		expr2 = ExprList_remove(exprs, &iter);
		xassert(expr == expr2);

		OBJ_DELETE(expr);
	}
}

/*-----------------------------------------------------------------------------
*   relocate all SYM_ADDR symbols based on address from start of sections
*----------------------------------------------------------------------------*/
static void relocate_symbols_symtab(SymbolHash* symtab)
{
	SymbolHashElem* iter;
	Symbol* sym;
	int			base_addr;
	int			offset;

	for (iter = SymbolHash_first(symtab); iter; iter = SymbolHash_next(iter))
	{
		sym = (Symbol*)iter->value;
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
	Module* module;
	ModuleListElem* iter;

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
	Section* section;
	SectionHashElem* iter;
	STR_DEFINE(name, STR_SIZE);
	int start_addr, end_addr;

	/* global code size */
	start_addr = get_first_section(NULL)->addr;
	section = get_last_section();
	end_addr = section->addr + get_section_size(section);

	if (opts.verbose)
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

			if (opts.verbose)
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

// search one module for unresolved symbols and link if needed
static bool linked_module(obj_file_t* obj, StrHash* extern_syms) {
	bool linked = false;

	// get module name
	xassert(goto_modname(obj));
	const char* modname = parse_wcount_str(obj);

	// get defined names
	if (goto_defined_names(obj)) {
		while (!linked) {
			int scope = parse_byte(obj);
			if (scope == 0)	
				break;					// end of list
			obj->i++;					// skip type
			parse_wcount_str(obj);		// skip section name
			obj->i += 4;				// skip value
			const char* symbol_name = parse_wcount_str(obj);
			parse_wcount_str(obj);		// skip defined file name
			obj->i += 4;				// skip line number

			// link module if one defined symbol matches pending externals
			if (scope == 'G' && StrHash_exists(extern_syms, symbol_name)) {
				link_lib_module(modname, obj, extern_syms);
				linked = true;
			}
		}
	}
	return linked;
}

// search chain of libraries for modules that resolve any of the pending symbols
// break search after first found module, so that first all dependencies of this module
// are linked in, before going to the next library module
static bool linked_libraries(StrHash* extern_syms) {
	// search library chain
	bool linked = false;
	// search all libraries
	for (obj_file_t* lib = g_libraries; !linked && lib != NULL; lib = lib->next) {
		// search all object modules inside each library
		int next_pos = -1;
		for (int pos = 8; !linked && pos > 0 && pos < lib->size; pos = next_pos) {
			lib->i = pos;
			next_pos = parse_int(lib);
			int module_size = parse_int(lib);

			if (module_size == 0)
				continue;					// deleted module

			// define an obj_file_t to link
			obj_file_t obj;
			obj.filename = lib->filename;
			obj.data = lib->data + lib->i;
			obj.size = module_size;
			obj.i = 0;
			if (linked_module(&obj, extern_syms))
				linked = true;
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
			int code_size = parse_int(obj);
			if (code_size < 0)		// end marker
				break;

			// next section
			const char* section_name = parse_wcount_str(obj);
			Section* section = new_section(section_name);
			int origin = parse_int(obj);
			set_origin(origin, section);
			section->align = parse_int(obj);

			// if creating relocatable code, ignore origin 
			if (opts.relocatable && section->origin >= 0) {
				warn_org_ignored(obj->filename, section->name);

				section->origin = -1;
				section->section_split = false;
			}
			// if running appmake, ignore origin except for first module
			else if (opts.appmake && section->origin >= 0 && !first_section) {
				warn_org_ignored(obj->filename, section->name);

				section->origin = -1;
				section->section_split = false;
			}

			// load bytes to section
			patch_from_memory(obj->data + obj->i, 0, code_size);
			obj->i += code_size;

			first_section = false;
		}
	}

	// load defined names
	if (goto_defined_names(obj)) {
		while (true) {
			int scope = parse_byte(obj);							// scope of symbol
			if (scope == 0)											// end marker
				break;

			int symbol_type = parse_byte(obj);						// type of symbol
			const char* section_name = parse_wcount_str(obj);		// section
			int value = parse_int(obj);								// value
			const char* name = parse_wcount_str(obj);				// symbol name
			const char* def_filename = parse_wcount_str(obj);		// where defined
			int line_num = parse_int(obj);							// where defined

			new_section(section_name);								// define CURRENTSECTION

			sym_type_t type = TYPE_UNKNOWN;
			switch (symbol_type)
			{
			case 'A': type = TYPE_ADDRESS;  break;
			case 'C': type = TYPE_CONSTANT; break;
			case '=': type = TYPE_COMPUTED; break;
			default:
				error_not_obj_file(obj->filename);
				return;
			}

			Symbol* sym = NULL;
			switch (scope)
			{
			case 'L': sym = define_local_sym(name, value, type); break;
			case 'G': sym = define_global_sym(name, value, type); break;
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
	xassert(goto_modname(obj));
	int end_external_names = obj->i;
	if (goto_external_names(obj)) {
		while (obj->i < end_external_names) {
			const char* name = parse_wcount_str(obj);
			StrHash_set(&extern_syms, name, (void*)name);	// remember all extern references
		}
	}
}

static void link_lib_module(const char* modname, obj_file_t* obj, StrHash* extern_syms) {
	Module* old_module = get_cur_module();			// remember current module

	Module* lib_module = set_cur_module(new_module());	// new module to link library
	lib_module->modname = spool_add(modname);
	object_module_append(obj, lib_module);

	if (opts.verbose)
		printf("Linking library module '%s'\n", modname);

	link_module(obj, extern_syms);

	set_cur_module(old_module);						// restore previous current module
}

void link_modules(void)
{
	ExprList* exprs = NULL;
	StrHash* extern_syms = OBJ_NEW(StrHash);

	// load all objects and libraries to memory, to speed-up linking
	if (!obj_files_read_data(&g_objects) || !obj_files_read_data(&g_libraries))
		return;
	
	opts.cur_list = false;

	if (opts.relocatable)
	{
		reloctable = m_new_n(char, 32768U);		// TODO: make this a dymanic array
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

	// <TODO>: merge Module and obj_file_t; for now check they are in sync
	ModuleListElem* iter;
	Module* mod = get_first_module(&iter);
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
	if (!get_num_errors() && !opts.consol_obj_file && g_libraries != NULL)
		link_libraries(extern_syms);

	clear_error_location();

	/* allocate segment addresses and compute absolute addresses of symbols */
	/* in consol_obj_file sections are zero-based */
	if (!get_num_errors() && !opts.consol_obj_file)
		sections_alloc_addr();

	/* relocate address symbols */
	if (!get_num_errors())
		relocate_symbols();

	/* define assembly size */
	if (!get_num_errors() && !opts.consol_obj_file)
		define_location_symbols();

	if (opts.consol_obj_file) {
		if (!get_num_errors())
			merge_modules(extern_syms);
	}
	else {
		/* collect expressions from all modules */
		exprs = OBJ_NEW(ExprList);
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
		if (opts.map)
			write_map_file();

		if (opts.globaldef)
			write_def_file();
	}

	OBJ_DELETE(extern_syms);
}

void
CreateBinFile(void) {
	CodeareaFile binfile = { 0 }, relocfile = { 0 };
	const char* filename = NULL;
	bool need_reloc_routine = (opts.relocatable && totaladdr != 0);

	if (opts.bin_file)      /* use predined output filename from command line */
		filename = path_canon(path_prepend_output_dir(opts.bin_file));
	else					/* create output filename, based on project filename */
		/* add '.bin' extension */
		filename = path_canon(get_bin_filename(get_first_module(NULL)->filename));		

	/* binary output to filename.bin */
	if (opts.verbose)
		printf("Creating binary '%s'\n", filename);

	binfile.initial_filename = binfile.filename = filename;
	binfile.fp = xfopen(binfile.filename, "wb");

	// no reloc-info with -R
	if (opts.reloc_info && !opts.relocatable) {
		relocfile.initial_filename = relocfile.filename = get_reloc_filename(filename);
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

			if (opts.verbose)
				printf("Relocation header is %d bytes.\n",
					(int)(sizeof_relocroutine + sizeof_reloctable + 4));
		}

		fwrite_codearea(filename, &binfile, &relocfile);		/* write code as one big chunk */

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

static void rename_module_local_symbols(Module* module)
{
	Symbol* sym;
	SymbolHashElem* sym_it;
	StrHash* old_syms = OBJ_NEW(StrHash);
	StrHashElem* name_it;
	Expr* expr;
	ExprListElem* expr_it;
	const char* old_name;
	const char* value;
	STR_DEFINE(new_name, STR_SIZE);
	STR_DEFINE(new_text, STR_SIZE);

	/* collect list of symbol names to change - cannot iterate through symbols hash while changing it */
	for (sym_it = SymbolHash_first(module->local_symtab); sym_it != NULL; sym_it = SymbolHash_next(sym_it)) {
		sym = (Symbol*)sym_it->value;

		old_name = spool_add(sym->name);
		Str_sprintf(new_name, "%s_%s", module->modname, old_name);
		StrHash_set(&old_syms, old_name, (void*)spool_add(Str_data(new_name)));
	}

	/* change symbol names */
	for (name_it = StrHash_first(old_syms); name_it != NULL; name_it = StrHash_next(name_it)) {
		value = spool_add(name_it->value);

		sym = SymbolHash_extract(module->local_symtab, name_it->key);
		sym->name = value;
		SymbolHash_set(&module->local_symtab, value, sym);
	}

	/* rename symbols in expressions */
	for (expr_it = ExprList_first(module->exprs); expr_it != NULL; expr_it = ExprList_next(expr_it)) {
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
	Module* module;
	Module* first_module;
	ModuleListElem* it;
	Symbol* sym;
	SymbolHashElem* sym_it, * next_sym;
	Expr* expr;
	StrHashElem* elem, * next;
	int start;

	first_module = get_first_module(NULL); xassert(first_module != NULL);

	for (module = get_first_module(&it); module != NULL; module = get_next_module(&it)) {
		/* remove local symbols that are not defined */
		for (sym_it = SymbolHash_first(module->local_symtab); sym_it != NULL; sym_it = next_sym) {
			next_sym = SymbolHash_next(sym_it);
			sym = (Symbol*)sym_it->value;
			if (!sym->is_defined)
				SymbolHash_remove_elem(module->local_symtab, sym_it);
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
			while ((sym_it = SymbolHash_first(module->local_symtab)) != NULL) {
				sym = SymbolHash_extract(module->local_symtab, sym_it->key);
				SymbolHash_set(&first_module->local_symtab, sym->name, sym);
			}

			/* move local expressions */
			while ((expr = ExprList_pop(module->exprs)) != NULL) {
				ExprList_push(&first_module->exprs, expr);

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
	Section* section;
	SectionHashElem* iter;

	for (section = get_first_section(&iter); section != NULL; section = get_next_section(&iter)) {
		intArray_set_size(section->module_start, 1);		/* delete all module boundaries */
	}
}

static void touch_symtab_symbols(SymbolHash* symtab)
{
	SymbolHashElem* iter;
	Symbol* sym;

	for (iter = SymbolHash_first(symtab); iter; iter = SymbolHash_next(iter)) {
		sym = (Symbol*)iter->value;
		//Bug 563 -- if (sym->type == TYPE_ADDRESS || sym->scope == SCOPE_EXTERN)
		sym->is_touched = true;
	}
}

static void touch_symbols()
{
	Module* module;
	ModuleListElem* it;

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
	Module* first_module;
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
