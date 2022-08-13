//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm.h"
#include "errors.h"
#include "if.h"
#include "utils.h"
using namespace std;

bool Asm::assemble(const string& filename) {
	if (!g_preproc.open(filename, true)) return false;
	if (!parse()) return false;
	return true;
}

bool Asm::parse() {
	int initial_error_count = g_errors.count();

	string line;
	while (g_preproc.getline(line)) {
		m_lexer.set(line);
		parse_line();
	}

	if (g_errors.count() == initial_error_count)
		return true;
	else
		return false;
}

void Asm::parse_line() {
	switch (m_state) {
	case State::Main: parse_line_main(); break;
	default: Assert(0);
	}
}

void Asm::parse_line_main() {
	while (!m_lexer.at_end()) {
		string label = check_label();
		/*
		if (!label.empty())
			asm_LABEL(label.c_str());
		*/

		if (m_lexer.peek().ttype == TType::Backslash)
			m_lexer.next();
		else
			asm_parse_main();
	}
}

string Asm::check_label() {
	if (m_lexer.peek(0).ttype == TType::Dot &&
		m_lexer.peek(1).ttype == TType::Ident &&
		m_lexer.peek(2).keyword != Keyword::EQU) {
		m_lexer.next(2);
		return m_lexer.peek(-1).svalue;
	}
	else if (m_lexer.peek(0).ttype == TType::Ident &&
		m_lexer.peek(1).ttype == TType::Colon &&
		m_lexer.peek(2).keyword != Keyword::EQU) {
		m_lexer.next(2);
		return m_lexer.peek(-2).svalue;
	}
	else
		return string();
}
