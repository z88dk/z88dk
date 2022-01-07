/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
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
#include "options.h"
#include "str.h"
#include "strutil.h"
#include "utstring.h"
#include "zobjfile.h"
#include "zutils.h"

/*-----------------------------------------------------------------------------
*   Object header
*----------------------------------------------------------------------------*/
char Z80objhdr[] = "Z80RMF" OBJ_VERSION;

#define Z80objhdr_size (sizeof(Z80objhdr)-1)
#define Z80objhdr_version_pos 6

/*-----------------------------------------------------------------------------
*   Write module to object file
*----------------------------------------------------------------------------*/
static long write_expr(FILE* fp)
{
	STR_DEFINE(last_sourcefile, STR_SIZE);		/* keep last source file referred to in object */
	ExprListElem* iter;
	Expr* expr;
	char range;
	const char* target_name;
	long expr_ptr;

	if (ExprList_empty(CURRENTMODULE->exprs))	/* no expressions */
		return -1;

	expr_ptr = ftell(fp);
	for (iter = ExprList_first(CURRENTMODULE->exprs); iter != NULL; iter = ExprList_next(iter))
	{
		expr = iter->obj;

		/* store range */
		range = 0;
		if (expr->target_name)
		{
			target_name = expr->target_name;		/* EQU expression */
			range = '=';
		}
		else
		{
			target_name = "";						/* patch expression */
			switch (expr->range)
			{
			case RANGE_DWORD:			range = 'L'; break;
			case RANGE_WORD:			range = 'C'; break;
			case RANGE_WORD_BE:			range = 'B'; break;
			case RANGE_BYTE_UNSIGNED:	range = 'U'; break;
			case RANGE_BYTE_SIGNED:		range = 'S'; break;
			case RANGE_HIGH_OFFSET:     range = 'H'; break;
			case RANGE_BYTE_TO_WORD_UNSIGNED:	range = 'u'; break;
			case RANGE_BYTE_TO_WORD_SIGNED:		range = 's'; break;
			case RANGE_PTR24:			range = 'P'; break;
			case RANGE_JR_OFFSET:		range = 'J'; break;
			default:					xassert(0);
			}
		}
		xfwrite_byte(range, fp);				/* range of expression */

		/* store file name if different from last, folowed by source line number */
		if (expr->filename != NULL &&
			strcmp(Str_data(last_sourcefile), expr->filename) != 0)
		{
			xfwrite_wcount_cstr(expr->filename, fp);
			Str_set(last_sourcefile, expr->filename);
		}
		else
			xfwrite_wcount_cstr("", fp);

		xfwrite_dword(expr->line_num, fp);				/* source line number */

		xfwrite_wcount_cstr(expr->section->name, fp);	/* section name */

		xfwrite_word(expr->asmpc, fp);					/* ASMPC */
		xfwrite_word(expr->code_pos, fp);				/* patchptr */
		xfwrite_wcount_cstr(target_name, fp);			/* target symbol for expression */
		xfwrite_wcount_cstr(Str_data(expr->text), fp);	/* expression */
	}

	xfwrite_byte(0, fp);								/* terminator */

	STR_DELETE(last_sourcefile);

	return expr_ptr;
}

static int write_symbols_symtab(FILE* fp, SymbolHash* symtab)
{
	SymbolHashElem* iter;
	Symbol* sym;
	int written = 0;
	char scope, type;

	for (iter = SymbolHash_first(symtab); iter; iter = SymbolHash_next(iter))
	{
		sym = (Symbol*)iter->value;

		/* scope */
		scope =
			(sym->scope == SCOPE_PUBLIC || (sym->is_defined && sym->scope == SCOPE_GLOBAL)) ? 'G' :
			(sym->scope == SCOPE_LOCAL) ? 'L' : 0;

		if (scope != 0 && sym->is_touched && sym->type != TYPE_UNKNOWN)
		{
			/* type */
			type = 0;
			switch (sym->type)
			{
			case TYPE_CONSTANT:	type = 'C'; break;
			case TYPE_ADDRESS:	type = 'A'; break;
			case TYPE_COMPUTED:	type = '='; break;
			default: xassert(0);
			}

			xfwrite_byte(scope, fp);
			xfwrite_byte(type, fp);

			xfwrite_wcount_cstr(sym->section->name, fp);
			xfwrite_dword(sym->value, fp);
			xfwrite_wcount_cstr(sym->name, fp);

			// write symbol definition location
			xfwrite_wcount_cstr(sym->filename ? sym->filename : "", fp);
			xfwrite_dword(sym->line_num, fp);

			written++;
		}
	}
	return written;
}

