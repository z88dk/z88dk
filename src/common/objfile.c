//-----------------------------------------------------------------------------
// zobjfile - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <ctype.h>
#include "z80asm_defs.h"
#include "xmalloc.h"
#include "xassert.h"
#include "utstring.h"
#include "utlist.h"
#include "strutil.h"
#include "objfile.h"
#include "fileutil.h"

#include <sys/types.h>	// needed before regex.h
#include "regex.h"

#define MAX_FP     0x7FFFFFFF
#define END(a, b)  ((a) >= 0 ? (a) : (b))

byte_t opt_obj_align_filler = DEFAULT_ALIGN_FILLER;
bool opt_obj_verbose = false;
bool opt_obj_list = false;
bool opt_obj_hide_local = false;
bool opt_obj_hide_expr = false;
bool opt_obj_hide_code = false;

static void objfile_read_strid(objfile_t* obj, FILE* fp, UT_string* str);

//-----------------------------------------------------------------------------
// string table
//-----------------------------------------------------------------------------

const char* objfile_header() {
    static UT_string* header = NULL;
    if (!header) {
        utstring_new(header);
        utstring_printf(header, SIGNATURE_OBJ SIGNATURE_VERS, CUR_VERSION);
    }
    return utstring_body(header);
}

const char* libfile_header() {
    static UT_string* header = NULL;
    if (!header) {
        utstring_new(header);
        utstring_printf(header, SIGNATURE_LIB SIGNATURE_VERS, CUR_VERSION);
    }
    return utstring_body(header);
}


//-----------------------------------------------------------------------------
// read from file
//-----------------------------------------------------------------------------
static file_type_e read_signature(FILE* fp, const char* filename,
	UT_string* signature, int* version)
{
	file_type_e type = is_none;
	*version = -1;

	char file_signature[SIGNATURE_SIZE + 1];

	// read signature
	if (fread(file_signature, 1, SIGNATURE_SIZE, fp) != SIGNATURE_SIZE)
		die("error: signature not found in '%s'\n", filename);
	file_signature[SIGNATURE_SIZE] = '\0';

	if (strncmp(file_signature, SIGNATURE_OBJ, 6) == 0)
		type = is_object;
	else if (strncmp(file_signature, SIGNATURE_LIB, 6) == 0)
		type = is_library;
	else
		die("error: file '%s' not object nor library\n", filename);

    utstring_clear(signature);
    utstring_printf(signature, "%.*s", SIGNATURE_SIZE, file_signature);

	// read version
	if (sscanf(file_signature + 6, "%d", version) < 1)
		die("error: file '%s' not object nor library\n", filename);

	if (*version < MIN_VERSION || *version > MAX_VERSION)
		die("error: file '%s' version %d not supported\n",
			filename, *version);

	if (opt_obj_list)
		printf("%s file %s at $%04X: %s\n",
			type == is_library ? "Library" : "Object ",
			filename,
			(unsigned)(ftell(fp) - SIGNATURE_SIZE), file_signature);

	return type;
}

static void write_signature(FILE* fp, file_type_e type)
{
    UT_string* signature;
    utstring_new(signature);

    utstring_printf(signature, "%s" SIGNATURE_VERS,
		type == is_object ? SIGNATURE_OBJ : SIGNATURE_LIB,
		CUR_VERSION);

	xfwrite_bytes(utstring_body(signature), SIGNATURE_SIZE, fp);

	utstring_free(signature);
}

static section_t* read_section(objfile_t* obj, FILE* fp)
{
    UT_string* name;
    utstring_new(name);

	// read section name from file
    if (obj->version >= 18)
        objfile_read_strid(obj, fp, name);
	else if (obj->version >= 16)
		xfread_wcount_str(name, fp);
	else
		xfread_bcount_str(name, fp);

	// search in existing sections
	section_t* section = NULL;
	DL_FOREACH(obj->sections, section) {
		if (strcmp(utstring_body(name), utstring_body(section->name)) == 0) {
			break;
		}
	}

	if (!section)
		die("error: section '%s' not found in file '%s'\n",
			utstring_body(name), utstring_body(obj->filename));

	utstring_free(name);

	return section;
}

//-----------------------------------------------------------------------------
// output formated data
//-----------------------------------------------------------------------------

static void print_section_name(UT_string* section)
{
	if (opt_obj_list) {
		if (utstring_len(section) > 0)
			printf("%s", utstring_body(section));
		else
			printf("\"\"");
	}
}

static void print_section(UT_string* section)
{
	if (opt_obj_list) {
		printf(" (section ");
		print_section_name(section);
		printf(")");
	}
}

static void print_filename_line_nr(UT_string* filename, int line_num)
{
	if (opt_obj_list) {
		printf(" (file ");
		if (utstring_len(filename) > 0)
			printf("%s", utstring_body(filename));
		else
			printf("\"\"");
		if (line_num > 0)
			printf(":%d", line_num);
		printf(")");
	}
}

static void print_bytes(UT_array* data)
{
	unsigned addr = 0;
	byte_t* p = (byte_t*)utarray_front(data);
	size_t size = utarray_len(data);
	bool need_nl = false;

	for (size_t i = 0; i < size; i++) {
		if ((addr % 16) == 0) {
			if (need_nl) {
				printf("\n");
				need_nl = false;
			}
			printf("    C $%04X:", addr);
			need_nl = true;
		}

		printf(" %02X", *p++);
		need_nl = true;
		addr++;
	}

	if (need_nl)
		printf("\n");
}

//-----------------------------------------------------------------------------
// symbol
//-----------------------------------------------------------------------------
symbol_t* symbol_new() {
	symbol_t* self = xnew(symbol_t);

    utstring_new(self->name);
    self->scope = SCOPE_NONE;
    self->type = TYPE_UNDEFINED;
	self->value = 0;
	self->section = NULL;
    utstring_new(self->filename);
	self->line_num = 0;

	self->next = self->prev = NULL;

	return self;
}

