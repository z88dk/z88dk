//-----------------------------------------------------------------------------
// z80asm
// Recognized CPUs
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <climits>
#include <iostream>
#include <set>
#include <sstream>
using namespace std;

CpuTable* g_cpu_table;

CpuTable::CpuTable() {
    // init maps and cpu names
    for (auto& info : m_table) {
        m_by_name[info.name] = info.id;
        m_cpu_names.push_back(info.name);
    }
    sort(m_cpu_names.begin(), m_cpu_names.end());

    // init dependency tree
    for (auto& info : m_table) {
        if (info.compat_parent_id == Cpu::UNDEF || info.is_strict)
            info.level = 0;     // no compatibility
        else
            info.level = -1;    // still to check
    }

    int max_compat_level = INT_MIN;
    bool done = false;
    do {
        done = true;
        for (auto& info : m_table) {
            if (info.level < 0) {   // not yet traversed
                const CpuInfo* parent = get_info(info.compat_parent_id);
                if (parent && parent->level >= 0) {
                    info.level = parent->level + 1;
                    if (max_compat_level < info.level)
                        max_compat_level = info.level;
                }
                done = false;
            }
        }
    } while (!done);

    // init orderd list of cpu-ids in library link order
    for (int level = max_compat_level; level >= 0; --level) {
        for (auto& info : m_table) {
            if (info.level == level)
                m_cpus_link_order.push_back(info.id);
        }
    }

}

const CpuInfo* CpuTable::get_info(Cpu id) const {
    int i = index(id);
    if (i < 0)
        return nullptr;
    else
        return &m_table[i];
}

const CpuInfo* CpuTable::get_info(const string& name) const {
    auto it = m_by_name.find(name);
    if (it == m_by_name.end())
        return nullptr;
    else {
        int i = index(it->second);
        if (i < 0)
            return nullptr;
        else
            return &m_table[i];
    }
}

string CpuTable::cpu_names() const {
    string names;
    for (auto& name : m_cpu_names) {
        if (!names.empty())
            names += ", ";
        names += name;
    }
    names += ".";
    return names;
}

string CpuTable::cpu_names(int lmargin, int rmargin) const {
    ostringstream oss;
    int col = lmargin;
    for (auto& name : m_cpu_names) {
        if (col + static_cast<int>(name.size()) + 2 > rmargin) {
            oss << endl << string(lmargin, ' ');
            col = lmargin;
        }
        oss << name << ", ";
        col += static_cast<int>(name.size()) + 2;
    }

    string str = oss.str();
    if (str_ends_with(str, ", ")) {
        str.pop_back();
        str.pop_back();
        str += ".";
    }

    return str;
}

const vector<string>& CpuTable::cpu_defines(Cpu id) const {
    static vector<string> empty_defines;
    const CpuInfo* info = get_info(id);
    if (info)
        return info->defines;
    else
        return empty_defines;
}

vector<string> CpuTable::all_defines() const {
    // Collect in a set to remove duplicates
    set<string> defines_set;
    for (const auto& info : m_table) {
        for (const auto& define : info.defines) {
            defines_set.insert(define);
        }
    }

    // Convert set to vector
    vector<string> defines;
    defines.reserve(defines_set.size());
    for (const auto& define : defines_set) {
        defines.push_back(define);
    }

    // Sort the vector
    sort(defines.begin(), defines.end());

    return defines;
}

int CpuTable::index(Cpu id) const {
    int i = static_cast<int>(id) - 1;
    if (i >= 0 && i < static_cast<int>(m_table.size()))
        return i;
    else
        return -1;
}
