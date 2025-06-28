//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

IDENT ":"
	g_obj_module->add_label($1.token.svalue());

IDENT "equ" EXPR
	g_obj_module->add_equ($1.token.svalue(), $3.expr->clone());

"assume" CONST_EXPR
	g_obj_module->set_assume($2.const_value);

"org" CONST_EXPR
    g_obj_module->set_origin($2.const_value);
