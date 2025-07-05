//-----------------------------------------------------------------------------
// z80asm
// Expression operators
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <unordered_map>
#include <stack>
using namespace std;

enum class Operator {
    //@@BEGIN: operator
    NONE,
    BIN_AND,
    BIN_NOT,
    BIN_OR,
    BIN_XOR,
    DIV,
    EQ,
    GE,
    GT,
    LE,
    LOG_AND,
    LOG_NOT,
    LOG_OR,
    LOG_XOR,
    LSHIFT,
    LT,
    MINUS,
    MOD,
    MULT,
    NE,
    PLUS,
    POWER,
    RSHIFT,
    TERNARY,
    UMINUS,
    UPLUS,
    //@@END
};

enum class Associativity {
    Left,
    Right,
};

enum class Arity {
    Unary,
    Binary,
    Ternary,
};

struct OperatorInfo {
    int precedence;
    Associativity associativity;
    Arity arity;
};

class OperatorTable {
public:
    static const OperatorInfo* get_info(Operator op);

private:
    static const unordered_map<Operator, OperatorInfo> table;
};

void do_operator(Operator op, stack<int>& operands);
string to_string(Operator op);

