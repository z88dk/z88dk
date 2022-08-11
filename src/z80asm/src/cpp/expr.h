//-----------------------------------------------------------------------------
// z80asm
// expressions
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lex.h"
using namespace std;

class ExprOp {
public:

private:

};

class Expr {
public:
	Expr(Lexer& lexer);

	bool parse();

private:
	Lexer&	m_lexer;
	int		m_value{ 0 };
};
