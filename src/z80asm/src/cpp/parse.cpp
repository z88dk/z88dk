//-----------------------------------------------------------------------------
// z80asm
// parser
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "parse.h"
#include "preproc.h"
using namespace std;

void Parser::clear() {
	m_state = State::Main;
	m_lexer.clear();
	m_exprs.clear();
}

bool Parser::parse() {
	bool ok = true;

	string line;
	while (g_preproc.getline(line)) {
		m_lexer.set(line);
		if (!parse_line())
			ok = false;
	}

	return ok;
}

bool Parser::parse_line() {
	m_exprs.clear();
	switch (m_state) {
	case State::Main: return parse_line_main();
	default: Assert(0); return false;
	}
}

bool Parser::parse_line_main() {
	while (!m_lexer.at_end()) {
		string label = check_label();
		/*
		if (!label.empty())
			asm_LABEL(label.c_str());
		*/

		switch (m_lexer.peek().ttype) {
		case TType::End:
		case TType::Newline:
			m_lexer.next();
			break;
		default:
			if (!parse_main1())
				return false;
		}
	}
	return true;
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

bool Parser::parse_symbol_declare(Symbol::Scope scope) {
	while (true) {
		// get identifier
		Token& token = m_lexer.peek();
		if (token.ttype != TType::Ident) {
			g_errors.error(ErrCode::IdentExpected);
			return false;
		}
		if (!g_symbols.declare(token.svalue, scope))
			return false;

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
			return true;
		default:
			g_errors.error(ErrCode::EolExpected);
			return false;
		}
	}
}

