//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include "cpu.h"
#include "diag.h"
#include "dump_context.h"
#include "obj_expr.h"
#include "obj_extern.h"
#include "obj_features.h"
#include "obj_modname.h"
#include "obj_range_type.h"
#include "obj_reloc.h"
#include "obj_schema.h"
#include "obj_section.h"
#include "obj_symbol.h"
#include "options.h"
#include "source_loc.h"
#include "string_utils.h"
#include "strings.h"
#include <cstdint>
#include <iomanip>
#include <ios>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

//-----------------------------------------------------------------------------
// Module type
//-----------------------------------------------------------------------------

// ObjModuleBase is pure data; dumping, packing and unpacking is done
// by free functions
template <typename Storage, template <typename> class Container>
struct ObjModuleBase {
    using Expr = ObjExprBase<Storage>;
    using Reloc = ObjRelocBase<Storage>;
    using Symbol = ObjSymbolBase<Storage>;
    using Extern = ObjExternBase<Storage>;
    using Section = ObjSectionBase<Storage>;
    using Modname = ObjModnameBase<Storage>;

    // attributes
    CPU cpu_id = DEFAULT_CPU;
    bool swap_ixiy = false;
    uint base_address = OrgNotDefined;
	
    Container<Modname> modname;
    Container<std::vector<Expr>>    exprs;
    Container<std::vector<Reloc>>   relocs;
    Container<std::vector<Symbol>>  symbols;
    Container<std::vector<Extern>>  externs;
    Container<std::vector<Section>> sections;

    // constructors
    ObjModuleBase() = default;
    virtual ~ObjModuleBase() = default;
};

// Assembler: owning, eager
using ObjModule = ObjModuleBase<InternedStorage, Eager>;

// Linker: non-owning, lazy
using ObjModuleView = ObjModuleBase<ViewStorage, Lazy>;