void symbol_free(symbol_t* self) {
	utstring_free(self->name);
	utstring_free(self->filename);
	xfree(self);
}

//-----------------------------------------------------------------------------
// expressions
//-----------------------------------------------------------------------------
expr_t* expr_new() {
	expr_t* self = xnew(expr_t);

    utstring_new(self->text);
    self->range = RANGE_UNDEFINED;
    self->asmpc = self->code_pos = 0;
    self->opcode_size = 2;      // default for normal JR
	self->section = NULL;
    utstring_new(self->target_name);

    utstring_new(self->filename);
	self->line_num = 0;

	self->next = self->prev = NULL;

	return self;
}

void expr_free(expr_t* self)
{
	utstring_free(self->text);
	utstring_free(self->target_name);
	utstring_free(self->filename);
	xfree(self);
}

//-----------------------------------------------------------------------------
// section
//-----------------------------------------------------------------------------

static UT_icd ut_byte_icd = { sizeof(byte_t),NULL,NULL,NULL };

section_t* section_new()
{
	section_t* self = xnew(section_t);

    utstring_new(self->name);
	utarray_new(self->data, &ut_byte_icd);
	self->org = ORG_NOT_DEFINED;
	self->align = 1;
	self->symbols = NULL;
	self->exprs = NULL;

	self->next = self->prev = NULL;

	return self;
}

void section_free(section_t* self)
{
	utstring_free(self->name);
	utarray_free(self->data);

	symbol_t* symbol, * tmp_symbol;
	DL_FOREACH_SAFE(self->symbols, symbol, tmp_symbol) {
		DL_DELETE(self->symbols, symbol);
		symbol_free(symbol);
	}

	expr_t* expr, * tmp_expr;
	DL_FOREACH_SAFE(self->exprs, expr, tmp_expr) {
		DL_DELETE(self->exprs, expr);
		expr_free(expr);
	}

	xfree(self);
}

//-----------------------------------------------------------------------------
// object file
//-----------------------------------------------------------------------------
objfile_t* objfile_new()
{
	objfile_t* self = xnew(objfile_t);

    utstring_new(self->filename);
    utstring_new(self->signature);
    utstring_new(self->modname);

    self->version = -1;
    self->global_org = ORG_NOT_DEFINED;
    self->cpu_id = CPU_Z80;
    self->swap_ixiy = IXIY_NO_SWAP;
	self->externs = argv_new();

	section_t* section = section_new();			// section "" must exist
	self->sections = NULL;
	DL_APPEND(self->sections, section);

    self->st = strtable_new();

	self->next = self->prev = NULL;

	return self;
}

void objfile_free(objfile_t* self)
{
	utstring_free(self->filename);
	utstring_free(self->signature);
	utstring_free(self->modname);
	argv_free(self->externs);

	section_t* section, * tmp;
	DL_FOREACH_SAFE(self->sections, section, tmp) {
		DL_DELETE(self->sections, section);
		section_free(section);
	}

    strtable_free(self->st);
	xfree(self);
}

//-----------------------------------------------------------------------------
// object file read
//-----------------------------------------------------------------------------
static void objfile_read_strid(objfile_t* obj, FILE* fp, UT_string* str) {
    unsigned strid = xfread_dword(fp);
    utstring_clear(str);
    utstring_printf(str, "%s", strtable_lookup(obj->st, strid));
}

static void objfile_read_sections(objfile_t* obj, FILE* fp, long fpos_start) {
	xfseek(fp, fpos_start, SEEK_SET);
	if (obj->version >= 5) {
		while (true) {
			int code_size = xfread_dword(fp);
			if (code_size < 0)
				break;

            // read section name
            UT_string* name;
            utstring_new(name);
            if (obj->version >= 18)
                objfile_read_strid(obj, fp, name);
			else if (obj->version >= 16)
				xfread_wcount_str(name, fp);
			else
				xfread_bcount_str(name, fp);

			// create new section object or use first if empty section
			section_t* section;
			if (utstring_len(name) == 0) {
				section = obj->sections;			// empty section is the first
				xassert(utstring_len(section->name) == 0);
				xassert(utarray_len(section->data) == 0);
			}
			else {
				section = section_new();			// create a new section
			}

            utstring_clear(section->name);
            utstring_printf(section->name, "%s", utstring_body(name));
			utstring_free(name);

			if (obj->version >= 8)
				section->org = xfread_dword(fp);
			else
				section->org = ORG_NOT_DEFINED;

			if (obj->version >= 10)
				section->align = xfread_dword(fp);
			else
				section->align = -1;

			if (opt_obj_list) {
				printf("  Section ");
				print_section_name(section->name);
				printf(": %d bytes", code_size);

				if (section->org >= 0)
					printf(", ORG $%04X", section->org);
				else if (section->org == ORG_SECTION_SPLIT)
					printf(", section split");
				else
					;

				if (section->align > 1)
					printf(", ALIGN %d", section->align);

				printf("\n");
			}

			utarray_resize(section->data, code_size);
			xfread(utarray_front(section->data), sizeof(byte_t), code_size, fp);

            if (obj->version >= 18) {
                // align to dword size
                unsigned aligned_size = ((code_size + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1));
                int extra_bytes = aligned_size - code_size;
                fseek(fp, extra_bytes, SEEK_CUR);
            }

			if (opt_obj_list && !opt_obj_hide_code)
				print_bytes(section->data);

			// insert in the list
			if (section != obj->sections)		// not first = "" section
				DL_APPEND(obj->sections, section);
		}
	}
	else {
		// reuse first section object
		section_t* section = obj->sections;

		int code_size = xfread_word(fp);
		if (code_size == 0)
			code_size = 0x10000;

		utarray_resize(section->data, code_size);
		xfread(utarray_front(section->data), sizeof(byte_t), code_size, fp);

		if (opt_obj_list && code_size > 0) {
			printf("  Section ");
			print_section_name(section->name);
			printf(": %d bytes\n", code_size);
			print_bytes(section->data);
		}
	}
}

