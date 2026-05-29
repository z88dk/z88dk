//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include <iostream>
#include <memory>
#include <string_view>
#include <utility>
#include <vector>

// helper for dumping AST in a readable format
struct DumpContext {
    std::ostream& os;
    int indent{0};

    DumpContext(std::ostream& os_, int indent_ = 0);
    void line(std::string_view text);
    DumpContext child() const;
};

// base class for all AST nodes
struct AstNode {
    virtual ~AstNode() = default;
    virtual void dump(DumpContext ctx) const = 0;
};

// base class for all expressions
struct Expr : AstNode {
    SourceLoc loc;
    explicit Expr(const SourceLoc& loc_) : loc(loc_) {}
};

struct ExprLiteralInt : Expr {
    int value;
    ExprLiteralInt(int v, const SourceLoc& loc) : Expr(loc), value(v) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLiteralFloat : Expr {
    double value;
    ExprLiteralFloat(double v, const SourceLoc& loc) : Expr(loc), value(v) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLiteralAsmpc : Expr {
    ExprLiteralAsmpc(const SourceLoc& loc) : Expr(loc) {}
    void dump(DumpContext ctx) const override;
};

struct ExprSymbol : Expr {
    StringInterner::Id name_id;
    ExprSymbol(StringInterner::Id name_id_, const SourceLoc& loc) : Expr(loc), name_id(name_id_) {}
    void dump(DumpContext ctx) const override;
};

struct ExprUnary : Expr {
    TokenType op;
    std::unique_ptr<Expr> rhs;
    ExprUnary(TokenType op_, std::unique_ptr<Expr> rhs_, const SourceLoc& loc)
        : Expr(loc), op(op_), rhs(std::move(rhs_)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprBinary : Expr {
    TokenType op;
    std::unique_ptr<Expr> lhs, rhs;
    ExprBinary(TokenType op_, std::unique_ptr<Expr> lhs_, std::unique_ptr<Expr> rhs_,
               const SourceLoc& loc)
        : Expr(loc), op(op_), lhs(std::move(lhs_)), rhs(std::move(rhs_)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprTernary : Expr {
    std::unique_ptr<Expr> cond, then_expr, else_expr;
    ExprTernary(std::unique_ptr<Expr> c, std::unique_ptr<Expr> t, std::unique_ptr<Expr> e,
                const SourceLoc& loc)
        : Expr(loc), cond(std::move(c)), then_expr(std::move(t)), else_expr(std::move(e)) {}
    void dump(DumpContext ctx) const override;
};

// base class for all statements
struct Stmt : AstNode {
    SourceLoc loc;

    explicit Stmt(const SourceLoc& loc_) : loc(loc_) {}
    virtual ~Stmt() = default;
    void dump(DumpContext ctx) const override;
};

struct LabelStmt : Stmt {
    StringInterner::Id text_id;

    LabelStmt(StringInterner::Id text_id_, const SourceLoc& loc_);
    virtual ~LabelStmt() = default;
    void dump(DumpContext ctx) const override;
};

// root of the AST
struct Program : AstNode {
    std::vector<std::unique_ptr<Stmt>> stmts;

    virtual ~Program() = default;
    void dump(DumpContext ctx) const override;
};

[[noreturn]] void dump_ast_and_exit(const std::unique_ptr<Program>& prog);
