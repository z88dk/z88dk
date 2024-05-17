//-----------------------------------------------------------------------------
// z80asm - store location in source file
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "location.h"
#include <iostream>
#include <sstream>
using namespace std;

//-----------------------------------------------------------------------------

Location::Location(const string& filename, int line_num, bool is_c_file)
    : filename_(filename), line_num_(line_num), is_c_file_(is_c_file) {
}

void Location::clear() {
    filename_.clear();
    line_num_ = 0;
    is_c_file_ = false;
}

bool Location::empty() const {
    return filename_.empty() && line_num_ == 0;
}

const string& Location::filename() const {
    return filename_;
}

int Location::line_num() const {
    return line_num_;
}

bool Location::is_c_file() const {
    return is_c_file_;
}

void Location::set_filename(const string& filename) {
    filename_ = filename;
    line_num_ = 0;
    is_c_file_ = false;
}

void Location::set_line(const string& filename, int line_num) {
    filename_ = filename;
    line_num_ = line_num;
    is_c_file_ = false;
}

void Location::set_line(int line_num) {
    line_num_ = line_num;
    is_c_file_ = false;
}

void Location::set_c_line(const string& filename, int line_num) {
    filename_ = filename;
    line_num_ = line_num;
    is_c_file_ = true;
}

void Location::set_c_line(int line_num) {
    line_num_ = line_num;
    is_c_file_ = true;
}

void Location::inc_line_num(int increment) {
    if (!is_c_file_)
        line_num_ += increment;
}

string Location::to_string() const {
    ostringstream oss;
    if (!filename_.empty()) {
        oss << filename_;
        if (line_num_ > 0)
            oss << ":" << line_num_;
    }
    return oss.str();
}

string to_string(const Location& location) {
    return location.to_string();
}

//-----------------------------------------------------------------------------

HasLocation::HasLocation()
    : location_(g_errors().location()) {
}

const Location& HasLocation::location() const {
    return location_;
}

void HasLocation::set_location(const Location& location) {
    location_ = location;
}

void HasLocation::clear() {
    location_.clear();
}
