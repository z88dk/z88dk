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
	symbol_t *sym = xnew(symbol_t);

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
	xfree(sym);
}

//-----------------------------------------------------------------------------
// expressions
//-----------------------------------------------------------------------------
expr_t *expr_new()
{
	expr_t *expr = xnew(expr_t);
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
	xfree(expr);
}

//-----------------------------------------------------------------------------
// binary code
//-----------------------------------------------------------------------------

static UT_icd ut_byte_icd = { sizeof(byte_t),NULL,NULL,NULL };

code_t *code_new()
{
	code_t *code = xnew(code_t);
	utarray_new(code->data, &ut_byte_icd);
	utstring_new(code->section);
	code->org = -1;
	code->align = 1;
	code->renamed = false;
	code->deleted = false;
	return code;
}

void code_free(code_t *code)
{
	utarray_free(code->data);
	utstring_free(code->section);
	xfree(code);
}

//-----------------------------------------------------------------------------
// signature
//-----------------------------------------------------------------------------
static enum file_type read_signature(FILE *fp, const char *filename,
	UT_string *signature, int *version)
{
	enum file_type type = is_none;
	*version = -1;

	char file_signature[SIGNATURE_SIZE + 1];

	// read signature
	if (fread(file_signature, sizeof(char), SIGNATURE_SIZE, fp) != SIGNATURE_SIZE)
		die("error: signature not found in '%s'\n", filename);

	if (strncmp(file_signature, SIGNATURE_OBJ, 6) == 0)
		type = is_object;
	else if (strncmp(file_signature, SIGNATURE_LIB, 6) == 0)
		type = is_library;
	else
		die("error: file '%s' not object nor library\n", filename);

	utstring_clear(signature);
	utstring_bincpy(signature, file_signature, SIGNATURE_SIZE);

	// read version
	if (sscanf(file_signature + 6, "%d", version) < 1)
		die("error: file '%s' not object nor library\n", filename);

	if (*version < MIN_VERSION || *version > MAX_VERSION)
		die("error: file '%s' version %d not supported\n",
			filename, *version);

	if (opt_list)
		printf("%s file %s at $%04lX: %s\n",
			type == is_library ? "Library" : "Object ",
			filename,
			ftell(fp) - SIGNATURE_SIZE, file_signature);

	return type;
}

static void write_signature(FILE *fp, enum file_type type)
{
	UT_string *signature;
	utstring_new(signature);

	utstring_printf(signature,
		"%s" SIGNATURE_VERS,
		type == is_object ? SIGNATURE_OBJ : SIGNATURE_LIB,
		CUR_VERSION);

	xfwrite(utstring_body(signature), sizeof(char), SIGNATURE_SIZE, fp);

	utstring_free(signature);
}

//-----------------------------------------------------------------------------
// object file
//-----------------------------------------------------------------------------
objfile_t *objfile_new()
{
	objfile_t *obj = xnew(objfile_t);
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

	xfree(obj);
}

static void print_section(UT_string *section)
{
	if (opt_list) {
		printf(" (section ");
		if (utstring_len(section) > 0)
			printf("%s", utstring_body(section));
		else
			printf("\"\"");
		printf(")");
	}
}

static void print_filename_line_nr(UT_string *filename, int line_nr)
{
	if (opt_list) {
		printf(" (file ");
		if (utstring_len(filename) > 0)
			printf("%s", utstring_body(filename));
		else
			printf("\"\"");
		if (line_nr > 0)
			printf(":%d", line_nr);
		printf(")");
	}
}

static void print_bytes(UT_array *data) 
{
	size_t addr = 0;
	byte_t *p = (byte_t*)utarray_front(data);
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

static void objfile_read_names(objfile_t *obj, FILE *fp, long fpos_start, long fpos_end)
{
	if (obj->version >= 5)					// signal end by zero type
		fpos_end = MAX_FP;

	if (opt_list)
		printf("  Names:\n");

	xfseek(fp, fpos_start, SEEK_SET);
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

		if (opt_list) {
			printf("    %c %c $%04X %s",
				sym->scope, sym->type, sym->value, utstring_body(sym->name));

			if (obj->version >= 5)
				print_section(sym->section);

			if (obj->version >= 9)
				print_filename_line_nr(sym->filename, sym->line_nr);

			printf("\n");
		}

		// insert in the list
		DL_APPEND(obj->names, sym);
	}
}

