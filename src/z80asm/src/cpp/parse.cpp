//-----------------------------------------------------------------------------
// z80asm
// parser
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "asm.h"
#include "errors.h"
#include "parse.h"
#include "preproc.h"
using namespace std;

void Parser::clear() {
	m_state = State::Main;
	m_lexer.clear();
	m_exprs.clear();
}

bool Parser::parse() {
	int start_errors = g_errors.count();

	string line;
	while (g_preproc.getline(line)) {
		m_lexer.set(line);
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

	while (!m_lexer.at_end() && start_errors == g_errors.count()) {
		string label = check_label();
		if (!label.empty())
			g_asm.cur_section()->add_label(label);

		switch (m_lexer.peek().ttype) {
		case TType::End:
		case TType::Newline:
			m_lexer.next();
			break;
		default:
			parse_main1();
		}
	}
}

string Parser::check_label() {
	TType t0 = m_lexer.peek(0).ttype;
	Keyword kw1 = m_lexer.peek(1).keyword;

	if (t0 == TType::Label && kw1 != Keyword::EQU) {
		m_lexer.next();
		return m_lexer.peek(-1).svalue;
	}
	else
		return string();
}

void Parser::parse_symbol_declare(Symbol::Scope scope) {
	while (true) {
		// get identifier
		Token& token = m_lexer.peek();
		if (token.ttype != TType::Ident) {
			g_errors.error(ErrCode::IdentExpected);
			return;
		}

		g_symbols.declare(token.svalue, scope);

		// get comma or end
		m_lexer.next();
		token = m_lexer.peek();
		switch (token.ttype) {
		case TType::Comma:
			m_lexer.next();
			continue;
		case TType::End:
		case TType::Newline:
			m_lexer.next();
			return;
		default:
			g_errors.error(ErrCode::EolExpected);
			return;
		}
	}
}

bool Parser::expr_in_parens() {
	Assert(m_exprs.size() >= 1);
	return m_exprs.back()->in_parens();
}

void Parser::add_opcode(unsigned bytes) {
	g_asm.cur_section()->add_opcode(bytes);
}

void Parser::add_opcode_n(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<UBytePatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_s(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<SBytePatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_h(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<HighOffsetPatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_n_0(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<UByte2WordPatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_s_0(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<SByte2WordPatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_nn(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<WordPatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_NN(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<BEWordPatch>(m_exprs[0]);
	instr->add_patch(patch);
}

void Parser::add_opcode_idx(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto patch = make_shared<SBytePatch>(m_exprs[0]);

	if (bytes & 0xFF0000) {			// 3 bytes, insert dis at second byte
		auto instr = g_asm.cur_section()->add_opcode(bytes >> 8);
		instr->add_patch(patch);
		instr->add_byte(bytes & 0xff);
	}
	else {							// 2 bytes
		auto instr = g_asm.cur_section()->add_opcode(bytes);
		instr->add_patch(patch);
	}
}

void Parser::add_opcode_idx_n(unsigned bytes) {
	Assert(m_exprs.size() == 2);

	auto instr = g_asm.cur_section()->add_opcode(bytes);

	auto patch_idx = make_shared<SBytePatch>(m_exprs[0]);
	instr->add_patch(patch_idx);

	auto patch_n = make_shared<UBytePatch>(m_exprs[1]);
	instr->add_patch(patch_n);
}

void Parser::add_opcode_n_n(unsigned bytes) {
	Assert(m_exprs.size() == 2);

	auto instr = g_asm.cur_section()->add_opcode(bytes);

	auto patch_n1 = make_shared<UBytePatch>(m_exprs[0]);
	instr->add_patch(patch_n1);

	auto patch_n2 = make_shared<UBytePatch>(m_exprs[1]);
	instr->add_patch(patch_n2);
}

// emulate "CALL flag, target" on the Rabbit, by:
// jp !flag, temp ; call target ; temp:
void Parser::add_emul_call_flag(unsigned bytes_jump, unsigned bytes_call) {
	Assert(m_exprs.size() == 1);

	// create label and expression
	string temp_label_name = g_asm.cur_section()->autolabel();
	Lexer lexer{ temp_label_name };			// prepare to parse expression with temp label
	auto temp_label_expr = make_shared<Expr>(lexer);
	Assert(temp_label_expr->parse());		// parse temp label

	// jp !flag, temp
	auto instr1 = g_asm.cur_section()->add_opcode(bytes_jump);
	auto patch1 = make_shared<WordPatch>(temp_label_expr);
	instr1->add_patch(patch1);

	// call target
	auto instr2 = g_asm.cur_section()->add_opcode(bytes_call);
	auto patch2 = make_shared<WordPatch>(m_exprs[0]);
	instr2->add_patch(patch2);

	// temp:
	g_asm.cur_section()->add_label(temp_label_name);
}

void Parser::add_call_function(const string& function_name) {
	Assert(m_exprs.size() == 0);

	// declare function as extern
	g_symbols.declare(function_name, Symbol::Scope::Extern);

	// create expression with function name
	Lexer lexer{ function_name };			// prepare to parse expression with function name
	auto function_expr = make_shared<Expr>(lexer);
	Assert(function_expr->parse());			// parse function name

	// add call instruction
	auto instr = g_asm.cur_section()->add_opcode(Z80_CALL);
	auto patch = make_shared<WordPatch>(function_expr);
	instr->add_patch(patch);
}

void Parser::add_jump_relative(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	if (g_args.opt_speed() && bytes != Z80_DJNZ) {	// convert short to long jumps, except DJNZ
		switch (bytes) {
		case Z80_JR:
			bytes = Z80_JP;
			break;
		case Z80_JR_FLAG(FLAG_NZ):
		case Z80_JR_FLAG(FLAG_Z):
		case Z80_JR_FLAG(FLAG_NC):
		case Z80_JR_FLAG(FLAG_C):
			bytes += Z80_JP_FLAG(0) - Z80_JR_FLAG(0);
			break;
		default:
			Assert(0);
		}

		auto instr = g_asm.cur_section()->add_opcode(bytes);
		auto patch = make_shared<WordPatch>(m_exprs[0]);
		instr->add_patch(patch);
	}
	else {
		auto instr = g_asm.cur_section()->add_opcode(bytes);
		auto patch = make_shared<JrOffsetPatch>(m_exprs[0]);
		instr->add_patch(patch);
	}
}

void Parser::add_z80n_mmu_n() {
	Assert(m_exprs.size() == 2);

	ExprResult r = m_exprs[0]->eval_silent();
	Assert(r.is_const());

	int c = r.value();
	if (c < 0 || c > 7)
		g_errors.error(ErrCode::IntRange, int_to_hex(c, 2));
	else {
		auto instr = g_asm.cur_section()->add_opcode(Z80N_MMU_N(c));
		auto patch = make_shared<UBytePatch>(m_exprs[1]);
		instr->add_patch(patch);
	}
}

void Parser::add_z80n_mmu_a() {
	Assert(m_exprs.size() == 1);

	ExprResult r = m_exprs[0]->eval_silent();
	Assert(r.is_const());

	int c = r.value();
	if (c < 0 || c > 7)
		g_errors.error(ErrCode::IntRange, int_to_hex(c, 2));
	else
		auto instr = g_asm.cur_section()->add_opcode(Z80N_MMU_A(c));
}

void Parser::add_restart() {
	Assert(m_exprs.size() == 1);

	ExprResult r = m_exprs[0]->eval_silent();
	Assert(r.is_const());

	int addr = r.value();

	if (addr > 0 && addr < 8)			// rst 0..7 -> 0..0x38
		addr <<= 3;

	switch (addr) {
	case 0x00: case 0x08: case 0x30:
		if (g_args.cpu() & CPU_RABBIT)
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