static void objfile_read_symbols(objfile_t* obj, FILE* fp, long fpos_start, long fpos_end)
{
	if (obj->version >= 5)					// signal end by zero scope
		fpos_end = MAX_FP;

	if (opt_obj_list)
		printf("  Symbols:\n");

	xfseek(fp, fpos_start, SEEK_SET);
	while (ftell(fp) < fpos_end) {
        // read scope / end marker
        sym_scope_t scope = SCOPE_NONE;
        if (obj->version >= 18) {
            scope = xfread_dword(fp);
            if (scope == SCOPE_NONE)            // end marker 
                break;
        }
        else {
            char old_scope = xfread_byte(fp);
            if (old_scope == '\0')                  // end marker
                break;

            scope = sym_scope_ofile_code(old_scope);
            if (scope == SCOPE_NONE) {
                printf("\nError symbol scope %d\n", old_scope);
                exit(EXIT_FAILURE);
            }
        }
		
        // read type
        sym_type_t type = TYPE_UNDEFINED;
        if (obj->version >= 18) {
            type = xfread_dword(fp);
        }
        else {
            char old_type = xfread_byte(fp);
            type = sym_type_ofile_code(old_type);
            if (type == TYPE_UNDEFINED) {
                printf("\nError symbol type %d\n", old_type);
                exit(EXIT_FAILURE);
            }
        }

        // define new symbol
        symbol_t* symbol = symbol_new();	// create a new symbol
		symbol->scope = scope;
        symbol->type = type;

		if (obj->version >= 5)
			symbol->section = read_section(obj, fp);
		else
			symbol->section = obj->sections;			// the first section

		symbol->value = xfread_dword(fp);
        if (obj->version >= 18)
            objfile_read_strid(obj, fp, symbol->name);
		else if (obj->version >= 16)
			xfread_wcount_str(symbol->name, fp);
		else
			xfread_bcount_str(symbol->name, fp);


		if (obj->version >= 9) {			// add definition location
            if (obj->version >= 18)
                objfile_read_strid(obj, fp, symbol->filename);
            else if (obj->version >= 16)
				xfread_wcount_str(symbol->filename, fp);
			else
				xfread_bcount_str(symbol->filename, fp);

			symbol->line_num = xfread_dword(fp);
		}

		if (opt_obj_list) {
			if (!(opt_obj_hide_local && symbol->scope == SCOPE_LOCAL)) {
                const char* scope_str = sym_scope_str_short(symbol->scope);
                if (scope_str == NULL) {
                    printf("\nError symbol scope %d\n", symbol->scope);
                    exit(EXIT_FAILURE);
                }
                printf("    %s", scope_str);

                const char* type_str = sym_type_str_short(symbol->type);
                if (type_str == NULL) {
                    printf("\nError symbol type %d\n", symbol->type);
                    exit(EXIT_FAILURE);
                }
                printf(" %s", type_str);

                printf(" $%04X: %s", symbol->value, utstring_body(symbol->name));

				if (obj->version >= 5)
					print_section(symbol->section->name);

				if (obj->version >= 9)
					print_filename_line_nr(symbol->filename, symbol->line_num);

				printf("\n");
			}
		}

		// insert in the list
		DL_APPEND(symbol->section->symbols, symbol);
	}
}

static void objfile_read_externs(objfile_t* obj, FILE* fp, long fpos_start, long fpos_end) {
    UT_string* name;
    utstring_new(name);

	if (opt_obj_list)
		printf("  Externs:\n");

	xfseek(fp, fpos_start, SEEK_SET);
    if (obj->version >= 18) {
        while (true) {
            objfile_read_strid(obj, fp, name);
            if (utstring_len(name) == 0)        // end marker
                break;

            argv_push(obj->externs, utstring_body(name));

            if (opt_obj_list)
                printf("    U         %s\n", utstring_body(name));
        }
    }
    else {
        while (ftell(fp) < fpos_end) {
            if (obj->version >= 16)
                xfread_wcount_str(name, fp);
            else
                xfread_bcount_str(name, fp);

            argv_push(obj->externs, utstring_body(name));

            if (opt_obj_list)
                printf("    U         %s\n", utstring_body(name));
        }
    }

	utstring_free(name);
}

