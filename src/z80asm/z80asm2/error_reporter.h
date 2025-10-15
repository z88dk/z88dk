//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <string>
#include <vector>

#define X(code, msg) code,
enum class ErrorCode {
#include "error_codes.def"
    Count
};
#undef X

class Location {
public:
    Location(const std::string& filename = "", int line_num = 0);

    const std::string& filename() const;
    int line_num() const;
    const std::string& source_line() const;
    const std::string& expanded_line() const;

    void set_filename(const std::string& filename);
    void set_line_num(int line_num);
    void set_source_line(const std::string& line);
    void set_expanded_line(const std::string& line);

    // Computes and sets the logical line number based on #line directive
    void set_logical_line_num(int line_directive_value,
                              int line_directive_physical_line,
                              int physical_line_num);

    // Sets the line number to the physical line number
    void set_physical_line_num(int physical_line_num);

    // Increments the logical line number
    void inc_line_num();

private:
    std::string filename_;
    int line_num_{ 0 };
    std::string source_line_;
    std::string expanded_line_;
};


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
