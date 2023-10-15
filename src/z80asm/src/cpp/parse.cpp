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
	m_line.clear();
	m_exprs.clear();
    m_const_exprs.clear();
}

void Parser::parse() {
	while (g_preproc.getline(m_line)) {
        if (g_args.debug_verbose())
            cout << g_preproc.location().filename() << ":" << g_preproc.location().line_num()
            << ": " << m_line.text();
		parse_line();
        if (g_args.debug_verbose())
            cout << g_asm << g_symbols;
	}
}

void Parser::error(ErrCode code) {
    error(code, m_line.peek_text());
}

void Parser::error(ErrCode code, const string& arg) {
    g_errors.error(code, arg);
    while (!m_line.at_end())
        m_line.next();
}

void Parser::parse_line() {
	m_exprs.clear();
    m_const_exprs.clear();
	switch (m_state) {
	case State::Main: parse_line_main(); return;
	default: Assert(0); return;
	}
}

void Parser::parse_line_main() {
	int start_errors = g_errors.count();

	while (!m_line.at_end() && start_errors == g_errors.count()) {
		switch (m_line.peek().type()) {
		case TType::End:
            break;
		case TType::Newline:
			m_line.next();
			break;
		default:
            if (parse_label())
                continue;
            m_start_stmt = m_line.pos();
			parse_main();
		}
    }
}

void Parser::check_eol() {
    switch (m_line.peek().type()) {
    case TType::End:
        return;
    case TType::Newline:
        m_line.next();
        return;
    default:
        error(ErrCode::EolExpected);
        return;
    }
}

bool Parser::parse_label() {
    if (m_line.peek(0).type() == TType::Dot &&
        m_line.peek(1).type() == TType::Ident &&
        !m_line.peek(2).is(Keyword::EQU, TType::Eq)) {
        m_line.next(2);
        add_label(m_line.peek(-1).svalue());
        return true;
    }
    else if (m_line.peek(0).type() == TType::Ident &&
        m_line.peek(1).type() == TType::Colon &&
        !m_line.peek(2).is(Keyword::EQU, TType::Eq)) {
        m_line.next(2);
        add_label(m_line.peek(-2).svalue());
        return true;
    }
    else
        return false;
}

void Parser::parse_symbol_declare(Symbol::Scope scope) {
	while (true) {
		// get identifier
		Token& token = m_line.peek();
		if (token.type() != TType::Ident) {
			error(ErrCode::IdentExpected);
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
        default:
            check_eol();
            return;
		}
	}
}

