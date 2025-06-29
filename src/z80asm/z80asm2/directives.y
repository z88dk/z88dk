//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

"align" CONST_EXPR "," CONST_EXPR
    g_obj_module->set_align($2.const_value, $4.const_value);

"align" CONST_EXPR
    g_obj_module->set_align($2.const_value, g_options->filler());

"assert" CONST_EXPR_IF
    g_obj_module->assert_($2.const_value);

"assert" CONST_EXPR_IF "," STR
    g_obj_module->assert_($2.const_value, $4.token.svalue());

"assume" CONST_EXPR
	g_obj_module->set_assume($2.const_value);

"define" CONST_ASSIGN_LIST
    for (auto& nv_pair : $2.ident_value_list) {
        g_obj_module->add_global_def(nv_pair.name, nv_pair.value);
    }

"extern" IDENT_LIST
    for (auto& ident : $2.ident_list) {
        g_obj_module->declare_extern(ident);
    }

"global" IDENT_LIST
    for (auto& ident : $2.ident_list) {
        g_obj_module->declare_global(ident);
    }

"org" CONST_EXPR
    g_obj_module->set_origin($2.const_value);

"public" IDENT_LIST
    for (auto& ident : $2.ident_list) {
        g_obj_module->declare_public(ident);
    }

"section" IDENT
    g_obj_module->set_cur_section($2.token.svalue());

IDENT ":"
	g_obj_module->add_label($1.token.svalue());

IDENT "equ" EXPR
	g_obj_module->add_equ($1.token.svalue(), $3.expr->clone());
