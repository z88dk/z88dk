#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
# Directives parser input
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# EQU / DEFC
#------------------------------------------------------------------------------

. IDENT [equ|=] EXPR $
	string name = m_line.peek(start_stmt_index() + 1).svalue();
	do_equ(name, m_exprs.back());

IDENT : [equ|=] EXPR $
	string name = m_line.peek(start_stmt_index() + 0).svalue();
	do_equ(name, m_exprs.back());

[START_STATE_EQU] IDENT [equ|=] EXPR [$|,]
	string name = m_line.peek(start_stmt_index() + 0).svalue();
	do_equ(name, m_exprs.back());
	
	// repeat if comma
	if (m_line.peek(-1).is(TType::Comma)) {
		m_start_stmt = m_line.pos();
		parse_main(START_STATE_EQU);
	}

[defc|dc] [START_STATE_DEFC] IDENT = EXPR [$|,]
	string name = m_line.peek(start_stmt_index() + 1).svalue();
	do_equ(name, m_exprs.back());
	
	// repeat if comma
	if (m_line.peek(-1).is(TType::Comma)) {
		m_start_stmt = m_line.pos() - 1;
		parse_main(START_STATE_DEFC);
	}

#------------------------------------------------------------------------------
# symbol declaration
#------------------------------------------------------------------------------

global [START_STATE_GLOBAL] IDENT [$|,]
	string name = m_line.peek(start_stmt_index() + 1).svalue();
	g_symbols.declare_global(name);

	// repeat if comma
	if (m_line.peek(-1).is(TType::Comma)) {
		m_start_stmt = m_line.pos() - 1;
		parse_main(START_STATE_GLOBAL);
	}

[extern|xref|lib] [START_STATE_EXTERN] IDENT [$|,]
	string name = m_line.peek(start_stmt_index() + 1).svalue();
	g_symbols.declare_extern(name);

	// repeat if comma
	if (m_line.peek(-1).is(TType::Comma)) {
		m_start_stmt = m_line.pos() - 1;
		parse_main(START_STATE_EXTERN);
	}

[public|xdef|xlib] [START_STATE_PUBLIC] IDENT [$|,]
	string name = m_line.peek(start_stmt_index() + 1).svalue();
	g_symbols.declare_public(name);

	// repeat if comma
	if (m_line.peek(-1).is(TType::Comma)) {
		m_start_stmt = m_line.pos() - 1;
		parse_main(START_STATE_PUBLIC);
	}

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
