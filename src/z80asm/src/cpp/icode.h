//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "errors.h"
#include "expr.h"
#include "symtab.h"
#include "utils.h"
#include "xassert.h"
#include "z80asm_defs.h"
#include <cinttypes>
#include <list>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class Object;						// represents object file, including modules
class Module;						// each module has a symbol table, a list of groups and a list of sections
class Section;						// list of instructions in this section
class Instr;						// instructions

//-----------------------------------------------------------------------------

template<class Child>
class child_list {
public:
	auto begin() { return m_list.begin(); }
	auto end() { return m_list.end(); }

	// find by name, return nullptr if not found; sets m_current
	shared_ptr<Child> find(const string& name) {
		auto it = m_map.find(name);
		if (it == m_map.end())
			return nullptr;
		else {
			m_current = it->second;
			return m_current;
		}
	}

	// return existing, or insert new one; sets m_current
	shared_ptr<Child> add(shared_ptr<Child> elem) {
		auto it = m_map.find(elem->name());
		if (it != m_map.end()) {
			m_current = it->second;
		}
		else {
			m_list.push_back(elem);
			m_map[elem->name()] = elem;
			m_current = elem;
		}
		return m_current;
	}

	// returns last child add()ed
	shared_ptr<Child> current() const { xassert(m_current); return m_current; }

private:
	list<shared_ptr<Child>> m_list;
	unordered_map<string, shared_ptr<Child>> m_map;
	shared_ptr<Child> m_current;
};

//-----------------------------------------------------------------------------

class Instr {
public:
	static inline const int UndefinedAsmpc = -1;

	Instr(Section* section);

	const Section* section() { return m_section; }

	int asmpc() const { return m_asmpc; }
	void set_asmpc(int n) { m_asmpc = n; }

	int asmpc_phased() const { return m_asmpc_phased; }
	void set_asmpc_phased(int n) { m_asmpc_phased = n; }

	bool is_phased() const { return m_asmpc_phased != UndefinedAsmpc; }
	int pc() const { return is_phased() ? m_asmpc_phased : m_asmpc; }
	void set_pc(int n) { if (is_phased()) m_asmpc_phased = n; else m_asmpc = n; }

	bool is_relative_jump() const;

	int size() const { return static_cast<int>(m_bytes.size()); }

	vector<uint8_t>& bytes() { return m_bytes; }
	vector<shared_ptr<Patch>>& patches() { return m_patches; }

	const Location& location() const { return m_location; }

	void add_patch(shared_ptr<Patch> patch);
	void add_byte(int n);
	void do_patch(shared_ptr<Patch> patch);

private:
	Section* m_section{ nullptr };
	int		m_asmpc{ UndefinedAsmpc };
	int		m_asmpc_phased{ UndefinedAsmpc };
	vector<uint8_t> m_bytes;
	vector<shared_ptr<Patch>> m_patches;
	Location m_location;
};

//-----------------------------------------------------------------------------

// in sync with objfile.h
#define ORG_NOT_DEFINED     -1
#define ORG_SECTION_SPLIT   -2

class Section {
public:
	Section(const string& name, Module* module);

	const string& name() const { return m_name; }
	const Module* module() { return m_module; }

    shared_ptr<Instr> add_instr();
    shared_ptr<Instr> add_instr(shared_ptr<Instr> instr);

	const list<shared_ptr<Instr>>& instrs() const { return m_instrs; }

	int asmpc() const;
	int asmpc_phased() const;
	bool is_phased() const;
	int pc() const;
    unsigned size() const;
    int origin() const { return m_origin; }
    int align() const { return m_align; }

	shared_ptr<Instr> add_asmpc();
    shared_ptr<Instr> add_label(const string& name);
    shared_ptr<Instr> add_opcode(unsigned bytes);
    shared_ptr<Instr> add_defs(int count, int filler);
    shared_ptr<Instr> add_defs(int count, const string& filler);

	static string autolabel();

	void check_relative_jumps();
	void patch_local_exprs();

private:
	string	m_name;
	Module*	m_module{ nullptr };
	list<shared_ptr<Instr>> m_instrs;
    int m_origin{ ORG_NOT_DEFINED };
    int m_align{ 1 };

	shared_ptr<Instr> add_label_(const string& name);

    void update_asmpc(int start = 0);
};

//-----------------------------------------------------------------------------

class Module {
public:
	Module(const string& name, Object* object);

	const string& name() const { return m_name; }
	const Object* object() { return m_object; }
	Symtab& symtab() { return m_symtab; }

	shared_ptr<Section> find_section(const string& name) { return m_sections.find(name); }
	shared_ptr<Section> add_section(const string& name);
	shared_ptr<Section> cur_section() { return m_sections.current(); }
	child_list<Section>& sections() { return m_sections; }

	void check_relative_jumps();
	void patch_local_exprs();
	void check_undefined_symbols();

private:
	string	m_name;					// module name
	Object* m_object{ nullptr };	// parent
	Symtab	m_symtab;				// module symbols
	child_list<Section> m_sections;	// list of sections
};

//-----------------------------------------------------------------------------

class Object {
public:
	Object(const string& filename);

	const string& filename() const { return m_filename; }
	const string name() const;

	shared_ptr<Module> find_module(const string& name) { return m_modules.find(name); }
	shared_ptr<Module> add_module(const string& name);
	shared_ptr<Module> cur_module() { return m_modules.current(); }
	auto begin() { return m_modules.begin(); }
	auto end() { return m_modules.end(); }

	void check_relative_jumps();
	void patch_local_exprs();
	void check_undefined_symbols();
	void write_obj_file();

private:
	string m_filename;
	child_list<Module> m_modules;
};
