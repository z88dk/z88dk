//-----------------------------------------------------------------------------
// z80asm
// Expression operators
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <unordered_map>
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
    static const OperatorInfo& get_info(Operator op);

private:
    static inline const unordered_map<Operator, OperatorInfo> table = {
        //@@BEGIN: operator_info
        { Operator::BIN_AND, { 7, Associativity::Left, Arity::Binary } },
        { Operator::BIN_NOT, { 13, Associativity::Right, Arity::Unary } },
        { Operator::BIN_OR, { 5, Associativity::Left, Arity::Binary } },
        { Operator::BIN_XOR, { 6, Associativity::Left, Arity::Binary } },
        { Operator::DIV, { 12, Associativity::Left, Arity::Binary } },
        { Operator::EQ, { 8, Associativity::Left, Arity::Binary } },
        { Operator::GE, { 9, Associativity::Left, Arity::Binary } },
        { Operator::GT, { 9, Associativity::Left, Arity::Binary } },
        { Operator::LE, { 9, Associativity::Left, Arity::Binary } },
        { Operator::LOG_AND, { 4, Associativity::Left, Arity::Binary } },
        { Operator::LOG_NOT, { 13, Associativity::Right, Arity::Unary } },
        { Operator::LOG_OR, { 2, Associativity::Left, Arity::Binary } },
        { Operator::LOG_XOR, { 3, Associativity::Left, Arity::Binary } },
        { Operator::LSHIFT, { 10, Associativity::Left, Arity::Binary } },
        { Operator::LT, { 9, Associativity::Left, Arity::Binary } },
        { Operator::MINUS, { 11, Associativity::Left, Arity::Binary } },
        { Operator::MOD, { 12, Associativity::Left, Arity::Binary } },
        { Operator::MULT, { 12, Associativity::Left, Arity::Binary } },
        { Operator::NE, { 8, Associativity::Left, Arity::Binary } },
        { Operator::NONE, { 0, Associativity::Left, Arity::Unary } },
        { Operator::PLUS, { 11, Associativity::Left, Arity::Binary } },
        { Operator::POWER, { 14, Associativity::Right, Arity::Binary } },
        { Operator::RSHIFT, { 10, Associativity::Left, Arity::Binary } },
        { Operator::TERNARY, { 1, Associativity::Right, Arity::Ternary } },
        { Operator::UMINUS, { 13, Associativity::Right, Arity::Unary } },
        { Operator::UPLUS, { 13, Associativity::Right, Arity::Unary } },
        //@@END
    };
};

string to_string(Operator op);

