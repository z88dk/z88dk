//-----------------------------------------------------------------------------
// z80asm
// parser
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "errors.h"
#include "parse.h"
#include "preproc.h"
using namespace std;

void Parser::clear() {
	m_state = State::Main;
	m_line.clear();
	m_exprs.clear();
}

bool Parser::parse() {
	int start_errors = g_errors.count();

	while (g_preproc.getline(m_line)) {
		parse_line();
	}

	return start_errors == g_errors.count();
}

void Parser::parse_line() {
	m_exprs.clear();
	switch (m_state) {
	case State::Main: parse_line_main(); return;
	default: Assert(0); return;
	}
}

void Parser::parse_line_main() {
	int start_errors = g_errors.count();

	while (!m_line.at_end() && start_errors == g_errors.count()) {
		string label = check_label();
		if (!label.empty())
			g_asm.cur_section()->add_label(label);

		switch (m_line.peek().type()) {
		case TType::End:
            break;
		case TType::Newline:
			m_line.next();
			break;
		default:
			parse_main1();
		}
	}
}

string Parser::check_label() {
    if (m_line.peek(0).type() == TType::Dot &&
        m_line.peek(1).type() == TType::Ident &&
        m_line.peek(2).keyword() != Keyword::EQU) {
        m_line.next(2);
        return m_line.peek(-1).svalue();
    }
    else if (m_line.peek(0).type() == TType::Ident &&
        m_line.peek(1).type() == TType::Colon &&
        m_line.peek(2).keyword() != Keyword::EQU) {
        m_line.next(2);
        return m_line.peek(-2).svalue();
    }
    else
        return string();
}

void Parser::parse_symbol_declare(Symbol::Scope scope) {
	while (true) {
		// get identifier
		Token& token = m_line.peek();
		if (token.type() != TType::Ident) {
			g_errors.error(ErrCode::IdentExpected, m_line.peek_text());
			return;
		}
		g_symbols.declare(token.svalue(), scope);

		// get comma or end
		m_line.next();
		token = m_line.peek();
		switch (token.type()) {
		case TType::Comma:
			m_line.next();
			continue;
		case TType::End:
            return;
		case TType::Newline:
			m_line.next();
			return;
		default:
			g_errors.error(ErrCode::EolExpected, m_line.peek_text());
			return;
		}
	}
}

bool Parser::expr_in_parens() {
	Assert(m_exprs.size() >= 1);
	return m_exprs.back()->in_parens();
}

// emulate "CALL flag, target" on the Rabbit, by:
// jp !flag, temp ; call target ; temp:
void Parser::add_emul_call_flag(unsigned bytes_jump, unsigned bytes_call) {
	Assert(m_exprs.size() == 1);

	// create label and expression
	string temp_label_name = g_asm.cur_section()->autolabel();
	ScannedLine line{ temp_label_name };			// prepare to parse expression with temp label
	auto temp_label_expr = make_shared<Expr>(line);
	Assert(temp_label_expr->parse());		// parse temp label

	// jp !flag, temp
	g_asm.cur_section()->add_opcode_nn(bytes_jump, temp_label_expr, PatchExpr::Type::Word);

	// call target
	g_asm.cur_section()->add_opcode_nn(bytes_call, m_exprs[0], PatchExpr::Type::Word);

	// temp:
	g_asm.cur_section()->add_label(temp_label_name);
}

void Parser::add_call_function(const string& function_name) {
	Assert(m_exprs.size() == 0);

	// declare function as extern
	g_symbols.declare(function_name, Symbol::Scope::Extern);

	// create expression with function name
	ScannedLine line{ function_name };			// prepare to parse expression with function name
	auto function_expr = make_shared<Expr>(line);
	Assert(function_expr->parse());			// parse function name

	// add call instruction
	g_asm.cur_section()->add_opcode_nn(Z80_CALL, function_expr, PatchExpr::Type::Word);
}

void Parser::add_jump_relative(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_jump_relative(bytes, m_exprs[0]);
}

void Parser::add_z80n_mmu_n() {
	Assert(m_exprs.size() == 2);
	Assert(m_exprs[0]->is_const());

	int c = m_exprs[0]->value();
	if (c < 0 || c > 7)
		g_errors.error(ErrCode::IntRange, int_to_hex(c, 2));
	else
		g_asm.cur_section()->add_opcode_n(Z80N_MMU_N(c), m_exprs[1], PatchExpr::Type::UByte);
}

void Parser::add_z80n_mmu_a() {
	Assert(m_exprs.size() == 1);
	Assert(m_exprs[0]->is_const());

	int c = m_exprs[0]->value();
	if (c < 0 || c > 7)
		g_errors.error(ErrCode::IntRange, int_to_hex(c, 2));
	else
		g_asm.cur_section()->add_opcode(Z80N_MMU_A(c));
}

void Parser::add_restart() {
	Assert(m_exprs.size() == 1);
	Assert(m_exprs[0]->is_const());

	int addr = m_exprs[0]->value();
	if (addr > 0 && addr < 8)			// rst 0..7 -> 0..0x38
		addr <<= 3;

	switch (addr) {
	case 0x00: case 0x08: case 0x30:
        if (g_args.cpu() == CPU_R2KA || g_args.cpu() == CPU_R3K)
            add_opcode((Z80_CALL << 16) | (addr << 8));
        else
            add_opcode(Z80_RST(addr));
		break;
	case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:
		add_opcode(Z80_RST(addr));
		break;
	default:
		g_errors.error(ErrCode::IntRange, int_to_hex(addr, 2));
	}
}

void Parser::add_opcode(unsigned bytes) {
	g_asm.cur_section()->add_opcode(bytes);
}

void Parser::add_opcode_n(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_n(bytes, m_exprs[0], PatchExpr::Type::UByte);
}

void Parser::add_opcode_s(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_n(bytes, m_exprs[0], PatchExpr::Type::SByte);
}

void Parser::add_opcode_h(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_n(bytes, m_exprs[0], PatchExpr::Type::HighOffset);
}

void Parser::add_opcode_n_0(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_n(bytes, m_exprs[0], PatchExpr::Type::UByte2Word);
}

void Parser::add_opcode_s_0(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_n(bytes, m_exprs[0], PatchExpr::Type::SByte2Word);
}

void Parser::add_opcode_nn(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_nn(bytes, m_exprs[0], PatchExpr::Type::Word);
}

void Parser::add_opcode_nnn(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_nnn(bytes, m_exprs[0], PatchExpr::Type::Ptr24);
}

void Parser::add_opcode_NN(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_nn(bytes, m_exprs[0], PatchExpr::Type::BEWord);
}

void Parser::add_opcode_idx(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	g_asm.cur_section()->add_opcode_idx(bytes, m_exprs[0]);
}

void Parser::add_opcode_idx_n(unsigned bytes) {
	Assert(m_exprs.size() == 2);

	g_asm.cur_section()->add_opcode_idx_n(bytes, m_exprs[0], m_exprs[1]);
}

void Parser::add_opcode_n_n(unsigned bytes) {
	Assert(m_exprs.size() == 2);

	g_asm.cur_section()->add_opcode_n_n(bytes, m_exprs[0], m_exprs[1]);
}
