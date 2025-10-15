//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error_reporter.h"

#define X(code, msg) msg,
const char* ErrorReporter::error_messages[] = {
#include "error_codes.def"
};
#undef X

Location::Location(const std::string& filename, int line_num)
    : filename_(filename), line_num_(line_num) {
}

const std::string& Location::filename() const {
    return filename_;
}

int Location::line_num() const {
    return line_num_;
}

const std::string& Location::source_line() const {
    return source_line_;
}

const std::string& Location::expanded_line() const {
    return expanded_line_;
}

void Location::set_filename(const std::string& filename) {
    filename_ = filename;
}

void Location::set_line_num(int line_num) {
    line_num_ = line_num;
}

void Location::set_source_line(const std::string& line) {
    source_line_ = line;
    expanded_line_.clear();
}

void Location::set_expanded_line(const std::string& line) {
    expanded_line_ = line;
}

// Computes and sets the logical line number based on #line directive
void Location::set_logical_line_num(int line_directive_value,
                                    int line_directive_physical_line,
                                    int physical_line_num) {
    // #line N means the *next* physical line is N
    int logical = line_directive_value +
                  (physical_line_num - line_directive_physical_line) - 1;
    line_num_ = logical;
}

// Sets the line number to the physical line number
void Location::set_physical_line_num(int physical_line_num) {
    line_num_ = physical_line_num;
}

// Increments the logical line number
void Location::inc_line_num() {
    ++line_num_;
}

ErrorReporter::ErrorReporter() = default;

void ErrorReporter::error(ErrorCode code, const std::string& arg) {
    ++error_count_;
    print_message("error", format_message(code, arg));
}

void ErrorReporter::warning(ErrorCode code, const std::string& arg) {
    print_message("warning", format_message(code, arg));
}

void ErrorReporter::error(const Location& loc, ErrorCode code,
                          const std::string& arg) {
    ++error_count_;
    print_message(loc, "error", format_message(code, arg));
}

void ErrorReporter::warning(const Location& loc, ErrorCode code,
                            const std::string& arg) {
    print_message(loc, "warning", format_message(code, arg));
}

int ErrorReporter::error_count() const {
    return error_count_;
}

bool ErrorReporter::has_error() const {
    return error_count_ > 0;
}

void ErrorReporter::print_message(const std::string& prefix,
                                  const std::string& message) {
    std::cerr << prefix << ": " << message << std::endl;
}

void ErrorReporter::print_message(const Location& loc,
                                  const std::string& prefix,
                                  const std::string& message) {
    std::cerr << loc.filename() << ":" << loc.line_num() << ": "
              << prefix << ": " << message << std::endl;
    if (!loc.source_line().empty()) {
        std::cerr << "   |" << loc.source_line() << std::endl;
    }
    if (!loc.expanded_line().empty()) {
        std::cerr << "   |" << loc.expanded_line() << std::endl;
    }
}

std::string ErrorReporter::format_message(ErrorCode code,
        const std::string& arg) const {
    std::string msg = error_messages[static_cast<int>(code)];
    if (!arg.empty()) {
        msg += ": " + arg;
    }
    return msg;
}
