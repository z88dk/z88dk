//-----------------------------------------------------------------------------
// string table - map strings to integers
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "strtable.h"
#include "die.h"
#include <stdio.h>

#define TEST_FILE "t_strtable.bin"

static strtable_t* make_table(void) {
    strtable_t* st = strtable_new();
    TEST_ASSERT_TRUE(st);
    TEST_ASSERT_EQUAL(1, strtable_size(st));

    TEST_ASSERT_EQUAL(0, strtable_add_string(st, ""));
    TEST_ASSERT_EQUAL(1, strtable_add_string(st, "one"));
    TEST_ASSERT_EQUAL(2, strtable_add_string(st, "two"));
    TEST_ASSERT_EQUAL(3, strtable_add_string(st, "three"));
    TEST_ASSERT_EQUAL(4, strtable_size(st));

    return st;
}

void t_strtable_memory(void) {
    strtable_t* st = make_table();

    TEST_ASSERT_EQUAL(0, strtable_add_string(st, ""));
    TEST_ASSERT_EQUAL(1, strtable_add_string(st, "one"));
    TEST_ASSERT_EQUAL(2, strtable_add_string(st, "two"));
    TEST_ASSERT_EQUAL(3, strtable_add_string(st, "three"));
    TEST_ASSERT_EQUAL(4, strtable_size(st));

    TEST_ASSERT_EQUAL_STRING("", strtable_lookup(st, 0));
    TEST_ASSERT_EQUAL_STRING("one", strtable_lookup(st, 1));
    TEST_ASSERT_EQUAL_STRING("two", strtable_lookup(st, 2));
    TEST_ASSERT_EQUAL_STRING("three", strtable_lookup(st, 3));
    TEST_ASSERT_EQUAL_STRING("", strtable_lookup(st, 4));
    TEST_ASSERT_EQUAL_STRING("", strtable_lookup(st, 1234));

    TEST_ASSERT_TRUE(strtable_find(st, ""));
    TEST_ASSERT_TRUE(strtable_find(st, "one"));
    TEST_ASSERT_TRUE(strtable_find(st, "two"));
    TEST_ASSERT_TRUE(strtable_find(st, "three"));

    TEST_ASSERT_FALSE(strtable_find(st, "THREE"));

    strtable_clear(st);
    TEST_ASSERT_EQUAL(1, strtable_size(st));

    TEST_ASSERT_TRUE(strtable_find(st, ""));
    TEST_ASSERT_FALSE(strtable_find(st, "one"));
    TEST_ASSERT_FALSE(strtable_find(st, "two"));
    TEST_ASSERT_FALSE(strtable_find(st, "three"));

    strtable_free(st);
    TEST_ASSERT_FALSE(st);
}

