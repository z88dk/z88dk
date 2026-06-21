//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ir.h"
#include <string_view>

bool get_const_expr_value(const Expr* expr, uint& out_value,
                          std::string_view error_kw);
bool get_const_expr_value(const Expr* expr, int& out_value,
                          std::string_view error_kw);
bool eval_exprs(Program& prog, bool& changed, bool silent);
bool compute_relocations(Program& prog);