static void objfile_read_exprs(objfile_t* obj, FILE* fp, long fpos_start, long fpos_end)
{
	UT_string* last_filename = NULL;		// weak pointer to last filename
	bool show_expr = opt_obj_list && !opt_obj_hide_expr;

	if (obj->version >= 4)					// signal end by zero type
		fpos_end = MAX_FP;

	if (show_expr)
		printf("  Expressions:\n");

	xfseek(fp, fpos_start, SEEK_SET);
    while (ftell(fp) < fpos_end) {
        range_t range = RANGE_UNDEFINED;
        if (obj->version >= 18) {
            range = xfread_dword(fp);
            if (range == RANGE_UNDEFINED)             // end marker
                break;
        }
        else {
            char old_range = xfread_byte(fp);
            if (old_range == '\0')                  // end marker
                break;
            range = range_ofile_code(old_range);
            if (range == RANGE_UNDEFINED) {
                printf("\nError expression range %d\n", old_range);
                exit(EXIT_FAILURE);
            }
        }

        if (show_expr) {
            const char* range_str = range_str_short(range);
            if (range_str == NULL) {
                printf("\nError expression range %d\n", range);
                exit(EXIT_FAILURE);
            }
            printf("    E %s", range_str);
        }

		// create a new expression
		expr_t* expr = expr_new();

		// read from file
		expr->range = range;

        // filename and line number
        if (obj->version >= 18) {
            objfile_read_strid(obj, fp, expr->filename);
            expr->line_num = xfread_dword(fp);
        }
        else if (obj->version >= 4) {
			xfread_wcount_str(expr->filename, fp);
			expr->line_num = xfread_dword(fp);
		}

        if (last_filename == NULL || utstring_len(expr->filename) > 0)
            last_filename = expr->filename;

        if (utstring_len(expr->filename) == 0)
            utstring_printf(expr->filename, "%s", utstring_body(last_filename));

        // read and create section
		if (obj->version >= 5)
			expr->section = read_section(obj, fp);
		else
			expr->section = obj->sections;			// the first section

        // ASMPC
		if (obj->version >= 3) {
			if (obj->version >= 17)
				expr->asmpc = xfread_dword(fp);
			else
				expr->asmpc = xfread_word(fp);

			if (show_expr)
				printf(" $%04X", expr->asmpc);
		}

        // code position
		if (obj->version >= 17)
			expr->code_pos = xfread_dword(fp);
		else
			expr->code_pos = xfread_word(fp);

		if (show_expr)
			printf(" $%04X", expr->code_pos);

        // opcode size
		if (obj->version >= 17) {
			expr->opcode_size = xfread_dword(fp);

			if (show_expr)
				printf(" %d", expr->opcode_size);
		}

        if (show_expr)
            printf(": ");

        if (obj->version >= 6) {
            if (obj->version >= 18)
                objfile_read_strid(obj, fp, expr->target_name);
            else if (obj->version >= 16)
                xfread_wcount_str(expr->target_name, fp);
            else
                xfread_bcount_str(expr->target_name, fp);

            if (show_expr && utstring_len(expr->target_name) > 0)
                printf("%s := ", utstring_body(expr->target_name));
        }

        if (obj->version >= 18)
            objfile_read_strid(obj, fp, expr->text);
        else if (obj->version >= 4)
            xfread_wcount_str(expr->text, fp);
		else {
			xfread_bcount_str(expr->text, fp);
			char end_marker = xfread_byte(fp);
			if (end_marker != '\0')
				die("missing expression end marker in file '%s'\n",
					utstring_body(obj->filename));
		}

		if (show_expr)
			printf("%s", utstring_body(expr->text));

		if (show_expr && obj->version >= 5)
			print_section(expr->section->name);

		if (show_expr && obj->version >= 4)
			print_filename_line_nr(last_filename, expr->line_num);

		if (show_expr)
			printf("\n");

		// insert in the list
		DL_APPEND(expr->section->exprs, expr);
	}
}

void objfile_read(objfile_t* obj, FILE* fp)
{
	long fpos0 = ftell(fp) - SIGNATURE_SIZE;	// before signature

    // CPU
    if (obj->version >= 18) {
        obj->cpu_id = xfread_dword(fp);
        obj->swap_ixiy = xfread_dword(fp);
    }

    // global ORG (for old versions)
	if (obj->version >= 8)
		obj->global_org = ORG_NOT_DEFINED;
	else if (obj->version >= 5)
		obj->global_org = xfread_dword(fp);
	else
		obj->global_org = xfread_word(fp);

	// file pointers
	long fpos_modname = xfread_dword(fp);
	long fpos_exprs = xfread_dword(fp);
	long fpos_symbols = xfread_dword(fp);
	long fpos_externs = xfread_dword(fp);
	long fpos_sections = xfread_dword(fp);

    // string table
    long fpos_st = -1;
    if (obj->version >= 18) {
        fpos_st = xfread_dword(fp);
        long save_fpos = ftell(fp);
        xfseek(fp, fpos0 + fpos_st, SEEK_SET);
        obj->st = strtable_fread(fp);
        xfseek(fp, save_fpos, SEEK_SET);
    }

	// module name
	xfseek(fp, fpos0 + fpos_modname, SEEK_SET);
    if (obj->version >= 18)
        objfile_read_strid(obj, fp, obj->modname);
    else if (obj->version >= 16)
        xfread_wcount_str(obj->modname, fp);
    else
        xfread_bcount_str(obj->modname, fp);

    if (opt_obj_list)
        printf("  Name: %s\n", utstring_body(obj->modname));

	// global ORG
    if (opt_obj_list && obj->global_org >= 0)
        printf("  Org:  $%04X\n", obj->global_org);

    // cpu
    if (opt_obj_list && obj->version >= 18) {
        const char* cpu_str = cpu_name(obj->cpu_id);
        if (cpu_str)
            printf("  CPU:  %s ", cpu_str);
        else
            printf("  CPU:  (invalid %d) ", obj->cpu_id);

        switch (obj->swap_ixiy) {
        case IXIY_NO_SWAP: break;
        case IXIY_SWAP: printf("(-IXIY)"); break;
        case IXIY_SOFT_SWAP: printf("(-IXIY-soft)"); break;
        default: xassert(0);
        }
        printf("\n");
    }

    // sections
	if (fpos_sections >= 0)
		objfile_read_sections(obj, fp, fpos0 + fpos_sections);

	// symbols
	if (fpos_symbols >= 0)
		objfile_read_symbols(obj, fp,
			fpos0 + fpos_symbols,
			fpos0 + END(fpos_externs, fpos_modname));

	// externs
	if (fpos_externs >= 0)
		objfile_read_externs(obj, fp,
			fpos0 + fpos_externs,
			fpos0 + fpos_modname);

	// expressions
	if (fpos_exprs >= 0)
		objfile_read_exprs(obj, fp,
			fpos0 + fpos_exprs,
			fpos0 + END(fpos_symbols, END(fpos_externs, fpos_modname)));
}

//-----------------------------------------------------------------------------
// object file write
//-----------------------------------------------------------------------------
static void objfile_write_strid(objfile_t* obj, FILE* fp, const char* str) {
    unsigned id = strtable_add_string(obj->st, str);
    xfwrite_dword(id, fp);
}

