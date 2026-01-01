//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "z80asm_defs.h"

#ifdef __cplusplus

#include <string>
#include <vector>
using namespace std;

//-----------------------------------------------------------------------------

struct Location {
    string	filename;		        // current assembly file
    int		line_num{ 0 };	        // curremt assembly line number
    string	source_line;	        // current assembly source line
    string	expanded_line;	        // current macro expanded line
    bool    is_c_source{ false };   // C_LINE seen

    Location(const string& filename = "", int line_num = 0);
    void clear();
    void set_filename(const string& filename);
    void set_prev_line_num(int prev_line_num);
    void set_line_num(int line_num);
    void set_source_line(const string& line);
    void set_expanded_line(const string& line);
    bool empty() const;
    void inc_line_num();
};

//-----------------------------------------------------------------------------

#endif // __cplusplus

enum ErrCode {
#define X(code, message)		code,
#include "errors.def"
};

#ifdef __cplusplus

//-----------------------------------------------------------------------------

struct Errors {
    int count{ 0 };
    Location location;          // current error location

    void error(ErrCode err_code, const string& arg = "");
    void warning(ErrCode err_code, const string& arg = "");

private:
    void show_error(const string& prefix, ErrCode err_code, const string& arg = "");
};

extern Errors g_errors;

//-----------------------------------------------------------------------------

extern "C" {
#endif
    // C interface
    int get_error_count();
    void clear_error_location();
    void set_error_location(const char* filename, int line_num);
    const char* get_error_filename();
    int get_error_line_num();
    void set_error_source_line(const char* line);
    void set_error_expanded_line(const char* line);
    int get_error_is_c_source();
    void error(int err_code, const char* arg);
    void error_hex2(int err_code, int hex_value);
    void error_hex4(int err_code, int hex_value);
    void error_file_not_found(const char* filename);
    void error_file_open(const char* filename);
    void error_duplicate_definition_module(const char* modulename, const char* name);
    void error_invalid_object_file(const char* filename);
    void error_invalid_library_file(const char* filename);
    void error_org_not_aligned(int origin, int align);
    void error_invalid_object_file_version(const char* filename, int found_version, int expected_version);
    void error_invalid_library_file_version(const char* filename, int found_version, int expected_version);
    void error_incompatible_cpu(const char* filename, cpu_t got_cpu_id);
    void error_illegal_cpu(const char* filename, cpu_t got_cpu_id);
    void error_incompatible_ixiy(const char* filename, swap_ixiy_t swap_ixiy);
    void warning(int err_code, const char* arg);
    void warning_hex2(int err_code, int hex_value);
    void warning_org_ignored(const char* filename, const char* section);

#ifdef __cplusplus
}
#endif
