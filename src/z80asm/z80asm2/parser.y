// Parser

IDENT "equ" EXPR
	g_object_module.add_constant($1.get_svalue(), $3.get_ivalue());

"assume" EXPR
	g_object_module.set_assume($2.get_ivalue());

IDENT ":"
	g_object_module.add_label($1.get_svalue());

"nop"
	g_object_module.add_opcode_void(0x00);

"jr" EXPR
	g_object_module.add_opcode_jr(0x18, $4.get_ivalue());

"jr" "nz" "," EXPR
	g_object_module.add_opcode_jr(0x20, $4.get_ivalue());

"jr" "z" "," EXPR
	g_object_module.add_opcode_jr(0x28, $4.get_ivalue());

"jr" "nc" "," EXPR
	g_object_module.add_opcode_jr(0x30, $4.get_ivalue());

"jr" "c" "," EXPR
	g_object_module.add_opcode_jr(0x38, $4.get_ivalue());

"ld" "a" "," EXPR
	g_object_module.add_opcode_n(0x3E, $4.get_ivalue());

"ld" "a" "," "(" EXPR ")"
	g_object_module.add_opcode_nn(0x3A, $4.get_ivalue());

"ld" "a" "," "a"
	g_object_module.add_opcode_void(0x7F);

"ld" "a" "," "b"
	g_object_module.add_opcode_void(0x78);
