//-----------------------------------------------------------------------------
// z80asm - output error messages
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
    ERR_IS("test_errors: Assertion failed: (size_t)err_code < NUM_ELEMS(messages), file errors.cpp, line 100\n");

    RUN_NOK(exec_error_message_with_invalid_err_code2);
    OUT_IS("");
    ERR_IS("test_errors: Assertion failed: (size_t)err_code < NUM_ELEMS(messages), file errors.cpp, line 100\n");
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

void test_error_at_location1() {
    SETUP(errors);
    errors.set_location(Location("f1.asm"));
    errors.error(ErrOk, "argument");
    IS(oss.str(), "f1.asm: error: ok: argument\n");
}

void test_error_at_location2() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.error(ErrOk);
    IS(oss.str(), "f1.asm:11: error: ok\n");
}

void test_error_at_location3() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.error(ErrOk, "argument");
    IS(oss.str(), "f1.asm:11: error: ok: argument\n");
}

void test_error_at_location4() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.error(ErrOk, 31);
    IS(oss.str(), "f1.asm:11: error: ok: $1f\n");
}

void test_error_at_location5() {
    SETUP(errors);
    errors.set_location(Location("f1.asm"));
    errors.warning(ErrOk, "argument");
    IS(oss.str(), "f1.asm: warning: ok: argument\n");
}

void test_error_at_location6() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.warning(ErrOk);
    IS(oss.str(), "f1.asm:11: warning: ok\n");
}

void test_error_at_location7() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.warning(ErrOk, "argument");
    IS(oss.str(), "f1.asm:11: warning: ok: argument\n");
}

void test_error_at_location8() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.warning(ErrOk, 31);
    IS(oss.str(), "f1.asm:11: warning: ok: $1f\n");
}

void test_error_at_location9() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.clear_location();
    errors.error(ErrOk, "argument");
    IS(oss.str(), "error: ok: argument\n");
}

void test_error_at_location10() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.clear_location();
    errors.warning(ErrOk, "argument");
    IS(oss.str(), "warning: ok: argument\n");
}

void test_error_with_source_text1() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.error(ErrOk);
    IS(oss.str(), "f1.asm:11: error: ok\n  ^---- ld a, b\n");
}

void test_error_with_source_text2() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.error(ErrOk, "argument");
    IS(oss.str(), "f1.asm:11: error: ok: argument\n  ^---- ld a, b\n");
}

void test_error_with_source_text3() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.error(ErrOk, 31);
    IS(oss.str(), "f1.asm:11: error: ok: $1f\n  ^---- ld a, b\n");
}

void test_error_with_source_text4() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.warning(ErrOk);
    IS(oss.str(), "f1.asm:11: warning: ok\n  ^---- ld a, b\n");
}

void test_error_with_source_text5() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.warning(ErrOk, "argument");
    IS(oss.str(), "f1.asm:11: warning: ok: argument\n  ^---- ld a, b\n");
}

void test_error_with_source_text6() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.warning(ErrOk, 31);
    IS(oss.str(), "f1.asm:11: warning: ok: $1f\n  ^---- ld a, b\n");
}

void test_error_with_source_text7() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\tb");
    errors.clear_location();
    errors.error(ErrOk, "argument");
    IS(oss.str(), "error: ok: argument\n");
}

void test_error_with_expanded_text1() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t$1f");
    errors.set_expanded_line("ld a,31");
    errors.error(ErrOk);
    IS(oss.str(), "f1.asm:11: error: ok\n  ^---- ld a, $1f\n    ^---- ld a,31\n");
}

void test_error_with_expanded_text2() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t31");
    errors.set_expanded_line("ld a,31");
    errors.error(ErrOk);
    IS(oss.str(), "f1.asm:11: error: ok\n  ^---- ld a, 31\n");
}

void test_error_with_expanded_text3() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t$1f");
    errors.set_expanded_line("ld a,31");
    errors.error(ErrOk, "argument");
    IS(oss.str(), "f1.asm:11: error: ok: argument\n  ^---- ld a, $1f\n    ^---- ld a,31\n");
}

void test_error_with_expanded_text4() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t$1f");
    errors.set_expanded_line("ld a,31");
    errors.error(ErrOk, 31);
    IS(oss.str(), "f1.asm:11: error: ok: $1f\n  ^---- ld a, $1f\n    ^---- ld a,31\n");
}

void test_error_with_expanded_text5() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t$1f");
    errors.set_expanded_line("ld a,31");
    errors.warning(ErrOk);
    IS(oss.str(), "f1.asm:11: warning: ok\n  ^---- ld a, $1f\n    ^---- ld a,31\n");
}

void test_error_with_expanded_text6() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t31");
    errors.set_expanded_line("ld a,31");
    errors.warning(ErrOk);
    IS(oss.str(), "f1.asm:11: warning: ok\n  ^---- ld a, 31\n");
}

void test_error_with_expanded_text7() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t$1f");
    errors.set_expanded_line("ld a,31");
    errors.warning(ErrOk, "argument");
    IS(oss.str(), "f1.asm:11: warning: ok: argument\n  ^---- ld a, $1f\n    ^---- ld a,31\n");
}

void test_error_with_expanded_text8() {
    SETUP(errors);
    errors.set_location(Location("f1.asm", 11));
    errors.set_source_line("\tld\ta,\t$1f");
    errors.set_expanded_line("ld a,31");
    errors.warning(ErrOk, 31);
    IS(oss.str(), "f1.asm:11: warning: ok: $1f\n  ^---- ld a, $1f\n    ^---- ld a,31\n");
}
