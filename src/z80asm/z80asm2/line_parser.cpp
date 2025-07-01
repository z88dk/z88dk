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
#include <cassert>
using namespace std;

LineParser::ParserState LineParser::m_states[] = {
    //@@BEGIN: states
    { // 0: 
      { {Keyword::ALIGN, 1}, {Keyword::ASSERT, 7}, {Keyword::ASSUME, 13}, {Keyword::BINARY, 16}, {Keyword::BYTE, 19}, {Keyword::CALL_OZ, 22}, {Keyword::CALL_PKG, 25}, {Keyword::CU, 28}, {Keyword::DB, 44}, {Keyword::DC, 47}, {Keyword::DDB, 50}, {Keyword::DEFB, 53}, {Keyword::DEFC, 56}, {Keyword::DEFDB, 59}, {Keyword::DEFINE, 62}, {Keyword::DEFM, 65}, {Keyword::DEFP, 68}, {Keyword::DEFQ, 71}, {Keyword::DEFS, 74}, {Keyword::DEFW, 82}, {Keyword::DM, 85}, {Keyword::DP, 88}, {Keyword::DQ, 91}, {Keyword::DS, 94}, {Keyword::DW, 102}, {Keyword::DWORD, 105}, {Keyword::EXTERN, 108}, {Keyword::GLOBAL, 111}, {Keyword::INCBIN, 120}, {Keyword::JP, 123}, {Keyword::JR, 126}, {Keyword::LD, 145}, {Keyword::NOP, 174}, {Keyword::ORG, 176}, {Keyword::PTR, 179}, {Keyword::PUBLIC, 182}, {Keyword::SECTION, 185}, {Keyword::WORD, 188}, },
      { {TType::IDENT, 114}, },
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
    { // 74: DEFS
      { },
      { {TType::CONST_EXPR, 75}, },
      nullptr,
    },
    { // 75: DEFS CONST_EXPR
      { },
      { {TType::COMMA, 76}, {TType::END, 81}, },
      nullptr,
    },
    { // 76: DEFS CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 77}, {TType::STR, 79}, },
      nullptr,
    },
    { // 77: DEFS CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 78}, },
      nullptr,
    },
    { // 78: DEFS CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_defs_const_expr_comma_const_expr,
    },
    { // 79: DEFS CONST_EXPR COMMA STR
      { },
      { {TType::END, 80}, },
      nullptr,
    },
    { // 80: DEFS CONST_EXPR COMMA STR END
      { },
      { },
      &LineParser::action_defs_const_expr_comma_str,
    },
    { // 81: DEFS CONST_EXPR END
      { },
      { },
      &LineParser::action_defs_const_expr,
    },
    { // 82: DEFW
      { },
      { {TType::EXPR_LIST, 83}, },
      nullptr,
    },
    { // 83: DEFW EXPR_LIST
      { },
      { {TType::END, 84}, },
      nullptr,
    },
    { // 84: DEFW EXPR_LIST END
      { },
      { },
      &LineParser::action_defw_expr_list,
    },
    { // 85: DM
      { },
      { {TType::BYTE_LIST, 86}, },
      nullptr,
    },
    { // 86: DM BYTE_LIST
      { },
      { {TType::END, 87}, },
      nullptr,
    },
    { // 87: DM BYTE_LIST END
      { },
      { },
      &LineParser::action_dm_byte_list,
    },
    { // 88: DP
      { },
      { {TType::EXPR_LIST, 89}, },
      nullptr,
    },
    { // 89: DP EXPR_LIST
      { },
      { {TType::END, 90}, },
      nullptr,
    },
    { // 90: DP EXPR_LIST END
      { },
      { },
      &LineParser::action_dp_expr_list,
    },
    { // 91: DQ
      { },
      { {TType::EXPR_LIST, 92}, },
      nullptr,
    },
    { // 92: DQ EXPR_LIST
      { },
      { {TType::END, 93}, },
      nullptr,
    },
    { // 93: DQ EXPR_LIST END
      { },
      { },
      &LineParser::action_dq_expr_list,
    },
    { // 94: DS
      { },
      { {TType::CONST_EXPR, 95}, },
      nullptr,
    },
    { // 95: DS CONST_EXPR
      { },
      { {TType::COMMA, 96}, {TType::END, 101}, },
      nullptr,
    },
    { // 96: DS CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 97}, {TType::STR, 99}, },
      nullptr,
    },
    { // 97: DS CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 98}, },
      nullptr,
    },
    { // 98: DS CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_ds_const_expr_comma_const_expr,
    },
    { // 99: DS CONST_EXPR COMMA STR
      { },
      { {TType::END, 100}, },
      nullptr,
    },
    { // 100: DS CONST_EXPR COMMA STR END
      { },
      { },
      &LineParser::action_ds_const_expr_comma_str,
    },
    { // 101: DS CONST_EXPR END
      { },
      { },
      &LineParser::action_ds_const_expr,
    },
    { // 102: DW
      { },
      { {TType::EXPR_LIST, 103}, },
      nullptr,
    },
    { // 103: DW EXPR_LIST
      { },
      { {TType::END, 104}, },
      nullptr,
    },
    { // 104: DW EXPR_LIST END
      { },
      { },
      &LineParser::action_dw_expr_list,
    },
    { // 105: DWORD
      { },
      { {TType::EXPR_LIST, 106}, },
      nullptr,
    },
    { // 106: DWORD EXPR_LIST
      { },
      { {TType::END, 107}, },
      nullptr,
    },
    { // 107: DWORD EXPR_LIST END
      { },
      { },
      &LineParser::action_dword_expr_list,
    },
    { // 108: EXTERN
      { },
      { {TType::IDENT_LIST, 109}, },
      nullptr,
    },
    { // 109: EXTERN IDENT_LIST
      { },
      { {TType::END, 110}, },
      nullptr,
    },
    { // 110: EXTERN IDENT_LIST END
      { },
      { },
      &LineParser::action_extern_ident_list,
    },
    { // 111: GLOBAL
      { },
      { {TType::IDENT_LIST, 112}, },
      nullptr,
    },
    { // 112: GLOBAL IDENT_LIST
      { },
      { {TType::END, 113}, },
      nullptr,
    },
    { // 113: GLOBAL IDENT_LIST END
      { },
      { },
      &LineParser::action_global_ident_list,
    },
    { // 114: IDENT
      { {Keyword::EQU, 117}, },
      { {TType::COLON, 115}, },
      nullptr,
    },
    { // 115: IDENT COLON
      { },
      { {TType::END, 116}, },
      nullptr,
    },
    { // 116: IDENT COLON END
      { },
      { },
      &LineParser::action_ident_colon,
    },
    { // 117: IDENT EQU
      { },
      { {TType::EXPR, 118}, },
      nullptr,
    },
    { // 118: IDENT EQU EXPR
      { },
      { {TType::END, 119}, },
      nullptr,
    },
    { // 119: IDENT EQU EXPR END
      { },
      { },
      &LineParser::action_ident_equ_expr,
    },
    { // 120: INCBIN
      { },
      { {TType::RAW_STR, 121}, },
      nullptr,
    },
    { // 121: INCBIN RAW_STR
      { },
      { {TType::END, 122}, },
      nullptr,
    },
    { // 122: INCBIN RAW_STR END
      { },
      { },
      &LineParser::action_incbin_raw_str,
    },
    { // 123: JP
      { },
      { {TType::EXPR, 124}, },
      nullptr,
    },
    { // 124: JP EXPR
      { },
      { {TType::END, 125}, },
      nullptr,
    },
    { // 125: JP EXPR END
      { },
      { },
      &LineParser::action_jp_expr,
    },
    { // 126: JR
      { {Keyword::C, 127}, {Keyword::NC, 133}, {Keyword::NZ, 137}, {Keyword::Z, 141}, },
      { {TType::EXPR, 131}, },
      nullptr,
    },
    { // 127: JR C
      { },
      { {TType::COMMA, 128}, },
      nullptr,
    },
    { // 128: JR C COMMA
      { },
      { {TType::EXPR, 129}, },
      nullptr,
    },
    { // 129: JR C COMMA EXPR
      { },
      { {TType::END, 130}, },
      nullptr,
    },
    { // 130: JR C COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_c_comma_expr,
    },
    { // 131: JR EXPR
      { },
      { {TType::END, 132}, },
      nullptr,
    },
    { // 132: JR EXPR END
      { },
      { },
      &LineParser::action_jr_expr,
    },
    { // 133: JR NC
      { },
      { {TType::COMMA, 134}, },
      nullptr,
    },
    { // 134: JR NC COMMA
      { },
      { {TType::EXPR, 135}, },
      nullptr,
    },
    { // 135: JR NC COMMA EXPR
      { },
      { {TType::END, 136}, },
      nullptr,
    },
    { // 136: JR NC COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nc_comma_expr,
    },
    { // 137: JR NZ
      { },
      { {TType::COMMA, 138}, },
      nullptr,
    },
    { // 138: JR NZ COMMA
      { },
      { {TType::EXPR, 139}, },
      nullptr,
    },
    { // 139: JR NZ COMMA EXPR
      { },
      { {TType::END, 140}, },
      nullptr,
    },
    { // 140: JR NZ COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nz_comma_expr,
    },
    { // 141: JR Z
      { },
      { {TType::COMMA, 142}, },
      nullptr,
    },
    { // 142: JR Z COMMA
      { },
      { {TType::EXPR, 143}, },
      nullptr,
    },
    { // 143: JR Z COMMA EXPR
      { },
      { {TType::END, 144}, },
      nullptr,
    },
    { // 144: JR Z COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_z_comma_expr,
    },
    { // 145: LD
      { {Keyword::A, 146}, {Keyword::B, 158}, {Keyword::C, 162}, {Keyword::IX, 166}, {Keyword::IY, 170}, },
      { },
      nullptr,
    },
    { // 146: LD A
      { },
      { {TType::COMMA, 147}, },
      nullptr,
    },
    { // 147: LD A COMMA
      { {Keyword::A, 148}, {Keyword::B, 150}, },
      { {TType::EXPR, 152}, {TType::LPAREN, 154}, },
      nullptr,
    },
    { // 148: LD A COMMA A
      { },
      { {TType::END, 149}, },
      nullptr,
    },
    { // 149: LD A COMMA A END
      { },
      { },
      &LineParser::action_ld_a_comma_a,
    },
    { // 150: LD A COMMA B
      { },
      { {TType::END, 151}, },
      nullptr,
    },
    { // 151: LD A COMMA B END
      { },
      { },
      &LineParser::action_ld_a_comma_b,
    },
    { // 152: LD A COMMA EXPR
      { },
      { {TType::END, 153}, },
      nullptr,
    },
    { // 153: LD A COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_a_comma_expr,
    },
    { // 154: LD A COMMA LPAREN
      { },
      { {TType::EXPR, 155}, },
      nullptr,
    },
    { // 155: LD A COMMA LPAREN EXPR
      { },
      { {TType::RPAREN, 156}, },
      nullptr,
    },
    { // 156: LD A COMMA LPAREN EXPR RPAREN
      { },
      { {TType::END, 157}, },
      nullptr,
    },
    { // 157: LD A COMMA LPAREN EXPR RPAREN END
      { },
      { },
      &LineParser::action_ld_a_comma_lparen_expr_rparen,
    },
    { // 158: LD B
      { },
      { {TType::COMMA, 159}, },
      nullptr,
    },
    { // 159: LD B COMMA
      { },
      { {TType::EXPR, 160}, },
      nullptr,
    },
    { // 160: LD B COMMA EXPR
      { },
      { {TType::END, 161}, },
      nullptr,
    },
    { // 161: LD B COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_b_comma_expr,
    },
    { // 162: LD C
      { },
      { {TType::COMMA, 163}, },
      nullptr,
    },
    { // 163: LD C COMMA
      { },
      { {TType::EXPR, 164}, },
      nullptr,
    },
    { // 164: LD C COMMA EXPR
      { },
      { {TType::END, 165}, },
      nullptr,
    },
    { // 165: LD C COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_c_comma_expr,
    },
    { // 166: LD IX
      { },
      { {TType::COMMA, 167}, },
      nullptr,
    },
    { // 167: LD IX COMMA
      { },
      { {TType::EXPR, 168}, },
      nullptr,
    },
    { // 168: LD IX COMMA EXPR
      { },
      { {TType::END, 169}, },
      nullptr,
    },
    { // 169: LD IX COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_ix_comma_expr,
    },
    { // 170: LD IY
      { },
      { {TType::COMMA, 171}, },
      nullptr,
    },
    { // 171: LD IY COMMA
      { },
      { {TType::EXPR, 172}, },
      nullptr,
    },
    { // 172: LD IY COMMA EXPR
      { },
      { {TType::END, 173}, },
      nullptr,
    },
    { // 173: LD IY COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_iy_comma_expr,
    },
    { // 174: NOP
      { },
      { {TType::END, 175}, },
      nullptr,
    },
    { // 175: NOP END
      { },
      { },
      &LineParser::action_nop,
    },
    { // 176: ORG
      { },
      { {TType::CONST_EXPR, 177}, },
      nullptr,
    },
    { // 177: ORG CONST_EXPR
      { },
      { {TType::END, 178}, },
      nullptr,
    },
    { // 178: ORG CONST_EXPR END
      { },
      { },
      &LineParser::action_org_const_expr,
    },
    { // 179: PTR
      { },
      { {TType::EXPR_LIST, 180}, },
      nullptr,
    },
    { // 180: PTR EXPR_LIST
      { },
      { {TType::END, 181}, },
      nullptr,
    },
    { // 181: PTR EXPR_LIST END
      { },
      { },
      &LineParser::action_ptr_expr_list,
    },
    { // 182: PUBLIC
      { },
      { {TType::IDENT_LIST, 183}, },
      nullptr,
    },
    { // 183: PUBLIC IDENT_LIST
      { },
      { {TType::END, 184}, },
      nullptr,
    },
    { // 184: PUBLIC IDENT_LIST END
      { },
      { },
      &LineParser::action_public_ident_list,
    },
    { // 185: SECTION
      { },
      { {TType::IDENT, 186}, },
      nullptr,
    },
    { // 186: SECTION IDENT
      { },
      { {TType::END, 187}, },
      nullptr,
    },
    { // 187: SECTION IDENT END
      { },
      { },
      &LineParser::action_section_ident,
    },
    { // 188: WORD
      { },
      { {TType::EXPR_LIST, 189}, },
      nullptr,
    },
    { // 189: WORD EXPR_LIST
      { },
      { {TType::END, 190}, },
      nullptr,
    },
    { // 190: WORD EXPR_LIST END
      { },
      { },
      &LineParser::action_word_expr_list,
    },
    //@@END
};

bool LineParser::parse_line(const string& line) {
    bool parse_ok = true;
    int error_count = g_error->count();

    if (!m_in.scan(line))
        return false;       // scanning failed

    if (m_in.peek().is(TType::END))
        return true;        // empty line

    switch (m_line_state) {
    case LineState::MAIN:
        parse_ok = parse_main();
        break;

    case LineState::DEFGROUP1:
    case LineState::DEFGROUP2:
    case LineState::DEFGROUP3:
        parse_ok = parse_defgroup();
        break;

    case LineState::DEFVARS1:
    case LineState::DEFVARS2:
        parse_ok = parse_defvars();
        break;

    default:
        assert(false && "Undefined state");
    }

    if (!parse_ok && g_error->count() == error_count)
        g_error->error_syntax();

    return parse_ok && g_error->count() == error_count;
}

bool LineParser::parse_main() {
    vector<ParseQueueElem> parse_queue;
    int value = 0;

    // switch states
    switch (m_in.peek().keyword()) {
    case Keyword::DEFGROUP:
        m_in.next();
        m_line_state = LineState::DEFGROUP1;
        return parse_defgroup();

    case Keyword::DEFVARS:
        m_in.next();

        if (!collect_const_expr(value)) 
            return false;

        if (value < 0) {
            m_defvars_addr = m_defvars_prev_addr;
            m_defvars_update = true;
        }
        else if (value == 0) {
            m_defvars_addr = 0;
            m_defvars_update = false;
        }
        else {
            m_defvars_addr = value;
            m_defvars_update = true;
        }

        m_line_state = LineState::DEFVARS1;
        return parse_defvars();

    default:;
    }

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

    return parse_ok;
}

bool LineParser::parse_defgroup() {
    string name;
    int value = 0;

    while (true) {
        if (m_in.peek().is_end()) {
            if (m_line_state == LineState::DEFGROUP3)   // comma at end of line is optional
                m_line_state = LineState::DEFGROUP2;
            return true;
        }

        switch (m_line_state) {
        case LineState::DEFGROUP1:      // wait of '{'
            m_defgroup_id = 0;
            if (m_in.peek().is(TType::LBRACE)) {
                m_in.next();
                m_line_state = LineState::DEFGROUP2;
                continue;
            }
            else
                return false;

        case LineState::DEFGROUP2:      // wait for constant assignment 
            if (m_in.peek().is(TType::RBRACE)) {
                m_in.next();
                m_line_state = LineState::MAIN;
                if (m_in.peek().is_end())
                    return true;
                else
                    return false;
            }
            else if (collect_ident(name) &&
                collect_optional_const_assignment(value, m_defgroup_id)) {
                g_obj_module->add_global_def(name, value);
                m_defgroup_id = value + 1;
                m_line_state = LineState::DEFGROUP3;
                continue;
            }
            else
                return false;

        case LineState::DEFGROUP3:      // wait for comma
            if (m_in.peek().is(TType::RBRACE)) {
                m_in.next();
                m_line_state = LineState::MAIN;
                if (m_in.peek().is_end())
                    return true;
                else
                    return false;
            }
            else if (m_in.peek().is(TType::COMMA)) {
                m_in.next();
                m_line_state = LineState::DEFGROUP2;
                continue;
            }
            else
                return false;

        default:
            assert(false && "invalid LineState");
        }
    }
}

bool LineParser::parse_defvars() {
    string name;
    int size = 1;
    int count = 0;

    while (true) {
        if (m_in.peek().is_end())
            return true;

        switch (m_line_state) {
        case LineState::DEFVARS1:      // wait of '{'
            m_defgroup_id = 0;
            if (m_in.peek().is(TType::LBRACE)) {
                m_in.next();
                m_line_state = LineState::DEFVARS2;
                continue;
            }
            else
                return false;

        case LineState::DEFVARS2:       // wait for constant definition 
            if (m_in.peek().is(TType::RBRACE)) {
                m_in.next();
                m_line_state = LineState::MAIN;
                if (m_in.peek().is_end())
                    return true;
                else
                    return false;
            }
            else if (collect_defvars_size(size) &&
                collect_const_expr(count) &&
                m_in.peek().is_end()) {
                m_defvars_addr += size * count;
                if (m_defvars_update)
                    m_defvars_prev_addr = m_defvars_addr;
                continue;
            }
            else if (collect_ident(name) &&
                     collect_defvars_size(size) &&
                     collect_const_expr(count) &&
                     m_in.peek().is_end()) {
                g_obj_module->add_global_def(name, m_defvars_addr);
                m_defvars_addr += size * count;
                if (m_defvars_update)
                    m_defvars_prev_addr = m_defvars_addr;
                continue;
            }
            else
                return false;

        default:
            assert(false && "invalid LineState");
        }
    }
}

bool LineParser::collect_ident(string& name) {
    if (!m_in.peek().is(TType::IDENT))
        return false;
    name = m_in.peek().svalue();
    m_in.next();
    return true;
}

bool LineParser::collect_defvars_size(int& size) {
    if (m_in.peek(0).keyword() == Keyword::DS &&
        m_in.peek(1).is(TType::DOT)) {
        m_in.next(2);

        switch (m_in.peek().keyword()) {
        case Keyword::B:
            m_in.next();
            size = 1;
            return true;

        case Keyword::W:
            m_in.next();
            size = 2;
            return true;

        case Keyword::P:
            m_in.next();
            size = 3;
            return true;

        case Keyword::Q:
            m_in.next();
            size = 4;
            return true;

        default:
            return false;
        }
    }
    else
        return false;
}

bool LineParser::collect_const_expr(int& value) {
    Expr expr;

    if (!expr.parse(m_in, false))
        return false;

    if (!expr.eval_const(value)) {
        g_error->error_constant_expression_expected();
        return false;
    }

    return true;
}

bool LineParser::collect_optional_const_assignment(int& value, int default_value) {
    value = default_value;
    if (m_in.peek().operator_() != Operator::EQ)
        return true; // no assignment, defaults to 1

    m_in.next(); // consume '='

    if (!collect_const_expr(value)) 
        return false;

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

void LineParser::action_defs_const_expr() {
    g_obj_module->add_defs(m_elems.elems[2-1].const_value, g_options->filler());


}

void LineParser::action_ds_const_expr() {
    g_obj_module->add_defs(m_elems.elems[2-1].const_value, g_options->filler());


}

void LineParser::action_defs_const_expr_comma_const_expr() {
    g_obj_module->add_defs(m_elems.elems[2-1].const_value, m_elems.elems[4-1].const_value);


}

void LineParser::action_ds_const_expr_comma_const_expr() {
    g_obj_module->add_defs(m_elems.elems[2-1].const_value, m_elems.elems[4-1].const_value);


}

void LineParser::action_defs_const_expr_comma_str() {
    g_obj_module->add_defs(m_elems.elems[2-1].const_value, m_elems.elems[4-1].token.svalue());


}

void LineParser::action_ds_const_expr_comma_str() {
    g_obj_module->add_defs(m_elems.elems[2-1].const_value, m_elems.elems[4-1].token.svalue());


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
    g_obj_module->add_cu_wait(m_elems.elems[4-1].const_value, m_elems.elems[6-1].const_value);


}

void LineParser::action_cu_dot_move_const_expr_comma_const_expr() {
    g_obj_module->add_cu_move(m_elems.elems[4-1].const_value, m_elems.elems[6-1].const_value);


}

void LineParser::action_cu_dot_stop() {
    g_obj_module->add_cu_stop();


}

void LineParser::action_cu_dot_nop() {
    g_obj_module->add_cu_nop();


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

