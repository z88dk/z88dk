//-----------------------------------------------------------------------------
// z80asm
// interface between C and C++ components
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// main routine
int z80asm_main(int argc, char *argv[]);

// string pool
const char* spool_add(const char* str);

// errors
void error_include_recursion(const char* filename);
void error_invalid_char();
void error_invalid_squoted_string();
void error_read_file(const char* filename);
void error_symbol_redefined(const char* name);
void error_syntax();
void error_unbalanced_struct(void);
void error_unbalanced_struct_at(const char* filename, int line_num);
void error_unclosed_string();
void error_wrong_number_macro_args(const char* name);

// options
bool option_ucase();
const char* search_includes(const char* filename);

// expressions
void parse_expr_eval_if_condition(const char *expr_text, bool* condition, bool* error);
bool check_ifdef_condition(const char* name);

// source file input
bool sfile_open(const char* filename, bool search_include_path);
void sfile_hold_input();
void sfile_unhold_input();
const char* sfile_getline();
const char* sfile_get_source_line();
const char* sfile_filename();
int sfile_line_num();
bool sfile_is_c_source();
void sfile_set_filename(const char* filename);
void sfile_set_line_num(int line_num, int line_inc);
void sfile_set_c_source(bool f);
void got_source_line(const char* filename, int line_num, const char* text);
void got_expanded_line(const char* filename, int line_num, const char* text);

#ifdef __cplusplus
}
#endif
