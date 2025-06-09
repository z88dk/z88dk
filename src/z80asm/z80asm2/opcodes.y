"nop"
	g_obj_module->add_opcode_void(0x00);

"jr" EXPR
	g_obj_module->add_opcode_jr(0x18, $4.expr->clone());

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
