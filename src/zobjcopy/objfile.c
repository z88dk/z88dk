//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "zobjcopy.h"

#define MAX_FP     0x7FFFFFFF
#define END(a, b)  ((a) >= 0 ? (a) : (b))

//-----------------------------------------------------------------------------
// symbol
//-----------------------------------------------------------------------------
symbol_t *symbol_new()
{
	symbol_t *sym = New(symbol_t);

	utstring_new(sym->name);
	utstring_new(sym->section);
	utstring_new(sym->filename);
	sym->scope = sym->type = '\0';
	sym->value = sym->line_nr = 0;

	sym->next = sym->prev = NULL;

	return sym;
}

void symbol_free(symbol_t *sym)
{
	utstring_free(sym->name);
	utstring_free(sym->section);
	utstring_free(sym->filename);
	Free(sym);
}

//-----------------------------------------------------------------------------
// expressions
//-----------------------------------------------------------------------------
expr_t *expr_new()
{
	expr_t *expr = New(expr_t);
	utstring_new(expr->text);
	utstring_new(expr->section);
	utstring_new(expr->target_name);
	utstring_new(expr->filename);
	expr->type = '\0';
	expr->asmpc = expr->patch_ptr = expr->line_nr = 0;
	expr->next = expr->prev = NULL;

	return expr;
}

void expr_free(expr_t *expr)
{
	utstring_free(expr->text);
	utstring_free(expr->section);
	utstring_free(expr->target_name);
	utstring_free(expr->filename);
	Free(expr);
}

//-----------------------------------------------------------------------------
// binary code
//-----------------------------------------------------------------------------

static UT_icd ut_byte_icd = { sizeof(byte_t),NULL,NULL,NULL };

code_t *code_new()
{
	code_t *code = New(code_t);
	utarray_new(code->data, &ut_byte_icd);
	utstring_new(code->section);
	code->org = -1;
	code->align = 1;

	return code;
}

void code_free(code_t *code)
{
	utarray_free(code->data);
	utstring_free(code->section);
	Free(code);
}

//-----------------------------------------------------------------------------
// object file
//-----------------------------------------------------------------------------
objfile_t *objfile_new()
{
	objfile_t *obj = New(objfile_t);
	utstring_new(obj->filename);
	utstring_new(obj->signature);
	utstring_new(obj->modname);

	obj->version = obj->global_org = -1;
	obj->names = NULL;
	utarray_new(obj->externs, &ut_str_icd);
	obj->exprs = NULL;

	obj->next = obj->prev = NULL;

	return obj;
}

void objfile_free(objfile_t *obj)
{
	utstring_free(obj->filename);
	utstring_free(obj->signature);
	utstring_free(obj->modname);
	utarray_free(obj->externs);

	symbol_t *sym, *tmp_sym;
	DL_FOREACH_SAFE(obj->names, sym, tmp_sym) {
		DL_DELETE(obj->names, sym);
		symbol_free(sym);
	}

	expr_t *expr, *tmp_expr;
	DL_FOREACH_SAFE(obj->exprs, expr, tmp_expr) {
		DL_DELETE(obj->exprs, expr);
		expr_free(expr);
	}

	code_t *code, *tmp_code;
	DL_FOREACH_SAFE(obj->codes, code, tmp_code) {
		DL_DELETE(obj->codes, code);
		code_free(code);
	}

	Free(obj);
}

static void objfile_read_names(objfile_t *obj, FILE *fp, long fpos_start, long fpos_end)
{
	if (obj->version >= 5)					// signal end by zero type
		fpos_end = MAX_FP;

	fseek(fp, fpos_start, SEEK_SET);
	while (ftell(fp) < fpos_end) {
		char scope = xfread_byte(fp);
		if (scope == '\0')
			break;							// end marker 

		// create a new symbol
		symbol_t *sym = symbol_new();

		// read from file
		sym->scope = scope;
		sym->type = xfread_byte(fp);

		if (obj->version >= 5)
			xfread_bcount_str(sym->section, fp);

		sym->value = xfread_dword(fp);
		xfread_bcount_str(sym->name, fp);
		
		if (obj->version >= 9) {			// add definition location
			xfread_bcount_str(sym->filename, fp);
			sym->line_nr = xfread_dword(fp);
		}

		// insert in the list
		DL_APPEND(obj->names, sym);
	}
}

static void objfile_read_externs(objfile_t *obj, FILE *fp, long fpos_start, long fpos_end)
{
	UT_string *name;
	utstring_new(name);

	fseek(fp, fpos_start, SEEK_SET);
	while (ftell(fp) < fpos_end) {
		xfread_bcount_str(name, fp);
		utarray_push_back(obj->externs, &utstring_body(name));
	}

	utstring_free(name);
}

static void objfile_read_exprs(objfile_t *obj, FILE *fp, long fpos_start, long fpos_end)
{
	UT_string *last_filename = NULL;		// weak pointer to last filename

	if (obj->version >= 4)					// signal end by zero type
		fpos_end = MAX_FP;

	fseek(fp, fpos_start, SEEK_SET);
	while (ftell(fp) < fpos_end) {
		char type = xfread_byte(fp);
		if (type == 0)
			break;							// end marker

		// create a new expression
		expr_t *expr = expr_new();

		// read from file
		expr->type = type;

		if (obj->version >= 4) {
			xfread_wcount_str(expr->filename, fp);
			if (last_filename == NULL || utstring_len(expr->filename) == 0)
				last_filename = expr->filename;

			expr->line_nr = xfread_dword(fp);
		}

		if (obj->version >= 5)
			xfread_bcount_str(expr->section, fp);

		if (obj->version >= 3)
			expr->asmpc = xfread_word(fp);

		expr->patch_ptr = xfread_word(fp);

		if (obj->version >= 6)
			xfread_bcount_str(expr->target_name, fp);

		if (obj->version >= 4) {
			xfread_wcount_str(expr->text, fp);
		}
		else {
			xfread_bcount_str(expr->text, fp);
			char end_marker = xfread_byte(fp);
			if (end_marker != '\0')
				die("missing expression end marker in file '%s'\n",
					utstring_body(obj->filename));
		}

		// insert in the list
		DL_APPEND(obj->exprs, expr);
	}
}

