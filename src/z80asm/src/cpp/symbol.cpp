//-----------------------------------------------------------------------------
// z80asm
// user symbol
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc.h"
#include "symbol.h"
using namespace std;

Symbol::Symbol(const string& name)
	: m_name(name)
	, m_filename(g_preproc.filename())
	, m_line_num(g_preproc.line_num()) {
}

Symbol::Symbol(const string& name, int value)
	: m_name(name)
	, m_value(value)
	, m_type(Type::Constant)
	, m_is_computed(true)
	, m_is_defined(true)
	, m_filename(g_preproc.filename())
	, m_line_num(g_preproc.line_num()) {
}
