//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <map>
using namespace std;

//-----------------------------------------------------------------------------
// Static defines
//-----------------------------------------------------------------------------

class StaticDefines {
public:
    void add(const string& name, int value = 1);
    void remove(const string& name);
    bool lookup(const string& name, int& result);
    bool exists(const string& name);
    void clear();

    auto begin() { return m_defines.begin(); }
    auto end() { return m_defines.end(); }
    auto cbegin() const { return m_defines.cbegin(); }
    auto cend() const { return m_defines.cend(); }
    auto size() const { return m_defines.size(); }

private:
    map<string, int> m_defines;
};

extern StaticDefines g_static_defines;
