//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assm.h"
#include "errors.h"
#include "icode.h"
#include "if.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <set>
using namespace std;

bool Assm::assemble(const string& filename) {
	m_state = State::Main;

	// create object and default module, section and group
	m_object = make_shared<Object>(filename);
	set_cur_module("");
	set_cur_group("");
	set_cur_section("");

	m_start_errors = g_errors.count();

	bool ret = assemble1(filename);

	m_object.reset();
	m_cur_module.reset();
	m_cur_group.reset();
	m_cur_section.reset();
	m_start_errors = 0;

	return ret;
}

bool Assm::assemble1(const string& filename) {
	if (!g_preproc.open(filename, true)) return false;
	if (!parse()) return false;
	return true;
}

void Assm::set_cur_module(const string& name) {
	m_cur_module = m_object->insert_module(name);
}

void Assm::set_cur_group(const string& name) {
	m_cur_group = m_cur_module.lock()->insert_group(name);
}

void Assm::set_cur_section(const string& name) {
	m_cur_section = m_cur_module.lock()->insert_section(name);
}

bool Assm::parse() {
	bool ok = true;

	string line;
	while (g_preproc.getline(line)) {
		m_lexer.set(line);
		if (!parse_line())
			ok = false;
	}

	return ok;
}

bool Assm::parse_line() {
	m_exprs.clear();
	switch (m_state) {
	case State::Main: return parse_line_main();
	default: Assert(0); return false;
	}
}

bool Assm::parse_line_main() {
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
			if (!asm_parse_main())
				return false;
		}
	}
	return true;
}

bool Assm::parse_symbol_declare(Symbol::Scope scope) {
	while (true) {
		// get identifier
		Token& token = m_lexer.peek();
		if (token.ttype != TType::Ident) {
			g_errors.error(ErrCode::Syntax);
			return false;
		}
		if (!symbol_declare(token.svalue, scope))
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
			g_errors.error(ErrCode::Syntax);
			return false;
		}
	}
}


string Assm::check_label() {
	TType t0 = m_lexer.peek(0).ttype;
	Keyword kw1 = m_lexer.peek(1).keyword;

	if (t0 == TType::Label && kw1 != Keyword::EQU) {
		m_lexer.next();
		return m_lexer.peek(-1).svalue;
	}
	else
		return string();
}

bool Assm::got_errors() {
	return m_start_errors != g_errors.count();
}

vector<shared_ptr<Symbol>> Assm::symbols_find_in_modules(const string& name) {
	set<shared_ptr<Symbol>> symbols;

	for (auto& module : m_object->modules()) {
		auto symbol = module->symtab().find(name);
		if (symbol)
			symbols.insert(symbol);
	}

	vector<shared_ptr<Symbol>> ret;
	std::copy(symbols.begin(), symbols.end(), ret.begin());
	return ret;
}

bool Assm::symbol_declare(const string& name, Symbol::Scope scope) {
	auto symbol = g_symbols.find(name);
	if (!symbol) {			// not found, create a new one
		symbol = make_shared<Symbol>(name);
		symbol->set_scope(scope);
		g_symbols.insert(symbol);
	}
	else {					// found, check if same scope
		if (symbol->scope() != scope) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);	// error at this location
			g_errors.push_location(symbol->location());
			g_errors.error(ErrCode::SymbolRedeclaration, name);	// error at other symbol location
			g_errors.pop_location();
			return false;
		}
	}
	return true;
}