static long objfile_write_exprs(objfile_t* obj, FILE* fp)
{
	long fpos0 = ftell(fp);					// start of expressions area
	bool has_exprs = false;

	section_t* section;
	DL_FOREACH(obj->sections, section) {
		expr_t* expr;
		DL_FOREACH(section->exprs, expr) {
			has_exprs = true;

			// store type
			xfwrite_dword(expr->range, fp);

			// store file name folowed by source line number
            objfile_write_strid(obj, fp, utstring_body(expr->filename));
			xfwrite_dword(expr->line_num, fp);				// source line number

            // store section name
            objfile_write_strid(obj, fp, utstring_body(expr->section->name));

			xfwrite_dword(expr->asmpc, fp);					// ASMPC
			xfwrite_dword(expr->code_pos, fp);				// code position
			xfwrite_dword(expr->opcode_size, fp);			// opcode size

            // target symbol for expression
            objfile_write_strid(obj, fp, utstring_body(expr->target_name));

            // expression
            objfile_write_strid(obj, fp, utstring_body(expr->text));
		}
	}

	if (has_exprs) {
        xfwrite_dword(RANGE_UNDEFINED, fp);	    		    // store end-terminator
		return fpos0;
	}
	else
		return -1;
}

static long objfile_write_symbols(objfile_t* obj, FILE* fp)
{
	long fpos0 = ftell(fp);						// start of symbols area
	bool has_symbols = false;

	section_t* section;
	DL_FOREACH(obj->sections, section) {
		symbol_t* symbol;
		DL_FOREACH(section->symbols, symbol) {
			has_symbols = true;

            xfwrite_dword(symbol->scope, fp);		// scope
            xfwrite_dword(symbol->type, fp);			// type
            objfile_write_strid(obj, fp, utstring_body(symbol->section->name));// section
			xfwrite_dword(symbol->value, fp);		// value
            objfile_write_strid(obj, fp, utstring_body(symbol->name));	// name
            objfile_write_strid(obj, fp, utstring_body(symbol->filename));// filename
			xfwrite_dword(symbol->line_num, fp);		// definition line
		}
	}

	if (has_symbols) {
        xfwrite_dword(0, fp);		// store end-terminator
		return fpos0;
	}
	else
		return -1;
}

static long objfile_write_externs(objfile_t* obj, FILE* fp) {
	if (argv_len(obj->externs) == 0)
        return -1;		// no external symbols

    long fpos0 = ftell(fp);							// start of externals area

	for (char** pname = argv_front(obj->externs); *pname; pname++) {
        objfile_write_strid(obj, fp, *pname);
	}

    objfile_write_strid(obj, fp, "");               // write "" as end marker

    return fpos0;
}

static long objfile_write_modname(objfile_t* obj, FILE* fp) {
	long fpos0 = ftell(fp);
    objfile_write_strid(obj, fp, utstring_body(obj->modname));
	return fpos0;
}

static long objfile_write_sections(objfile_t* obj, FILE* fp) {
    // alignment data
    static const char align[sizeof(int32_t)] = { 0 };

	if (!obj->sections)
        return -1;			// no section 

	long fpos0 = ftell(fp);

	section_t* section;
    DL_FOREACH(obj->sections, section) {
        xfwrite_dword((int)utarray_len(section->data), fp);
        objfile_write_strid(obj, fp, utstring_body(section->name));
        xfwrite_dword(section->org, fp);
        xfwrite_dword(section->align, fp);
        xfwrite_bytes(utarray_front(section->data), utarray_len(section->data), fp);

        // align to dword size
        unsigned aligned_size = ((utarray_len(section->data) + (sizeof(int32_t) - 1))
            & ~(sizeof(int32_t) - 1));
        int extra_bytes = aligned_size - (int)utarray_len(section->data);
        xfwrite(align, 1, extra_bytes, fp);
    }

	xfwrite_dword(-1, fp);					// end marker

	return fpos0;
}

void objfile_write(objfile_t* obj, FILE* fp) {
	long fpos0 = ftell(fp);

	// write header
	write_signature(fp, is_object);

    // write CPU
    xfwrite_dword(obj->cpu_id, fp);
    xfwrite_dword(obj->swap_ixiy, fp);

    // write placeholders for 6 pointers
	long header_ptr = ftell(fp);
	for (int i = 0; i < 6; i++)
		xfwrite_dword(-1, fp);

	// write blocks, return pointers
	long expr_ptr = objfile_write_exprs(obj, fp);           
	long symbols_ptr = objfile_write_symbols(obj, fp);      
	long externs_ptr = objfile_write_externs(obj, fp);      
	long modname_ptr = objfile_write_modname(obj, fp);      
	long sections_ptr = objfile_write_sections(obj, fp);    
    long st_ptr = ftell(fp);
    strtable_fwrite(obj->st, fp);
	long end_ptr = ftell(fp);

	// write pointers to areas
	xfseek(fp, header_ptr, SEEK_SET);
#define Write_ptr(x, fp)	xfwrite_dword((x) == -1 ? -1 : (x) - fpos0, fp)

	Write_ptr(modname_ptr, fp);     // 0
    Write_ptr(expr_ptr, fp);        // 1
    Write_ptr(symbols_ptr, fp);     // 2
    Write_ptr(externs_ptr, fp);     // 3
    Write_ptr(sections_ptr, fp);    // 4
    Write_ptr(st_ptr, fp);          // 5

#undef Write_ptr

	xfseek(fp, end_ptr, SEEK_SET);
}

//-----------------------------------------------------------------------------
// object or library file
//-----------------------------------------------------------------------------
file_t* file_new() {
	file_t* file = xnew(file_t);
    utstring_new(file->filename);
    utstring_new(file->signature);
	file->type = is_none;
	file->version = -1;
	file->objs = NULL;
    file->st = strtable_new();

	return file;
}

