// Example parser

"." IDENT
	define_label($2);

IDENT ":"
	define_label($1);

IDENT "equ" EXPR $
	define_const($1, $3);
	
"include" RAW_STR
	include_file($2);

IDENT "macro" LIST(IDENT,",") $
	string body = read_text_up_to("endm");
	add_macro($1, $3, body);

"defb" LIST(EXPR,",") $
	add_bytes($2);

"defw" LIST(EXPR,",") $
	add_words($2);

"defp" LIST(EXPR,",") $
	add_pointers($2);

"defdw" LIST(EXPR,",") $
	add_dwords($2);

"nop" $
	add_opcode_void(0x00);

"jr" EXPR $
	add_opcode_jr(0x18, $4);

"jr" "nz" "," EXPR $
	add_opcode_jr(0x20, $4);

"jr" "z" "," EXPR $
	add_opcode_jr(0x28, $4);

"jr" "nc" "," EXPR $
	add_opcode_jr(0x30, $4);

"jr" "c" "," EXPR $
	add_opcode_jr(0x38, $4);

"ld" "a" "," EXPR $
	add_opcode_n(0x3E, $4);

"ld" "a" "," "(" EXPR ")" $
	add_opcode_nn(0x3A, $4);
