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
      { {Keyword::ASSUME, 1}, {Keyword::DEFINE, 4}, {Keyword::EXTERN, 7}, {Keyword::GLOBAL, 10}, {Keyword::JP, 19}, {Keyword::JR, 22}, {Keyword::LD, 41}, {Keyword::NOP, 70}, {Keyword::ORG, 72}, {Keyword::PUBLIC, 75}, {Keyword::SECTION, 78}, },
      { {TType::IDENT, 13}, },
      nullptr,
    },
    { // 1: ASSUME
      { },
      { {TType::CONST_EXPR, 2}, },
      nullptr,
    },
    { // 2: ASSUME CONST_EXPR
      { },
      { {TType::END, 3}, },
      nullptr,
    },
    { // 3: ASSUME CONST_EXPR END
      { },
      { },
      &LineParser::action_assume_const_expr,
    },
    { // 4: DEFINE
      { },
      { {TType::CONST_ASSIGN_LIST, 5}, },
      nullptr,
    },
    { // 5: DEFINE CONST_ASSIGN_LIST
      { },
      { {TType::END, 6}, },
      nullptr,
    },
    { // 6: DEFINE CONST_ASSIGN_LIST END
      { },
      { },
      &LineParser::action_define_const_assign_list,
    },
    { // 7: EXTERN
      { },
      { {TType::IDENT_LIST, 8}, },
      nullptr,
    },
    { // 8: EXTERN IDENT_LIST
      { },
      { {TType::END, 9}, },
      nullptr,
    },
    { // 9: EXTERN IDENT_LIST END
      { },
      { },
      &LineParser::action_extern_ident_list,
    },
    { // 10: GLOBAL
      { },
      { {TType::IDENT_LIST, 11}, },
      nullptr,
    },
    { // 11: GLOBAL IDENT_LIST
      { },
      { {TType::END, 12}, },
      nullptr,
    },
    { // 12: GLOBAL IDENT_LIST END
      { },
      { },
      &LineParser::action_global_ident_list,
    },
    { // 13: IDENT
      { {Keyword::EQU, 16}, },
      { {TType::COLON, 14}, },
      nullptr,
    },
    { // 14: IDENT COLON
      { },
      { {TType::END, 15}, },
      nullptr,
    },
    { // 15: IDENT COLON END
      { },
      { },
      &LineParser::action_ident_colon,
    },
    { // 16: IDENT EQU
      { },
      { {TType::EXPR, 17}, },
      nullptr,
    },
    { // 17: IDENT EQU EXPR
      { },
      { {TType::END, 18}, },
      nullptr,
    },
    { // 18: IDENT EQU EXPR END
      { },
      { },
      &LineParser::action_ident_equ_expr,
    },
    { // 19: JP
      { },
      { {TType::EXPR, 20}, },
      nullptr,
    },
    { // 20: JP EXPR
      { },
      { {TType::END, 21}, },
      nullptr,
    },
    { // 21: JP EXPR END
      { },
      { },
      &LineParser::action_jp_expr,
    },
    { // 22: JR
      { {Keyword::C, 23}, {Keyword::NC, 29}, {Keyword::NZ, 33}, {Keyword::Z, 37}, },
      { {TType::EXPR, 27}, },
      nullptr,
    },
    { // 23: JR C
      { },
      { {TType::COMMA, 24}, },
      nullptr,
    },
    { // 24: JR C COMMA
      { },
      { {TType::EXPR, 25}, },
      nullptr,
    },
    { // 25: JR C COMMA EXPR
      { },
      { {TType::END, 26}, },
      nullptr,
    },
    { // 26: JR C COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_c_comma_expr,
    },
    { // 27: JR EXPR
      { },
      { {TType::END, 28}, },
      nullptr,
    },
    { // 28: JR EXPR END
      { },
      { },
      &LineParser::action_jr_expr,
    },
    { // 29: JR NC
      { },
      { {TType::COMMA, 30}, },
      nullptr,
    },
    { // 30: JR NC COMMA
      { },
      { {TType::EXPR, 31}, },
      nullptr,
    },
    { // 31: JR NC COMMA EXPR
      { },
      { {TType::END, 32}, },
      nullptr,
    },
    { // 32: JR NC COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nc_comma_expr,
    },
    { // 33: JR NZ
      { },
      { {TType::COMMA, 34}, },
      nullptr,
    },
    { // 34: JR NZ COMMA
      { },
      { {TType::EXPR, 35}, },
      nullptr,
    },
    { // 35: JR NZ COMMA EXPR
      { },
      { {TType::END, 36}, },
      nullptr,
    },
    { // 36: JR NZ COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nz_comma_expr,
    },
    { // 37: JR Z
      { },
      { {TType::COMMA, 38}, },
      nullptr,
    },
    { // 38: JR Z COMMA
      { },
      { {TType::EXPR, 39}, },
      nullptr,
    },
    { // 39: JR Z COMMA EXPR
      { },
      { {TType::END, 40}, },
      nullptr,
    },
    { // 40: JR Z COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_z_comma_expr,
    },
    { // 41: LD
      { {Keyword::A, 42}, {Keyword::B, 54}, {Keyword::C, 58}, {Keyword::IX, 62}, {Keyword::IY, 66}, },
      { },
      nullptr,
    },
    { // 42: LD A
      { },
      { {TType::COMMA, 43}, },
      nullptr,
    },
    { // 43: LD A COMMA
      { {Keyword::A, 44}, {Keyword::B, 46}, },
      { {TType::EXPR, 48}, {TType::LPAREN, 50}, },
      nullptr,
    },
    { // 44: LD A COMMA A
      { },
      { {TType::END, 45}, },
      nullptr,
    },
    { // 45: LD A COMMA A END
      { },
      { },
      &LineParser::action_ld_a_comma_a,
    },
    { // 46: LD A COMMA B
      { },
      { {TType::END, 47}, },
      nullptr,
    },
    { // 47: LD A COMMA B END
      { },
      { },
      &LineParser::action_ld_a_comma_b,
    },
    { // 48: LD A COMMA EXPR
      { },
      { {TType::END, 49}, },
      nullptr,
    },
    { // 49: LD A COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_a_comma_expr,
    },
    { // 50: LD A COMMA LPAREN
      { },
      { {TType::EXPR, 51}, },
      nullptr,
    },
    { // 51: LD A COMMA LPAREN EXPR
      { },
      { {TType::RPAREN, 52}, },
      nullptr,
    },
    { // 52: LD A COMMA LPAREN EXPR RPAREN
      { },
      { {TType::END, 53}, },
      nullptr,
    },
    { // 53: LD A COMMA LPAREN EXPR RPAREN END
      { },
      { },
      &LineParser::action_ld_a_comma_lparen_expr_rparen,
    },
    { // 54: LD B
      { },
      { {TType::COMMA, 55}, },
      nullptr,
    },
    { // 55: LD B COMMA
      { },
      { {TType::EXPR, 56}, },
      nullptr,
    },
    { // 56: LD B COMMA EXPR
      { },
      { {TType::END, 57}, },
      nullptr,
    },
    { // 57: LD B COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_b_comma_expr,
    },
    { // 58: LD C
      { },
      { {TType::COMMA, 59}, },
      nullptr,
    },
    { // 59: LD C COMMA
      { },
      { {TType::EXPR, 60}, },
      nullptr,
    },
    { // 60: LD C COMMA EXPR
      { },
      { {TType::END, 61}, },
      nullptr,
    },
    { // 61: LD C COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_c_comma_expr,
    },
    { // 62: LD IX
      { },
      { {TType::COMMA, 63}, },
      nullptr,
    },
    { // 63: LD IX COMMA
      { },
      { {TType::EXPR, 64}, },
      nullptr,
    },
    { // 64: LD IX COMMA EXPR
      { },
      { {TType::END, 65}, },
      nullptr,
    },
    { // 65: LD IX COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_ix_comma_expr,
    },
    { // 66: LD IY
      { },
      { {TType::COMMA, 67}, },
      nullptr,
    },
    { // 67: LD IY COMMA
      { },
      { {TType::EXPR, 68}, },
      nullptr,
    },
    { // 68: LD IY COMMA EXPR
      { },
      { {TType::END, 69}, },
      nullptr,
    },
    { // 69: LD IY COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_iy_comma_expr,
    },
    { // 70: NOP
      { },
      { {TType::END, 71}, },
      nullptr,
    },
    { // 71: NOP END
      { },
      { },
      &LineParser::action_nop,
    },
    { // 72: ORG
      { },
      { {TType::CONST_EXPR, 73}, },
      nullptr,
    },
    { // 73: ORG CONST_EXPR
      { },
      { {TType::END, 74}, },
      nullptr,
    },
    { // 74: ORG CONST_EXPR END
      { },
      { },
      &LineParser::action_org_const_expr,
    },
    { // 75: PUBLIC
      { },
      { {TType::IDENT_LIST, 76}, },
      nullptr,
    },
    { // 76: PUBLIC IDENT_LIST
      { },
      { {TType::END, 77}, },
      nullptr,
    },
    { // 77: PUBLIC IDENT_LIST END
      { },
      { },
      &LineParser::action_public_ident_list,
    },
    { // 78: SECTION
      { },
      { {TType::IDENT, 79}, },
      nullptr,
    },
    { // 79: SECTION IDENT
      { },
      { {TType::END, 80}, },
      nullptr,
    },
    { // 80: SECTION IDENT END
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
    , const_value(other.const_value)
    , ident_list(other.ident_list)
    , ident_value_list(other.ident_value_list) {
}

LineParser::Elem& LineParser::Elem::operator=(const Elem& other) {
    if (&other != this) {
        token = other.token;
        expr = other.expr->clone();
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
                    elem.expr->lookup_symbols();
                }
                if (elem.const_expr) {
                    if (!elem.expr->eval_const(elem.const_value)) {
                        g_error->error_constant_expression_expected();
                        return false;
                    }
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
            elem.token = Token{ TType::INT, false };
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

//@@BEGIN:actions_impl
void LineParser::action_assume_const_expr() {
	g_obj_module->set_assume(m_elems.elems[2-1].const_value);


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
