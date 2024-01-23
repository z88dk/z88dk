//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "model.h"
#include "z80asm.h"

StaticDefines g_static_defines;

//-----------------------------------------------------------------------------
// Static defines
//-----------------------------------------------------------------------------

void StaticDefines::add(const string& name, int value) {
    auto it = m_defines.find(name);
    if (it != m_defines.end()) {
        if (it->second != value)
            g_errors.error(Errors::Code::duplicate_definition, name);
    }
    else {
        m_defines[name] = value;
        if (g_args.opt_verbose)
            cout << "Predefined constant: " << name << " = " << int_to_hex(value, 4) << endl;
    }
}

void StaticDefines::remove(const string& name) {
    m_defines.erase(name);
}

bool StaticDefines::lookup(const string& name, int& result) {
    auto it = m_defines.find(name);
    if (it != m_defines.end()) {
        result = it->second;
        return true;
    }
    else {
        result = 0;
        return false;
    }
}

bool StaticDefines::exists(const string& name) {
    int value;
    return lookup(name, value);
}

void StaticDefines::clear() {
    m_defines.clear();
}
