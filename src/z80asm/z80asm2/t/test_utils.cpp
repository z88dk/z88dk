//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "t/test.h"
using namespace std;

void test_str_chomp() {
    IS(str_chomp(""), "");
    IS(str_chomp(" \t\f\r\n\v"), "");
    IS(str_chomp(" x\t\f\r\n\v"), " x");
}

void test_str_strip() {
    IS(str_strip(""), "");
    IS(str_strip(" \t\f\r\n\v"), "");
    IS(str_strip(" \t\f\r\n\vx\t\f\r\n\v"), "x");
}

void test_remove_extra_blanks() {
    IS(str_remove_extra_blanks(""), "");
    IS(str_remove_extra_blanks("x"), "x");
    IS(str_remove_extra_blanks("\t\f\r\n\vx\t\f\r\n\vy\t\f\r\n\v"), "x y");
}

void test_remove_all_blanks() {
    IS(str_remove_all_blanks(""), "");
    IS(str_remove_all_blanks("x"), "x");
    IS(str_remove_all_blanks("\t\f\r\n\vx\t\f\r\n\vy\t\f\r\n\v"), "xy");
}
