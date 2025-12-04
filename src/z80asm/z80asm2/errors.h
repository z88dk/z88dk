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
#include "errors.def"
};
#undef X

class Errors {
public:
    Errors();
    void reset();
    void clear(); // does not reset error count

    void error(ErrorCode code, const std::string& arg = "");
    void warning(ErrorCode code, const std::string& arg = "");

    // Overloads that accept explicit location (for expression errors)
    void error(const Location& loc, ErrorCode code, const std::string& arg = "");
    void warning(const Location& loc, ErrorCode code, const std::string& arg = "");

    const Location& location() const;
    void set_location(const Location& loc);
    void set_source_line(const std::string& line);
    void set_expanded_line(const std::string& line);

    int error_count() const;
    bool has_errors() const;
    bool has_warnings() const;
    const std::string& last_error_message() const;

private:
    int error_count_ = 0;
    int warning_count_ = 0;
    Location location_;
    std::string source_line_;
    std::string expanded_line_;
    std::string last_error_message_;

    // set last_error_message_
    void format_error_message(ErrorCode code,
                              const std::string& prefix,
                              const std::string& arg);
    
    // Format error message with explicit location
    void format_error_message(const Location& loc,
                              ErrorCode code,
                              const std::string& prefix,
                              const std::string& arg);
};

// global error reporter instance
extern Errors g_errors;
