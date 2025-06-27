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
      { {Keyword::ASSUME, 1}, {Keyword::JP, 10}, {Keyword::JR, 13}, {Keyword::LD, 32}, {Keyword::NOP, 61}, },
      { {TType::IDENT, 4}, },
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
    { // 4: IDENT
      { {Keyword::EQU, 7}, },
      { {TType::COLON, 5}, },
      nullptr,
    },
    { // 5: IDENT COLON
      { },
      { {TType::END, 6}, },
      nullptr,
    },
    { // 6: IDENT COLON END
      { },
      { },
      &LineParser::action_ident_colon,
    },
    { // 7: IDENT EQU
      { },
      { {TType::EXPR, 8}, },
      nullptr,
    },
    { // 8: IDENT EQU EXPR
      { },
      { {TType::END, 9}, },
      nullptr,
    },
    { // 9: IDENT EQU EXPR END
      { },
      { },
      &LineParser::action_ident_equ_expr,
    },
    { // 10: JP
      { },
      { {TType::EXPR, 11}, },
      nullptr,
    },
    { // 11: JP EXPR
      { },
      { {TType::END, 12}, },
      nullptr,
    },
    { // 12: JP EXPR END
      { },
      { },
      &LineParser::action_jp_expr,
    },
    { // 13: JR
      { {Keyword::C, 14}, {Keyword::NC, 20}, {Keyword::NZ, 24}, {Keyword::Z, 28}, },
      { {TType::EXPR, 18}, },
      nullptr,
    },
    { // 14: JR C
      { },
      { {TType::COMMA, 15}, },
      nullptr,
    },
    { // 15: JR C COMMA
      { },
      { {TType::EXPR, 16}, },
      nullptr,
    },
    { // 16: JR C COMMA EXPR
      { },
      { {TType::END, 17}, },
      nullptr,
    },
    { // 17: JR C COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_c_comma_expr,
    },
    { // 18: JR EXPR
      { },
      { {TType::END, 19}, },
      nullptr,
    },
    { // 19: JR EXPR END
      { },
      { },
      &LineParser::action_jr_expr,
    },
    { // 20: JR NC
      { },
      { {TType::COMMA, 21}, },
      nullptr,
    },
    { // 21: JR NC COMMA
      { },
      { {TType::EXPR, 22}, },
      nullptr,
    },
    { // 22: JR NC COMMA EXPR
      { },
      { {TType::END, 23}, },
      nullptr,
    },
    { // 23: JR NC COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nc_comma_expr,
    },
    { // 24: JR NZ
      { },
      { {TType::COMMA, 25}, },
      nullptr,
    },
    { // 25: JR NZ COMMA
      { },
      { {TType::EXPR, 26}, },
      nullptr,
    },
    { // 26: JR NZ COMMA EXPR
      { },
      { {TType::END, 27}, },
      nullptr,
    },
    { // 27: JR NZ COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_nz_comma_expr,
    },
    { // 28: JR Z
      { },
      { {TType::COMMA, 29}, },
      nullptr,
    },
    { // 29: JR Z COMMA
      { },
      { {TType::EXPR, 30}, },
      nullptr,
    },
    { // 30: JR Z COMMA EXPR
      { },
      { {TType::END, 31}, },
      nullptr,
    },
    { // 31: JR Z COMMA EXPR END
      { },
      { },
      &LineParser::action_jr_z_comma_expr,
    },
    { // 32: LD
      { {Keyword::A, 33}, {Keyword::B, 45}, {Keyword::C, 49}, {Keyword::IX, 53}, {Keyword::IY, 57}, },
      { },
      nullptr,
    },
    { // 33: LD A
      { },
      { {TType::COMMA, 34}, },
      nullptr,
    },
    { // 34: LD A COMMA
      { {Keyword::A, 35}, {Keyword::B, 37}, },
      { {TType::EXPR, 39}, {TType::LPAREN, 41}, },
      nullptr,
    },
    { // 35: LD A COMMA A
      { },
      { {TType::END, 36}, },
      nullptr,
    },
    { // 36: LD A COMMA A END
      { },
      { },
      &LineParser::action_ld_a_comma_a,
    },
    { // 37: LD A COMMA B
      { },
      { {TType::END, 38}, },
      nullptr,
    },
    { // 38: LD A COMMA B END
      { },
      { },
      &LineParser::action_ld_a_comma_b,
    },
    { // 39: LD A COMMA EXPR
      { },
      { {TType::END, 40}, },
      nullptr,
    },
    { // 40: LD A COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_a_comma_expr,
    },
    { // 41: LD A COMMA LPAREN
      { },
      { {TType::EXPR, 42}, },
      nullptr,
    },
    { // 42: LD A COMMA LPAREN EXPR
      { },
      { {TType::RPAREN, 43}, },
      nullptr,
    },
    { // 43: LD A COMMA LPAREN EXPR RPAREN
      { },
      { {TType::END, 44}, },
      nullptr,
    },
    { // 44: LD A COMMA LPAREN EXPR RPAREN END
      { },
      { },
      &LineParser::action_ld_a_comma_lparen_expr_rparen,
    },
    { // 45: LD B
      { },
      { {TType::COMMA, 46}, },
      nullptr,
    },
    { // 46: LD B COMMA
      { },
      { {TType::EXPR, 47}, },
      nullptr,
    },
    { // 47: LD B COMMA EXPR
      { },
      { {TType::END, 48}, },
      nullptr,
    },
    { // 48: LD B COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_b_comma_expr,
    },
    { // 49: LD C
      { },
      { {TType::COMMA, 50}, },
      nullptr,
    },
    { // 50: LD C COMMA
      { },
      { {TType::EXPR, 51}, },
      nullptr,
    },
    { // 51: LD C COMMA EXPR
      { },
      { {TType::END, 52}, },
      nullptr,
    },
    { // 52: LD C COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_c_comma_expr,
    },
    { // 53: LD IX
      { },
      { {TType::COMMA, 54}, },
      nullptr,
    },
    { // 54: LD IX COMMA
      { },
      { {TType::EXPR, 55}, },
      nullptr,
    },
    { // 55: LD IX COMMA EXPR
      { },
      { {TType::END, 56}, },
      nullptr,
    },
    { // 56: LD IX COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_ix_comma_expr,
    },
    { // 57: LD IY
      { },
      { {TType::COMMA, 58}, },
      nullptr,
    },
    { // 58: LD IY COMMA
      { },
      { {TType::EXPR, 59}, },
      nullptr,
    },
    { // 59: LD IY COMMA EXPR
      { },
      { {TType::END, 60}, },
      nullptr,
    },
    { // 60: LD IY COMMA EXPR END
      { },
      { },
      &LineParser::action_ld_iy_comma_expr,
    },
    { // 61: NOP
      { },
      { {TType::END, 62}, },
      nullptr,
    },
    { // 62: NOP END
      { },
      { },
      &LineParser::action_nop,
    },
    //@@END
};

