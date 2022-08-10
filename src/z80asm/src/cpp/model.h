//-----------------------------------------------------------------------------
// z80asm
// data model
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "symtab.h"
#include <string>
#include <list>
using namespace std;

class Object;						// represents object file
class Module;						// that contains modules, each wit its symbol table
class Group;						// that include groups of sections
class Section;						// that include sections
class Code;							// that include code

class Section {
public:
	Section(Group* parent, const string& name = "") { (void)parent; (void)name; }

private:
	Group*		m_parent{ nullptr };// parent group
	string		m_name;				// name of SECTION directive, empty at start
	list<Code*> m_code;				// list of instructions
};

class Group {
public:
	Group(Module* parent, const string& name = "") { (void)parent; (void)name; }

private:
	Module*		m_parent{ nullptr };// parent module
	string		m_name;				// name of GROUP directive, empty at start
	list<Section*> m_sections;		// list of sections
	Group*		m_cur_section{ nullptr };	// point at last refered section
};

class Module {
public:
	Module(Object* parent, const string& name = "") { (void)parent; (void)name; }

private:
	Object*		m_parent{ nullptr };// parent object
	string		m_name;				// name of MODULE directive, empty if none
	Symtab		m_symtab;			// symbols defined in this module
	list<Group*> m_groups;			// list of groups of sections
	Group*		m_cur_group{ nullptr };		// point at last refered group
};

class Object {
public:
	Object(const string& name) { (void)name; }

private:
	string		m_name;				// basename of file name
	Symtab		m_symtab;			// public and external declarations
	list<Module*> m_modules;		// modules
	Module*		m_cur_module{ nullptr };	// point at last refered module
};

