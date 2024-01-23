//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

void test_num_elems() {
    int arr[23];
    IS(NUM_ELEMS(arr), static_cast<size_t>(23));
}

void test_xassert() {
    RUN_NOK("exec_xassert");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "Test: Assertion failed: 0, file " __FILE__ ", line 24\n");
}

int exec_xassert() {
    xassert_init("Test");
    xassert(1);
    xassert(0);
    return EXIT_SUCCESS;
}

void test_is_alnum() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", c))
                OK(is_alnum(c));
            else
                NOK(is_alnum(c));
        }
    }
}

void test_is_alpha() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", c))
                OK(is_alpha(c));
            else
                NOK(is_alpha(c));
        }
    }
}

void test_is_lower() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefghijklmnopqrstuvwxyz", c))
                OK(is_lower(c));
            else
                NOK(is_lower(c));
        }
    }
}

void test_is_upper() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", c))
                OK(is_upper(c));
            else
                NOK(is_upper(c));
        }
    }
}

void test_is_digit() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("0123456789", c))
                OK(is_digit(c));
            else
                NOK(is_digit(c));
        }
    }
}

void test_is_xdigit() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefABCDEF0123456789", c))
                OK(is_xdigit(c));
            else
                NOK(is_xdigit(c));
        }
    }
}

void test_is_cntrl() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if ((c >= 1 && c <= 31) || c == 127)
                OK(is_cntrl(c));
            else
                NOK(is_cntrl(c));
        }
    }
}

void test_is_graph() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (c >= 33 && c <= 126)
                OK(is_graph(c));
            else
                NOK(is_graph(c));
        }
    }
}

void test_is_print() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (c >= 32 && c <= 126)
                OK(is_print(c));
            else
                NOK(is_print(c));
        }
    }
}

void test_is_punct() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", c))
                OK(is_punct(c));
            else
                NOK(is_punct(c));
        }
    }
}

void test_is_space() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr(" \t\f\v\r\n", c))
                OK(is_space(c));
            else
                NOK(is_space(c));
        }
    }
}

void test_is_blank() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr(" \t", c))
                OK(is_blank(c));
            else
                NOK(is_blank(c));
        }
    }
}

void test_is_eol() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("\r\n", c))
                OK(is_eol(c));
            else
                NOK(is_eol(c));
        }
    }
}

void test_is_ident_char_start() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_", c))
                OK(is_ident_start(c));
            else
                NOK(is_ident_start(c));
        }
    }
}

void test_is_ident_char() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$", c))
                OK(is_ident(c));
            else
                NOK(is_ident(c));
        }
    }
}

void test_to_lower() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", c))
                IS(static_cast<char>(c + ('a' - 'A')), to_lower(c));
            else
                IS(static_cast<char>(c), to_lower(c));
        }
    }
}

void test_to_upper() {
    for (int c = -128; c <= 255; c++) {
        if (c != 0) {
            DIAG(c);
            if (strchr("abcdefghijklmnopqrstuvwxyz", c))
                IS(static_cast<char>(c - ('a' - 'A')), to_upper(c));
            else
                IS(static_cast<char>(c), to_upper(c));
        }
    }
}

