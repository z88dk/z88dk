//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include <string>
using namespace std;

struct Location {
    PoolStr     filename;
    int         line_num;
    int         line_inc{ 1 };
    bool        is_c_source{ false };

    Location(const string& filename = "", int line_num = 0);
    void clear();
    bool empty() const;
    void inc_line_num();
};


struct Errors {
    enum class Code {
#define X(id, text)    id,
#include "errors.def"
    };

    int         count{ 0 };
    Location    location;
    string      source_line;
    string      expanded_line;

    void clear(); // except count
    void clear_lines();
    int exit_code() const;

    void error(Code code, const string& arg = "");
    void warning(Code code, const string& arg = "");
    void os_error(Code code, const string& arg = "");

private:
    void show_message(bool is_error, Code code, const string& arg);
};

extern Errors g_errors;
