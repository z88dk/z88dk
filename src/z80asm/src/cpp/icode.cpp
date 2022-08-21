//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "icode.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <memory>
using namespace std;

Icode::Icode(Section* parent)
	: m_parent(parent)
	, m_location(g_preproc.location()) {
}

void Icode::set_asmpc(int n) {
	m_asmpc = n;
	if (m_prev_asmpc == UndefinedAsmpc)
		m_prev_asmpc = n;
}

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

Group::Group(const string& name, Module* module)
	: m_name(name), m_module(module) {
	insert_section("");		// create default section with empty name
}

shared_ptr<Section> Group::get_section(const string& name) {
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

Module::Module(const string& name, Object* object)
	: m_name(name), m_object(object) {
	// create default section and group
	insert_section("");
	insert_group("");
}

shared_ptr<Section> Module::get_section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())		// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Section> Module::insert_section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())		// found
		return it->second;
	else {								// not found
		auto group = make_shared<Section>(name, this);
		m_sections.push_back(group);
		m_sections_map[name] = group;
		return group;
	}
}

shared_ptr<Group> Module::get_group(const string& name) {
	auto it = m_groups_map.find(name);
	if (it != m_groups_map.end())			// found
		return it->second;
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
		return group;
	}
}

Object::Object(const string& filename) {
	insert_module("");		// create default module with empty name
	m_filename = fs::path(filename).replace_extension(EXT_O).generic_string();
}

shared_ptr<Module> Object::get_module(const string& name) {
	auto it = m_modules_map.find(name);
	if (it != m_modules_map.end())			// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Module> Object::insert_module(const string& name) {
	auto it = m_modules_map.find(name);
	if (it != m_modules_map.end())			// found
		return it->second;
	else {								// not found
		auto module = make_shared<Module>(name, this);
		m_modules.push_back(module);
		m_modules_map[name] = module;
		return module;
	}
}
