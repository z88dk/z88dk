//-----------------------------------------------------------------------------
// z80asm
// Line parser
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scanner.h"
#include "token.h"
#include <string>
#include <vector>
using namespace std;

class Expr;

class LineParser {
public:
    bool parse_line(const string& line);

private:
    struct NameValuePair {
        string name;
        int value{ 0 };
    };

    struct Elem {
        Token token;
        Expr* expr{ nullptr };
        bool const_expr{ false };
        bool const_expr_if{ false };
        int const_value{ 0 };
        vector<string> ident_list;
        vector<NameValuePair> ident_value_list;

        Elem() = default;
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

    bool collect_ident(string& name);
    bool collect_optional_const_assignment(int& value);
    bool collect_ident_list(vector<string>& names);
    bool collect_const_assign_list(vector<NameValuePair>& nv_list);

    //@@BEGIN:actions_decl
    void action_align_const_expr_comma_const_expr();
    void action_align_const_expr();
    void action_assert_const_expr_if();
    void action_assert_const_expr_if_comma_str();
    void action_assume_const_expr();
    void action_binary_raw_str();
    void action_define_const_assign_list();
    void action_extern_ident_list();
    void action_global_ident_list();
    void action_incbin_raw_str();
    void action_org_const_expr();
    void action_public_ident_list();
    void action_section_ident();
    void action_ident_colon();
    void action_ident_equ_expr();
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
    void action_ld_ix_comma_expr();
    void action_ld_iy_comma_expr();
    void action_jp_expr();
    //@@END

    // state in the parsing state machine
    struct State {
        unordered_map<Keyword, int> keyword_next;
        unordered_map<TType, int>	ttype_next;
        void(LineParser::* action)();
    };

    static State m_states[];
};

