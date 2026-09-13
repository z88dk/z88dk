//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "symtab.h"
#include <string>
#include <vector>

bool build_asm_source(Prog& prog, Symtab& symtab,
                      std::vector<std::string>& out_asm_source);

