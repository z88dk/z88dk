//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <string_view>
#include <vector>

struct ObjectFile {
    std::string module_name;
    int cpu_id;
    int ixiy_mode;

    /*
    std::vector<ObjExpression> expressions;
    std::vector<ObjDefinedSymbol> defined_symbols;
    std::vector<ObjExternalSymbol> external_symbols;
    std::vector<ObjSection> sections;
    ObjStringTable strings;
    */

};

bool write_object_file(const ObjectFile& obj, std::string_view filename);
