//-----------------------------------------------------------------------------
// z80asm - output error messages
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "location.h"
#include <iostream>
#include <string>
using namespace std;

// error code
enum ErrCode {
#define X(code, message)    code,
#include "errors.def"
};

// output error messages
class Errors {
public:
    void clear();
    void set_output(ostream& os);
    int count() const { return count_; }
    void error(ErrCode err_code, const string& argument = "");
    void error(ErrCode err_code, int argument);
    void warning(ErrCode err_code, const string& argument = "");
    void warning(ErrCode err_code, int argument);
    void set_source_line(const string& line);
    void set_expanded_line(const string& line);
    const Location& location() const;
    void set_location(const Location& location);
    void clear_location();
    string source_line();
    string expanded_line();

private:
    ostream* os_{ &cerr };          // output stream for errors
    int count_{ 0 };                // count errors
    string source_line_;            // input line where error detected
    string expanded_line_;          // input line after macro processing
    Location location_;             // error location

    string error_prefix();
    string error_suffix();
    static string error_message(ErrCode err_code);
    static string num_to_text(int n);
};
