/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Handle object file contruction, reading and writing
*/

#include "class.h"
#include "codearea.h"
#include "die.h"
#include "fileutil.h"
#include "if.h"
#include "libfile.h"
#include "str.h"
#include "strutil.h"
#include "utstring.h"
#include "utlist.h"
#include "zobjfile.h"
#include "z80asm_defs.h"

/*-----------------------------------------------------------------------------
*   Write module to object file
*----------------------------------------------------------------------------*/

static void copy_objfile_externs(objfile_t* obj) {
    Symbol1* sym;
    for (Symbol1HashElem* iter = Symbol1Hash_first(global_symtab); iter!=NULL;
        iter = Symbol1Hash_next(iter)
        ) {
        sym = (Symbol1*)iter->value;

        if (sym->is_touched &&
            (sym->scope == SCOPE_EXTERN || (!sym->is_defined && sym->scope == SCOPE_GLOBAL))
            ) {
            argv_push(obj->externs, sym->name);
        }
    }
}

static void copy_objfile_exprs(objfile_t* obj, Section1* in_section, section_t* out_section) {
    for (Expr1ListElem* iter = Expr1List_first(CURRENTMODULE->exprs); iter != NULL;
        iter = Expr1List_next(iter)
        ) {
        Expr1* in_expr = iter->obj;
        if (in_expr->section == in_section) {
            expr_t* out_expr = expr_new();
            utstring_printf(out_expr->text, "%s", in_expr->text->data);

            out_expr->range = in_expr->range;
            if (in_expr->target_name)      /* EQU expression */
                utstring_printf(out_expr->target_name, "%s", in_expr->target_name);
        
            out_expr->asmpc = in_expr->asmpc;
            out_expr->code_pos = in_expr->code_pos;
            out_expr->opcode_size = in_expr->opcode_size;

            out_expr->section = out_section;        // weak pointer

            utstring_printf(out_expr->filename, "%s", in_expr->filename ? in_expr->filename : "");
            out_expr->line_num = in_expr->line_num;

            // insert in the list
            DL_APPEND(out_expr->section->exprs, out_expr);
        }
    }
}

static void copy_objfile_symbols_symtab(objfile_t* obj, Section1* in_section, section_t* out_section,
    Symbol1Hash* symtab) {
    for (Symbol1HashElem* iter = Symbol1Hash_first(symtab); iter != NULL;
        iter = Symbol1Hash_next(iter)
        ) {
        Symbol1* in_sym = (Symbol1*)iter->value;
        if (in_sym->section == in_section) {
            sym_scope_t scope = 
                (in_sym->scope == SCOPE_PUBLIC ||
                    (in_sym->is_defined && in_sym->scope == SCOPE_GLOBAL)) ? SCOPE_PUBLIC :
                (in_sym->scope == SCOPE_LOCAL) ? SCOPE_LOCAL :
                SCOPE_NONE;

            if (scope != SCOPE_NONE && in_sym->is_touched && in_sym->type != TYPE_UNDEFINED) {
                symbol_t* out_sym = symbol_new();
                utstring_printf(out_sym->name, "%s", in_sym->name);

                out_sym->scope = scope;
                out_sym->type = in_sym->type;
                out_sym->value = in_sym->value;
                out_sym->section = out_section;     // weak pointer

                utstring_printf(out_sym->filename, "%s", in_sym->filename ? in_sym->filename : "");
                out_sym->line_num = in_sym->line_num;

                // insert in the list
                DL_APPEND(out_sym->section->symbols, out_sym);
            }
        }
    }
}

static void copy_objfile_symbols(objfile_t* obj, Section1* in_section, section_t* out_section) {
    copy_objfile_symbols_symtab(obj, in_section, out_section, CURRENTMODULE->local_symtab);
    copy_objfile_symbols_symtab(obj, in_section, out_section, global_symtab);
}

static void copy_objfile_sections(objfile_t* obj) {
    Section1HashElem* iter;
    for (Section1* in_section = get_first_section(&iter); in_section != NULL;
        in_section = get_next_section(&iter)
        ) {
        section_t* out_section = strlen(in_section->name) == 0 ? obj->sections : section_new();
        utstring_printf(out_section->name, "%s", in_section->name);
        out_section->org = in_section->origin;
        if (in_section->section_split)
            out_section->org = ORG_SECTION_SPLIT;
        out_section->align = in_section->align;

        set_cur_section(in_section);
        int addr = get_cur_module_start();
        int size = get_cur_module_size();

        utarray_resize(out_section->data, size);
        if (size > 0) {     /* ByteArray_item(bytes,0) creates item[0]!! */
            char* data = utarray_front(out_section->data);
            if (data != NULL)
                memcpy(data, (char*)ByteArray_item(in_section->bytes, addr), size);
        }

        copy_objfile_exprs(obj, in_section, out_section);
        copy_objfile_symbols(obj, in_section, out_section);

        // insert in the list
        if (out_section != obj->sections)		// not first = "" section
            DL_APPEND(obj->sections, out_section);
    }

    set_cur_section(get_first_section(NULL));
}

