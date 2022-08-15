//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <memory>
#include <string>
using namespace std;

class Lexer;
class Object;
class Module;
class Group;
class Section;

class Asm {
public:
	bool assemble(const string& filename);

private:
	enum class State { Main };

	shared_ptr<Lexer>	m_lexer;
	State				m_state{ State::Main };
	shared_ptr<Object>	m_object;
	weak_ptr<Module>	m_cur_module;
	weak_ptr<Group>		m_cur_group;
	weak_ptr<Section>	m_cur_section;

	bool parse();
	bool parse_line();
	bool parse_line_main();
	bool asm_parse_main();
	string check_label();

	void set_cur_module(const string& name);
	void set_cur_section(const string& group_name, const string& section_name);
};
