//-----------------------------------------------------------------------------
// string table - map strings to integers
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define STRTABLE_SOURCE

#include "fileutil.h"
#include "strtable.h"
#include "utarray.h"
#include "uthash.h"
#include "xassert.h"
#include "xmalloc.h"
#include <stdlib.h>

//-----------------------------------------------------------------------------
// types
//-----------------------------------------------------------------------------
typedef struct {
    char* str;                      // actual string in alloc space
    uint_t id;                      // index into string table
    UT_hash_handle hh;
} strtable_item_t;

typedef struct {
    UT_array* strs_list;            // each item is a weak pointer to a strtable_item_t
    strtable_item_t* strs_hash;     // holds the strings
} strtable_t;

//-----------------------------------------------------------------------------
// methods
//-----------------------------------------------------------------------------

static void strtable_clear_all(void* st_) {
    strtable_t* st = st_;
    strtable_item_t* elem, * tmp;
    HASH_ITER(hh, st->strs_hash, elem, tmp) {
        HASH_DEL(st->strs_hash, elem);
        xfree(elem->str);
        xfree(elem);
    }
    utarray_clear(st->strs_list);
}

void strtable_clear(void* st_) {
    strtable_t* st = st_;
    strtable_clear_all(st);
    strtable_add_string(st, "");          // empty string is id 0
}

void* strtable_new(void) {
    strtable_t* st = xnew(strtable_t);
    utarray_new(st->strs_list, &ut_ptr_icd);
    strtable_clear(st);
    return st;
}

void strtable_free_(void* st_) {
    strtable_t* st = st_;
    strtable_clear_all(st);
    utarray_free(st->strs_list);
    xfree(st);
}

uint_t strtable_add_string(void* st_, const char* str) {
    strtable_t* st = st_;
    strtable_item_t* found;
    HASH_FIND_STR(st->strs_hash, str, found);
    if (found) {
        return found->id;
    }
    else {
        // create new item
        strtable_item_t* elem = xnew(strtable_item_t);
        elem->str = xstrdup(str);
        elem->id = (uint_t)HASH_COUNT(st->strs_hash);

        // add to hash table
        HASH_ADD_STR(st->strs_hash, str, elem);

        // add to string list
        utarray_push_back(st->strs_list, &elem);

        return elem->id;
    }
}

bool strtable_find(void* st_, const char* str) {
    strtable_t* st = st_;
    strtable_item_t* found;
    HASH_FIND_STR(st->strs_hash, str, found);
    if (found)
        return true;
    else
        return false;
}

const char* strtable_lookup(void* st_, uint_t id) {
    strtable_t* st = st_;
    if (id < (uint_t)HASH_COUNT(st->strs_hash)) {
        strtable_item_t* elem = *(strtable_item_t**)utarray_eltptr(st->strs_list, id);
        xassert(elem);
        xassert(elem->str);
        return elem->str;
    }
    else
        return "";
}

uint_t strtable_size(void* st_) {
    strtable_t* st = st_;
    return (uint_t)HASH_COUNT(st->strs_hash);
}

void strtable_fwrite(void* st_, FILE* fp) {
    strtable_t* st = st_;

    // alignment data
    static const char align_data[sizeof(int32_t)] = { 0 };

    // write size of table and placeholder for size of strings
    uint_t num_strings = strtable_size(st);
    xfwrite_dword(num_strings, fp);
    long fpos_strings_size = ftell(fp);
    xfwrite_dword(0, fp);

    // write index of each string into array of strings concatenated separated by '\0'
    uint_t str_table_pos = 0;
    for (uint_t id = 0; id < num_strings; id++) {
        const char* str = strtable_lookup(st, id);
        uint_t pos = str_table_pos;           // position of this string in table
        str_table_pos += (uint_t)strlen(str) + 1; // next position

        xfwrite_dword(pos, fp);                 // index into strings
    }

    // write all strings together
    for (uint_t id = 0; id < num_strings; id++) {
        const char* str = strtable_lookup(st, id);
        xfwrite(str, 1, strlen(str) + 1, fp);       // write string including '\0'
    }

    // align to dword size
    uint_t aligned_str_table_pos = ((str_table_pos + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1));
    int extra_bytes = aligned_str_table_pos - str_table_pos;
    xfwrite(align_data, 1, extra_bytes, fp);

    long fpos_end = ftell(fp);
    xfseek(fp, fpos_strings_size, SEEK_SET);
    xfwrite_dword(aligned_str_table_pos, fp);
    xfseek(fp, fpos_end, SEEK_SET);
}

void* strtable_fread(FILE* fp) {
    strtable_t* st = strtable_new();

    long fpos_start = ftell(fp);

    // read sizes
    uint_t num_strings = xfread_dword(fp);
    uint_t aligned_strings_size = xfread_dword(fp);

    // go to start of strings and read them
    xfseek(fp, fpos_start + (2 + num_strings) * sizeof(int32_t), SEEK_SET);
    UT_string* strings;
    utstring_new(strings);
    utstring_reserve(strings, aligned_strings_size + 1);        // add space for '\0'
    xfread(utstring_body(strings), 1, aligned_strings_size, fp);
    utstring_len(strings) = aligned_strings_size;

    // go to start of table and add each string to the st
    xfseek(fp, fpos_start + 2 * sizeof(int32_t), SEEK_SET);
    for (uint_t i = 0; i < num_strings; i++) {
        uint_t pos = xfread_dword(fp);
        const char* str = utstring_body(strings) + pos;
        uint_t id = strtable_add_string(st, str);
        xassert(id == i);
    }

    // go to end of table
    xfseek(fp, fpos_start + (2 + num_strings) * sizeof(int32_t) + aligned_strings_size, SEEK_SET);

    utstring_free(strings);

    return st;
}

void* strtable_parse(const byte_t* mem) {
    strtable_t* st = strtable_new();

    const byte_t* p = mem;
    uint_t num_strings = parse_le_int32(p); p += sizeof(int32_t);
    p += sizeof(int32_t);   // string size

    const char* strings = (const char*)p + num_strings * sizeof(int32_t);
    for (uint_t id = 0; id < num_strings; id++) {
        uint_t pos = parse_le_int32(p); p += sizeof(int32_t);
        const char* str = strings + pos;
        xassert(id == strtable_add_string(st, str));
    }

    return st;
}

