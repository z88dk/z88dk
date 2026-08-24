//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../ast.h"
#include "../ast_expr.h"
#include "../dump_context.h"
#include <string>

void NumberExpr::dump(DumpContext ctx) const {
    ctx.line("NumberExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("value: " + std::to_string(value));
    ctx.line("}");
}

void LabelLineRefExpr::dump(DumpContext ctx) const {
    ctx.line("LabelLineRefExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}

void LabelAddrRefExpr::dump(DumpContext ctx) const {
    ctx.line("LabelAddrRefExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}

void StringLiteralExpr::dump(DumpContext ctx) const {
    ctx.line("StringLiteralExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("value: \"" + value + "\"");
    ctx.line("}");
}

void VariableExpr::dump(DumpContext ctx) const {
    ctx.line("VariableExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}

void ArrayRefExpr::dump(DumpContext ctx) const {
    ctx.line("ArrayRefExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("indices", indices, child_ctx);
    ctx.line("}");
}

void SliceExpr::dump(DumpContext ctx) const {
    ctx.line("SliceExpr {");
    auto child_ctx = ctx.child();
    dump_child_expr("base", base.get(), child_ctx);
    dump_child_expr("from", from.get(), child_ctx);
    dump_child_expr("to", to.get(), child_ctx);
    ctx.line("}");
}

void UnaryExpr::dump(DumpContext ctx) const {
    ctx.line("UnaryExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("op: " + token_type_name(op));
    dump_child_expr("operand", operand.get(), child_ctx);
    ctx.line("}");
}

void BinaryExpr::dump(DumpContext ctx) const {
    ctx.line("BinaryExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("op: " + token_type_name(op));
    dump_child_expr("left", left.get(), child_ctx);
    dump_child_expr("right", right.get(), child_ctx);
    ctx.line("}");
}

void BasicFuncCallExpr::dump(DumpContext ctx) const {
    ctx.line("BasicFuncCallExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}

void ProcCallExpr::dump(DumpContext ctx) const {
    ctx.line("ProcCallExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}

void FnCallExpr::dump(DumpContext ctx) const {
    ctx.line("FnCallExpr {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}

#endif
