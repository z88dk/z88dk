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
      { {Keyword::ALIGN, 1}, {Keyword::ASSERT, 7}, {Keyword::ASSUME, 13}, {Keyword::BINARY, 16}, {Keyword::BYTE, 19}, {Keyword::CALL_OZ, 22}, {Keyword::CALL_PKG, 25}, {Keyword::CU, 28}, {Keyword::DB, 44}, {Keyword::DC, 47}, {Keyword::DDB, 50}, {Keyword::DEFB, 53}, {Keyword::DEFC, 56}, {Keyword::DEFDB, 59}, {Keyword::DEFINE, 62}, {Keyword::DEFM, 65}, {Keyword::DEFP, 68}, {Keyword::DEFQ, 71}, {Keyword::DEFW, 74}, {Keyword::DM, 77}, {Keyword::DP, 80}, {Keyword::DQ, 83}, {Keyword::DW, 86}, {Keyword::DWORD, 89}, {Keyword::EXTERN, 92}, {Keyword::GLOBAL, 95}, {Keyword::INCBIN, 104}, {Keyword::JP, 107}, {Keyword::JR, 110}, {Keyword::LD, 129}, {Keyword::NOP, 158}, {Keyword::ORG, 160}, {Keyword::PTR, 163}, {Keyword::PUBLIC, 166}, {Keyword::SECTION, 169}, {Keyword::WORD, 172}, },
      { {TType::IDENT, 98}, },
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
    { // 47: DC
      { },
      { {TType::ASSIGN_LIST, 48}, },
      nullptr,
    },
    { // 48: DC ASSIGN_LIST
      { },
      { {TType::END, 49}, },
      nullptr,
    },
    { // 49: DC ASSIGN_LIST END
      { },
      { },
      &LineParser::action_dc_assign_list,
    },
    { // 50: DDB
      { },
      { {TType::EXPR_LIST, 51}, },
      nullptr,
    },
    { // 51: DDB EXPR_LIST
      { },
      { {TType::END, 52}, },
      nullptr,
    },
    { // 52: DDB EXPR_LIST END
      { },
      { },
      &LineParser::action_ddb_expr_list,
    },
    { // 53: DEFB
      { },
      { {TType::BYTE_LIST, 54}, },
      nullptr,
    },
    { // 54: DEFB BYTE_LIST
      { },
      { {TType::END, 55}, },
      nullptr,
    },
    { // 55: DEFB BYTE_LIST END
      { },
      { },
      &LineParser::action_defb_byte_list,
    },
    { // 56: DEFC
      { },
      { {TType::ASSIGN_LIST, 57}, },
      nullptr,
    },
    { // 57: DEFC ASSIGN_LIST
      { },
      { {TType::END, 58}, },
      nullptr,
    },
    { // 58: DEFC ASSIGN_LIST END
      { },
      { },
      &LineParser::action_defc_assign_list,
    },
    { // 59: DEFDB
      { },
      { {TType::EXPR_LIST, 60}, },
      nullptr,
    },
    { // 60: DEFDB EXPR_LIST
      { },
      { {TType::END, 61}, },
      nullptr,
    },
    { // 61: DEFDB EXPR_LIST END
      { },
      { },
      &LineParser::action_defdb_expr_list,
    },
    { // 62: DEFINE
      { },
      { {TType::CONST_ASSIGN_LIST, 63}, },
      nullptr,
    },
    { // 63: DEFINE CONST_ASSIGN_LIST
      { },
      { {TType::END, 64}, },
      nullptr,
    },
    { // 64: DEFINE CONST_ASSIGN_LIST END
      { },
      { },
      &LineParser::action_define_const_assign_list,
    },
    { // 65: DEFM
      { },
      { {TType::BYTE_LIST, 66}, },
      nullptr,
    },
    { // 66: DEFM BYTE_LIST
      { },
      { {TType::END, 67}, },
      nullptr,
    },
    { // 67: DEFM BYTE_LIST END
      { },
      { },
      &LineParser::action_defm_byte_list,
    },
    { // 68: DEFP
      { },
      { {TType::EXPR_LIST, 69}, },
      nullptr,
    },
    { // 69: DEFP EXPR_LIST
      { },
      { {TType::END, 70}, },
      nullptr,
    },
    { // 70: DEFP EXPR_LIST END
      { },
      { },
      &LineParser::action_defp_expr_list,
    },
    { // 71: DEFQ
      { },
      { {TType::EXPR_LIST, 72}, },
      nullptr,
    },
    { // 72: DEFQ EXPR_LIST
      { },
      { {TType::END, 73}, },
      nullptr,
    },
    { // 73: DEFQ EXPR_LIST END
      { },
      { },
      &LineParser::action_defq_expr_list,
    },
    { // 74: DEFW
      { },
      { {TType::EXPR_LIST, 75}, },
      nullptr,
    },
    { // 75: DEFW EXPR_LIST
      { },
      { {TType::END, 76}, },
      nullptr,
    },
    { // 76: DEFW EXPR_LIST END
      { },
      { },
      &LineParser::action_defw_expr_list,
    },
    { // 77: DM
      { },
      { {TType::BYTE_LIST, 78}, },
      nullptr,
    },
    { // 78: DM BYTE_LIST
      { },
      { {TType::END, 79}, },
      nullptr,
    },
    { // 79: DM BYTE_LIST END
      { },
      { },
      &LineParser::action_dm_byte_list,
    },
    { // 80: DP
      { },
      { {TType::EXPR_LIST, 81}, },
      nullptr,
    },
    { // 81: DP EXPR_LIST
      { },
      { {TType::END, 82}, },
      nullptr,
    },
    { // 82: DP EXPR_LIST END
      { },
      { },
      &LineParser::action_dp_expr_list,
    },
    { // 83: DQ
      { },
      { {TType::EXPR_LIST, 84}, },
      nullptr,
    },
    { // 84: DQ EXPR_LIST
      { },
      { {TType::END, 85}, },
      nullptr,
    },
    { // 85: DQ EXPR_LIST END
      { },
      { },
      &LineParser::action_dq_expr_list,
    },
    { // 86: DW
      { },
      { {TType::EXPR_LIST, 87}, },
      nullptr,
    },
    { // 87: DW EXPR_LIST
      { },
      { {TType::END, 88}, },
      nullptr,
    },
    { // 88: DW EXPR_LIST END
      { },
      { },
      &LineParser::action_dw_expr_list,
    },
    { // 89: DWORD
      { },
      { {TType::EXPR_LIST, 90}, },
      nullptr,
    },
    { // 90: DWORD EXPR_LIST
      { },
      { {TType::END, 91}, },
      nullptr,
    },
    { // 91: DWORD EXPR_LIST END
      { },
      { },
      &LineParser::action_dword_expr_list,
    },
    { // 92: EXTERN
      { },
      { {TType::IDENT_LIST, 93}, },
      nullptr,
    },
    { // 93: EXTERN IDENT_LIST
      { },
      { {TType::END, 94}, },
      nullptr,
    },
    { // 94: EXTERN IDENT_LIST END
      { },
      { },
      &LineParser::action_extern_ident_list,
    },
    { // 95: GLOBAL
      { },
      { {TType::IDENT_LIST, 96}, },
      nullptr,
    },
    { // 96: GLOBAL IDENT_LIST
      { },
      { {TType::END, 97}, },
      nullptr,
    },
    { // 97: GLOBAL IDENT_LIST END
      { },
      { },
      &LineParser::action_global_ident_list,
    },
    { // 98: IDENT
      { {Keyword::EQU, 101}, },
      { {TType::COLON, 99}, },
      nullptr,
    },
    { // 99: IDENT COLON
      { },
      { {TType::END, 100}, },
      nullptr,
    },
    { // 100: IDENT COLON END
      { },
      { },
      &LineParser::action_ident_colon,
    },
    { // 101: IDENT EQU
      { },
      { {TType::EXPR, 102}, },
      nullptr,
    },
    { // 102: IDENT EQU EXPR
      { },
      { {TType::END, 103}, },
      nullptr,
    },
    { // 103: IDENT EQU EXPR END
      { },
      { },
      &LineParser::action_ident_equ_expr,
    },
    { // 104: INCBIN
      { },
      { {TType::RAW_STR, 105}, },
      nullptr,
    },
    { // 105: INCBIN RAW_STR
      { },
      { {TType::END, 106}, },
      nullptr,
    },
    { // 106: INCBIN RAW_STR END
      { },
      { },
      &LineParser::action_incbin_raw_str,
    },
    { // 107: JP
      { },
      { {TType::EXPR, 108}, },
      nullptr,
    },
    { // 108: JP EXPR
      { },
      { {TType::END, 109}, },
      nullptr,
    },
    { // 109: JP EXPR END
      { },
      { },
      &LineParser::action_jp_expr,
    },
    { // 110: JR
      { {Keyword::C, 111}, {Keyword::NC, 117}, {Keyword::NZ, 121}, {Keyword::Z, 125}, },
      { {TType::EXPR, 115}, },
      nullptr,
    },
    { // 111: JR C
      { },
      { {TType::COMMA, 112}, },
      nullptr,
    },
    { // 112: JR C COMMA
      { },
      { {TType::EXPR, 113}, },
      nullptr,
    },
    { // 113: JR C COMMA EXPR
      { },
      { {TType::END, 114}, },
      nullptr,
    },
    { // 114: JR C COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_c_comma_expr,
    },
    { // 115: JR EXPR
      { },
      { {TType::END, 116}, },
      nullptr,
    },
    { // 116: JR EXPR END
      { },
      { },
      &LineParser::action_jr_expr,
    },
    { // 117: JR NC
      { },
      { {TType::COMMA, 118}, },
      nullptr,
    },
    { // 118: JR NC COMMA
      { },
      { {TType::EXPR, 119}, },
      nullptr,
    },
    { // 119: JR NC COMMA EXPR
      { },
      { {TType::END, 120}, },
      nullptr,
    },
    { // 120: JR NC COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nc_comma_expr,
    },
    { // 121: JR NZ
      { },
      { {TType::COMMA, 122}, },
      nullptr,
    },
    { // 122: JR NZ COMMA
      { },
      { {TType::EXPR, 123}, },
      nullptr,
    },
    { // 123: JR NZ COMMA EXPR
      { },
      { {TType::END, 124}, },
      nullptr,
    },
    { // 124: JR NZ COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nz_comma_expr,
    },
    { // 125: JR Z
      { },
      { {TType::COMMA, 126}, },
      nullptr,
    },
    { // 126: JR Z COMMA
      { },
      { {TType::EXPR, 127}, },
      nullptr,
    },
    { // 127: JR Z COMMA EXPR
      { },
      { {TType::END, 128}, },
      nullptr,
    },
    { // 128: JR Z COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_z_comma_expr,
    },
    { // 129: LD
      { {Keyword::A, 130}, {Keyword::B, 142}, {Keyword::C, 146}, {Keyword::IX, 150}, {Keyword::IY, 154}, },
      { },
      nullptr,
    },
    { // 130: LD A
      { },
      { {TType::COMMA, 131}, },
      nullptr,
    },
    { // 131: LD A COMMA
      { {Keyword::A, 132}, {Keyword::B, 134}, },
      { {TType::EXPR, 136}, {TType::LPAREN, 138}, },
      nullptr,
    },
    { // 132: LD A COMMA A
      { },
      { {TType::END, 133}, },
      nullptr,
    },
    { // 133: LD A COMMA A END
      { },
      { },
      &LineParser::action_ld_a_comma_a,
    },
    { // 134: LD A COMMA B
      { },
      { {TType::END, 135}, },
      nullptr,
    },
    { // 135: LD A COMMA B END
      { },
      { },
      &LineParser::action_ld_a_comma_b,
    },
    { // 136: LD A COMMA EXPR
      { },
      { {TType::END, 137}, },
      nullptr,
    },
    { // 137: LD A COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_a_comma_expr,
    },
    { // 138: LD A COMMA LPAREN
      { },
      { {TType::EXPR, 139}, },
      nullptr,
    },
    { // 139: LD A COMMA LPAREN EXPR
      { },
      { {TType::RPAREN, 140}, },
      nullptr,
    },
    { // 140: LD A COMMA LPAREN EXPR RPAREN
      { },
      { {TType::END, 141}, },
      nullptr,
    },
    { // 141: LD A COMMA LPAREN EXPR RPAREN END
      { },
      { },
      &LineParser::action_ld_a_comma_lparen_expr_rparen,
    },
    { // 142: LD B
      { },
      { {TType::COMMA, 143}, },
      nullptr,
    },
    { // 143: LD B COMMA
      { },
      { {TType::EXPR, 144}, },
      nullptr,
    },
    { // 144: LD B COMMA EXPR
      { },
      { {TType::END, 145}, },
      nullptr,
    },
    { // 145: LD B COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_b_comma_expr,
    },
    { // 146: LD C
      { },
      { {TType::COMMA, 147}, },
      nullptr,
    },
    { // 147: LD C COMMA
      { },
      { {TType::EXPR, 148}, },
      nullptr,
    },
    { // 148: LD C COMMA EXPR
      { },
      { {TType::END, 149}, },
      nullptr,
    },
    { // 149: LD C COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_c_comma_expr,
    },
    { // 150: LD IX
      { },
      { {TType::COMMA, 151}, },
      nullptr,
    },
    { // 151: LD IX COMMA
      { },
      { {TType::EXPR, 152}, },
      nullptr,
    },
    { // 152: LD IX COMMA EXPR
      { },
      { {TType::END, 153}, },
      nullptr,
    },
    { // 153: LD IX COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_ix_comma_expr,
    },
    { // 154: LD IY
      { },
      { {TType::COMMA, 155}, },
      nullptr,
    },
    { // 155: LD IY COMMA
      { },
      { {TType::EXPR, 156}, },
      nullptr,
    },
    { // 156: LD IY COMMA EXPR
      { },
      { {TType::END, 157}, },
      nullptr,
    },
    { // 157: LD IY COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_iy_comma_expr,
    },
    { // 158: NOP
      { },
      { {TType::END, 159}, },
      nullptr,
    },
    { // 159: NOP END
      { },
      { },
      &LineParser::action_nop,
    },
    { // 160: ORG
      { },
      { {TType::CONST_EXPR, 161}, },
      nullptr,
    },
    { // 161: ORG CONST_EXPR
      { },
      { {TType::END, 162}, },
      nullptr,
    },
    { // 162: ORG CONST_EXPR END
      { },
      { },
      &LineParser::action_org_const_expr,
    },
    { // 163: PTR
      { },
      { {TType::EXPR_LIST, 164}, },
      nullptr,
    },
    { // 164: PTR EXPR_LIST
      { },
      { {TType::END, 165}, },
      nullptr,
    },
    { // 165: PTR EXPR_LIST END
      { },
      { },
      &LineParser::action_ptr_expr_list,
    },
    { // 166: PUBLIC
      { },
      { {TType::IDENT_LIST, 167}, },
      nullptr,
    },
    { // 167: PUBLIC IDENT_LIST
      { },
      { {TType::END, 168}, },
      nullptr,
    },
    { // 168: PUBLIC IDENT_LIST END
      { },
      { },
      &LineParser::action_public_ident_list,
    },
    { // 169: SECTION
      { },
      { {TType::IDENT, 170}, },
      nullptr,
    },
    { // 170: SECTION IDENT
      { },
      { {TType::END, 171}, },
      nullptr,
    },
    { // 171: SECTION IDENT END
      { },
      { },
      &LineParser::action_section_ident,
    },
    { // 172: WORD
      { },
      { {TType::EXPR_LIST, 173}, },
      nullptr,
    },
    { // 173: WORD EXPR_LIST
      { },
      { {TType::END, 174}, },
      nullptr,
    },
    { // 174: WORD EXPR_LIST END
      { },
      { },
      &LineParser::action_word_expr_list,
    },
    //@@END
};

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
                if (!elem.expr.empty()) {
                    if (elem.const_expr_if)
                        elem.expr.lookup_symbols_if();
                    else
                        elem.expr.lookup_symbols();
                }

                if (elem.const_expr) {
                    if (!elem.expr.eval_const(elem.const_value)) {
                        g_error->error_constant_expression_expected();
                        return false;
                    }
                }
                else if (elem.const_expr_if) {
                    elem.const_value = 0;   // default value
                    elem.expr.eval_const(elem.const_value); // ignore status
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

        // check ASSIGN_LIST
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::ASSIGN_LIST);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::ASSIGN_LIST, false };
            if (collect_assign_list(elem.ident_expr_list)) {
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
            elem.const_expr = true;
            if (elem.expr.parse(m_in, true)) {
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
            elem.const_expr_if = true;
            if (elem.expr.parse(m_in, true)) {
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
            if (elem.expr.parse(m_in, true)) {
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

bool LineParser::collect_byte_or_string(vector<Expr>& exprs) {
    Expr expr;

    if (m_in.peek().is(TType::STR)) {
        for (auto& c : m_in.peek().svalue()) {
            if (!expr.parse(to_string(static_cast<unsigned int>(c))))
                return false;
            exprs.push_back(expr);
        }
        m_in.next();
        return true;
    }
    else if (expr.parse(m_in, false)) {
        expr.lookup_symbols();
        exprs.push_back(expr);
        return true;
    }
    else {
        return false;
    }
}

bool LineParser::collect_byte_list(vector<Expr>& exprs) {
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

bool LineParser::collect_expr_list(vector<Expr>& exprs) {
    Expr expr;

    exprs.clear();

    if (!expr.parse(m_in, false))
        return false;
    expr.lookup_symbols();
    exprs.push_back(expr);

    while (m_in.peek().is(TType::COMMA)) {
        m_in.next(); // consume ','

        if (!expr.parse(m_in, false))
            return false;
        expr.lookup_symbols();
        exprs.push_back(expr);
    }

    return true;
}

bool LineParser::collect_assign(vector<NameExprPair>& ne_list) {
    NameExprPair ne_pair;

    if (!collect_ident(ne_pair.name))
        return false;

    if (m_in.peek().operator_() != Operator::EQ)
        return false;
    m_in.next();

    if (!ne_pair.expr.parse(m_in, false))
        return false;
    ne_pair.expr.lookup_symbols();
    ne_list.push_back(ne_pair);
    return true;
}

bool LineParser::collect_assign_list(vector<NameExprPair>& ne_list) {
    ne_list.clear();
    if (!collect_assign(ne_list))
        return false;

    while (m_in.peek().is(TType::COMMA)) {
        m_in.next(); // consume ','

        if (!collect_assign(ne_list))
            return false;
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

void LineParser::action_defc_assign_list() {
    for (auto& ne_pair : m_elems.elems[2-1].ident_expr_list) {
		g_obj_module->add_equ(ne_pair.name, ne_pair.expr);
	}


}

void LineParser::action_dc_assign_list() {
    for (auto& ne_pair : m_elems.elems[2-1].ident_expr_list) {
		g_obj_module->add_equ(ne_pair.name, ne_pair.expr);
	}


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
	g_obj_module->add_equ(m_elems.elems[1-1].token.svalue(), m_elems.elems[3-1].expr);


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
	g_obj_module->add_opcode_jr(0x18, m_elems.elems[2-1].expr);


}

void LineParser::action_jr_nz_comma_expr() {
	g_obj_module->add_opcode_jr(0x20, m_elems.elems[4-1].expr);


}

void LineParser::action_jr_z_comma_expr() {
	g_obj_module->add_opcode_jr(0x28, m_elems.elems[4-1].expr);


}

void LineParser::action_jr_nc_comma_expr() {
	g_obj_module->add_opcode_jr(0x30, m_elems.elems[4-1].expr);


}

void LineParser::action_jr_c_comma_expr() {
	g_obj_module->add_opcode_jr(0x38, m_elems.elems[4-1].expr);


}

void LineParser::action_ld_a_comma_expr() {
	g_obj_module->add_opcode_n(0x3E, m_elems.elems[4-1].expr);


}

void LineParser::action_ld_b_comma_expr() {
	g_obj_module->add_opcode_n(0x06, m_elems.elems[4-1].expr);


}

void LineParser::action_ld_c_comma_expr() {
	g_obj_module->add_opcode_n(0x0E, m_elems.elems[4-1].expr);


}

void LineParser::action_ld_a_comma_lparen_expr_rparen() {
	g_obj_module->add_opcode_nn(0x3A, m_elems.elems[4-1].expr);


}

void LineParser::action_ld_a_comma_a() {
	g_obj_module->add_opcode_void(0x7F);


}

void LineParser::action_ld_a_comma_b() {
	g_obj_module->add_opcode_void(0x78);


}

void LineParser::action_ld_ix_comma_expr() {
	g_obj_module->add_opcode_nn(0xDD21, m_elems.elems[4-1].expr);


}

void LineParser::action_ld_iy_comma_expr() {
	g_obj_module->add_opcode_nn(0xFD21, m_elems.elems[4-1].expr);


}

void LineParser::action_jp_expr() {
	g_obj_module->add_opcode_nn(0xC3, m_elems.elems[2-1].expr);


}

//@@END

