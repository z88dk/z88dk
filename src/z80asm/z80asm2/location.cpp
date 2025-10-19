//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"

Location::Location(const std::string& filename, int line_num)
    : filename_(filename), line_num_(line_num), increment_line_numbers_(true) {
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
    if (increment_line_numbers_) {
        // #line N means the *next* physical line is N
        int logical = line_directive_value +
                      (physical_line_num - line_directive_physical_line) - 1;
        line_num_ = logical;
    }
}

// Sets the line number to the physical line number
void Location::set_physical_line_num(int physical_line_num) {
    line_num_ = physical_line_num;
}

// Increments the logical line number (only when enabled)
void Location::inc_line_num() {
    if (increment_line_numbers_) {
        ++line_num_;
    }
}

void Location::set_increment_line_numbers(bool enable) {
    increment_line_numbers_ = enable;
}

bool Location::increment_line_numbers() const {
    return increment_line_numbers_;
}

