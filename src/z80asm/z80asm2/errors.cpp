//-----------------------------------------------------------------------------
// z80asm - output error messages
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "utils.h"
#include "xassert.h"
#include <iomanip>
#include <sstream>
using namespace std;

void Errors::clear() {
    os_ = &cerr;
    count_ = 0;
    clear_location();
}

void Errors::set_output(ostream& os) {
    os_ = &os;
}

void Errors::error(ErrCode err_code, const string& argument) {
    count_++;
    *os_ << error_prefix() << "error: " << error_message(err_code);
    if (!argument.empty())
        *os_ << ": " << argument;
    *os_ << error_suffix() << endl;
}

void Errors::error(ErrCode err_code, int argument) {
    count_++;
    *os_ << error_prefix() << "error: " << error_message(err_code)
        << ": " << num_to_text(argument) << error_suffix() << endl;
}

void Errors::warning(ErrCode err_code, const string& argument) {
    *os_ << error_prefix() << "warning: " << error_message(err_code);
    if (!argument.empty())
        *os_ << ": " << argument;
    *os_ << error_suffix() << endl;
}

void Errors::warning(ErrCode err_code, int argument) {
    *os_ << error_prefix() << "warning: " << error_message(err_code)
        << ": " << num_to_text(argument) << error_suffix() << endl;
}

void Errors::set_source_line(const string& line) {
    source_line_ = line;
    expanded_line_.clear();
}

void Errors::set_expanded_line(const string& line) {
    expanded_line_ = line;
}

void Errors::clear_location() {
    HasLocation::clear();
    source_line_.clear();
    expanded_line_.clear();
}

string Errors::source_line() {
    return source_line_;
}

string Errors::expanded_line() {
    return expanded_line_;
}

string Errors::error_prefix() {
    ostringstream oss;
    if (!location().empty())
        oss << location().to_string() << ": ";
    return oss.str();
}

string Errors::error_suffix() {
    ostringstream oss;
    if (!source_line_.empty()) {
        oss << endl << "  ^---- " << str_remove_extra_blanks(source_line_);
        if (!expanded_line_.empty()) {
            string source_wo_spaces = str_remove_all_blanks(source_line_);
            string expanded_wo_spaces = str_remove_all_blanks(expanded_line_);
            if (source_wo_spaces != expanded_wo_spaces)
                oss << endl << "    ^---- " << str_remove_extra_blanks(expanded_line_);
        }
    }
    return oss.str();
}

string Errors::error_message(ErrCode err_code) {
    static const char* messages[] = {
#define X(code, message)    message,
#include "errors.def"
    };

    xassert((size_t)err_code < NUM_ELEMS(messages));
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
