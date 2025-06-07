//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "input_files.h"
#include "location.h"
#include "operator.h"
#include "preproc.h"
#include "scanner.h"
#include "symbol.h"
#include "token.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <cassert>
#include <cctype>
#include <cstring>
#include <deque>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <list>
#include <queue>
#include <sstream>
#include <stack>
#include <string>
#include <unordered_map>
#include <vector>
#include "obj_module.h"
using namespace std;

//-----------------------------------------------------------------------------
// Object Module
//-----------------------------------------------------------------------------

class ObjModule1 {
public:
    ObjModule1() {}
    ObjModule1(const ObjModule1& other) = delete;
    virtual ~ObjModule1();
    ObjModule1& operator=(const ObjModule1& other) = delete;

    Symtab* get_symtab() { return &m_symtab; }
    int get_asmpc() const { return m_asmpc; }
    int get_offset() const { return static_cast<int>(m_code.size()); }

    void clear();
    void next_opcode();
    void add_constant(const string& name, Expr* expr);
    void add_label(const string& name);
    void set_assume(int value) { m_assume = value; }
    void add_opcode_void(long long opcode);
    void add_opcode_jr(long long opcode, Expr* expr);
    void add_opcode_n(long long opcode, Expr* expr);
    void add_opcode_nn(long long opcode, Expr* expr);

private:
    Symtab m_symtab;
    vector<unsigned char> m_code;
    vector<Patch*> m_patches;
    int m_asmpc{ 0 };
};


//@@.cpp

//-----------------------------------------------------------------------------
// Object Module
//-----------------------------------------------------------------------------

ObjModule::~ObjModule() {
    clear();
}

void ObjModule::clear() {
    m_symtab.clear();
    m_code.clear();
    for (auto& patch : m_patches)
        delete patch;
    m_patches.clear();
    m_asmpc = get_offset();
    m_assume = 0;
}

void ObjModule::next_opcode() {
    m_asmpc = get_offset();
}

void ObjModule::add_label(const string& name) {
    if (m_symtab.get_symbol(name)) {
        g_error.error_duplicate_definition(name);
    }
    else {
        auto expr = new Expr;
        bool ok = expr->parse(std::to_string(m_asmpc));
        assert(ok);
        auto symbol = new Symbol(name);
        symbol->set_sym_type(SymType::ADDRESS);
        symbol->set_expr(expr);
        m_symtab.add_symbol(name, symbol);
    }
}

void ObjModule::add_opcode_void(long long opcode) {
}

void ObjModule::add_opcode_jr(long long opcode, Expr* expr) {
    add_opcode_void(opcode);
    auto patch = new Patch(expr, get_offset(), PatchType::JR);
    for (int i = 0; i < patch->size(); ++i)
        add_opcode_void(0);
    m_patches.push_back(patch);
}

void ObjModule::add_opcode_n(long long opcode, Expr* expr) {
    add_opcode_void(opcode);
    auto patch = new Patch(expr, get_offset(), PatchType::N);
    for (int i = 0; i < patch->size(); ++i)
        add_opcode_void(0);
    m_patches.push_back(patch);
}

void ObjModule::add_opcode_nn(long long opcode, Expr* expr) {
    add_opcode_void(opcode);
    auto patch = new Patch(expr, get_offset(), PatchType::NN);
    for (int i = 0; i < patch->size(); ++i)
        add_opcode_void(0);
    m_patches.push_back(patch);
}

//@@.h

//-----------------------------------------------------------------------------
// Line parser
//-----------------------------------------------------------------------------

class LineParser {
public:
    bool parse(const string& line);

private:
    struct Elem {
        Token token;
        Expr* expr{ nullptr };
        int expr_value{ 0 };

        Elem() {}
        Elem(const Elem& other)
            : token(other.token), expr(other.expr ? other.expr->clone() : nullptr), expr_value(other.expr_value) {}
        Elem& operator=(const Elem& other) {
            if (&other != this) {
                token = other.token;
                expr = other.expr->clone();
                expr_value = other.expr_value;
            }
            return *this;
        }
        virtual ~Elem() {
            delete expr;
        }
    };

    struct Elems {
        vector<Elem> elems;

        Elems() {};
        Elems(const Elems& other) {
            elems.insert(elems.end(), other.elems.begin(), other.elems.end());
        }
        Elems& operator = (const Elems& other) {
            if (&other != this)
                elems.insert(elems.end(), other.elems.begin(), other.elems.end());
            return *this;
        }
        virtual ~Elems() {
            elems.clear();
        }
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
    void action_ld_a_comma_lparen_expr_rparen();
    void action_ld_a_comma_a();
    void action_ld_a_comma_b();
    //@@END

    // state in the parsing state machine
	struct State {
		unordered_map<Keyword, int> keyword_next;
		unordered_map<TType, int>	ttype_next;
		void(LineParser::*action)();
	};

