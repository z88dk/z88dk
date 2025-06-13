//-----------------------------------------------------------------------------
// z80asm
// String table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "memmap.h"
#include "utils.h"
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class StringTable {
public:
    StringTable();
    StringTable(const StringTable& other) = delete;
    StringTable& operator=(const StringTable& other) = delete;

    void clear();
    size_t add_string(const string& str);
    const string& get_string(size_t index) const;
    bool find_string(const string& str, size_t& index) const;
    bool find_string(const string& str) const;
    size_t size() const;

    void write(Memmap& memmap) const;
    bool read(Memmap& memmap);

#ifdef UNIT_TESTS
    static void test();
#endif

private:
    vector<string> m_strings;               // string table
    unordered_map<string, size_t> m_id_map; // map from string to index
};
