//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "z80asm_defs.h"
#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#define TOSTR(x)	_TOSTR(x)
#define _TOSTR(x)	#x

// program name
#define Z80ASM_PROG	    "z88dk-z80asm"

// environment variable
#define Z80ASM_ENVVAR	"Z80ASM"

// library base name
#define Z80ASM_LIB_BASE	Z80ASM_PROG

// default file name extensions
#define EXT_ASM     ".asm"    
#define EXT_LIS		".lis"    
#define EXT_O		".o"	  
#define EXT_DEF     ".def"    
#define EXT_BIN     ".bin"    
#define EXT_LIB     ".lib"    
#define EXT_SYM     ".sym"    
#define EXT_MAP     ".map"    
#define EXT_RELOC   ".reloc"
#define EXT_M4      ".m4"

// appmake
#define APPMAKE_NONE	0
#define APPMAKE_ZX81	1
#define APPMAKE_ZX		2

#define ZX_ORIGIN		23760		// origin for unexpanded ZX Spectrum
#define ZX_ORIGIN_MIN	ZX_ORIGIN
#define ZX_ORIGIN_MAX	0xFFFF
#define ZX_APP_EXT		".tap"		// ZX Spectrum TAP file

#define ZX81_ORIGIN		16514		// origin for ZX 81
#define ZX81_ORIGIN_MIN	ZX81_ORIGIN
#define ZX81_ORIGIN_MAX	ZX81_ORIGIN
#define ZX81_APP_EXT	".P"		// ZX81 .P file

// main routine
int z80asm_main();

// string pool
const char* spool_add(const char* str);

// C memory allocation
void* must_malloc(size_t size);
void* must_calloc(size_t count, size_t size);
void* must_realloc(void* block, size_t size);
void must_free(void* block);
char* must_strdup(const char* str);

void library_file_append(const char* filename);
void set_origin_option(int origin);

// filesystem
const char* path_parent_dir(const char* filename);
bool path_file_exists(const char* filename);
const char* path_replace_ext(const char* filename, const char* ext);

const char* get_asm_filename(const char* filename);
const char* get_lis_filename(const char* filename);
const char* get_o_filename(const char* filename);
const char* get_def_filename(const char* filename);
const char* get_bin_filename(const char* filename, const char* section);
const char* get_lib_filename(const char* filename);
const char* get_sym_filename(const char* filename);
const char* get_map_filename(const char* filename);
const char* get_reloc_filename(const char* filename);

// symbol table
struct Symbol1;
struct Symbol1* define_static_def_sym(const char* name, long value);
void undefine_static_def_sym(const char* name);
struct Symbol1* define_local_def_sym(const char* name, long value);
void undefine_local_def_sym(const char* name);
struct Symbol1* find_local_symbol(const char* name);

// expressions
void parse_const_expr_eval(const char* expr_text,
    int* result, bool* error, bool silent);
void parse_expr_eval_if_condition(const char *expr_text, bool* condition, bool* error);
bool check_ifdef_condition(const char* name);

// source file input
bool sfile_open(const char* filename);
void sfile_hold_input();
void sfile_unhold_input();
char* sfile_getline();	// NOTE: user must free returned pointer
const char* sfile_filename();
int sfile_line_num();
bool sfile_is_c_source();

// code area
int get_PC();
int get_phased_PC();
const char* get_cur_section_name(void);

// list file
void list_open(const char* list_file);
void list_close();
void list_source_line(const char* filename, int line_num, const char* section, int asmpc, int phased_pc, const char* text);
void list_expanded_line(const char* section, int asmpc, int phased_pc, const char* text);
void list_append_bytes(int value, int num_bytes);
void list_patch_bytes(const char* section, int asmpc, int value, int num_bytes);
void list_end_line();
void list_got_source_line(const char* filename, int line_num, const char* text);
void list_got_expanded_line(const char* text);
void list_set(bool f);
bool list_is_on();

// floats
const char* get_float_format_define(void);

// object files
bool check_object_file(const char* obj_filename);
bool check_object_file_no_errors(const char* obj_filename);

#ifdef __cplusplus
}
#endif
