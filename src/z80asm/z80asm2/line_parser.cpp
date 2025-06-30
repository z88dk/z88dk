//-----------------------------------------------------------------------------
// z80asm
// Line parser
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "line_parser.h"
#include "obj_module.h"
#include "options.h"
#include "token.h"
using namespace std;

LineParser::State LineParser::m_states[] = {
    //@@BEGIN: states
    { // 0: 
      { {Keyword::ALIGN, 1}, {Keyword::ASSERT, 7}, {Keyword::ASSUME, 13}, {Keyword::BINARY, 16}, {Keyword::BYTE, 19}, {Keyword::CALL_OZ, 22}, {Keyword::CALL_PKG, 25}, {Keyword::CU, 28}, {Keyword::DB, 44}, {Keyword::DDB, 47}, {Keyword::DEFB, 50}, {Keyword::DEFDB, 53}, {Keyword::DEFINE, 56}, {Keyword::DEFM, 59}, {Keyword::DEFP, 62}, {Keyword::DEFQ, 65}, {Keyword::DEFW, 68}, {Keyword::DM, 71}, {Keyword::DP, 74}, {Keyword::DQ, 77}, {Keyword::DW, 80}, {Keyword::DWORD, 83}, {Keyword::EXTERN, 86}, {Keyword::GLOBAL, 89}, {Keyword::INCBIN, 98}, {Keyword::JP, 101}, {Keyword::JR, 104}, {Keyword::LD, 123}, {Keyword::NOP, 152}, {Keyword::ORG, 154}, {Keyword::PTR, 157}, {Keyword::PUBLIC, 160}, {Keyword::SECTION, 163}, {Keyword::WORD, 166}, },
      { {TType::IDENT, 92}, },
      nullptr,
    },
    { // 1: ALIGN
      { },
      { {TType::CONST_EXPR, 2}, },
      nullptr,
    },
    { // 2: ALIGN CONST_EXPR
      { },
      { {TType::COMMA, 3}, {TType::END, 6}, },
      nullptr,
    },
    { // 3: ALIGN CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 4}, },
      nullptr,
    },
    { // 4: ALIGN CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 5}, },
      nullptr,
    },
    { // 5: ALIGN CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_align_const_expr_comma_const_expr,
    },
    { // 6: ALIGN CONST_EXPR END
      { },
      { },
      &LineParser::action_align_const_expr,
    },
    { // 7: ASSERT
      { },
      { {TType::CONST_EXPR_IF, 8}, },
      nullptr,
    },
    { // 8: ASSERT CONST_EXPR_IF
      { },
      { {TType::COMMA, 9}, {TType::END, 12}, },
      nullptr,
    },
    { // 9: ASSERT CONST_EXPR_IF COMMA
      { },
      { {TType::STR, 10}, },
      nullptr,
    },
    { // 10: ASSERT CONST_EXPR_IF COMMA STR
      { },
      { {TType::END, 11}, },
      nullptr,
    },
    { // 11: ASSERT CONST_EXPR_IF COMMA STR END
      { },
      { },
      &LineParser::action_assert_const_expr_if_comma_str,
    },
    { // 12: ASSERT CONST_EXPR_IF END
      { },
      { },
      &LineParser::action_assert_const_expr_if,
    },
    { // 13: ASSUME
      { },
      { {TType::CONST_EXPR, 14}, },
      nullptr,
    },
    { // 14: ASSUME CONST_EXPR
      { },
      { {TType::END, 15}, },
      nullptr,
    },
    { // 15: ASSUME CONST_EXPR END
      { },
      { },
      &LineParser::action_assume_const_expr,
    },
    { // 16: BINARY
      { },
      { {TType::RAW_STR, 17}, },
      nullptr,
    },
    { // 17: BINARY RAW_STR
      { },
      { {TType::END, 18}, },
      nullptr,
    },
    { // 18: BINARY RAW_STR END
      { },
      { },
      &LineParser::action_binary_raw_str,
    },
    { // 19: BYTE
      { },
      { {TType::BYTE_LIST, 20}, },
      nullptr,
    },
    { // 20: BYTE BYTE_LIST
      { },
      { {TType::END, 21}, },
      nullptr,
    },
    { // 21: BYTE BYTE_LIST END
      { },
      { },
      &LineParser::action_byte_byte_list,
    },
    { // 22: CALL_OZ
      { },
      { {TType::CONST_EXPR, 23}, },
      nullptr,
    },
    { // 23: CALL_OZ CONST_EXPR
      { },
      { {TType::END, 24}, },
      nullptr,
    },
    { // 24: CALL_OZ CONST_EXPR END
      { },
      { },
      &LineParser::action_call_oz_const_expr,
    },
    { // 25: CALL_PKG
      { },
      { {TType::CONST_EXPR, 26}, },
      nullptr,
    },
    { // 26: CALL_PKG CONST_EXPR
      { },
      { {TType::END, 27}, },
      nullptr,
    },
    { // 27: CALL_PKG CONST_EXPR END
      { },
      { },
      &LineParser::action_call_pkg_const_expr,
    },
    { // 28: CU
      { },
      { {TType::DOT, 29}, },
      nullptr,
    },
    { // 29: CU DOT
      { {Keyword::MOVE, 30}, {Keyword::NOP, 35}, {Keyword::STOP, 37}, {Keyword::WAIT, 39}, },
      { },
      nullptr,
    },
    { // 30: CU DOT MOVE
      { },
      { {TType::CONST_EXPR, 31}, },
      nullptr,
    },
    { // 31: CU DOT MOVE CONST_EXPR
      { },
      { {TType::COMMA, 32}, },
      nullptr,
    },
    { // 32: CU DOT MOVE CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 33}, },
      nullptr,
    },
    { // 33: CU DOT MOVE CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 34}, },
      nullptr,
    },
    { // 34: CU DOT MOVE CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_cu_dot_move_const_expr_comma_const_expr,
    },
    { // 35: CU DOT NOP
      { },
      { {TType::END, 36}, },
      nullptr,
    },
    { // 36: CU DOT NOP END
      { },
      { },
      &LineParser::action_cu_dot_nop,
    },
    { // 37: CU DOT STOP
      { },
      { {TType::END, 38}, },
      nullptr,
    },
    { // 38: CU DOT STOP END
      { },
      { },
      &LineParser::action_cu_dot_stop,
    },
    { // 39: CU DOT WAIT
      { },
      { {TType::CONST_EXPR, 40}, },
      nullptr,
    },
    { // 40: CU DOT WAIT CONST_EXPR
      { },
      { {TType::COMMA, 41}, },
      nullptr,
    },
    { // 41: CU DOT WAIT CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 42}, },
      nullptr,
    },
    { // 42: CU DOT WAIT CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 43}, },
      nullptr,
    },
    { // 43: CU DOT WAIT CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_cu_dot_wait_const_expr_comma_const_expr,
    },
    { // 44: DB
      { },
      { {TType::BYTE_LIST, 45}, },
      nullptr,
    },
    { // 45: DB BYTE_LIST
      { },
      { {TType::END, 46}, },
      nullptr,
    },
    { // 46: DB BYTE_LIST END
      { },
      { },
      &LineParser::action_db_byte_list,
    },
    { // 47: DDB
      { },
      { {TType::EXPR_LIST, 48}, },
      nullptr,
    },
    { // 48: DDB EXPR_LIST
      { },
      { {TType::END, 49}, },
      nullptr,
    },
    { // 49: DDB EXPR_LIST END
      { },
      { },
      &LineParser::action_ddb_expr_list,
    },
    { // 50: DEFB
      { },
      { {TType::BYTE_LIST, 51}, },
      nullptr,
    },
    { // 51: DEFB BYTE_LIST
      { },
      { {TType::END, 52}, },
      nullptr,
    },
    { // 52: DEFB BYTE_LIST END
      { },
      { },
      &LineParser::action_defb_byte_list,
    },
    { // 53: DEFDB
      { },
      { {TType::EXPR_LIST, 54}, },
      nullptr,
    },
    { // 54: DEFDB EXPR_LIST
      { },
      { {TType::END, 55}, },
      nullptr,
    },
    { // 55: DEFDB EXPR_LIST END
      { },
      { },
      &LineParser::action_defdb_expr_list,
    },
    { // 56: DEFINE
      { },
      { {TType::CONST_ASSIGN_LIST, 57}, },
      nullptr,
    },
    { // 57: DEFINE CONST_ASSIGN_LIST
      { },
      { {TType::END, 58}, },
      nullptr,
    },
    { // 58: DEFINE CONST_ASSIGN_LIST END
      { },
      { },
      &LineParser::action_define_const_assign_list,
    },
    { // 59: DEFM
      { },
      { {TType::BYTE_LIST, 60}, },
      nullptr,
    },
    { // 60: DEFM BYTE_LIST
      { },
      { {TType::END, 61}, },
      nullptr,
    },
    { // 61: DEFM BYTE_LIST END
      { },
      { },
      &LineParser::action_defm_byte_list,
    },
    { // 62: DEFP
      { },
      { {TType::EXPR_LIST, 63}, },
      nullptr,
    },
    { // 63: DEFP EXPR_LIST
      { },
      { {TType::END, 64}, },
      nullptr,
    },
    { // 64: DEFP EXPR_LIST END
      { },
      { },
      &LineParser::action_defp_expr_list,
    },
    { // 65: DEFQ
      { },
      { {TType::EXPR_LIST, 66}, },
      nullptr,
    },
    { // 66: DEFQ EXPR_LIST
      { },
      { {TType::END, 67}, },
      nullptr,
    },
    { // 67: DEFQ EXPR_LIST END
      { },
      { },
      &LineParser::action_defq_expr_list,
    },
    { // 68: DEFW
      { },
      { {TType::EXPR_LIST, 69}, },
      nullptr,
    },
    { // 69: DEFW EXPR_LIST
      { },
      { {TType::END, 70}, },
      nullptr,
    },
    { // 70: DEFW EXPR_LIST END
      { },
      { },
      &LineParser::action_defw_expr_list,
    },
    { // 71: DM
      { },
      { {TType::BYTE_LIST, 72}, },
      nullptr,
    },
    { // 72: DM BYTE_LIST
      { },
      { {TType::END, 73}, },
      nullptr,
    },
    { // 73: DM BYTE_LIST END
      { },
      { },
      &LineParser::action_dm_byte_list,
    },
    { // 74: DP
      { },
      { {TType::EXPR_LIST, 75}, },
      nullptr,
    },
    { // 75: DP EXPR_LIST
      { },
      { {TType::END, 76}, },
      nullptr,
    },
    { // 76: DP EXPR_LIST END
      { },
      { },
      &LineParser::action_dp_expr_list,
    },
    { // 77: DQ
      { },
      { {TType::EXPR_LIST, 78}, },
      nullptr,
    },
    { // 78: DQ EXPR_LIST
      { },
      { {TType::END, 79}, },
      nullptr,
    },
    { // 79: DQ EXPR_LIST END
      { },
      { },
      &LineParser::action_dq_expr_list,
    },
    { // 80: DW
      { },
      { {TType::EXPR_LIST, 81}, },
      nullptr,
    },
    { // 81: DW EXPR_LIST
      { },
      { {TType::END, 82}, },
      nullptr,
    },
    { // 82: DW EXPR_LIST END
      { },
      { },
      &LineParser::action_dw_expr_list,
    },
    { // 83: DWORD
      { },
      { {TType::EXPR_LIST, 84}, },
      nullptr,
    },
    { // 84: DWORD EXPR_LIST
      { },
      { {TType::END, 85}, },
      nullptr,
    },
    { // 85: DWORD EXPR_LIST END
      { },
      { },
      &LineParser::action_dword_expr_list,
    },
    { // 86: EXTERN
      { },
      { {TType::IDENT_LIST, 87}, },
      nullptr,
    },
    { // 87: EXTERN IDENT_LIST
      { },
      { {TType::END, 88}, },
      nullptr,
    },
    { // 88: EXTERN IDENT_LIST END
      { },
      { },
      &LineParser::action_extern_ident_list,
    },
    { // 89: GLOBAL
      { },
      { {TType::IDENT_LIST, 90}, },
      nullptr,
    },
    { // 90: GLOBAL IDENT_LIST
      { },
      { {TType::END, 91}, },
      nullptr,
    },
    { // 91: GLOBAL IDENT_LIST END
      { },
      { },
      &LineParser::action_global_ident_list,
    },
    { // 92: IDENT
      { {Keyword::EQU, 95}, },
      { {TType::COLON, 93}, },
      nullptr,
    },
    { // 93: IDENT COLON
      { },
      { {TType::END, 94}, },
      nullptr,
    },
    { // 94: IDENT COLON END
      { },
      { },
      &LineParser::action_ident_colon,
    },
    { // 95: IDENT EQU
      { },
      { {TType::EXPR, 96}, },
      nullptr,
    },
    { // 96: IDENT EQU EXPR
      { },
      { {TType::END, 97}, },
      nullptr,
    },
    { // 97: IDENT EQU EXPR END
      { },
      { },
      &LineParser::action_ident_equ_expr,
    },
    { // 98: INCBIN
      { },
      { {TType::RAW_STR, 99}, },
      nullptr,
    },
    { // 99: INCBIN RAW_STR
      { },
      { {TType::END, 100}, },
      nullptr,
    },
    { // 100: INCBIN RAW_STR END
      { },
      { },
      &LineParser::action_incbin_raw_str,
    },
    { // 101: JP
      { },
      { {TType::EXPR, 102}, },
      nullptr,
    },
    { // 102: JP EXPR
      { },
      { {TType::END, 103}, },
      nullptr,
    },
    { // 103: JP EXPR END
      { },
      { },
      &LineParser::action_jp_expr,
    },
    { // 104: JR
      { {Keyword::C, 105}, {Keyword::NC, 111}, {Keyword::NZ, 115}, {Keyword::Z, 119}, },
      { {TType::EXPR, 109}, },
      nullptr,
    },
    { // 105: JR C
      { },
      { {TType::COMMA, 106}, },
      nullptr,
    },
    { // 106: JR C COMMA
      { },
      { {TType::EXPR, 107}, },
      nullptr,
    },
    { // 107: JR C COMMA EXPR
      { },
      { {TType::END, 108}, },
      nullptr,
    },
    { // 108: JR C COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_c_comma_expr,
    },
    { // 109: JR EXPR
      { },
      { {TType::END, 110}, },
      nullptr,
    },
    { // 110: JR EXPR END
      { },
      { },
      &LineParser::action_jr_expr,
    },
    { // 111: JR NC
      { },
      { {TType::COMMA, 112}, },
      nullptr,
    },
    { // 112: JR NC COMMA
      { },
      { {TType::EXPR, 113}, },
      nullptr,
    },
    { // 113: JR NC COMMA EXPR
      { },
      { {TType::END, 114}, },
      nullptr,
    },
    { // 114: JR NC COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nc_comma_expr,
    },
    { // 115: JR NZ
      { },
      { {TType::COMMA, 116}, },
      nullptr,
    },
    { // 116: JR NZ COMMA
      { },
      { {TType::EXPR, 117}, },
      nullptr,
    },
    { // 117: JR NZ COMMA EXPR
      { },
      { {TType::END, 118}, },
      nullptr,
    },
    { // 118: JR NZ COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nz_comma_expr,
    },
    { // 119: JR Z
      { },
      { {TType::COMMA, 120}, },
      nullptr,
    },
    { // 120: JR Z COMMA
      { },
      { {TType::EXPR, 121}, },
      nullptr,
    },
    { // 121: JR Z COMMA EXPR
      { },
      { {TType::END, 122}, },
      nullptr,
    },
    { // 122: JR Z COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_z_comma_expr,
    },
    { // 123: LD
      { {Keyword::A, 124}, {Keyword::B, 136}, {Keyword::C, 140}, {Keyword::IX, 144}, {Keyword::IY, 148}, },
      { },
      nullptr,
    },
    { // 124: LD A
      { },
      { {TType::COMMA, 125}, },
      nullptr,
    },
    { // 125: LD A COMMA
      { {Keyword::A, 126}, {Keyword::B, 128}, },
      { {TType::EXPR, 130}, {TType::LPAREN, 132}, },
      nullptr,
    },
    { // 126: LD A COMMA A
      { },
      { {TType::END, 127}, },
      nullptr,
    },
    { // 127: LD A COMMA A END
      { },
      { },
      &LineParser::action_ld_a_comma_a,
    },
    { // 128: LD A COMMA B
      { },
      { {TType::END, 129}, },
      nullptr,
    },
    { // 129: LD A COMMA B END
      { },
      { },
      &LineParser::action_ld_a_comma_b,
    },
    { // 130: LD A COMMA EXPR
      { },
      { {TType::END, 131}, },
      nullptr,
    },
    { // 131: LD A COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_a_comma_expr,
    },
    { // 132: LD A COMMA LPAREN
      { },
      { {TType::EXPR, 133}, },
      nullptr,
    },
    { // 133: LD A COMMA LPAREN EXPR
      { },
      { {TType::RPAREN, 134}, },
      nullptr,
    },
    { // 134: LD A COMMA LPAREN EXPR RPAREN
      { },
      { {TType::END, 135}, },
      nullptr,
    },
    { // 135: LD A COMMA LPAREN EXPR RPAREN END
      { },
      { },
      &LineParser::action_ld_a_comma_lparen_expr_rparen,
    },
    { // 136: LD B
      { },
      { {TType::COMMA, 137}, },
      nullptr,
    },
    { // 137: LD B COMMA
      { },
      { {TType::EXPR, 138}, },
      nullptr,
    },
    { // 138: LD B COMMA EXPR
      { },
      { {TType::END, 139}, },
      nullptr,
    },
    { // 139: LD B COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_b_comma_expr,
    },
    { // 140: LD C
      { },
      { {TType::COMMA, 141}, },
      nullptr,
    },
    { // 141: LD C COMMA
      { },
      { {TType::EXPR, 142}, },
      nullptr,
    },
    { // 142: LD C COMMA EXPR
      { },
      { {TType::END, 143}, },
      nullptr,
    },
    { // 143: LD C COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_c_comma_expr,
    },
    { // 144: LD IX
      { },
      { {TType::COMMA, 145}, },
      nullptr,
    },
    { // 145: LD IX COMMA
      { },
      { {TType::EXPR, 146}, },
      nullptr,
    },
    { // 146: LD IX COMMA EXPR
      { },
      { {TType::END, 147}, },
      nullptr,
    },
    { // 147: LD IX COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_ix_comma_expr,
    },
    { // 148: LD IY
      { },
      { {TType::COMMA, 149}, },
      nullptr,
    },
    { // 149: LD IY COMMA
      { },
      { {TType::EXPR, 150}, },
      nullptr,
    },
    { // 150: LD IY COMMA EXPR
      { },
      { {TType::END, 151}, },
      nullptr,
    },
    { // 151: LD IY COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_iy_comma_expr,
    },
    { // 152: NOP
      { },
      { {TType::END, 153}, },
      nullptr,
    },
    { // 153: NOP END
      { },
      { },
      &LineParser::action_nop,
    },
    { // 154: ORG
      { },
      { {TType::CONST_EXPR, 155}, },
      nullptr,
    },
    { // 155: ORG CONST_EXPR
      { },
      { {TType::END, 156}, },
      nullptr,
    },
    { // 156: ORG CONST_EXPR END
      { },
      { },
      &LineParser::action_org_const_expr,
    },
    { // 157: PTR
      { },
      { {TType::EXPR_LIST, 158}, },
      nullptr,
    },
    { // 158: PTR EXPR_LIST
      { },
      { {TType::END, 159}, },
      nullptr,
    },
    { // 159: PTR EXPR_LIST END
      { },
      { },
      &LineParser::action_ptr_expr_list,
    },
    { // 160: PUBLIC
      { },
      { {TType::IDENT_LIST, 161}, },
      nullptr,
    },
    { // 161: PUBLIC IDENT_LIST
      { },
      { {TType::END, 162}, },
      nullptr,
    },
    { // 162: PUBLIC IDENT_LIST END
      { },
      { },
      &LineParser::action_public_ident_list,
    },
    { // 163: SECTION
      { },
      { {TType::IDENT, 164}, },
      nullptr,
    },
    { // 164: SECTION IDENT
      { },
      { {TType::END, 165}, },
      nullptr,
    },
    { // 165: SECTION IDENT END
      { },
      { },
      &LineParser::action_section_ident,
    },
    { // 166: WORD
      { },
      { {TType::EXPR_LIST, 167}, },
      nullptr,
    },
    { // 167: WORD EXPR_LIST
      { },
      { {TType::END, 168}, },
      nullptr,
    },
    { // 168: WORD EXPR_LIST END
      { },
      { },
      &LineParser::action_word_expr_list,
    },
    //@@END
};

