//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "t/test.h"
using namespace std;

#define SETUP(errors)   Errors errors;  \
                        ostringstream oss;  \
                        errors.set_output(oss)

void test_error_message() {
    SETUP(errors);
    errors.error(ErrOk);
    IS(oss.str(), "error: ok\n");
}

void test_error_message_with_string_arg() {
    SETUP(errors);
    errors.error(ErrOk, "argument");
    IS(oss.str(), "error: ok: argument\n");
}

static void message_with_numeric_arg(int n, const string& s) {
    SETUP(errors);
    errors.error(ErrOk, n);
    IS(oss.str(), "error: ok: " + s + "\n");
}

void test_error_message_with_numeric_arg() {
    message_with_numeric_arg(0, "0");
    message_with_numeric_arg(1, "1");
    message_with_numeric_arg(9, "9");
    message_with_numeric_arg(10, "$0a");
    message_with_numeric_arg(15, "$0f");
    message_with_numeric_arg(255, "$ff");
    message_with_numeric_arg(256, "$0100");
    message_with_numeric_arg(65535, "$ffff");
    message_with_numeric_arg(65536, "$010000");
    message_with_numeric_arg(16777215, "$ffffff");
    message_with_numeric_arg(16777216, "$01000000");
    message_with_numeric_arg(2147483647, "$7fffffff");
    message_with_numeric_arg(-1, "-1");
    message_with_numeric_arg(-9, "-9");
    message_with_numeric_arg(-10, "-$0a");
    message_with_numeric_arg(-15, "-$0f");
    message_with_numeric_arg(-255, "-$ff");
    message_with_numeric_arg(-256, "-$0100");
    message_with_numeric_arg(-65535, "-$ffff");
    message_with_numeric_arg(-65536, "-$010000");
    message_with_numeric_arg(-16777215, "-$ffffff");
    message_with_numeric_arg(-16777216, "-$01000000");
    message_with_numeric_arg(-2147483647, "-$7fffffff");
}

void test_error_message_with_invalid_err_code() {
    RUN_NOK(exec_error_message_with_invalid_err_code1);
    OUT_IS("");
    ERR_IS("Assertion failed: err_code >= 0 && err_code < NUM_ELEMS(messages), "
        "file errors.cpp, line 46\n");

    RUN_NOK(exec_error_message_with_invalid_err_code2);
    OUT_IS("");
    ERR_IS("Assertion failed: err_code >= 0 && err_code < NUM_ELEMS(messages), "
        "file errors.cpp, line 46\n");
}

int exec_error_message_with_invalid_err_code1() {
    SETUP(errors);
    errors.error((ErrCode)-1);
    return EXIT_SUCCESS;
}

int exec_error_message_with_invalid_err_code2() {
    int count_messages = 0;
#define X(code, message)    count_messages++;
#include "errors.def"

    SETUP(errors);
    errors.error((ErrCode)count_messages);
    return EXIT_SUCCESS;
}

void test_count_of_errors() {
    SETUP(errors);
    IS(errors.count(), 0);
    errors.error(ErrOk);
    IS(errors.count(), 1);
}

void test_warning_message() {
    SETUP(errors);
    errors.warning(ErrOk);
    IS(oss.str(), "warning: ok\n");
}

void test_warning_message_with_string_arg() {
    SETUP(errors);
    errors.warning(ErrOk, "argument");
    IS(oss.str(), "warning: ok: argument\n");
}

void test_warning_message_with_numeric_arg() {
    SETUP(errors);
    errors.warning(ErrOk, 127);
    IS(oss.str(), "warning: ok: $7f\n");
}

void test_count_of_warnings() {
    SETUP(errors);
    IS(errors.count(), 0);
    errors.warning(ErrOk);
    IS(errors.count(), 0);
}

