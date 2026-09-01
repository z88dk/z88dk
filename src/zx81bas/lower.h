//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast_stmt.h"
#include "symtab.h"
#include <memory>
#include <string_view>

static inline std::string_view end_of_program_label = "ZX81BASENDOFPROGRAM";

bool lower_prog(Prog& prog, Symtab& symtab, std::unique_ptr<Prog>& out_prog);