LineParser::Elem::Elem(const Elem& other)
    : token(other.token)
    , expr(other.expr ? other.expr->clone() : nullptr)
    , const_expr(other.const_expr)
    , const_expr_if(other.const_expr_if)
    , const_value(other.const_value)
    , ident_list(other.ident_list)
    , ident_value_list(other.ident_value_list) {
    for (auto& expr : other.exprs)
        exprs.push_back(expr->clone());
}

LineParser::Elem& LineParser::Elem::operator=(const Elem& other) {
    if (&other != this) {
        token = other.token;
        expr = other.expr->clone();
        const_expr = other.const_expr;
        const_expr_if = other.const_expr_if;
        const_value = other.const_value;
        ident_list = other.ident_list;
        ident_value_list = other.ident_value_list;
        for (auto& expr : other.exprs)
            exprs.push_back(expr->clone());
    }
    return *this;
}

LineParser::Elem::~Elem() {
    delete expr;
    for (auto& e : exprs)
        delete e;
}

LineParser::Elems::Elems() {}

LineParser::Elems::Elems(const Elems& other) {
    for (auto& elem : other.elems) {
        elems.push_back(elem);
    }
}

LineParser::Elems& LineParser::Elems::operator=(const Elems& other) {
    if (&other != this) {
        elems.clear();
        for (auto& elem : other.elems) {
            elems.push_back(elem);
        }
    }
    return *this;
}

