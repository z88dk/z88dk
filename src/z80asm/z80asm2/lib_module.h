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
// Library type
//-----------------------------------------------------------------------------

template <typename Storage, template <typename> class Container>
struct LibModuleBase {
    using Module = ObjModuleBase<Storage, Container>;

    std::vector<Module> modules;

    // constructors
    LibModuleBase() = default;
    virtual ~LibModuleBase() = default;
};

// Assembler: owning, eager
using LibModule = LibModuleBase<InternedStorage, Eager>;

// Linker: non-owning, lazy
using LibModuleView = LibModuleBase<ViewStorage, Lazy>;

