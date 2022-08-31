//-----------------------------------------------------------------------------
// z80asm
// data model
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lex.h"
#include "expr.h"
#include "utils.h"
#include <list>
#include <unordered_map>
#include <memory>
#include <string>
using namespace std;

class Prog;
class Object;
class Module;
class Section;
class Instr;
class Patch;
class Expr;
class ExprNode;
class Symtab;
class Symbol;
class MemMap;
class MemArea;

class Prog {
public:
	Prog(const string& name);

	const string& name() const { return m_name; }
	shared_ptr<MemMap> memmap() const { return m_memmap; }
	shared_ptr<Symtab> defines() const { return m_defines; }
	shared_ptr<Symtab> globals() const { return m_globals; }
	child_list<Prog, Object> objects() { return m_objects; }

private:
	string	m_name;
	shared_ptr<MemMap>	m_memmap;
	shared_ptr<Symtab>	m_defines;
	shared_ptr<Symtab>	m_globals;
	child_list<Prog, Object> m_objects;
};

class Object {
public:
	Object(shared_ptr<Prog> prog, const string& name);

private:
	string	m_name;
	weak_ptr<Prog>	m_prog;
	list<shared_ptr<Module>> m_modules;
	unordered_map<string, shared_ptr<Module>> m_module_map;
};

class Module {
public:
	Module(shared_ptr<Object> object, const string& name);

private:
	string m_name;
	weak_ptr<Object>	m_object;
	shared_ptr<Symtab>	m_locals;
	list<shared_ptr<Section>> m_sections;
	unordered_map<string, shared_ptr<Section>> m_section_map;
};
