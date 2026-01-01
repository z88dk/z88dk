//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
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
    warning_count_ = 0;
    clear();
}

void Errors::clear() {
    quiet_ = false;
    location_.clear();
    source_line_.clear();
    expanded_line_.clear();
    last_error_message_.clear();
}

void Errors::set_quiet(bool f) {
    quiet_ = f;
}

void Errors::error(ErrorCode code, const std::string& arg) {
    ++error_count_;
    format_error_message(code, "error", arg);
    if (!quiet_) {
        std::cerr << last_error_message_;
    }
}

void Errors::warning(ErrorCode code, const std::string& arg) {
    ++warning_count_;
    format_error_message(code, "warning", arg);
    if (!quiet_) {
        std::cerr << last_error_message_;
    }
}

void Errors::error(const Location& loc, ErrorCode code,
                   const std::string& arg) {
    ++error_count_;
    format_error_message(loc, code, "error", arg);
    if (!quiet_) {
        std::cerr << last_error_message_;
    }
}

void Errors::warning(const Location& loc, ErrorCode code,
                     const std::string& arg) {
    ++warning_count_;
    format_error_message(loc, code, "warning", arg);
    if (!quiet_) {
        std::cerr << last_error_message_;
    }
}

const Location& Errors::location() const {
    return location_;
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

bool Errors::has_warnings() const {
    return warning_count_ > 0;
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
    if (!expanded_line_.empty() && expanded_line_ != source_line_) {
        oss << "   |" << expanded_line_ << std::endl;
    }

    last_error_message_ = oss.str();
}

void Errors::format_error_message(const Location& loc,
                                  ErrorCode code,
                                  const std::string& prefix,
                                  const std::string& arg) {
    std::ostringstream oss;

    if (!loc.empty()) {
        oss << loc.filename() << ":" << loc.line_num() << ": ";
    }

    std::string msg = error_messages[static_cast<int>(code)];
    oss << prefix << ": " << msg;

    if (!arg.empty()) {
        oss << ": " << arg;
    }

    oss << std::endl;

    // Note: No source_line_ or expanded_line_ output for explicit location errors
    // since the context may not be available for expressions evaluated later

    last_error_message_ = oss.str();
}
