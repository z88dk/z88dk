//-----------------------------------------------------------------------------
// z80asm - output error messages
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <string>
using namespace std;

// number of elements of array
#ifndef NUM_ELEMS
#define NUM_ELEMS(a)    (sizeof(a) / sizeof(a[0]))
#endif

// error code
enum ErrCode {
#define X(code, message)    code,
#include "errors.def"
};

// output error messages
class Errors {
public:
    void set_output(ostream& os);
    int count() { return count_; }
    void error(ErrCode err_code, const string& argument = "");
    void error(ErrCode err_code, int argument);
    void warning(ErrCode err_code, const string& argument = "");
    void warning(ErrCode err_code, int argument);

private:
    ostream* os_{ &cerr };          // output stream for errors
    int count_{ 0 };                // count errors

    static string error_message(ErrCode err_code);
    static string num_to_text(int n);
};
