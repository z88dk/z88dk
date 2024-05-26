//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "t/test.h"
#include <iostream>
#include <fstream>
#include <sstream>
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

void test_swrite_int16() {
    ostringstream oss;
    swrite_int16(0x1234, oss);
    IS(oss.str().size(), 2);
    IS(oss.str()[0], 0x34);
    IS(oss.str()[1], 0x12);
}

void test_swrite_int32() {
    ostringstream oss;
    swrite_int32(0x12345678, oss);
    IS(oss.str().size(), 4);
    IS(oss.str()[0], 0x78);
    IS(oss.str()[1], 0x56);
    IS(oss.str()[2], 0x34);
    IS(oss.str()[3], 0x12);
}

void test_swrite_string() {
    ostringstream oss1;
    swrite_string("", oss1);
    IS(oss1.str().size(), 2);
    IS(oss1.str()[0], 0);
    IS(oss1.str()[1], 0);

    ostringstream oss2;
    swrite_string("hello", oss2);
    IS(oss2.str().size(), 7);
    IS(oss2.str()[0], 5);
    IS(oss2.str()[1], 0);
    IS(oss2.str()[2], 'h');
    IS(oss2.str()[3], 'e');
    IS(oss2.str()[4], 'l');
    IS(oss2.str()[5], 'l');
    IS(oss2.str()[6], 'o');
}

void test_sread_int16() {
    istringstream iss1("\x34\x12");
    IS(sread_int16(iss1), 0x1234);

    istringstream iss2("\xff\xff");
    IS(sread_int16(iss2), -1);
}

void test_sread_int32() {
    istringstream iss1("\x78\x56\x34\x12");
    IS(sread_int32(iss1), 0x12345678);

    istringstream iss2("\xff\xff\xff\xff");
    IS(sread_int32(iss2), -1);
}

void test_sread_string() {
    char bytes1[] = { 0, 0 };
    istringstream iss1(string(std::begin(bytes1), std::end(bytes1)));
    IS(sread_string(iss1), "");

    char bytes2[] = { 5, 0, 'h', 'e', 'l', 'l', 'o' };
    istringstream iss2(string(std::begin(bytes2), std::end(bytes2)));
    IS(sread_string(iss2), "hello");
}

void test_string_table() {
    StringTable st;

    IS(st.count(), 1);
    IS(st.lookup(0), "");
    NOK(st.find("hello"));

    IS(st.add_string("hello"), 1);
    IS(st.count(), 2);
    IS(st.lookup(0), "");
    IS(st.lookup(1), "hello");
    OK(st.find("hello"));

    // write string table
    ofstream os("test~.bin", ios::binary);
    OK(os.is_open());
    IS(st.write(os), 0);
    os.close();

    // read it back
    ifstream is("test~.bin", ios::binary);
    OK(is.is_open());
    IS(sread_int32(is), 2);     // size of table
    IS(sread_int32(is), 8);     // size of strings, aligned
    IS(sread_int32(is), 0);     // index of ""
    IS(sread_int32(is), 1);     // index of "hello"
    char buffer[16];
    is.read(buffer, sizeof(buffer));
    IS(is.gcount(), 8);
    IS(buffer[0], 0);           // "" terminator
    IS(buffer[1], 'h');
    IS(buffer[2], 'e');
    IS(buffer[3], 'l');
    IS(buffer[4], 'l');
    IS(buffer[5], 'o');
    IS(buffer[6], 0);           // "hello" terminator
    IS(buffer[7], 0);           // filler
    OK(is.eof());

    // read st from file
    st.clear();
    IS(st.count(), 1);
    IS(st.lookup(0), "");

    st.read(is, 0);             // read from pos 0
    NOK(is.eof());
    is.close();

    IS(st.count(), 2);
    IS(st.lookup(0), "");
    IS(st.lookup(1), "hello");
    OK(st.find("hello"));

    remove("test~.bin");
}
