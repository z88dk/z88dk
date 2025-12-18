//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>

enum class CPU {
#define X(code, id, name)   id = code,
#include "cpu.def"
};

CPU cpu_lookup(const std::string& name);
std::string cpu_name(CPU id);
std::vector<std::string> cpu_names();