static long objfile_write_names(objfile_t *obj, FILE *fp)
{
	if (!obj->names) return -1;					// no defined symbols

	long fpos0 = ftell(fp);						// start of symbols area

	for (symbol_t *symbol = obj->names; symbol; symbol = symbol->next) {
		xfwrite_byte(symbol->scope, fp);		// scope
		xfwrite_byte(symbol->type, fp);			// type
		xfwrite_bcount_str(symbol->section, fp);// section
		xfwrite_dword(symbol->value, fp);		// value
		xfwrite_bcount_str(symbol->name, fp);	// name
		xfwrite_bcount_str(symbol->filename, fp);// filename
		xfwrite_dword(symbol->line_nr, fp);		// definition line
	}

	// store end-terminator
	xfwrite_byte(0, fp);

	return fpos0;
}

static void objfile_read_externs(objfile_t *obj, FILE *fp, long fpos_start, long fpos_end)
{
	UT_string *name;
	utstring_new(name);

	if (opt_list)
		printf("  External names:\n");

	xfseek(fp, fpos_start, SEEK_SET);
	while (ftell(fp) < fpos_end) {
		xfread_bcount_str(name, fp);
		utarray_push_back(obj->externs, &utstring_body(name));

		if (opt_list)
			printf("    U         %s\n", utstring_body(name));
	}

	utstring_free(name);
}

static long objfile_write_externs1(objfile_t *obj, FILE *fp, UT_string *name)
{
	if (utarray_len(obj->externs) == 0) return -1;	// no external symbols

	long fpos0 = ftell(fp);							// start of externals area

	char **pname = NULL;
	while ((pname = (char**)utarray_next(obj->externs, pname)) != NULL) {
		utstring_clear(name);
		utstring_printf(name, "%s", *pname);
		xfwrite_bcount_str(name, fp);
	}

	return fpos0;
}

static long objfile_write_externs(objfile_t *obj, FILE *fp)
{
	UT_string *name;
	utstring_new(name);

	long ret = objfile_write_externs1(obj, fp, name);

	utstring_free(name);
	return ret;
}

static void objfile_read_exprs(objfile_t *obj, FILE *fp, long fpos_start, long fpos_end)
{
	UT_string *last_filename = NULL;		// weak pointer to last filename

	if (obj->version >= 4)					// signal end by zero type
		fpos_end = MAX_FP;

	if (opt_list)
		printf("  Expressions:\n");

	xfseek(fp, fpos_start, SEEK_SET);
	while (ftell(fp) < fpos_end) {
		char type = xfread_byte(fp);
		if (type == 0)
			break;							// end marker

		if (opt_list)
			printf("    E %c%c",
				type,
				type == '=' ? ' ' :
				type == 'L' ? 'l' :
				type == 'C' ? 'w' :
				type == 'B' ? 'W' : 'b');

		// create a new expression
		expr_t *expr = expr_new();

		// read from file
		expr->type = type;

		if (obj->version >= 4) {
			xfread_wcount_str(expr->filename, fp);
			if (last_filename == NULL || utstring_len(expr->filename) > 0)
				last_filename = expr->filename;

			expr->line_nr = xfread_dword(fp);
		}

		if (obj->version >= 5)
			xfread_bcount_str(expr->section, fp);

		if (obj->version >= 3) {
			expr->asmpc = xfread_word(fp);

			if (opt_list)
				printf(" $%04X", expr->asmpc);
		}

		expr->patch_ptr = xfread_word(fp);
		if (opt_list)
			printf(" $%04X: ", expr->patch_ptr);

		if (obj->version >= 6) {
			xfread_bcount_str(expr->target_name, fp);

			if (opt_list && utstring_len(expr->target_name) > 0)
				printf("%s := ", utstring_body(expr->target_name));
		}

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

		if (opt_list)
			printf("%s", utstring_body(expr->text));

		if (opt_list && obj->version >= 5) 
			print_section(expr->section);

		if (opt_list && obj->version >= 4)
			print_filename_line_nr(last_filename, expr->line_nr);

		if (opt_list)
			printf("\n");

		// insert in the list
		DL_APPEND(obj->exprs, expr);
	}
}