static long write_symbols(FILE* fp)
{
	long symbols_ptr;
	int written = 0;

	symbols_ptr = ftell(fp);

	written += write_symbols_symtab(fp, CURRENTMODULE->local_symtab);
	written += write_symbols_symtab(fp, global_symtab);

	if (written)
	{
		xfwrite_byte(0, fp);								/* terminator */
		return symbols_ptr;
	}
	else
		return -1;
}

static long write_externsym(FILE* fp)
{
	SymbolHashElem* iter;
	Symbol* sym;
	long externsym_ptr;
	int written = 0;

	externsym_ptr = ftell(fp);

	for (iter = SymbolHash_first(global_symtab); iter; iter = SymbolHash_next(iter))
	{
		sym = (Symbol*)iter->value;

		if (sym->is_touched &&
			(sym->scope == SCOPE_EXTERN || (!sym->is_defined && sym->scope == SCOPE_GLOBAL)))
		{
			xfwrite_wcount_cstr(sym->name, fp);
			written++;
		}
	}

	if (written)
		return externsym_ptr;
	else
		return -1;
}

static long write_modname(FILE* fp)
{
	long modname_ptr = ftell(fp);
	xfwrite_wcount_cstr(CURRENTMODULE->modname, fp);		/* write module name */
	return modname_ptr;
}

static long write_code(FILE* fp)
{
	long code_ptr;
	int code_size = 0;
	bool wrote_data = false;

	code_ptr = ftell(fp);
	wrote_data = fwrite_module_code(fp, &code_size);

	if (opts.verbose)
		printf("Module '%s' size: %ld bytes\n", CURRENTMODULE->modname, (long)code_size);

	if (wrote_data)
		return code_ptr;
	else
		return -1;
}

void write_obj_file(const char* source_filename)
{
	const char* obj_filename;
	FILE* fp;
	long header_ptr, modname_ptr, expr_ptr, symbols_ptr, externsym_ptr, code_ptr;
	int i;

	/* open file */
	obj_filename = get_obj_filename(source_filename);

	if (opts.verbose)
		printf("Writing object file '%s'\n", path_canon(obj_filename));

	fp = xfopen(obj_filename, "wb");

	/* write header */
	xfwrite_cstr(Z80objhdr, fp);

	/* write placeholders for 5 pointers */
	header_ptr = ftell(fp);
	for (i = 0; i < 5; i++)
		xfwrite_dword(-1, fp);

	/* write sections, return pointers */
	expr_ptr = write_expr(fp);
	symbols_ptr = write_symbols(fp);
	externsym_ptr = write_externsym(fp);
	modname_ptr = write_modname(fp);
	code_ptr = write_code(fp);

	/* write pointers to areas */
	fseek(fp, header_ptr, SEEK_SET);
	xfwrite_dword(modname_ptr, fp);
	xfwrite_dword(expr_ptr, fp);
	xfwrite_dword(symbols_ptr, fp);
	xfwrite_dword(externsym_ptr, fp);
	xfwrite_dword(code_ptr, fp);

	/* close temp file and rename to object file */
	xfclose(fp);
}



