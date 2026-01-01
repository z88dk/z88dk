//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "utils.h"
#include <algorithm>
#include <unordered_map>

CPU cpu_lookup(const std::string& name) {
    static std::unordered_map<std::string, CPU> lu_table = {
#define X(code, id, name)   { name, CPU::id },
#include "cpu.def"
    };
    auto it = lu_table.find(to_lower(name));
    if (it == lu_table.end()) {
        return CPU::not_defined;
    }
    else {
        return it->second;
    }
}

std::string cpu_name(CPU id) {
    // CPU ids may not be sequencial
    switch (id) {
#define X(code, id, name)   case CPU::id: return name;
#include "cpu.def"
    default:
        return "";
    }
}

std::vector<std::string> cpu_names() {
    static std::vector<std::string> names = {
#define X(code, id, name)   name,
#include "cpu.def"
    };
    std::sort(names.begin(), names.end());
    return std::vector<std::string>();
}