void test_is_ident() {
    for (int c1 = '$' - 1; c1 <= 'z' + 1; c1++) {
        for (int c2 = '$' - 1; c2 <= 'z' + 1; c2++) {
            string ident = string(1, c1) + string(1, c2);
            DIAG(ident);
            if (strchr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_", c1) &&
                strchr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$", c2))
                OK(is_ident(ident));
            else
                NOK(is_ident(ident));
        }
    }
}

void test_int_to_hex() {
    STR_IS(int_to_hex(-11, 2), "-$0b");
    STR_IS(int_to_hex(-10, 2), "-$0a");
    STR_IS(int_to_hex(-9, 2), "-9");
    STR_IS(int_to_hex(-1, 2), "-1");
    STR_IS(int_to_hex(0, 2), "0");
    STR_IS(int_to_hex(1, 2), "1");
    STR_IS(int_to_hex(9, 2), "9");
    STR_IS(int_to_hex(10, 2), "$0a");
    STR_IS(int_to_hex(11, 2), "$0b");
    STR_IS(int_to_hex(11, 4), "$000b");
    STR_IS(int_to_hex(0x123456, 4), "$123456");
}

void test_expand_env_vars() {
    OK(putenv(const_cast<char*>("TEST_ENV_VAR1=1")) == 0);
    OK(putenv(const_cast<char*>("TEST_ENV_VAR2=2")) == 0);

    STR_IS(expand_env_vars("aTEST_ENV_VAR1b"), "aTEST_ENV_VAR1b");
    STR_IS(expand_env_vars("a$TEST_ENV_VAR1b"), "a$TEST_ENV_VAR1b");
    STR_IS(expand_env_vars("a${TEST_ENV_VAR1b"), "a${TEST_ENV_VAR1b");
    STR_IS(expand_env_vars("a${TEST_ENV_VAR}1b"), "a1b");
    STR_IS(expand_env_vars("a${TEST_ENV_VAR1}b"), "a1b");
    STR_IS(expand_env_vars("a${TEST_ENV_VAR${TEST_ENV_VAR2}}b"), "a2b");

    OK(putenv(const_cast<char*>("TEST_ENV_VAR1=")) == 0);
    OK(putenv(const_cast<char*>("TEST_ENV_VAR2=")) == 0);
}

void test_unquote() {
    STR_IS(unquote("abc"), "abc");
    STR_IS(unquote("a'bc"), "a'bc");
    STR_IS(unquote("a'b'c"), "abc");
    STR_IS(unquote("'abc"), "'abc");
    STR_IS(unquote("'abc'"), "abc");
    STR_IS(unquote("'a\"bc'"), "a\"bc");
    STR_IS(unquote("'a\"b\"c'"), "abc");
}

void test_str_chomp() {
    STR_IS(str_chomp(""), "");
    STR_IS(str_chomp("\r\n \t\f \r\n \t\f\v"), "");
    STR_IS(str_chomp("\r\n \t\fx\r\n \t\f\v"), "\r\n \t\fx");
}

void test_str_strip() {
    STR_IS(str_strip(""), "");
    STR_IS(str_strip("\r\n \t\f \r\n \t\f\v"), "");
    STR_IS(str_strip("\r\n \t\fx\r\n \t\f\v"), "x");
}

void test_str_remove_all_blanks() {
    STR_IS(str_remove_all_blanks(""), "");
    STR_IS(str_remove_all_blanks("\r\n \t\f \r\n \t\f\v"), "");
    STR_IS(str_remove_all_blanks("\r\n a \t\f b \r\n c \t\f\v"), "abc");
}

void test_str_remove_extra_blanks() {
    STR_IS(str_remove_extra_blanks(""), "");
    STR_IS(str_remove_extra_blanks("\r\n \t\f \r\n \t\f\v"), "");
    STR_IS(str_remove_extra_blanks("\r\n \t\f x \r\n \t\f\v"), "x");
    STR_IS(str_remove_extra_blanks("a \r\n b \t\f c \r\n d \t\f\v e"), "a b c d e");
}

void test_str_replace_all() {
    STR_IS(str_replace_all("Hello", "l", "L"), "HeLLo");
    STR_IS(str_replace_all("aabbaa", "aa", "aabbaa"), "aabbaabbaabbaa");
}

void test_str_tolower() {
    STR_IS(str_tolower(""), "");
    STR_IS(str_tolower("Hello World!"), "hello world!");
}

void test_str_toupper() {
    STR_IS(str_toupper(""), "");
    STR_IS(str_toupper("Hello World!"), "HELLO WORLD!");
}

void test_str_ends_with() {
    OK(str_ends_with("f1.asm", ".asm"));
    NOK(str_ends_with("f1.asm", ".as"));
    OK(str_ends_with("f1.asm", "f1.asm"));
    NOK(str_ends_with(".asm", "f1.asm"));
}

void test_str_to_cstr() {
    STR_IS(str_to_cstr(""), "\"\"");
    STR_IS(str_to_cstr(
        "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"),
        "\"\\1\\2\\3\\4\\5\\6\\a\\b\\t\\n\\v\\f\\r\\x0e\\x0f\\x10\\x11\\x12\\x13\\x14\\x15\\x16\\x17\\x18\\x19\\x1a\\x1b\\x1c\\x1d\\x1e\\x1f !\\\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\\x7f\\x80\\x81\\x82\\x83\\x84\\x85\\x86\\x87\\x88\\x89\\x8a\\x8b\\x8c\\x8d\\x8e\\x8f\\x90\\x91\\x92\\x93\\x94\\x95\\x96\\x97\\x98\\x99\\x9a\\x9b\\x9c\\x9d\\x9e\\x9f\\xa0\\xa1\\xa2\\xa3\\xa4\\xa5\\xa6\\xa7\\xa8\\xa9\\xaa\\xab\\xac\\xad\\xae\\xaf\\xb0\\xb1\\xb2\\xb3\\xb4\\xb5\\xb6\\xb7\\xb8\\xb9\\xba\\xbb\\xbc\\xbd\\xbe\\xbf\\xc0\\xc1\\xc2\\xc3\\xc4\\xc5\\xc6\\xc7\\xc8\\xc9\\xca\\xcb\\xcc\\xcd\\xce\\xcf\\xd0\\xd1\\xd2\\xd3\\xd4\\xd5\\xd6\\xd7\\xd8\\xd9\\xda\\xdb\\xdc\\xdd\\xde\\xdf\\xe0\\xe1\\xe2\\xe3\\xe4\\xe5\\xe6\\xe7\\xe8\\xe9\\xea\\xeb\\xec\\xed\\xee\\xef\\xf0\\xf1\\xf2\\xf3\\xf4\\xf5\\xf6\\xf7\\xf8\\xf9\\xfa\\xfb\\xfc\\xfd\\xfe\\xff\"");
}

void test_split() {
    vector<string> out = split(" hello world 123 456 ");
    IS(out.size(), static_cast<size_t>(4));
    STR_IS(out[0], "hello");
    STR_IS(out[1], "world");
    STR_IS(out[2], "123");
    STR_IS(out[3], "456");
}

void test_is_little_endian() {
#ifdef _WIN32
    OK(is_little_endian());
#endif
}

void test_parse_le_int32() {
    byte_t mem1[] = "\x12\x34\x56\x78";
    IS(parse_le_int32(mem1), 0x78563412);

    byte_t mem2[] = "\xff\xff\xff\xff";
    IS(parse_le_int32(mem2), -1);
}

void test_write_le_int32() {
    byte_t mem[sizeof(int32_t)];
    write_le_int32(mem, 0x78563412);
    IS(memcmp(mem, "\x12\x34\x56\x78", sizeof(int32_t)), 0);

    write_le_int32(mem, -1);
    IS(memcmp(mem, "\xff\xff\xff\xff", sizeof(int32_t)), 0);
}

void test_safe_getline() {
    test_file_spew("f1.asm",
        "line 1\r"
        "line 2\n"
        "line 3\r\n"
        "line 4");
    {
        string line;
        ifstream ifs("f1.asm", ios::binary);

        line = "xxxxx";
        OK(!safe_getline(ifs, line).eof());
        STR_IS(line, "line 1");

        line = "xxxxx";
        OK(!safe_getline(ifs, line).eof());
        STR_IS(line, "line 2");

        line = "xxxxx";
        OK(!safe_getline(ifs, line).eof());
        STR_IS(line, "line 3");

        line = "xxxxx";
        OK(!safe_getline(ifs, line).eof());
        STR_IS(line, "line 4");

        line = "xxxxx";
        OK(safe_getline(ifs, line).eof());
        STR_IS(line, "");

    }
    OK(0 == remove("f1.asm"));
}

void test_expand_glob() {
    fs::create_directories("test/a/c");
    fs::create_directories("test/a/asm");
    fs::create_directories("test/b/c");
    fs::create_directories("test/b/asm");
    fs::create_directories("test/c/c");
    fs::create_directories("test/c/asm");
    test_file_spew("test/a/c/f1.c", "");
    test_file_spew("test/a/c/f2.c", "");
    test_file_spew("test/b/c/f1.c", "");
    test_file_spew("test/b/c/f2.c", "");
    test_file_spew("test/c/c/f1.c", "");
    test_file_spew("test/c/c/f2.c", "");
    test_file_spew("test/a/asm/f1.asm", "");
    test_file_spew("test/a/asm/f2.asm", "");
    test_file_spew("test/b/asm/f1.asm", "");
    test_file_spew("test/b/asm/f2.asm", "");
    test_file_spew("test/c/asm/f1.asm", "");
    test_file_spew("test/c/asm/f2.asm", "");

    vector<fs::path> result;

    expand_glob(result, "test/a/c/f.c");
    IS(result.size(), static_cast<size_t>(0));

    expand_glob(result, "test/a/c/f1.c");
    IS(result.size(), static_cast<size_t>(1));
    STR_IS(result[0].generic_string(), "test/a/c/f1.c");

    expand_glob(result, "test/a/c/*.c");
    IS(result.size(), static_cast<size_t>(2));
    STR_IS(result[0].generic_string(), "test/a/c/f1.c");
    STR_IS(result[1].generic_string(), "test/a/c/f2.c");

    expand_glob(result, "test/a/c/f?.c");
    IS(result.size(), static_cast<size_t>(2));
    STR_IS(result[0].generic_string(), "test/a/c/f1.c");
    STR_IS(result[1].generic_string(), "test/a/c/f2.c");

    expand_glob(result, "test/*/c/*.c");
    IS(result.size(), static_cast<size_t>(6));
    STR_IS(result[0].generic_string(), "test/a/c/f1.c");
    STR_IS(result[1].generic_string(), "test/a/c/f2.c");
    STR_IS(result[2].generic_string(), "test/b/c/f1.c");
    STR_IS(result[3].generic_string(), "test/b/c/f2.c");
    STR_IS(result[4].generic_string(), "test/c/c/f1.c");
    STR_IS(result[5].generic_string(), "test/c/c/f2.c");

    expand_glob(result, "test/**/*.asm");
    IS(result.size(), static_cast<size_t>(6));
    STR_IS(result[0].generic_string(), "test/a/asm/f1.asm");
    STR_IS(result[1].generic_string(), "test/a/asm/f2.asm");
    STR_IS(result[2].generic_string(), "test/b/asm/f1.asm");
    STR_IS(result[3].generic_string(), "test/b/asm/f2.asm");
    STR_IS(result[4].generic_string(), "test/c/asm/f1.asm");
    STR_IS(result[5].generic_string(), "test/c/asm/f2.asm");

    fs::remove_all("test");
}

void test_pool_str() {
    PoolStr s1;
    STR_IS(s1, "");
    OK(s1.empty());

    s1 = "hello";
    STR_IS(s1, "hello");
    NOK(s1.empty());

    s1.clear();
    STR_IS(s1, "");
    OK(s1.empty());

    PoolStr s2("hello");
    STR_IS(s2, "hello");
    NOK(s2.empty());

    s1 = s2;
    STR_IS(s1, "hello");
    NOK(s1.empty());

    PoolStr s3(s2);
    STR_IS(s3, "hello");
    NOK(s3.empty());

    s3 = "world";
    s1 = s3;
    STR_IS(s1, "world");
    NOK(s1.empty());

    OK(s1 == s3);
    NOK(s1 != s3);

    s1 = "hello ";
    s2 = s1 + "world";
    STR_IS(s2, "hello world");

    s1 = "hello ";
    s2 = "world";
    s3 = s1 + s2;
    STR_IS(s3, "hello world");
}

void test_string_table() {
    StringTable st;

    IS(st.count(), static_cast<size_t>(1));

    size_t id1 = st.add_string("");
    IS(id1, static_cast<size_t>(0));
    IS(st.add_string(""), id1);

    size_t id2 = st.add_string("hello");
    IS(st.count(), static_cast<size_t>(2));

    IS(st.add_string("hello"), id2);

    const string* s1 = &(st.lookup(id2));
    STR_IS(*s1, "hello");

    const string* s2 = &(st.lookup(id2));
    OK(s1 == s2);

    OK(st.find("hello"));
    NOK(st.find("world"));

    st.clear();
    IS(st.count(), static_cast<size_t>(1));
    STR_IS(st.lookup(0), "");
    IS(st.count(), static_cast<size_t>(1));
}
