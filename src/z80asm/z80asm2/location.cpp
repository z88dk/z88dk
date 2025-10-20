//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"

Location::Location(const std::string& filename, int line_num)
    : filename_(filename), line_num_(line_num), inc_line_nums_(true) {
}

void Location::clear() {
    filename_.clear();
    line_num_ = 0;
    inc_line_nums_ = true;
}

bool Location::empty() const {
    return filename_.empty() && line_num_ == 0;
}

// Computes and sets the logical line number based on #line directive
void Location::set_logical_line_num(int line_directive_value,
                                    int line_directive_physical_line,
                                    int physical_line_num) {
    if (inc_line_nums_) {
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
    if (inc_line_nums_) {
        ++line_num_;
    }
}

void Location::set_inc_line_nums(bool enable) {
    inc_line_nums_ = enable;
}

