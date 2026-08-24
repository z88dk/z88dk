//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../dump_context.h"
#include "../ast_expr.h"
#include <string>
#include <vector>
#include <memory>

void dump_expr_list(const char* name,
                    const std::vector<std::unique_ptr<Expr>>& list,
                    DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    for (const auto& e : list) {
        if (e) {
            e->dump(child_ctx);
        }
    }
    ctx.line("]");
}

void dump_child_expr(const char* name, const Expr* e, DumpContext& ctx) {
    ctx.line(std::string(name) + ": ");
    if (e) {
        auto child_ctx = ctx.child();
        e->dump(child_ctx);
    }
    else {
        auto child_ctx = ctx.child();
        child_ctx.line("null");
    }
}

#endif