LineParser::Elems::~Elems() {
    elems.clear();
}

bool LineParser::parse_line(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed

    if (m_in.peek().is(TType::END)) 
        return true;        // empty line

    vector<ParseQueueElem> parse_queue;

    // add initial state
    ParseQueueElem queue_elem;
    queue_elem.state = 0;
    queue_elem.in_pos = m_in.pos();
    parse_queue.push_back(queue_elem);

    // check all possible paths
    bool parse_ok = false;
    while (!parse_queue.empty()) {
        ParseQueueElem queue_elem = parse_queue.back();
        parse_queue.pop_back();
        auto& cur_state = m_states[queue_elem.state];

        // check if at final state
        if (cur_state.action) {
            // setup data for function call
            m_elems = queue_elem.elems;

            // compute constant expressions, lookup symbols in expressions
            for (auto& elem : m_elems) {
                if (elem.expr) {
                    if (elem.const_expr_if)
                        elem.expr->lookup_symbols_if();
                    else
                        elem.expr->lookup_symbols();
                }

                if (elem.const_expr) {
                    if (!elem.expr->eval_const(elem.const_value)) {
                        g_error->error_constant_expression_expected();
                        return false;
                    }
                }
                else if (elem.const_expr_if) {
                    elem.const_value = 0;   // default value
                    elem.expr->eval_const(elem.const_value); // ignore status
                }
            }

            // call action
            (this->*cur_state.action)();
            parse_ok = true;
            break;
        }

        // check IDENT_LIST
        m_in.set_pos(queue_elem.in_pos);
        auto it = cur_state.ttype_next.find(TType::IDENT_LIST);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::IDENT_LIST, false };
            if (collect_ident_list(elem.ident_list)) {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check CONST_ASSIGN_LIST
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::CONST_ASSIGN_LIST);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::CONST_ASSIGN_LIST, false };
            if (collect_const_assign_list(elem.ident_value_list)) {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check BYTE_LIST
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::BYTE_LIST);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::BYTE_LIST, false };
            if (collect_byte_list(elem.exprs)) {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check EXPR_LIST
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::EXPR_LIST);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::EXPR_LIST, false };
            if (collect_expr_list(elem.exprs)) {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check CONST_EXPR
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::CONST_EXPR);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::CONST_EXPR, false };
            elem.expr = new Expr;
            elem.const_expr = true;
            if (!elem.expr->parse(m_in, true)) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check CONST_EXPR_IF
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::CONST_EXPR_IF);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::CONST_EXPR_IF, false };
            elem.expr = new Expr;
            elem.const_expr_if = true;
            if (!elem.expr->parse(m_in, true)) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check EXPR
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::EXPR);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::EXPR, false };
            elem.expr = new Expr;
            if (!elem.expr->parse(m_in, true)) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check token
        m_in.set_pos(queue_elem.in_pos);
        TType ttype = m_in.peek().ttype();
        it = cur_state.ttype_next.find(ttype);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = m_in.peek();
            m_in.next();

            ParseQueueElem new_state = queue_elem;
            new_state.state = it->second;
            new_state.in_pos = m_in.pos();
            new_state.elems.elems.push_back(elem);
            parse_queue.push_back(new_state);
        }

        // check keyword
        m_in.set_pos(queue_elem.in_pos);
        Keyword keyword = m_in.peek().keyword();
        if (keyword != Keyword::NONE) {
            auto it = cur_state.keyword_next.find(keyword);
            if (it != cur_state.keyword_next.end()) {
                Elem elem;
                elem.token = m_in.peek();
                m_in.next();

                ParseQueueElem new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }
    }

    if (!parse_ok)
        g_error->error_syntax();

    return parse_ok;
}