/*-----------------------------------------------------------------------------
*   Check the object file header
*----------------------------------------------------------------------------*/
static bool test_header(FILE* file)
{
	char buffer[Z80objhdr_size];

	if (fread(buffer, 1, Z80objhdr_size, file) == Z80objhdr_size &&
		memcmp(buffer, Z80objhdr, Z80objhdr_size) == 0
		)
		return true;
	else
		return false;
}

/*-----------------------------------------------------------------------------
*   Object file class
*----------------------------------------------------------------------------*/
DEF_CLASS(OFile);

void OFile_init(OFile* self)
{
	self->modname_ptr =
		self->expr_ptr =
		self->symbols_ptr =
		self->externsym_ptr =
		self->code_ptr = -1;
}

void OFile_copy(OFile* self, OFile* other) { xassert(0); }

void OFile_fini(OFile* self)
{
	/* if not from library, close file */
	if (self->file != NULL &&
		self->start_ptr == 0
		)
		xfclose(self->file);

	/* if writing but not closed, delete partialy created file */
	if (self->writing &&
		self->start_ptr == 0 &&
		self->file != NULL &&
		self->filename != NULL
		)
		remove(self->filename);
}

/*-----------------------------------------------------------------------------
*	read object file header from within an open library file.
*   Return NULL if invalid object file or not the correct version.
*   Object needs to be deleted by caller by OBJ_DELETE()
*   Keeps the library file open
*----------------------------------------------------------------------------*/
OFile* OFile_read_header(FILE* file, size_t start_ptr)
{
	UT_string* modname = utstr_new();
	OFile* self;

	/* check file version */
	fseek(file, start_ptr, SEEK_SET);
	if (!test_header(file))
		return NULL;

	/* create OFile object */
	self = OBJ_NEW(OFile);

	self->file = file;
	self->start_ptr = start_ptr;
	self->writing = false;

	self->modname_ptr = xfread_dword(file);
	self->expr_ptr = xfread_dword(file);
	self->symbols_ptr = xfread_dword(file);
	self->externsym_ptr = xfread_dword(file);
	self->code_ptr = xfread_dword(file);

	/* read module name */
	fseek(file, start_ptr + self->modname_ptr, SEEK_SET);
	xfread_wcount_str(modname, file);
	self->modname = spool_add(utstr_body(modname));

	utstr_free(modname);

	return self;
}

/*-----------------------------------------------------------------------------
*	open object file for reading, read header.
*   Return NULL if invalid object file or not the correct version.
*   Object needs to be deleted by caller by OBJ_DELETE()
*   Keeps the object file open
*----------------------------------------------------------------------------*/
static OFile* _OFile_open_read(const char* filename, bool test_mode)
{
	OFile* self;
	FILE* file;

	/* file exists? */
	file = fopen(filename, "rb");
	if (!file) {
		if (!test_mode)
			error_file_open(filename);
		return NULL;
	}

	/* read header */
	self = OFile_read_header(file, 0);
	if (self == NULL)
	{
		xfclose(file);

		if (!test_mode)
			error_not_obj_file(filename);

		return NULL;
	}
	self->filename = spool_add(filename);

	/* return object */
	return self;
}

OFile* OFile_open_read(const char* filename)
{
	return _OFile_open_read(filename, false);
}

/*-----------------------------------------------------------------------------
*	close object file
*----------------------------------------------------------------------------*/
void OFile_close(OFile* self)
{
	if (self != NULL && self->file != NULL)
	{
		xfclose(self->file);
		self->file = NULL;
	}
}

/*-----------------------------------------------------------------------------
*	test if a object file exists and is the correct version, return object if yes
*   return NULL if not.
*   Object needs to be deleted by caller by OBJ_DELETE()
*----------------------------------------------------------------------------*/
OFile* OFile_test_file(const char* filename)
{
	return _OFile_open_read(filename, true);
}

