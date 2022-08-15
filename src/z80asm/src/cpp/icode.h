//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cinttypes>
#include <list>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class PatchExpr;
class Symtab;
class Object;						// represents object file
class Module;						// that contains modules, each wit its symbol table
class Group;						// that include groups of sections
class Section;						// that include sections
class Icode;						// that include code

class Icode {
public:
	enum class Type {
		Label,
	};

	Icode(Section* parent);
	static shared_ptr<Icode> make_label(const string& name);

	const Section* parent() { return m_parent; }

	size_t asmpc() const { return m_asmpc; }
	void set_asmpc(size_t n);
	bool asmpc_changed() const { return m_asmpc != m_prev_asmpc; }

	size_t size() const { return m_size; }

	const vector<uint8_t>& bytes() const { return m_bytes; }
	const vector<shared_ptr<PatchExpr>> patches() const { return m_patches; }

	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }

private:
	static inline const size_t UndefinedAsmpc = static_cast<size_t>(-1);

	Section* m_parent{ nullptr };
	size_t	m_asmpc{ UndefinedAsmpc };
	size_t	m_prev_asmpc{ UndefinedAsmpc };
	size_t	m_size{ 0 };
	vector<uint8_t> m_bytes;
	vector<shared_ptr<PatchExpr>> m_patches;
	string	m_filename;
	int		m_line_num{ 0 };
};

class Section {
public:
	Section(const string& name, Group* parent);

	void push_back(shared_ptr<Icode> node);

	const Group* parent() { return m_parent; }
	const list<shared_ptr<Icode>>& nodes() const { return m_nodes; }

	size_t asmpc() const;

private:
	string	m_name;
	Group*	m_parent{ nullptr };
	list<shared_ptr<Icode>> m_nodes;
};

class Group {
public:
	Group(const string& name, Module* parent);

	shared_ptr<Section> get_child(const string& name);
	shared_ptr<Section> insert(const string& name);	// appends or returns existing

	const Module* parent() { return m_parent; }
	const list<shared_ptr<Section>>& nodes() const { return m_nodes; }

private:
	string	m_name;
	Module* m_parent{ nullptr };
	list<shared_ptr<Section>> m_nodes;
	unordered_map<string, shared_ptr<Section>> m_node_map;
};

class Module {
public:
	Module(const string& name, Object* parent);

	shared_ptr<Group> get_child(const string& name);
	shared_ptr<Group> insert(const string& name);	// appends or returns existing

	const Object* parent() { return m_parent; }
	const list<shared_ptr<Group>>& nodes() const { return m_nodes; }
	shared_ptr<Symtab> symtab() { return m_symtab; }

private:
	string	m_name;
	Object* m_parent{ nullptr };
	list<shared_ptr<Group>> m_nodes;
	unordered_map<string, shared_ptr<Group>> m_node_map;
	shared_ptr<Symtab>	m_symtab;			// module symbols
};

class Object {
public:
	Object(const string& filename);

	shared_ptr<Module> get_child(const string& name);
	shared_ptr<Module> insert(const string& name);	// appends or returns existing

	const string& filename() const { return m_filename; }
	const list<shared_ptr<Module>> nodes() const { return m_nodes; }

private:
	string m_filename;
	list<shared_ptr<Module>> m_nodes;
	unordered_map<string, shared_ptr<Module>> m_node_map;
};
