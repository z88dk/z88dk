//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "icode.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <iostream>
#include <memory>
#include <sstream>
#include <cctype>
using namespace std;

// Encoding for C_LINEand ASM_LINE
static string url_encode(const string& text) {
	ostringstream ss;
	for (auto c : text) {
		if (isalnum(c))
			ss << c;
		else
			ss << '_' << setfill('0') << setw(2) << hex << static_cast<unsigned int>(c) << dec;
	}
	return ss.str();
}

//-----------------------------------------------------------------------------

Icode::Icode(Section* parent, Type type)
	: m_parent(parent), m_type(type)
	, m_location(g_preproc.location()) {
	m_asmpc = parent->asmpc();
	m_asmpc_phased = parent->asmpc_phased();
}

void Icode::set_asmpc(int n) {
	m_asmpc = n;
}

//-----------------------------------------------------------------------------

Section::Section(const string& name, Module* module)
	: m_name(name), m_module(module) {
}

void Section::push_back(shared_ptr<Icode> node) {
	node->set_asmpc(asmpc());
	m_icode.push_back(node);
}

int Section::asmpc() const {
	if (m_icode.empty())
		return 0;
	else
		return m_icode.back()->asmpc() + m_icode.back()->size();
}

int Section::asmpc_phased() const {
	if (m_icode.empty())
		return Icode::UndefinedAsmpc;
	else if (m_icode.back()->asmpc_phased() == Icode::UndefinedAsmpc)
		return Icode::UndefinedAsmpc;
	else
		return m_icode.back()->asmpc_phased() + m_icode.back()->size();
}

void Section::add_label(const string& name) {
	add_label_(name);

	// add debug label
	if (g_args.debug() && g_preproc.is_c_source()) {
		ostringstream ss;
		ss << "__ASM_LINE_" << g_preproc.location().line_num
			<< "_" << url_encode(g_preproc.location().filename);
		string debug_name = ss.str();
		if (!g_symbols.find_local(debug_name))
			add_label_(debug_name);
	}
}

void Section::add_opcode(unsigned bytes) {
	auto instr = make_shared<Icode>(this, Icode::Type::Opcode);

	bool found = false;
	if (found || (bytes & 0xff000000) != 0) {
		instr->bytes().push_back((bytes >> 24) & 0xff);
		found = true;
	}
	if (found || (bytes & 0xff0000) != 0) {
		instr->bytes().push_back((bytes >> 16) & 0xff);
		found = true;
	}
	if (found || (bytes & 0xff00) != 0) {
		instr->bytes().push_back((bytes >> 8) & 0xff);
		found = true;
	}
	instr->bytes().push_back(bytes & 0xff);

	m_icode.push_back(instr);
}

string Section::autolabel() {
	static int n;
	ostringstream ss;
	ss << "__autolabel_" << setfill('0') << setw(4) << ++n;
	return ss.str();
}

void Section::add_label_(const string& name) {
	auto instr = make_shared<Icode>(this, Icode::Type::Label);

	shared_ptr<Symbol> label;
	if (asmpc_phased() != Icode::UndefinedAsmpc)
		label = g_symbols.add(name, asmpc_phased(), Symbol::Type::Constant);
	else
		label = g_symbols.add(name, asmpc(), Symbol::Type::Address);

	if (label) {		// no error
		label->set_touched();
		instr->set_label(label);
		m_icode.push_back(instr);
	}
}

//-----------------------------------------------------------------------------

Group::Group(const string& name, Module* module)
	: m_name(name), m_module(module) {
	insert_section("");		// create default section with empty name
}

shared_ptr<Section> Group::section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())			// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Section> Group::insert_section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())			// found
		return it->second;	
	else {								// not found
		auto section = make_shared<Section>(name, m_module);
		m_sections.push_back(section);
		m_sections_map[name] = section;
		return section;
	}
}

//-----------------------------------------------------------------------------

Module::Module(const string& name, Object* object)
	: m_name(name), m_object(object) {
	// create default section and group
	insert_section("");
	insert_group("");
}

shared_ptr<Section> Module::section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end()) {	// found
		shared_ptr<Section> section = it->second;
		m_cur_section = section;
		return section;
	}
	else
		return nullptr;
}

shared_ptr<Section> Module::insert_section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())		// found
		return it->second;
	else {								// not found
		auto section = make_shared<Section>(name, this);
		m_sections.push_back(section);
		m_sections_map[name] = section;
		m_cur_section = section;
		return section;
	}
}

shared_ptr<Group> Module::group(const string& name) {
	auto it = m_groups_map.find(name);
	if (it != m_groups_map.end()) {			// found
		shared_ptr<Group> group = it->second;
		m_cur_group = group;
		return group;
	}
	else
		return nullptr;
}

shared_ptr<Group> Module::insert_group(const string& name) {
	auto it = m_groups_map.find(name);
	if (it != m_groups_map.end())			// found
		return it->second;
	else {								// not found
		auto group = make_shared<Group>(name, this);
		m_groups.push_back(group);
		m_groups_map[name] = group;
		m_cur_group = group;
		return group;
	}
}

//-----------------------------------------------------------------------------

Object::Object(const string& filename) {
	insert_module("");		// create default module with empty name
	m_filename = fs::path(filename).replace_extension(EXT_O).generic_string();
}

shared_ptr<Module> Object::module(const string& name) {
	auto it = m_modules_map.find(name);
	if (it != m_modules_map.end()) {		// found
		shared_ptr<Module> module = it->second;
		m_cur_module = module;
		return module;
	}
	else
		return nullptr;
}

shared_ptr<Module> Object::insert_module(const string& name) {
	auto it = m_modules_map.find(name);
	if (it != m_modules_map.end())		// found
		return it->second;
	else {								// not found
		auto module = make_shared<Module>(name, this);
		m_modules.push_back(module);
		m_modules_map[name] = module;
		m_cur_module = module;
		return module;
	}
}