void t_strtable_file_write(void) {
    strtable_t* st = make_table();

    FILE* fp = fopen(TEST_FILE, "wb");
    TEST_ASSERT_TRUE(fp);
    strtable_fwrite(st, fp);
    fclose(fp);

    byte_t buffer[BUFSIZ];
    fp = fopen(TEST_FILE, "rb");
    TEST_ASSERT_TRUE(fp);
    size_t size = fread(buffer, 1, sizeof(buffer), fp);
    TEST_ASSERT_EQUAL(40, size);
    fclose(fp);

    xremove(TEST_FILE);

    // num_strings
    TEST_ASSERT_EQUAL(4, buffer[0]);
    TEST_ASSERT_EQUAL(0, buffer[1]);
    TEST_ASSERT_EQUAL(0, buffer[2]);
    TEST_ASSERT_EQUAL(0, buffer[3]);

    // length of strings
    TEST_ASSERT_EQUAL(16, buffer[4]);
    TEST_ASSERT_EQUAL(0, buffer[5]);
    TEST_ASSERT_EQUAL(0, buffer[6]);
    TEST_ASSERT_EQUAL(0, buffer[7]);

    // pointer to string 0
    TEST_ASSERT_EQUAL(0, buffer[8]);
    TEST_ASSERT_EQUAL(0, buffer[9]);
    TEST_ASSERT_EQUAL(0, buffer[10]);
    TEST_ASSERT_EQUAL(0, buffer[11]);

    // pointer to string 1
    TEST_ASSERT_EQUAL(1, buffer[12]);
    TEST_ASSERT_EQUAL(0, buffer[13]);
    TEST_ASSERT_EQUAL(0, buffer[14]);
    TEST_ASSERT_EQUAL(0, buffer[15]);

    // pointer to string 2
    TEST_ASSERT_EQUAL(5, buffer[16]);
    TEST_ASSERT_EQUAL(0, buffer[17]);
    TEST_ASSERT_EQUAL(0, buffer[18]);
    TEST_ASSERT_EQUAL(0, buffer[19]);

    // pointer to string 3
    TEST_ASSERT_EQUAL(9, buffer[20]);
    TEST_ASSERT_EQUAL(0, buffer[21]);
    TEST_ASSERT_EQUAL(0, buffer[22]);
    TEST_ASSERT_EQUAL(0, buffer[23]);

    // string 0
    TEST_ASSERT_EQUAL(0, buffer[24]);

    // string 1
    TEST_ASSERT_EQUAL('o', buffer[25]);
    TEST_ASSERT_EQUAL('n', buffer[26]);
    TEST_ASSERT_EQUAL('e', buffer[27]);
    TEST_ASSERT_EQUAL(0, buffer[28]);

    // string 2
    TEST_ASSERT_EQUAL('t', buffer[29]);
    TEST_ASSERT_EQUAL('w', buffer[30]);
    TEST_ASSERT_EQUAL('o', buffer[31]);
    TEST_ASSERT_EQUAL(0, buffer[32]);

    // string 3
    TEST_ASSERT_EQUAL('t', buffer[33]);
    TEST_ASSERT_EQUAL('h', buffer[34]);
    TEST_ASSERT_EQUAL('r', buffer[35]);
    TEST_ASSERT_EQUAL('e', buffer[36]);
    TEST_ASSERT_EQUAL('e', buffer[37]);
    TEST_ASSERT_EQUAL(0, buffer[38]);

    // align
    TEST_ASSERT_EQUAL(0, buffer[39]);

    strtable_free(st);
    TEST_ASSERT_FALSE(st);
}

void t_strtable_file_read(void) {
    FILE* fp = fopen(TEST_FILE, "wb");
    TEST_ASSERT_TRUE(fp);
    TEST_ASSERT_EQUAL(40, fwrite(
        "\x04\0\0\0" "\x10\0\0\0"
        "\0\0\0\0"
        "\x01\0\0\0"
        "\x05\0\0\0"
        "\x09\0\0\0"
        "\0"
        "one\0"
        "two\0"
        "three\0"
        "\0", 1, 40, fp));
    fclose(fp);

    fp = fopen(TEST_FILE, "rb");
    TEST_ASSERT_TRUE(fp);
    strtable_t* st = strtable_fread(fp);
    fclose(fp);

    xremove(TEST_FILE);

    TEST_ASSERT_EQUAL(4, strtable_size(st));
    TEST_ASSERT_EQUAL_STRING("", strtable_lookup(st, 0));
    TEST_ASSERT_EQUAL_STRING("one", strtable_lookup(st, 1));
    TEST_ASSERT_EQUAL_STRING("two", strtable_lookup(st, 2));
    TEST_ASSERT_EQUAL_STRING("three", strtable_lookup(st, 3));

    strtable_free(st);
    TEST_ASSERT_FALSE(st);
}

void t_strtable_file_parse(void) {
    FILE* fp = fopen(TEST_FILE, "wb");
    TEST_ASSERT_TRUE(fp);
    TEST_ASSERT_EQUAL(40, fwrite(
        "\x04\0\0\0" "\x10\0\0\0"
        "\0\0\0\0"
        "\x01\0\0\0"
        "\x05\0\0\0"
        "\x09\0\0\0"
        "\0"
        "one\0"
        "two\0"
        "three\0"
        "\0", 1, 40, fp));
    fclose(fp);

    byte_t buffer[BUFSIZ];
    fp = fopen(TEST_FILE, "rb");
    TEST_ASSERT_TRUE(fp);
    size_t size = fread(buffer, 1, sizeof(buffer), fp);
    TEST_ASSERT_EQUAL(40, size);
    fclose(fp);

    xremove(TEST_FILE);

    strtable_t* st = strtable_parse(buffer);

    TEST_ASSERT_EQUAL(4, strtable_size(st));
    TEST_ASSERT_EQUAL_STRING("", strtable_lookup(st, 0));
    TEST_ASSERT_EQUAL_STRING("one", strtable_lookup(st, 1));
    TEST_ASSERT_EQUAL_STRING("two", strtable_lookup(st, 2));
    TEST_ASSERT_EQUAL_STRING("three", strtable_lookup(st, 3));

    strtable_free(st);
    TEST_ASSERT_FALSE(st);
}