LineParser::Elem::Elem() {
}

LineParser::Elem::Elem(const Elem& other)
    : token(other.token)
    , expr(other.expr ? other.expr->clone() : nullptr)
    , const_expr(other.const_expr)
    , const_value(other.const_value) {
}

LineParser::Elem& LineParser::Elem::operator=(const Elem& other) {
    if (&other != this) {
        token = other.token;
        expr = other.expr->clone();
        const_value = other.const_value;
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

    if (m_in.peek().is(TType::END)) {
        return true;        // empty line
    }
    else {
        switch (m_in.peek().keyword()) {
        case Keyword::DEFINE:
            m_in.next();
            return parse_define_args();
        case Keyword::EXTERN:
            m_in.next();
            return parse_extern_args();
        case Keyword::PUBLIC:
            m_in.next();
            return parse_public_args();
        case Keyword::GLOBAL:
            m_in.next();
            return parse_global_args();
        case Keyword::SECTION:
            m_in.next();
            return parse_section_args();
        default:;
            // fall through
        }
    }

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

        // check CONST_EXPR
        m_in.set_pos(queue_elem.in_pos);
        auto it = cur_state.ttype_next.find(TType::CONST_EXPR);
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

// parse name=expr,name,name=expr
bool LineParser::parse_define_args(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed
    else
        return parse_define_args();
}

bool LineParser::parse_extern_args(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed
    else
        return parse_extern_args();
}

bool LineParser::parse_public_args(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed
    else
        return parse_public_args();
}

bool LineParser::parse_global_args(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed
    else
        return parse_global_args();
}

bool LineParser::parse_section_args(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed
    else
        return parse_section_args();
}

bool LineParser::parse_define_args() {
    while (true) {
        string name;
        int value = 0;
        if (!parse_name(name))
            return false;

        if (m_in.peek().is(TType::OPERATOR) &&
            m_in.peek().operator_() == Operator::EQ) {
            m_in.next();
            if (!parse_const_expr(value))
                return false;
            action_define(name, value);
        }
        else {
            action_define(name);
        }

        if (m_in.peek().is(TType::END))
            return true;

        if (!parse_comma())
            return false;
    }
}

bool LineParser::parse_extern_args() {
    vector<string> names;
    if (!parse_ident_list(names))
        return false;

    for (auto& name : names)
        action_extern(name);

    return true;
}

bool LineParser::parse_public_args() {
    vector<string> names;
    if (!parse_ident_list(names))
        return false;

    for (auto& name : names)
        action_public(name);

    return true;
}

bool LineParser::parse_global_args() {
    vector<string> names;
    if (!parse_ident_list(names))
        return false;

    for (auto& name : names)
        action_global(name);

    return true;
}

bool LineParser::parse_section_args() {
    string name;
    if (!parse_name(name))
        return false;
    if (!parse_end())
        return false;
    action_section(name);
    return true;
}

bool LineParser::parse_ident_list(vector<string>& names) {
    names.clear();
    while (true) {
        string name;
        if (!parse_name(name))
            return false;

        names.push_back(name);

        if (m_in.peek().is(TType::END))
            return true;

        if (!parse_comma())
            return false;
    }
}

//@@BEGIN:actions_impl
void LineParser::action_ident_colon() {
	g_obj_module->add_label(m_elems.elems[1-1].token.svalue());


}

void LineParser::action_ident_equ_expr() {
	g_obj_module->add_equ(m_elems.elems[1-1].token.svalue(), m_elems.elems[3-1].expr->clone());


}

void LineParser::action_assume_const_expr() {
	g_obj_module->set_assume(m_elems.elems[2-1].const_value);

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

bool LineParser::parse_name(string& name) {
    if (m_in.peek().is(TType::IDENT)) {
        name = m_in.peek().svalue();
        m_in.next();
        return true;
    }
    else {
        g_error->error_expected_ident();
        return false;
    }
}

bool LineParser::parse_const_expr(int& value) {
    value = 0;
    Expr* expr = new Expr;
    if (!expr->parse(m_in, false)) {
        delete expr;
        return false;
    }

    g_obj_module->cur_section()->add_instr();
    expr->lookup_symbols();
    if (!expr->eval_const(value)) {
        delete expr;
        g_error->error_constant_expression_expected();
        return false;

    }
    else {
        delete expr;
        return true;
    }
}

bool LineParser::parse_equal() {
    if (m_in.peek().is(TType::OPERATOR) && m_in.peek().operator_()==Operator::EQ) {
        m_in.next();
        return true;
    }
    else {
        g_error->error_expected_equal();
        return false;
    }
}

bool LineParser::parse_comma() {
    if (m_in.peek().is(TType::COMMA)) {
        m_in.next();
        return true;
    }
    else {
        g_error->error_expected_comma();
        return false;
    }
}

bool LineParser::parse_end() {
    if (m_in.peek().is(TType::END)) {
        return true;
    }
    else {
        g_error->error_expected_eol();
        return false;
    }
}

void LineParser::action_define(const string& name, int value) {
    g_obj_module->add_global_def(name, value);
}

void LineParser::action_extern(const string& name) {
    g_obj_module->declare_extern(name);
}

void LineParser::action_public(const string& name) {
    g_obj_module->declare_public(name);
}

void LineParser::action_global(const string& name) {
    g_obj_module->declare_global(name);
}

void LineParser::action_section(const string& name) {
    g_obj_module->set_cur_section(name);
}
