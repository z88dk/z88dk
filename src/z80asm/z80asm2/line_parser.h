//-----------------------------------------------------------------------------
// z80asm
// Line parser
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
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

    struct NameExprPair {
        string name;
        Expr expr;

        NameExprPair() = default;

        NameExprPair(const NameExprPair& other) {
            name = other.name;
            expr = other.expr;
        }

        NameExprPair& operator=(const NameExprPair& other) {
            if (&other != this) {
                name = other.name;
                expr = other.expr;
            }
            return *this;
        }

        virtual ~NameExprPair() {
        }
        
    };

    struct Elem {
        Token token;
        Expr expr;
        bool const_expr{ false };
        bool const_expr_if{ false };
        int const_value{ 0 };
        vector<string> ident_list;
        vector<NameValuePair> ident_value_list;
        vector<NameExprPair> ident_expr_list;
        vector<Expr> exprs;

        Elem() = default;

        Elem(const Elem& other)
            : token(other.token)
            , expr(other.expr)
            , const_expr(other.const_expr)
            , const_expr_if(other.const_expr_if)
            , const_value(other.const_value)
            , ident_list(other.ident_list)
            , ident_value_list(other.ident_value_list)
            , ident_expr_list(other.ident_expr_list)
            , exprs(other.exprs) {
        }

        Elem& operator=(const Elem& other) {
            if (&other != this) {
                token = other.token;
                expr = other.expr;
                const_expr = other.const_expr;
                const_expr_if = other.const_expr_if;
                const_value = other.const_value;
                ident_list = other.ident_list;
                ident_value_list = other.ident_value_list;
                ident_expr_list = other.ident_expr_list;
                exprs = other.exprs;
            }
            return *this;
        }

        virtual ~Elem() {
        }
    };

    struct Elems {
        vector<Elem> elems;

        Elems() = default;

        Elems(const Elems& other) {
            for (auto& elem : other.elems) {
                elems.push_back(elem);
            }
        }

        Elems& operator=(const Elems& other) {
            if (&other != this) {
                elems.clear();
                for (auto& elem : other.elems) {
                    elems.push_back(elem);
                }
            }
            return *this;
        }

        virtual ~Elems() {
            elems.clear();
        }

        auto begin() { return elems.begin(); }
        auto end() { return elems.end(); }
        auto cbegin() const { return elems.cbegin(); }
        auto cend() const { return elems.cend(); }
        auto size() const { return elems.size(); }
    };

    enum class LineState {
        MAIN,
        DEFGROUP1,
        DEFGROUP2,
        DEFGROUP3,
    };

    // LineParser members
    LineState m_line_state{ LineState::MAIN };
    Scanner m_in;   // input tokens
    Elems m_elems;  // synthatic elements
    int m_defgroup_id{ 0 };

    struct ParseQueueElem {
        int state{ 0 };
        int in_pos{ 0 };
        Elems elems;
    };

    bool parse_main();
    bool parse_defgroup();

    bool collect_ident(string& name);
    bool collect_optional_const_assignment(int& value, int default_value = 1);
    bool collect_ident_list(vector<string>& names);
    bool collect_const_assign_list(vector<NameValuePair>& nv_list);
    bool collect_byte_or_string(vector<Expr>& exprs);
    bool collect_byte_list(vector<Expr>& exprs);
    bool collect_expr_list(vector<Expr>& exprs);
    bool collect_assign(vector<NameExprPair>& ne_list);
    bool collect_assign_list(vector<NameExprPair>& ne_list);

    //@@BEGIN:actions_decl
    void action_align_const_expr_comma_const_expr();
    void action_align_const_expr();
    void action_assert_const_expr_if();
    void action_assert_const_expr_if_comma_str();
    void action_assume_const_expr();
    void action_binary_raw_str();
    void action_define_const_assign_list();
    void action_defb_byte_list();
    void action_db_byte_list();
    void action_defm_byte_list();
    void action_dm_byte_list();
    void action_byte_byte_list();
    void action_defw_expr_list();
    void action_dw_expr_list();
    void action_word_expr_list();
    void action_defdb_expr_list();
    void action_ddb_expr_list();
    void action_defp_expr_list();
    void action_dp_expr_list();
    void action_ptr_expr_list();
    void action_defq_expr_list();
    void action_dq_expr_list();
    void action_dword_expr_list();
    void action_defc_assign_list();
    void action_dc_assign_list();
    void action_extern_ident_list();
    void action_global_ident_list();
    void action_incbin_raw_str();
    void action_org_const_expr();
    void action_public_ident_list();
    void action_section_ident();
    void action_ident_colon();
    void action_ident_equ_expr();
    void action_cu_dot_wait_const_expr_comma_const_expr();
    void action_cu_dot_move_const_expr_comma_const_expr();
    void action_cu_dot_stop();
    void action_cu_dot_nop();
    void action_call_oz_const_expr();
    void action_call_pkg_const_expr();
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
    struct ParserState {
        unordered_map<Keyword, int> keyword_next;
        unordered_map<TType, int>	ttype_next;
        void(LineParser::* action)();
    };

    static ParserState m_states[];
};

