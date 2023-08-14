//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scan.h"
#include "preproc.h"
using namespace std;

// parser output

class Asm {
public:
	bool assemble(const string& filename);

private:
	enum class State { Assembly };
	Preproc		m_preproc;
	ScannedLine		m_line;
	State		m_state{ State::Assembly };

	bool parse();
	void parse_line();
	void parse_line_assembly();
	void asm_parser_assembly();
	string check_label();
};
