//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar - CPU opcodes
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

"nop"
	g_obj_module->add_opcode_void(0x00);

"jr" EXPR
	g_obj_module->add_opcode_jr(0x18, $2.expr);

"jr" "nz" "," EXPR
	g_obj_module->add_opcode_jr(0x20, $4.expr);

"jr" "z" "," EXPR
	g_obj_module->add_opcode_jr(0x28, $4.expr);

"jr" "nc" "," EXPR
	g_obj_module->add_opcode_jr(0x30, $4.expr);

"jr" "c" "," EXPR
	g_obj_module->add_opcode_jr(0x38, $4.expr);

"ld" "a" "," EXPR
	g_obj_module->add_opcode_n(0x3E, $4.expr);

"ld" "b" "," EXPR
	g_obj_module->add_opcode_n(0x06, $4.expr);

"ld" "c" "," EXPR
	g_obj_module->add_opcode_n(0x0E, $4.expr);

"ld" "a" "," "(" EXPR ")"
	g_obj_module->add_opcode_nn(0x3A, $4.expr);

"ld" "a" "," "a"
	g_obj_module->add_opcode_void(0x7F);

"ld" "a" "," "b"
	g_obj_module->add_opcode_void(0x78);

"ld" "ix" "," EXPR
	g_obj_module->add_opcode_nn(0xDD21, $4.expr);

"ld" "iy" "," EXPR
	g_obj_module->add_opcode_nn(0xFD21, $4.expr);

"jp" EXPR
	g_obj_module->add_opcode_nn(0xC3, $2.expr);

