//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "location.h"
#include <iostream>
#include <string>
#include <vector>

#define X(code, msg) code,
enum class ErrorCode {
#include "error_codes.def"
    Count
};
#undef X

class ErrorReporter {
public:
    ErrorReporter();

    void error(ErrorCode code, const std::string& arg = "");
    void warning(ErrorCode code, const std::string& arg = "");
    void error(const Location& loc, ErrorCode code, const std::string& arg = "");
    void warning(const Location& loc, ErrorCode code, const std::string& arg = "");

    int error_count() const;
    bool has_error() const;

private:
    int error_count_ = 0;
    static const char* error_messages[static_cast<int>(ErrorCode::Count)];
    void print_message(const std::string& prefix, const std::string& message);
    void print_message(const Location& loc, const std::string& prefix,
                       const std::string& message);
    std::string format_message(ErrorCode code, const std::string& arg) const;

};
