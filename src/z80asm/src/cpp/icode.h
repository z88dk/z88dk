//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "symtab.h"
#include <cinttypes>
#include <list>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class PatchExpr;
class Symtab;
class Object;						// represents object file, including modules
class Module;						// each module has a symbol table, a list of groups and a list of sections
class Section;						// list of icode instructions in this section
class Icode;						// icode instructions

class Icode {
public:
	static inline const int UndefinedAsmpc = -1;

	enum class Type {
		Label,
	};

	Icode(Section* parent);
	static shared_ptr<Icode> make_label(const string& name);

	const Section* parent() { return m_parent; }

	int asmpc() const { return m_asmpc; }
	void set_asmpc(int n);
	int asmpc_phased() const { return m_asmpc_phased; }
	void set_asmpc_phased(int n) { m_asmpc_phased = n; }
	bool asmpc_changed() const { return m_asmpc != m_prev_asmpc; }

	int size() const { return m_size; }

	const vector<uint8_t>& bytes() const { return m_bytes; }
	const vector<shared_ptr<PatchExpr>> patches() const { return m_patches; }

	const Location& location() const { return m_location; }

private:
	Section* m_parent{ nullptr };
	int		m_asmpc{ UndefinedAsmpc };
	int		m_asmpc_phased{ UndefinedAsmpc };
	int		m_prev_asmpc{ UndefinedAsmpc };
	int		m_size{ 0 };
	vector<uint8_t> m_bytes;
	vector<shared_ptr<PatchExpr>> m_patches;
	Location m_location;
};

class Section {
public:
	Section(const string& name, Module* module);

	void push_back(shared_ptr<Icode> node);

	const Module* module() { return m_module; }
	const list<shared_ptr<Icode>>& icode() const { return m_icode; }

	int asmpc() const;
	int asmpc_phased() const;

private:
	string	m_name;
	Module*	m_module{ nullptr };
	list<shared_ptr<Icode>> m_icode;
};

class Group {
public:
	Group(const string& name, Module* module);

	shared_ptr<Section> section(const string& name);	// nullptr if not found
	shared_ptr<Section> insert_section(const string& name);	// appends or returns existing

	const Module* module() { return m_module; }
	const list<shared_ptr<Section>>& sections() const { return m_sections; }

private:
	string	m_name;
	Module* m_module{ nullptr };
	list<shared_ptr<Section>> m_sections;
	unordered_map<string, shared_ptr<Section>> m_sections_map;
};

class Module {
public:
	Module(const string& name, Object* object);

	const string& name() const { return m_name; }

	shared_ptr<Section> section(const string& name);	// nullptr if not found
	shared_ptr<Section> insert_section(const string& name);	// appends or returns existing
	shared_ptr<Section> cur_section() { return m_cur_section; }

	shared_ptr<Group> group(const string& name);	// nullptr if not found
	shared_ptr<Group> insert_group(const string& name);	// appends or returns existing
	shared_ptr<Group> cur_group() { return m_cur_group; }

	const Object* object() { return m_object; }
	const list<shared_ptr<Section>>& sections() const { return m_sections; }
	const list<shared_ptr<Group>>& groups() const { return m_groups; }
	Symtab& symtab() { return m_symtab; }

private:
	string	m_name;
	Object* m_object{ nullptr };
	Symtab	m_symtab;			// module symbols

	list<shared_ptr<Section>> m_sections;
	unordered_map<string, shared_ptr<Section>> m_sections_map;
	shared_ptr<Section> m_cur_section;

	list<shared_ptr<Group>> m_groups;
	unordered_map<string, shared_ptr<Group>> m_groups_map;
	shared_ptr<Group> m_cur_group;
};

class Object {
public:
	Object(const string& filename);

	shared_ptr<Module> module(const string& name);	// nullptr if not found
	shared_ptr<Module> insert_module(const string& name);	// appends or returns existing
	shared_ptr<Module> cur_module() { return m_cur_module; }

	const string& filename() const { return m_filename; }
	const list<shared_ptr<Module>> modules() const { return m_modules; }

private:
	string m_filename;
	list<shared_ptr<Module>> m_modules;
	unordered_map<string, shared_ptr<Module>> m_modules_map;
	shared_ptr<Module> m_cur_module;
};