template <typename TPatch>
static void parse_data(ScannedLine& m_line) {
    auto section = g_asm.cur_section();
    auto instr = make_shared<Instr>(section.get());
    section->add_instr(instr);

    while (true) {
        // get expresion or string
        Token& token = m_line.peek();
        if (typeid(TPatch) == typeid(UBytePatch) &&
            token.is(TType::String)) {      // load string
            for (auto& c : token.svalue())
                instr->bytes().push_back(c & 0xff);
            m_line.next();
        }
        else {
            auto expr = make_shared<Expr>();
            if (expr->parse(m_line)) {
                auto patch = make_shared<TPatch>(expr);
                instr->add_patch(patch);
            }
            else {
                g_errors.error(ErrCode::Syntax, m_line.peek_text());
                return;
            }
        }

        // get comma or end of line
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

void Parser::parse_int8_data() {
    parse_data<UBytePatch>(m_line);
}

void Parser::parse_int16_data() {
    parse_data<WordPatch>(m_line);
}

void Parser::parse_int16be_data() {
    parse_data<BEWordPatch>(m_line);
}

void Parser::parse_int24_data() {
    parse_data<Ptr24Patch>(m_line);
}

void Parser::parse_int32_data() {
    parse_data<DWordPatch>(m_line);
}

void Parser::parse_defc() {
    while (true) {
        // collect name
        Token& token = m_line.peek();
        if (!token.is(TType::Ident)) {
            error(ErrCode::IdentExpected);
            break;
        }
        string name = m_line.peek().svalue();
        m_line.next();

        // collect =
        token = m_line.peek();
        if (!token.is(TType::Eq)) {
            error(ErrCode::EqExpected);
            break;
        }
        m_line.next();

        // collect expression
        auto expr = make_shared<Expr>();
        if (!expr->parse(m_line)) {
            break;
        }

        // create symbol
        do_equ(name, expr);

        // check for another
        token = m_line.peek();
        switch (token.type()) {
        case TType::Comma:
            m_line.next();
            continue;
        default:
            check_eol();
            return;
        }
    }
}

void Parser::parse_equ(const string& name) {
    // collect expression
    auto expr = make_shared<Expr>();
    if (expr->parse(m_line)) {

        // create symbol
        do_equ(name, expr);

        check_eol();
    }
}

void Parser::do_defs_n() {
    Assert(m_const_exprs.size() == 1);
    g_asm.cur_section()->add_defs(m_const_exprs.back(), g_args.filler());
}

void Parser::do_defs_n_n() {
    Assert(m_const_exprs.size() == 2);
    g_asm.cur_section()->add_defs(m_const_exprs[0], m_const_exprs[1]);
}

void Parser::do_defs_n_str(const string& filler) {
    Assert(m_const_exprs.size() == 1);
    g_asm.cur_section()->add_defs(m_const_exprs.back(), filler);
}

void Parser::do_equ(const string& name, shared_ptr<Expr> expr) {
    auto symbol = make_shared<Symbol>(Symbol::MakeComputed(), name, expr);
    g_symbols.add(symbol);
}

bool Parser::expr_in_parens() {
	Assert(m_exprs.size() >= 1);
	return m_exprs.back()->in_parens();
}

void Parser::add_label(const string& name) {
    g_asm.cur_section()->add_label(name);
}

void Parser::add_opcode(unsigned bytes) {
	g_asm.cur_section()->add_opcode(bytes);
}

void Parser::add_opcode_n(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<UBytePatch>(m_exprs.back());
	instr->add_patch(patch);
}

void Parser::add_opcode_s(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<SBytePatch>(m_exprs.back());
	instr->add_patch(patch);
}

void Parser::add_opcode_h(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<HighOffsetPatch>(m_exprs.back());
	instr->add_patch(patch);
}

void Parser::add_opcode_n_0(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<UByte2WordPatch>(m_exprs.back());
	instr->add_patch(patch);
}

void Parser::add_opcode_s_0(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<SByte2WordPatch>(m_exprs.back());
	instr->add_patch(patch);
}

void Parser::add_opcode_nn(unsigned bytes, int target_offset) {
	Assert(m_exprs.size() >= 1);

    shared_ptr<Expr> expr = m_exprs.back();

    if (target_offset != 0) {
        // build expr1 = target_offset+(expr)
		string text = std::to_string(target_offset)+"+(" + expr->text() + ")";
		expr = Expr::make_expr(text);
    }

    auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<WordPatch>(expr);
	instr->add_patch(patch);
}

void Parser::add_opcode_nnn(unsigned bytes, int target_offset) {
    Assert(m_exprs.size() >= 1);

    shared_ptr<Expr> expr = m_exprs.back();

    if (target_offset != 0) {
        // build expr1 = target_offset+(expr)
		string text = std::to_string(target_offset)+"+(" + expr->text() + ")";
		expr = Expr::make_expr(text);
    }

    auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<Ptr24Patch>(expr);
	instr->add_patch(patch);
}

void Parser::add_opcode_nnnn(unsigned bytes, int target_offset) {
    Assert(m_exprs.size() == 1);

    shared_ptr<Expr> expr = m_exprs.back();

    if (target_offset != 0) {
        // build expr1 = target_offset+(expr)
		string text = std::to_string(target_offset)+"+(" + expr->text() + ")";
		expr = Expr::make_expr(text);
    }

    auto instr = g_asm.cur_section()->add_opcode(bytes);
    auto patch = make_shared<DWordPatch>(expr);
    instr->add_patch(patch);
}

void Parser::add_opcode_NN(unsigned bytes) {
	Assert(m_exprs.size() == 1);

	auto instr = g_asm.cur_section()->add_opcode(bytes);
	auto patch = make_shared<BEWordPatch>(m_exprs.back());
	instr->add_patch(patch);
}

void Parser::add_opcode_idx(unsigned bytes) {
	Assert(m_exprs.size() >= 1);

	auto patch = make_shared<SBytePatch>(m_exprs.back());

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

void Parser::add_opcode_idx_idx1(unsigned bytes0, unsigned bytes1) {
    Assert(m_exprs.size() == 1);

    shared_ptr<Expr> expr0 = m_exprs.back();

    // build expr1 = 1+(expr)
	string text1 = "1+(" + expr0->text() + ")";
	auto expr1 = Expr::make_expr(text1);

    add_opcode_idx(bytes0);
    m_exprs.push_back(expr1);
    add_opcode_idx(bytes1);
	m_exprs.pop_back();
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

void Parser::add_opcode_defb() {
    Assert(m_exprs.size() == 1);

    auto instr = g_asm.cur_section()->add_instr();
    auto patch = make_shared<UBytePatch>(m_exprs.back());
    instr->add_patch(patch);
}

// emulate "CALL flag, target" on the Rabbit, by:
// jp !flag, temp ; call target ; temp:
void Parser::add_emul_call_flag(unsigned bytes_jump, unsigned bytes_call) {
	Assert(m_exprs.size() == 1);

	// create label and expression
	string temp_label_name = Section::autolabel();
    auto temp_label_expr = Expr::make_expr(temp_label_name);

	// jp !flag, temp
	auto instr1 = g_asm.cur_section()->add_opcode(bytes_jump);
	auto patch1 = make_shared<WordPatch>(temp_label_expr);
	instr1->add_patch(patch1);

	// call target
	auto instr2 = g_asm.cur_section()->add_opcode(bytes_call);
	auto patch2 = make_shared<WordPatch>(m_exprs.back());
	instr2->add_patch(patch2);

	// temp:
	g_asm.cur_section()->add_label(temp_label_name);
}

void Parser::add_call_function(const string& function_name) {
	// declare function as extern
	g_symbols.declare(function_name, Symbol::Scope::Extern);

	// create expression with function name
    auto function_expr = Expr::make_expr(function_name);

	// add call instruction
	auto instr = g_asm.cur_section()->add_opcode(Z80_CALL);
    switch (g_args.cpu()) {
    case CPU_EZ80:
    {
        auto patch = make_shared<Ptr24Patch>(function_expr);
        instr->add_patch(patch);
        break;
    }
    default:
    {
        auto patch = make_shared<WordPatch>(function_expr);
        instr->add_patch(patch);
    }
    }
}

void Parser::add_jump_relative(unsigned bytes) {
	Assert(m_exprs.size() >= 1);

    shared_ptr<Instr> instr;
    auto jroffset_patch = make_shared<JrOffsetPatch>(m_exprs.back());
    auto word_patch = make_shared<WordPatch>(m_exprs.back());

	if (g_args.opt_speed()) {	// convert short to long jumps
		switch (bytes) {
		case Z80_JR:
            instr = g_asm.cur_section()->add_opcode(Z80_JP);
            instr->add_patch(word_patch);
			break;
		case Z80_JR_FLAG(FLAG_NZ):
		case Z80_JR_FLAG(FLAG_Z):
		case Z80_JR_FLAG(FLAG_NC):
		case Z80_JR_FLAG(FLAG_C):
            instr = g_asm.cur_section()->add_opcode(bytes + Z80_JP_FLAG(0) - Z80_JR_FLAG(0));
            instr->add_patch(word_patch);
            break;
        case Z80_DJNZ:		// "dec b; jp nz" is always slower
        case R4K_DWJNZ:		// "dec b; jp nz" is always slower
        case (Z80_DEC(REG_B) << 8) | Z80_JR_FLAG(FLAG_NZ):
        case (RABBIT_ALTD << 8) | Z80_DJNZ:
        case (RABBIT_ALTD << 16) | R4K_DWJNZ:
            instr = g_asm.cur_section()->add_opcode(bytes);
            instr->add_patch(jroffset_patch);
            break;
        case R4K_JR_FLAG(FLAG_R4K_GT):            // jr cx is faster than jp cx
        case R4K_JR_FLAG(FLAG_R4K_GTU):
        case R4K_JR_FLAG(FLAG_R4K_LT):
        case R4K_JR_FLAG(FLAG_R4K_V):
            instr = g_asm.cur_section()->add_opcode(bytes);
            instr->add_patch(jroffset_patch);
            break;
        default:
			Assert(0);
		}
	}
	else {
		instr = g_asm.cur_section()->add_opcode(bytes);
		instr->add_patch(jroffset_patch);
	}
}

void Parser::add_jump_relative16(unsigned bytes) {
    Assert(m_exprs.size() == 1);
    auto instr = g_asm.cur_section()->add_opcode(bytes);
    auto patch = make_shared<JreOffsetPatch>(m_exprs.back());
    instr->add_patch(patch);
}

void Parser::add_z80n_mmu_n() {
	Assert(m_exprs.size() == 2);

	ExprResult r = m_exprs[0]->eval_silent();
	Assert(r.is_const());

	int c = r.value();
	if (c < 0 || c > 7)
		error(ErrCode::IntRange, int_to_hex(c, 2));
	else {
		auto instr = g_asm.cur_section()->add_opcode(Z80N_MMU_N(c));
		auto patch = make_shared<UBytePatch>(m_exprs[1]);
		instr->add_patch(patch);
	}
}

void Parser::add_z80n_mmu_a() {
	Assert(m_exprs.size() == 1);

	ExprResult r = m_exprs.back()->eval_silent();
	Assert(r.is_const());

	int c = r.value();
	if (c < 0 || c > 7)
		error(ErrCode::IntRange, int_to_hex(c, 2));
	else
		auto instr = g_asm.cur_section()->add_opcode(Z80N_MMU_A(c));
}

void Parser::add_restart() {
	Assert(m_exprs.size() == 1);

	ExprResult r = m_exprs.back()->eval_noisy();
    if (!r.is_const()) {
        error(ErrCode::ConstExprExpected);
    }
    else {
        int addr = r.value();

        if (addr > 0 && addr < 8)			// rst 0..7 -> 0..0x38
            addr <<= 3;

        switch (addr) {
        case 0x00: case 0x08: case 0x30:
            if (g_args.cpu() == CPU_R2KA || g_args.cpu() == CPU_R3K ||
                g_args.cpu() == CPU_R4K || g_args.cpu() == CPU_R5K)
                add_opcode((Z80_CALL << 16) | (addr << 8));
            else
                add_opcode(Z80_RST(addr));
            break;
        case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:
            add_opcode(Z80_RST(addr));
            break;
        default:
            error(ErrCode::IntRange, int_to_hex(addr, 2));
        }
    }
}

void Parser::warn_if_expr_in_parens() {
    if (expr_in_parens())
        g_errors.warning(ErrCode::ExprInParens);
}

void Parser::error_expr_not_in_parens() {
    error(ErrCode::ExprNotInParens);
}
