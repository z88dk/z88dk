//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include <iostream>
#include <sstream>

#define X(code, msg) msg,
static const char* error_messages[] = {
#include "errors.def"
};
#undef X

Errors g_errors;

Errors::Errors() = default;

void Errors::reset() {
    error_count_ = 0;
    clear();
}

void Errors::clear() {
    location_.clear();
    source_line_.clear();
    expanded_line_.clear();
    last_error_message_.clear();
}

void Errors::error(ErrorCode code, const std::string& arg) {
    ++error_count_;
    format_error_message(code, "error", arg);
    std::cerr << last_error_message_;
}

void Errors::warning(ErrorCode code, const std::string& arg) {
    format_error_message(code, "warning", arg);
    std::cerr << last_error_message_;
}

const std::string& Errors::filename() const {
    return location_.filename();
}

int Errors::line_num() const {
    return location_.line_num();
}

void Errors::set_location(const Location& loc) {
    location_ = loc;
}

void Errors::set_source_line(const std::string& line) {
    source_line_ = line;
    expanded_line_.clear();
}

void Errors::set_expanded_line(const std::string& line) {
    expanded_line_ = line;
}

int Errors::error_count() const {
    return error_count_;
}

bool Errors::has_errors() const {
    return error_count_ > 0;
}

const std::string& Errors::last_error_message() const {
    return last_error_message_;
}

void Errors::format_error_message(ErrorCode code,
                                  const std::string& prefix, const std::string& arg) {
    std::ostringstream oss;

    if (!location_.empty()) {
        oss << location_.filename() << ":" << location_.line_num() << ": ";
    }

    std::string msg = error_messages[static_cast<int>(code)];
    oss << prefix << ": " << msg;

    if (!arg.empty()) {
        oss << ": " << arg;
    }

    oss << std::endl;

    if (!source_line_.empty()) {
        oss << "   |" << source_line_ << std::endl;
    }
    if (!expanded_line_.empty()) {
        oss << "   |" << expanded_line_ << std::endl;
    }

    last_error_message_ = oss.str();
}