	static inline State m_states[] = {
		//@@BEGIN: states
		{ /* 0:  */
		  { {Keyword::ASSUME, 1}, {Keyword::JR, 10}, {Keyword::LD, 29}, {Keyword::NOP, 42}, },
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
		  { {Keyword::A, 30}, },
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
		{ /* 42: NOP */
		  { },
		  { {TType::END, 43}, },
		  nullptr,
		},
		{ /* 43: NOP END */
		  { },
		  { },
		  &LineParser::action_nop,
		},
		//@@END
	};
};

//@@.cpp

//-----------------------------------------------------------------------------
// Line parser
//-----------------------------------------------------------------------------

bool LineParser::parse(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed

    if (m_in.peek().is(TType::END))
        return true;        // empty line

    vector<ParseQueueElem> parse_queue;

    // add initial state
    ParseQueueElem queue_elem;
    queue_elem.state = 0;
    queue_elem.in_pos = m_in.get_pos();
    parse_queue.push_back(queue_elem);

    // check all possible paths
    bool parse_ok = false;
    while (!parse_queue.empty()) {
        ParseQueueElem queue_elem = parse_queue.back();
        parse_queue.pop_back();
        auto& cur_state = m_states[queue_elem.state];

        // check if at final state
        if (cur_state.action) {
            g_obj_module.next_opcode();
            m_elems = queue_elem.elems; // setup data for function call
            (this->*cur_state.action)();
            parse_ok = true;
            break;
        }

        // check CONST_EXPR
        m_in.set_pos(queue_elem.in_pos);
        auto it = cur_state.ttype_next.find(TType::CONST_EXPR);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.expr = new Expr;
            bool ok = elem.expr->parse(m_in);
            if (!ok) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                bool ok = elem.expr->eval(g_obj_module.get_asmpc(), g_obj_module.get_symtab(), elem.expr_value);
                if (!ok) {
                    delete elem.expr;
                    elem.expr = nullptr;
                }
                else {
                    auto new_state = queue_elem;
                    new_state.state = it->second;
                    new_state.in_pos = m_in.get_pos();
                    new_state.elems.elems.push_back(elem);
                    parse_queue.push_back(new_state);
                }
            }
        }

        // check EXPR
        m_in.set_pos(queue_elem.in_pos);
        it = cur_state.ttype_next.find(TType::EXPR);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::EXPR, false };
            elem.expr = new Expr;
            bool ok = elem.expr->parse(m_in);
            if (!ok) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                auto new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.get_pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check token
        m_in.set_pos(queue_elem.in_pos);
        TType ttype = m_in.peek().get_ttype();
        it = cur_state.ttype_next.find(ttype);
        if (it != cur_state.ttype_next.end()) {
            Elem elem;
            elem.token = m_in.peek();
            m_in.next();

            auto new_state = queue_elem;
            new_state.state = it->second;
            new_state.in_pos = m_in.get_pos();
            new_state.elems.elems.push_back(elem);
            parse_queue.push_back(new_state);
        }

        // check keyword
        m_in.set_pos(queue_elem.in_pos);
        Keyword keyword = m_in.peek().get_keyword();
        if (keyword != Keyword::NONE) {
            auto it = cur_state.keyword_next.find(keyword);
            if (it != cur_state.keyword_next.end()) {
                Elem elem;
                elem.token = m_in.peek();
                m_in.next();

                auto new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.get_pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }
    }

    if (!parse_ok)
        g_error.error_syntax();

    return parse_ok;
}

//@@BEGIN:actions_impl
void LineParser::action_ident_colon() {
	g_obj_module.add_label(m_elems.elems[1-1].token.get_svalue());


}

void LineParser::action_ident_equ_expr() {
	g_obj_module.add_constant(m_elems.elems[1-1].token.get_svalue(), m_elems.elems[3-1].expr->clone());


}

void LineParser::action_assume_const_expr() {
	g_obj_module.set_assume(m_elems.elems[2-1].expr_value);


}

void LineParser::action_nop() {
	g_obj_module.add_opcode_void(0x00);


}

void LineParser::action_jr_expr() {
	g_obj_module.add_opcode_jr(0x18, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_nz_comma_expr() {
	g_obj_module.add_opcode_jr(0x20, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_z_comma_expr() {
	g_obj_module.add_opcode_jr(0x28, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_nc_comma_expr() {
	g_obj_module.add_opcode_jr(0x30, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_c_comma_expr() {
	g_obj_module.add_opcode_jr(0x38, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_expr() {
	g_obj_module.add_opcode_n(0x3E, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_lparen_expr_rparen() {
	g_obj_module.add_opcode_nn(0x3A, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_a() {
	g_obj_module.add_opcode_void(0x7F);


}

void LineParser::action_ld_a_comma_b() {
	g_obj_module.add_opcode_void(0x78);

}

//@@END

//@@test

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

void parse_file(const string& filename) {
    g_preproc.clear();
    g_obj_module.clear();

    g_input_files.push_file(filename);
	string line;
	while (g_input_files.getline(line)) {
		g_preproc.expand(line);
		string expanded_line;
		while (g_preproc.getline(expanded_line)) {
			g_location.set_expanded_text(expanded_line);
			cout << g_location.get_filename() << ":" << g_location.get_line_num() << ": " << line << endl << expanded_line << endl;
            LineParser parser;
            if (!parser.parse(expanded_line))
                cout << "parse failed" << endl;
		}
	}
}

int main(int argc, char* argv[]) {
	for (int i = 1; i < argc; i++) {
		parse_file(argv[i]);
	}
}

