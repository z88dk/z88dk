//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast_expr.h"
#include "release_assert.h"
#include "lexer.h"

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

