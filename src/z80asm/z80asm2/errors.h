//-----------------------------------------------------------------------------
// z80asm - output error messages
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "location.h"
#include <iostream>
#include <string>
#include <vector>
using namespace std;

// error code
enum ErrCode {
#define X(code, message)    code,
#include "errors.def"
};

// output error messages
class Errors {
public:
    Errors();
    void clear();

    void set_output(ostream& os);

    int count() const;
    int exit_code() const;
    const Location& location() const;
    const string& source_line();
    const string& expanded_line();

    void error(ErrCode err_code, const string& argument = "");
    void error(ErrCode err_code, int argument);
    void warning(ErrCode err_code, const string& argument = "");
    void warning(ErrCode err_code, int argument);

    void set_source_line(const string& line);
    void set_expanded_line(const string& line);
    void set_location(const Location& location);
    void clear_location();

    void push_location(const Location& location);
    void pop_location();

private:
    struct SourceLine {
        Location location;              // source file location
        string source_line;             // input line where error detected
        string expanded_line;           // input line after macro expansion
    };

    ostream* os_;                       // output stream for errors
    int count_;                         // count errors
    vector<SourceLine> source_lines_;   // stack of locations

    string error_prefix();
    string error_suffix();
    static string error_message(ErrCode err_code);
    static string num_to_text(int n);
};
