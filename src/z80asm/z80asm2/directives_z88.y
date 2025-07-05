//-----------------------------------------------------------------------------
// z80asm
// Recognized grammar - z88 architecture
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

"call_oz" CONST_EXPR
    g_obj_module->call_oz($2.const_value);

"call_pkg" CONST_EXPR
    g_obj_module->call_pkg($2.const_value);
