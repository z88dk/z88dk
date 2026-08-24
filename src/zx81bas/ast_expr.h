//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "dump_context.h"
#include "lexer.h"
#include <memory>
#include <string>
#include <vector>

struct Expr : TreeNode {
#ifdef _DEBUG
    void dump(DumpContext ctx) const override = 0;
#endif
};

struct NumberExpr : Expr {
    double value = 0.0;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelLineRefExpr : Expr {
    std::string name;   // @label

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelAddrRefExpr : Expr {
    std::string name;   // &var

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StringLiteralExpr : Expr {
    std::string value;      // ASCII string literal

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct VariableExpr : Expr {
    std::string name;       // includes $ if present

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ArrayRefExpr : Expr {
    std::string name;  // A or A$
    std::vector<std::unique_ptr<Expr>> indices;  // one or more expressions

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SliceExpr : Expr {
    std::unique_ptr<Expr> base;   // A$, A$(I), or any string expression
    std::unique_ptr<Expr> from;   // may be nullptr
    std::unique_ptr<Expr> to;     // may be nullptr

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnaryExpr : Expr {
    TokenType op;        // only '-'
    std::unique_ptr<Expr> operand;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BinaryExpr : Expr {
    TokenType op;        // + - * / ** AND OR NOT = < > <= >= <>
    std::unique_ptr<Expr> left;
    std::unique_ptr<Expr> right;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BasicFuncCallExpr : Expr {
    std::string name;    // SIN, COS, LEN, VAL, STR$, etc.
    std::vector<std::unique_ptr<Expr>> args;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallExpr : Expr {
    std::string name;                         // PROCname
    std::vector<std::unique_ptr<Expr>> args;  // (10, 20)

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FnCallExpr : Expr {
    std::string name;                         // FNname
    std::vector<std::unique_ptr<Expr>> args;  // (10, 20)

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

int precedence(const Expr& e);
