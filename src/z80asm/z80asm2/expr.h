//-----------------------------------------------------------------------------
// z80asm
// Expression
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scanner.h"
#include <string>
using namespace std;

class Symtab;

class Expr {
public:
    enum class Status {
        OK,
        SCAN_FAILED,
        EOL_EXPECTED,
        OPERAND_EXPECTED,
        MISMATCHED_PARENS,
        MISMATCHED_TERNARY,
        INSUFICIENT_OPERANDS,
        TOO_MANY_OPERANDS,
        UNDEFINED_SYMBOL,
    };

    Status get_status() const { return m_status; }

    bool parse(const string& line);
    bool parse(Scanner& in);
    bool eval(int asmpc, Symtab* symtab, int& result);

    string to_string() const;
    string rpn_to_string() const;

    Expr* clone();

private:
    vector<Token> m_infix;
    vector<Token> m_postfix;
    Status m_status{ Status::OK };

    bool is_unary(Scanner& in) const;
    bool to_RPN(Scanner& in);
    bool check_syntax();
};