static void objfile_read_codes(objfile_t *obj, FILE *fp, long fpos_start)
{
	fseek(fp, fpos_start, SEEK_SET);
	if (obj->version >= 5) {
		while (true) {
			int code_size = xfread_dword(fp);
			if (code_size < 0)
				break;

			// create new code object
			code_t *code = code_new();

			xfread_bcount_str(code->section, fp);

			if (obj->version >= 8)
				code->org = xfread_dword(fp);
			else
				code->org = -1;

			if (obj->version >= 10)
				code->align = xfread_dword(fp);
			else
				code->align = -1;

			utarray_resize(code->data, code_size);
			xfread(utarray_front(code->data), sizeof(byte_t), code_size, fp);

			// insert in the list
			DL_APPEND(obj->codes, code);
		}
	}
	else {
		// create new code object
		code_t *code = code_new();

		int code_size = xfread_word(fp);
		if (code_size == 0) code_size = 0x10000;

		utarray_resize(code->data, code_size);
		xfread(utarray_front(code->data), sizeof(byte_t), code_size, fp);

		// insert in the list
		DL_APPEND(obj->codes, code);
	}
}

void objfile_read(objfile_t *obj, FILE *fp)
{
	long fpos0 = ftell(fp) - SIGNATURE_SIZE;	// before signature

	// global ORG (for old versions)
	if (obj->version >= 8)
		obj->global_org = -1;
	else if (obj->version >= 5)
		obj->global_org = xfread_dword(fp);
	else
		obj->global_org = xfread_word(fp);

	// file pointers
	long fpos_modname = xfread_dword(fp);
	long fpos_exprs = xfread_dword(fp);
	long fpos_names = xfread_dword(fp);
	long fpos_externs = xfread_dword(fp);
	long fpos_codes = xfread_dword(fp);

	// module name
	fseek(fp, fpos0 + fpos_modname, SEEK_SET);
	xfread_bcount_str(obj->modname, fp);

	// names
	if (fpos_names >= 0)
		objfile_read_names(obj, fp,
			fpos0 + fpos_names,
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
			fpos0 + END(fpos_names, END(fpos_externs, fpos_modname)));

	// code
	if (fpos_codes >= 0)
		objfile_read_codes(obj, fp, fpos0 + fpos_codes);
}

//-----------------------------------------------------------------------------
// object or library file
//-----------------------------------------------------------------------------

file_t *file_new()
{
	file_t *file = New(file_t);
	utstring_new(file->filename);
	utstring_new(file->signature);
	file->type = is_none;
	file->version = -1;
	file->objs = NULL;

	return file;
}

void file_free(file_t *file)
{
	utstring_free(file->filename);
	utstring_free(file->signature);

	objfile_t *obj, *tmp;
	DL_FOREACH_SAFE(file->objs, obj, tmp) {
		DL_DELETE(file->objs, obj);
		objfile_free(obj);
	}
	Free(file);
}

static enum file_type file_read_signature(file_t *file, FILE *fp)
{
	file->type = is_none;
	file->version = -1;
	
	char file_signature[SIGNATURE_SIZE + 1];
	memset(file_signature, 0, sizeof(file_signature));

	// read signature
	if (fread(file_signature, sizeof(char), SIGNATURE_SIZE, fp) != SIGNATURE_SIZE)
		die("error: signature not found in '%s'\n", utstring_body(file->filename));

	if (strncmp(file_signature, "Z80RMF", 6) == 0)
		file->type = is_object;
	else if (strncmp(file_signature, "Z80LMF", 6) == 0)
		file->type = is_library;
	else
		die("error: file '%s' not object nor library\n", utstring_body(file->filename));

	utstring_clear(file->signature);
	utstring_bincpy(file->signature, file_signature, SIGNATURE_SIZE);

	// read version
	if (sscanf(file_signature + 6, "%d", &file->version) < 1)
		die("error: file '%s' not object nor library\n", utstring_body(file->filename));

	if (file->version < MIN_VERSION || file->version > MAX_VERSION)
		die("error: file '%s' version %d not supported\n",
			utstring_body(file->filename), file->version);

	return file->type;
}

static void file_read_object(file_t *file, FILE *fp)
{
	objfile_t *obj = objfile_new();

	utstring_concat(obj->filename, file->filename);
	utstring_concat(obj->signature, file->signature);
	obj->version = file->version;

	objfile_read(obj, fp);

	DL_APPEND(file->objs, obj);
}

static void file_read_library(file_t *file, FILE *fp)
{
	die("not implemented\n");
}

void file_read(file_t *file, const char *filename)
{
	// save file name
	utstring_clear(file->filename); 
	utstring_bincpy(file->filename, filename, strlen(filename));

	// open file and read signature
	FILE *fp = xfopen(filename, "rb");
	file_read_signature(file, fp);
	printf("Input file %s: %s file version %d\n",
		filename, (file->type == is_library ? "library" : "object"), file->version);

	// read object files
	switch (file->type) {
	case is_object:  file_read_object(file, fp);  break;
	case is_library: file_read_library(file, fp); break;
	default: assert(0);
	}

	xfclose(fp);
}

