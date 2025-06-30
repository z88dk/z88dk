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

"binary" RAW_STR
    g_obj_module->include_binary($2.token.svalue());

"define" CONST_ASSIGN_LIST
    for (auto& nv_pair : $2.ident_value_list) {
        g_obj_module->add_global_def(nv_pair.name, nv_pair.value);
    }

"defb" BYTE_LIST
    g_obj_module->add_byte_list($2.exprs);

"db" BYTE_LIST
    g_obj_module->add_byte_list($2.exprs);

"defm" BYTE_LIST
    g_obj_module->add_byte_list($2.exprs);

"dm" BYTE_LIST
    g_obj_module->add_byte_list($2.exprs);

"byte" BYTE_LIST
    g_obj_module->add_byte_list($2.exprs);

"defw" EXPR_LIST
    g_obj_module->add_word_list($2.exprs);

"dw" EXPR_LIST
    g_obj_module->add_word_list($2.exprs);

"word" EXPR_LIST
    g_obj_module->add_word_list($2.exprs);

"defdb" EXPR_LIST
    g_obj_module->add_word_be_list($2.exprs);

"ddb" EXPR_LIST
    g_obj_module->add_word_be_list($2.exprs);

"defp" EXPR_LIST
    g_obj_module->add_ptr_list($2.exprs);

"dp" EXPR_LIST
    g_obj_module->add_ptr_list($2.exprs);

"ptr" EXPR_LIST
    g_obj_module->add_ptr_list($2.exprs);

"defq" EXPR_LIST
    g_obj_module->add_dword_list($2.exprs);

"dq" EXPR_LIST
    g_obj_module->add_dword_list($2.exprs);

"dword" EXPR_LIST
    g_obj_module->add_dword_list($2.exprs);

"defc" ASSIGN_LIST
    for (auto& ne_pair : $2.ident_expr_list) {
		g_obj_module->add_equ(ne_pair.name, ne_pair.expr);
	}

"dc" ASSIGN_LIST
    for (auto& ne_pair : $2.ident_expr_list) {
		g_obj_module->add_equ(ne_pair.name, ne_pair.expr);
	}

"extern" IDENT_LIST
    for (auto& ident : $2.ident_list) {
        g_obj_module->declare_extern(ident);
    }

"global" IDENT_LIST
    for (auto& ident : $2.ident_list) {
        g_obj_module->declare_global(ident);
    }

"incbin" RAW_STR
    g_obj_module->include_binary($2.token.svalue());

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
	g_obj_module->add_equ($1.token.svalue(), $3.expr);
//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar - z80n architecture
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

"cu" "." "wait" CONST_EXPR "," CONST_EXPR
    g_obj_module->cu_wait($4.const_value, $6.const_value);

"cu" "." "move" CONST_EXPR "," CONST_EXPR
    g_obj_module->cu_move($4.const_value, $6.const_value);

"cu" "." "stop"
    g_obj_module->cu_stop();

"cu" "." "nop"
    g_obj_module->cu_nop();
//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar - z88 architecture
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

"call_oz" CONST_EXPR
    g_obj_module->call_oz($2.const_value);

"call_pkg" CONST_EXPR
    g_obj_module->call_pkg($2.const_value);
//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar - CPU opcodes
// Copyright (C) Paulo Custodio, 2011-2024
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

