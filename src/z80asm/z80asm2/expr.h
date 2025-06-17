//-----------------------------------------------------------------------------
// z80asm
// Expression
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scanner.h"
#include <string>
#include <vector>
using namespace std;

class Instr;
class Symtab;

class Expr {
public:
    void clear();
    bool parse(const string& line);
    bool parse(Scanner& in, bool silent);
    bool eval_const(Symtab* symtab, int& result);
    bool eval_instr(Symtab* symtab, Instr* asmpc, Instr*& result);
    bool eval(Symtab* symtab, int asmpc, int& result, bool silent = false);
    string to_string() const;
    string rpn_to_string() const;

    Expr* clone() const;

private:
    vector<Token> m_infix;
    vector<Token> m_postfix;
    int m_pos0{ 0 };

    bool is_unary(Scanner& in) const;
    bool to_RPN(Scanner& in, bool silent);
    bool check_syntax(bool silent);
};