bool LineParser::collect_ident(string& name) {
    if (!m_in.peek().is(TType::IDENT))
        return false;
    name = m_in.peek().svalue();
    m_in.next();
    return true;
}

bool LineParser::collect_optional_const_assignment(int& value) {
    value = 1;
    if (m_in.peek().operator_() != Operator::EQ)
        return true; // no assignment, defaults to 1

    m_in.next(); // consume '='

    Expr expr;
    if (!expr.parse(m_in, true))
        return false; // syntax error
    if (!expr.eval_const(value))
        return false; // constant expression expected

    return true; // return expression value
}

bool LineParser::collect_ident_list(vector<string>& names) {
    string name;

    names.clear();

    if (!collect_ident(name))
        return false;
    names.push_back(name);

    while (m_in.peek().is(TType::COMMA)) {
        m_in.next();
        if (!collect_ident(name))
            return false;
        names.push_back(name);
    }

    return true;
}

bool LineParser::collect_const_assign_list(vector<NameValuePair>& nv_list) {
    NameValuePair nv;

    nv_list.clear();

    if (!collect_ident(nv.name))
        return false;
    if (!collect_optional_const_assignment(nv.value))
        return false;
    nv_list.push_back(nv);

    while (m_in.peek().is(TType::COMMA)) {
        m_in.next(); // consume ','

        if (!collect_ident(nv.name))
            return false;
        if (!collect_optional_const_assignment(nv.value))
            return false;
        nv_list.push_back(nv);
    }

    return true;
}

