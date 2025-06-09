//-----------------------------------------------------------------------------
// z80asm
// Expression operators
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "operator.h"
#include <cassert>
using namespace std;

const unordered_map<Operator, OperatorInfo> OperatorTable::table = {
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

string to_string(Operator op) {
    static unordered_map<Operator, string> operators = {
        //@@BEGIN: operator_text
        { Operator::BIN_AND, "&" },
        { Operator::BIN_NOT, "~" },
        { Operator::BIN_OR, "|" },
        { Operator::BIN_XOR, "^" },
        { Operator::DIV, "/" },
        { Operator::EQ, "=" },
        { Operator::GE, ">=" },
        { Operator::GT, ">" },
        { Operator::LE, "<=" },
        { Operator::LOG_AND, "&&" },
        { Operator::LOG_NOT, "!" },
        { Operator::LOG_OR, "||" },
        { Operator::LOG_XOR, "^^" },
        { Operator::LSHIFT, "<<" },
        { Operator::LT, "<" },
        { Operator::MINUS, "-" },
        { Operator::MOD, "%" },
        { Operator::MULT, "*" },
        { Operator::NE, "<>" },
        { Operator::NONE, "" },
        { Operator::PLUS, "+" },
        { Operator::POWER, "**" },
        { Operator::RSHIFT, ">>" },
        { Operator::TERNARY, "?:" },
        { Operator::UMINUS, "-" },
        { Operator::UPLUS, "+" },
        //@@END
    };

    auto it = operators.find(op);
    if (it == operators.end())
        return "";
    else
        return it->second;
}

const OperatorInfo& OperatorTable::get_info(Operator op) {
    auto it = table.find(op);
    if (it == table.end())
        assert(false && "Unknown operator");
    return it->second;
}

