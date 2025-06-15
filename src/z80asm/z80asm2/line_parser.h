//-----------------------------------------------------------------------------
// z80asm
// Line parser
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scanner.h"
#include "token.h"
using namespace std;

class Expr;

class LineParser {
public:
    bool parse_line(const string& line);
    bool parse_define(const string& line);

private:
    struct Elem {
        Token token;
        Expr* expr{ nullptr };
        bool const_expr{ false };
        int const_value{ 0 };

        Elem();
        Elem(const Elem& other);
        Elem& operator=(const Elem& other);
        virtual ~Elem();
    };

    struct Elems {
        vector<Elem> elems;

        Elems();
        Elems(const Elems& other);
        Elems& operator=(const Elems& other);
        virtual ~Elems();
        auto begin() { return elems.begin(); }
        auto end() { return elems.end(); }
        auto cbegin() const { return elems.cbegin(); }
        auto cend() const { return elems.cend(); }
        auto size() const { return elems.size(); }
    };

    Scanner m_in;   // input tokens
    Elems m_elems;  // synthatic elements

    struct ParseQueueElem {
        int state{ 0 };
        int in_pos{ 0 };
        Elems elems;
    };

    //@@BEGIN:actions_decl
    void action_ident_colon();
    void action_ident_equ_expr();
    void action_assume_const_expr();
    void action_nop();
    void action_jr_expr();
    void action_jr_nz_comma_expr();
    void action_jr_z_comma_expr();
    void action_jr_nc_comma_expr();
    void action_jr_c_comma_expr();
    void action_ld_a_comma_expr();
    void action_ld_b_comma_expr();
    void action_ld_c_comma_expr();
    void action_ld_a_comma_lparen_expr_rparen();
    void action_ld_a_comma_a();
    void action_ld_a_comma_b();
    //@@END

    bool parse_define();
    bool parse_name(string& name);
    bool parse_const_expr(int& value);
    bool parse_equal();
    bool parse_comma();
    bool parse_end();

    void action_define(const string& name, int value = 1);

    // state in the parsing state machine
    struct State {
        unordered_map<Keyword, int> keyword_next;
        unordered_map<TType, int>	ttype_next;
        void(LineParser::* action)();
    };

    static State m_states[];
};

