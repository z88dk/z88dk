//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "lexer_keywords.h"
#include "string_utils.h"
#include <algorithm>
#include <cassert>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

CPU cpu_lookup(std::string_view name) {
    static const std::unordered_map<std::string, CPU> lu_table = {
#define X(code, id, name, defines)   { name, CPU::id },
#include "cpu.def"
    };

    std::string name_s(name);
    auto it = lu_table.find(to_lower(name_s));
    if (it == lu_table.end()) {
        return CPU::none;
    }
    else {
        return it->second;
    }
}

std::string cpu_name(CPU cpu_id) {
    // CPU ids may not be sequencial
    static const std::unordered_map<CPU, std::string> lu_table = {
#define X(code, id, name, defines)   { CPU::id, name },
#include "cpu.def"
    };

    auto it = lu_table.find(cpu_id);
    if (it == lu_table.end()) {
        assert(0);
        return "unknown";
    }
    else {
        return it->second;
    }
}

std::vector<std::string> cpu_names() {
    static std::vector<std::string> names = {
#define X(code, id, name, defines)   name,
#include "cpu.def"
    };
    std::sort(names.begin(),
              names.end());  // could be compile-time in C++20 with consteval and std::array
    return names;
}

static const std::unordered_map<CPU, std::vector<std::string>>& cpu_defines_table() {
    static const std::unordered_map<CPU, std::vector<std::string>> table = []() {
        std::unordered_map<CPU, std::vector<std::string>> t;
        struct Entry {
            CPU id;
            const char* defines;
        };
        static const Entry entries[] = {
#define X(code, id, name, defines)   { CPU::id, defines },
#include "cpu.def"
        };
        for (const auto& e : entries) {
            std::vector<std::string> words;
            std::istringstream ss(e.defines);
            std::string word;
            while (ss >> word) {
                words.push_back(std::move(word));
            }
            t[e.id] = std::move(words);
        }
        return t;
    }
    ();
    return table;
}

std::vector<std::string> cpu_all_defines() {
    static const std::vector<std::string> all = []() {
        std::vector<std::string> result;
        for (const auto& [id, words] : cpu_defines_table()) {
            result.insert(result.end(), words.begin(), words.end());
        }
        std::sort(result.begin(), result.end());
        result.erase(std::unique(result.begin(), result.end()), result.end());
        return result;
    }
    ();
    return all;
}

std::vector<std::string> cpu_defines(CPU cpu_id) {
    const auto& table = cpu_defines_table();
    auto it = table.find(cpu_id);
    if (it == table.end())
        return {};
    return it->second;
}

Keyword cpu_invert_flag_condition(Keyword kw) {
    switch (kw) {
    case Keyword::C:
        return Keyword::NC;
    case Keyword::EQ:
        return Keyword::NE;
    case Keyword::GE:
        return Keyword::LT;
    case Keyword::GEU:
        return Keyword::LTU;
    case Keyword::GT:
        return Keyword::LE;
    case Keyword::GTU:
        return Keyword::LEU;
    case Keyword::K:
        return Keyword::NK;
    case Keyword::LE:
        return Keyword::GT;
    case Keyword::LEU:
        return Keyword::GTU;
    case Keyword::LO:
        return Keyword::LZ;
    case Keyword::LT:
        return Keyword::GE;
    case Keyword::LTU:
        return Keyword::GEU;
    case Keyword::LZ:
        return Keyword::LO;
    case Keyword::M:
        return Keyword::P;
    case Keyword::NC:
        return Keyword::C;
    case Keyword::NE:
        return Keyword::EQ;
    case Keyword::NK:
        return Keyword::K;
    case Keyword::NV:
        return Keyword::V;
    case Keyword::NX5:
        return Keyword::X5;
    case Keyword::NZ:
        return Keyword::Z;
    case Keyword::P:
        return Keyword::M;
    case Keyword::PE:
        return Keyword::PO;
    case Keyword::PO:
        return Keyword::PE;
    case Keyword::V:
        return Keyword::NV;
    case Keyword::X5:
        return Keyword::NX5;
    case Keyword::Z:
        return Keyword::NZ;
    default:
        assert(0);
        return Keyword::None;
    }
}

// replace IX<->IY, IXH<->IYH, AIX<->AIY, XIX<->YIY
static void swap_x_y(std::string& inout_text) {
    for (auto& c : inout_text) {
        switch (c) {
        case 'x':
            c = 'y';
            break;
        case 'X':
            c = 'Y';
            break;
        case 'y':
            c = 'x';
            break;
        case 'Y':
            c = 'X';
            break;
        default:
            ;
        }
    }
}

void swap_ix_iy(std::string& inout_text, Keyword& inout_kw) {
    if (keyword_is_x_register(inout_kw)) {
        swap_x_y(inout_text);
        inout_kw = keyword_lookup(inout_text);
    }
}