static long objfile_write_exprs1(objfile_t *obj, FILE *fp, UT_string *last_filename, UT_string *empty)
{
	if (!obj->exprs) return -1;				// no expressions

	long fpos0 = ftell(fp);					// start of expressions area

	utstring_clear(last_filename);
	for (expr_t *expr = obj->exprs; expr; expr = expr->next) {
		
		// store type
		xfwrite_byte(expr->type, fp);		

		// store file name if different from last, folowed by source line number
		if (strcmp(utstring_body(expr->filename), utstring_body(last_filename)) != 0) {
			xfwrite_wcount_str(expr->filename, fp);
			utstring_clear(last_filename); 
			utstring_concat(last_filename, expr->filename);
		}
		else {
			xfwrite_wcount_str(empty, fp);
		}

		xfwrite_dword(expr->line_nr, fp);			// source line number
		xfwrite_bcount_str(expr->section, fp);		// section name

		xfwrite_word(expr->asmpc, fp);				// ASMPC
		xfwrite_word(expr->patch_ptr, fp);			// patchptr
		xfwrite_bcount_str(expr->target_name, fp);	// target symbol for expression
		xfwrite_wcount_str(expr->text, fp);			// expression
	}

	// store end-terminator
	xfwrite_byte(0, fp);

	return fpos0;
}

static long objfile_write_exprs(objfile_t *obj, FILE *fp)
{
	UT_string *last_filename, *empty;
	utstring_new(last_filename);
	utstring_new(empty);

	long ret = objfile_write_exprs1(obj, fp, last_filename, empty);

	utstring_free(last_filename);
	utstring_free(empty);
	return ret;
}

static void objfile_read_codes(objfile_t *obj, FILE *fp, long fpos_start)
{
	xfseek(fp, fpos_start, SEEK_SET);
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

			if (opt_list) {
				printf("  Code: %d bytes", code_size);

				if (code->org >= 0)
					printf(", ORG $%04X", code->org);
				else if (code->org == -2) 
					printf(", section split");
				else
					;

				if (code->align > 1)
					printf(", ALIGN %d", code->align);

				print_section(code->section);
				printf("\n");
			}

			utarray_resize(code->data, code_size);
			xfread(utarray_front(code->data), sizeof(byte_t), code_size, fp);

			if (opt_list)
				print_bytes(code->data);

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

		if (opt_list && code_size > 0) {
			printf("  Code: %d bytes\n", code_size);
			print_bytes(code->data);
		}

		// insert in the list
		DL_APPEND(obj->codes, code);
	}
}

static long objfile_write_codes(objfile_t *obj, FILE *fp)
{
	if (!obj->codes) return -1;				// no code sections

	long fpos0 = ftell(fp);

	for (code_t *code = obj->codes; code; code = code->next) {
		xfwrite_dword(utarray_len(code->data), fp);
		xfwrite_bcount_str(code->section, fp);
		xfwrite_dword(code->org, fp);
		xfwrite_dword(code->align, fp);
		xfwrite(utarray_front(code->data), sizeof(byte_t), utarray_len(code->data), fp);
	}

	xfwrite_dword(-1, fp);					// end marker

	return fpos0;
}

