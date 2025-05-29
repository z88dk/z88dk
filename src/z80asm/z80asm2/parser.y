// Parser

IDENT "equ" EXPR
	add_const($1, $3)

"assume" EXPR
	set_assume($2)

IDENT ":"
	add_label($1)

"nop"
	add_opcode_void(0x00);

"jr" EXPR
	add_opcode_jr(0x18, $4);

"jr" "nz" "," EXPR
	add_opcode_jr(0x20, $4);

"jr" "z" "," EXPR
	add_opcode_jr(0x28, $4);

"jr" "nc" "," EXPR
	add_opcode_jr(0x30, $4);

"jr" "c" "," EXPR
	add_opcode_jr(0x38, $4);

"ld" "a" "," EXPR
	add_opcode_n(0x3E, $4);

"ld" "a" "," "(" EXPR ")"
	add_opcode_nn(0x3A, $4);

"ld" "a" "," "a"
	add_opcode_void(0x7F);

"ld" "a" "," "b"
	add_opcode_void(0x78);

