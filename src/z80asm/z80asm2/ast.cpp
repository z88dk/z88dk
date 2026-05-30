//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"

#include "string_interner.h"
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>

DumpContext::DumpContext(std::ostream& os_, int indent_)
    : os(os_), indent(indent_) {
}

void DumpContext::line(std::string_view text) {
    os << std::string(indent * 4, ' ') << text << std::endl;
}

DumpContext DumpContext::child() const {
    return DumpContext(os, indent + 1);
}

void Stmt::dump(DumpContext ctx) const {
    ctx.line("Stmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
}

LabelStmt::LabelStmt(StringInterner::Id text_id_, const SourceLoc& loc_)
    : Stmt(loc_), text_id(text_id_) {
}

void LabelStmt::dump(DumpContext ctx) const {
    Stmt::dump(ctx);
    auto c = ctx.child();
    std::string ident_str = g_strings.to_string(text_id);
    c.line("Label: " + ident_str);
    if (is_local) {
        c.line("Local part: " + ident_str.substr(at_pos));
    }
}

void Program::dump(DumpContext ctx) const {
    ctx.line("Program");
    auto c = ctx.child();
    for (const auto& stmt : stmts) {
        stmt->dump(c);
    }
}

void dump_ast_and_exit(const std::unique_ptr<Program>& prog) {
    DumpContext ctx(std::cout);
    prog->dump(ctx);
    exit(EXIT_SUCCESS);
}

void ExprLiteralInt::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralInt: " + std::to_string(value));
}

void ExprLiteralFloat::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralFloat: " + std::to_string(value));
}

void ExprLiteralAsmpc::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralAsmpc");
}

void ExprSymbol::dump(DumpContext ctx) const {
    ctx.line("ExprSymbol: " + g_strings.to_string(name_id));
}

void ExprLocalLabel::dump(DumpContext ctx) const {
    ctx.line("ExprLocalLabel: " + g_strings.to_string(name_id) + " @ " + std::to_string(at_pos));
}

void ExprUnary::dump(DumpContext ctx) const {
    ctx.line("ExprUnary: " + to_string(op));
    auto c = ctx.child();
    c.line("RHS:");
    rhs->dump(c.child());
}

void ExprBinary::dump(DumpContext ctx) const {
    ctx.line("ExprBinary: " + to_string(op));
    auto c = ctx.child();
    c.line("LHS:");
    lhs->dump(c.child());
    c.line("RHS:");
    rhs->dump(c.child());
}

void ExprTernary::dump(DumpContext ctx) const {
    ctx.line("ExprTernary");
    auto c = ctx.child();
    c.line("Condition:");
    cond->dump(c.child());
    c.line("Then:");
    then_expr->dump(c.child());
    c.line("Else:");
    else_expr->dump(c.child());
}