bool LineParser::collect_byte_or_string(vector<Expr*>& exprs) {
    Expr expr;

    if (m_in.peek().is(TType::STR)) {
        for (auto& c : m_in.peek().svalue()) {
            if (!expr.parse(to_string(static_cast<unsigned int>(c))))
                return false;
            exprs.push_back(expr.clone());
        }
        m_in.next();
        return true;
    }
    else if (expr.parse(m_in, false)) {
        expr.lookup_symbols();
        exprs.push_back(expr.clone());
        return true;
    }
    else {
        return false;
    }
}

bool LineParser::collect_byte_list(vector<Expr*>& exprs) {
    Expr expr;

    exprs.clear();

    if (!collect_byte_or_string(exprs))
        return false;

    while (m_in.peek().is(TType::COMMA)) {
        m_in.next(); // consume ','

        if (!collect_byte_or_string(exprs))
            return false;
    }

    return true;
}

bool LineParser::collect_expr_list(vector<Expr*>& exprs) {
    Expr expr;

    exprs.clear();

    if (!expr.parse(m_in, false))
        return false;
    expr.lookup_symbols();
    exprs.push_back(expr.clone());

    while (m_in.peek().is(TType::COMMA)) {
        m_in.next(); // consume ','

        if (!expr.parse(m_in, false))
            return false;
        expr.lookup_symbols();
        exprs.push_back(expr.clone());
    }

    return true;
}

