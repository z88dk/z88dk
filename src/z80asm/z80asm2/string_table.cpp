//-----------------------------------------------------------------------------
// z80asm
// String table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "string_table.h"

StringTable::StringTable() {
    m_strings.emplace_back(""); // reserve index 0 for empty string
    m_id_map[""] = 0; // map empty string to index 0
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
    int index = static_cast<int>(m_strings.size());
    m_strings.push_back(str);
    m_id_map[str] = index;
    return index; // return the new index
}

const string& StringTable::get_string(int index) const {
    if (index < 0 || index >= static_cast<int>(m_strings.size()))
        return m_strings.at(0); // return empty string for invalid index
    else
        return m_strings.at(index);
}

bool StringTable::find_string(const string& str, int& index) const {
    auto it = m_id_map.find(str);
    if (it != m_id_map.end()) {
        index = it->second;
        return true; // string found
    }
    else {
        index = -1; // string not found, set index to -1
        return false; // string not found
    }
}

bool StringTable::find_string(const string& str) const {
    int index = -1;
    return find_string(str, index);
}

int StringTable::size() const {
    return static_cast<int>(m_strings.size());
}
