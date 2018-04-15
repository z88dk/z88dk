//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "utarray.h"
#include "utstring.h"
#include <stdbool.h>
#include <stdio.h>

#define MIN_VERSION		1
#define MAX_VERSION		11
#define CUR_VERSION		MAX_VERSION
#define SIGNATURE_SIZE	8
#define SIGNATURE_OBJ	"Z80RMF"
#define SIGNATURE_LIB	"Z80LMF"
#define SIGNATURE_VERS	"%02d"
#define ALIGN_FILLER	0xFF

enum file_type { is_none, is_library, is_object };

// a defined symbol
typedef struct symbol_s
{
	UT_string *name;
	UT_string *section;
	UT_string *filename;
	char	scope;
	char	type;
	int		value;
	int		line_nr;

	struct symbol_s *next, *prev;		// to store DL list of symbols
} symbol_t;

extern symbol_t *symbol_new();
extern void symbol_free(symbol_t *sym);

// an expression
typedef struct expr_s
{
	UT_string *text;
	UT_string *section;
	UT_string *target_name;
	UT_string *filename;
	char	type;
	int		asmpc, patch_ptr;
	int		line_nr;

	struct expr_s *next, *prev;			// to store DL list of symbols
} expr_t;

extern expr_t *expr_new();
extern void expr_free(expr_t *expr);

// object code
typedef struct code_s
{
	UT_array	*data;
	UT_string	*section;
	int			 org;
	int			 align;

	struct code_s *next, *prev;			// to store DL list of symbols

	bool	renamed;
	bool	deleted;
} code_t;

extern code_t *code_new();
extern void code_free(code_t *code);

// one object file
typedef struct objfile_s
{
	UT_string	*filename;
	UT_string	*signature;
	UT_string	*modname;
	int			 version;
	int			 global_org;

	symbol_t	*names;
	UT_array	*externs;
	expr_t		*exprs;
	code_t		*codes;

	struct objfile_s *next, *prev;		// to store DL list of object files
} objfile_t;

extern objfile_t *objfile_new();
extern void objfile_free(objfile_t *obj);
extern void objfile_read(objfile_t *obj, FILE *fp);
extern void objfile_write(objfile_t *obj, FILE *fp);

// one file - either object or library
typedef struct file_s
{
	UT_string	*filename;
	UT_string	*signature;
	enum file_type type;
	int			 version;

	objfile_t	*objs;					// either one or multiple object files

} file_t;

extern file_t *file_new();
extern void file_free(file_t *file);
extern void file_read(file_t *file, const char *filename);
extern void file_write(file_t *file, const char *filename);
extern void file_rename_sections(file_t *file, const char *old_regexp, const char *new_name);