void file_free(file_t* file) {
	utstring_free(file->filename);
	utstring_free(file->signature);

	objfile_t* obj, * tmp;
	DL_FOREACH_SAFE(file->objs, obj, tmp) {
		DL_DELETE(file->objs, obj);
		objfile_free(obj);
	}

    strtable_free(file->st);
	xfree(file);
}

//-----------------------------------------------------------------------------
// read file
//-----------------------------------------------------------------------------
static void file_read_object(file_t* file, FILE* fp, UT_string* signature, int version) {
	objfile_t* obj = objfile_new();

    utstring_concat(obj->filename, file->filename);
    utstring_concat(obj->signature, signature);
	obj->version = version;

	objfile_read(obj, fp);

	DL_APPEND(file->objs, obj);
}

static void file_read_library(file_t* file, FILE* fp, UT_string* signature, int version) {
    utstring_clear(file->signature);
    utstring_concat(file->signature, signature);
	file->version = version;

    UT_string* obj_signature;
    utstring_new(obj_signature);

	int next = SIGNATURE_SIZE;
    if (file->version >= 18) {
        next += sizeof(int32_t);                // skip string table pointer
    }

	int length = 0;
	int obj_version = -1;

	do {
		xfseek(fp, next, SEEK_SET);		        // next object file

		next = xfread_dword(fp);
		length = xfread_dword(fp);

        if (next == -1 && length == 0)
            break;                              // end marker

        file_type_e type = read_signature(fp, utstring_body(file->filename), obj_signature, &obj_version);
        if (type != is_object)
            die("File %s: contains non-object file\n", utstring_body(file->filename));

        if (length == 0) {
			if (opt_obj_list)
				printf("  Deleted...\n");
		}
		else {
            file_read_object(file, fp, obj_signature, obj_version);
		}

		if (opt_obj_list)
			printf("\n");
	} while (next != -1);

    // no need to read string table, it is created while writing

	utstring_free(obj_signature);
}

void file_read(file_t* file, const char* filename) {
    UT_string* signature;
    utstring_new(signature);

	// save file name
    utstring_clear(file->filename);
    utstring_printf(file->filename, "%s", filename);

	// open file and read signature
	FILE* fp = xfopen(filename, "rb");
    if (fp == NULL)
        die("error: cannot open '%s'\n", filename);
    file->type = read_signature(fp, utstring_body(file->filename), signature, &file->version);

	if (opt_obj_verbose)
		printf("Reading file '%s': %s version %d\n",
			filename, file->type == is_object ? "object" : "library", file->version);

	// read object files
	switch (file->type) {
	case is_object:  file_read_object(file, fp, signature, file->version);  break;
	case is_library: file_read_library(file, fp, signature, file->version); break;
	default: xassert(0);
	}

	xfclose(fp);

	utstring_free(signature);
}

//-----------------------------------------------------------------------------
// write file
//-----------------------------------------------------------------------------
static void file_write_object(file_t* file, FILE* fp) {
	objfile_write(file->objs, fp);
}

void objfile_get_defined_symbols(objfile_t* obj, strtable_t* st) {
    section_t* section;
    DL_FOREACH(obj->sections, section) {
        symbol_t* symbol;
        DL_FOREACH(section->symbols, symbol) {
            if (symbol->scope == SCOPE_PUBLIC)
                strtable_add_string(st, utstring_body(symbol->name)); // add public symbols to string table
        }
    }
}

static void file_write_library(file_t* file, FILE* fp) {
    // init string table
    strtable_clear(file->st);

    // write header
	write_signature(fp, is_library);
    long st_ptr = ftell(fp);
    xfwrite_dword(-1, fp);              // placeholder for string table address

    // write each object file
	for (objfile_t* obj = file->objs; obj; obj = obj->next) {
        objfile_get_defined_symbols(obj, file->st);     // setup table of defined symbols

		long header_ptr = ftell(fp);
		xfwrite_dword(-1, fp);			// place holder for next
		xfwrite_dword(-1, fp);			// place holder for size

		long obj_start = ftell(fp);
		objfile_write(obj, fp);
		long obj_end = ftell(fp);
        long obj_size = obj_end - obj_start;

		xfseek(fp, header_ptr, SEEK_SET);
		xfwrite_dword(obj_end, fp);		    // next
		xfwrite_dword(obj_size, fp);
		xfseek(fp, obj_end, SEEK_SET);
	}

    // write end marker
    xfwrite_dword(-1, fp);
    xfwrite_dword(0, fp);

    // write string table
    long st_pos = ftell(fp);
    strtable_fwrite(file->st, fp);
    long fpos = ftell(fp);
    fseek(fp, st_ptr, SEEK_SET);
    xfwrite_dword(st_pos, fp);
    fseek(fp, fpos, SEEK_SET);
}

void file_write(file_t* file, const char* filename)
{
	if (opt_obj_verbose)
		printf("Writing file '%s': %s version %d\n",
			filename, file->type == is_object ? "object" : "library", CUR_VERSION);

	FILE* fp = xfopen(filename, "wb");

	switch (file->type) {
	case is_object:  file_write_object(file, fp);  break;
	case is_library: file_write_library(file, fp); break;
	default: xassert(0);
	}

	xfclose(fp);
}

