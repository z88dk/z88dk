#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
# Directives parser input
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

org EXPR $
	while (!m_lexer.at_end()) m_lexer.next();

LABEL equ EXPR $
	while (!m_lexer.at_end()) m_lexer.next();

section
	while (!m_lexer.at_end()) m_lexer.next();

#------------------------------------------------------------------------------
# symbol declaration
#------------------------------------------------------------------------------

global
	parse_symbol_declare(Symbol::Scope::Global);

extern
	parse_symbol_declare(Symbol::Scope::Extern);

xref
	parse_symbol_declare(Symbol::Scope::Extern);

lib
	parse_symbol_declare(Symbol::Scope::Extern);

public
	parse_symbol_declare(Symbol::Scope::Public);

xdef
	parse_symbol_declare(Symbol::Scope::Public);

xlib
	parse_symbol_declare(Symbol::Scope::Public);
