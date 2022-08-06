//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm.h"
#include "errors.h"
#include "if.h"
using namespace std;

bool Asm::assemble(const string& filename) {
	if (!m_preproc.open(filename, true)) return false;
	if (!parse()) return false;
	return true;
}

bool Asm::parse() {
	int initial_error_count = g_errors.count();

	string line;
	while (m_preproc.getline(line)) {
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
	case State::Assembly: parse_line_assembly(); break;
	default: Assert(0);
	}
}

void Asm::parse_line_assembly() {
	string label = check_label();
	/*
	if (!label.empty())
		asm_LABEL(label.c_str());
	*/

	while (!m_lexer.at_end()) {
		if (m_lexer.peek().ttype == TType::Backslash)
			m_lexer.next();
		else
			asm_parser_assembly();
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
