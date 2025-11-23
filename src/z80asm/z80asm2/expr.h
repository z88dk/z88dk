//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include <vector>

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
    bool is_extern() const {
        return is_extern_;
    }
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
        TokenType op = TokenType::EndOfLine;// valid if kind == Op
        bool unary = false;                 // valid if kind == Op
        std::string name;                   // valid if kind == Symbol
    };

    struct RPNOp {
        TokenType op = TokenType::EndOfLine;
        bool unary = false;
    };

    bool silent_ = false;
    bool is_extern_ = false;
    bool is_undefined_ = false;
    bool is_constant_ = true;
    TokensLine line_;
    std::vector<RPNItem> rpn_items_;

    static int prec(TokenType type, bool unary);
    static bool is_right_assoc(TokenType type, bool unary);
    static bool is_operator_token(TokenType tt);
    static bool can_start_operand_sequence(const TokensLine& line, unsigned j);
    bool try_parse(const TokensLine& line, unsigned& i,
                   std::vector<RPNItem>& out);
    void collapse_ops_while(std::vector<RPNOp>& ops,
                            const RPNOp& incoming, std::vector<RPNItem>& out);
};