//-----------------------------------------------------------------------------
// rename sections
//-----------------------------------------------------------------------------
static bool delete_merged_section(objfile_t* obj, section_t** p_merged_section,
	section_t* section, const char* new_name)
{
#define merged_section (*p_merged_section)

	char* old_name = xstrdup(utstring_body(section->name));

	// merge section first to compute alignment
    utstring_clear(section->name);
    utstring_printf(section->name, "%s", new_name);

	// merge section blocks
	int merged_base;
	bool delete_section;
	if (!merged_section) {
		merged_section = section;			// first in chain
		merged_base = 0;
		delete_section = false;
	}
	else {
		merged_base = (int)utarray_len(merged_section->data);

		// handle alignment
		int above = merged_base % section->align;
		if (above > 0) {
			int fill = section->align - above;
			for (int i = 0; i < fill; i++)
				utarray_push_back(merged_section->data, &opt_obj_align_filler);

			merged_base += fill;
		}

		// concatenate section blocks
		utarray_concat(merged_section->data, section->data);
		utarray_clear(section->data);

		symbol_t* symbol, * tmp_symbol;
		DL_FOREACH_SAFE(section->symbols, symbol, tmp_symbol) {
			// compute changed Address
			if (symbol->type == TYPE_ADDRESS)
				symbol->value += merged_base;

			// move to merged_section
			symbol->section = merged_section;
			DL_DELETE(section->symbols, symbol);
			DL_APPEND(merged_section->symbols, symbol);
		}

		expr_t* expr, * tmp_expr;
		DL_FOREACH_SAFE(section->exprs, expr, tmp_expr) {
			// compute changed patch address
			expr->asmpc += merged_base;
			expr->code_pos += merged_base;

			// move to merged_section
			expr->section = merged_section;
			DL_DELETE(section->exprs, expr);
			DL_APPEND(merged_section->exprs, expr);
		}

		delete_section = true;
	}

	xfree(old_name);

	return delete_section;

#undef merged_section
}

