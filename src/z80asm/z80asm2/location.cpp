//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"

Location::Location(const std::string& filename, int line_num)
    : filename_(filename), line_num_(line_num) {
}

void Location::clear() {
    filename_.clear();
    line_num_ = 0;
}

bool Location::empty() const {
    return filename_.empty() && line_num_ == 0;
}

const std::string& Location::filename() const {
    return filename_;
}

int Location::line_num() const {
    return line_num_;
}

void Location::set_filename(const std::string& filename) {
    filename_ = filename;
}

void Location::set_line_num(int line_num) {
    line_num_ = line_num;
}

void Location::inc_line_num() {
    line_num_++;
}
