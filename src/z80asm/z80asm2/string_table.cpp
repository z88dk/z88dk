//-----------------------------------------------------------------------------
// z80asm
// String table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "string_table.h"
#include <cassert>
#include <iostream>
using namespace std;

StringTable::StringTable() {
    clear();
}

void StringTable::clear() {
    m_strings.clear();
    m_id_map.clear();
    m_strings.emplace_back(""); // reserve index 0 for empty string
    m_id_map[""] = 0; // map empty string to index 0
}

int StringTable::add_string(const string& str) {
    auto it = m_id_map.find(str);
    if (it != m_id_map.end()) {
        return it->second; // string already exists, return its index
    }
    int index = size();
    m_strings.push_back(str);
    m_id_map[str] = index;
    return index; // return the new index
}

const string& StringTable::get_string(int index) const {
    assert(index >= 0 && index < size() && "Index out of bounds");
    return m_strings.at(index);
}

bool StringTable::find_string(const string& str, int& index) const {
    auto it = m_id_map.find(str);
    if (it != m_id_map.end()) {
        index = it->second;
        return true; // string found
    }
    else {
        index = 0; // string not found, set index to 0
        return false; // string not found
    }
}

bool StringTable::find_string(const string& str) const {
    int index = 0;
    return find_string(str, index);
}

int StringTable::size() const {
    return static_cast<int>(m_strings.size());
}

void StringTable::write(Memmap& memmap) const {
    // write size of table and placeholder for size of strings
    int num_strings = size();
    memmap.write_long(static_cast<uint32_t>(num_strings));
    int strings_size_pos = memmap.pos();
    memmap.write_long(0); // placeholder for size of strings

    // write index of each string into array of strings separated by '\0'
    int str_table_pos = 0;
    for (int id = 0; id < num_strings; ++id) {
        string str = get_string(id);
        memmap.write_long(static_cast<uint32_t>(str_table_pos));    // index into strings
        str_table_pos += static_cast<int>(str.size()) + 1;          // next position
    }

    // write all strings together
    int strings_pos = memmap.pos();
    for (int id = 0; id < num_strings; ++id) {
        string str = get_string(id);
        memmap.write_data(reinterpret_cast<const uint8_t*>(str.data()),
                            static_cast<int>(str.size()) + 1); // write string including '\0'
    }
    memmap.align();
    int end_pos = memmap.pos();
    ptrdiff_t strings_size = end_pos - strings_pos;

    // write strings size
    memmap.set_pos(strings_size_pos);
    memmap.write_long(static_cast<uint32_t>(strings_size));

    // move pos to end
    memmap.set_pos(end_pos);
}

bool StringTable::read(Memmap& memmap) {
    clear(); // clear existing strings

    uint32_t num_strings;
    if (!memmap.read_long(num_strings)) 
        return false; // failed to read number of strings

    uint32_t strings_size;
    if (!memmap.read_long(strings_size)) 
        return false; // failed to read size of strings

    vector<uint32_t> string_pos;
    for (uint32_t id = 0; id < num_strings; ++id) {
        uint32_t str_index;
        if (!memmap.read_long(str_index)) 
            return false; // failed to read string index
        string_pos.push_back(str_index); // map id to position
    }

    string strings;
    strings.resize(strings_size); // reserve space for all strings
    if (!memmap.read_data(reinterpret_cast<uint8_t*>(&strings[0]),
        strings_size)) 
        return false; // failed to read strings data

    for (uint32_t id = 0; id < num_strings; ++id) {
        string str{ strings.c_str() + string_pos[id] };
        if (id != static_cast<uint32_t>(add_string(str))) // add string to the table
            return false;
    }

    return true;
}

#ifdef UNIT_TESTS
void StringTable::test() {
    StringTable table;
    assert(table.size() == 1); // only the empty string is present

    int index1 = table.add_string("Hello");
    assert(index1 == 1);
    assert(table.get_string(index1) == "Hello");
    assert(table.size() == 2);

    int index2 = table.add_string("World");
    assert(index2 == 2);
    assert(table.get_string(index2) == "World");
    assert(table.size() == 3);

    int index3 = table.add_string("Hello");
    assert(index3 == 1); // should return the same index as before
    assert(table.get_string(index3) == "Hello");

    int index4;
    assert(table.find_string("World", index4));
    assert(index4 == 2);
    assert(table.find_string("World"));

    assert(!table.find_string("Nonexistent", index4));
    assert(index4 == 0); // should set index to 0 if not found
    assert(!table.find_string("Nonexistent"));

    assert(table.get_string(0) == ""); // should return empty string for index 0
    assert(table.get_string(1) == "Hello");
    assert(table.get_string(2) == "World");

    Memmap memmap;
    table.write(memmap);
    memmap.write_file("string_table.bin"); // Write to a binary file
    table.clear();

    memmap.clear();
    assert(memmap.read_file("string_table.bin")); // Read from the binary file
    assert(table.read(memmap)); // Read the string table from the memmap

    assert(table.get_string(0) == ""); // should return empty string for index 0
    assert(table.get_string(1) == "Hello");
    assert(table.get_string(2) == "World");

    table.clear();
    assert(table.size() == 1); // after clear, only the empty string should be present

    remove("string_table.bin");

    cout << "StringTable tests passed." << endl;
}
#endif
