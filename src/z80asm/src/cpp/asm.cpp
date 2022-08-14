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

Asm::Asm() {
	m_lexer = make_shared<Lexer>();
}

bool Asm::assemble(const string& filename) {
	if (!g_preproc.open(filename, true)) return false;
	if (!parse()) return false;
	return true;
}

bool Asm::parse() {
	bool ok = true;

	string line;
	while (g_preproc.getline(line)) {
		m_lexer->set(line);
		if (!parse_line())
			ok = false;
	}

	return ok;
}

bool Asm::parse_line() {
	switch (m_state) {
	case State::Main: return parse_line_main();
	default: Assert(0); return false;
	}
}

bool Asm::parse_line_main() {
	while (!m_lexer->at_end()) {
		string label = check_label();
		/*
		if (!label.empty())
			asm_LABEL(label.c_str());
		*/

		switch (m_lexer->peek().ttype) {
		case TType::End:
			break;
		case TType::Backslash:
		case TType::Newline:
			m_lexer->next();
			break;
		default:
			if (!asm_parse_main())
				return false;
		}
	}
	return true;
}

string Asm::check_label() {
	TType ttype0 = m_lexer->peek(0).ttype;
	Keyword keyword1 = m_lexer->peek(1).keyword;

	if (ttype0 == TType::Label && keyword1 != Keyword::EQU) {
		m_lexer->next();
		return m_lexer->peek(-1).svalue;
	}
	else
		return string();
}
