//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

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
"nop"
	g_obj_module->add_opcode_void(0x00);

"jr" EXPR
	g_obj_module->add_opcode_jr(0x18, $2.expr->clone());

"jr" "nz" "," EXPR
	g_obj_module->add_opcode_jr(0x20, $4.expr->clone());

"jr" "z" "," EXPR
	g_obj_module->add_opcode_jr(0x28, $4.expr->clone());

"jr" "nc" "," EXPR
	g_obj_module->add_opcode_jr(0x30, $4.expr->clone());

"jr" "c" "," EXPR
	g_obj_module->add_opcode_jr(0x38, $4.expr->clone());

"ld" "a" "," EXPR
	g_obj_module->add_opcode_n(0x3E, $4.expr->clone());

"ld" "b" "," EXPR
	g_obj_module->add_opcode_n(0x06, $4.expr->clone());

"ld" "c" "," EXPR
	g_obj_module->add_opcode_n(0x0E, $4.expr->clone());

"ld" "a" "," "(" EXPR ")"
	g_obj_module->add_opcode_nn(0x3A, $4.expr->clone());

"ld" "a" "," "a"
	g_obj_module->add_opcode_void(0x7F);

"ld" "a" "," "b"
	g_obj_module->add_opcode_void(0x78);

"ld" "ix" "," EXPR
	g_obj_module->add_opcode_nn(0xDD21, $4.expr->clone());

"ld" "iy" "," EXPR
	g_obj_module->add_opcode_nn(0xFD21, $4.expr->clone());

"jp" EXPR
	g_obj_module->add_opcode_nn(0xC3, $2.expr->clone());

