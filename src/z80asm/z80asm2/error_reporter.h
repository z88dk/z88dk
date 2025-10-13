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

    const std::string& filename() const {
        return filename_;
    }
    int line_num() const {
        return line_num_;
    }
    const std::string& source_line() const {
        return source_line_;
    }
    const std::string& expanded_line() const {
        return expanded_line_;
    }

    void set_filename(const std::string& filename) {
        filename_ = filename;
    }
    void set_line_num(int line_num) {
        line_num_ = line_num;
    }
    void set_source_line(const std::string& line) {
        source_line_ = line;
        expanded_line_.clear();
    }
    void set_expanded_line(const std::string& line) {
        expanded_line_ = line;
    }

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
