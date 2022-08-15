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
	, m_filename(g_preproc.filename())
	, m_line_num(g_preproc.line_num()) {
}

void Icode::set_asmpc(size_t n) {
	m_asmpc = n;
	if (m_prev_asmpc == UndefinedAsmpc)
		m_prev_asmpc = n;
}

Section::Section(const string& name, Group* parent)
	: m_name(name), m_parent(parent) {
}

void Section::push_back(shared_ptr<Icode> node) {
	node->set_asmpc(asmpc());
	m_nodes.push_back(node);
}

size_t Section::asmpc() const {
	if (m_nodes.empty())
		return 0;
	else
		return m_nodes.back()->asmpc() + m_nodes.back()->size();
}

Group::Group(const string& name, Module* parent)
	: m_name(name), m_parent(parent) {
	insert("");		// create default section with empty name
}

shared_ptr<Section> Group::get_child(const string& name) {
	auto it = m_node_map.find(name);
	if (it != m_node_map.end())			// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Section> Group::insert(const string& name) {
	auto it = m_node_map.find(name);
	if (it != m_node_map.end())			// found
		return it->second;	
	else {								// not found
		auto section = make_shared<Section>(name, this);
		m_nodes.push_back(section);
		m_node_map[name] = section;
		return section;
	}
}

Module::Module(const string& name, Object* parent)
	: m_name(name), m_parent(parent) {
	insert("");		// create default group with empty name
	m_symtab = make_shared<Symtab>(global_symbols());
}

shared_ptr<Group> Module::get_child(const string& name) {
	auto it = m_node_map.find(name);
	if (it != m_node_map.end())			// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Group> Module::insert(const string& name) {
	auto it = m_node_map.find(name);
	if (it != m_node_map.end())			// found
		return it->second;
	else {								// not found
		auto group = make_shared<Group>(name, this);
		m_nodes.push_back(group);
		m_node_map[name] = group;
		return group;
	}
}

Object::Object(const string& filename) {
	insert("");		// create default module with empty name
	m_filename = fs::path(filename).replace_extension(EXT_O).generic_string();
}

shared_ptr<Module> Object::get_child(const string& name) {
	auto it = m_node_map.find(name);
	if (it != m_node_map.end())			// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Module> Object::insert(const string& name) {
	auto it = m_node_map.find(name);
	if (it != m_node_map.end())			// found
		return it->second;
	else {								// not found
		auto module = make_shared<Module>(name, this);
		m_nodes.push_back(module);
		m_node_map[name] = module;
		return module;
	}
}
