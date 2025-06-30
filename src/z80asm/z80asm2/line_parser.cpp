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
      { {Keyword::ALIGN, 1}, {Keyword::ASSERT, 7}, {Keyword::ASSUME, 13}, {Keyword::BINARY, 16}, {Keyword::CALL_OZ, 19}, {Keyword::CALL_PKG, 22}, {Keyword::CU, 25}, {Keyword::DEFINE, 41}, {Keyword::EXTERN, 44}, {Keyword::GLOBAL, 47}, {Keyword::INCBIN, 56}, {Keyword::JP, 59}, {Keyword::JR, 62}, {Keyword::LD, 81}, {Keyword::NOP, 110}, {Keyword::ORG, 112}, {Keyword::PUBLIC, 115}, {Keyword::SECTION, 118}, },
      { {TType::IDENT, 50}, },
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
    { // 19: CALL_OZ
      { },
      { {TType::CONST_EXPR, 20}, },
      nullptr,
    },
    { // 20: CALL_OZ CONST_EXPR
      { },
      { {TType::END, 21}, },
      nullptr,
    },
    { // 21: CALL_OZ CONST_EXPR END
      { },
      { },
      &LineParser::action_call_oz_const_expr,
    },
    { // 22: CALL_PKG
      { },
      { {TType::CONST_EXPR, 23}, },
      nullptr,
    },
    { // 23: CALL_PKG CONST_EXPR
      { },
      { {TType::END, 24}, },
      nullptr,
    },
    { // 24: CALL_PKG CONST_EXPR END
      { },
      { },
      &LineParser::action_call_pkg_const_expr,
    },
    { // 25: CU
      { },
      { {TType::DOT, 26}, },
      nullptr,
    },
    { // 26: CU DOT
      { {Keyword::MOVE, 27}, {Keyword::NOP, 32}, {Keyword::STOP, 34}, {Keyword::WAIT, 36}, },
      { },
      nullptr,
    },
    { // 27: CU DOT MOVE
      { },
      { {TType::CONST_EXPR, 28}, },
      nullptr,
    },
    { // 28: CU DOT MOVE CONST_EXPR
      { },
      { {TType::COMMA, 29}, },
      nullptr,
    },
    { // 29: CU DOT MOVE CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 30}, },
      nullptr,
    },
    { // 30: CU DOT MOVE CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 31}, },
      nullptr,
    },
    { // 31: CU DOT MOVE CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_cu_dot_move_const_expr_comma_const_expr,
    },
    { // 32: CU DOT NOP
      { },
      { {TType::END, 33}, },
      nullptr,
    },
    { // 33: CU DOT NOP END
      { },
      { },
      &LineParser::action_cu_dot_nop,
    },
    { // 34: CU DOT STOP
      { },
      { {TType::END, 35}, },
      nullptr,
    },
    { // 35: CU DOT STOP END
      { },
      { },
      &LineParser::action_cu_dot_stop,
    },
    { // 36: CU DOT WAIT
      { },
      { {TType::CONST_EXPR, 37}, },
      nullptr,
    },
    { // 37: CU DOT WAIT CONST_EXPR
      { },
      { {TType::COMMA, 38}, },
      nullptr,
    },
    { // 38: CU DOT WAIT CONST_EXPR COMMA
      { },
      { {TType::CONST_EXPR, 39}, },
      nullptr,
    },
    { // 39: CU DOT WAIT CONST_EXPR COMMA CONST_EXPR
      { },
      { {TType::END, 40}, },
      nullptr,
    },
    { // 40: CU DOT WAIT CONST_EXPR COMMA CONST_EXPR END
      { },
      { },
      &LineParser::action_cu_dot_wait_const_expr_comma_const_expr,
    },
    { // 41: DEFINE
      { },
      { {TType::CONST_ASSIGN_LIST, 42}, },
      nullptr,
    },
    { // 42: DEFINE CONST_ASSIGN_LIST
      { },
      { {TType::END, 43}, },
      nullptr,
    },
    { // 43: DEFINE CONST_ASSIGN_LIST END
      { },
      { },
      &LineParser::action_define_const_assign_list,
    },
    { // 44: EXTERN
      { },
      { {TType::IDENT_LIST, 45}, },
      nullptr,
    },
    { // 45: EXTERN IDENT_LIST
      { },
      { {TType::END, 46}, },
      nullptr,
    },
    { // 46: EXTERN IDENT_LIST END
      { },
      { },
      &LineParser::action_extern_ident_list,
    },
    { // 47: GLOBAL
      { },
      { {TType::IDENT_LIST, 48}, },
      nullptr,
    },
    { // 48: GLOBAL IDENT_LIST
      { },
      { {TType::END, 49}, },
      nullptr,
    },
    { // 49: GLOBAL IDENT_LIST END
      { },
      { },
      &LineParser::action_global_ident_list,
    },
    { // 50: IDENT
      { {Keyword::EQU, 53}, },
      { {TType::COLON, 51}, },
      nullptr,
    },
    { // 51: IDENT COLON
      { },
      { {TType::END, 52}, },
      nullptr,
    },
    { // 52: IDENT COLON END
      { },
      { },
      &LineParser::action_ident_colon,
    },
    { // 53: IDENT EQU
      { },
      { {TType::EXPR, 54}, },
      nullptr,
    },
    { // 54: IDENT EQU EXPR
      { },
      { {TType::END, 55}, },
      nullptr,
    },
    { // 55: IDENT EQU EXPR END
      { },
      { },
      &LineParser::action_ident_equ_expr,
    },
    { // 56: INCBIN
      { },
      { {TType::RAW_STR, 57}, },
      nullptr,
    },
    { // 57: INCBIN RAW_STR
      { },
      { {TType::END, 58}, },
      nullptr,
    },
    { // 58: INCBIN RAW_STR END
      { },
      { },
      &LineParser::action_incbin_raw_str,
    },
    { // 59: JP
      { },
      { {TType::EXPR, 60}, },
      nullptr,
    },
    { // 60: JP EXPR
      { },
      { {TType::END, 61}, },
      nullptr,
    },
    { // 61: JP EXPR END
      { },
      { },
      &LineParser::action_jp_expr,
    },
    { // 62: JR
      { {Keyword::C, 63}, {Keyword::NC, 69}, {Keyword::NZ, 73}, {Keyword::Z, 77}, },
      { {TType::EXPR, 67}, },
      nullptr,
    },
    { // 63: JR C
      { },
      { {TType::COMMA, 64}, },
      nullptr,
    },
    { // 64: JR C COMMA
      { },
      { {TType::EXPR, 65}, },
      nullptr,
    },
    { // 65: JR C COMMA EXPR
      { },
      { {TType::END, 66}, },
      nullptr,
    },
    { // 66: JR C COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_c_comma_expr,
    },
    { // 67: JR EXPR
      { },
      { {TType::END, 68}, },
      nullptr,
    },
    { // 68: JR EXPR END
      { },
      { },
      &LineParser::action_jr_expr,
    },
    { // 69: JR NC
      { },
      { {TType::COMMA, 70}, },
      nullptr,
    },
    { // 70: JR NC COMMA
      { },
      { {TType::EXPR, 71}, },
      nullptr,
    },
    { // 71: JR NC COMMA EXPR
      { },
      { {TType::END, 72}, },
      nullptr,
    },
    { // 72: JR NC COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nc_comma_expr,
    },
    { // 73: JR NZ
      { },
      { {TType::COMMA, 74}, },
      nullptr,
    },
    { // 74: JR NZ COMMA
      { },
      { {TType::EXPR, 75}, },
      nullptr,
    },
    { // 75: JR NZ COMMA EXPR
      { },
      { {TType::END, 76}, },
      nullptr,
    },
    { // 76: JR NZ COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nz_comma_expr,
    },
    { // 77: JR Z
      { },
      { {TType::COMMA, 78}, },
      nullptr,
    },
    { // 78: JR Z COMMA
      { },
      { {TType::EXPR, 79}, },
      nullptr,
    },
    { // 79: JR Z COMMA EXPR
      { },
      { {TType::END, 80}, },
      nullptr,
    },
    { // 80: JR Z COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_z_comma_expr,
    },
    { // 81: LD
      { {Keyword::A, 82}, {Keyword::B, 94}, {Keyword::C, 98}, {Keyword::IX, 102}, {Keyword::IY, 106}, },
      { },
      nullptr,
    },
    { // 82: LD A
      { },
      { {TType::COMMA, 83}, },
      nullptr,
    },
    { // 83: LD A COMMA
      { {Keyword::A, 84}, {Keyword::B, 86}, },
      { {TType::EXPR, 88}, {TType::LPAREN, 90}, },
      nullptr,
    },
    { // 84: LD A COMMA A
      { },
      { {TType::END, 85}, },
      nullptr,
    },
    { // 85: LD A COMMA A END
      { },
      { },
      &LineParser::action_ld_a_comma_a,
    },
    { // 86: LD A COMMA B
      { },
      { {TType::END, 87}, },
      nullptr,
    },
    { // 87: LD A COMMA B END
      { },
      { },
      &LineParser::action_ld_a_comma_b,
    },
    { // 88: LD A COMMA EXPR
      { },
      { {TType::END, 89}, },
      nullptr,
    },
    { // 89: LD A COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_a_comma_expr,
    },
    { // 90: LD A COMMA LPAREN
      { },
      { {TType::EXPR, 91}, },
      nullptr,
    },
    { // 91: LD A COMMA LPAREN EXPR
      { },
      { {TType::RPAREN, 92}, },
      nullptr,
    },
    { // 92: LD A COMMA LPAREN EXPR RPAREN
      { },
      { {TType::END, 93}, },
      nullptr,
    },
    { // 93: LD A COMMA LPAREN EXPR RPAREN END
      { },
      { },
      &LineParser::action_ld_a_comma_lparen_expr_rparen,
    },
    { // 94: LD B
      { },
      { {TType::COMMA, 95}, },
      nullptr,
    },
    { // 95: LD B COMMA
      { },
      { {TType::EXPR, 96}, },
      nullptr,
    },
    { // 96: LD B COMMA EXPR
      { },
      { {TType::END, 97}, },
      nullptr,
    },
    { // 97: LD B COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_b_comma_expr,
    },
    { // 98: LD C
      { },
      { {TType::COMMA, 99}, },
      nullptr,
    },
    { // 99: LD C COMMA
      { },
      { {TType::EXPR, 100}, },
      nullptr,
    },
    { // 100: LD C COMMA EXPR
      { },
      { {TType::END, 101}, },
      nullptr,
    },
    { // 101: LD C COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_c_comma_expr,
    },
    { // 102: LD IX
      { },
      { {TType::COMMA, 103}, },
      nullptr,
    },
    { // 103: LD IX COMMA
      { },
      { {TType::EXPR, 104}, },
      nullptr,
    },
    { // 104: LD IX COMMA EXPR
      { },
      { {TType::END, 105}, },
      nullptr,
    },
    { // 105: LD IX COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_ix_comma_expr,
    },
    { // 106: LD IY
      { },
      { {TType::COMMA, 107}, },
      nullptr,
    },
    { // 107: LD IY COMMA
      { },
      { {TType::EXPR, 108}, },
      nullptr,
    },
    { // 108: LD IY COMMA EXPR
      { },
      { {TType::END, 109}, },
      nullptr,
    },
    { // 109: LD IY COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_iy_comma_expr,
    },
    { // 110: NOP
      { },
      { {TType::END, 111}, },
      nullptr,
    },
    { // 111: NOP END
      { },
      { },
      &LineParser::action_nop,
    },
    { // 112: ORG
      { },
      { {TType::CONST_EXPR, 113}, },
      nullptr,
    },
    { // 113: ORG CONST_EXPR
      { },
      { {TType::END, 114}, },
      nullptr,
    },
    { // 114: ORG CONST_EXPR END
      { },
      { },
      &LineParser::action_org_const_expr,
    },
    { // 115: PUBLIC
      { },
      { {TType::IDENT_LIST, 116}, },
      nullptr,
    },
    { // 116: PUBLIC IDENT_LIST
      { },
      { {TType::END, 117}, },
      nullptr,
    },
    { // 117: PUBLIC IDENT_LIST END
      { },
      { },
      &LineParser::action_public_ident_list,
    },
    { // 118: SECTION
      { },
      { {TType::IDENT, 119}, },
      nullptr,
    },
    { // 119: SECTION IDENT
      { },
      { {TType::END, 120}, },
      nullptr,
    },
    { // 120: SECTION IDENT END
      { },
      { },
      &LineParser::action_section_ident,
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
    }
    return *this;
}

LineParser::Elem::~Elem() {
    delete expr;
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

