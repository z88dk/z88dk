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
