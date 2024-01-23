//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

void test_location() {
    Location loc1;
    STR_IS(loc1.filename, "");
    IS(loc1.line_num, 0);
    OK(loc1.empty());

    Location loc2("f1.asm");
    STR_IS(loc2.filename, "f1.asm");
    IS(loc2.line_num, 0);
    NOK(loc2.empty());

    Location loc3("f1.asm", 11);
    STR_IS(loc3.filename, "f1.asm");
    IS(loc3.line_num, 11);
    NOK(loc3.empty());

    loc3.inc_line_num();
    STR_IS(loc3.filename, "f1.asm");
    IS(loc3.line_num, 12);
    NOK(loc3.empty());

    loc3.line_inc = 0;
    loc3.inc_line_num();
    STR_IS(loc3.filename, "f1.asm");
    IS(loc3.line_num, 12);
    NOK(loc3.empty());

    loc3.line_num = 15;
    loc3.line_inc = 1;
    STR_IS(loc3.filename, "f1.asm");
    IS(loc3.line_num, 15);
    NOK(loc3.empty());

    loc3.filename = "f2.asm";
    STR_IS(loc3.filename, "f2.asm");
    IS(loc3.line_num, 15);
    NOK(loc3.empty());

    loc3.clear();
    STR_IS(loc3.filename, "");
    IS(loc3.line_num, 0);
    OK(loc3.empty());
}

void test_error() {
    RUN_OK("exec_error", "");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU\n");

    RUN_OK("exec_error", "42");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 42\n");

    RUN_OK("exec_warning", "");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "warning: integer range\n");

    RUN_OK("exec_warning", "42");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "warning: integer range: 42\n");
}

int exec_error(const string& arg) {
    Errors errors;
    xassert_init("Test");
    xassert(errors.count == 0);
    if (arg.empty())
        errors.error(Errors::Code::illegal_cpu);
    else
        errors.error(Errors::Code::illegal_cpu, arg);
    xassert(errors.count == 1);
    return EXIT_SUCCESS;
}

int exec_warning(const string& arg) {
    Errors errors;
    xassert_init("Test");
    xassert(errors.count == 0);
    if (arg.empty())
        errors.warning(Errors::Code::integer_range);
    else
        errors.warning(Errors::Code::integer_range, arg);
    xassert(errors.count == 0);
    return EXIT_SUCCESS;
}
