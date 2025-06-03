// Parser

IDENT ":"
	g_obj_module.add_label($1.token.get_svalue());

IDENT "equ" EXPR
	g_obj_module.add_constant($1.token.get_svalue(), $3.expr);

"assume" CONST_EXPR
	g_obj_module.set_assume($2.expr_value);

"nop"
	g_obj_module.add_opcode_void(0x00);

"jr" EXPR
	g_obj_module.add_opcode_jr(0x18, $4.expr);

"jr" "nz" "," EXPR
	g_obj_module.add_opcode_jr(0x20, $4.expr);

"jr" "z" "," EXPR
	g_obj_module.add_opcode_jr(0x28, $4.expr);

"jr" "nc" "," EXPR
	g_obj_module.add_opcode_jr(0x30, $4.expr);

"jr" "c" "," EXPR
	g_obj_module.add_opcode_jr(0x38, $4.expr);

"ld" "a" "," EXPR
	g_obj_module.add_opcode_n(0x3E, $4.expr);

"ld" "a" "," "(" EXPR ")"
	g_obj_module.add_opcode_nn(0x3A, $4.expr);

"ld" "a" "," "a"
	g_obj_module.add_opcode_void(0x7F);

"ld" "a" "," "b"
	g_obj_module.add_opcode_void(0x78);