// convert to objfile_t
static objfile_t* copy_objfile(const char* obj_filename) {
    objfile_t* obj = objfile_new();
    utstring_printf(obj->filename, "%s", obj_filename);
    utstring_printf(obj->signature, "%s" SIGNATURE_VERS, SIGNATURE_OBJ, CUR_VERSION);
    utstring_printf(obj->modname, "%s", CURRENTMODULE->modname);
    obj->version = CUR_VERSION;
    obj->cpu_id = option_cpu();
    obj->swap_ixiy = option_swap_ixiy();
    copy_objfile_externs(obj);
    copy_objfile_sections(obj);
    return obj;
}

void write_obj_file(const char* obj_filename) {
    if (option_verbose())
        printf("Writing object file '%s'\n", path_canon(obj_filename));

    objfile_t* obj = copy_objfile(obj_filename);

	// #2254 - write temp file
	UT_string* temp_filename;
	utstring_new(temp_filename);
	utstring_printf(temp_filename, "%s~", obj_filename);

	FILE* fp = xfopen(utstring_body(temp_filename), "wb");
    objfile_write(obj, fp);

	/* close temp file and rename to object file */
	xfclose(fp);

	// #2254 - rename temp file
	remove(obj_filename);
	int rv = rename(utstring_body(temp_filename), obj_filename);
	if (rv != 0) 
		error_file_rename(utstring_body(temp_filename));

	utstring_free(temp_filename);
    objfile_free(obj);
}

bool check_object_file(const char* obj_filename)
{
	return check_obj_lib_file(
        false,
		obj_filename,
        objfile_header(),
        error_file_not_found,
        error_file_open,
		error_not_obj_file,
		error_obj_file_version,
        error_cpu_incompatible,
        error_ixiy_incompatible);
}

static void no_error_file(const char* filename) {}
static void no_error_version(const char* filename, int version, int expected) {}
static void no_error_cpu_incompatible(const char* filename, cpu_t cpu_id) {}
static void no_error_ixiy_incompatible(const char* filename, swap_ixiy_t swap_ixiy) {}

bool check_object_file_no_errors(const char* obj_filename) {
	return check_obj_lib_file(
        false,
		obj_filename,
        objfile_header(),
        no_error_file,
		no_error_file,
		no_error_file,
		no_error_version,
        no_error_cpu_incompatible,
        no_error_ixiy_incompatible);
}

bool check_obj_lib_file(
    bool is_lib,
    const char* filename,
    const char* signature,
    void(*do_error_file_not_found)(const char*),
    void(*do_error_file_open)(const char*),
    void(*do_error_file_type)(const char*),
    void(*do_error_version)(const char*, int, int),
    void(*do_error_cpu_incompatible)(const char*, cpu_t),
    void(*do_error_ixiy_incompatible)(const char*, swap_ixiy_t))
{
    FILE* fp = NULL;

    // file exists?
    if (!file_exists(filename)) {
        do_error_file_not_found(filename);
        return false;
    }

    // can read file?
    fp = fopen(filename, "rb");
    if (fp == NULL) {
        do_error_file_open(filename);
        return false;
    }

    // can read header?
    char header[SIGNATURE_SIZE + 1];
    if (SIGNATURE_SIZE != fread(header, 1, SIGNATURE_SIZE, fp)) {
        do_error_file_type(filename);
        fclose(fp);
        return false;
    }
    header[SIGNATURE_SIZE] = '\0';

    // header has correct prefix?
    if (strncmp(header, signature, SIGNATURE_BASE_SIZE) != 0) {
        do_error_file_type(filename);
        fclose(fp);
        return false;
    }

    // has right version?
    int version;
    if (1 != sscanf(header + SIGNATURE_BASE_SIZE, "%d", &version)) {
        do_error_file_type(filename);
        fclose(fp);
        return false;
    }
    if (version != CUR_VERSION) {
        do_error_version(filename, version, CUR_VERSION);
        fclose(fp);
        return false;
    }

    // libraries may contain multiple cpu-ixiy combinations
    if (is_lib || option_lib_for_all_cpus()) {
        fclose(fp);
        return true;
    }

    // only for object files
    
    // has right CPU?
    cpu_t cpu_id = xfread_dword(fp);
    if (!cpu_compatible(option_cpu(), cpu_id)) {
        do_error_cpu_incompatible(filename, cpu_id);
        fclose(fp);
        return false;
    }

    // has right -XIIY?
    swap_ixiy_t swap_ixiy = xfread_dword(fp);
    if (!ixiy_compatible(option_swap_ixiy(), swap_ixiy)) {
        do_error_ixiy_incompatible(filename, swap_ixiy);
        fclose(fp);
        return false;
    }

    // ok
	fclose(fp);
	return true;
}
