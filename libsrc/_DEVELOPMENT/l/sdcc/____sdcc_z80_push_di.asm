
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_z80_push_di

EXTERN asm_z80_push_di

defc ____sdcc_z80_push_di = asm_z80_push_di
