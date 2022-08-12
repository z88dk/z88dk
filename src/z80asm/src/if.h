//-----------------------------------------------------------------------------
// z80asm
// interface between C and C++ components
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#define TOSTR(x)	_TOSTR(x)
#define _TOSTR(x)	#x

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


// CPU types
#define CPU_Z80     (1 << 0)
#define CPU_Z80N	(1 << 1)
#define CPU_Z180    (1 << 2)
#define CPU_R2KA	(1 << 3)
#define CPU_R3K		(1 << 4)
#define CPU_8080	(1 << 5)
#define CPU_8085	(1 << 6)
#define CPU_GBZ80	(1 << 7)

#define CPU_Z80_NAME		"z80"
#define CPU_Z80N_NAME		"z80n"
#define CPU_Z180_NAME		"z180"
#define CPU_R2KA_NAME		"r2ka"
#define CPU_R3K_NAME		"r3k"
#define CPU_8080_NAME		"8080"
#define CPU_8085_NAME		"8085"
#define CPU_GBZ80_NAME		"gbz80"
#define ARCH_TI83_NAME		"ti83"
#define ARCH_TI83PLUS_NAME	"ti83plus"

#define CPU_ZILOG	(CPU_Z80 | CPU_Z80N | CPU_Z180)
#define CPU_RABBIT	(CPU_R2KA | CPU_R3K)
#define CPU_ALL		(CPU_ZILOG | CPU_RABBIT)
#define CPU_NOT_Z80	(CPU_ALL & ~(CPU_Z80 | CPU_Z80N))

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

// errors
int get_num_errors();
void clear_error_location();
void set_error_location(const char* filename, int line_num);
const char* get_error_filename();
int get_error_line_num();
void set_error_source_line(const char* line);
void set_error_expanded_line(const char* line);

void error_align_redefined();
void error_expected_const_expr();
void error_division_by_zero();
void error_duplicate_definition(const char* name);
void error_duplicate_definition_module(const char* modulename, const char* name);
void error_expr_recursion();
void error_file_open(const char* filename);
void error_illegal_ident();
void error_int_range(int value);
void error_invalid_char_const();
void error_invalid_org(int origin);
void error_jr_not_local();
void error_lib_file_version(const char* filename, int found_version, int expected_version);
void error_missing_block();
void error_missing_close_block();
void error_missing_quote();
void error_not_lib_file(const char* filename);
void error_not_obj_file(const char* filename);
void error_obj_file_version(const char* filename, int found_version, int expected_version);
void error_org_not_aligned(int origin, int align);
void error_org_redefined();
void error_segment_overflow();
void error_string_too_long();
void error_symbol_redecl(const char* name);
void error_syntax();
void error_syntax_expr();
void error_undefined_symbol(const char* name);
void warn_expr_in_parens();
void warn_org_ignored(const char* filename, const char* section);
void warn_int_range(int value);
void error_dma_base_register_illegal(int value);
void error_dma_missing_args();
void error_dma_extra_args();
void error_dma_illegal_port_A_timing();
void error_dma_illegal_port_B_timing();
void error_dma_unsupported_interrupts();
void warn_dma_unsupported_features();
void warn_dma_unsupported_command();
void error_dma_illegal_mode();
void error_dma_illegal_command();
void error_dma_illegal_read_mask();
void warn_dma_half_cycle_timing();
void warn_dma_ready_signal_unsupported();
void error_cmd_failed(const char* cmd);
void error_assert_failed();

// options
bool option_verbose();
bool option_swap_ixiy();
void push_includes(const char* dir);
void pop_includes();
const char* search_includes(const char* filename);
int option_cpu();
const char* option_cpu_name();
bool option_ti83();
bool option_ti83plus();
bool option_speed();
bool option_debug();
const char* search_libraries(const char* filename);
const char* option_lib_file();
void library_file_append(const char* filename);
const char* option_bin_file();
bool option_make_bin();
bool option_split_bin();
bool option_date_stamp();
bool option_relocatable();
bool option_reloc_info();
int option_filler();
void set_origin_option(int origin);
bool option_symtable();
bool option_list_file();
bool option_map();
bool option_globaldef();
int option_appmake();
bool option_consol_obj_file();
const char* option_consol_obj_file_name();
size_t option_files_size();
const char* option_file(size_t n);

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

// expressions
void parse_const_expr_eval(const char* expr_text, int* result, bool* error);
void parse_expr_eval_if_condition(const char *expr_text, bool* condition, bool* error);
bool check_ifdef_condition(const char* name);

// source file input
bool sfile_open(const char* filename, bool search_include_path);
void sfile_hold_input();
void sfile_unhold_input();
char* sfile_getline();			// NOTE: user must free returned pointer
char* sfile_get_source_line();	// NOTE: user must free returned pointer
const char* sfile_filename();
int sfile_line_num();
bool sfile_is_c_source();
void sfile_set_filename(const char* filename);
void sfile_set_line_num(int line_num, int line_inc);
void sfile_set_c_source(bool f);

// symbol table
struct Symbol1;
struct Symbol1* define_static_def_sym(const char* name, long value);

// code area
int get_PC();
int get_phased_PC();

// list file
void list_open(const char* list_file);
void list_close();
void list_source_line(const char* filename, int line_num, int asmpc, int phased_pc, const char* text);
void list_expanded_line(int asmpc, int phased_pc, const char* text);
void list_append_bytes(int value, int num_bytes);
void list_patch_bytes(int asmpc, int value, int num_bytes);
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
