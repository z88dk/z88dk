//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "t/test.h"
#include <iostream>
#include <fstream>
using namespace std;

void test_is_ident_start() {
    for (char c = 0; c < 127; c++) {
        if (c == '_' || 
            (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
            OK(is_ident_start(c));
        else
            NOK(is_ident_start(c));
    }
}

void test_is_ident_char() {
    for (char c = 0; c < 127; c++) {
        if (c == '_' || c == '$' || (c >= '0' && c <= '9') ||
            (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
            OK(is_ident(c));
        else
            NOK(is_ident(c));
    }
}

void test_is_ident_str() {
    NOK(is_ident(""));
    OK(is_ident("a"));
    OK(is_ident("z"));
    OK(is_ident("A"));
    OK(is_ident("Z"));
    OK(is_ident("_"));
    NOK(is_ident("0"));
    NOK(is_ident("9"));
    NOK(is_ident("$"));
    OK(is_ident("_abc$123"));
    OK(is_ident("abc_$123"));
    NOK(is_ident("123$abc"));
}

void test_char_digit() {
    for (char c = 0; c < 127; c++) {
        if (c >= '0' && c <= '9')
            IS(char_digit(c), c - '0');
        else if (c >= 'a' && c <= 'f')
            IS(char_digit(c), c + 10 - 'a');
        else if (c >= 'A' && c <= 'F')
            IS(char_digit(c), c + 10 - 'A');
        else
            IS(char_digit(c), -1);
    }
}

void test_str_begins_with() {
    OK(str_begins_with("", ""));
    OK(str_begins_with("abc", "a"));
    OK(str_begins_with("abc", "ab"));
    OK(str_begins_with("abc", "abc"));
    NOK(str_begins_with("abc", "a "));
}

void test_str_ends_with() {
    OK(str_ends_with("", ""));
    OK(str_ends_with("abc", "c"));
    OK(str_ends_with("abc", "bc"));
    OK(str_ends_with("abc", "abc"));
    NOK(str_ends_with("abc", "c "));
}

void test_str_tolower() {
    IS(str_tolower(""), "");
    IS(str_tolower("Abc123"), "abc123");
}

void test_str_toupper() {
    IS(str_toupper(""), "");
    IS(str_toupper("Abc123"), "ABC123");
}

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

void test_replace_all() {
    IS(str_replace_all("helo helo", "", "xx"), "helo helo");
    IS(str_replace_all("helo helo", "l", "ll"), "hello hello");
    IS(str_replace_all("", "l", "ll"), "");
}

void test_safe_getline() {
    test_spew("test.txt",
        "line1\r"
        "line2\n"
        "line3\r\n"
        "line4");
    ifstream ifs("test.txt", ios::binary);
    string text;

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line1");

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line2");

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line3");

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line4");

    text = "x";
    NOK(!safe_getline(ifs, text).eof());
    IS(text, "");

    text = "x";
    NOK(!safe_getline(ifs, text).eof());
    IS(text, "");

    ifs.close();
    remove("test.txt");
}

void test_ipow() {
    IS(ipow(10, -1), 0);
    IS(ipow(10, 0), 1);
    IS(ipow(10, 1), 10);
    IS(ipow(10, 2), 100);
    IS(ipow(10, 3), 1000);
}

void test_int_to_hex() {
    IS(int_to_hex(-256, 2), "-$100");
    IS(int_to_hex(-255, 2), "-$ff");
    IS(int_to_hex(-10, 2), "-$0a");
    IS(int_to_hex(-9, 2), "-9");
    IS(int_to_hex(-1, 2), "-1");
    IS(int_to_hex(0, 2), "0");
    IS(int_to_hex(1, 2), "1");
    IS(int_to_hex(9, 2), "9");
    IS(int_to_hex(10, 2), "$0a");
    IS(int_to_hex(255, 2), "$ff");
    IS(int_to_hex(256, 2), "$100");
}
