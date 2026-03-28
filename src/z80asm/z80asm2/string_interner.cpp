//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "string_interner.h"
#include <string>
#include <string_view>

StringInterner g_strings;

// Reserve ID 0 for the empty string
StringInterner::StringInterner() {
    pool.emplace_back("");                 // pool[0] = ""
    map.emplace(std::string(""), 0);
}

// Returns an ID for the given string, interning it if needed.
StringInterner::Id StringInterner::intern(std::string_view s) {
    std::string key(s);
    auto it = map.find(key);
    if (it != map.end()) {
        return it->second;
    }

    Id id = static_cast<Id>(pool.size());
    pool.emplace_back(s);
    map.emplace(std::move(key), id);
    return id;
}

// Get C-string for an ID (stable pointer).
const char* StringInterner::c_str(Id id) const {
    return pool[id].c_str();
}

// Get string_view for an ID.
std::string_view StringInterner::view(Id id) const {
    return std::string_view(pool[id]);
}

// Get std::string for an ID.
std::string StringInterner::to_string(Id id) const {
    return std::string(pool[id]);
}

// Optional: number of unique strings.
size_t StringInterner::size() const noexcept {
    return pool.size();
}