void file_rename_sections(file_t* file, const char* old_regexp, const char* new_name)
{
	if (opt_obj_verbose)
		printf("File '%s': rename sections that match '%s' to '%s'\n",
			utstring_body(file->filename), old_regexp, new_name);

	// compile regular expression
	regex_t regex;
	int reti = regcomp(&regex, old_regexp, REG_EXTENDED | REG_NOSUB);
	if (reti)
		die("error: could not compile regex '%s'\n", old_regexp);

	// search file for sections that match
	objfile_t* obj;
	DL_FOREACH(file->objs, obj) {

		if (opt_obj_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		// section to collect all other that match
		section_t* merged_section = NULL;

		section_t* section, * tmp;
		DL_FOREACH_SAFE(obj->sections, section, tmp) {
			if (strcmp(utstring_body(section->name), new_name) == 0 ||
				(reti = regexec(&regex, utstring_body(section->name), 0, NULL, 0))
				== REG_OKAY)
			{	// match
				if (opt_obj_verbose)
					printf("  rename section %s -> %s\n",
						utstring_len(section->name) > 0 ? utstring_body(section->name) : "\"\"",
						new_name);

				// join sections
				if (delete_merged_section(obj, &merged_section, section, new_name)) {
					DL_DELETE(obj->sections, section);
					section_free(section);
				}
			}
			else if (reti == REG_NOMATCH) {		// no match
				if (opt_obj_verbose)
					printf("  skip section %s\n",
						utstring_len(section->name) > 0 ? utstring_body(section->name) : "\"\"");
			}
			else {								// error
				char msgbuf[100];
				regerror(reti, &regex, msgbuf, sizeof(msgbuf));
				die("error: regex match failed: %s\n", msgbuf);
			}
		}
	}

	// free memory
	regfree(&regex);
}

static void obj_rename_symbol(objfile_t* obj, const char* old_name, const char* new_name)
{
    UT_string* new_text;
    utstring_new(new_text);

	section_t* section;
	DL_FOREACH(obj->sections, section) {
		expr_t* expr;
		DL_FOREACH(section->exprs, expr) {
			if (strcmp(utstring_body(expr->target_name), old_name) == 0) {
                utstring_clear(expr->target_name);
                utstring_printf(expr->target_name, "%s", new_name);
			}

			char* p = NULL;
			size_t n = 0;
			while (n < utstring_len(expr->text) &&
				(p = strstr(utstring_body(expr->text) + n, old_name)) != NULL) {
				if ((p == utstring_body(expr->text) || !isalnum(p[-1])) &&
					!isalnum(p[strlen(old_name)])) {
					// old_name is not part of a bigger identifier
                    utstring_clear(new_text);
					utstring_printf(new_text, "%.*s%s%s",
						(int)(p - utstring_body(expr->text)), utstring_body(expr->text),
						new_name,
						p + strlen(old_name));
                    utstring_clear(expr->text);
                    utstring_concat(expr->text, new_text);
					n += p - utstring_body(expr->text) + strlen(new_name);
				}
			}
		}
	}

	utstring_free(new_text);
}

void file_add_symbol_prefix(file_t* file, const char* regexp, const char* prefix)
{
	if (opt_obj_verbose)
		printf("File '%s': add prefix '%s' to symbols that match '%s'\n",
			utstring_body(file->filename), prefix, regexp);

	// compile regular expression
	regex_t regex;
	int reti = regcomp(&regex, regexp, REG_EXTENDED | REG_NOSUB);
	if (reti)
		die("error: could not compile regex '%s'\n", regexp);

	// search file for symbols that match
    UT_string* new_name;
    utstring_new(new_name);

	objfile_t* obj;
	DL_FOREACH(file->objs, obj) {

		if (opt_obj_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		section_t* section;
		DL_FOREACH(obj->sections, section) {

			symbol_t* symbol;
			DL_FOREACH(section->symbols, symbol) {
				if (symbol->scope == SCOPE_PUBLIC) {
					if ((reti = regexec(&regex, utstring_body(symbol->name), 0, NULL, 0)) == REG_OKAY) {	// match
                        utstring_clear(new_name);
                        utstring_printf(new_name, "%s%s", prefix, utstring_body(symbol->name));

						if (opt_obj_verbose)
							printf("  rename symbol %s -> %s\n",
								utstring_body(symbol->name),
								utstring_body(new_name));

						obj_rename_symbol(obj,
							utstring_body(symbol->name),
							utstring_body(new_name));

                        utstring_clear(symbol->name);
                        utstring_concat(symbol->name, new_name);
					}
					else if (reti == REG_NOMATCH) {		// no match
						if (opt_obj_verbose)
							printf("  skip symbol %s\n", utstring_body(symbol->name));
					}
					else {								// error
						char msgbuf[100];
						regerror(reti, &regex, msgbuf, sizeof(msgbuf));
						die("error: regex match failed: %s\n", msgbuf);
					}
				}
			}
		}
	}

	// free memory
	regfree(&regex);
	utstring_free(new_name);
}

void file_rename_symbol(file_t* file, const char* old_name, const char* new_name)
{
	if (opt_obj_verbose)
		printf("File '%s': rename symbol '%s' to '%s'\n",
			utstring_body(file->filename), old_name, new_name);

	objfile_t* obj;
	DL_FOREACH(file->objs, obj) {

		if (opt_obj_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		for (char** ext = argv_front(obj->externs); *ext; ext++) {
			if (strcmp(*ext, old_name) == 0) {	// match
				if (opt_obj_verbose)
					printf("  rename symbol %s -> %s\n", old_name, new_name);

				obj_rename_symbol(obj, old_name, new_name);
				xfree(*ext);
				*ext = xstrdup(new_name);
			}
			else {		// no match
				if (opt_obj_verbose)
					printf("  skip symbol %s\n", *ext);
			}
		}

		section_t* section;
		DL_FOREACH(obj->sections, section) {

			symbol_t* symbol;
			DL_FOREACH(section->symbols, symbol) {
				if (symbol->scope == SCOPE_PUBLIC) {
					if (strcmp(utstring_body(symbol->name), old_name) == 0) {	// match
						if (opt_obj_verbose)
							printf("  rename symbol %s -> %s\n", old_name, new_name);

						obj_rename_symbol(obj, old_name, new_name);
                        utstring_clear(symbol->name);
                        utstring_printf(symbol->name, "%s", new_name);
					}
					else {		// no match
						if (opt_obj_verbose)
							printf("  skip symbol %s\n", utstring_body(symbol->name));
					}
				}
			}
		}
	}
}

static void file_change_symbols_scope(file_t* file, const char* regexp,
    sym_scope_t old_scope, sym_scope_t new_scope)
{
	if (opt_obj_verbose)
		printf("File '%s': make symbols that match '%s' %s\n",
			utstring_body(file->filename), regexp,
			new_scope == SCOPE_LOCAL ? "local" : "global");

	// compile regular expression
	regex_t regex;
	int reti = regcomp(&regex, regexp, REG_EXTENDED | REG_NOSUB);
	if (reti)
		die("error: could not compile regex '%s'\n", regexp);

	// search file for symbols that match
	objfile_t* obj;
	DL_FOREACH(file->objs, obj) {

		if (opt_obj_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		section_t* section;
		DL_FOREACH(obj->sections, section) {

			symbol_t* symbol;
			DL_FOREACH(section->symbols, symbol) {
				if (symbol->scope == old_scope) {
					if ((reti = regexec(&regex, utstring_body(symbol->name), 0, NULL, 0)) == REG_OKAY) {	// match
						if (opt_obj_verbose)
							printf("  change scope of symbol %s -> %s\n",
                                utstring_body(symbol->name),
                                new_scope == SCOPE_LOCAL ? "local" : "global");
						symbol->scope = new_scope;
					}
					else if (reti == REG_NOMATCH) {		// no match
						if (opt_obj_verbose)
							printf("  skip symbol %s\n", utstring_body(symbol->name));
					}
					else {								// error
						char msgbuf[100];
						regerror(reti, &regex, msgbuf, sizeof(msgbuf));
						die("error: regex match failed: %s\n", msgbuf);
					}
				}
			}
		}
	}

	// free memory
	regfree(&regex);
}

void file_make_symbols_local(file_t* file, const char* regexp)
{
	file_change_symbols_scope(file, regexp, SCOPE_PUBLIC, SCOPE_LOCAL);
}

void file_make_symbols_global(file_t* file, const char* regexp)
{
	file_change_symbols_scope(file, regexp, SCOPE_LOCAL, SCOPE_PUBLIC);
}

void file_set_section_org(file_t* file, const char* name, int value)
{
	if (opt_obj_verbose)
		printf("File '%s': set section '%s' ORG to $%04X\n",
			utstring_body(file->filename), name, value);

	// search file for section
	objfile_t* obj;
	DL_FOREACH(file->objs, obj) {

		if (opt_obj_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		section_t* section;
		DL_FOREACH(obj->sections, section) {
			if (strcmp(utstring_body(section->name), name) == 0) {
				if (opt_obj_verbose)
					printf("  section %s ORG -> $%04X\n",
						utstring_len(section->name) > 0 ? utstring_body(section->name) : "\"\"",
						value);
				section->org = value;
			}
			else {
				if (opt_obj_verbose)
					printf("  skip section %s\n",
						utstring_len(section->name) > 0 ? utstring_body(section->name) : "\"\"");
			}
		}
	}
}

void file_set_section_align(file_t* file, const char* name, int value)
{
	if (opt_obj_verbose)
		printf("File '%s': set section '%s' ALIGN to $%04X\n",
			utstring_body(file->filename), name, value);

	// search file for section
	objfile_t* obj;
	DL_FOREACH(file->objs, obj) {

		if (opt_obj_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		section_t* section;
		DL_FOREACH(obj->sections, section) {
			if (strcmp(utstring_body(section->name), name) == 0) {
				if (opt_obj_verbose)
					printf("  section %s ALIGN -> $%04X\n",
						utstring_len(section->name) > 0 ? utstring_body(section->name) : "\"\"",
						value);
				section->align = value;
			}
			else {
				if (opt_obj_verbose)
					printf("  skip section %s\n",
						utstring_len(section->name) > 0 ? utstring_body(section->name) : "\"\"");
			}
		}
	}
}

