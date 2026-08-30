//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "dump_context.h"
#include "errors.h"
#include "lexer.h"
#include <memory>
#include <string>
#include <utility>
#include <vector>

enum class ExprType {
    Number,
    String,
};

struct Expr : TreeNode {
    ExprType type = ExprType::Number;
    SourceLoc loc;			// source location

    explicit Expr(ExprType type_, SourceLoc loc_)
        : type(type_), loc(loc_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override = 0;
#endif
};

struct NumberExpr : Expr {
    double value = 0.0;

    explicit NumberExpr(double value_, SourceLoc loc_)
        : Expr(ExprType::Number, loc_), value(value_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelLineRefExpr : Expr {
    std::string name;   // @label

    explicit LabelLineRefExpr(const std::string& name_, SourceLoc loc_)
        : Expr(ExprType::Number, loc_), name(name_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelAddrRefExpr : Expr {
    std::string name;   // &var

    explicit LabelAddrRefExpr(const std::string& name_, SourceLoc loc_)
        : Expr(ExprType::Number, loc_), name(name_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StringLiteralExpr : Expr {
    std::string value;      // ASCII string literal

    explicit StringLiteralExpr(std::string val, SourceLoc loc_)
        : Expr(ExprType::String, loc_), value(std::move(val)) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct VariableExpr : Expr {
    std::string name;       // includes $ if present

    explicit VariableExpr(const std::string& name_, SourceLoc loc_)
        : Expr(is_string_variable(name_) ? ExprType::String : ExprType::Number, loc_),
          name(name_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ArrayRefExpr : Expr {
    std::string name;  // A or A$
    std::vector<std::unique_ptr<Expr>> indices;  // one or more expressions

    explicit ArrayRefExpr(const std::string& name_, SourceLoc loc_)
        : Expr(is_string_variable(name_) ? ExprType::String : ExprType::Number, loc_),
          name(name_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SliceExpr : Expr {
    std::unique_ptr<Expr> base;   // A$, A$(I), or any string expression
    std::unique_ptr<Expr> from;   // may be nullptr
    std::unique_ptr<Expr> to;     // may be nullptr

    explicit SliceExpr(std::unique_ptr<Expr> base_, SourceLoc loc_)
        : Expr(ExprType::String, loc_), base(std::move(base_)) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnaryExpr : Expr {
    TokenType op;        // only '-'
    std::unique_ptr<Expr> operand;

    explicit UnaryExpr(TokenType op_, std::unique_ptr<Expr> operand_,
                       SourceLoc loc_)
        : Expr(operand_->type, loc_), op(op_), operand(std::move(operand_)) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BinaryExpr : Expr {
    TokenType op;        // + - * / ** AND OR NOT = < > <= >= <>
    std::unique_ptr<Expr> lhs;
    std::unique_ptr<Expr> rhs;

    explicit BinaryExpr(TokenType op_,
                        std::unique_ptr<Expr> lhs_,
                        std::unique_ptr<Expr> rhs_, SourceLoc loc_)
        : Expr(lhs_->type, loc_), op(op_),
          lhs(std::move(lhs_)),
          rhs(std::move(rhs_)) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BasicFuncCallExpr : Expr {
    Keyword keyword;    // SIN, COS, LEN, VAL, STR$, etc.
    std::vector<std::unique_ptr<Expr>> args;

    explicit BasicFuncCallExpr(Keyword keyword_, SourceLoc loc_)
        : Expr(ExprType::Number, loc_), keyword(keyword_) {
        switch (keyword) {
        case Keyword::INKEY_DLR:
        case Keyword::STR_DLR:
        case Keyword::CHR_DLR:
            type = ExprType::String;
            break;
        default:
            type = ExprType::Number;
            break;
        }
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallExpr : Expr {
    std::string name;                         // PROCname
    std::vector<std::unique_ptr<Expr>> args;  // (10, 20)

    explicit ProcCallExpr(const std::string& name_, SourceLoc loc_)
        : Expr(ExprType::Number, loc_), name(name_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FnCallExpr : Expr {
    std::string name;                         // FNname
    std::vector<std::unique_ptr<Expr>> args;  // (10, 20)

    explicit FnCallExpr(const std::string& name_, SourceLoc loc_)
        : Expr(ExprType::Number, loc_), name(name_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

int precedence(const Expr& e);
