//-----------------------------------------------------------------------------
// z80asm - data model for intemediate code
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <vector>
#include <string>
#include <map>
#include "source.h"

// represent one symbol
struct Symbol {
	std::string		name;
};

// represent one assembly instruction
struct ICode {
	unsigned	address;		// address after link step
	SourceFile *source_file;	// input location
	unsigned	line_nr;

};

// represent one symbol table
struct SymbolTable {
	std::map<std::string, Symbol> symbols;
};

// represent one section of code
struct Section {
	std::vector<ICode> icode;
};

// represent one object module
struct Module {
	SymbolTable symtab;
	std::vector<Section> sections;
};

// represent one compilation unit
struct CompilationUnit {
	SymbolTable global_symtab;				// refer to symbols in each of the Modules
	std::vector<Module> modules;
	std::vector<SourceFile> source_files;
};
