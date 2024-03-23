//-----------------------------------------------------------------------------
// z80asm - output error messages
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "xassert.h"
#include <iomanip>
#include <sstream>
using namespace std;

void Errors::set_output(ostream& os) {
    os_ = &os;
}

void Errors::error(ErrCode err_code, const string& argument) {
    count_++;
    *os_ << "error: " << error_message(err_code);
    if (!argument.empty())
        *os_ << ": " << argument;
    *os_ << endl;
}

void Errors::error(ErrCode err_code, int argument) {
    count_++;
    *os_ << "error: " << error_message(err_code) << ": " << num_to_text(argument) << endl;
}

void Errors::warning(ErrCode err_code, const string& argument) {
    *os_ << "warning: " << error_message(err_code);
    if (!argument.empty())
        *os_ << ": " << argument;
    *os_ << endl;
}

void Errors::warning(ErrCode err_code, int argument) {
    *os_ << "warning: " << error_message(err_code) << ": " << num_to_text(argument) << endl;
}

string Errors::error_message(ErrCode err_code) {
    static const char* messages[] = {
#define X(code, message)    message,
#include "errors.def"
    };

    xassert(err_code < NUM_ELEMS(messages));
    return messages[(int)err_code];
}

string Errors::num_to_text(int n) {
    if (n < 0)
        return string("-") + num_to_text(-n);
    else if (n < 10)
        return std::to_string(n);
    else if (n < 0x100) {
        ostringstream oss;
        oss << "$" << setw(2) << setfill('0') << hex << n;
        return oss.str();
    }
    else if (n < 0x10000) {
        ostringstream oss;
        oss << "$" << setw(4) << setfill('0') << hex << n;
        return oss.str();
    }
    else if (n < 0x1000000) {
        ostringstream oss;
        oss << "$" << setw(6) << setfill('0') << hex << n;
        return oss.str();
    }
    else {
        ostringstream oss;
        oss << "$" << setw(8) << setfill('0') << hex << n;
        return oss.str();
    }
}
