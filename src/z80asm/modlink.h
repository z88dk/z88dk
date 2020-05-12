/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2020
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#pragma once

#include "types.h"
#include "expr.h"
#include "module.h"
#include "utlist.h"

// list of objects/libraries to search during linking
typedef struct obj_file_t {
	struct obj_file_t* next, *prev;		// doubly linked list
	const char*		filename;			// library file name (strpool)
	int				size;				// size of library file
	byte_t*			data;				// contents of library file, loaded before linking
	int				i;					// point to next position to parse
	Module*			module;				// weak pointer to main module information, if object file
} obj_file_t;


extern obj_file_t*	g_libraries;		// list of libraries to link
extern obj_file_t*	g_objects;			// list of linked objects


void obj_files_append(obj_file_t** plist, const char* filename, Module* module);
bool obj_files_read_data(obj_file_t** plist);
void obj_files_free(obj_file_t** plist);

// append a library from the command line to the list to be linked
bool library_file_append(const char* filename);

// append an object from the command line to the list to be linked
bool object_file_append(const char* filename, Module* module);
void object_module_append(obj_file_t* obj, Module* module);

void link_modules( void );
void compute_equ_exprs( ExprList *exprs, bool show_error, bool module_relative_addr );