//@@BEGIN:actions_impl
void LineParser::action_align_const_expr_comma_const_expr() {
    g_obj_module->set_align(m_elems.elems[2-1].const_value, m_elems.elems[4-1].const_value);


}

void LineParser::action_align_const_expr() {
    g_obj_module->set_align(m_elems.elems[2-1].const_value, g_options->filler());


}

void LineParser::action_assert_const_expr_if() {
    g_obj_module->assert_(m_elems.elems[2-1].const_value);


}

void LineParser::action_assert_const_expr_if_comma_str() {
    g_obj_module->assert_(m_elems.elems[2-1].const_value, m_elems.elems[4-1].token.svalue());


}

void LineParser::action_assume_const_expr() {
	g_obj_module->set_assume(m_elems.elems[2-1].const_value);


}

void LineParser::action_binary_raw_str() {
    g_obj_module->include_binary(m_elems.elems[2-1].token.svalue());


}

void LineParser::action_define_const_assign_list() {
    for (auto& nv_pair : m_elems.elems[2-1].ident_value_list) {
        g_obj_module->add_global_def(nv_pair.name, nv_pair.value);
    }


}

void LineParser::action_defb_byte_list() {
    g_obj_module->add_byte_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_db_byte_list() {
    g_obj_module->add_byte_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_defm_byte_list() {
    g_obj_module->add_byte_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_dm_byte_list() {
    g_obj_module->add_byte_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_byte_byte_list() {
    g_obj_module->add_byte_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_defw_expr_list() {
    g_obj_module->add_word_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_dw_expr_list() {
    g_obj_module->add_word_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_word_expr_list() {
    g_obj_module->add_word_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_defdb_expr_list() {
    g_obj_module->add_word_be_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_ddb_expr_list() {
    g_obj_module->add_word_be_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_defp_expr_list() {
    g_obj_module->add_ptr_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_dp_expr_list() {
    g_obj_module->add_ptr_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_ptr_expr_list() {
    g_obj_module->add_ptr_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_defq_expr_list() {
    g_obj_module->add_dword_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_dq_expr_list() {
    g_obj_module->add_dword_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_dword_expr_list() {
    g_obj_module->add_dword_list(m_elems.elems[2-1].exprs);


}

void LineParser::action_extern_ident_list() {
    for (auto& ident : m_elems.elems[2-1].ident_list) {
        g_obj_module->declare_extern(ident);
    }


}

void LineParser::action_global_ident_list() {
    for (auto& ident : m_elems.elems[2-1].ident_list) {
        g_obj_module->declare_global(ident);
    }


}

void LineParser::action_incbin_raw_str() {
    g_obj_module->include_binary(m_elems.elems[2-1].token.svalue());


}

void LineParser::action_org_const_expr() {
    g_obj_module->set_origin(m_elems.elems[2-1].const_value);


}

void LineParser::action_public_ident_list() {
    for (auto& ident : m_elems.elems[2-1].ident_list) {
        g_obj_module->declare_public(ident);
    }


}

void LineParser::action_section_ident() {
    g_obj_module->set_cur_section(m_elems.elems[2-1].token.svalue());


}

void LineParser::action_ident_colon() {
	g_obj_module->add_label(m_elems.elems[1-1].token.svalue());


}

void LineParser::action_ident_equ_expr() {
	g_obj_module->add_equ(m_elems.elems[1-1].token.svalue(), m_elems.elems[3-1].expr->clone());


}

void LineParser::action_cu_dot_wait_const_expr_comma_const_expr() {
    g_obj_module->cu_wait(m_elems.elems[4-1].const_value, m_elems.elems[6-1].const_value);


}

void LineParser::action_cu_dot_move_const_expr_comma_const_expr() {
    g_obj_module->cu_move(m_elems.elems[4-1].const_value, m_elems.elems[6-1].const_value);


}

void LineParser::action_cu_dot_stop() {
    g_obj_module->cu_stop();


}

void LineParser::action_cu_dot_nop() {
    g_obj_module->cu_nop();


}

void LineParser::action_call_oz_const_expr() {
    g_obj_module->call_oz(m_elems.elems[2-1].const_value);


}

void LineParser::action_call_pkg_const_expr() {
    g_obj_module->call_pkg(m_elems.elems[2-1].const_value);


}

void LineParser::action_nop() {
	g_obj_module->add_opcode_void(0x00);


}

void LineParser::action_jr_expr() {
	g_obj_module->add_opcode_jr(0x18, m_elems.elems[2-1].expr->clone());


}

void LineParser::action_jr_nz_comma_expr() {
	g_obj_module->add_opcode_jr(0x20, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_z_comma_expr() {
	g_obj_module->add_opcode_jr(0x28, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_nc_comma_expr() {
	g_obj_module->add_opcode_jr(0x30, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_c_comma_expr() {
	g_obj_module->add_opcode_jr(0x38, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_expr() {
	g_obj_module->add_opcode_n(0x3E, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_b_comma_expr() {
	g_obj_module->add_opcode_n(0x06, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_c_comma_expr() {
	g_obj_module->add_opcode_n(0x0E, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_lparen_expr_rparen() {
	g_obj_module->add_opcode_nn(0x3A, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_a() {
	g_obj_module->add_opcode_void(0x7F);


}

void LineParser::action_ld_a_comma_b() {
	g_obj_module->add_opcode_void(0x78);


}

void LineParser::action_ld_ix_comma_expr() {
	g_obj_module->add_opcode_nn(0xDD21, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_iy_comma_expr() {
	g_obj_module->add_opcode_nn(0xFD21, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jp_expr() {
	g_obj_module->add_opcode_nn(0xC3, m_elems.elems[2-1].expr->clone());


}

//@@END

