//-----------------------------------------------------------------------------
// z80asm - store location in source file
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"
#include "t/test.h"
using namespace std;

void test_empty_location() {
    Location location;
    OK(location.empty());
    IS(location.filename(), "");
    IS(location.line_num(), 0);
    NOK(location.is_c_file());
}

void test_location_with_filename() {
    Location location("f1.asm");
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 0);
    NOK(location.is_c_file());
}

void test_location_with_filename_line_num() {
    Location location("f1.asm", 11);
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 11);
    NOK(location.is_c_file());
}

void test_location_with_filename_line_num_c_file() {
    Location location("f1.asm", 11, true);
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 11);
    OK(location.is_c_file());
}

void test_clear() {
    Location location("f1.asm", 11);
    NOK(location.empty());
    location.clear();
    OK(location.empty());
    IS(location.filename(), "");
    IS(location.line_num(), 0);
    NOK(location.is_c_file());
}

void test_set_filename() {
    Location location("f2.asm", 11, true);
    location.set_filename("f1.asm");
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 0);
    NOK(location.is_c_file());
}

void test_set_line() {
    Location location("f1.asm", 11, true);
    location.set_line(22);
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 22);
    NOK(location.is_c_file());
}

void test_set_line_filename() {
    Location location("f2.asm", 11, true);
    location.set_line("f1.asm", 22);
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 22);
    NOK(location.is_c_file());
}

void test_set_c_line() {
    Location location("f1.asm", 11, false);
    location.set_c_line(22);
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 22);
    OK(location.is_c_file());
}

void test_set_c_line_filename() {
    Location location("f2.asm", 11, false);
    location.set_c_line("f1.asm", 22);
    NOK(location.empty());
    IS(location.filename(), "f1.asm");
    IS(location.line_num(), 22);
    OK(location.is_c_file());
}

void test_inc_line_num() {
    Location location("f1.asm", 11, false);
    IS(location.line_num(), 11);
    location.inc_line_num();
    IS(location.line_num(), 12);
    location.inc_line_num(-1);
    IS(location.line_num(), 11);
}

void test_inc_c_line_num() {
    Location location("f1.asm", 11, true);
    IS(location.line_num(), 11);
    location.inc_line_num();
    IS(location.line_num(), 11);
    location.inc_line_num(-1);
    IS(location.line_num(), 11);
}

void test_to_string_empty() {
    Location location;
    IS(location.to_string(), "");
    IS(to_string(location), "");
}

void test_to_string_filename() {
    Location location("f1.asm");
    IS(location.to_string(), "f1.asm");
    IS(to_string(location), "f1.asm");
}

void test_to_string_filename_line_num() {
    Location location("f1.asm", 11);
    IS(location.to_string(), "f1.asm:11");
    IS(to_string(location), "f1.asm:11");
}
