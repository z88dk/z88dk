//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "dump_context.h"
#include <vector>
#include <memory>

#ifdef _DEBUG

struct Expr;

void dump_expr_list(const char* name,
                    const std::vector<std::unique_ptr<Expr>>& list,
                    DumpContext& ctx);
void dump_child_expr(const char* name, const Expr* e, DumpContext& ctx);

#endif