static long objfile_write_modname(objfile_t *obj, FILE *fp)
{
	long fpos0 = ftell(fp);
	xfwrite_bcount_str(obj->modname, fp);
	return fpos0;
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
	xfseek(fp, fpos0 + fpos_modname, SEEK_SET);
	xfread_bcount_str(obj->modname, fp);
	if (opt_list)
		printf("  Name: %s\n", utstring_body(obj->modname));

	// global ORG
	if (opt_list && obj->global_org >= 0)
		printf("  Org:  $%04X\n", obj->global_org);

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

void objfile_write(objfile_t *obj, FILE *fp)
{
	long fpos0 = ftell(fp);

	// write header
	write_signature(fp, is_object);

	// write placeholders for 5 pointers
	long header_ptr = ftell(fp);
	for (int i = 0; i < 5; i++)
		xfwrite_dword(-1, fp);

	// write sections, return pointers
	long expr_ptr = objfile_write_exprs(obj, fp);
	long symbols_ptr = objfile_write_names(obj, fp);
	long externsym_ptr = objfile_write_externs(obj, fp);
	long modname_ptr = objfile_write_modname(obj, fp);
	long code_ptr = objfile_write_codes(obj, fp);
	long end_ptr = ftell(fp);

	// write pointers to areas
	xfseek(fp, header_ptr, SEEK_SET);
	xfwrite_dword(modname_ptr == -1 ? -1 : modname_ptr - fpos0, fp);
	xfwrite_dword(expr_ptr == -1 ? -1 : expr_ptr - fpos0, fp);
	xfwrite_dword(symbols_ptr == -1 ? -1 : symbols_ptr - fpos0, fp);
	xfwrite_dword(externsym_ptr == -1 ? -1 : externsym_ptr - fpos0, fp);
	xfwrite_dword(code_ptr == -1 ? -1 : code_ptr - fpos0, fp);

	xfseek(fp, end_ptr, SEEK_SET);
}

//-----------------------------------------------------------------------------
// object or library file
//-----------------------------------------------------------------------------

file_t *file_new()
{
	file_t *file = xnew(file_t);
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
	xfree(file);
}

static void file_read_object(file_t *file, FILE *fp, UT_string *signature, int version)
{
	objfile_t *obj = objfile_new();

	utstring_concat(obj->filename, file->filename);
	utstring_concat(obj->signature, signature);
	obj->version = version;

	objfile_read(obj, fp);

	DL_APPEND(file->objs, obj);
}

static void file_read_library(file_t *file, FILE *fp, UT_string *signature, int version)
{
	utstring_concat(file->signature, signature);
	file->version = version;

	UT_string *obj_signature;
	utstring_new(obj_signature);

	long fpos0 = ftell(fp) - SIGNATURE_SIZE;	// before signature
	int next = SIGNATURE_SIZE;
	int length = 0;
	int obj_version = -1;

	do {
		xfseek(fp, fpos0 + next, SEEK_SET);		// next object file

		next = xfread_dword(fp);
		length = xfread_dword(fp);

		enum file_type type = read_signature(fp, utstring_body(file->filename), obj_signature, &obj_version);
		if (type != is_object)
			die("File %s: contains non-object file\n", utstring_body(file->filename));

		if (length == 0) {
			if (opt_list)
				printf("  Deleted...\n");
		}
		else {
			file_read_object(file, fp, obj_signature, obj_version);
		}

		if (opt_list)
			printf("\n");
	} while (next != -1);

	utstring_free(obj_signature);
}

void file_read(file_t *file, const char *filename)
{
	UT_string *signature;
	utstring_new(signature);

	// save file name
	utstring_clear(file->filename); 
	utstring_bincpy(file->filename, filename, strlen(filename));

	// open file and read signature
	FILE *fp = xfopen(filename, "rb");
	file->type = read_signature(fp, utstring_body(file->filename), signature, &file->version);

	if (opt_verbose)
		printf("Reading file '%s': %s version %d\n",
			filename, file->type == is_object ? "object" : "library", file->version);

	// read object files
	switch (file->type) {
	case is_object:  file_read_object(file, fp, signature, file->version);  break;
	case is_library: file_read_library(file, fp, signature, file->version); break;
	default: assert(0);
	}

	xfclose(fp);

	utstring_free(signature);
}

static void file_write_object(file_t *file, FILE *fp)
{
	objfile_write(file->objs, fp);
}

static void file_write_library(file_t *file, FILE *fp)
{
	// write header
	write_signature(fp, is_library);

	for (objfile_t *obj = file->objs; obj; obj = obj->next) {
		long header_ptr = ftell(fp);
		xfwrite_dword(-1, fp);			// place holder for next
		xfwrite_dword(-1, fp);			// place holder for size
		
		long obj_start = ftell(fp);
		objfile_write(obj, fp);
		long obj_end = ftell(fp);

		xfseek(fp, header_ptr, SEEK_SET);
		if (obj->next)
			xfwrite_dword(obj_end, fp);		// next
		else
			xfwrite_dword(-1, fp);			// last
		xfwrite_dword(obj_end - obj_start, fp);

		xfseek(fp, obj_end, SEEK_SET);
	}
}

void file_write(file_t *file, const char *filename)
{
	if (opt_verbose)
		printf("Writing file '%s': %s version %d\n",
			filename, file->type == is_object ? "object" : "library", CUR_VERSION);

	FILE *fp = xfopen(filename, "wb");

	switch (file->type) {
	case is_object:  file_write_object(file, fp);  break;
	case is_library: file_write_library(file, fp); break;
	default: assert(0);
	}

	xfclose(fp);
}

static void merge_section(objfile_t *obj, code_t *code_head, int code_size,
	const char *old_name, const char *new_name)
{
	symbol_t *symbol;
	expr_t *expr;
	code_t *code;

	// merge code first to compute alignment
	DL_FOREACH(obj->codes, code) {
		if (strcmp(utstring_body(code->section), old_name) == 0) {
			utstring_clear(code->section);
			utstring_bincpy(code->section, new_name, strlen(new_name));

			// merge code blocks
			if (code_head) {
				// handle alignment
				int above = code_size % code->align;
				if (above > 0) {
					byte_t filler = ALIGN_FILLER;
					for (int i = 0; i < code->align - above; i++)
						utarray_push_back(code_head->data, &filler);
					code_size += code->align - above;
				}

				// concatenate code blocks
				utarray_concat(code_head->data, code->data);
				utarray_clear(code->data);
				code->deleted = true;
			}
		}
	}

	DL_FOREACH(obj->names, symbol) {
		if (strcmp(utstring_body(symbol->section), old_name) == 0) {
			// rename section
			utstring_clear(symbol->section);
			utstring_bincpy(symbol->section, new_name, strlen(new_name));

			// compute changed Address
			if (code_head && symbol->type == 'A')
				symbol->value += code_size;
		}
	}

	DL_FOREACH(obj->exprs, expr) {
		if (strcmp(utstring_body(expr->section), old_name) == 0) {
			utstring_clear(expr->section);
			utstring_bincpy(expr->section, new_name, strlen(new_name));

			// compute changed path address
			if (code_head) {
				expr->asmpc += code_size;
				expr->patch_ptr += code_size;
			}
		}
	}
}

void file_rename_sections(file_t *file, const char *old_regexp, const char *new_name)
{
	if (opt_verbose)
		printf("Renaming sections in file '%s' that match '%s' to '%s'\n",
			utstring_body(file->filename), old_regexp, new_name);

	// compile regular expression
	regex_t regex;
	int reti = regcomp(&regex, old_regexp, REG_EXTENDED | REG_NOSUB);
	if (reti)
		die("error: could not compile regex '%s'\n", old_regexp);

	// search file for sections that match
	objfile_t *obj;
	code_t *code;
	DL_FOREACH(file->objs, obj) {

		if (opt_verbose)
			printf("Block '%s'\n", utstring_body(obj->signature));

		// for each object file
		DL_FOREACH(obj->codes, code) {
			code->renamed = false;
			code->deleted = false;
		}

		// section to collect all other that match
		code_t *code_head = NULL;
		int code_size = 0;

		DL_FOREACH(obj->codes, code) {
			if (!code->renamed) {
				reti = regexec(&regex, utstring_body(code->section), 0, NULL, 0);
				if (reti == REG_OKAY) {				// match
					if (opt_verbose)
						printf("  rename section %s -> %s\n",
							utstring_body(code->section), new_name);

					// join sections
					// NOTE: code->section is modified in merge_section(), need to save old name
					char *old_name = xstrdup(utstring_body(code->section));
					merge_section(obj, code_head, code_size, old_name, new_name);
					xfree(old_name);

					if (!code_head) 
						code_head = code;
					code_size = utarray_len(code_head->data);
				}
				else if (reti == REG_NOMATCH) {		// no match
					if (opt_verbose)
						printf("  skip section %s\n",
							utstring_body(code->section));
				}
				else {								// error
					char msgbuf[100];
					regerror(reti, &regex, msgbuf, sizeof(msgbuf));
					die("error: regex match failed: %s\n", msgbuf);
				}
				code->renamed = true;
			}
		}

		// delete code blocks that have been merged
		code_t *tmp;
		DL_FOREACH_SAFE(obj->codes, code, tmp) {
			if (code->deleted) {
				DL_DELETE(obj->codes, code);
				code_free(code);
			}
		}
	}

	// free memory
	regfree(&regex);
}
