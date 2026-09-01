//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_expr.h"
#include "lexer.h"
#include "release_assert.h"
#include <memory>

Expr::Expr(ExprType type_, SourceLoc loc_)
    : type(type_), loc(loc_) {
}

void Expr::accept(ASTVisitor& v) {
    v.visit(*this);
}

NumberExpr::NumberExpr(double value_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), value(value_) {
}

std::unique_ptr<Expr> NumberExpr::clone() const {
    return std::make_unique<NumberExpr>(value, loc);
}

void NumberExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

LabelLineRefExpr::LabelLineRefExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {
}

std::unique_ptr<Expr> LabelLineRefExpr::clone() const {
    return std::make_unique<LabelLineRefExpr>(name, loc);
}

void LabelLineRefExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

LabelAddrRefExpr::LabelAddrRefExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {
}

std::unique_ptr<Expr> LabelAddrRefExpr::clone() const {
    return std::make_unique<LabelAddrRefExpr>(name, loc);
}

void LabelAddrRefExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

StringLiteralExpr::StringLiteralExpr(std::string val, SourceLoc loc_)
    : Expr(ExprType::String, loc_), value(std::move(val)) {
}

std::unique_ptr<Expr> StringLiteralExpr::clone() const {
    return std::make_unique<StringLiteralExpr>(value, loc);
}

void StringLiteralExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

VariableExpr::VariableExpr(const std::string& name_, SourceLoc loc_)
    : Expr(is_string_variable(name_) ?
           ExprType::String : ExprType::Number, loc_),
      name(name_) {
}

std::unique_ptr<Expr> VariableExpr::clone() const {
    return std::make_unique<VariableExpr>(name, loc);
}

void VariableExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

ArrayRefExpr::ArrayRefExpr(const std::string& name_, SourceLoc loc_)
    : Expr(is_string_variable(name_) ?
           ExprType::String : ExprType::Number, loc_),
      name(name_) {
}

std::unique_ptr<Expr> ArrayRefExpr::clone() const {
    auto e = std::make_unique<ArrayRefExpr>(name, loc);
    for (auto& index : indices) {
        e->indices.push_back(index->clone());
    }
    return e;
}

void ArrayRefExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

SliceExpr::SliceExpr(std::unique_ptr<Expr> base_, SourceLoc loc_)
    : Expr(ExprType::String, loc_), base(std::move(base_)) {
}

std::unique_ptr<Expr> SliceExpr::clone() const {
    auto e = std::make_unique<SliceExpr>(base->clone(), loc);
    if (from) {
        e->from = from->clone();
    }
    if (to) {
        e->to = to->clone();
    }
    return e;
}

void SliceExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

UnaryExpr::UnaryExpr(TokenType op_, std::unique_ptr<Expr> operand_,
                     SourceLoc loc_)
    : Expr(operand_->type, loc_), op(op_), operand(std::move(operand_)) {
}

std::unique_ptr<Expr> UnaryExpr::clone() const {
    return std::make_unique<UnaryExpr>(op, operand->clone(), loc);
}

void UnaryExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

BinaryExpr::BinaryExpr(TokenType op_,
                       std::unique_ptr<Expr> lhs_,
                       std::unique_ptr<Expr> rhs_, SourceLoc loc_)
    : Expr(lhs_->type, loc_), op(op_),
      lhs(std::move(lhs_)),
      rhs(std::move(rhs_)) {
}

std::unique_ptr<Expr> BinaryExpr::clone() const {
    return std::make_unique<BinaryExpr>(op, lhs->clone(), rhs->clone(), loc);
}

void BinaryExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

BasicFuncCallExpr::BasicFuncCallExpr(Keyword keyword_, SourceLoc loc_)
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

std::unique_ptr<Expr> BasicFuncCallExpr::clone() const {
    auto e = std::make_unique<BasicFuncCallExpr>(keyword, loc);
    for (auto& arg : args) {
        e->args.push_back(arg->clone());
    }
    return e;
}

void BasicFuncCallExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

ProcCallExpr::ProcCallExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {
}

std::unique_ptr<Expr> ProcCallExpr::clone() const {
    auto e = std::make_unique<ProcCallExpr>(name, loc);
    for (auto& arg : args) {
        e->args.push_back(arg->clone());
    }
    return e;
}

void ProcCallExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

FnCallExpr::FnCallExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {
}

std::unique_ptr<Expr> FnCallExpr::clone() const {
    auto e = std::make_unique<FnCallExpr>(name, loc);
    for (auto& arg : args) {
        e->args.push_back(arg->clone());
    }
    return e;
}

void FnCallExpr::accept(ASTVisitor& v) {
    v.visit(*this);
}

int precedence(const Expr& e) {
    if (dynamic_cast<const NumberExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const StringLiteralExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const LabelLineRefExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const LabelAddrRefExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const VariableExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const ArrayRefExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const SliceExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const BasicFuncCallExpr*>(&e)) {
        return 1;
    }

    if (auto u = dynamic_cast<const UnaryExpr*>(&e)) {
        switch (u->op) {
        case TokenType::Minus:
            return 2;
        default:
            release_assert(0);
        }
    }

    if (auto b = dynamic_cast<const BinaryExpr*>(&e)) {
        switch (b->op) {
        case TokenType::Power:
            return 3;
        case TokenType::Multiply:
        case TokenType::Divide:
        case TokenType::IntDivide:
        case TokenType::MOD:
            return 4;
        case TokenType::Plus:
        case TokenType::Minus:
            return 5;
        case TokenType::Equal:
        case TokenType::Less:
        case TokenType::Greater:
        case TokenType::LessEqual:
        case TokenType::GreaterEqual:
        case TokenType::NotEqual:
            return 6;
        case TokenType::AND:
        case TokenType::OR:
        case TokenType::NOT:
            return 7;
        default:
            release_assert(0);
        }
    }

    release_assert(0);
    return 99; // not reached
}