/*-----------------------------------------------------------------------------
*	return static ByteArray with binary contents of given file
*	return NULL if input file is not an object, or does not exist
*	NOTE: not reentrant, reuses array on each call
*----------------------------------------------------------------------------*/
ByteArray* read_obj_file_data(const char* filename)
{
	static ByteArray* buffer = NULL;
	size_t	 size;
	OFile* ofile;

	/* static object to read each file, not reentrant */
	INIT_OBJ(ByteArray, &buffer);

	/* open object file, check header */
	ofile = OFile_open_read(filename);
	if (ofile == NULL)
		return NULL;					/* error */

	fseek(ofile->file, 0, SEEK_END);	/* file pointer to end of file */
	size = ftell(ofile->file);
	fseek(ofile->file, 0, SEEK_SET);	/* file pointer to start of file */

	/* set array size, read file */
	ByteArray_set_size(buffer, size);
	xfread_bytes(ByteArray_item(buffer, 0), size, ofile->file);

	OBJ_DELETE(ofile);

	return buffer;
}

/*-----------------------------------------------------------------------------
*	Updates current module name and size, if given object file is valid
*	Load module name and size, when assembling with -d and up-to-date
*----------------------------------------------------------------------------*/
static bool objmodule_loaded_1(const char* obj_filename, UT_string* section_name)
{
	int code_size;
	OFile* ofile;
	Section* section;

	ofile = OFile_test_file(obj_filename);
	if (ofile != NULL)
	{
		CURRENTMODULE->modname = ofile->modname;

		/* reserve space in each section; BUG_0015 */
		if (ofile->code_ptr >= 0)
		{
			fseek(ofile->file, ofile->start_ptr + ofile->code_ptr, SEEK_SET);

			while (true)	/* read sections until end marker */
			{
				code_size = xfread_dword(ofile->file);
				if (code_size < 0)
					break;

				/* reserve space in section */
				xfread_wcount_str(section_name, ofile->file);
				section = new_section(utstr_body(section_name));
				read_origin(ofile->file, section);
				section->align = xfread_dword(ofile->file);

				append_reserve(code_size);

				/* advance past code block */
				fseek(ofile->file, code_size, SEEK_CUR);
			}
		}

		OBJ_DELETE(ofile);					/* BUG_0049 */

		return true;
	}
	else
		return false;
}

bool objmodule_loaded(const char* obj_filename)
{
	UT_string* section_name = utstr_new();
	bool ret = objmodule_loaded_1(obj_filename, section_name);
	utstr_free(section_name);
	return ret;
}

bool check_object_file(const char* obj_filename)
{
	return check_obj_lib_file(
		obj_filename,
		Z80objhdr,
		error_not_obj_file,
		error_obj_file_version);
}

static void no_error_file(const char* filename) {}
static void no_error_version(const char* filename, int version, int expected) {}

bool check_object_file_no_errors(const char* obj_filename) {
	return check_obj_lib_file(
		obj_filename,
		Z80objhdr,
		no_error_file,
		no_error_version);
}

bool check_obj_lib_file(const char* filename,
	char* signature,
	void(*error_file)(const char*),
	void(*error_version)(const char*, int, int))
{
	FILE* fp = NULL;

	// can read file?
	fp = fopen(filename, "rb");
	if (fp == NULL) {
		error_file_open(filename);
		goto error;
	}

	// can read header?
	char header[Z80objhdr_size + 1];
	if (Z80objhdr_size != fread(header, 1, Z80objhdr_size, fp)) {
		error_file(filename);
		goto error;
	}

	// header has correct prefix?
	if (strncmp(header, signature, Z80objhdr_version_pos) != 0) {
		error_file(filename);
		goto error;
	}

	// has right version?
	header[Z80objhdr_size] = '\0';
	int version, expected;
	sscanf(OBJ_VERSION, "%d", &expected);
	if (1 != sscanf(header + Z80objhdr_version_pos, "%d", &version)) {
		error_file(filename);
		goto error;
	}
	if (version != expected) {
		error_version(filename, version, expected);
		goto error;
	}

	// ok
	fclose(fp);
	return true;

error:
	if (fp)
		fclose(fp);
	return false;
}
