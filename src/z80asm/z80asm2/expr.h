//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include <vector>

// Evaluate a C-style constant expression starting at p.
// Advances p to the first character after the parsed expression.
// Returns true on success and the evaluated integer
// return false and p unchanged on failure.
bool eval_const_expr(const TokensLine& line, unsigned& i, int& value);

class Expr {
public:
    Expr() = default;
    void clear();

    // if silent, no errors are issued
    void set_silent(bool silent) {
        silent_ = silent;
    }

    // try to parse expression from line at index i
    // returns false and i unchanged if invalid syntax
    // outputs errors if not silent
    bool parse(const TokensLine& line, unsigned& i);

    // try to evaluate previously parsed expression
    // returns false if evaluation failed
    // (e.g. division by zero, undefined symbol)
    // sets flags to tell if expression is defined and/or constant
    bool evaluate(int& out_value);
    bool is_undefined() const {
        return is_undefined_;
    }
    bool is_constant() const {
        return is_constant_;
    }

    // convert the infix expression to a string
    std::string to_string() const;

private:
    struct RPNItem {
        enum Kind { Value, Op, Symbol } kind = Kind::Value;
        int value = 0;                      // valid if kind == Value
        TokenType op = TokenType::EndOfFile;// valid if kind == Op
        bool unary = false;                 // valid if kind == Op
        std::string name;                   // valid if kind == Symbol
    };

    struct RPNOp {
        TokenType op = TokenType::EndOfFile;
        bool unary = false;
    };

    bool silent_ = false;
    bool is_undefined_ = false;
    bool is_constant_ = true;
    TokensLine line_;
    std::vector<RPNItem> rpn_items_;

    bool try_parse(const TokensLine& line, unsigned& i,
                   std::vector<RPNItem>& out);
    void collapse_ops_while(std::vector<RPNOp>& ops,
                            const RPNOp& incoming, std::vector<RPNItem>& out);
};
