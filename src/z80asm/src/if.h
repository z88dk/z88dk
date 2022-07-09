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

// main routine
int z80asm_main(int argc, char *argv[]);

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
void error_glob_no_files(const char* pattern);
void error_illegal_ident();
void error_illegal_option(const char* option);
void error_int_range(int value);
void error_invalid_char_const();
void error_invalid_define_option(const char* define_text);
void error_invalid_filler_option(const char* filler_text);
void error_invalid_float_format();
void error_invalid_org(int origin);
void error_invalid_org_option(const char* origin_text);
void error_jr_not_local();
void error_lib_file_version(const char* filename, int found_version, int expected_version);
void error_missing_block();
void error_missing_close_block();
void error_missing_quote();
void error_no_src_file();
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
bool option_ucase();
bool option_list_file();
bool option_cur_list();
bool option_verbose();
const char* search_includes(const char* filename);

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

// floats
bool set_float_format(const char* format);
const char* get_float_format_define(void);

#ifdef __cplusplus
}
#endif
