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

Errors::Errors() {
    clear();
}

void Errors::clear() {
    os_ = &cerr;
    count_ = 0;
    source_lines_.clear();
    source_lines_.emplace_back();           // always keep one element
}

void Errors::set_output(ostream& os) {
    os_ = &os;
}

int Errors::count() const {
    return count_;
}

int Errors::exit_code() const {
    return count_ == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}

const Location& Errors::location() const {
    return source_lines_.back().location;
}

const string& Errors::source_line() {
    return source_lines_.back().source_line;
}

const string& Errors::expanded_line() {
    return source_lines_.back().expanded_line;
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
    source_lines_.back().source_line = line;
    source_lines_.back().expanded_line.clear();
}

void Errors::set_expanded_line(const string& line) {
    source_lines_.back().expanded_line = line;
}

void Errors::set_location(const Location& location) {
    source_lines_.back().location = location;
    source_lines_.back().source_line.clear();
    source_lines_.back().expanded_line.clear();
}

void Errors::clear_location() {
    source_lines_.back().location.clear();
    source_lines_.back().source_line.clear();
    source_lines_.back().expanded_line.clear();
}

void Errors::push_location(const Location& location) {
    source_lines_.emplace_back();
    source_lines_.back().location = location;
}

void Errors::pop_location() {
    if (source_lines_.size() > 1)
        source_lines_.pop_back();
    else
        clear_location();
}

string Errors::error_prefix() {
    ostringstream oss;
    if (!location().empty())
        oss << location().to_string() << ": ";
    return oss.str();
}

string Errors::error_suffix() {
    ostringstream oss;
    if (!source_lines_.back().source_line.empty()) {
        oss << endl << "  ^---- " << str_remove_extra_blanks(source_lines_.back().source_line);
        if (!source_lines_.back().expanded_line.empty()) {
            string source_wo_spaces = str_remove_all_blanks(source_lines_.back().source_line);
            string expanded_wo_spaces = str_remove_all_blanks(source_lines_.back().expanded_line);
            if (source_wo_spaces != expanded_wo_spaces)
                oss << endl << "    ^---- " << str_remove_extra_blanks(source_lines_.back().expanded_line);
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
