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
    bool parse(const string& line);

private:
    struct Elem {
        Token token;
        Expr* expr{ nullptr };
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

    // state in the parsing state machine
    struct State {
        unordered_map<Keyword, int> keyword_next;
        unordered_map<TType, int>	ttype_next;
        void(LineParser::* action)();
    };

    static inline State m_states[] = {
        //@@BEGIN: states
        { /* 0:  */
          { {Keyword::ASSUME, 1}, {Keyword::JR, 10}, {Keyword::LD, 29}, {Keyword::NOP, 50}, },
          { {TType::IDENT, 4}, },
          nullptr,
        },
        { /* 1: ASSUME */
          { },
          { {TType::CONST_EXPR, 2}, },
          nullptr,
        },
        { /* 2: ASSUME CONST_EXPR */
          { },
          { {TType::END, 3}, },
          nullptr,
        },
        { /* 3: ASSUME CONST_EXPR END */
          { },
          { },
          &LineParser::action_assume_const_expr,
        },
        { /* 4: IDENT */
          { {Keyword::EQU, 7}, },
          { {TType::COLON, 5}, },
          nullptr,
        },
        { /* 5: IDENT COLON */
          { },
          { {TType::END, 6}, },
          nullptr,
        },
        { /* 6: IDENT COLON END */
          { },
          { },
          &LineParser::action_ident_colon,
        },
        { /* 7: IDENT EQU */
          { },
          { {TType::EXPR, 8}, },
          nullptr,
        },
        { /* 8: IDENT EQU EXPR */
          { },
          { {TType::END, 9}, },
          nullptr,
        },
        { /* 9: IDENT EQU EXPR END */
          { },
          { },
          &LineParser::action_ident_equ_expr,
        },
        { /* 10: JR */
          { {Keyword::C, 11}, {Keyword::NC, 17}, {Keyword::NZ, 21}, {Keyword::Z, 25}, },
          { {TType::EXPR, 15}, },
          nullptr,
        },
        { /* 11: JR C */
          { },
          { {TType::COMMA, 12}, },
          nullptr,
        },
        { /* 12: JR C COMMA */
          { },
          { {TType::EXPR, 13}, },
          nullptr,
        },
        { /* 13: JR C COMMA EXPR */
          { },
          { {TType::END, 14}, },
          nullptr,
        },
        { /* 14: JR C COMMA EXPR END */
          { },
          { },
          &LineParser::action_jr_c_comma_expr,
        },
        { /* 15: JR EXPR */
          { },
          { {TType::END, 16}, },
          nullptr,
        },
        { /* 16: JR EXPR END */
          { },
          { },
          &LineParser::action_jr_expr,
        },
        { /* 17: JR NC */
          { },
          { {TType::COMMA, 18}, },
          nullptr,
        },
        { /* 18: JR NC COMMA */
          { },
          { {TType::EXPR, 19}, },
          nullptr,
        },
        { /* 19: JR NC COMMA EXPR */
          { },
          { {TType::END, 20}, },
          nullptr,
        },
        { /* 20: JR NC COMMA EXPR END */
          { },
          { },
          &LineParser::action_jr_nc_comma_expr,
        },
        { /* 21: JR NZ */
          { },
          { {TType::COMMA, 22}, },
          nullptr,
        },
        { /* 22: JR NZ COMMA */
          { },
          { {TType::EXPR, 23}, },
          nullptr,
        },
        { /* 23: JR NZ COMMA EXPR */
          { },
          { {TType::END, 24}, },
          nullptr,
        },
        { /* 24: JR NZ COMMA EXPR END */
          { },
          { },
          &LineParser::action_jr_nz_comma_expr,
        },
        { /* 25: JR Z */
          { },
          { {TType::COMMA, 26}, },
          nullptr,
        },
        { /* 26: JR Z COMMA */
          { },
          { {TType::EXPR, 27}, },
          nullptr,
        },
        { /* 27: JR Z COMMA EXPR */
          { },
          { {TType::END, 28}, },
          nullptr,
        },
        { /* 28: JR Z COMMA EXPR END */
          { },
          { },
          &LineParser::action_jr_z_comma_expr,
        },
        { /* 29: LD */
          { {Keyword::A, 30}, {Keyword::B, 42}, {Keyword::C, 46}, },
          { },
          nullptr,
        },
        { /* 30: LD A */
          { },
          { {TType::COMMA, 31}, },
          nullptr,
        },
        { /* 31: LD A COMMA */
          { {Keyword::A, 32}, {Keyword::B, 34}, },
          { {TType::EXPR, 36}, {TType::LPAREN, 38}, },
          nullptr,
        },
        { /* 32: LD A COMMA A */
          { },
          { {TType::END, 33}, },
          nullptr,
        },
        { /* 33: LD A COMMA A END */
          { },
          { },
          &LineParser::action_ld_a_comma_a,
        },
        { /* 34: LD A COMMA B */
          { },
          { {TType::END, 35}, },
          nullptr,
        },
        { /* 35: LD A COMMA B END */
          { },
          { },
          &LineParser::action_ld_a_comma_b,
        },
        { /* 36: LD A COMMA EXPR */
          { },
          { {TType::END, 37}, },
          nullptr,
        },
        { /* 37: LD A COMMA EXPR END */
          { },
          { },
          &LineParser::action_ld_a_comma_expr,
        },
        { /* 38: LD A COMMA LPAREN */
          { },
          { {TType::EXPR, 39}, },
          nullptr,
        },
        { /* 39: LD A COMMA LPAREN EXPR */
          { },
          { {TType::RPAREN, 40}, },
          nullptr,
        },
        { /* 40: LD A COMMA LPAREN EXPR RPAREN */
          { },
          { {TType::END, 41}, },
          nullptr,
        },
        { /* 41: LD A COMMA LPAREN EXPR RPAREN END */
          { },
          { },
          &LineParser::action_ld_a_comma_lparen_expr_rparen,
        },
        { /* 42: LD B */
          { },
          { {TType::COMMA, 43}, },
          nullptr,
        },
        { /* 43: LD B COMMA */
          { },
          { {TType::EXPR, 44}, },
          nullptr,
        },
        { /* 44: LD B COMMA EXPR */
          { },
          { {TType::END, 45}, },
          nullptr,
        },
        { /* 45: LD B COMMA EXPR END */
          { },
          { },
          &LineParser::action_ld_b_comma_expr,
        },
        { /* 46: LD C */
          { },
          { {TType::COMMA, 47}, },
          nullptr,
        },
        { /* 47: LD C COMMA */
          { },
          { {TType::EXPR, 48}, },
          nullptr,
        },
        { /* 48: LD C COMMA EXPR */
          { },
          { {TType::END, 49}, },
          nullptr,
        },
        { /* 49: LD C COMMA EXPR END */
          { },
          { },
          &LineParser::action_ld_c_comma_expr,
        },
        { /* 50: NOP */
          { },
          { {TType::END, 51}, },
          nullptr,
        },
        { /* 51: NOP END */
          { },
          { },
          &LineParser::action_nop,
        },
        //@@END
    };
};

