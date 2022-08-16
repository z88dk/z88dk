//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm.h"
#include "errors.h"
#include "icode.h"
#include "if.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
using namespace std;

bool Asm::assemble(const string& filename) {
	m_lexer = make_shared<Lexer>();
	m_state = State::Main;

	m_object = make_shared<Object>(filename);
	set_cur_module("");
	set_cur_group("");
	set_cur_section("");

	if (!g_preproc.open(filename, true)) return false;
	if (!parse()) return false;

	m_lexer.reset();
	m_object.reset();
	m_cur_module.reset();
	m_cur_group.reset();
	m_cur_section.reset();

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
	TType t0 = m_lexer->peek(0).ttype;
	Keyword kw1 = m_lexer->peek(1).keyword;

	if (t0 == TType::Label && kw1 != Keyword::EQU) {
		m_lexer->next();
		return m_lexer->peek(-1).svalue;
	}
	else
		return string();
}

void Asm::set_cur_module(const string& name) {
	m_cur_module = m_object->insert_module(name);
}

void Asm::set_cur_group(const string& name) {
	m_cur_group = m_cur_module.lock()->insert_group(name);
}

void Asm::set_cur_section(const string& name) {
	m_cur_section = m_cur_module.lock()->insert_section(name);
}
