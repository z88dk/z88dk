//-----------------------------------------------------------------------------
// z80asm
// Expression
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "location.h"
#include "scanner.h"
#include <string>
#include <vector>
using namespace std;

class Instr;
class Symtab;
class Section;

class Expr {
public:
    Expr();
    Expr(const Expr& other);
    Expr& operator=(const Expr& other);
    void clear();
    bool empty() const;
    const Location& location() const { return m_location; }
    bool parse(const string& line);
    bool parse(Scanner& in, bool silent);
    void lookup_symbols();
    void lookup_symbols_if();
    bool eval_const(int& value) const;
    bool eval_instr(Instr*& instr) const;
    bool eval(int& result, bool silent = false) const;
    bool eval_local_jr_distance(int& distance) const;
    string to_string() const;
    string rpn_to_string() const;

#ifdef UNIT_TESTS
    static void test();
#endif

private:
    vector<Token> m_infix;
    vector<Token> m_postfix;
    int m_pos0{ 0 };
    Location m_location;
    Instr* m_asmpc{ nullptr };

    void lookup_symbols(bool touched);

    enum class Result {
        Undefined,
        Constant,
        Address,
        Computed,
    };

    Result combine_results(Result r1) const;
    Result combine_results(Result r1, Result r2) const;
    Result combine_results(Result r1, Result r2, Result r3) const;

    struct ValueResult {
        int value{ 0 };
        Result result{ Result::Undefined };
        Section* section{ nullptr };
        Instr* instr{ nullptr };

        ValueResult() = default;
        ValueResult(int v, Result r, Section* s = nullptr, Instr* i = nullptr)
            : value(v), result(r), section(s), instr(i) {
        }
        bool operator==(const ValueResult& other) {
            return value == other.value && result == other.result &&
                section == other.section && instr == other.instr;
        }
    };

    bool is_unary(Scanner& in) const;
    bool to_RPN(Scanner& in, bool silent);
    bool check_RPN_syntax(bool silent);
    ValueResult check_eval() const;
};
