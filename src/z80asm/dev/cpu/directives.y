#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
# Directives parser input
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# labels
#------------------------------------------------------------------------------

IDENT :
	{	string label = m_line.peek(-2).svalue();
		g_asm.cur_section()->add_label(label);
	}

. IDENT
	{	string label = m_line.peek(-1).svalue();
		g_asm.cur_section()->add_label(label);
	}

#------------------------------------------------------------------------------
# EQU
#------------------------------------------------------------------------------

. IDENT [equ|=] EXPR $
	{	string name = m_line.peek(start_stmt_index() + 1).svalue();
		auto symbol = make_shared<Symbol>(Symbol::MakeComputed(), 
										  name, m_exprs.back());
		g_symbols.add(symbol);
	}

IDENT : [equ|=] EXPR $
	{	string name = m_line.peek(start_stmt_index()).svalue();
		auto symbol = make_shared<Symbol>(Symbol::MakeComputed(), 
										  name, m_exprs.back());
		g_symbols.add(symbol);
	}

IDENT [equ|=] EXPR $
	{	string name = m_line.peek(start_stmt_index()).svalue();
		auto symbol = make_shared<Symbol>(Symbol::MakeComputed(), 
										  name, m_exprs.back());
		g_symbols.add(symbol);
	}

#------------------------------------------------------------------------------
# symbol declaration
#------------------------------------------------------------------------------

global
	parse_symbol_declare(Symbol::Scope::Global);

[extern|xref|lib]
	parse_symbol_declare(Symbol::Scope::Extern);

[public|xdef|xlib]
	parse_symbol_declare(Symbol::Scope::Public);

#------------------------------------------------------------------------------
# data definitions
#------------------------------------------------------------------------------

[defs|ds] CONST_EXPR $
	do_defs_n();

[defs|ds] CONST_EXPR , CONST_EXPR $
	do_defs_n_n();

[defs|ds] CONST_EXPR , STR $
	do_defs_n_str(m_line.peek(-2).svalue());

[byte|defb|defm|db|dm]
	parse_int8_data();

[word|defw|dw]
	parse_int16_data();

[ptr|defp|dp]
	parse_int24_data();

[dword|defq|dq]
	parse_int32_data();

[wordbe|defdb|ddb]
	parse_int16be_data();
	
#------------------------------------------------------------------------------
# others
#------------------------------------------------------------------------------

org CONST_EXPR $
	/*set_origin(expr);*/
	while (!m_line.at_end()) m_line.next();

section
	while (!m_line.at_end()) m_line.next();

