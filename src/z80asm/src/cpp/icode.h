//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "z80asm_cpu.h"
#include "errors.h"
#include "expr.h"
#include "symtab.h"
#include "errors.h"
#include <cinttypes>
#include <list>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class Expr;
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
		None, Label, Opcode, JumpRelative,
	};

	Icode(Section* parent, Type type);

	const Section* parent() { return m_parent; }
	Type type() const { return m_type; }

	int asmpc() const { return m_asmpc; }
	void set_asmpc(int n);

	int asmpc_phased() const { return m_asmpc_phased; }
	void set_asmpc_phased(int n) { m_asmpc_phased = n; }

	shared_ptr<Symbol> label() { return m_label; }
	void set_label(shared_ptr<Symbol> l) { m_label = l; }

	int size() const { return static_cast<int>(m_bytes.size()); }

	vector<uint8_t>& bytes() { return m_bytes; }
	vector<shared_ptr<PatchExpr>> patches() { return m_patches; }

	const Location& location() const { return m_location; }

private:
	Section* m_parent{ nullptr };
	Type	m_type{ Type::None };
	int		m_asmpc{ UndefinedAsmpc };
	int		m_asmpc_phased{ UndefinedAsmpc };
	shared_ptr<Symbol> m_label;
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

	void add_label(const string& name);
	void add_opcode(unsigned bytes);
	void add_opcode_n(unsigned bytes, shared_ptr<Expr> n, PatchExpr::Type type);
	void add_opcode_nn(unsigned bytes, shared_ptr<Expr> nn, PatchExpr::Type type);
	void add_opcode_nnn(unsigned bytes, shared_ptr<Expr> nnn, PatchExpr::Type type);
	void add_opcode_idx(unsigned bytes, shared_ptr<Expr> dis);
	void add_opcode_idx_n(unsigned bytes, shared_ptr<Expr> dis, shared_ptr<Expr> n);
	void add_opcode_n_n(unsigned bytes, shared_ptr<Expr> n1, shared_ptr<Expr> n2);
	void add_jump_relative(unsigned bytes, shared_ptr<Expr> nn);

	string autolabel();

private:
	string	m_name;
	Module*	m_module{ nullptr };
	list<shared_ptr<Icode>> m_icode;

	void add_label_(const string& name);
	void add_jump_relative_(unsigned bytes, shared_ptr<Expr> nn);
	void add_opcode_idx_(unsigned bytes);
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
